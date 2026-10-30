# Kardia Notification Sending Architecture
Author:	Greg Beeley
Date:	08-Jun-2026

## Overview
This document describes the operation and interfaces of the Kardia asynchronous notifications queueing and sending system.

## Concepts
1.	Notification - A single piece of information describing an update or change that happens within the Kardia system, and which was subscribed to by a particular person wanting to receive that information.  An example might be Joe Donor giving a $100 gift to the organization's general fund on a particular date, where someone in Kardia subscribed to that kind of notification.

2.	Notification Type - An entire category of notifications, typically originating from a particular part of the Kardia system.  An example might be gift notifications.

3.	Notification Method - A general way that a notification could be sent to someone.  An example might be an SMS message or an Email message.

4.	Notification Recipient - A person who desires to receive notifications.

5.	Contact Method - A particular email address, phone number, etc., that the recipient desires to use for a particular notification method.

6.	Notification Preference - A notification type that a notification recipient desires to receive via a given notification method at a particular contact method, possibly at a maximum frequency, and possibly paused for a period of time.

7.	Notification Queue - A list of unsent, in-progress, or recently sent, notifications.

8.	Sending Group - A subset of notifications in the queue being prepared to be sent in a specific batch.  When notifications are in a sending group, they are "spoken for" by a sending process, and the sending process takes responsibility for monitoring the sending process and then updating the various notification status values, until the notifications are sent, failed, and/or released out of the sending group back to the notification queue.

9.	Sending Group Key - A unique code representing a Sending Group.

## Workflow
1.	Subscription and Unsubscription - notification recipients can update their notification preferences at any point, affecting all notifications generated after the point of update.

2.	Generation - events happen in Kardia that generate new notifications, based on notification preferences.

3.	Updates - if events happen that affect a notification before it begins processing, the notification can optionally be updated instead of a new notification being created.

4.	Sending Group Creation - a notification sending process selects notifications from the queue to become a part of a Sending Group, which results in a new Sending Group Key being created and the status on the selected notifications being changed to (P)rocessing.

5.	Contact Update - all denormalized/historical contact data in the notification queue for notifications in the sending group are updated to the latest information from the notification preferences and Kardia partner / contact tables.  If the recipient is no longer subscribed at this point (no preference record, or disabled preference record, or paused preference record with discarding turned on, or no valid contact method), the notification is deleted.

6.	Document Generation - if needed, the text strings or messages are actually generated which will be sent.  This could be simple messages for SMS (for example), or entire HTML reports for email.

7.	Send, Fail, or Release - all notifications in the sending group are either successfully sent, hard-failed to be sent, or are temporarily unable to be sent and are released out of the sending group back into a non-processing status in the notification queue.  Some notification methods may involve an inherent queueing mechanism, such as an email out queue.  In that case, the notification can stay in a processing state in the sending group.

## Example Process and Testing
1.	Ensure recipients are subscribed to the notifications in question through the **Notifications** tab in Kardia's **Manage Staff** application.  In this case, we'll use the `GIFT` notification type (notification of gifts donated to a fund that the staff member manages).  If this subscription process needs to be automated (as a part of a data conversion), the table to use is `p_notification_pref`, making sure the type and method are present in `p_notification_type` and `p_notification_method`.  In this example we'll use a method with ID #1, label "Email", description "Email Message", allowed contact types "E", and no ack expected.  For the GIFT notification type, the data labels (1, 2, and 3) are Amount, Fund, and Comment, respectively.

2.	Generate some actual notifications.  In this case, enter a gift batch with gifts to a fund that the staff member is already a manager of (in the **Funds Managed** tab of Kardia's **Manage Staff** application).  Then post the batch, which is what generates the entries for the notifications queue.

3.	Verify the content of the notifications queue during the testing process.  Open up Kardia's **Notifications Queue** application and review the generated notifications.

4.	Have a system for sending the notifications via email developed.  How this system should work is described below.

## Example Sending Process
1.	Create a report that can be used for generating the notification email content.  An example that can be used is the `gift_notifications.rpt` report in the receipting module.  However, this report generates all of the notification items in one document, not separate documents.  The report should generate an email containing multiple notifications (from `p_notification`) for a single recipient, and the report should be designed to be run as a group of reports to cover all of the recipients in a single sending group (see discussion above in **Workflow**).  This report can then, where needed, join together data from the `p_notification` table with data from other tables (such as partner/contact/location data, additional giving information context and analytics, and so forth), to give the final formatted result.

2.	Create a sending process interface, either automated in the background or through the UI, which implements this process.  This sending UI can be loosely based on Kardia's **Send Statements and Reports** application.

3.	Create an email-sending object that uses the SMTP driver.  These objects are structure files that use a `.smtp` extension.  This object will be used for actually sending the reports.  Note that the SMTP driver does not actually currently use the SMTP protocol directly, but instead submits emails to the local server's MTA (usually Postfix).  Direct SMTP sending may be added in the future.

4.	Sending Group.  The sending process should create a Sending Group, via the **Initiate** endpoint in the **notify** API endpoint group, or via the `sending_group_create.qy` method in the `base` module.  The sending group creation generates a hex string which is specific to a particular sending method (Email in this case) and type (GIFT in this case), and serves as a "lock" to ensure no other sending process works with the notification queue items in the sending group.  The sending group creation process also automatically updates the contact information in the notifications to the latest that is configured in Kardia for each recipient.

5.	Report Generation.  The sending process should loop through the recipients in the sending group, and for each recipient generate a report and copy its output to a new email object (within the `.smtp` object created previously).  This can be done in a single SQL `INSERT ... SELECT` statement, setting `objcontent` and some attributes on the created (INSERTed) email objects.  The query will need to join together the sending group list (from `p_notification` or the SendingGroups/Queue endpoint) with the report itself, with the report pathname being passed parameters (an `EXPRESSION` type `FROM` source) to tell the report what sending group and recipient to use.  Note that the email sending driver allows for a general purpose tag to be set on the email message objects, allowing future correlation between emails and the notifications queue, since it is technically possible for two recipients to have the same email address - thus ruling out email address being used as the primary correlation key.  A recommended email tag would be the sending group key combined with the recipient partner key.

6.	Monitoring Sending Results.  The process should then, as the user requests it, monitor the email sending results to provide an indication to the user of how many of the emails have been successfully sent, how many have failed, how many are in-process, and how many are temporarily deferred.  It should do this by updating the `p_notification` table entries for each of the emails, in this case based on status information for the email objects.  Updating the notifications queue will allow for the user to view the results in the UI via reading the `p_notifications` table or appropriate API endpoint.  The entire sending group can be marked as sent or canceled via the appropriate API endpoints or via the `sending_group_marksent.qy` and `sending_group_cancel.qy` methods, but individual notifications can also be updated where an exception to the overall status is needed (if the whole group succeeds except for one or two emails for example).  Sending processes may find it simpler to just update every notification item individually.  Note that since multiple notifications can be sent in one email to one recipient, the status of one email will end up resulting in an update of multiple notification queue items.
