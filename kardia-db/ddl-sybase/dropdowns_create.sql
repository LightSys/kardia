use Kardia_DB
go


print 'adding table _p_record_status'
create table _p_record_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_record_status add constraint pk__p_record_status primary key clustered (tag)
go
insert _p_record_status values('A','Active','','')
go
insert _p_record_status values('Q','Active/QA','','')
go
insert _p_record_status values('U','Unknown','','')
go
insert _p_record_status values('X','Unknown','','')
go
insert _p_record_status values('M','Merged','Two records have been merged.  This is no longer used.','')
go
insert _p_record_status values('O','Obsolete','','')
go

print 'adding table _p_contact_type'
create table _p_contact_type (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_contact_type add constraint pk__p_contact_type primary key clustered (tag)
go
insert _p_contact_type values('E','Email','','')
go
insert _p_contact_type values('F','Fax','','')
go
insert _p_contact_type values('C','Cell','','')
go
insert _p_contact_type values('P','Phone','','')
go
insert _p_contact_type values('W','Web','Webpage','')
go
insert _p_contact_type values('B','Blog','Blog URL','')
go
insert _p_contact_type values('S','Skype','','')
go
insert _p_contact_type values('K','Facebook','','')
go
insert _p_contact_type values('T','Twitter','','')
go

print 'adding table _p_location_type'
create table _p_location_type (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_location_type add constraint pk__p_location_type primary key clustered (tag)
go
insert _p_location_type values('H','Home','','')
go
insert _p_location_type values('W','Work','','')
go
insert _p_location_type values('V','Vacation','','')
go
insert _p_location_type values('S','School','','')
go

print 'adding table _p_partner_class'
create table _p_partner_class (
  tag	char(3) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_partner_class add constraint pk__p_partner_class primary key clustered (tag)
go
insert _p_partner_class values('IND','Individual','','')
go
insert _p_partner_class values('OFC','Office (Our Org.)','','')
go
insert _p_partner_class values('HOU','Household','','')
go
insert _p_partner_class values('CHU','Church','','')
go
insert _p_partner_class values('ORG','Organization','','')
go
insert _p_partner_class values('MIS','Mission','','')
go
insert _p_partner_class values('SCH','School','','')
go
insert _p_partner_class values('FOU','Foundation','','')
go
insert _p_partner_class values('BUS','Business','','')
go
insert _p_partner_class values('BUC','Christian Business','','')
go
insert _p_partner_class values('FIE','Field','','')
go
insert _p_partner_class values('CLI','Client','','')
go

print 'adding table _p_partner_gender'
create table _p_partner_gender (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_partner_gender add constraint pk__p_partner_gender primary key clustered (tag)
go
insert _p_partner_gender values('M','Male','','')
go
insert _p_partner_gender values('F','Female','','')
go
insert _p_partner_gender values('C','Couple','','')
go
insert _p_partner_gender values('O','Other','Organization, etc','')
go

print 'adding table _p_postal_status'
create table _p_postal_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_postal_status add constraint pk__p_postal_status primary key clustered (tag)
go
insert _p_postal_status values('K','Addressee Unknown','','')
go
insert _p_postal_status values('F','Forwarding Expired','','')
go
insert _p_postal_status values('N','No # or address','','')
go
insert _p_postal_status values('U','Undeliverable','','')
go
insert _p_postal_status values('X','Other','','')
go
insert _p_postal_status values('C','Certified','','')
go

print 'adding table _p_nomail_reason'
create table _p_nomail_reason (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_nomail_reason add constraint pk__p_nomail_reason primary key clustered (tag)
go
insert _p_nomail_reason values('U','Undeliverable','','')
go
insert _p_nomail_reason values('O','Office Request','','')
go
insert _p_nomail_reason values('P','Personal Request','','')
go
insert _p_nomail_reason values('M','Field Worker Request','','')
go
insert _p_nomail_reason values('D','Deceased','','')
go
insert _p_nomail_reason values('T','Temporarily Away','','')
go
insert _p_nomail_reason values('I','Inactive Donor','','')
go
insert _p_nomail_reason values('X','Other','','')
go

print 'adding table _p_relation_type'
create table _p_relation_type (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_relation_type add constraint pk__p_relation_type primary key clustered (tag)
go
insert _p_relation_type values('S','Sibling','','')
go
insert _p_relation_type values('P','Parent','','')
go
insert _p_relation_type values('F','Friend','','')
go
insert _p_relation_type values('M','Member','','')
go

print 'adding table _p_status_code'
create table _p_status_code (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_status_code add constraint pk__p_status_code primary key clustered (tag)
go
insert _p_status_code values('A','Active','','')
go
insert _p_status_code values('X','Removed','','')
go
insert _p_status_code values('D','Deceased','','')
go
insert _p_status_code values('O','Obsolete','','')
go

print 'adding table _p_marital_status'
create table _p_marital_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_marital_status add constraint pk__p_marital_status primary key clustered (tag)
go
insert _p_marital_status values('M','Married','','')
go
insert _p_marital_status values('S','Single','','')
go
insert _p_marital_status values('U','Unknown','','')
go
insert _p_marital_status values('O','Other','(organization','')
go

print 'adding table _p_bulk_postal_code'
create table _p_bulk_postal_code (
  tag	char(4) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_bulk_postal_code add constraint pk__p_bulk_postal_code primary key clustered (tag)
go
insert _p_bulk_postal_code values('L801','AADC letter size','AADC Standard Mail Bulk - letter size','')
go
insert _p_bulk_postal_code values('L009','Mixed ADCs','Periodicals-Standard Mail-Package Services Flats-Irregular Parcels','')
go

print 'adding table _a_account_type'
create table _a_account_type (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _a_account_type add constraint pk__a_account_type primary key clustered (tag)
go
insert _a_account_type values('A','Asset','','')
go
insert _a_account_type values('L','Liability','','')
go
insert _a_account_type values('Q','Equity','','')
go
insert _a_account_type values('R','Revenue','','')
go
insert _a_account_type values('E','Expense','','')
go

print 'adding table _a_period_status'
create table _a_period_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _a_period_status add constraint pk__a_period_status primary key clustered (tag)
go
insert _a_period_status values('N','Never Opened','','')
go
insert _a_period_status values('O','Open','','')
go
insert _a_period_status values('C','Closed','','')
go
insert _a_period_status values('A','Archived','','')
go

print 'adding table _a_gift_type'
create table _a_gift_type (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _a_gift_type add constraint pk__a_gift_type primary key clustered (tag)
go
insert _a_gift_type values('C','Cash','','')
go
insert _a_gift_type values('K','Check','','')
go
insert _a_gift_type values('D','Credit Card','','')
go
insert _a_gift_type values('E','EFT','','')
go

print 'adding table _a_payroll_interval'
create table _a_payroll_interval (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _a_payroll_interval add constraint pk__a_payroll_interval primary key clustered (tag)
go
insert _a_payroll_interval values('0','Misc','','')
go
insert _a_payroll_interval values('1','Daily','','')
go
insert _a_payroll_interval values('2','Weekly','','')
go
insert _a_payroll_interval values('3','Biweekly','','')
go
insert _a_payroll_interval values('4','Semimonthly','','')
go
insert _a_payroll_interval values('5','Monthly','','')
go
insert _a_payroll_interval values('6','ALL','','')
go

print 'adding table _a_restricted_type'
create table _a_restricted_type (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _a_restricted_type add constraint pk__a_restricted_type primary key clustered (tag)
go
insert _a_restricted_type values('N','Not Restricted','','')
go
insert _a_restricted_type values('T','Temporarily Restricted','','')
go
insert _a_restricted_type values('P','Permanently Restricted','','')
go

print 'adding table _a_alphabet'
create table _a_alphabet (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _a_alphabet add constraint pk__a_alphabet primary key clustered (tag)
go
insert _a_alphabet values('A','','','')
go
insert _a_alphabet values('B','','','')
go
insert _a_alphabet values('C','','','')
go
insert _a_alphabet values('D','','','')
go
insert _a_alphabet values('E','','','')
go
insert _a_alphabet values('F','','','')
go
insert _a_alphabet values('G','','','')
go
insert _a_alphabet values('H','','','')
go
insert _a_alphabet values('I','','','')
go
insert _a_alphabet values('J','','','')
go
insert _a_alphabet values('K','','','')
go
insert _a_alphabet values('L','','','')
go
insert _a_alphabet values('M','','','')
go
insert _a_alphabet values('N','','','')
go
insert _a_alphabet values('O','','','')
go
insert _a_alphabet values('P','','','')
go
insert _a_alphabet values('Q','','','')
go
insert _a_alphabet values('R','','','')
go
insert _a_alphabet values('S','','','')
go
insert _a_alphabet values('T','','','')
go
insert _a_alphabet values('U','','','')
go
insert _a_alphabet values('V','','','')
go
insert _a_alphabet values('W','','','')
go
insert _a_alphabet values('X','','','')
go
insert _a_alphabet values('Y','','','')
go
insert _a_alphabet values('Z','','','')
go

print 'adding table _s_process'
create table _s_process (
  tag	char(2) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _s_process add constraint pk__s_process primary key clustered (tag)
go
insert _s_process values('A1','Create Balancing Entries','','')
go
insert _s_process values('A2','Verify Journal Balance','','')
go
insert _s_process values('A3','Verify Cost Ctr Balance','','')
go
insert _s_process values('A4','Verify Acct 1900 Balance','','')
go
insert _s_process values('A5','Post Batch','','')
go
insert _s_process values('P1','Select Payroll Period','','')
go
insert _s_process values('P2','Create/Edit Period','','')
go
insert _s_process values('P3','Review Payroll Data','','')
go
insert _s_process values('P4','Post Payroll','','')
go
insert _s_process values('P5','Create Paychecks','','')
go

print 'adding table _a_receipt_type'
create table _a_receipt_type (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _a_receipt_type add constraint pk__a_receipt_type primary key clustered (tag)
go
insert _a_receipt_type values('I','Immediate','','')
go
insert _a_receipt_type values('A','Annual','','')
go
insert _a_receipt_type values('N','None','','')
go

print 'adding table _m_membership_status'
create table _m_membership_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _m_membership_status add constraint pk__m_membership_status primary key clustered (tag)
go
insert _m_membership_status values('P','Pending','','')
go
insert _m_membership_status values('A','Active','','')
go
insert _m_membership_status values('E','Expired','','')
go
insert _m_membership_status values('D','Deleted','','')
go
insert _m_membership_status values('C','Canceled','','')
go

print 'adding table _m_member_type'
create table _m_member_type (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _m_member_type add constraint pk__m_member_type primary key clustered (tag)
go
insert _m_member_type values('M','Member','','')
go
insert _m_member_type values('O','Owner','','')
go

print 'adding table _p_postal_mode'
create table _p_postal_mode (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_postal_mode add constraint pk__p_postal_mode primary key clustered (tag)
go
insert _p_postal_mode values('B','Bulk','','')
go
insert _p_postal_mode values('F','First Class','','')
go

print 'adding table _m_list_status'
create table _m_list_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _m_list_status add constraint pk__m_list_status primary key clustered (tag)
go
insert _m_list_status values('A','Active','','')
go
insert _m_list_status values('O','Obsolete','','')
go

print 'adding table _m_list_type'
create table _m_list_type (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _m_list_type add constraint pk__m_list_type primary key clustered (tag)
go
insert _m_list_type values('P','Publication','','')
go
insert _m_list_type values('I','Issue','','')
go
insert _m_list_type values('S','Selection','','')
go

print 'adding table _a_motivational_code_status'
create table _a_motivational_code_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _a_motivational_code_status add constraint pk__a_motivational_code_status primary key clustered (tag)
go
insert _a_motivational_code_status values('A','Active','','')
go
insert _a_motivational_code_status values('O','Obsolete','','')
go

print 'adding table _m_member_reason'
create table _m_member_reason (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _m_member_reason add constraint pk__m_member_reason primary key clustered (tag)
go
insert _m_member_reason values('R','Person Requested','','')
go
insert _m_member_reason values('M','Requested by Field Worker','','')
go
insert _m_member_reason values('O','Added by Office','','')
go
insert _m_member_reason values('D','Gave Donation','','')
go
insert _m_member_reason values('C','Motivation Code','','')
go
insert _m_member_reason values('X','Other','','')
go

print 'adding table _m_cancel_reason'
create table _m_cancel_reason (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _m_cancel_reason add constraint pk__m_cancel_reason primary key clustered (tag)
go
insert _m_cancel_reason values('G','No Longer a Donor','','')
go
insert _m_cancel_reason values('I','Not Interested','','')
go
insert _m_cancel_reason values('S','Did Not Intend to Subscribe','','')
go
insert _m_cancel_reason values('O','Offended','','')
go
insert _m_cancel_reason values('1','One-Time Interest Only','','')
go
insert _m_cancel_reason values('L','Too Much Mail (from this subscription)','','')
go
insert _m_cancel_reason values('Q','Too Much Mail (from our ministry)','','')
go
insert _m_cancel_reason values('N','Too Much Mail (in general)','','')
go
insert _m_cancel_reason values('U','Cannot Afford the Subscription','','')
go
insert _m_cancel_reason values('X','Other','','')
go

print 'adding table _m_delivery_method'
create table _m_delivery_method (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _m_delivery_method add constraint pk__m_delivery_method primary key clustered (tag)
go
insert _m_delivery_method values('M','Postal Mail','','')
go
insert _m_delivery_method values('E','Email','','')
go

print 'adding table _p_addr_field'
create table _p_addr_field (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _p_addr_field add constraint pk__p_addr_field primary key clustered (tag)
go
insert _p_addr_field values('A','p_in_care_of','','')
go
insert _p_addr_field values('B','p_address_1','','')
go
insert _p_addr_field values('C','p_address_2','','')
go
insert _p_addr_field values('D','p_address_3','','')
go
insert _p_addr_field values('E','p_city','','')
go
insert _p_addr_field values('F','p_state_province','','')
go
insert _p_addr_field values('G','p_postal_code','','')
go
insert _p_addr_field values('H','p_country_code','','')
go
insert _p_addr_field values('I','p_country_name','','')
go
insert _p_addr_field values('J','p_bulk_postal_code','','')
go

print 'adding table _r_delivery_method'
create table _r_delivery_method (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _r_delivery_method add constraint pk__r_delivery_method primary key clustered (tag)
go
insert _r_delivery_method values('E','Email','','')
go
insert _r_delivery_method values('W','Web','','')
go
insert _r_delivery_method values('P','Print','','')
go

print 'adding table _e_track_status'
create table _e_track_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _e_track_status add constraint pk__e_track_status primary key clustered (tag)
go
insert _e_track_status values('A','Active','','')
go
insert _e_track_status values('O','Obsolete','','')
go

print 'adding table _e_req_whom'
create table _e_req_whom (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _e_req_whom add constraint pk__e_req_whom primary key clustered (tag)
go
insert _e_req_whom values('P','Partner','','')
go
insert _e_req_whom values('O','Organization','','')
go
insert _e_req_whom values('E','Either','','')
go

print 'adding table _e_completion_status'
create table _e_completion_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _e_completion_status add constraint pk__e_completion_status primary key clustered (tag)
go
insert _e_completion_status values('C','Complete','','')
go
insert _e_completion_status values('I','Incomplete','','')
go
insert _e_completion_status values('E','Exited','','')
go

print 'adding table _e_req_completion_status'
create table _e_req_completion_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _e_req_completion_status add constraint pk__e_req_completion_status primary key clustered (tag)
go
insert _e_req_completion_status values('C','Complete','','')
go
insert _e_req_completion_status values('I','Incomplete','','')
go
insert _e_req_completion_status values('W','Waived','','')
go

print 'adding table _e_tag_volatility'
create table _e_tag_volatility (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _e_tag_volatility add constraint pk__e_tag_volatility primary key clustered (tag)
go
insert _e_tag_volatility values('P','Persistent','','')
go
insert _e_tag_volatility values('D','Derived','','')
go
insert _e_tag_volatility values('I','Implied','','')
go

print 'adding table _e_workflow_step_trigger_type'
create table _e_workflow_step_trigger_type (
  tag	char(4) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _e_workflow_step_trigger_type add constraint pk__e_workflow_step_trigger_type primary key clustered (tag)
go
insert _e_workflow_step_trigger_type values('STEP','Step Completion','','')
go
insert _e_workflow_step_trigger_type values('DOC','Document Upload','','')
go
insert _e_workflow_step_trigger_type values('DOCP','Document Associated','','')
go

print 'adding table _a_flag_type'
create table _a_flag_type (
  tag	char(3) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _a_flag_type add constraint pk__a_flag_type primary key clustered (tag)
go
insert _a_flag_type values('CNT','Is This Supporter Continuing?','','')
go
insert _a_flag_type values('GIV','Is This Supporter Going To Give?','','')
go
insert _a_flag_type values('INC','Is This Supporter Increasing?','','')
go
insert _a_flag_type values('DEC','Is This Supporter Decreasing?','','')
go
insert _a_flag_type values('IVL','What Is The Giving Interval?','','')
go
insert _a_flag_type values('AMT','Is The Support Amount Changing?','','')
go

print 'adding table _a_flag_resolution'
create table _a_flag_resolution (
  tag	char(3) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _a_flag_resolution add constraint pk__a_flag_resolution primary key clustered (tag)
go
insert _a_flag_resolution values('UPD','Support Updated','','')
go
insert _a_flag_resolution values('OLD','No Longer Giving','','')
go
insert _a_flag_resolution values('NOC','No Changes This Time','','')
go

print 'adding table _h_benefit_mode'
create table _h_benefit_mode (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _h_benefit_mode add constraint pk__h_benefit_mode primary key clustered (tag)
go
insert _h_benefit_mode values('L','Limited to Amount Accrued','','')
go
insert _h_benefit_mode values('P','Policy-driven but Not Controlled By System','','')
go

print 'adding table _e_collaborator_status'
create table _e_collaborator_status (
  tag	char(1) not null,
  text	varchar(60) not null,
  description varchar(255) null,
  __cx_osml_control varchar(255) null)
go
alter table _e_collaborator_status add constraint pk__e_collaborator_status primary key clustered (tag)
go
insert _e_collaborator_status values('P','Priority','','')
go
insert _e_collaborator_status values('A','Active','','')
go
insert _e_collaborator_status values('I','Inactive','','')
go
