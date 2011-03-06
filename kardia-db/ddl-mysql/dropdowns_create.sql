use Kardia_DB;

create table _p_record_status (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_record_status add constraint pk__p_record_status primary key  (tag);
insert _p_record_status values('A','Active','','');
insert _p_record_status values('U','Unknown','','');
insert _p_record_status values('X','Unknown','','');
insert _p_record_status values('M','Merged','Two records have been merged.  This is no longer used.','');
insert _p_record_status values('O','Obsolete','','');
create table _p_contact_type (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_contact_type add constraint pk__p_contact_type primary key  (tag);
insert _p_contact_type values('E','Email','','');
insert _p_contact_type values('F','Fax','','');
insert _p_contact_type values('C','Cell','','');
insert _p_contact_type values('P','Phone','','');
insert _p_contact_type values('W','Web','Webpage','');
insert _p_contact_type values('B','Blog','Blog url','');
insert _p_contact_type values('S','Skype','','');
create table _p_location_type (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_location_type add constraint pk__p_location_type primary key  (tag);
insert _p_location_type values('H','Home','','');
insert _p_location_type values('W','Work','','');
insert _p_location_type values('V','Vacation','','');
insert _p_location_type values('S','School','','');
create table _p_partner_class (
  tag	char(3) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_partner_class add constraint pk__p_partner_class primary key  (tag);
insert _p_partner_class values('IND','Individual','','');
insert _p_partner_class values('CHU','Church','','');
insert _p_partner_class values('ORG','Organization','','');
insert _p_partner_class values('MIS','Mission','','');
insert _p_partner_class values('SCH','School','','');
insert _p_partner_class values('FOU','Foundation','','');
insert _p_partner_class values('BUS','Business','','');
insert _p_partner_class values('BUC','Christian Business','','');
insert _p_partner_class values('FIE','Field','','');
insert _p_partner_class values('CLI','Client','','');
create table _p_partner_gender (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_partner_gender add constraint pk__p_partner_gender primary key  (tag);
insert _p_partner_gender values('M','Male','','');
insert _p_partner_gender values('F','Female','','');
insert _p_partner_gender values('C','Couple','','');
insert _p_partner_gender values('O','Other','Organization, etc','');
create table _p_postal_status (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_postal_status add constraint pk__p_postal_status primary key  (tag);
insert _p_postal_status values('K','Addressee Unknown','','');
insert _p_postal_status values('F','Forwarding Expired','','');
insert _p_postal_status values('N','No # or address','','');
insert _p_postal_status values('U','Undeliverable','','');
insert _p_postal_status values('X','Other','','');
insert _p_postal_status values('C','C','','');
create table _p_relation_type (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_relation_type add constraint pk__p_relation_type primary key  (tag);
insert _p_relation_type values('S','Sibling','','');
insert _p_relation_type values('P','Parent','','');
insert _p_relation_type values('F','Friend','','');
insert _p_relation_type values('M','Member','','');
insert _p_relation_type values('S','Staff','','');
create table _p_status_code (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_status_code add constraint pk__p_status_code primary key  (tag);
insert _p_status_code values('A','Active','','');
insert _p_status_code values('X','Removed','','');
insert _p_status_code values('D','Deceased','','');
insert _p_status_code values('O','Obsolete','','');
create table _p_marital_status (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_marital_status add constraint pk__p_marital_status primary key  (tag);
insert _p_marital_status values('M','Married','','');
insert _p_marital_status values('S','Single','','');
insert _p_marital_status values('U','Unknown','','');
insert _p_marital_status values('O','Other','(organization','');
create table _p_bulk_postal_code (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_bulk_postal_code add constraint pk__p_bulk_postal_code primary key  (tag);
insert _p_bulk_postal_code values('L801','AADC letter size','AADC Standard Mail Bulk - letter size','');
insert _p_bulk_postal_code values('L009','Mixed ADCs','Periodicals-Standard Mail-Package Services Flats-Irregular Parcels','');
create table _a_account_type (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _a_account_type add constraint pk__a_account_type primary key  (tag);
insert _a_account_type values('A','Asset','','');
insert _a_account_type values('L','Liability','','');
insert _a_account_type values('Q','Equity','','');
insert _a_account_type values('R','Revenue','','');
insert _a_account_type values('E','Expense','','');
create table _a_period_status (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _a_period_status add constraint pk__a_period_status primary key  (tag);
insert _a_period_status values('N','Never Opened','','');
insert _a_period_status values('O','Open','','');
insert _a_period_status values('C','Closed','','');
insert _a_period_status values('A','Archived','','');
create table _a_gift_type (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _a_gift_type add constraint pk__a_gift_type primary key  (tag);
insert _a_gift_type values('C','Cash','','');
insert _a_gift_type values('K','Check','','');
insert _a_gift_type values('D','Credit Card','','');
insert _a_gift_type values('E','EFT','','');
create table _a_payroll_interval (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _a_payroll_interval add constraint pk__a_payroll_interval primary key  (tag);
insert _a_payroll_interval values('0','Misc','','');
insert _a_payroll_interval values('1','Daily','','');
insert _a_payroll_interval values('2','Weekly','','');
insert _a_payroll_interval values('3','Biweekly','','');
insert _a_payroll_interval values('4','Semimonthly','','');
insert _a_payroll_interval values('5','Monthly','','');
insert _a_payroll_interval values('6','ALL','','');
create table _a_restricted_type (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _a_restricted_type add constraint pk__a_restricted_type primary key  (tag);
insert _a_restricted_type values('N','Not Restricted','','');
insert _a_restricted_type values('T','Temporarily Restricted','','');
insert _a_restricted_type values('P','Permanently Restricted','','');
create table _a_alphabet (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _a_alphabet add constraint pk__a_alphabet primary key  (tag);
insert _a_alphabet values('A','','','');
insert _a_alphabet values('B','','','');
insert _a_alphabet values('C','','','');
insert _a_alphabet values('D','','','');
insert _a_alphabet values('E','','','');
insert _a_alphabet values('F','','','');
insert _a_alphabet values('G','','','');
insert _a_alphabet values('H','','','');
insert _a_alphabet values('I','','','');
insert _a_alphabet values('J','','','');
insert _a_alphabet values('K','','','');
insert _a_alphabet values('L','','','');
insert _a_alphabet values('M','','','');
insert _a_alphabet values('N','','','');
insert _a_alphabet values('O','','','');
insert _a_alphabet values('P','','','');
insert _a_alphabet values('Q','','','');
insert _a_alphabet values('R','','','');
insert _a_alphabet values('S','','','');
insert _a_alphabet values('T','','','');
insert _a_alphabet values('U','','','');
insert _a_alphabet values('V','','','');
insert _a_alphabet values('W','','','');
insert _a_alphabet values('X','','','');
insert _a_alphabet values('Y','','','');
insert _a_alphabet values('Z','','','');
create table _s_process (
  tag	char(2) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _s_process add constraint pk__s_process primary key  (tag);
insert _s_process values('A1','Create Balancing Entries','','');
insert _s_process values('A2','Verify Journal Balance','','');
insert _s_process values('A3','Verify Cost Ctr Balance','','');
insert _s_process values('A4','Verify Acct 1900 Balance','','');
insert _s_process values('A5','Post Batch','','');
insert _s_process values('P1','Select Payroll Period','','');
insert _s_process values('P2','Create Monthly Data','','');
insert _s_process values('P3','Review Payroll Data','','');
insert _s_process values('P4','Create GL Batch','','');
create table _a_receipt_type (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _a_receipt_type add constraint pk__a_receipt_type primary key  (tag);
insert _a_receipt_type values('I','Immediate','','');
insert _a_receipt_type values('A','Annual','','');
insert _a_receipt_type values('N','None','','');
create table _m_membership_status (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _m_membership_status add constraint pk__m_membership_status primary key  (tag);
insert _m_membership_status values('A','Active','','');
insert _m_membership_status values('E','Expired','','');
insert _m_membership_status values('D','Deleted','','');
insert _m_membership_status values('C','Canceled','','');
create table _m_member_type (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _m_member_type add constraint pk__m_member_type primary key  (tag);
insert _m_member_type values('M','Member','','');
insert _m_member_type values('O','Owner','','');
create table _p_postal_mode (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _p_postal_mode add constraint pk__p_postal_mode primary key  (tag);
insert _p_postal_mode values('B','Bulk','','');
insert _p_postal_mode values('F','First Class','','');
create table _m_list_status (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _m_list_status add constraint pk__m_list_status primary key  (tag);
insert _m_list_status values('A','Active','','');
insert _m_list_status values('O','Obsolete','','');
create table _m_list_type (
  tag	char(1) not null,
  text	varchar(30) not null,
  description varchar(255) null,__cx_osml_control varchar(255) null);
alter table _m_list_type add constraint pk__m_list_type primary key  (tag);
insert _m_list_type values('P','Publication','','');
insert _m_list_type values('I','Issue','','');
insert _m_list_type values('S','Selection','','');
