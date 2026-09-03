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
