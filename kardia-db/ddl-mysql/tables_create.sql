
use Kardia_DB;
/* Table for Centrallix annotations */
create table ra(
	a varchar(32),
	b text,
	c text,
	PRIMARY KEY (a)
	);

insert ra values('a_account','GL Accounts',':a_acct_desc');

insert ra values('a_account_category','Control Categories',':a_acct_cat_desc');

insert ra values('a_batch','Batches',':a_batch_desc');

insert ra values('a_fund','Funds',':a_fund_desc');

insert ra values('a_fund_prefix','Fund Prefixes',':a_fund_prefix_desc');

insert ra values('a_period','Periods',':a_period_desc');

insert ra values('m_list','Mailing Lists',':m_list_description');

insert ra values('p_partner','Partners',':p_surname + ", " + :p_given_name');



/* p_partner */

create table p_partner (
        p_partner_key                         char(10)  not null,      /*  --  */
        p_creating_office                     char(10)  not null,      /* partner key of creating office --  */
        p_parent_key                          char(10)  null,          /* for partner hierarchies of various sorts --  */
        p_partner_class                       char(3)  not null,       /*  --  */
        p_status_code                         char(1)  not null,       /* D=Deceased A=Active X=Removed by Constituent O=Obsolete for unknown reason --  */
        p_status_change_date                  datetime  null,          /*  --  */
        p_title                               varchar(64)  null,       /* Mr. & Mrs. --  */
        p_given_name                          varchar(64)  null,       /* Jonathan and Jane --  */
        p_preferred_name                      varchar(64)  null,       /* Jon and Jane --  */
        p_surname                             varchar(64)  null,       /* Doe --  */
        p_surname_first                       bit,                     /* surname comes first, e.g., Korean --  */
        p_localized_name                      varchar(96)  null,       /*  --  */
        p_suffix                              varchar(64)  null,       /* such as "Jr.", "M.D.", "and Family", etc. --  */
        p_org_name                            varchar(64)  null,       /*  --  */
        p_gender                              char(1)  null,           /* M=male, F=female, C=couple --  */
        p_language_code                       char(3)  null,           /*  --  */
        p_acquisition_code                    char(3)  null,           /*  --  */
        p_comments                            varchar(1536)  null,     /*  --  */
        p_record_status_code                  char(1)  not null,       /* A=active, O=obsolete, M=merged --  */
        p_no_mail_reason                      char(1)  null,           /* Reason why p_no_mail is set: (U)ndeliverable, (O)ffice Request, (P)ersonal Request, (M)issionary Request, (D)eceased, (T)emporarily Away, (I)nactive Donor, (X) Other. --  */
        p_no_solicitations                    bit,                     /*  --  */
        p_no_mail                             bit,                     /*  --  */
        a_fund                                varchar(20)  null,       /* The fund code (see a_fund) associated with the partner, if applicable. --  */
        p_best_contact                        char(10)  null,          /*  --  */
        p_merged_with                         char(10)  null,          /* new key id after merge --  */
        p_legacy_key_1                        char(10)  null,          /* old system --  */
        p_legacy_key_2                        char(10)  null,          /* old system --  */
        p_legacy_key_3                        char(10)  null,          /* old system --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_partner_key_cnt */

create table p_partner_key_cnt (
        p_partner_key                         char(10)  not null       /*  --  */

);


/* p_person */

create table p_person (
        p_partner_key                         char(10)  not null,      /*  --  */
        p_previous_surname                    varchar(64)  null,       /*  --  */
        p_date_of_birth                       datetime  null,          /*  --  */
        p_marital_status                      char(1)  not null,       /*  --  */
        p_academic_title                      varchar(48)  null,       /*  --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_location */

create table p_location (
        p_partner_key                         char(10)  not null,      /*  --  */
        p_location_id                         tinyint  not null,       /*  --  */
        p_revision_id                         integer  not null,       /* 0 if current address, or <n> if it is an older revision. --  */
        p_location_type                       char(1)  null,           /* H=home, W=work, S=school, V=vacation --  */
        p_date_effective                      datetime  null,          /*  --  */
        p_date_good_until                     datetime  null,          /*  --  */
        p_purge_date                          datetime  null,          /*  --  */
        p_in_care_of                          varchar(80)  null,       /*  --  */
        p_address_1                           varchar(80)  null,       /*  --  */
        p_address_2                           varchar(80)  null,       /*  --  */
        p_address_3                           varchar(80)  null,       /*  --  */
        p_city                                varchar(64)  null,       /*  --  */
        p_state_province                      varchar(64)  null,       /* Use country-keyed ref tbl 4 state/prov/county --  */
        p_country_code                        char(2)  null,           /* Use ISO codes same as domain names --  */
        p_postal_code                         varchar(12)  null,       /*  --  */
        p_postal_mode                         char(1)  null,           /* B-Bulk F-FirstClass Used to override postal modes on mailings --  */
        p_bulk_postal_code                    varchar(12)  null,       /* USPS - zip center 3 digits --  */
        p_certified_date                      datetime  null,          /* e.g., CASS certification of address --  */
        p_postal_status                       char(1)  null,           /* e.g., ACS status, CASS status -- K=Addressee-UnKnown F=Forwarding-Order-Expired N=No-such-#-or-Address U=Undeliverable-by-P.O. X=Other */
        p_postal_barcode                      varchar(128)  null,      /* Postal barcode sequence for printing mailing labels etc. --  */
        p_record_status_code                  char(1)  not null,       /* A=active, O=obsolete, Q=active but needs QA (e.g., new record) --  */
        p_location_comments                   varchar(1536)  null,     /*  --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_address_format */

create table p_address_format (
        p_address_set                         char(10)  not null,      /* Set of address formats being used --  */
        p_country_code                        char(2)  not null,       /* Country for address format (from p_country table / p_country_code in p_location) --  */
        p_format                              varchar(1024)  not null,
                                                                      /* Format of address, to be evaluated with Centrallix substitute() function. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_address_format_set */

create table p_address_format_set (
        p_address_set                         char(10)  not null,      /* Set of address formats being used --  */
        p_address_set_desc                    char(255)  not null,     /* description of address format set. --  */
        p_is_active                           bit  not null,           /* is the address format set active? --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into p_address_format_set (p_address_set,p_address_set_desc,p_is_active,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "STANDARD" as p_address_set, "Standard Format Set" as p_address_set_desc, 1 as p_is_active, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* p_contact_info */

create table p_contact_info (
        p_partner_key                         char(10)  not null,      /*  --  */
        p_contact_id                          tinyint  not null,       /*  --  */
        p_contact_type                        char(1)  not null,       /* P=phone, F=fax, C=cell, E=email, W=website --  */
        p_location_id                         char(3)  null,           /* Either the ID of the associated location, or a 'location type' (W, H, etc...) --  */
        p_phone_country                       varchar(3)  null,        /*  --  */
        p_phone_area_city                     varchar(4)  null,        /*  --  */
        p_contact_data                        varchar(80)  null,       /*  --  */
        p_record_status_code                  char(1)  not null,       /* A=active, O=obsolete --  */
        p_contact_comments                    varchar(1536)  null,     /*  --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_contact_usage */

create table p_contact_usage (
        p_contact_usage_type_code             varchar(4)  not null,    /* Unique code for this usage type --  */
        p_partner_key                         char(10)  not null,      /* The partner ID that this applies to --  */
        p_contact_location_id                 integer  not null,       /* The contact or location ID this applies to --  */
        p_contact_or_location                 char(1)  not null,       /* C = contact, L = location --  */
        p_start_date                          datetime  null,          /* The first validity date for this usage --  */
        p_end_date                            datetime  null,          /* The last validity date for this usage --  */
        p_daterange_no_year                   bit  not null,           /* If set to 1, ignore the year part of the start-end date range (the range recurs yearly) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_contact_usage_type */

create table p_contact_usage_type (
        p_contact_usage_type_code             varchar(4)  not null,    /* Unique code for this usage type --  */
        p_system_provided                     bit  not null,           /* 1 = this code is provided with the system and cannot be changed or removed --  */
        p_use_for_locations                   bit  not null,           /* 1 = this code can be used for p_location records. --  */
        p_use_for_contacts                    bit  not null,           /* 1 = this code can be used for contact data (phone, email, etc.) --  */
        p_contact_types                       varchar(32)  not null,   /* a list of contact type codes that this code applies to. --  */
        p_contact_usage_label                 varchar(80)  not null,   /* The label/description for this usage code. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_partner_relationship */

create table p_partner_relationship (
        p_partner_key                         char(10)  not null,      /* source of relationship --  */
        p_relation_type                       integer  not null,       /* brother, wife, son, etc. See p_partner_relationship_type. --  */
        p_relation_key                        char(10)  not null,      /* the one the source is related to --  */
        p_relation_comments                   varchar(900)  null,      /*  --  */
        p_relation_start_date                 datetime  null,          /*  --  */
        p_relation_end_date                   datetime  null,          /*  --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_partner_relationship_type */

create table p_partner_relationship_type (
        p_relation_type                       integer  not null,       /* brother, wife, son, etc. See p_partner_relationship_type. --  */
        p_relation_type_label                 varchar(40)  not null,   /*  --  */
        p_relation_type_desc                  varchar(900)  null,      /*  --  */
        p_relation_type_rev_label             varchar(40)  not null,   /* label for relationship applied in reverse --  */
        p_relation_type_rev_desc              varchar(900)  null,      /* description for relationship applied in reverse --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_church */

create table p_church (
        p_partner_key                         char(10)  not null,      /*  --  */
        p_approximate_size                    int  null,               /*  --  */
        p_denomination_code                   char(3)  null,           /*  --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_donor */

create table p_donor (
        p_partner_key                         char(10)  not null,      /* The partner key of this payee --  */
        a_gl_ledger_number                    char(10)  not null,      /* The GL ledger in our system used for tracking the receivable (asset acct) --  */
        a_gl_account_code                     char(16)  null,          /* The GL account in our system used for tracking the receivable (asset acct) --  */
        p_account_with_donor                  varchar(20)  null,       /* The account number with the payer (e.g., if payer is a business and we have an account with them) --  */
        p_allow_contributions                 bit  not null,           /* Whether to permit payments/contributions from this payer --  */
        p_location_id                         integer  null,           /* The location id (address) to use for issuing receipts to this donor --  */
        p_contact_id                          integer  null,           /* The contact info id (email/phone/etc) to use as a "best contact for" this donor --  */
        p_org_name_first                      bit  not null,           /* Whether to list organization name first on receipt address, rather than first/last name. --  */
        p_receipt_desired                     char(1)  null,           /* Indicates the donor's preference for receipts: (N)one, (I)mmediate, (A)nnual --  */
        p_is_daf                              bit  default 0,          /* Whether this donor is a donor advised fund --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_payee */

create table p_payee (
        p_partner_key                         char(10)  not null,      /* The partner key of this payee --  */
        a_gl_ledger_number                    char(10)  not null,      /* The GL ledger in our system used for tracking the payable (liability acct) --  */
        a_gl_account_code                     char(16)  null,          /* The GL account in our system used for tracking the payable (liability acct) --  */
        p_account_with_payee                  varchar(20)  null,       /* The account number with the payee (e.g., if payee is a business and we have an account with them) --  */
        p_allow_payments                      bit  not null,           /* Whether to permit payments to this payee --  */
        p_location_id                         integer  null,           /* The location id (address) to use for issuing payments to this payee --  */
        p_contact_id                          integer  null,           /* The contact info id (email/phone/etc) to use as a "best contact for" this payee --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_staff */

create table p_staff (
        p_partner_key                         char(10)  not null,      /* The partner key of the staff member --  */
        p_is_staff                            bit,                     /* Set to 0 to disable this partner as a staff member. --  */
        p_kardia_login                        varchar(128)  null,      /* The Kardia login name of the staff member. --  */
        p_kardiaweb_login                     varchar(128)  null,      /* The Kardia self-service website login of the staff member. --  */
        p_preferred_email_id                  integer  null,           /* Preferred email (p_contact_info) for receiving reports and such from Kardia --  */
        p_preferred_location_id               integer  null,           /* Preferred location (p_location) for receiving reports and such from Kardia --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_bulk_postal_code */

create table p_bulk_postal_code (
        p_bulk_code                           varchar(10)  not null,   /* The Post-office code for the bulk mailing type, for example, L801 --  */
        p_country_code                        varchar(2)  not null,    /* The country the code is for --  */
        p_bulk_postal_code                    varchar(10)  not null,   /* The Zip Center (3 digits) --  */
        p_bulk_postal_code_description        varchar(255)  null,      /* Name of zip center (city, etc) --  */
        p_zip_state                           char(2)  null,           /* The State the zip is in --  */
        p_bulk_range                          varchar(20)  null,       /* The range that the zipcenter falls into. Used for double-checking purposes only --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_zipranges */

create table p_zipranges (
        p_state_code                          char(2)  not null,       /* The state the range is for --  */
        p_first_zip                           char(5)  not null,       /* First zip code in the range --  */
        p_last_zip                            char(5)  not null,       /* Last zip in the range --  */
        p_state_name                          varchar(20)  not null,   /* The State the zip is in --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_country */

create table p_country (
        p_country_code                        char(2)  not null,       /* ISO 3166-1 Alpha-2 With UK exception (basically ccTLD codes) --  */
        p_iso3166_2_code                      char(2)  not null,       /* ISO 3166-1 Alpha-2 --  */
        p_iso3166_3_code                      char(3)  not null,       /* ISO 3166-1 Alpha-3 --  */
        p_fips_code                           char(2)  not null,       /* Two-letter codes used by FIPS 10-4 / CIA World Factbook / Joshua Project / HIS-ROG3 --  */
        p_country_name                        varchar(255)  not null,  /* The name of the country --  */
        p_local_name                          varchar(255)  null,      /* The localized name of the country --  */
        p_phone_code                          int  null,               /* The phone calling code for this country --  */
        p_security_level                      int  null,               /* The security level for this country (from Joshua project) --  */
        p_nationality                         varchar(30)  null,       /* Nationality of the people --  */
        p_early_timezone                      char(5)  null,           /* Earliest timezone in the country --  */
        p_late_timezone                       char(5)  null,           /* Latest timezone in the country --  */
        p_record_status_code                  char(1)  not null,       /* (A)ctive, (O)bsolete -- for listing old addresses that have obsolete country codes. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_pol_division */

create table p_pol_division (
        p_country_code                        char(2)  not null,       /* ISO 3166-1 Alpha-2 With UK exception (basically ccTLD codes) --  */
        p_pol_division                        varchar(64)  not null,   /* Political division abbrev/code, or full name if no abbrev/code. --  */
        p_pol_division_parent                 varchar(64)  null,       /* Political division that this is a part of (null == top level state or province) --  */
        p_pol_division_name                   varchar(64)  not null,   /* Political division name or label --  */
        p_local_name                          varchar(255)  null,      /* The localized name of the political division --  */
        p_record_status_code                  char(1)  not null,       /* (A)ctive, (O)bsolete -- for old addresses that have an obsolete state/province. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'AL' as p_pol_division, 'Alabama' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'GA' as p_pol_division, 'Georgia' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'HI' as p_pol_division, 'Hawaii' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'ID' as p_pol_division, 'Idaho' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'IL' as p_pol_division, 'Illinois' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'IN' as p_pol_division, 'Indiana' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'IA' as p_pol_division, 'Iowa' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'KS' as p_pol_division, 'Kansas' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'KY' as p_pol_division, 'Kentucky' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'LA' as p_pol_division, 'Louisiana' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'ME' as p_pol_division, 'Maine' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'AK' as p_pol_division, 'Alaska' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'MD' as p_pol_division, 'Maryland' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'MA' as p_pol_division, 'Massachusetts' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'MI' as p_pol_division, 'Michigan' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'MN' as p_pol_division, 'Minnesota' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'MS' as p_pol_division, 'Mississippi' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'MO' as p_pol_division, 'Missouri' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'MT' as p_pol_division, 'Montana' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'NE' as p_pol_division, 'Nebraska' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'NV' as p_pol_division, 'Nevada' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'NH' as p_pol_division, 'New Hampshire' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'AZ' as p_pol_division, 'Arizona' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'NJ' as p_pol_division, 'New Jersey' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'NM' as p_pol_division, 'New Mexico' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'NY' as p_pol_division, 'New York' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'NC' as p_pol_division, 'North Carolina' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'ND' as p_pol_division, 'North Dakota' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'OH' as p_pol_division, 'Ohio' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'OK' as p_pol_division, 'Oklahoma' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'OR' as p_pol_division, 'Oregon' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'PA' as p_pol_division, 'Pennsylvania' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'RI' as p_pol_division, 'Rhode Island' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'AR' as p_pol_division, 'Arkansas' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'SC' as p_pol_division, 'South Carolina' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'SD' as p_pol_division, 'South Dakota' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'TN' as p_pol_division, 'Tennessee' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'TX' as p_pol_division, 'Texas' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'UT' as p_pol_division, 'Utah' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'VT' as p_pol_division, 'Vermont' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'VA' as p_pol_division, 'Virginia' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'WA' as p_pol_division, 'Washington' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'WV' as p_pol_division, 'West Virginia' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'WI' as p_pol_division, 'Wisconsin' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'CA' as p_pol_division, 'California' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'WY' as p_pol_division, 'Wyoming' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'DC' as p_pol_division, 'Washington DC' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'CO' as p_pol_division, 'Colorado' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'CT' as p_pol_division, 'Connecticut' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'DE' as p_pol_division, 'Delaware' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_pol_division (p_country_code,p_pol_division,p_pol_division_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'US' as p_country_code, 'FL' as p_pol_division, 'Florida' as p_pol_division_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* p_banking_details */

create table p_banking_details (
        p_banking_details_key                 integer  not null,       /* banking details key (autonumbered) --  */
        p_banking_type                        char(1)  not null,       /* type of account (C=checking, S=savings, R=revolving credit account such as VISA/MC) --  */
        p_banking_card_type                   char(2)  null,           /* type of revolving credit - VI = visa, MC = mastercard, AE = american express, DI = discover, etc. --  */
        p_partner_id                          char(10)  null,          /* partner id of the account owner (if relevant) --  */
        p_bank_partner_id                     char(10)  null,          /* partner id of the financial institution itself (if available) --  */
        p_bank_account_name                   varchar(80)  not null,   /* name on the account (e.g., name on visa card, etc.) --  */
        p_bank_account_number                 varchar(32)  null,       /* number of the account --  */
        p_bank_routing_number                 varchar(32)  null,       /* routing number, if applicable --  */
        p_next_check_number                   integer  null,           /* next check number to use when writing checks --  */
        p_bank_expiration                     datetime  null,          /* expiration date on account --  */
        a_ledger_number                       char(10)  null,          /* GL ledger associated with this bank account --  */
        a_account_code                        char(16)  null,          /* GL account associated with this bank account --  */
        p_comment                             varchar(255)  null,      /* comments / description of bank account --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_banking_type */

create table p_banking_type (
        p_banking_type                        char(1)  not null,       /* type of account (C=checking, S=savings, R=revolving credit account such as VISA/MC, D=certificate of deposit, M=merchant, I=investment) --  */
        p_banking_desc                        varchar(64)  null,       /* comments / description of bank account --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into p_banking_type (p_banking_type,p_banking_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'C' as p_banking_type, 'Checking' as p_banking_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_banking_type (p_banking_type,p_banking_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'S' as p_banking_type, 'Savings' as p_banking_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_banking_type (p_banking_type,p_banking_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'R' as p_banking_type, 'Revolving Credit' as p_banking_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_banking_type (p_banking_type,p_banking_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'D' as p_banking_type, 'Certificate of Deposit' as p_banking_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_banking_type (p_banking_type,p_banking_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'M' as p_banking_type, 'Merchant' as p_banking_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_banking_type (p_banking_type,p_banking_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'I' as p_banking_type, 'Investment' as p_banking_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* p_title */

create table p_title (
        p_title                               varchar(64)  not null,   /* Mr. & Mrs. --  */
        p_record_status_code                  char(1)  not null,       /* A=active, O=obsolete --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_gazetteer */

create table p_gazetteer (
        p_country_code                        char(2)  not null,       /* The country code containing this gazetteer feature --  */
        p_feature_type                        char(2)  not null,       /* The feature type. "PC" for postal code (zip code). --  */
        p_feature_id                          integer  not null,       /* numeric ID of the feature (this depends on feature source) --  */
        p_alt_feature_id                      integer  not null,       /* alternate numeric ID of the feature (this depends on feature source) --  */
        p_feature_name                        varchar(80)  not null,   /* name of the feature (zip code, city name, etc.) --  */
        p_feature_desc                        varchar(255)  null,      /* description of the feature (zip code, city name, etc.) --  */
        p_state_province                      varchar(64)  null,       /* if applicable, the state or province that this feature occurs in (data not always available) --  */
        p_area_land                           float  null,             /* land area of the feature, in square miles --  */
        p_area_water                          float  null,             /* water area of the feature, in square miles --  */
        p_latitude                            float  null,             /* latitude of the feature, in degrees. Positive is north latitude, negative is south latitude. --  */
        p_longitude                           float  null,             /* longitude of the feature, in degrees. Positive is east latitude, negative is west latitude. --  */
        p_source                              varchar(40)  null,       /* source of the data (USCENSUS2010, for the US 2010 Census Gazetteer files) --  */
        p_validity_date                       datetime  null,          /* the date that the data was gathered / is first valid. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_dup_check_tmp */

create table p_dup_check_tmp (
        p_partner_key                         char(10)  not null,      /* partner key of a potential duplicate record. --  */
        s_username                            varchar(20)  not null,   /* name of the user that is looking for the dups --  */
        p_score                               int  not null,           /* the "score" that we want to order the potential duplicate record in. --  */
        p_comment                             varchar(255)  not null,  /* a comment describing what is similar about this duplicate record. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_partner_sort_tmp */

create table p_partner_sort_tmp (
        p_partner_key                         char(10)  not null,      /* partner key --  */
        s_username                            varchar(20)  not null,   /* name of the user --  */
        p_sort_session_id                     integer  not null,       /* ID of sort session, a unique integer. --  */
        p_sortkey                             varchar(255)  not null,  /* the sorting key, determining the order in which sorted records are returned. --  */
        p_location_id                         integer  null,           /* the location record to use for this partner --  */
        p_contact_id                          integer  null,           /* the contact record to use for this partner --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_acquisition_code */

create table p_acquisition_code (
        p_acquisition_code                    char(3)  not null,       /* The 3-character acquisition code for how we originally came in contact with the person --  */
        p_acquisition_name                    varchar(32)  not null,   /* A brief description or label for the acquisition code --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into p_acquisition_code (p_acquisition_code,p_acquisition_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'CNV' as p_acquisition_code, 'Data Conversion' as p_acquisition_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_acquisition_code (p_acquisition_code,p_acquisition_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'OTH' as p_acquisition_code, 'Other Reason' as p_acquisition_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_acquisition_code (p_acquisition_code,p_acquisition_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'DON' as p_acquisition_code, 'New Donor' as p_acquisition_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_acquisition_code (p_acquisition_code,p_acquisition_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'PAR' as p_acquisition_code, 'Missionary Partner' as p_acquisition_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_acquisition_code (p_acquisition_code,p_acquisition_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'PAY' as p_acquisition_code, 'New Payee' as p_acquisition_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_acquisition_code (p_acquisition_code,p_acquisition_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'STA' as p_acquisition_code, 'New Staff Member' as p_acquisition_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_acquisition_code (p_acquisition_code,p_acquisition_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'MIS' as p_acquisition_code, 'New Missionary' as p_acquisition_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_acquisition_code (p_acquisition_code,p_acquisition_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'EVT' as p_acquisition_code, 'Met at an Event' as p_acquisition_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_acquisition_code (p_acquisition_code,p_acquisition_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'UNI' as p_acquisition_code, 'Met at a College or University' as p_acquisition_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into p_acquisition_code (p_acquisition_code,p_acquisition_name,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'RAN' as p_acquisition_code, 'Met at Random / Divine Appointment' as p_acquisition_name, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* p_partner_search */

create table p_partner_search (
        p_search_id                           integer  not null,       /* ID of search, a unique integer. --  */
        p_search_desc                         varchar(255)  not null,  /* A name/description given to this search --  */
        p_search_visibility                   char(1)  not null,       /* P = only to me, A = visible to everyone --  */
        p_is_temporary                        bit  not null,           /* If set to 1 (true), then this search and its results will automatically be erased --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_partner_search_stage */

create table p_partner_search_stage (
        p_search_id                           integer  not null,       /* ID of search, a unique integer. --  */
        p_search_stage_id                     integer  not null,       /* ID of search stage - an advanced search is composed of one or more stages, each of which can filter, remove from, or add to the results generated by previous stages. --  */
        p_stage_type                          char(3)  not null,       /* the type of search stage --  */
        p_stage_op                            char(1)  not null,       /* the "operator" -- are we (A)dding matching people, (R)equiring some criteria, or (E)xcluding matches --  */
        p_result_count                        integer  null,           /* the number of results at the end of this stage the last time results were computed --  */
        p_sequence                            integer  not null,       /* Sequence (order) of search stages. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_partner_search_results */

create table p_partner_search_results (
        p_partner_key                         char(10)  not null,      /* partner key --  */
        s_username                            varchar(20)  not null,   /* name of the user --  */
        p_search_session_id                   integer  not null,       /* ID of search session, a unique integer. --  */
        p_search_stage_id                     integer  not null,       /* ID of search stage - see p_partner_search for details. --  */
        p_sortkey                             varchar(255)  not null,  /* the sorting key, determining the order in which records are returned. --  */
        p_location_id                         integer  null,           /* the location record to use for this partner --  */
        p_contact_id                          integer  null,           /* the contact record to use for this partner --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_search_stage_criteria */

create table p_search_stage_criteria (
        p_search_id                           integer  not null,       /* ID of search, a unique integer. --  */
        p_search_stage_id                     integer  not null,       /* ID of search stage --  */
        p_criteria_name                       varchar(32)  not null,   /* the criteria name. --  */
        p_criteria_value                      varchar(900)  null,      /* the criteria's value. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_nondup */

create table p_nondup (
        p_partner_key                         char(10)  not null,      /*  --  */
        p_nondup_partner_key                  char(10)  not null,      /*  --  */
        p_comment                             varchar(900)  null,      /* comments about this pair of partner keys --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_dup */

create table p_dup (
        p_partner_key                         char(10)  not null,      /*  --  */
        p_dup_partner_key                     char(10)  not null,      /*  --  */
        p_match_quality                       float  not null,         /* The degree of match for the potential duplicates (0.0 ~ 1.0) --  */
        p_location_id                         integer  null,           /* If this is a duplicate location (same partner), this is the location ID. --  */
        p_dup_location_id                     integer  null,           /*  --  */
        p_revision_id                         integer  null,           /*  --  */
        p_dup_revision_id                     integer  null,           /*  --  */
        p_contact_id                          integer  null,           /* If this is a duplicate contact record (same partner), this is the contact ID. --  */
        p_dup_contact_id                      integer  null,           /*  --  */
        p_comment                             varchar(900)  null,      /* comments about this potential duplicate --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* p_merge */

create table p_merge (
        p_partner_key_a                       char(10)  not null,      /*  --  */
        p_partner_key_b                       char(10)  not null,      /*  --  */
        p_data_source                         varchar(16)  not null,   /* The source of the data (gift, address, contact, etc.) --  */
        p_data_key                            varchar(255)  not null,  /* The primary key or other identifier of the data in question --  */
        p_data_desc                           varchar(255)  not null,  /* The data's summarized content/value. --  */
        p_short_data_desc                     varchar(255)  not null,  /* The data's summarized content/value, shortened to be more appropriate for fuzzy string comparison --  */
        p_date_start                          datetime  null,          /* If we're managing data based on a date range, this is the starting date --  */
        p_date_end                            datetime  null,          /* If we're managing the data based on date range, this is the ending date --  */
        p_allow_copy                          bit  not null,           /* 1 if we can make a copy of this data (e.g. addresses, phones, emails), 0 if we can only move it (e.g. gifts, payments, etc.) --  */
        p_default_copy                        bit  not null,           /* 1 if by default we copy rather than move, 0 if by default we move rather than copy --  */
        p_default_marriage_copy               bit  not null,           /* 1 if by default we copy this in a marriage merge, 0 if by default we leave it alone --  */
        p_default_marriage_move               bit  not null,           /* 1 if by default we move this in a marriage merge, 0 if by default we leave it alone --  */
        p_allow_multiple                      bit  not null,           /* 1 if we can have more than one of these items per partner (addresses, gifts, etc), or 0 if we can only have one per partner (staff, church, person) --  */
        p_default_multiple                    bit  not null,           /* 1 if we by default keep multiples, or 0 if we by default don't create multiples. --  */
        p_allow_delete                        bit  not null,           /* 1 if we can delete this item entirely during the merge, or 0 if we cannot delete it --  */
        p_allow_collate                       bit  not null,           /* 1 if we should look at the "short desc" to see if two of these are identical, 0 if they are never considered identical --  */
        p_disposition                         varchar(3)  not null,    /* How we're handling this, first char where from (uppercase if copy, lowercase if move), 2nd/3rd chars where to, for example aB means move from a to b, BC means copy from B to C, ABC means copy from A to both B and C. --  */
        p_comment                             varchar(900)  null,      /* comments about this merge data --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* m_list */

create table m_list (
        m_list_code                           varchar(20)  not null,   /* key --  */
        m_list_parent                         varchar(20)  null,       /* if we have a hierarchy of lists, e.g., a publication has issues --  */
        m_list_description                    varchar(255)  not null,  /*  --  */
        m_list_status                         char(1)  not null,       /* O=obsolete, A=active --  */
        m_list_type                           char(1)  not null,       /* P=publication, I=issue, C=campaign, M=motivational code, O=other, etc. --  */
        m_delivery_method                     char(1)  null,           /* default delivery method for this publication (E=email, M=mail) --  */
        m_discard_after                       datetime  null,          /* for temporary lists/extracts --  */
        m_list_frozen                         bit,                     /* do not permit add/remove memberships --  */
        m_date_sent                           datetime  null,          /*  --  */
        a_charge_ledger                       char(10)  null,          /* who to charge for publ. costs --  */
        p_postal_mode                         char(1)  null,           /* B-Bulk F-FirstClass Used to set postal modes on mailings --  */
        a_charge_fund                         varchar(20)  null,       /*  --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* m_list_membership */

create table m_list_membership (
        m_list_code                           varchar(20)  not null,   /*  --  */
        p_partner_key                         char(10)  not null,      /*  --  */
        m_hist_id                             int  not null,           /* a history of previous subscriptions and removals --  */
        m_num_copies                          int  not null,           /* usually just 1 copy; possible to be 0 copies --  */
        p_location_id                         tinyint  null,           /* if member specifies a particular Location to use --  */
        p_contact_id                          tinyint  null,           /* if member specifies a particular contact info record to use --  */
        m_delivery_method                     char(1)  null,           /* E=email, M=postal mail. If NULL, use delivery method from m_list. --  */
        m_member_type                         char(1)  not null,       /* O=owner, M=member --  */
        m_num_issues_sub                      int  null,               /* how many issues in subscription --  */
        m_num_issues_recv                     int  null,               /* DENORMALIZATION: how many issues received? --  */
        m_start_date                          datetime  null,          /*  --  */
        m_end_date                            datetime  null,          /*  --  */
        m_hold_until_date                     datetime  null,          /* "don't send for 5 months" --  */
        m_renewal_date                        datetime  null,          /* date to bug the member --  */
        m_cancel_date                         datetime  null,          /*  --  */
        m_notice_sent_date                    datetime  null,          /*  --  */
        p_postal_mode                         char(1)  null,           /* B-Bulk F-FirstClass Used to override postal modes for this membership --  */
        m_membership_status                   char(1)  not null,       /* A=active, O=obsolete --  */
        m_complimentary                       bit,                     /* whether the subscription or issue was complimentary --  */
        m_comments                            varchar(255)  null,      /*  --  */
        m_show_contact                        bit,                     /* whether to show first/last name for an org's subscription --  */
        m_contact                             varchar(80)  null,       /* text to use instead of first/last name when printing labels --  */
        m_reason_member                       char(1)  null,           /* why person is on this list --  */
        m_reason_cancel                       char(1)  null,           /* reason given for canceling --  */
        m_sort_order                          integer  null,           /* if a list was imported, and the order it prints in is significant in some way, this field can be used. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* m_list_document */

create table m_list_document (
        m_list_code                           varchar(20)  not null,   /* key --  */
        e_document_id                         integer  not null,       /* document ID - see CRM system for document storage. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_contact_autorecord */

create table e_contact_autorecord (
        p_partner_key                         char(10)  not null,      /* The partner ID that is doing the engaging --  */
        e_collaborator_id                     char(10)  not null,      /* The collaborator that the partner communicated with --  */
        e_contact_history_type                integer  not null,       /* The type of the contact to automatically record (email / phone / etc), or "ALL" to apply to all types --  */
        e_contact_id                          integer  not null,       /* The contact info id (p_contact_info) to auto record, or (-1) to apply to ALL contact records relevant to the history type above. --  */
        e_engagement_id                       integer  null,           /* The engagement that this contact is in regard to (null if general or pre-engagement) --  */
        e_auto_record                         bit  not null,           /* Whether to auto-record: 1=yes, 0=no --  */
        e_auto_record_apply_all               bit  not null,           /* Whether this auto-record record applies to just this collaborator (0) or to ALL collaborators (1). The auto_record setting for a specific collaborator will override one set for all collaborators. If more than one 'all collaborators' record is present and they conflict, then the default is ON (1), to automatically record the contacts. --  */
        e_comments                            varchar(255)  null,      /* User-entered comments on this engagement track/step for this partner --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_contact_history_type */

create table e_contact_history_type (
        e_contact_history_type                integer  not null,       /* The unique ID of this contact history type --  */
        e_short_name                          varchar(24)  not null,   /* Short name of the history type (such as "Phone" or "Pray" or "Note") --  */
        e_description                         varchar(80)  not null,   /* The description of this history type --  */
        e_user_selectable                     bit  not null,           /* Whether this type is selectable by the user when hand-entering a contact history item (otherwise, it is only used for auto-generated records) --  */
        e_is_notes                            bit  not null,           /* Whether this type reflects simple notes recorded (1) or an actual conversation (0) --  */
        e_is_inperson                         bit  not null,           /* Whether this type reflects an in-person contact at a place (1) or via a contact method like email/phone/etc (0) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into e_contact_history_type (e_contact_history_type,e_short_name,e_description,e_user_selectable,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 1 as e_contact_history_type, 'Phone' as e_short_name, 'Phone Call' as e_description, 1 as e_user_selectable, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_contact_history_type (e_contact_history_type,e_short_name,e_description,e_user_selectable,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 2 as e_contact_history_type, 'Email' as e_short_name, 'Email Message' as e_description, 1 as e_user_selectable, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_contact_history_type (e_contact_history_type,e_short_name,e_description,e_user_selectable,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 3 as e_contact_history_type, 'Conversation' as e_short_name, 'In-Person Conversation' as e_description, 1 as e_user_selectable, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_contact_history_type (e_contact_history_type,e_short_name,e_description,e_user_selectable,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 4 as e_contact_history_type, 'Note' as e_short_name, 'Note' as e_description, 1 as e_user_selectable, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_contact_history_type (e_contact_history_type,e_short_name,e_description,e_user_selectable,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 5 as e_contact_history_type, 'Pray' as e_short_name, 'Prayer/Praise Item' as e_description, 1 as e_user_selectable, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_contact_history_type (e_contact_history_type,e_short_name,e_description,e_user_selectable,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 6 as e_contact_history_type, 'SignUp' as e_short_name, 'Sign Up List' as e_description, 1 as e_user_selectable, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_contact_history_type (e_contact_history_type,e_short_name,e_description,e_user_selectable,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 7 as e_contact_history_type, 'Update' as e_short_name, 'Update' as e_description, 1 as e_user_selectable, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* e_contact_history */

create table e_contact_history (
        e_contact_history_id                  integer  not null,       /* The unique ID of this contact history item --  */
        p_partner_key                         char(10)  not null,      /* The partner key of the person that the organization contacted --  */
        e_contact_history_type                integer  not null,       /* The unique ID of this contact history type --  */
        p_contact_id                          integer  null,           /* The p_contact_info ID that was used for this contact (such as a phone number, email address, etc.) --  */
        p_location_partner_key                char(10)  null,          /* The partner key of the location where the contact took place (may be the same as the p_partner_key in some cases) --  */
        p_location_id                         integer  null,           /* The p_location ID where the contact physically took place (for in-person contacts) --  */
        p_location_revision_id                integer  null,           /* The p_location revision ID where the contact physically took place (for in-person contacts) --  */
        e_whom                                char(10)  null,          /* The collaborator/user who made the contact; NULL if no particular user was involved --  */
        e_initiation                          char(1)  null,           /* Set to 'P' if the engaging partner initiated the contact, or 'C' if the collaborator (organization) initiated the contact --  */
        e_subject                             varchar(255)  null,      /* A short description of the contact that took place --  */
        e_contact_date                        datetime  not null,      /* The date and time that the contact took place --  */
        e_notes                               varchar(900)  null,      /* Notes regarding this contact --  */
        e_message_id                          varchar(255)  null,      /* Message-ID header field of email message, or similar unique ID for other communications --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_activity */

create table e_activity (
        e_activity_group_id                   integer  not null,       /* A unique ID identifying the group of contact activity items that are being aggregated. --  */
        e_activity_id                         integer  not null,       /* A unique ID identifying a single activity item within a group of items. --  */
        p_partner_key                         char(10)  not null,      /* The partner involved in the activity --  */
        e_whom                                char(10)  null,          /* The collaborator (with the organization) that was involved in the communication, if any. --  */
        e_initiation                          char(1)  null,           /* Set to 'P' if the engaging partner initiated the activity, or 'C' if the collaborator (organization) initiated the activity. --  */
        e_sort_key                            varchar(20)  null,       /* A value we can use to sort this activity data, if needed --  */
        e_activity_date                       datetime  not null,      /* The date that the activity took place --  */
        e_activity_type                       char(4)  not null,       /* The type of activity. --  */
        e_reference_info                      varchar(900)  null,      /* Information we can use to track back to the source data of the activity (such as a history ID, a gift ledger+batch+giftid, or such). --  */
        e_info                                varchar(900)  null,      /* Informational notes regarding this activity --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_engagement_track */

create table e_engagement_track (
        e_track_id                            integer  not null,       /* A unique ID identifying the engagement track --  */
        e_track_name                          varchar(24)  not null,   /* A short name for the engagement track --  */
        e_track_description                   varchar(255)  not null,  /* A description for the engagement track --  */
        e_track_color                         varchar(32)  null,       /* Color to be used in presenting this track visually - RGB (i.e. '#f0f0f0') or named (i.e., 'green') --  */
        e_track_status                        char(1)  not null,       /* Status of this engagement track: (A)ctive or (O)bsolete --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_engagement_track_collab */

create table e_engagement_track_collab (
        e_track_id                            integer  not null,       /* A unique ID identifying the engagement track --  */
        p_collab_partner_key                  char(10)  not null,      /* Partner key of the collaborator. If a Kardia user, the username must be tied to the partner key in the p_staff table. --  */
        e_collab_type_id                      integer  not null,       /* Type of collaborator --  */
        e_comments                            varchar(255)  null,      /* Comments about this collaborator's involvement in this track. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_engagement_step */

create table e_engagement_step (
        e_track_id                            integer  not null,       /* A unique ID identifying the engagement track --  */
        e_step_id                             integer  not null,       /* A unique ID identifying the engagement step --  */
        e_step_name                           varchar(32)  not null,   /* A short name for the engagement step --  */
        e_step_description                    varchar(255)  not null,  /* A description for the engagement step --  */
        e_step_sequence                       integer  not null,       /* What order the engagement steps come in. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_engagement_step_collab */

create table e_engagement_step_collab (
        e_track_id                            integer  not null,       /* A unique ID identifying the engagement track --  */
        e_step_id                             integer  not null,       /* A unique ID identifying the engagement step --  */
        p_collab_partner_key                  char(10)  not null,      /* Partner key of the collaborator. If a Kardia user, the username must be tied to the partner key in the p_staff table. --  */
        e_collab_type_id                      integer  not null,       /* Type of collaborator --  */
        e_comments                            varchar(255)  null,      /* Comments about this collaborator's involvement in this step. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_engagement_step_req */

create table e_engagement_step_req (
        e_track_id                            integer  not null,       /* A unique ID identifying the engagement track --  */
        e_step_id                             integer  not null,       /* A unique ID identifying the engagement step --  */
        e_req_id                              integer  not null,       /* The unique ID identifying the template requirement item. --  */
        e_req_name                            varchar(255)  not null,  /* A description for the engagement step requirement --  */
        e_due_days_from_step                  integer  null,           /* If applicable, how many days to set the due date at after the partner starts this step --  */
        e_due_days_from_req                   integer  null,           /* If applicable, how many days to set the due date at after the partner completes another requirement --  */
        e_due_days_from_req_id                integer  null,           /* If applicable, the requirement ID whose completion triggers the due date interval for this requirement --  */
        e_req_whom                            char(1)  not null,       /* Who this requirement is fulfilled by: (P)artner, (O)rganization, or (E)ither. --  */
        e_req_doc_type_id                     integer  null,           /* Does a document fulfill this step? If so, the corresponding document type ID is stored here. --  */
        e_req_waivable                        bit  not null,           /* Can this requirement be waived? 0 if not, or 1 if so --  */
        e_req_sequence                        integer  not null,       /* The order in which the requirements appear --  */
        e_is_active                           bit  not null,           /* Whether this requirement is active/visible or not. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_partner_engagement */

create table e_partner_engagement (
        p_partner_key                         char(10)  not null,      /* The partner ID that is doing the engaging --  */
        e_engagement_id                       integer  not null,       /* A unique ID for this partner's current engagement --  */
        e_hist_id                             integer  not null,       /* An incrementing ID for showing the history of this engagement. --  */
        e_track_id                            integer  not null,       /* The engagement track --  */
        e_step_id                             integer  not null,       /* The current engagement step --  */
        e_is_archived                         bit  not null,           /* Set to 0 if the engagement in this track is currently active, or 1 if it is archived/historical --  */
        e_completion_status                   char(1)  not null,       /* Status of the step: (I)ncomplete, (C)omplete, (E)xited without completing the step --  */
        e_desc                                varchar(40)  not null,   /* User-entered short description on this engagement track/step for this partner --  */
        e_comments                            varchar(900)  null,      /* User-entered comments on this engagement track/step for this partner --  */
        e_start_date                          datetime  not null,      /* The date the user entered this engagement track and/or step --  */
        e_started_by                          char(10)  not null,      /* Collaborator partner ID that caused the track/step to begin --  */
        e_completion_date                     datetime  null,          /* The date the user completed this engagement step --  */
        e_completed_by                        char(10)  null,          /* Collaborator partner ID that caused the track/step to become complete --  */
        e_exited_date                         datetime  null,          /* The date the user exited this engagement step (whether completed or not) --  */
        e_exited_by                           char(10)  null,          /* Collaborator partner ID that caused the track/step to exit --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_partner_engagement_req */

create table e_partner_engagement_req (
        p_partner_key                         char(10)  not null,      /* The partner ID that is doing the engaging --  */
        e_engagement_id                       integer  not null,       /* A unique ID for this partner's current engagement --  */
        e_hist_id                             integer  not null,       /* An incrementing ID for showing the history of this engagement. --  */
        e_req_item_id                         integer  not null,       /* An incrementing ID for this actual requirement item --  */
        e_track_id                            integer  not null,       /* The engagement track id -- if copied from template --  */
        e_step_id                             integer  not null,       /* The engagement track step id -- if copied from template --  */
        e_req_id                              integer  null,           /* The engagement track requirement id -- if copied from template --  */
        e_req_completion_status               char(1)  not null,       /* Status of the requirement: (I)ncomplete, (C)omplete, (W)aived --  */
        e_req_name                            varchar(255)  not null,  /* A description for the engagement step requirement --  */
        e_due_days_from_step                  integer  null,           /* If applicable, how many days to set the due date at after the partner starts this step --  */
        e_due_days_from_req                   integer  null,           /* If applicable, how many days to set the due date at after the partner completes another requirement --  */
        e_due_days_from_req_id                integer  null,           /* If applicable, the requirement ID whose completion triggers the due date interval for this requirement --  */
        e_req_whom                            char(1)  not null,       /* Who this requirement is fulfilled by: (P)artner, (O)rganization, or (E)ither. --  */
        e_req_doc_type_id                     integer  null,           /* Does a document fulfill this step? If so, the corresponding document type ID is stored here. --  */
        e_req_waivable                        bit  not null,           /* Can this requirement be waived? 0 if not, or 1 if so --  */
        e_req_doc_id                          integer  null,           /* Document ID used to fulfill this requirement --  */
        e_completion_date                     datetime  null,          /* The date the user completed this engagement step --  */
        e_completed_by                        char(10)  null,          /* Collaborator partner ID that caused the track/step to become complete --  */
        e_waived_date                         datetime  null,          /* The date the user exited this engagement step (whether completed or not) --  */
        e_waived_by                           char(10)  null,          /* Collaborator partner ID that caused the track/step to exit --  */
        e_req_sequence                        integer  not null,       /* The order in which the requirements appear --  */
        e_is_active                           bit  not null,           /* Whether this requirement is active/visible or not. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_tag_type */

create table e_tag_type (
        e_tag_id                              integer  not null,       /* ID of the tag --  */
        e_tag_label                           varchar(40)  not null,   /* Short label for this tag. --  */
        e_tag_desc                            varchar(255)  not null,  /* A full description of the tag. --  */
        e_is_active                           bit  not null,           /* 1 if active, or 0 if not active. An inactive tag may still be present in the tag graph, but will not be available to the user to select. --  */
        e_tag_threshold                       float  not null,         /* A value between 0.0 and 1.0 that indicates how strong a tag must be in order for it to actually be created in the tag graph for a partner. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_tag_type_relationship */

create table e_tag_type_relationship (
        e_tag_id                              integer  not null,       /* ID of the tag --  */
        e_rel_tag_id                          integer  not null,       /* ID of the related tag --  */
        e_rel_strength                        float  not null,         /* The strength of the relationship (0.0 to 1.0) --  */
        e_rel_certainty                       float  not null,         /* The certainty of the relationship (0.0 to 1.0) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_tag */

create table e_tag (
        e_tag_id                              integer  not null,       /* ID of the tag --  */
        p_partner_key                         char(10)  not null,      /* ID of the partner that has been thusly tagged --  */
        e_tag_strength                        float  not null,         /* The strength of the tag (-1.0 to 1.0) - negative values mean disinterest, etc. --  */
        e_tag_certainty                       float  not null,         /* The certainty of the tag (0.0 to 1.0) --  */
        e_tag_volatility                      char(1)  not null,       /* The volatility of the tag: (P)ersistent - created by a user, (D)erived from other data, or merely (I)mplied from other tags. --  */
        e_tag_origin                          varchar(8)  null,        /* If the tag was derived from other data, this is the type of the source of that data. Values for this are not yet defined. --  */
        e_tag_comments                        varchar(255)  null,      /* Comments about this tag --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_tag_activity */

create table e_tag_activity (
        e_tag_activity_group                  integer  not null,       /* The group used for tag activity aggregation. --  */
        e_tag_activity_id                     integer  not null,       /* ID of the activity item --  */
        e_tag_id                              integer  not null,       /* ID of the tag --  */
        p_partner_key                         char(10)  not null,      /* ID of the partner --  */
        e_tag_strength                        float  not null,         /* The strength of the tag (-1.0 to 1.0) - negative values mean disinterest, etc. --  */
        e_tag_certainty                       float  not null,         /* The certainty of the tag (0.0 to 1.0) --  */
        e_tag_volatility                      char(1)  not null,       /* The volatility of the tag: (P)ersistent - created by a user, (D)erived from other data, or merely (I)mplied from other tags. --  */
        e_tag_origin                          varchar(8)  null,        /* If the tag was derived from other data, this is the type of the source of that data. Values for this are not yet defined. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_tag_source */

create table e_tag_source (
        e_tag_id                              integer  not null,       /* ID of the tag being derived --  */
        e_tag_source_type                     varchar(32)  not null,   /* Source type (GIFT, MLIST, etc.) --  */
        e_tag_source_key                      varchar(255)  not null,  /* They identity for the specific source record (for example, a ledger/fund/acct combination for gift tags) --  */
        e_is_active                           bit  not null,           /* 1 if active, or 0 if this derivation is not active. --  */
        e_tag_strength                        float  not null,         /* A value between -1.0 and 1.0 that indicates the strength of the derivation (negative values work against the tag) --  */
        e_tag_certainty                       float  not null,         /* A value between 0.0 and 1.0 that indicates the certainty of the derivation. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_document_type */

create table e_document_type (
        e_doc_type_id                         integer  not null,       /* The ID of the document type --  */
        e_parent_doc_type_id                  integer  null,           /* The parent (more general) document type, for hierarchical organization of document types --  */
        e_doc_type_label                      varchar(40)  not null,   /* A short label for the document type --  */
        e_doc_type_desc                       varchar(255)  null,      /* A long description of the document type --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into e_document_type (e_doc_type_id,e_doc_type_label,e_doc_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 1 as e_doc_type_id, 'Profile Photo' as e_doc_type_label, 'Profile Photograph' as e_doc_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_document_type (e_doc_type_id,e_doc_type_label,e_doc_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 2 as e_doc_type_id, 'Prayer Letter' as e_doc_type_label, 'Prayer Letter' as e_doc_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_document_type (e_doc_type_id,e_doc_type_label,e_doc_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 3 as e_doc_type_id, 'Application' as e_doc_type_label, 'Application' as e_doc_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_document_type (e_doc_type_id,e_doc_type_label,e_doc_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 4 as e_doc_type_id, 'Resume' as e_doc_type_label, 'Resume' as e_doc_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_document_type (e_doc_type_id,e_doc_type_label,e_doc_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 5 as e_doc_type_id, 'Document' as e_doc_type_label, 'Document' as e_doc_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_document_type (e_doc_type_id,e_doc_type_label,e_doc_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 6 as e_doc_type_id, 'Image' as e_doc_type_label, 'Image' as e_doc_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* e_document */

create table e_document (
        e_document_id                         integer  not null,       /* The ID of the document. --  */
        e_doc_type_id                         integer  not null,       /* The ID of the document type --  */
        e_title                               varchar(80)  not null,   /* The title of this document. --  */
        e_orig_filename                       varchar(255)  not null,  /* The original filename of the document when it was uploaded --  */
        e_current_folder                      varchar(255)  not null,  /* The pathname of the folder the document is currently stored in. --  */
        e_current_filename                    varchar(255)  not null,  /* The current filename of the document, as stored. --  */
        e_uploading_collaborator              char(10)  not null,      /* The collaborator or collaborator group that uploaded the document --  */
        e_workflow_instance_id                integer  null,           /* The workflow instance of this document, if any. This is used for workflow state chains triggered by the document upload itself rather than by the association of the document with a particular partner. --  */
        e_image_width                         integer  null,           /* The width, in pixels, of the image (if this file is am image) --  */
        e_image_height                        integer  null,           /* The height, in pixels, of the image (if this file is am image) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_document_comment */

create table e_document_comment (
        e_document_id                         integer  not null,       /* The ID of the document. --  */
        e_doc_comment_id                      integer  not null,       /* The ID of the comment --  */
        e_comments                            varchar(999)  not null,  /* Comments made about the document --  */
        e_collaborator                        char(10)  not null,      /* The collaborator making the comments --  */
        e_workflow_state_id                   integer  null,           /* The workflow state, if any, of the document at the time the comments were made. --  */
        e_target_collaborator                 char(10)  null,          /* A target collaborator (or collaborator group) for the comments. If set, it will create a to-do item for that collaborator. --  */
        e_target_review_period                integer  null,           /* The number of days the collaborator has to review the comments and acknowledge them (this sets a due date for the to-do item mentioned above). --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_partner_document */

create table e_partner_document (
        e_document_id                         integer  not null,       /* The ID of the document. --  */
        p_partner_key                         char(10)  not null,      /* The partner that is associated with the document --  */
        e_pardoc_assoc_id                     integer  not null,       /* A unique ID identifying the association of a document with a partner --  */
        e_engagement_id                       integer  null,           /* The current engagement ID (track instance) associated with this document --  */
        e_workflow_instance_id                integer  null,           /* The current workflow instance associated with this document, if any --  */
        e_image_offset_x                      integer  null,           /* The offset to the point in the image where we want to display --  */
        e_image_offset_y                      integer  null,           /* The offset to the point in the image where we want to display --  */
        e_image_scale_height                  integer  null,           /* The scaling height of the image (scale width is set automatically) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_workflow_type */

create table e_workflow_type (
        e_workflow_id                         integer  not null,       /* The ID of the workflow --  */
        e_workflow_label                      varchar(40)  not null,   /* A short label for the workflow --  */
        e_workflow_desc                       varchar(255)  null,      /* A long description of the workflow --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_workflow_type_step */

create table e_workflow_type_step (
        e_workflow_step_id                    integer  not null,       /* A particular workflow step --  */
        e_workflow_id                         integer  not null,       /* A particular workflow --  */
        e_workflow_step_label                 varchar(40)  not null,   /* A short label for the workflow step --  */
        e_workflow_step_desc                  varchar(255)  null,      /* A long description of the workflow step --  */
        e_workflow_step_trigger               integer  null,           /* What triggers this workflow state. See the trigger type, below, for the context for this number (e.g. workflow step id or document id) --  */
        e_workflow_step_trigger_type          varchar(4)  null,        /* The type of trigger for this workflow state: STEP for being triggered by another step, DOC for being triggered by the upload of a document type, DOCP for triggering when a document is associated with a partner. Other types will be added in the future. --  */
        e_collaborator                        char(10)  not null,      /* The collaborator or collaborator group that is responsible for handling this workflow step. --  */
        e_workflow_step_days                  integer  null,           /* The number of days the collaborator or collab group has to handle a document in this workflow step. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_workflow */

create table e_workflow (
        e_workflow_instance_id                integer  not null,       /* A particular workflow in progress --  */
        e_workflow_id                         integer  not null,       /* The workflow that is in progress --  */
        e_workflow_start                      datetime  not null,      /* The starting date of the entire workflow --  */
        e_workflow_trigger_id                 integer  null,           /* The ID of the object triggering the entire workflow to start --  */
        e_workflow_trigger_type               varchar(4)  null,        /* The type of the trigger for the workflow, such as DOC or DOCP --  */
        e_workflow_step_id                    integer  not null,       /* The current step in the workflow that we are at --  */
        e_workflow_step_start                 datetime  not null,      /* The starting date of the current workflow step --  */
        e_workflow_step_trigger_id            integer  null,           /* The ID of the workflow step that triggered this step to begin --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_collaborator_type */

create table e_collaborator_type (
        e_collab_type_id                      integer  not null,       /* The collaboration type ID --  */
        e_collab_type_label                   varchar(40)  not null,   /* A short collaboration type label --  */
        e_collab_type_desc                    varchar(255)  null,      /* A description of this collaboration type --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into e_collaborator_type (e_collab_type_id,e_collab_type_label,e_collab_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 1 as e_collab_type_id, 'Mobilizer' as e_collab_type_label, 'Mobilizer' as e_collab_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* e_collaborator */

create table e_collaborator (
        e_collaborator                        char(10)  not null,      /* The ID (partner key) of the collaborator --  */
        p_partner_key                         char(10)  not null,      /* The id (partner key) of the partner who is engaging --  */
        e_collab_type_id                      integer  not null,       /* The collaboration type ID --  */
        e_silence_interval                    integer  null,           /* The number of days without communication FROM a partner before a task item is generated for re-contacting the partner. Communication here can include all non-note contact history types, as well as financial gifts received. --  */
        e_recontact_interval                  integer  null,           /* Assuming the e_silence_interval, above, is met, this is the number of days since OUR last communication TO the partner before another task item is generated to re-contact the partner --  */
        e_collaborator_status                 char(1)  not null,       /* Collaborator status: (P) Priority, (A) Active, (I) Inactive ("back burner"). --  */
        e_is_automatic                        bit  not null,           /* Set to 1 if this was added automatically by a track or step. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_todo_type */

create table e_todo_type (
        e_todo_type_id                        integer  not null,       /* The todo type ID --  */
        e_todo_type_label                     varchar(40)  not null,   /* A short todo type label --  */
        e_todo_type_desc                      varchar(255)  null,      /* A description of this todo type --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into e_todo_type (e_todo_type_id,e_todo_type_label,e_todo_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 1 as e_todo_type_id, 'Follow-up' as e_todo_type_label, 'Follow-up' as e_todo_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* e_todo */

create table e_todo (
        e_todo_id                             integer  not null,       /* The todo ID --  */
        e_todo_type_id                        integer  not null,       /* The todo type ID --  */
        e_todo_desc                           varchar(255)  not null,  /* The description of this todo --  */
        e_todo_comments                       varchar(900)  null,      /* Misc comments about this todo item --  */
        e_todo_status                         char(1)  not null,       /* To-do item status: (I)ncomplete, (C)omplete, or (X) for canceled. --  */
        e_todo_completion_date                datetime  null,          /* Completion date for a To-do that has been completed. --  */
        e_todo_canceled_date                  datetime  null,          /* Cancellation date for a To-do that has been canceled. --  */
        e_todo_due_date                       datetime  null,          /* Due date for this to-do item --  */
        e_todo_collaborator                   char(10)  not null,      /* The collaborator that needs to do this todo item --  */
        e_todo_partner                        char(10)  null,          /* The engaging partner that this todo relates to --  */
        e_todo_engagement_id                  integer  null,           /* The engagement ID, if any, that this todo relates to --  */
        e_todo_document_id                    integer  null,           /* The document ID, if any, that this todo relates to --  */
        e_todo_req_item_id                    integer  null,           /* The requirement item ID, if any, that this todo relates to --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_data_item_type */

create table e_data_item_type (
        e_data_item_type_id                   integer  not null,       /* The data item type ID --  */
        e_parent_data_item_type_id            integer  null,           /* The parent data item type ID (hierarchy reference) --  */
        e_data_item_type_label                varchar(40)  not null,   /* A short data item type label --  */
        e_data_item_type_desc                 varchar(255)  null,      /* A description of this data item type --  */
        e_data_item_type_type                 varchar(16)  null,       /* Data type: string, integer, double, datetime, money --  */
        e_data_item_type_highlight            integer  null,           /* Set to 0 or null to not highlight this item, or 1 to highlight it on the profile page --  */
        e_data_item_type_highlight_if         varchar(64)  null,       /* If set, this is compared with the data item value and highlighted IF they match. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_data_item_type_value */

create table e_data_item_type_value (
        e_data_item_type_id                   integer  not null,       /* The data item type ID --  */
        e_data_item_value_id                  integer  not null,       /* An identifier for this unique value list item --  */
        e_data_item_string_value              varchar(999)  null,      /* The value of this data item. --  */
        e_data_item_integer_value             integer  null,           /* The value of this data item. --  */
        e_data_item_datetime_value            datetime  null,          /* The value of this data item. --  */
        e_data_item_double_value              float  null,             /* The value of this data item. --  */
        e_data_item_money_value               decimal(14,4)  null,     /* The value of this data item. --  */
        e_is_default                          bit  not null,           /* Whether this value is the default value. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_data_item_group */

create table e_data_item_group (
        e_data_item_group_id                  integer  not null,       /* The data item group ID --  */
        e_data_item_type_id                   integer  null,           /* The data item type hierarchy that this group relates to --  */
        e_data_item_group_name                varchar(80)  not null,   /* The name of this actual group --  */
        e_data_item_group_desc                varchar(255)  null,      /* A description of this group --  */
        p_partner_key                         char(10)  not null,      /* The engaging partner that this data item group is about --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_data_item */

create table e_data_item (
        e_data_item_id                        integer  not null,       /* The data item ID --  */
        e_data_item_type_id                   integer  not null,       /* The data item type ID --  */
        e_data_item_group_id                  integer  null,           /* The data item group ID --  */
        e_data_item_string_value              varchar(999)  null,      /* The value of this data item. --  */
        e_data_item_integer_value             integer  null,           /* The value of this data item. --  */
        e_data_item_datetime_value            datetime  null,          /* The value of this data item. --  */
        e_data_item_double_value              float  null,             /* The value of this data item. --  */
        e_data_item_money_value               decimal(14,4)  null,     /* The value of this data item. --  */
        e_data_item_highlight                 integer  null,           /* Set to 0 or null to not highlight this item, or 1 to highlight it on the profile page. Inherited from the data item type, but changeable for the particular data item. --  */
        p_partner_key                         char(10)  not null,      /* The engaging partner that this data item is about (denormalized from the data item group table) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_highlights */

create table e_highlights (
        e_highlight_user                      varchar(20)  not null,   /* The user that is viewing highlights. --  */
        e_highlight_partner                   char(10)  not null,      /* The partner for whom highlights are being viewed. --  */
        e_highlight_id                        varchar(64)  not null,   /* A unique name to identify the specific highlight. --  */
        e_highlight_name                      varchar(64)  not null,   /* The name of the data being displayed --  */
        e_highlight_type                      varchar(20)  not null,   /* The general type of the data being displayed --  */
        e_highlight_data                      varchar(900)  not null,  /* The data to be displayed --  */
        e_highlight_reference_info            varchar(255)  null,      /* Reference info to underlying data (e.g., primary key of underlying record) --  */
        e_highlight_precedence                float  not null,         /* A value between 0.0 and infinity, providing the precedence level of this information. The results will be sorted by this value descending. --  */
        e_highlight_strength                  float  not null,         /* The strength/level of this data (mainly used for tags). 0.0 renders with a white background. (x > 0.0) with various shades of green, and (x < 0.0) with various shades of red. --  */
        e_highlight_certainty                 float  not null,         /* The certainty of this data (mainly used for tags). (0.7 <= x < 1.0) renders normally. (0.3 <= x < 0.7) renders with a question mark. (0.0 <= x < 0.3) renders with two question marks. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_data_highlight */

create table e_data_highlight (
        e_highlight_subject                   varchar(40)  not null,   /* The user, group, and/or role (u:username, g:groupname, r:rolename, or ur:username:rolename), or * for a system-wide default --  */
        e_highlight_object_type               varchar(20)  not null,   /* The type of object being highlighted ("Address", "Tag", "Relationship", "Note", "ToDo", or DataItemTypeID) --  */
        e_highlight_object_id                 varchar(32)  not null,   /* The specific object ID being highlighted, or "*" to apply to all objects of this type --  */
        e_highlight_precedence                float  not null,         /* An value increasing (x > 1.0) or decreasing (0.0 < x < 1.0) the precedence of this information. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_ack */

create table e_ack (
        e_ack_id                              integer  not null,       /* The unique ID of this acknowledgement --  */
        e_object_type                         varchar(32)  not null,   /* The type of object that has been acknowledged --  */
        e_object_id                           varchar(32)  not null,   /* A unique ID identifying the object acknowledged --  */
        e_ack_type                            integer  not null,       /* The type of acknowledgement (viewed, prayed, comment, like, etc.) --  */
        e_ack_comments                        varchar(900)  null,      /* Comments related to this ACK (for example, if the ack is a comment on a post) --  */
        e_whom                                char(10)  not null,      /* The collaborator who acknowledged the object --  */
        p_dn_partner_key                      char(10)  null,          /* (denormalization) the partner key of the person who created the object being acknowledged. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_ack_type */

create table e_ack_type (
        e_ack_type                            integer  not null,       /* The unique ID of this ack type --  */
        e_ack_type_label                      varchar(40)  not null,   /* The short name of the acknowledgement type --  */
        e_ack_type_desc                       varchar(255)  not null,  /* The description of the acknowledgement type --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into e_ack_type (e_ack_type,e_ack_type_label,e_ack_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 1 as e_ack_type, 'Prayed' as e_ack_type_label, 'Prayed' as e_ack_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_ack_type (e_ack_type,e_ack_type_label,e_ack_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 2 as e_ack_type, 'Reply' as e_ack_type_label, 'Reply' as e_ack_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_ack_type (e_ack_type,e_ack_type_label,e_ack_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 3 as e_ack_type, 'Comment' as e_ack_type_label, 'Comment' as e_ack_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into e_ack_type (e_ack_type,e_ack_type_label,e_ack_type_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 4 as e_ack_type, 'Viewed' as e_ack_type_label, 'Viewed' as e_ack_type_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* e_trackactivity */

create table e_trackactivity (
        p_partner_key                         char(10)  not null,      /* The partner whose track information we are displaying --  */
        e_username                            varchar(20)  not null,   /* The username of the user viewing the partner --  */
        e_sort_key                            varchar(32)  not null,   /* Controls the display order (steps by sequence, requirements by step sequence and req ID) --  */
        e_track_id                            integer  not null,       /* The ID of the track being displayed --  */
        e_step_id                             integer  not null,       /* The ID of the step being displayed --  */
        e_object_type                         char(1)  not null,       /* 'S' for step and 'R' for requirement --  */
        e_completion_status                   char(1)  not null,       /* I/C/E for steps, I/C/W for requirements --  */
        e_object_name                         varchar(32)  not null,   /* The "name" of the step or requirement being displayed (for linkage to a data editing form) --  */
        e_object_label                        varchar(64)  not null,   /* The main visual label for the step or requirement --  */
        e_object_desc                         varchar(255)  not null,  /* The brief description of the step or requirement --  */
        e_object_comm                         varchar(900)  null,      /* Any comments associated with the step or requirement --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_text_expansion */

create table e_text_expansion (
        e_exp_tag                             varchar(16)  not null,   /* The short tag to be expanded --  */
        e_exp_desc                            varchar(64)  not null,   /* A brief description of the tag/expansion --  */
        e_exp_expansion                       varchar(900)  not null,  /* The expansion of the short tag (i.e., a phrase or paragraph). --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_text_search_word */

create table e_text_search_word (
        e_word_id                             integer  not null,       /* The ID of the word --  */
        e_word                                varchar(64)  not null,   /* The word --  */
        e_salt                                varchar(64)  null,       /* If set, indicates that the word is encrypted and this is the salt used. --  */
        e_word_relevance                      float  not null,         /* An overall relevance factor (0.0 to 1.0) for the word. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_text_search_rel */

create table e_text_search_rel (
        e_word_id                             integer  not null,       /* The ID of the word --  */
        e_target_word_id                      integer  not null,       /* The word --  */
        e_rel_relevance                       float  not null,         /* A relevance factor for the relationship --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* e_text_search_occur */

create table e_text_search_occur (
        e_word_id                             integer  not null,       /* The ID of the word --  */
        e_document_id                         integer  not null,       /* The word --  */
        e_sequence                            integer  not null,       /* The sequence in which the word occurs in the document --  */
        e_eol                                 bit  not null,           /* 1 = word was followed by a line break or other break in the original document --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* h_staff */

create table h_staff (
        p_partner_key                         char(10)  not null,      /* The partner key of the staff member --  */
        h_is_active                           bit,                     /* Set to 0 to disable this partner as a staff member. --  */
        h_start_date                          datetime  not null,      /* Original starting date for this staff member. --  */
        h_staff_role                          char(1)  not null,       /* Role of this staff member: (E)mployee, (V)olunteer, (N)one --  */
        h_percent_fulltime                    float  null,             /* Percent of full-time status. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* h_group */

create table h_group (
        h_group_id                            integer  not null,       /* The ID of this group --  */
        h_group_label                         varchar(64)  not null,   /* The label (short description) of the group --  */
        h_group_comments                      varchar(900)  null,      /* Comments/description for this group. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* h_group_member */

create table h_group_member (
        h_group_id                            integer  not null,       /* The ID of this group --  */
        p_partner_key                         char(10)  not null,      /* The ID of the partner that's in this group --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* h_holidays */

create table h_holidays (
        h_holiday_id                          integer  not null,       /* The ID of this holiday --  */
        h_group_id                            integer  null,           /* The group ID, if this holiday only applies to a particular group, otherwise null. --  */
        h_holiday_label                       varchar(64)  not null,   /* The label (short description) for the holiday. --  */
        h_holiday_date                        datetime  not null,      /* The date this holiday occurs on. --  */
        h_holiday_end_date                    datetime  null,          /* If the holiday is a limited number of hours, this shows the ending date/time. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* h_work_register */

create table h_work_register (
        p_partner_key                         char(10)  not null,      /* The partner key of the employee --  */
        h_work_register_id                    integer  not null,       /* Unique ID of the work register entry for this partner. --  */
        h_work_date                           datetime  not null,      /* Date that this work record applies to (date only, work times are in h_work_register_times) --  */
        h_work_hours                          float  null,             /* Number of hours the employee worked. --  */
        h_work_type                           char(1)  not null,       /* Type of work register entry: (N)ormal work, (T)imeoff used, (H)oliday used, (W)orked during a paid holiday --  */
        h_benefit_type_id                     integer  null,           /* If paid time off was used ('T', above), this is the h_benefit_type of the paid time off. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* h_work_register_times */

create table h_work_register_times (
        p_partner_key                         char(10)  not null,      /* The partner key of the employee --  */
        h_work_register_time_id               integer  not null,       /* Unique ID of the work register time entry for this partner. --  */
        h_work_start_date                     datetime  not null,      /* Date/time that the work began --  */
        h_work_end_date                       datetime  not null,      /* Date/time that the work ended --  */
        h_work_comments                       varchar(900)  null,      /* Comments about this particular work time interval --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* h_benefit_period */

create table h_benefit_period (
        h_benefit_period_id                   integer  not null,       /* The ID of the benefit period --  */
        h_benefit_period_label                varchar(64)  not null,   /* A label (short description) for the benefit period --  */
        h_benefit_period_start_date           datetime  not null,      /* The starting date for the period --  */
        h_benefit_period_end_date             datetime  not null,      /* The ending date for the period --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* h_benefit_type */

create table h_benefit_type (
        h_benefit_type_id                     integer  not null,       /* The ID of the benefit type --  */
        h_benefit_type_label                  varchar(64)  not null,   /* A label (short description) for the benefit type --  */
        h_benefit_type_abbrev                 varchar(16)  not null,   /* An abbreviation of the benefit type --  */
        h_benefit_type_color                  varchar(16)  not null,   /* Color used to represent the benefit in the UI --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* h_benefit_type_sched */

create table h_benefit_type_sched (
        h_benefit_type_id                     integer  not null,       /* The ID of the benefit type --  */
        h_benefit_type_sched_id               integer  not null,       /* A unique ID for the application of this benefit type --  */
        p_partner_key                         char(10)  null,          /* This is set if the schedule applies just to one person --  */
        h_group_id                            integer  null,           /* This is set if the schedule applies just to a specific group --  */
        h_min_years                           integer  null,           /* This is set if the schedule applies to a minimum # of years of service --  */
        h_max_years                           integer  null,           /* This is set if the schedule applies to a maximum # of years of service --  */
        h_benefit_mode                        char(1)  not null,       /* (L)imited to amount accrued, or (P)olicy-driven but not limited by system --  */
        h_new_benefits                        integer  not null,       /* The number of hours of new benefits accrued in the period --  */
        h_carryover_benefits                  integer  not null,       /* The number of hours of benefits that can be carried over from the prior period --  */
        h_accrual_threshold                   integer  not null,       /* The number of hours of benefits that must be accrued before any can be used --  */
        h_usage_increment                     integer  not null,       /* The increment (in hours) of this benefit that must be used (e.g. increments of 0.5 day or 4 hours) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* h_benefits */

create table h_benefits (
        h_benefit_type_id                     integer  not null,       /* The ID of the benefit type --  */
        p_partner_key                         char(10)  not null,      /* The partner for whom we're tracking benefits --  */
        h_benefit_period_id                   integer  not null,       /* The period in which we're tracking benefits --  */
        h_benefit_type_sched_id               integer  null,           /* The benefit type schedule item this was created from (unless manually created) --  */
        h_carried_over                        integer  not null,       /* The hours of benefits carried over from the prior year --  */
        h_newly_accrued                       integer  not null,       /* The hours of benefits newly accrued to the employee --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* r_group_sched */

create table r_group_sched (
        r_group_name                          char(8)  not null,       /* short name of the report group. --  */
        r_group_sched_id                      int  not null,           /* ID of the scheduled sending --  */
        r_group_sched_date                    datetime  not null,      /* Date that the group of reports will be sent --  */
        r_group_sched_status                  char(1)  not null,       /* N = not sent, S = sent, A = archived --  */
        r_group_sched_sent_by                 varchar(20)  null,       /* What user sent the reports? --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* r_group_sched_param */

create table r_group_sched_param (
        r_group_name                          char(8)  not null,       /* short name of the report group that this parameter belongs to --  */
        r_group_sched_id                      int  not null,           /* ID of this scheduled report run --  */
        r_param_name                          varchar(64)  not null,   /* name of the parameter --  */
        r_param_value                         varchar(900)  null,      /* value for the parameter (in string format). --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* r_group_sched_report */

create table r_group_sched_report (
        r_group_name                          char(8)  not null,       /* short name of the report group. --  */
        r_delivery_method                     varchar(1)  not null,    /* method of delivery - Email/Web/Print --  */
        r_group_sched_id                      int  not null,           /* ID of the scheduled sending --  */
        p_recipient_partner_key               char(10)  not null,      /* Recipient of the report --  */
        r_report_id                           int  not null,           /* ID of the report (a person can receive more than one report of a given type/group, e.g. with different parameters) --  */
        r_group_sched_address                 varchar(80)  null,       /* The address (e.g. email) that this report was actually sent to, or attempted to be sent to. --  */
        r_group_sched_status                  char(1)  not null,       /* N = not sent, S = sent, T = temporary error / will be retried, I = invalid email address error, F = other error / failure --  */
        r_group_sched_error                   varchar(900)  null,      /* Textual error message from email sending facility --  */
        r_group_sched_sent_date               datetime  null,          /* Date/time that this report was actually sent --  */
        r_group_sched_file                    varchar(900)  null,      /* OSML pathname where the generated report is stored. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* r_group */

create table r_group (
        r_group_name                          char(8)  not null,       /* short name of the report group. --  */
        r_group_description                   varchar(255)  null,      /* description of the report group --  */
        r_group_module                        varchar(20)  not null,   /* directory name of the module containing the report to run (e.g., 'base', 'rcpt', 'disb', etc.) --  */
        r_group_file                          varchar(255)  not null,  /* file name of the .rpt file in the above module. --  */
        r_group_template_file                 varchar(255)  null,      /* file name of a mail merge / template document (txt file) to be used --  */
        r_is_active                           bit,                     /* Whether or not the group is 'active'. Kardia may come with many preconfigured report groups that are not activated by the user yet. --  */
        r_send_empty                          bit,                     /* Whether or not to send an "empty" report with no data internally. Only supported for reports that have an is_empty out parameter. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* r_group_report */

create table r_group_report (
        r_group_name                          char(8)  not null,       /* short name of the report group. --  */
        r_delivery_method                     varchar(1)  not null,    /* method of delivery - Email/Web/Print --  */
        p_recipient_partner_key               char(10)  not null,      /* to whom we are sending this report --  */
        r_report_id                           integer  not null,       /* an ID representing a unique report of this type received by this partner (can be many) --  */
        r_is_active                           bit,                     /* Whether or not the report is 'active'. We may need to enable/disable particular reports in the group from time to time. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* r_group_param */

create table r_group_param (
        r_group_name                          char(8)  not null,       /* short name of the report group that this parameter belongs to --  */
        r_param_name                          varchar(64)  not null,   /* name of the parameter --  */
        r_param_description                   varchar(255)  null,      /* description of the report parameter --  */
        r_is_group_param                      bit,                     /* whether this parameter can be supplied by the user running the report group --  */
        r_is_report_param                     bit,                     /* whether this parameter can be supplied by individual reports in the group --  */
        r_is_sched_param                      bit,                     /* whether this parameter can be supplied by the scheduled report run --  */
        r_is_required                         bit,                     /* whether this parameter MUST be supplied --  */
        r_pass_to_report                      bit,                     /* whether this parameter will be passed to the .rpt object --  */
        r_pass_to_template                    bit,                     /* whether this parameter can be used for mail merge / template substitution --  */
        r_param_cmp_module                    varchar(64)  null,       /* component module (directory name) used for getting user input on this parameter. --  */
        r_param_cmp_file                      varchar(256)  null,      /* component file (.cmp) used for getting user input on this parameter. --  */
        r_param_ui_sequence                   integer  null,           /* sequence the parameter comes in when presented to the user in the UI. --  */
        r_param_default                       varchar(1536)  null,     /* default value for the parameter (in string format). --  */
        r_param_default_expr                  varchar(1536)  null,     /* expression to determine default value of the parameter --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* r_group_report_param */

create table r_group_report_param (
        r_group_name                          char(8)  not null,       /* short name of the report group that this parameter belongs to --  */
        r_delivery_method                     char(1)  not null,       /* delivery method (Email, Web, Print) --  */
        p_recipient_partner_key               char(10)  not null,      /* partner key of report recipient --  */
        r_report_id                           integer  not null,       /* represents a unique report of this type received by this partner (can be many) --  */
        r_param_name                          varchar(64)  not null,   /* name of the parameter --  */
        r_param_value                         varchar(900)  null,      /* value for the parameter (in string format). --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* r_saved_paramset */

create table r_saved_paramset (
        r_paramset_id                         int  not null,           /* unique id for the parameter set --  */
        r_paramset_desc                       varchar(255)  null,      /* description of the parameter set --  */
        r_module                              varchar(20)  not null,   /* directory name of the module containing the report to run (e.g., 'base', 'rcpt', 'disb', etc.) --  */
        r_file                                varchar(255)  not null,  /* file name of the .rpt file in the above module. --  */
        r_is_personal                         bit,                     /* Set to 1 if the parameter set is available only to its creator. Otherwise, everyone can see the parameter set. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* r_saved_param */

create table r_saved_param (
        r_paramset_id                         int  not null,           /* unique id for the parameter set --  */
        r_param_name                          varchar(64)  not null,   /* name of the parameter --  */
        r_param_value                         varchar(1536)  null,     /* parameter's value --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_config */

create table a_config (
        a_ledger_number                       char(10)  not null,      /* ledger number (alphanumeric allowed) --  */
        a_config_name                         char(16)  not null,      /* configuration parameter name --  */
        a_config_value                        varchar(255)  null,      /* configuration parameter value --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_analysis_attr */

create table a_analysis_attr (
        a_attr_code                           char(8)  not null,       /* analysis attribute code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this attribute --  */
        a_desc                                varchar(255)  not null,  /* description of attribute --  */
        a_fund_enab                           bit  not null,           /* whether to enable this attr for funds --  */
        a_acct_enab                           bit  not null,           /* whether to enable this attr for GL accounts --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_analysis_attr_value */

create table a_analysis_attr_value (
        a_attr_code                           char(8)  not null,       /* analysis attribute code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this attribute --  */
        a_value                               varchar(255)  not null,  /* one possible value for this analysis attribute --  */
        a_desc                                varchar(255)  null,      /* description for this value --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_fund_analysis_attr */

create table a_fund_analysis_attr (
        a_attr_code                           char(8)  not null,       /* analysis attribute code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this attribute --  */
        a_fund                                char(20)  not null,      /* fund --  */
        a_value                               varchar(255)  null,      /* analysis attribute value --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_acct_analysis_attr */

create table a_acct_analysis_attr (
        a_attr_code                           char(8)  not null,       /* analysis attribute code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this attribute --  */
        a_account_code                        char(16)  not null,      /* GL account code --  */
        a_value                               varchar(255)  null,      /* analysis attribute value --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_fund */

create table a_fund (
        a_fund                                char(20)  not null,      /* fund code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this fund --  */
        a_parent_fund                         char(20)  null,          /* fund that this data rolls up into for reporting (within same ledger) --  */
        a_bal_fund                            char(20)  not null,      /* a_bal_fund = a_is_balancing?a_fund:a_parent_fund --  */
        a_fund_class                          char(3)  null,           /* classification (could be others too): (ADM)inistration & General, (FUN)draising, (MIN)istry / Program Services. --  */
        a_reporting_level                     int  not null,           /* at what detail level should this fund be shown (in reports); smaller number = less detail, more generalized report --  */
        a_is_posting                          bit,                     /* enables posting to this fund --  */
        a_is_external                         bit,                     /* Does the fund represent a subdivision of the local entity, or is it foreign/external? --  */
        a_is_balancing                        bit,                     /* Is this a true fund which self-balances (satisfies the accounting equation), or is it merely a fund within a fund? --  */
        a_restricted_type                     char(1)  not null,       /* Fund restriction code: N = not restricted, T = temporarily restricted, P = permanently restricted --  */
        a_fund_desc                           char(32)  null,          /* short description of fund, for reporting --  */
        a_fund_comments                       varchar(255)  null,      /* comments / long description of fund --  */
        a_legacy_code                         varchar(32)  null,       /* Legacy fund code, from data import --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_account */

create table a_account (
        a_account_code                        char(16)  not null,      /* account code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this account --  */
        a_parent_account_code                 char(16)  null,          /* account that this data rolls up into for reporting (within same ledger) --  */
        a_acct_type                           char(1)  not null,       /* type of account: (A)sset, (L)iability, (Q)Equity, (R)evenue, (E)xpense --  */
        a_account_class                       char(3)  null,           /* classification (used for managing which accts go with which fund) --  */
        a_reporting_level                     int  not null,           /* at what detail level should this account be shown (in reports); smaller number = less detail, more generalized report --  */
        p_banking_details_key                 char(10)  null,          /* esp. for Asset accounts, this is the relevant bank account data --  */
        a_is_contra                           bit,                     /* is this a contra account - if so a_parent_account_code gives main account it balances against --  */
        a_is_posting                          bit,                     /* enables posting to this account --  */
        a_is_inverted                         bit,                     /* should the account total be inverted for reporting (credit vs debit account) --  */
        a_is_intrafund_xfer                   bit,                     /* account is used for intra-fund transfers --  */
        a_is_interfund_xfer                   bit,                     /* account is used for inter-fund transfers --  */
        a_acct_desc                           varchar(32)  not null,   /* short description of account for reporting --  */
        a_acct_comment                        varchar(255)  null,      /* comments / long description of account --  */
        a_legacy_code                         varchar(32)  null,       /* Legacy account code from data import --  */
        a_default_category                    char(8)  null,           /* default category (control acct) for this gl account. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_account_usage */

create table a_account_usage (
        a_acct_usage_code                     char(4)  not null,       /* account usage code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* applicable ledger number --  */
        a_account_code                        char(16)  not null,      /* the account to use --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_account_usage_type */

create table a_account_usage_type (
        a_acct_usage_code                     char(4)  not null,       /* account usage code (alphanumeric allowed) --  */
        a_acct_type                           char(1)  not null,       /* type of account that must be selected: (A)sset, (L)iability, (Q)Equity, (R)evenue, (E)xpense --  */
        a_acct_usage_desc                     varchar(32)  not null,   /* short description of account usage for reporting --  */
        a_acct_usage_comment                  varchar(255)  null,      /* comments / long description of account usage --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "IFTE" as a_acct_usage_code, "E" as a_acct_type, "Inter-Fund Transfer Expense" as a_acct_usage_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "IFTR" as a_acct_usage_code, "R" as a_acct_type, "Inter-Fund Transfer Revenue" as a_acct_usage_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "ICTE" as a_acct_usage_code, "E" as a_acct_type, "Inter-CostCtr Transfer Expense" as a_acct_usage_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "ICTR" as a_acct_usage_code, "R" as a_acct_type, "Inter-CostCtr Transfer Revenue" as a_acct_usage_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "ILTE" as a_acct_usage_code, "E" as a_acct_type, "Inter-Ledger Transfer Expense" as a_acct_usage_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "ILTR" as a_acct_usage_code, "R" as a_acct_type, "Inter-Ledger Transfer Revenue" as a_acct_usage_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* a_account_category */

create table a_account_category (
        a_account_category                    char(8)  not null,       /* account code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this account --  */
        a_acct_type                           char(1)  not null,       /* type of account that this category applies to: (A)sset, (L)iability, (Q)Equity, (R)evenue, (E)xpense --  */
        a_is_intrafund_xfer                   bit,                     /* account is used for intra-fund transfers --  */
        a_is_interfund_xfer                   bit,                     /* account is used for inter-fund transfers --  */
        a_acct_cat_desc                       varchar(32)  not null,   /* short description of account for reporting --  */
        a_acct_cat_comment                    varchar(255)  null,      /* comments / long description of account --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_fund_acct */

create table a_fund_acct (
        a_ledger_number                       char(10)  not null,      /* ledger number --  */
        a_period                              char(8)  not null,       /* the high level accounting period (i.e., year) --  */
        a_fund                                char(20)  not null,      /* fund code --  */
        a_account_code                        char(16)  not null,      /* GL account code --  */
        a_fund_acct_class                     char(3)  null,           /* classification (could be others too): (ADM)inistration & General, (FUN)draising, (MIN)istry / Program Services. --  */
        a_opening_balance                     decimal(14,4)  not null,
                                                                      /* opening balance for the period (year) --  */
        a_current_balance                     decimal(14,4)  not null,
                                                                      /* current balance for the period (year) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_period */

create table a_period (
        a_period                              char(8)  not null,       /* accounting period (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number (alphanumeric allowed) --  */
        a_parent_period                       char(8)  null,           /* period that this period summarizes into (month -> quarter -> year). Normally NULL for the year. --  */
        a_status                              char(1)  not null,       /* accounting period status (N)ever opened, (O)pen for transactions, (C)losed, (A)rchived --  */
        a_summary_only                        bit,                     /* Set this if the period is for summary use only (e.g., quarters and years) and does not actually take transactions --  */
        a_start_date                          datetime  not null,      /* date, in principle, that this accounting period begins --  */
        a_end_date                            datetime  not null,      /* date, in principle, that this accounting period ends --  */
        a_first_opened                        datetime  null,          /* date the period was actually first opened --  */
        a_last_closed                         datetime  null,          /* date the period was actually last closed --  */
        a_archived                            datetime  null,          /* date the period was archived --  */
        a_period_desc                         varchar(32)  null,       /* short description of period, for reporting --  */
        a_period_comment                      varchar(255)  null,      /* comments / long description of accounting period --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_period_usage */

create table a_period_usage (
        a_period_usage_code                   char(4)  not null,       /* period usage code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* applicable ledger number --  */
        a_period                              char(8)  not null,       /* the period to use --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_period_usage_type */

create table a_period_usage_type (
        a_period_usage_code                   char(4)  not null,       /* period usage code (alphanumeric allowed) --  */
        a_period_usage_desc                   varchar(32)  not null,   /* short description of period usage for reporting --  */
        a_period_usage_comment                varchar(255)  null,      /* comments / long description of period usage --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into a_period_usage_type (a_period_usage_code,a_period_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "GIFT" as a_period_usage_code, "Gift Entry Default Period" as a_period_usage_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_period_usage_type (a_period_usage_code,a_period_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "CURR" as a_period_usage_code, "General Default Period" as a_period_usage_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_period_usage_type (a_period_usage_code,a_period_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "YEAR" as a_period_usage_code, "General Default Year" as a_period_usage_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* a_ledger */

create table a_ledger (
        a_ledger_number                       char(10)  not null,      /* ledger number (alphanumeric allowed) --  */
        a_is_posting                          bit,                     /* enables posting to this ledger --  */
        a_next_batch_number                   integer  null,           /* next batch number for creation of new batches --  */
        a_ledger_desc                         varchar(32)  null,       /* short description of ledger, for reporting --  */
        a_ledger_comment                      varchar(255)  null,      /* comments / long description of ledger --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_batch */

create table a_batch (
        a_batch_number                        integer  not null,       /* Batch identification code. --  */
        a_ledger_number                       char(10)  not null,      /* ledger number for this batch. --  */
        a_period                              char(8)  not null,       /* accounting period for this batch. --  */
        a_batch_desc                          varchar(255)  null,      /* description of batch --  */
        a_next_journal_number                 integer  default 0  null,
                                                                      /* counter of next journal id to use --  */
        a_next_transaction_number             integer  default 0  null,
                                                                      /* counter of next transaction id to use --  */
        a_default_effective_date              datetime  null,          /* default effective date to use for transactions in this batch --  */
        a_origin                              char(2)  null,           /* origin module for batch - e.g., CR, CD, PP, GL --  */
        s_process_code                        char(3)  null,           /* process/workflow for this batch --  */
        s_process_status_code                 char(1)  null,           /* process status for this batch - e.g., (N)ew, Posted In (O)rigin, (U)nposted, (P)osted --  */
        a_corrects_batch_number               integer  null,           /* If set, indicates a batch# that this batch corrects. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_transaction */

create table a_transaction (
        a_ledger_number                       char(10)  not null,      /* ledger number for this transaction. --  */
        a_batch_number                        integer  not null,       /* Batch id for this transaction. --  */
        a_journal_number                      integer  not null,       /* journal id for this transaction. --  */
        a_transaction_number                  integer  not null,       /* transaction id --  */
        a_period                              char(8)  not null,       /* Accounting period this transaction is recorded in. --  */
        a_effective_date                      datetime  not null,      /* Effective date of transaction (e.g., accrual date) --  */
        a_transaction_type                    char(1)  not null,       /* B=Beginning balance, E=Ending (closing of exp/rev into equity), T=Transaction (normal) --  */
        a_fund                                char(20)  not null,      /* Fund this transaction is posted to. --  */
        a_account_category                    char(8)  not null,       /* Broad category of account (object) --  */
        a_account_code                        char(16)  not null,      /* GL Account that this transaction is posted to --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of debit or credit --  */
        a_posted                              bit  default 0,          /* Has this transaction been posted - yes (1) or no (0)? --  */
        a_modified                            bit  default 0,          /* Has this transaction been hand-edited (1) or auto-generated without hand edit (0)? --  */
        a_corrected                           bit  default 0,          /* Has a correcting transaction been posted affecting this entry - yes (1) or no (0)? --  */
        a_correcting                          bit  default 0,          /* Does this transaction correct a previous transaction? yes(1) or no(0) --  */
        a_corrected_batch                     integer  null,           /* If a_correcting=1, which batch# is being corrected? --  */
        a_corrected_journal                   integer  null,           /* If a_correcting=1, which journal# is being corrected? --  */
        a_corrected_transaction               integer  null,           /* If a_correcting=1, which transaction# is being corrected? --  */
        a_reconciled                          bit  default 0,          /* Has this transaction been reconciled externally (e.g., our check deposited, their check cleared, etc.) - yes (1) or no (0)? --  */
        a_postprocessed                       bit  default 0,          /* Has postprocessing been done yet for this transaction (e.g., admin charges on gifts) - yes (1) or no (0)? --  */
        a_postprocess_type                    char(2)  not null,       /* Type of postprocessing to be done for this transaction (e.g., admin charge), "XX" = none --  */
        a_origin                              char(2)  not null,       /* Subsystem of origin (or "MN" for manually entered) E.g., "AP" accounts payable, "AR" accounts receivable, etc. --  */
        a_recv_document_id                    varchar(64)  null,       /* External supporting document that we received (e.g., gift check number, etc.) --  */
        a_sent_document_id                    varchar(64)  null,       /* Supporting document that we generated/sent (e.g., receipt number, our check number, etc.) --  */
        p_ext_partner_id                      char(10)  null,          /* Partner ID of external entity (e.g., gift donor, payee for a check, etc.) --  */
        p_int_partner_id                      char(10)  null,          /* Partner ID of internal entity (e.g., gift "recipient", etc.) --  */
        a_legacy_code                         varchar(20)  null,       /* Legacy key or record number for referencing a pre-conversion transaction. --  */
        a_receipt_sent                        bit  default 0,          /* *** Receipt sent to donor --  */
        a_receipt_desired                     bit  default 0,          /* *** Receipt needed -- should be "1" for all gifts unless otherwise specified --  */
        a_first_gift                          bit  default 0,          /* *** Donor's first gift? --  */
        a_gift_type                           char(1)  null,           /* *** Type of Gift? --  */
        a_goods_provided                      decimal(14,4)  default 0.00  null,
                                                                      /* *** Amount of gift that is considered a fee for goods provided in return --  */
        a_gift_received_date                  datetime  null,          /* *** Date a gift actually was received by the office --  */
        a_gift_postmark_date                  datetime  null,          /* *** Date a gift was postmarked (if available) --  */
        a_comment                             varchar(255)  null,      /* Transaction comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_transaction_tmp */

create table a_transaction_tmp (
        a_ledger_number                       char(10)  not null,      /* ledger number for this transaction. --  */
        a_batch_number                        integer  not null,       /* Batch id for this transaction. --  */
        a_journal_number                      integer  not null,       /* journal id for this transaction. --  */
        a_transaction_number                  integer  not null,       /* transaction id --  */
        a_period                              char(8)  not null,       /* Accounting period this transaction is recorded in. --  */
        a_effective_date                      datetime  not null,      /* Effective date of transaction (e.g., accrual date) --  */
        a_transaction_type                    char(1)  not null,       /* B=Beginning balance, E=Ending (closing of exp/rev into equity), T=Transaction (normal) --  */
        a_fund                                char(20)  not null,      /* Fund this transaction is posted to. --  */
        a_account_category                    char(8)  not null,       /* Broad category of account (object) --  */
        a_account_code                        char(16)  not null,      /* GL Account that this transaction is posted to --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of debit or credit --  */
        a_posted                              bit  default 0,          /* Has this transaction been posted - yes (1) or no (0)? --  */
        a_modified                            bit  default 0,          /* Has this transaction been hand-edited (1) or auto-generated without hand edit (0)? --  */
        a_corrected                           bit  default 0,          /* Has a correcting transaction been posted affecting this entry - yes (1) or no (0)? --  */
        a_correcting                          bit  default 0,          /* Does this transaction correct a previous transaction? yes(1) or no(0) --  */
        a_corrected_batch                     integer  null,           /* If a_correcting=1, which batch# is being corrected? --  */
        a_corrected_journal                   integer  null,           /* If a_correcting=1, which journal# is being corrected? --  */
        a_corrected_transaction               integer  null,           /* If a_correcting=1, which transaction# is being corrected? --  */
        a_reconciled                          bit  default 0,          /* Has this transaction been reconciled externally (e.g., our check deposited, their check cleared, etc.) - yes (1) or no (0)? --  */
        a_postprocessed                       bit  default 0,          /* Has postprocessing been done yet for this transaction (e.g., admin charges on gifts) - yes (1) or no (0)? --  */
        a_postprocess_type                    char(2)  not null,       /* Type of postprocessing to be done for this transaction (e.g., admin charge), "XX" = none --  */
        a_origin                              char(2)  not null,       /* Subsystem of origin (or "MN" for manually entered) E.g., "AP" accounts payable, "AR" accounts receivable, etc. --  */
        a_recv_document_id                    varchar(64)  null,       /* External supporting document that we received (e.g., gift check number, etc.) --  */
        a_sent_document_id                    varchar(64)  null,       /* Supporting document that we generated/sent (e.g., receipt number, our check number, etc.) --  */
        p_ext_partner_id                      char(10)  null,          /* Partner ID of external entity (e.g., gift donor, payee for a check, etc.) --  */
        p_int_partner_id                      char(10)  null,          /* Partner ID of internal entity (e.g., gift "recipient", etc.) --  */
        a_legacy_code                         varchar(20)  null,       /* Legacy key or record number for referencing a pre-conversion transaction. --  */
        a_receipt_sent                        bit  default 0,          /* *** Receipt sent to donor --  */
        a_receipt_desired                     bit  default 0,          /* *** Receipt needed -- should be "1" for all gifts unless otherwise specified --  */
        a_first_gift                          bit  default 0,          /* *** Donor's first gift? --  */
        a_gift_type                           char(1)  null,           /* *** Type of Gift? --  */
        a_goods_provided                      decimal(14,4)  default 0.00  null,
                                                                      /* *** Amount of gift that is considered a fee for goods provided in return --  */
        a_gift_received_date                  datetime  null,          /* *** Date a gift actually was received by the office --  */
        a_gift_postmark_date                  datetime  null,          /* *** Date a gift was postmarked (if available) --  */
        a_comment                             varchar(255)  null,      /* Transaction comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_account_class */

create table a_account_class (
        a_account_class                       char(3)  not null,       /* account class (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this account class --  */
        a_acct_class_desc                     varchar(255)  not null,  /* description of account class --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_fund_class */

create table a_fund_class (
        a_fund_class                          char(3)  not null,       /* fund class (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this fund class --  */
        a_fund_class_desc                     varchar(255)  not null,  /* description of fund class --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_reporting_level */

create table a_reporting_level (
        a_reporting_level                     int  not null,           /* reporting level number --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this reporting level --  */
        a_level_desc                          varchar(32)  not null,   /* short description of reporting level --  */
        a_level_rpt_desc                      varchar(32)  not null,   /* short description of level, for report creation dialogs --  */
        a_level_comment                       varchar(255)  null,      /* comments / long description --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_fund_prefix */

create table a_fund_prefix (
        a_fund_prefix                         char(20)  not null,      /* fund prefix (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this fund prefix --  */
        a_fund_prefix_desc                    char(32)  null,          /* short description of fund prefix, for reporting --  */
        a_fund_prefix_comments                varchar(255)  null,      /* comments / long description of fund prefix --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_fund_staff */

create table a_fund_staff (
        a_ledger_number                       char(10)  not null,      /* ledger number (a_ledger) --  */
        a_fund                                char(20)  not null,      /* fund code (a_fund) --  */
        p_staff_partner_key                   varchar(10)  not null,   /* Partner key (p_partner) --  */
        p_start_date                          datetime  null,          /* starting date that data is available to fund manager --  */
        p_end_date                            datetime  null,          /* ending date that data is available to fund manager --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_ledger_office */

create table a_ledger_office (
        a_ledger_number                       char(10)  not null,      /* ledger number (a_ledger) --  */
        p_office_partner_key                  varchar(10)  not null,   /* Partner key of Office (p_partner) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_currency */

create table a_currency (
        a_ledger_number                       char(10)  not null,      /* ledger number (a_ledger) --  */
        a_currency_code                       char(3)  not null,       /* Code for this currency --  */
        a_currency_desc                       varchar(64)  not null,   /* Description for this currency --  */
        a_enabled                             bit  not null,           /* Whether this currency can be selected in data entry or not --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_currency_exch_rate */

create table a_currency_exch_rate (
        a_ledger_number                       char(10)  not null,      /* ledger number (a_ledger) --  */
        a_base_currency_code                  char(3)  not null,       /* The base currency --  */
        a_foreign_currency_code               char(3)  not null,       /* The foreign currency --  */
        a_exch_rate_date                      datetime  not null,      /* The effective date for the exchange rate (date only) --  */
        a_exch_rate                           float  not null,         /* The exchange rate. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_payroll */

create table a_payroll (
        a_ledger_number                       char(10)  not null,      /* ledger number that will be doing the payroll. --  */
        a_payroll_group_id                    integer  not null,       /* group ID for this payroll entry --  */
        a_payroll_id                          integer  not null,       /* unique ID for this payroll entry --  */
        p_payee_partner_key                   char(10)  not null,      /* partner ID of the payee. --  */
        a_payee_name                          char(80)  null,          /* if necessary, this can be used to adjust the name used in payroll. --  */
        a_priority                            integer  null,           /* if more than one payroll in a fund, this sets the priority (higher number = higher priority) --  */
        a_payroll_interval                    char(2)  not null,       /* interval (OW = once weekly, BW = biweekly, OD = daily, SM = semimonthly, OM = once monthly, MS = misc) --  */
        a_fund                                char(20)  not null,      /* Fund that this payroll takes place within --  */
        a_start_date                          datetime  null,          /* starting date that this payroll record applies to --  */
        a_end_date                            datetime  null,          /* ending date that this payroll record applies to --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_payroll_period */

create table a_payroll_period (
        a_ledger_number                       char(10)  not null,      /* ledger number (alphanumeric allowed) --  */
        a_payroll_group_id                    integer  not null,       /* payroll group ID --  */
        a_payroll_period                      char(12)  not null,      /* payroll period (alphanumeric allowed) --  */
        a_period                              char(8)  not null,       /* accounting period for this payroll period. --  */
        a_start_date                          datetime  not null,      /* first date that wages were earned this period. --  */
        a_end_date                            datetime  not null,      /* last date that wages were earned in this period. --  */
        a_accrual_date                        datetime  not null,      /* date wages are accounted for. Typically same as a_end_date on accrual setups, same as a_pay_date on cash or modified cash setups. --  */
        a_pay_date                            datetime  not null,      /* date wages are actually paid / paychecks disbursed --  */
        a_payroll_period_desc                 varchar(40)  null,       /* short description of payroll period, for reporting --  */
        a_payroll_period_comment              varchar(255)  null,      /* comments / long description of payroll period --  */
        a_posted                              bit  not null,           /* whether this period has been posted to GL --  */
        a_batch_number                        int  null,               /* GL batch number for this period --  */
        a_checks_batch_number                 int  null,               /* GL batch number for checks issued for this period --  */
        a_base_on_period                      char(12)  null,          /* Which period this period's data was based on. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_payroll_period_payee */

create table a_payroll_period_payee (
        a_ledger_number                       char(10)  not null,      /* ledger number (alphanumeric allowed) --  */
        a_payroll_group_id                    integer  not null,       /* payroll group ID --  */
        a_payroll_period                      char(12)  not null,      /* payroll period (alphanumeric allowed) --  */
        a_payroll_id                          integer  not null,       /* Payee ID --  */
        a_comment                             varchar(255)  null,      /* comments for this payee --  */
        p_country_code                        char(2)  null,           /* country that this payee's withholdings are done for --  */
        p_state_province                      char(2)  null,           /* state or province this payee's withholdings are done for. --  */
        a_is_employee                         bit  not null,           /* whether this payee is an "employee" for legal purposes (employee vs 1099 in the US) --  */
        a_is_fica                             bit  not null,           /* whether this payee uses FICA withholdings (1, US only), or SECA (0) --  */
        a_is_exempt                           bit  not null,           /* whether this payee is exempt from wage and hour law --  */
        a_is_salaried                         bit  not null,           /* whether this payee is paid a salary (1) or hourly (0) --  */
        a_minimum_wage                        decimal(14,4)  null,     /* the statutory minimum wage that applies to this employee --  */
        a_hours_worked                        float  null,             /* the TOTAL hours worked by this employee during this pay period --  */
        a_overtime_hours_worked               float  null,             /* the overtime hours worked during this pay period --  */
        a_base_hourly_pay                     decimal(14,4)  null,     /* The employee's base pay rate per hour --  */
        a_base_pay                            decimal(14,4)  null,     /* The employee's total base pay --  */
        a_overtime_pay                        decimal(14,4)  null,     /* the employee's overtime additional pay --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_payroll_group */

create table a_payroll_group (
        a_ledger_number                       char(10)  not null,      /* ledger number that will be doing the payroll. --  */
        a_payroll_group_id                    integer  not null,       /* unique ID for this payroll group --  */
        a_payroll_group_name                  char(80)  null,          /* the name of this payroll group --  */
        a_payroll_interval                    char(2)  not null,       /* interval (OW = once weekly, BW = biweekly, OD = daily, SM = semimonthly, OM = once monthly, MS = misc) --  */
        a_acct_method                         char(1)  not null,       /* accounting method: (A)ccrual - pay accrues on last date of pay period, or (C)ash - pay accrues on payment date --  */
        a_paydate_delay                       integer  not null,       /* the number of days after end date of period when payroll is typically paid (0 for issue on exact end date) --  */
        a_fund                                char(20)  not null,      /* default fund that this payroll takes place within (can be overridden on payee entries) --  */
        a_liab_fund                           char(20)  null,          /* fund to xfer payroll liabilities to, if any --  */
        a_cash_fund                           char(20)  null,          /* fund for handling cash for payroll, if any --  */
        a_issue_checks                        bit  not null,           /* whether we write the checks (1) or some outside entity does (0) and we just record the total transaction. --  */
        a_service_bureau_id                   integer  null,           /* partner id of payroll service bureau that is being used, if any --  */
        a_service_bureau_group_name           varchar(64)  null,       /* identifier of this payroll group at the payroll service bureau --  */
        a_start_date                          datetime  null,          /* starting date that this payroll group applies to --  */
        a_end_date                            datetime  null,          /* ending date that this payroll group applies to --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_payroll_import */

create table a_payroll_import (
        a_payroll_id                          integer  not null,       /* unique ID for this payroll entry --  */
        p_payee_partner_key                   char(10)  not null,      /* partner ID of the payee. --  */
        a_payee_name                          char(80)  null,          /* if necessary, this can be used to adjust the name used in payroll. --  */
        a_priority                            integer  null,           /* if more than one payroll in a fund, this sets the priority (higher number = higher priority) --  */
        a_payroll_interval                    char(2)  not null,       /* interval (OW = once weekly, BW = biweekly, OD = daily, SM = semimonthly, OM = once monthly, MS = misc) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that will be doing the payroll. --  */
        a_fund                                char(20)  not null,      /* fund that this payroll takes place within --  */
        a_start_date                          datetime  null,          /* starting date that this payroll record applies to --  */
        a_end_date                            datetime  null,          /* ending date that this payroll record applies to --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_payroll_item */

create table a_payroll_item (
        a_ledger_number                       char(8)  not null,       /* ledger number for this pay item --  */
        a_payroll_group_id                    integer  not null,       /* unique ID for this payroll group -> a_payroll_group:a_payroll_group_id --  */
        a_payroll_id                          integer  not null,       /* unique ID for this payroll entry -> a_payroll:a_payroll_id --  */
        a_payroll_item_id                     integer  not null,       /* unique ID for this payroll item --  */
        a_payroll_item_type_code              char(4)  not null,       /* type of payroll item -> a_payroll_item_type --  */
        a_is_instance                         bit  default 0,          /* set to 1 if this is an actual instance of payroll, rather than the template --  */
        a_period                              char(8)  null,           /* if this is an instance, a_period contains the relevant accounting period --  */
        a_effective_date                      datetime  null,          /* if this is an instance, this field specifies the effective date for the payroll --  */
        a_target_amount                       decimal(14,4)  null,     /* target amount of currency, such as amount for gross pay --  */
        a_actual_amount                       decimal(14,4)  null,     /* actual amount of currency used, for payroll item instances --  */
        a_minimum_amount                      decimal(14,4)  null,     /* if amount is flexible, this specifies the minimum --  */
        a_percent                             float  null,             /* if this is a percentage-based item, the percent goes here --  */
        a_filing_status                       char(1)  null,           /* for tax withholding, the filing status. --  */
        a_allowances                          integer  null,           /* for tax withholding, the number of withholding allowances claimed (e.g., on W4) --  */
        a_dependent_allowances                integer  null,           /* for tax withholding, the number of withholding allowances claimed for dependents (some states, such as Georgia/Indiana) --  */
        a_ref_fund                            char(20)  null,          /* for receivables/payables/etc, the fund to check --  */
        a_ref_account_code                    char(10)  null,          /* for receivables/payables/etc, the gl account to check --  */
        a_xfer_fund                           char(20)  null,          /* for line items that reference an outside fund. --  */
        a_xfer_account_code                   char(10)  null,          /* gl acct to use in outside fund. --  */
        a_start_date                          datetime  null,          /* starting date that this payroll item record applies to --  */
        a_end_date                            datetime  null,          /* ending date that this payroll item record applies to --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_payroll_item_import */

create table a_payroll_item_import (
        a_payroll_id                          integer  not null,       /* unique ID for this payroll entry -> a_payroll:a_payroll_id --  */
        a_payroll_item_id                     integer  not null,       /* unique ID for this payroll item --  */
        a_payroll_item_type_code              char(4)  not null,       /* type of payroll item -> a_payroll_item_type --  */
        a_is_instance                         bit  default 0,          /* set to 1 if this is an actual instance of payroll, rather than the template --  */
        a_period                              char(8)  null,           /* if this is an instance, a_period contains the relevant accounting period --  */
        a_effective_date                      datetime  null,          /* if this is an instance, this field specifies the effective date for the payroll --  */
        a_target_amount                       decimal(14,4)  null,     /* target amount of currency, such as amount for gross pay --  */
        a_actual_amount                       decimal(14,4)  null,     /* actual amount of currency used, for payroll item instances --  */
        a_minimum_amount                      decimal(14,4)  null,     /* if amount is flexible, this specifies the minimum --  */
        a_percent                             float  null,             /* if this is a percentage-based item, the percent goes here --  */
        a_filing_status                       char(1)  null,           /* for tax withholding, the filing status. --  */
        a_allowances                          integer  null,           /* for tax withholding, the number of withholding allowances claimed (e.g., on W4) --  */
        a_dependent_allowances                integer  null,           /* for tax withholding, the number of withholding allowances claimed for dependents (some states, such as Georgia/Indiana) --  */
        a_ref_fund                            char(20)  null,          /* for receivables/payables/etc, the fund to check --  */
        a_ref_account_code                    char(10)  null,          /* for receivables/payables/etc, the gl account to check --  */
        a_xfer_fund                           char(20)  null,          /* for line items that reference an outside fund. --  */
        a_xfer_account_code                   char(10)  null,          /* gl acct to use in outside fund. --  */
        a_start_date                          datetime  null,          /* starting date that this payroll item record applies to --  */
        a_end_date                            datetime  null,          /* ending date that this payroll item record applies to --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_payroll_item_type */

create table a_payroll_item_type (
        a_ledger_number                       char(10)  not null,      /* ledger number that will be doing the payroll. --  */
        a_payroll_item_type_code              char(4)  not null,       /* code for this payroll item type --  */
        a_payroll_item_class_code             char(1)  not null,       /* general category of payroll item --  */
        a_payroll_item_subclass_code          char(2)  null,           /* specific category of payroll item --  */
        a_payroll_item_form_sequence          integer  null,           /* order this item comes in on the payroll form. --  */
        a_ref_account_code                    char(10)  null,          /* default GL account code to use for items of this type --  */
        a_xfer_fund                           char(20)  null,          /* default fund to use when this item involves an xfer --  */
        a_xfer_account_code                   char(10)  null,          /* default gl account to use when this item involves an xfer --  */
        a_state_province                      char(2)  null,           /* State/Province that this tax table relates to. --  */
        a_desc                                varchar(32)  null,       /* description for this code --  */
        a_exempt_from_tax                     varchar(255)  null,      /* if this line item is excluded from tax (for "G"ross or for post-tax deductions), or included in tax (for "pre-tax" deductions), this is a list of tax line item types that are excluded/included. --  */
        a_comment                             varchar(255)  null,      /* comments for this code --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_payroll_item_class */

create table a_payroll_item_class (
        a_payroll_item_class_code             char(1)  not null,       /* payroll item class code --  */
        a_desc                                varchar(32)  null,       /* description for this code --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'A' as a_payroll_item_class_code, 'Available Funds' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'R' as a_payroll_item_class_code, 'Pre-Tax Receivables' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'T' as a_payroll_item_class_code, 'Tax Withholding' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'V' as a_payroll_item_class_code, 'Post-Tax Receivables' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'X' as a_payroll_item_class_code, 'Exemption from Tax' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'B' as a_payroll_item_class_code, 'Pre-Tax Benefit' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'D' as a_payroll_item_class_code, 'Post-Tax Deduction' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'E' as a_payroll_item_class_code, 'Employer Tax' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'G' as a_payroll_item_class_code, 'Gross Pay' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'I' as a_payroll_item_class_code, 'Informational' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'M' as a_payroll_item_class_code, 'Non-Tax Payables' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'N' as a_payroll_item_class_code, 'Net Pay' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_class (a_payroll_item_class_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'P' as a_payroll_item_class_code, 'Pre-Payroll Transaction' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* a_payroll_item_subclass */

create table a_payroll_item_subclass (
        a_payroll_item_class_code             char(1)  not null,       /* payroll item class code --  */
        a_payroll_item_subclass_code          char(2)  not null,       /* payroll item subclass code --  */
        a_desc                                varchar(32)  null,       /* description for this subclass --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into a_payroll_item_subclass (a_payroll_item_class_code,a_payroll_item_subclass_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'T' as a_payroll_item_class_code, 'TI' as a_payroll_item_subclass_code, 'FICA' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_subclass (a_payroll_item_class_code,a_payroll_item_subclass_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'T' as a_payroll_item_class_code, 'TF' as a_payroll_item_subclass_code, 'Federal Income' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_subclass (a_payroll_item_class_code,a_payroll_item_subclass_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'T' as a_payroll_item_class_code, 'TS' as a_payroll_item_subclass_code, 'State Income' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_subclass (a_payroll_item_class_code,a_payroll_item_subclass_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'T' as a_payroll_item_class_code, 'TL' as a_payroll_item_subclass_code, 'Local' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_payroll_item_subclass (a_payroll_item_class_code,a_payroll_item_subclass_code,a_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select 'T' as a_payroll_item_class_code, 'TU' as a_payroll_item_subclass_code, 'State Unemployment' as a_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* a_payroll_form_group */

create table a_payroll_form_group (
        a_ledger_number                       char(8)  not null,       /* ledger number for the organization --  */
        a_payroll_form_group_name             varchar(80)  not null,   /* name for the group of payroll items --  */
        a_payroll_form_sequence               integer  not null,       /* ascending numerical sequence to put the payroll form elements in --  */
        a_payroll_item_type_code              char(3)  not null,       /* payroll item type code to display --  */
        a_payroll_form_desc                   varchar(255)  null,      /* description to print next to the payroll form item --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_tax_filingstatus */

create table a_tax_filingstatus (
        a_ledger_number                       char(10)  not null,      /* ledger number (alphanumeric allowed) --  */
        a_payroll_item_type_code              char(3)  not null,       /* payroll item type --  */
        a_filing_status                       char(1)  not null,       /* filing status code --  */
        a_desc                                varchar(255)  not null,  /* description of filing status --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_tax_table */

create table a_tax_table (
        a_tax_entry_id                        integer  not null,       /* synthetic primary key --  */
        a_payroll_item_type                   char(4)  not null,       /* payroll item type code that uses this tax table (of type 'T') --  */
        a_ledger_number                       char(10)  not null,      /* ledger number (alphanumeric allowed) --  */
        a_start_date                          datetime  not null,      /* beginning date that this table is valid. --  */
        a_end_date                            datetime  not null,      /* last date that this table is valid. --  */
        a_payroll_interval                    char(2)  not null,       /* interval (OW = once weekly, BW = biweekly, OD = daily, SM = semimonthly, OM = once monthly, MS = misc) --  */
        a_filing_status                       char(1)  not null,       /* for tax withholding, the filing status. --  */
        a_minimum_salary                      decimal(14,4)  not null,
                                                                      /* minimum salary amount that this item applies to --  */
        a_maximum_salary                      decimal(14,4)  not null,
                                                                      /* maximum salary amount that this item applies to --  */
        a_subtract_salary                     decimal(14,4)  not null,
                                                                      /* amount to subtract from salary before computing percentage --  */
        a_percent                             float  not null,         /* percent of tax --  */
        a_add_to_tax                          decimal(14,4)  not null,
                                                                      /* amount to add to tax after percent is computed --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_tax_allowance_table */

create table a_tax_allowance_table (
        a_tax_allowance_entry_id              integer  not null,       /* synthetic primary key --  */
        a_payroll_item_type                   char(4)  not null,       /* payroll item type code that uses this tax table (of type 'T') --  */
        a_ledger_number                       char(10)  not null,      /* ledger number (alphanumeric allowed) --  */
        a_start_date                          datetime  not null,      /* beginning date that this table is valid. --  */
        a_end_date                            datetime  not null,      /* last date that this table is valid. --  */
        a_payroll_interval                    char(2)  not null,       /* interval (OW = once weekly, BW = biweekly, OD = daily, SM = semimonthly, OM = once monthly, MS = misc) --  */
        a_filing_status                       char(1)  not null,       /* for tax withholding, the filing status. --  */
        a_flat_deduction_amt                  decimal(14,4)  not null,
                                                                      /* amount of flat deduction from salary (e.g., "standard deduction" for some states) --  */
        a_allowance                           decimal(14,4)  not null,
                                                                      /* amount to deduct for "personal" tax allowances, or a more generalized "number of exemptions". --  */
        a_dependent_allowance                 decimal(14,4)  not null,
                                                                      /* amount to deduct for "dependent" tax allowances, for states that make this distinction. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_salary_review */

create table a_salary_review (
        a_ledger_number                       char(10)  not null,      /* ledger number for this payroll --  */
        a_payroll_id                          integer  not null,       /* ID for this payroll --  */
        a_review                              varchar(16)  not null,   /* ID of the support review we're working with - from the Donor system. --  */
        a_target_payroll                      decimal(14,4)  not null,
                                                                      /* Target (desired) salary --  */
        a_interval                            integer  not null,       /* Payroll interval type (semimonthly, monthly, etc.) --  */
        a_percentage                          float  not null,         /* Adjustment percentage applied --  */
        a_actual_payroll                      decimal(14,4)  not null,
                                                                      /* Actual (adjusted) salary - as adjusted by percentage and any required rounding --  */
        a_comment                             varchar(255)  null,      /* Any comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_fund_admin_fee */

create table a_fund_admin_fee (
        a_fund                                char(20)  not null,      /* fund code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this fund --  */
        a_admin_fee_type                      char(3)  not null,       /* admin fee type to apply to this fund (and subsidiaries) --  */
        a_default_subtype                     char(1)  null,           /* default subtype to use for gifts to this fund --  */
        a_percentage                          float  null,             /* percent to deduct for this fund, if different from a_admin_fee_type:a_default_percentage --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_admin_fee_type */

create table a_admin_fee_type (
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this admin fee type --  */
        a_admin_fee_type                      char(3)  not null,       /* admin fee type --  */
        a_admin_fee_subtype                   char(1)  not null,       /* admin fee subtype - e.g., for variable percentages. --  */
        a_admin_fee_type_desc                 varchar(255)  not null,  /* description of this admin fee type --  */
        a_is_default_subtype                  bit  default 0,          /* set to 1 to make this subtype the default one. --  */
        a_default_percentage                  float  not null,         /* percent of gift for entire admin fee type --  */
        a_tmp_total_percentage                float  null,             /* (tmp use) - total of item percentages --  */
        a_tmp_fixed_percentage                float  null,             /* (tmp use) - total of "fixed" (non-proportional) item percentages --  */
        a_comment                             varchar(255)  null,      /* comments for this admin fee type --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_admin_fee_type_tmp */

create table a_admin_fee_type_tmp (
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this admin fee type --  */
        a_admin_fee_type                      char(3)  not null,       /* admin fee type --  */
        a_admin_fee_subtype                   char(1)  not null,       /* admin fee subtype - e.g., for variable percentages. --  */
        a_admin_fee_type_desc                 varchar(255)  not null,  /* description of this admin fee type --  */
        a_is_default_subtype                  bit  default 0,          /* set to 1 to make this subtype the default one. --  */
        a_default_percentage                  float  not null,         /* percent of gift for entire admin fee type --  */
        a_tmp_total_percentage                float  null,             /* (tmp use) - total of item percentages --  */
        a_tmp_fixed_percentage                float  null,             /* (tmp use) - total of "fixed" (non-proportional) item percentages --  */
        a_comment                             varchar(255)  null,      /* comments for this admin fee type --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_admin_fee_type_item */

create table a_admin_fee_type_item (
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this admin fee type --  */
        a_admin_fee_type                      char(3)  not null,       /* admin fee type --  */
        a_admin_fee_subtype                   char(1)  not null,       /* admin fee subtype - e.g., for variable percentages. --  */
        a_dest_fund                           char(20)  not null,      /* destination fund for the admin fee proceeds --  */
        a_percentage                          float  not null,         /* percent of gift to go to the above fund --  */
        a_is_fixed                            bit  default 0,          /* if fee is scaled up or down, will the scaling apply to this fee item? --  */
        a_comment                             varchar(255)  null,      /* comments for this admin fee type item --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_admin_fee_type_item_tmp */

create table a_admin_fee_type_item_tmp (
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this admin fee type --  */
        a_admin_fee_type                      char(3)  not null,       /* admin fee type --  */
        a_admin_fee_subtype                   char(1)  not null,       /* admin fee subtype - e.g., for variable percentages. --  */
        a_dest_fund                           char(20)  not null,      /* destination fund for the admin fee proceeds --  */
        a_percentage                          float  not null,         /* percent of gift to go to the above fund --  */
        a_is_fixed                            bit  default 0,          /* if fee is scaled up or down, will the scaling apply to this fee item? --  */
        a_comment                             varchar(255)  null,      /* comments for this admin fee type item --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_fund_receipting */

create table a_fund_receipting (
        a_fund                                char(20)  not null,      /* fund code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this fund --  */
        a_receiptable                         bit  default 1,          /* can we receipt revenue (gifts) into this account? --  */
        a_disposition                         char(1)  null,           /* Donor management disposition of fund: N = not interesting, O = one-time gifts typical, R = recurring gifts typical --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_fund_receipting_accts */

create table a_fund_receipting_accts (
        a_fund                                char(20)  not null,      /* fund code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this fund --  */
        a_account_code                        char(16)  not null,      /* a GL account that we can receipt into for this fund. --  */
        a_non_tax_deductible                  bit  default 0,          /* are cash receipts tax deductible? --  */
        a_is_default                          bit  default 0,          /* is this the default receipting acct for this fund? --  */
        a_receipt_comment                     varchar(64)  null,       /* text to use in place of a_fund_desc from a_fund, when printing receipts. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_receipt_type */

create table a_receipt_type (
        a_receipt_type                        char(1)  not null,       /* receipt type --  */
        a_receipt_type_desc                   varchar(64)  not null,   /* receipt type description --  */
        a_is_default                          bit  default 0,          /* is this the default receipt type? --  */
        a_is_enabled                          bit  default 1,          /* is this receipt type enabled? --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into a_receipt_type (a_receipt_type,a_receipt_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "I" as a_receipt_type, "Immediate" as a_receipt_type_desc, 1 as a_is_default, 1 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_receipt_type (a_receipt_type,a_receipt_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "N" as a_receipt_type, "None" as a_receipt_type_desc, 0 as a_is_default, 1 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_receipt_type (a_receipt_type,a_receipt_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "A" as a_receipt_type, "Annual" as a_receipt_type_desc, 0 as a_is_default, 0 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_receipt_type (a_receipt_type,a_receipt_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "Q" as a_receipt_type, "Quarterly" as a_receipt_type_desc, 0 as a_is_default, 0 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_receipt_type (a_receipt_type,a_receipt_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "M" as a_receipt_type, "Monthly" as a_receipt_type_desc, 0 as a_is_default, 0 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* a_gift_payment_type */

create table a_gift_payment_type (
        a_ledger_number                       char(10)  not null,      /* ledger number --  */
        a_gift_payment_type                   char(1)  not null,       /* payment type --  */
        a_gift_payment_type_desc              varchar(64)  not null,   /* payment type description --  */
        a_is_default                          bit  default 0,          /* is this the default payment type? --  */
        a_is_enabled                          bit  default 1,          /* is this payment type enabled? --  */
        a_is_cash                             bit  default 1,          /* is this payment type a cash (check, cash, credit card, etc.) or noncash (in-kind) gift? --  */
        a_payment_fund                        char(20)  null,          /* fund for payment (defaults to value in a_config) --  */
        a_payment_account_code                char(16)  null,          /* GL account for payment (defaults to value in a_config) --  */
        a_desig_account_code                  char(16)  null,          /* GL account code for designations, to force a specific one --  */
        a_min_gift                            decimal(14,4)  null,     /* Minimum gift for this payment type --  */
        a_max_gift                            decimal(14,4)  null,     /* Maximum gift for this payment type --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into a_gift_payment_type (a_gift_payment_type,a_gift_payment_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "K" as a_gift_payment_type, "Check" as a_gift_payment_type_desc, 1 as a_is_default, 1 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_gift_payment_type (a_gift_payment_type,a_gift_payment_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "C" as a_gift_payment_type, "Cash" as a_gift_payment_type_desc, 0 as a_is_default, 1 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_gift_payment_type (a_gift_payment_type,a_gift_payment_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "E" as a_gift_payment_type, "EFT" as a_gift_payment_type_desc, 0 as a_is_default, 1 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_gift_payment_type (a_gift_payment_type,a_gift_payment_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "D" as a_gift_payment_type, "Credit Card" as a_gift_payment_type_desc, 0 as a_is_default, 1 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_gift_payment_type (a_gift_payment_type,a_gift_payment_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "N" as a_gift_payment_type, "In-Kind Non-Capitalized" as a_gift_payment_type_desc, 0 as a_is_default, 0 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into a_gift_payment_type (a_gift_payment_type,a_gift_payment_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "I" as a_gift_payment_type, "In-Kind Capitalized" as a_gift_payment_type_desc, 0 as a_is_default, 0 as a_is_enabled, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* a_receipt_mailing */

create table a_receipt_mailing (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        m_list_code                           varchar(20)  not null,   /* Code for the mailing list associated with receipting --  */
        a_prev_issue_lookback                 integer  null,           /* Number of days to look back for a previous issue if the donor hasn't yet gotten issue --  */
        a_prev_issue_max_interval             float  null,             /* Maximum giving interval for lookback to happen (1.0 = monthly, 3.0 = quarterly, etc.) --  */
        a_comment                             varchar(255)  null,      /* Comment about the use of this mailing list in receipting --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_gift */

create table a_subtrx_gift (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        a_batch_number                        integer  not null,       /* Batch id for this gift. --  */
        a_gift_number                         integer  not null,       /* sequential gift number in the batch. --  */
        a_period                              char(8)  not null,       /* Accounting period this transaction is recorded in. --  */
        a_fund                                char(20)  not null,      /* Which fund the gift is given to. --  */
        a_account_code                        char(16)  not null,      /* Which GL Account this gift posts to in the above fund. --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of the gift. --  */
        a_posted                              bit  default 0,          /* Has this transaction been posted (in this table)? --  */
        a_posted_to_gl                        bit  default 0,          /* Has this transaction been posted to the GL - yes (1) or no (0)? --  */
        a_gift_type                           char(1)  not null,       /* Type of gift: (C)ash, chec(K), credit car(D), (E)FT --  */
        a_gift_admin_fee                      float  null,             /* Total administration fee percent to use (optionally specified by user) --  */
        a_gift_admin_subtype                  char(1)  null,           /* Admin fee subtype to use (overrides that specified in a_fund_admin_fee) --  */
        a_calc_admin_fee                      float  null,             /* Total administration fee percent as calculated by the system (set by admin fee logic) --  */
        a_calc_admin_fee_type                 char(3)  null,           /* admin fee type as calculated by the system (set by admin fee logic) --  */
        a_calc_admin_fee_subtype              char(1)  null,           /* admin fee subtype as calculated by the system (set by admin fee logic) --  */
        a_recv_document_id                    varchar(64)  null,       /* Check number, transaction number, etc., for received gift. --  */
        a_receipt_number                      varchar(64)  null,       /* Receipt number that we sent out --  */
        p_donor_partner_id                    char(10)  null,          /* Partner ID of donor --  */
        p_recip_partner_id                    char(10)  null,          /* Partner ID of gift recipient. May not be needed for non-pool based financial setups. --  */
        a_receipt_sent                        bit  default 0,          /* Receipt sent to donor --  */
        a_receipt_desired                     bit  default 0,          /* Receipt needed -- should be "1" for all gifts unless otherwise specified --  */
        a_anonymous_gift                      bit  default 0,          /* Set this if the donor wishes to remain anonymous (to the recipient) --  */
        a_personal_gift                       bit  default 0,          /* Set this if the gift is a personal gift (i.e., payable to missionary instead of support gift) --  */
        a_first_gift                          bit  default 0,          /* Donor's first gift? --  */
        a_goods_provided                      decimal(14,4)  default 0.00  null,
                                                                      /* Amount of gift that is considered a fee for goods provided in return --  */
        a_gift_received_date                  datetime  null,          /* Date a gift actually was received by the office --  */
        a_gift_postmark_date                  datetime  null,          /* Date a gift was postmarked (if available) --  */
        a_receipt_sent_date                   datetime  null,          /* Date the receipt was sent to the donor --  */
        a_comment                             varchar(255)  null,      /* Gift comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_gift_group */

create table a_subtrx_gift_group (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        a_batch_number                        integer  not null,       /* Batch id for this gift. --  */
        a_gift_number                         integer  not null,       /* sequential gift number in the batch. --  */
        a_period                              char(8)  not null,       /* Accounting period this transaction is recorded in. --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of the gift. --  */
        a_foreign_amount                      decimal(14,4)  null,     /* Amount of the gift in the donor's foreign currency --  */
        a_foreign_currency                    char(3)  null,           /* Foreign currency code for this gift. --  */
        a_foreign_currency_exch_rate          float  null,             /* Foreign currency effective exchange rate --  */
        a_foreign_currency_date               float  null,             /* Foreign currency effective date for exchange rate --  */
        a_posted                              bit  default 0,          /* Has this transaction been posted (in this table)? --  */
        a_posted_to_gl                        bit  default 0,          /* Has this transaction been posted to the GL - yes (1) or no (0)? --  */
        a_gift_type                           char(1)  not null,       /* Type of gift: (C)ash, chec(K), credit car(D), (E)FT --  */
        a_receipt_number                      varchar(64)  null,       /* Receipt number that we sent out --  */
        p_donor_partner_id                    char(10)  null,          /* Partner ID of donor --  */
        p_ack_partner_id                      char(10)  null,          /* Partner ID to send non-receipt acknowledgment to --  */
        p_pass_partner_id                     char(10)  null,          /* Partner ID of pass-through entity --  */
        a_receipt_sent                        bit  default 0,          /* Receipt sent to donor --  */
        a_ack_receipt_sent                    bit  default 0,          /* Acknowledgement sent --  */
        a_receipt_desired                     char(1)  default 'I'  null,
                                                                      /* Receipt needed -- 'I' for immediate, 'A' for annual, 'N' for no receipt --  */
        a_ack_receipt_desired                 char(1)  null,           /* Acknowledgement needed -- 'I' for immediate, 'A' for annual, 'N' for no receipt --  */
        a_first_gift                          bit  default 0,          /* Donor's first gift? --  */
        a_goods_provided                      decimal(14,4)  default 0.00  null,
                                                                      /* Amount of gift that is considered a fee for goods provided in return --  */
        a_gift_received_date                  datetime  null,          /* Date a gift actually was received by the office --  */
        a_gift_postmark_date                  datetime  null,          /* Date a gift was postmarked (if available) --  */
        a_receipt_sent_date                   datetime  null,          /* Date the receipt was sent to the donor --  */
        a_ack_receipt_sent_date               datetime  null,          /* Date the acknowledgement was sent --  */
        a_comment                             varchar(900)  null,      /* Gift comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_gift_item */

create table a_subtrx_gift_item (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        a_batch_number                        integer  not null,       /* Batch id for this gift. --  */
        a_gift_number                         integer  not null,       /* sequential gift number in the batch. --  */
        a_split_number                        integer  not null,       /* sequential split number for line items in a gift (split gift between multiple designations) --  */
        a_period                              char(8)  not null,       /* Accounting period this transaction is recorded in. --  */
        a_fund                                char(20)  not null,      /* Which fund the gift is given to. --  */
        a_account_code                        char(16)  not null,      /* Which GL Account this gift posts to in the above fund. --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of the gift. --  */
        a_foreign_amount                      decimal(14,4)  null,     /* Amount of the gift in the donor's foreign currency --  */
        a_foreign_currency                    char(3)  null,           /* Foreign currency code for this gift. --  */
        a_foreign_currency_exch_rate          float  null,             /* Foreign currency effective exchange rate --  */
        a_foreign_currency_date               float  null,             /* Foreign currency effective date for exchange rate --  */
        a_recv_document_id                    varchar(64)  null,       /* Check number, transaction number, etc., for received gift. --  */
        a_account_hash                        varchar(256)  null,      /* Argon2id hash of the routing number and account number. --  */
        a_check_front_image                   varchar(256)  null,      /* Image of the front of the check (relative to /apps/kardia/files/rcpt/check_images) --  */
        a_check_back_image                    varchar(256)  null,      /* Image of the back of the check (relative to /apps/kardia/files/rcpt/check_images) --  */
        a_posted                              bit  default 0,          /* Has this transaction been posted (in this table)? --  */
        a_posted_to_gl                        bit  default 0,          /* Has this transaction been posted to the GL - yes (1) or no (0)? --  */
        a_gift_admin_fee                      float  null,             /* Total administration fee percent to use (optionally specified by user) --  */
        a_gift_admin_subtype                  char(1)  null,           /* Admin fee subtype to use (overrides that specified in a_fund_admin_fee) --  */
        a_calc_admin_fee                      float  null,             /* Total administration fee percent as calculated by the system (set by admin fee logic) --  */
        a_calc_admin_fee_type                 char(3)  null,           /* admin fee type as calculated by the system (set by admin fee logic) --  */
        a_calc_admin_fee_subtype              char(1)  null,           /* admin fee subtype as calculated by the system (set by admin fee logic) --  */
        p_recip_partner_id                    char(10)  null,          /* Partner ID of gift recipient. May not be needed for non-pool based financial setups. --  */
        a_confidential                        bit  default 0,          /* Set this if the donor wishes to remain anonymous (to the recipient) --  */
        a_non_tax_deductible                  bit  default 0,          /* Set this if the gift is a non-tax-deductible gift, such as a personal gift (i.e., payable to missionary instead of support gift) --  */
        a_motivational_code                   varchar(16)  null,       /* Optional motivational code that indicates what motivated the donor to give this gift. --  */
        a_item_intent_code                    char(1)  null,           /* Giver intention for this line item - different from intent type. E.g. Extra, Recurring, Increase, Decrease, LastGift, AsAble, OneTime. --  */
        a_comment                             varchar(255)  null,      /* Gift comments --  */
        i_eg_source_key                       varchar(255)  null,      /* If imported, this is the key value for i_eg_gift_import. --  */
        p_dn_donor_partner_id                 char(10)  null,          /* **Denormalized** Partner ID of gift donor. --  */
        p_dn_ack_partner_id                   char(10)  null,          /* **Denormalized** Partner ID to send gift acknowledgement. --  */
        p_dn_pass_partner_id                  char(10)  null,          /* **Denormalized** Partner ID of gift pass-through entity. --  */
        a_dn_receipt_number                   varchar(64)  null,       /* **Denormalized** Receipt number we sent out. --  */
        a_dn_gift_received_date               datetime  null,          /* **Denormalized** Date gift was received --  */
        a_dn_gift_postmark_date               datetime  null,          /* **Denormalized** Date gift was postmarked --  */
        a_dn_gift_type                        char(1)  null,           /* **Denormalized** Gift type (C/K/E/D). --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_gift_intent */

create table a_subtrx_gift_intent (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        a_batch_number                        integer  not null,       /* Batch id for this gift. --  */
        a_gift_number                         integer  not null,       /* sequential gift number in the batch. --  */
        a_intent_number                       integer  not null,       /* intent number for this gift --  */
        a_split_number                        integer  null,           /* the split gift ID, if this gift references a specific split gift item, otherwise NULL. --  */
        a_pledge_id                           integer  null,           /* Reference to pledges table to associate this gift intent with a pledge --  */
        p_dn_donor_partner_id                 char(10)  not null,      /* Donor ID making the pledge - denormalized (from gift_group) --  */
        p_dn_ack_partner_id                   char(10)  null,          /* Acknowledgement ID making the pledge - denormalized (from gift_group) --  */
        a_fund                                char(20)  null,          /* Fund being pledged to --  */
        a_intent_type                         varchar(1)  not null,    /* Intent type: P=pledge, F=faith promise, I=intention --  */
        a_amount                              decimal(14,4)  null,     /* Amount for this intent (e.g. monthly amount) - UI should default copy from gift data --  */
        a_total_amount                        decimal(14,4)  null,     /* Total amount for this intent (e.g. total pledge) --  */
        a_start_date                          datetime  null,          /* Starting date - UI should default copy from gift data --  */
        a_end_date                            datetime  null,          /* Ending date / due date - default is null --  */
        a_giving_interval                     integer  null,           /* Giving interval: 1=monthly, 12=annually, NULL=total or as-able --  */
        a_gift_count                          integer  null,           /* Number of gifts intended (NULL for unknown/no limit) --  */
        a_comment                             varchar(255)  null,      /* Comment about this intent or pledge --  */
        a_autogen                             bit  not null,           /* Auto-generated by matching in the UI --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_gift_rcptcnt */

create table a_subtrx_gift_rcptcnt (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        a_next_receipt_number                 integer  not null,       /* next receipt number to use for receipting --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_fund_auto_subscribe */

create table a_fund_auto_subscribe (
        a_fund                                char(20)  not null,      /* fund code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this fund --  */
        m_list_code                           varchar(20)  not null,   /* the mailing list code of the mailing to subscribe the donor to. --  */
        a_minimum_gift                        decimal(14,4)  null,     /* sets a minimum gift before automatic subscription takes place. --  */
        a_subscribe_months                    integer  null,           /* how many months to subscribe the donor (or indefinitely, if null) --  */
        a_comments                            varchar(255)  null,      /* comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_motivational_code */

create table a_motivational_code (
        a_motivational_code                   char(16)  not null,      /* motivational code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this motivational code --  */
        a_motivational_code_status            char(1)  not null,       /* status of this motivational code: A=Active, O=Obsolete. --  */
        a_parent_motivational_code            varchar(16)  null,       /* motivational code parent or category --  */
        m_list_code                           varchar(20)  null,       /* (Optional) mailing list associated with this motivational code --  */
        a_fund                                varchar(20)  null,       /* Optional fund associated with this motivational code --  */
        a_account_code                        varchar(16)  null,       /* Optional GL account associated with this motivational code --  */
        a_gift_admin_fee                      float  null,             /* Optional override percentage for admin fees for gifts on this motiv code. --  */
        a_gift_admin_subtype                  char(1)  null,           /* Optional override admin subtype for admin fees for gifts on this motiv code. --  */
        a_gift_comment                        varchar(255)  null,      /* Optional comment to auto-fill the gift comment field. --  */
        a_comments                            varchar(255)  null,      /* comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_giving_pattern */

create table a_giving_pattern (
        a_ledger_number                       char(10)  not null,      /* ledger number for this giving pattern --  */
        p_donor_partner_key                   char(10)  not null,      /* Partner ID for the donor --  */
        a_fund                                char(20)  not null,      /* fund that this donor is giving toward --  */
        a_pattern_id                          integer  not null,       /* sequential integer ID of this giving pattern record. --  */
        a_history_id                          integer  not null,       /* sequential integer ID of the history of this giving pattern record. --  */
        a_review                              varchar(16)  null,       /* An identifier for the support review this entry is associated with --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of money the donor is giving --  */
        a_interval                            integer  null,           /* Month interval at which the donor is giving (1=monthly, 3=quarterly, 12=annually, 0=onetime/as-able, null=unknown) --  */
        a_is_active                           bit  default 1,          /* Is this giving pattern an active one? --  */
        a_start_date                          datetime  not null,      /* Date that this donor began this current giving pattern --  */
        a_end_date                            datetime  null,          /* Date that we expect the donor to end this giving pattern (NOT A LEGAL OBLIGATION ON THE DONOR'S PART) --  */
        a_evaluation_date                     datetime  not null,      /* Date that this giving pattern was determined --  */
        a_actual_fund                         char(20)  null,          /* Actual fund that the donor donated to, if not to the one listed above. --  */
        a_percent                             float  null,             /* Percent of gift (0.00 to 1.00) allocated to this fund, if a_actual_fund is supplied. --  */
        a_comment                             varchar(255)  null,      /* Giving pattern comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_giving_pattern_allocation */

create table a_giving_pattern_allocation (
        a_ledger_number                       char(10)  not null,      /* ledger number for this giving pattern --  */
        p_donor_partner_key                   char(10)  not null,      /* Partner ID for the donor --  */
        a_fund                                char(20)  not null,      /* fund that this donor is giving toward --  */
        a_pattern_id                          integer  not null,       /* sequential integer ID of this giving pattern record. --  */
        a_history_id                          integer  not null,       /* sequential integer ID of the history of this giving pattern record. --  */
        a_review                              varchar(16)  null,       /* An identifier for the support review this entry is associated with --  */
        a_actual_fund                         char(20)  not null,      /* Actual fund that the donor donated to --  */
        a_percent                             float  not null,         /* Percent of gift (0.00 to 1.00) allocated to this fund --  */
        a_comment                             varchar(255)  null,      /* Comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_giving_pattern_flag */

create table a_giving_pattern_flag (
        a_ledger_number                       char(10)  not null,      /* ledger number for this giving pattern --  */
        p_donor_partner_key                   char(10)  not null,      /* Partner ID for the donor --  */
        a_fund                                char(20)  not null,      /* fund that this donor is giving toward --  */
        a_pattern_id                          integer  not null,       /* sequential integer ID of this giving pattern record. --  */
        a_history_id                          integer  not null,       /* sequential integer ID of the giving pattern flag (since past/historical ones are kept around). However this DOES NOT relate to the history ID in the a_giving_pattern table. --  */
        a_review                              varchar(16)  null,       /* An identifier for the support review this flag is associated with, if any --  */
        a_prior_interval                      integer  null,           /* The recorded giving interval at the time this flag was generated. --  */
        a_prior_amount                        decimal(14,4)  null,     /* The recorded giving amount at the time this flag was generated. --  */
        a_flag_type                           char(3)  not null,       /* The type of flag (see _a_flag_type validation table) --  */
        a_flag_resolution                     char(3)  null,           /* How this flag was resolved (NULL if not yet resolved, or see _a_flag_resolution for values) --  */
        a_new_interval                        integer  null,           /* If the resolution involved a new giving interval, this specifies it. --  */
        a_new_amount                          decimal(14,4)  null,     /* If the resolution involved changing the giving amount, this specifies it. --  */
        a_comment                             varchar(255)  null,      /* Comment generated for this flag. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_funding_target */

create table a_funding_target (
        a_ledger_number                       char(10)  not null,      /* ledger number for the fund --  */
        a_fund                                char(20)  not null,      /* fund that we're establishing a target for --  */
        a_target_id                           integer  not null,       /* sequential integer ID of this funding target record. --  */
        a_target_desc                         varchar(255)  not null,  /* Description for this funding target --  */
        a_review                              varchar(16)  null,       /* Support review ID that this target is connected with, if available --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of money for the target --  */
        a_interval                            integer  not null,       /* Month interval for the funding target (0=absolute, 1=monthly, 3=quarterly, 12=annually) --  */
        a_start_date                          datetime  not null,      /* Date that this funding target begins --  */
        a_end_date                            datetime  null,          /* Date that this funding target ends --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_support_review */

create table a_support_review (
        a_ledger_number                       char(10)  not null,      /* ledger number for this giving pattern --  */
        a_review                              varchar(16)  not null,   /* An identifier for the support review this entry is associated with --  */
        a_review_date                         datetime  not null,      /* Date that this review was done --  */
        a_review_desc                         varchar(255)  not null,  /* Support review description --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_support_review_target */

create table a_support_review_target (
        a_ledger_number                       char(10)  not null,      /* ledger number for this fund --  */
        a_fund                                char(20)  not null,      /* fund that is being reviewed --  */
        a_target_id                           integer  not null,       /* ID of the funding target we're working with --  */
        a_review                              varchar(16)  not null,   /* ID of the support review we're looking at --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of money that was actually raised thusfar --  */
        a_target_amount                       decimal(14,4)  not null,
                                                                      /* The target that was supposed to be raised (from funding_target) --  */
        a_comment                             varchar(255)  null,      /* Any comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_descriptives */

create table a_descriptives (
        a_ledger_number                       char(10)  not null,      /* ledger number for the donations --  */
        p_donor_partner_key                   char(10)  not null,      /* Partner ID for the donor --  */
        a_fund                                char(20)  not null,      /* fund that this donor is giving toward --  */
        a_first_gift                          datetime  null,          /* first gift date --  */
        a_first_gift_amount                   decimal(14,4)  null,     /* first gift amount --  */
        a_last_gift                           datetime  null,          /* most recent gift date --  */
        a_last_gift_amount                    decimal(14,4)  null,     /* most recent gift amount --  */
        a_ntl_gift                            datetime  null,          /* next to last gift date --  */
        a_ntl_gift_amount                     decimal(14,4)  null,     /* next to last gift amount --  */
        a_act_lookahead_date                  datetime  null,          /* *ending date now or in the future that we're creating giving averages from --  */
        a_act_lookback_date                   datetime  null,          /* *starting date in the past that we're creating giving averages from --  */
        a_act_average_amount                  decimal(14,4)  null,     /* actual average giving since first gift or within last 12 months, whichever is shorter, with an exception for giving that occurs less frequently than every six months --  */
        a_act_average_months                  integer  null,           /* number of months for the above average --  */
        a_act_average_interval                float  null,             /* actual average interval since first gift or within last 12 months, whichever is shorter, with an exception for giving that occurs less frequently than every six months --  */
        a_act_count                           integer  null,           /* total number of gifts within the generated descriptives --  */
        a_act_total                           decimal(14,4)  null,     /* total giving within the generated descriptives --  */
        a_hist_1_amount                       decimal(14,4)  null,     /* giving history most recent - amount --  */
        a_hist_1_count                        integer  null,           /* giving history most recent - count --  */
        a_hist_1_first                        datetime  null,          /* giving history most recent - first occurrence --  */
        a_hist_1_last                         datetime  null,          /* giving history most recent - last occurrence --  */
        a_hist_2_amount                       decimal(14,4)  null,     /* giving history 2nd most recent - amount --  */
        a_hist_2_count                        integer  null,           /* giving history 2nd most recent - count --  */
        a_hist_2_first                        datetime  null,          /* giving history 2nd most recent - first occurrence --  */
        a_hist_2_last                         datetime  null,          /* giving history 2nd most recent - last occurrence --  */
        a_hist_3_amount                       decimal(14,4)  null,     /* giving history 3rd most recent - amount --  */
        a_hist_3_count                        integer  null,           /* giving history 3rd most recent - count --  */
        a_hist_3_first                        datetime  null,          /* giving history 3rd most recent - first occurrence --  */
        a_hist_3_last                         datetime  null,          /* giving history 3rd most recent - last occurrence --  */
        a_lapsed_days                         int  null,               /* number of days past the expected next gift date (positive) or before that date (negative) --  */
        a_is_current                          int  null,               /* is this giving pattern current (2), lapsing (1), or lapsed/past (0)? --  */
        a_increase_pct                        float  null,             /* the percent increase of the most recent increase in monthly giving between two consecutive giving histories --  */
        a_increase_date                       datetime  null,          /* the date of the most recent increase in monthly giving between two consecutive giving histories --  */
        a_decrease_pct                        float  null,             /* the percent decrease of the most recent decrease in monthly giving between two consecutive giving histories --  */
        a_decrease_date                       datetime  null,          /* the date of the most recent decrease in monthly giving between two consecutive giving histories --  */
        a_is_extra                            int  null,               /* is there an extra gift within the current giving pattern within the past year? --  */
        a_is_approximate                      int  null,               /* is one of the three most recent giving histories an approximation of sporadic/irregular/as-able gifts? --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_descriptives_hist */

create table a_descriptives_hist (
        a_ledger_number                       char(10)  not null,      /* ledger number for the donations --  */
        p_donor_partner_key                   char(10)  not null,      /* Partner ID for the donor --  */
        a_fund                                char(20)  not null,      /* fund that this donor is giving toward --  */
        a_hist_id                             integer  not null,       /* unique id for this history entry --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* amount given --  */
        a_first_gift                          datetime  null,          /* first gift date --  */
        a_last_gift                           datetime  null,          /* most recent gift date --  */
        a_ntl_gift                            datetime  null,          /* next to last gift date --  */
        a_count                               integer  null,           /* actual number of gifts contributing to this giving pattern --  */
        a_total                               decimal(14,4)  null,     /* actual total giving for this giving pattern --  */
        a_act_average_amount                  decimal(14,4)  null,     /* actual monthly average due to this giving pattern --  */
        a_act_average_months                  integer  null,           /* number of months used for the above average --  */
        a_act_average_interval                float  null,             /* actual average giving interval due to this giving pattern --  */
        a_merged_id                           integer  null,           /* *if we're doing a merge of giving patterns, we indicate it here --  */
        a_lapsed_days                         int  null,               /* number of days past the expected next gift date (positive) or before that date (negative) --  */
        a_is_current                          int  null,               /* is this giving pattern current (2), lapsing (1), or lapsed/past (0)? --  */
        a_increase_pct                        float  null,             /* the percent increase in monthly giving compared to the previous regular giving pattern --  */
        a_decrease_pct                        float  null,             /* the percent decrease in monthly giving compared to the previous regular giving pattern --  */
        a_is_extra                            int  null,               /* is this giving pattern a one-time / occasional "extra" amount? --  */
        a_is_approximate                      int  null,               /* is this giving pattern an average of sporadic/irregular/as-able gifts? --  */
        a_prev_end                            datetime  null,          /* *date of the last gift in the previous giving pattern --  */
        a_next_start                          datetime  null,          /* *date of the first gift in the next giving pattern --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_pledge */

create table a_pledge (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        a_pledge_id                           integer  not null,       /* ID of this pledge --  */
        a_is_active                           bit  not null,           /* Active pledge? --  */
        p_donor_partner_id                    char(10)  not null,      /* Donor ID making the pledge --  */
        a_fund                                char(20)  null,          /* Fund being pledged to --  */
        a_intent_type                         varchar(1)  not null,    /* Intent type: P=pledge, F=faith promise, I=intention, R=online recurring --  */
        a_amount                              decimal(14,4)  null,     /* Periodic amount for this intent (e.g. monthly) - UI should default copy from gift data --  */
        a_total_amount                        decimal(14,4)  null,     /* Total amount this intent (e.g. pledged total for the year) --  */
        a_pledge_date                         datetime  null,          /* Date the pledge was made --  */
        a_start_date                          datetime  null,          /* Starting date - UI should default copy from gift data --  */
        a_end_date                            datetime  null,          /* Ending date / due date - default is null --  */
        a_giving_interval                     integer  null,           /* Giving interval: 1=monthly, 12=annually, NULL=total or as-able --  */
        a_gift_count                          integer  null,           /* Number of gifts intended (NULL for unknown/no limit) --  */
        a_comment                             varchar(255)  null,      /* Comment about this intent or pledge --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_intent_type */

create table a_intent_type (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        a_intent_type                         varchar(1)  not null,    /* Intent type: P=pledge, F=faith promise, I=intention, R=online recurring --  */
        a_intent_desc                         varchar(80)  not null,   /* Intent type label/description --  */
        a_is_active                           bit  not null,           /* Active intent type (selectable by the user) --  */
        a_create_receivable                   bit  not null,           /* Whether to create a receivable for this intent type --  */
        a_recv_account_code                   char(16)  null,          /* If creating receivables, this is the GL account to use --  */
        a_allow_daf                           bit  not null,           /* Whether to allow donor advised fund (DAF) gifts to this intent type --  */
        a_comment                             varchar(255)  null,      /* Comment about this intent or pledge --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_cashdisb */

create table a_subtrx_cashdisb (
        a_ledger_number                       char(10)  not null,      /* ledger number for this disbursement --  */
        a_batch_number                        integer  not null,       /* Batch id for this disbursement --  */
        a_disbursement_id                     integer  not null,       /* id number for this disbursement (check) --  */
        a_line_item                           integer  not null,       /* item number for the line item in the disbursement --  */
        a_period                              char(8)  not null,       /* Accounting period this disbursement is recorded in. --  */
        a_effective_date                      datetime  not null,      /* Effective date of disbursement (e.g., accrual date) --  */
        a_cash_account_code                   char(10)  not null,      /* Cash account the funds are disbursed from --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of disbursement --  */
        a_fund                                char(20)  not null,      /* Fund for the expense / liability side of the transaction --  */
        a_account_code                        char(10)  not null,      /* GL account for the expense / liability side of the transaction --  */
        a_payee_partner_key                   char(10)  not null,      /* Partner id of the payee (recipient) --  */
        a_check_number                        varchar(16)  null,       /* Check number being issued --  */
        a_posted                              bit  default 0,          /* Has this disbursement been posted (in this file) --  */
        a_posted_to_gl                        bit  default 0,          /* Has this disbursement been posted into the GL - yes (1) or no (0)? --  */
        a_voided                              bit  default 0,          /* Has this check been voided --  */
        a_approved_by                         varchar(20)  null,       /* Who approved the check --  */
        a_approved_date                       datetime  null,          /* When the check was approved --  */
        a_paid_by                             varchar(20)  null,       /* Who paid the check --  */
        a_paid_date                           datetime  null,          /* When the check was paid --  */
        a_reconciled                          bit  default 0,          /* Has this check been reconciled to the bank account (e.g. no longer outstanding) --  */
        a_comment                             varchar(255)  null,      /* Xfer comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_payable */

create table a_subtrx_payable (
        a_ledger_number                       char(10)  not null,      /* ledger number for this disbursement --  */
        a_payable_id                          integer  not null,       /* id number for this payable item --  */
        a_batch_number_payable                integer  not null,       /* Batch id for the payable/liability journal --  */
        a_batch_number_resolution             integer  not null,       /* Batch id for the resolution journal (cash disbursement) --  */
        a_posted                              bit,                     /* Whether the payable is posted or not (0/1) --  */
        a_requested_by                        char(10)  null,          /* Partner who requested the payable --  */
        a_requested_date                      datetime  null,          /* Date the payable was requested --  */
        a_approved_by                         char(10)  null,          /* Partner who approved the payable --  */
        a_approved_date                       datetime  null,          /* Date the payable was approved --  */
        a_resolved_by                         char(10)  null,          /* Partner who resolved (paid) the payable --  */
        a_resolved_date                       datetime  null,          /* When the payable was actually paid --  */
        a_taxable                             bit,                     /* Whether this is a taxable payable (0/1) --  */
        a_advance                             bit,                     /* Whether this is an expense advance (0/1) --  */
        a_payment_terms                       varchar(16)  null,       /* The terms on which the payment is required. Use "PAYROLL" to cause this to be disbursed with next payroll. --  */
        a_payment_method                      integer  null,           /* Requested payment method --  */
        a_document_id                         integer  null,           /* A document/image providing proof of this expense, if available, such as a receipt or invoice --  */
        a_due_date                            datetime  null,          /* When the payable is due to be paid --  */
        a_payee_partner_key                   char(10)  not null,      /* Partner id of the payee (recipient) --  */
        a_account_with_payee                  varchar(20)  null,       /* Account number at payee --  */
        a_invoice_number                      varchar(64)  null,       /* Invoice number associated with this payable --  */
        a_make_payment_to                     varchar(80)  not null,   /* Name to make the payment to, if different from payee name --  */
        a_payment_comment                     varchar(255)  null,      /* Comment to be included on the check or payment when it is sent --  */
        a_comment                             varchar(255)  null,      /* Payable comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_payable_item */

create table a_subtrx_payable_item (
        a_ledger_number                       char(10)  not null,      /* ledger number for this disbursement --  */
        a_payable_id                          integer  not null,       /* id number for this payable item --  */
        a_line_item                           integer  not null,       /* item number for the line item in the payable --  */
        a_requested_terms                     varchar(16)  null,       /* The terms on which the request was made --  */
        a_document_id                         integer  null,           /* A document/image providing proof of this expense, if available, such as a receipt or invoice --  */
        a_occurrence_date                     datetime  null,          /* When the event happened that triggered this payable (e.g. date of expense on an expense report) --  */
        a_accrued_date                        datetime  not null,      /* When the payable accrues as an expense --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of payable --  */
        a_fund                                char(20)  not null,      /* Fund for the expense generated by the payable --  */
        a_account_code                        char(10)  not null,      /* GL account for the expense generated by the payable --  */
        a_liab_fund                           char(20)  not null,      /* Fund for the liability generated by the payable --  */
        a_liab_account_code                   char(10)  not null,      /* GL account for the liability generated by the payable --  */
        a_comment                             varchar(255)  null,      /* Payable comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_xfer */

create table a_subtrx_xfer (
        a_ledger_number                       char(10)  not null,      /* ledger number for this transfer --  */
        a_batch_number                        integer  not null,       /* Batch id for this transfer --  */
        a_journal_number                      integer  not null,       /* journal id for this transfer (one per transfer) --  */
        a_period                              char(8)  not null,       /* Accounting period this transfer is recorded in. --  */
        a_effective_date                      datetime  not null,      /* Effective date of transfer (e.g., accrual date) --  */
        a_source_fund                         char(20)  not null,      /* Fund that the money is coming from --  */
        a_dest_fund                           char(20)  not null,      /* Fund that the money is going to --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount to transfer --  */
        a_in_gl                               bit  default 0,          /* Has this transfer been posted into the GL - yes (1) or no (0)? --  */
        a_comment                             varchar(255)  null,      /* Xfer comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_deposit */

create table a_subtrx_deposit (
        a_ledger_number                       char(10)  not null,      /* ledger number for this deposit --  */
        a_batch_number                        integer  not null,       /* Batch id for this deposit --  */
        a_period                              char(8)  not null,       /* Accounting period this deposit is recorded in. --  */
        a_effective_date                      datetime  not null,      /* Effective date of deposit (e.g., accrual date) --  */
        a_from_account_code                   char(10)  null,          /* GL account drawn from (typically an "undeposited funds" GL account) --  */
        a_account_code                        char(10)  not null,      /* Cash account the funds are deposited into --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Total amount of deposit --  */
        a_cash_amount                         decimal(14,4)  not null,
                                                                      /* Amount of cash deposited --  */
        a_num_checks                          integer  not null,       /* Number of checks deposited --  */
        a_posted                              bit  default 0,          /* Has this transfer been posted into the Deposits journal? --  */
        a_posted_to_gl                        bit  default 0,          /* Has this transfer been posted into the GL - yes (1) or no (0)? --  */
        a_comment                             varchar(255)  null,      /* Xfer comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_subtrx_cashxfer */

create table a_subtrx_cashxfer (
        a_ledger_number                       char(10)  not null,      /* ledger number for this transfer --  */
        a_batch_number                        integer  not null,       /* Batch id for this transfer --  */
        a_journal_number                      integer  not null,       /* journal id for this transfer (one per transfer) --  */
        a_period                              char(8)  not null,       /* Accounting period this transfer is recorded in. --  */
        a_effective_date                      datetime  not null,      /* Effective date of transfer (e.g., accrual date) --  */
        a_source_cash_acct                    char(16)  not null,      /* Account the funds are coming from --  */
        a_dest_cash_acct                      char(16)  not null,      /* Account the funds are going to --  */
        a_fund                                char(20)  not null,      /* Fund in which to perform the cash transfer --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount to transfer --  */
        a_in_gl                               bit  default 0,          /* Has this transfer been posted into the GL - yes (1) or no (0)? --  */
        a_comment                             varchar(255)  null,      /* Xfer comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* i_eg_gift_import */

create table i_eg_gift_import (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        i_eg_gift_uuid                        char(36)  not null,      /* UUID for the gift record (xml:gift-id) --  */
        i_eg_desig_uuid                       varchar(36)  not null,   /* ID of designation that the donor chose --  */
        i_eg_trx_uuid                         char(36)  not null,      /* UUID for the transaction record (xml:txn-id) --  */
        i_eg_donor_uuid                       char(36)  not null,      /* UUID for the donor (xml:giver-id) --  */
        i_eg_donor_alt_id                     char(36)  null,          /* alternate ID for the donor --  */
        i_eg_account_uuid                     varchar(36)  null,       /* ID of donation account that the donor used --  */
        i_eg_service                          varchar(16)  null,       /* Service ID (e.g. EG, EGS, SS) from Kardia online giving service plugin --  */
        i_eg_status                           varchar(16)  not null,   /* processing status (paid, pending, returned) (xml:status) --  */
        i_eg_returned_status                  varchar(16)  null,       /* Reason for a return (xml:returned-status) --  */
        i_eg_processor                        varchar(80)  not null,   /* Name of payment processor (xml:processor) --  */
        i_eg_donor_name                       varchar(80)  not null,   /* Name (given name and surname) of the donor (xml:name) --  */
        i_eg_donor_given_name                 varchar(80)  null,       /* given name of the donor --  */
        i_eg_donor_surname                    varchar(80)  null,       /* surname of the donor --  */
        i_eg_donor_middle_name                varchar(80)  null,       /* middle name of the donor --  */
        i_eg_donor_prefix                     varchar(80)  null,       /* prefix/title of donor --  */
        i_eg_donor_suffix                     varchar(80)  null,       /* suffix (jr/sr/etc) of donor --  */
        i_eg_donor_addr1                      varchar(80)  null,       /* Address line 1 of donor. (xml:address-line-1) --  */
        i_eg_donor_addr2                      varchar(80)  null,       /* Address line 2 of donor. (xml:address-line-2) --  */
        i_eg_donor_addr3                      varchar(80)  null,       /* Address line 3 of donor. --  */
        i_eg_donor_city                       varchar(80)  null,       /* City of donor. (xml:city) --  */
        i_eg_donor_state                      varchar(80)  null,       /* State of donor. (xml:state) --  */
        i_eg_donor_postal                     varchar(80)  null,       /* Postal Code of donor. (xml:postal) --  */
        i_eg_donor_country                    varchar(80)  null,       /* Country of donor. (xml:country) --  */
        i_eg_donor_phone                      varchar(80)  null,       /* Phone number of donor. (xml:phone) --  */
        i_eg_donor_email                      varchar(80)  null,       /* Email address of donor. (xml:email) --  */
        i_eg_gift_amount                      decimal(14,4)  not null,
                                                                      /* amount of gift (xml:amount) --  */
        i_eg_gift_currency                    varchar(16)  null,       /* currency of gift (e.g. USD, CAD, etc) --  */
        i_eg_gift_pmt_type                    varchar(16)  null,       /* Payment type (xml:payment-type) --  */
        i_eg_gift_lastfour                    char(4)  null,           /* Last four digits of account number (xml:last-four) --  */
        i_eg_gift_interval                    varchar(16)  not null,   /* Recurring gift interval (xml:recurring-interval) --  */
        i_eg_gift_date                        datetime  not null,      /* Date of gift (xml:given-on) --  */
        i_eg_gift_trx_date                    datetime  null,          /* Date of transaction (xml:txn-date) --  */
        i_eg_gift_settlement_date             datetime  null,          /* Date of payment settlement (xml:settlement-date) --  */
        i_eg_receipt_desired                  varchar(255)  null,      /* The "Send My Receipt:" field --  */
        i_eg_anonymous                        varchar(255)  null,      /* The "Anonymous Gift:" field --  */
        i_eg_prayforme                        varchar(255)  null,      /* The "May We Pray For You?" field --  */
        i_eg_desig_name                       varchar(80)  not null,   /* Gift designation/purpose (xml:designation) --  */
        i_eg_desig_notes                      varchar(255)  null,      /* Notes provided by donor (xml:notes) --  */
        i_eg_net_amount                       decimal(14,4)  null,     /* Net gift (less fees for this transaction) (xml:net) --  */
        i_eg_deposit_date                     datetime  null,          /* Date that this gift was deposited into the ministry's account (xml:deposit-date) --  */
        i_eg_deposit_uuid                     char(36)  null,          /* ID of the deposit. (xml:deposit-id) --  */
        i_eg_deposit_status                   char(16)  null,          /* status of the deposit --  */
        i_eg_deposit_gross_amt                decimal(14,4)  null,     /* gross amount of the deposit before fees (xml:deposit-gross) --  */
        i_eg_deposit_amt                      decimal(14,4)  null,     /* net amount of the deposit (xml:deposit-net) --  */
        p_donor_partner_key                   char(10)  null,          /* Kardia partner key assigned by import process --  */
        i_eg_donormap_confidence              integer  null,           /* Confidence of mapping: 0=low, 1=medium, 2=high --  */
        i_eg_donormap_future                  integer  null,           /* Future applicability of donor mapping: 0=low, 1=medium, 2=high --  */
        a_fund                                char(20)  null,          /* Kardia fund assigned by import process --  */
        i_eg_fundmap_confidence               integer  null,           /* Confidence of mapping: 0=low, 1=medium, 2=high --  */
        i_eg_fundmap_future                   integer  null,           /* Future applicability of the fund mapping: 0=low, 1=medium, 2=high --  */
        a_account_code                        char(16)  null,          /* Kardia GL account code assigned by import process --  */
        i_eg_acctmap_confidence               integer  null,           /* Confidence of current mapping: 0=low, 1=medium, 2=high --  */
        i_eg_acctmap_future                   integer  null,           /* Future usability of the account mapping: 0=low, 1=medium, 2=high --  */
        a_batch_number                        integer  null,           /* Kardia GL batch used to process this gift record --  */
        a_batch_number_fees                   integer  null,           /* Kardia GL batch used to process the fees for this gift record --  */
        a_batch_number_deposit                integer  null,           /* Kardia GL batch used to process the deposit for this gift record --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* i_eg_gift_trx_fees */

create table i_eg_gift_trx_fees (
        a_ledger_number                       char(10)  not null,      /* ledger number for this set of fees --  */
        i_eg_fees_id                          integer  not null,       /* A unique ID for the fees data. --  */
        i_eg_service                          varchar(16)  null,       /* Service ID (e.g. EG, EGS, SS) from Kardia online giving service plugin --  */
        i_eg_processor                        varchar(80)  null,       /* Name of payment processor (xml:processor) --  */
        i_eg_gift_currency                    varchar(16)  null,       /* currency of gift (e.g. USD, CAD, etc) --  */
        i_eg_gift_pmt_type                    varchar(16)  null,       /* Payment type (xml:payment-type) --  */
        i_eg_fee_flat_amt                     decimal(14,4)  null,     /* Flat part of fee --  */
        i_eg_fee_pct_amt                      float  null,             /* Percentage part of fee --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* i_eg_giving_url */

create table i_eg_giving_url (
        a_ledger_number                       char(10)  not null,      /* ledger number for the fund --  */
        a_fund                                char(20)  not null,      /* Kardia fund, or * to give a default URL for all funds in the ledger. --  */
        i_eg_url                              varchar(255)  not null,  /* URL a donor can visit to give an online donation. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* i_crm_partner_import */

create table i_crm_partner_import (
        i_crm_import_id                       integer  not null,       /* unique import ID for this record in the given import data session. --  */
        i_crm_import_session_id               integer  not null,       /* import session ID (unique for imported data set) --  */
        i_crm_import_type_id                  integer  null,           /* type of import being done (ref. i_crm_import_type table) --  */
        i_crm_external_key                    varchar(64)  null,       /* external key for data import source --  */
        i_crm_partner_key                     char(10)  null,          /* Partner key for newly inserted record --  */
        i_crm_create_partner                  bit  not null,           /* whether to create a new partner (and possibly address/location) record (0=no, 1=yes) --  */
        i_crm_create_email                    bit  not null,           /* whether to create a new email address record for the partner --  */
        i_crm_create_phone                    bit  not null,           /* whether to create a new phone# record for partner --  */
        i_crm_comment                         varchar(255)  null,      /* Comment for newly created record --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* i_crm_partner_import_option */

create table i_crm_partner_import_option (
        i_crm_import_id                       integer  not null,       /* unique import ID for this record in the given import data session. --  */
        i_crm_import_session_id               integer  not null,       /* import session ID (unique for imported data set) --  */
        i_crm_import_type_id                  integer  null,           /* type of import being done (ref. i_crm_import_type table) --  */
        i_crm_import_type_option_id           integer  null,           /* option of import being done (ref. i_crm_import_type_option table) --  */
        i_crm_option_comment                  varchar(900)  null,      /* specify an alternate comment for the option --  */
        i_crm_tag_strength                    float  null,             /* strength value for tag (default 1.0) --  */
        i_crm_tag_certainty                   float  null,             /* certainty value for tag (default 1.0) --  */
        i_crm_task_due_days                   integer  null,           /* for tasks, how soon the task will be due (in days, from the import date) --  */
        i_crm_collab_id                       char(10)  null,          /* partner key for collaborator being added. --  */
        i_crm_create_option                   bit  not null,           /* Whether to create this option at all --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* i_crm_import_type */

create table i_crm_import_type (
        i_crm_import_type_id                  integer  not null,       /* unique import type --  */
        i_crm_field_pk                        varchar(255)  null,      /* field to be used for import key (this won't become the Partner Key, but will be stored in the legacy key 1 field) --  */
        i_crm_field_surname                   varchar(255)  null,      /* field for surname (last name / family name) field. --  */
        i_crm_field_given_name                varchar(255)  null,      /* field for given name / first name --  */
        i_crm_field_date                      varchar(255)  null,      /* field for date the data was created --  */
        i_crm_field_org_name                  varchar(255)  null,      /* field for name of organization --  */
        i_crm_field_phone                     varchar(255)  null,      /* field(spec) for phone number --  */
        i_crm_field_email                     varchar(255)  null,      /* field(spec) for email address --  */
        i_crm_field_addr1                     varchar(255)  null,      /* field(spec) for Address Line 1 --  */
        i_crm_field_addr2                     varchar(255)  null,      /* field(spec) for Address Line 2 --  */
        i_crm_field_addr3                     varchar(255)  null,      /* field(spec) for Address Line 3 --  */
        i_crm_field_careof                    varchar(255)  null,      /* field(spec) for in-care-of --  */
        i_crm_field_city                      varchar(255)  null,      /* field(spec) for City --  */
        i_crm_field_stateprov                 varchar(255)  null,      /* field(spec) for State/Province --  */
        i_crm_field_postal_code               varchar(255)  null,      /* field(spec) for Postal (zip) code --  */
        i_crm_field_country                   varchar(255)  null,      /* field(spec) for Country. --  */
        i_crm_country_type                    varchar(12)  null,       /* What code set (or full name) to be used for interpreting country data --  */
        i_crm_field_comment                   varchar(255)  null,      /* field(spec) for Partner Comment --  */
        i_crm_field_addr_comment              varchar(255)  null,      /* field(spec) for Address Comment --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* i_crm_import_type_option */

create table i_crm_import_type_option (
        i_crm_import_type_id                  integer  not null,       /* unique import type --  */
        i_crm_import_type_option_id           integer  not null,       /* the identifier for the option in this import type --  */
        i_crm_option_type                     char(1)  not null,       /* T = tag, K = track, C = collaborator, I = interaction, N = note, F = task(followup) --  */
        i_crm_option_class                    integer  not null,       /* the classification of the option (for tags, this is the tag type. for tracks, the track type. etc.) --  */
        i_crm_option_comment                  varchar(900)  null,      /* a comment to be added for the option. This can contain substitute() specs, to include various fields as needed. --  */
        i_crm_tag_strength                    float  null,             /* strength value for tag (default 1.0) --  */
        i_crm_tag_certainty                   float  null,             /* certainty value for tag (default 1.0) --  */
        i_crm_task_due_days                   integer  null,           /* for tasks, how soon the task will be due (in days, from the import date) --  */
        i_crm_collab_id                       char(10)  null,          /* partner key for collaborator being added. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* i_disb_import_classify */

create table i_disb_import_classify (
        a_ledger_number                       char(10)  not null,      /* ledger number for this classification rule --  */
        i_disb_classify_item                  integer  not null,       /* unique id for this rule --  */
        i_disb_classify_active                bit  not null,           /* Whether this rule is active or not --  */
        i_disb_match_ckno                     varchar(20)  null,       /* Match against check number --  */
        i_disb_match_payee                    varchar(20)  null,       /* Match against payee ID --  */
        i_disb_match_year                     integer  null,           /* Match against year --  */
        i_disb_match_amount                   decimal(14,4)  null,     /* Match against amount --  */
        i_disb_match_comment                  varchar(255)  null,      /* Match against comments field (substring match) --  */
        i_disb_insert                         bit  not null,           /* Whether to modify the existing (0) or insert a new (1) disbursements record. For multi-line classifications, set the first to 0 and subsequent to 1. --  */
        i_disb_set_account                    varchar(20)  null,       /* Set GL account for the expense / liability side of the transaction --  */
        i_disb_set_fund                       varchar(20)  null,       /* Set fund for the expense --  */
        i_disb_set_amount                     decimal(14,4)  null,     /* Amount for this disbursement line item --  */
        a_comment                             varchar(255)  null,      /* A comment/description for this rule --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* i_disb_import_status */

create table i_disb_import_status (
        a_ledger_number                       char(10)  not null,      /* ledger number for this classification rule --  */
        i_disb_legacy_key                     varchar(20)  not null,   /* unique key for legacy data --  */
        i_disb_legacy_amount                  decimal(14,4)  not null,
                                                                      /* The amount of the legacy data transaction --  */
        i_disb_legacy_payee                   varchar(20)  not null,   /* Payee ID in legacy system --  */
        i_disb_partner_key                    varchar(20)  null,       /* Partner key from Kardia. Null if there is no match based on Legacy Key 1. --  */
        i_disb_legacy_ckno                    varchar(20)  not null,   /* Check number in legacy system --  */
        i_disb_legacy_paydate                 datetime  null,          /* Payment date in legacy system --  */
        i_disb_legacy_entereddate             datetime  not null,      /* Entered date from legacy system --  */
        i_disb_legacy_approveddate            datetime  null,          /* Approval date from legacy system --  */
        i_disb_legacy_enteredby               varchar(20)  null,       /* Who entered the data in the legacy system. --  */
        i_disb_legacy_approvedby              varchar(20)  null,       /* Who approved the data in the legacy system. --  */
        i_disb_import_status                  char(1)  not null,       /* Import status: (N) not imported, (I) imported, (S) selected for current import --  */
        i_disb_import_comments                varchar(900)  null,      /* Comments --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* c_message */

create table c_message (
        c_message_id                          int  not null,           /* The id of a message in a specific chat. --  */
        c_chat_id                             int  not null,           /* The foreign key to the chat that this is part of. --  */
        c_message                             varchar(1024)  not null,
                                                                      /* The actual message that is being held --  */
        s_date_created                        datetime  not null,      /* The time that the message was sent out. --  */
        s_created_by                          varchar(20)  not null,   /* This is used for the person that created the message. --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* c_chat */

create table c_chat (
        c_chat_id                             int  not null,           /* The synthetic key that serves to identify the unique chat. --  */
        c_last_send                           datetime  not null,      /* The time of the last message to be sent. -- This am thinking this should be denormalized (as it is) so that the retrieved list of tables can be ordered by this. (It is not too essential that it is updated.) */
        c_last_message_id                     int  not null,           /* The message_id of the last message to be sent. -- This can be used in combination with the user's data to see if there is any new data in a chat for each user. */
        c_public                              char(1)  not null,       /* If the chat is public or not. ('Y' or 'N' for yes or no) --  */
        c_title                               varchar(30)  not null,   /* The title of the chat. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /* This is not the same as the time of the last message sent. This is the time that things such as the chat name or chat publicity were modified. --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* c_member */

create table c_member (
        c_chat_id                             int  not null,           /* The key of the chat that the user has been invited to. --  */
        s_username                            varchar(20)  not null,   /* Foreign natural key of the user that has been invited to/is in the chat. --  */
        c_last_read_message_id                int  null,               /* The id of the last message that the user read from this chat. -- This could be null for invitations. */
        c_status                              char(1)  not null,       /* The user's status in the chat. 'I' is unanswered invitation, 'O' is in the chat (open chat), and 'C' is closed chat. This record is deleted if the user declines the invitation. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /* Here, this is used for the person that invited them to the chat. --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* t_project */

create table t_project (
        t_project_id                          integer  not null,       /* unique project ID --  */
        t_parent_project_id                   integer  null,           /* project ID of parent project - for nesting subprojects --  */
        t_project_label                       varchar(64)  not null,   /* a short label (name) for the project. --  */
        t_project_desc                        varchar(900)  null,      /* a description for the project --  */
        t_project_start                       datetime  null,          /* starting date for the project --  */
        t_project_end                         datetime  null,          /* ending date for the project --  */
        t_project_color                       varchar(32)  null,       /* a color (hex triplet, "#ffffff", or common name, "white") for the project --  */
        t_project_status                      char(1)  null,           /* status (A)ctive, (O)bsolete --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* t_sprint */

create table t_sprint (
        t_sprint_id                           integer  not null,       /* unique sprint ID --  */
        t_sprint_label                        varchar(64)  not null,   /* a short label (name) for the sprint. --  */
        t_sprint_start                        datetime  null,          /* starting date for the sprint --  */
        t_sprint_end                          datetime  null,          /* ending date for the sprint --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* t_sprint_project */

create table t_sprint_project (
        t_project_id                          integer  not null,       /* project ID --  */
        t_sprint_id                           integer  not null,       /* the sprint the project is participating in --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* t_sprint_time */

create table t_sprint_time (
        t_time_id                             integer  not null,       /* unique time interval ID --  */
        t_sprint_id                           integer  not null,       /* unique sprint ID --  */
        t_project_id                          integer  null,           /* unique project ID - NULL if it applies to all projects in the sprint --  */
        t_time_start                          datetime  not null,      /* starting date and time for the time interval --  */
        t_time_hours                          float  not null,         /* number of hours in this time interval --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* t_task */

create table t_task (
        t_task_id                             integer  not null,       /* unique task ID --  */
        t_sprint_id                           integer  null,           /* unique sprint ID this task is assigned to (NULL if not assigned to a sprint yet) --  */
        t_project_id                          integer  not null,       /* unique project ID this task is assigned to --  */
        t_task_label                          varchar(64)  not null,   /* label for the task --  */
        t_task_desc                           varchar(900)  null,      /* description for the task --  */
        t_task_hours                          float  null,             /* estimated number of hours needed for this task --  */
        t_task_percent                        float  null,             /* percent done (in decimal form: 0.0 through 1.0) --  */
        t_task_state                          integer  null,           /* the state that the task is in (e.g.: back burner, to-do, in-progress, testing, done) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* t_participant */

create table t_participant (
        p_partner_key                         char(10)  not null,      /* participant partner key in Kardia --  */
        t_project_id                          integer  not null,       /* unique project ID this participant is working in --  */
        t_role                                varchar(64)  null,       /* label for the role of this participant in the project --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* t_sprint_participant */

create table t_sprint_participant (
        p_partner_key                         char(10)  not null,      /* participant partner key in Kardia --  */
        t_sprint_id                           integer  not null,       /* unique sprint ID this participant is working in --  */
        t_project_id                          integer  not null,       /* unique project ID this participant is working in --  */
        t_skill_ratio                         float  null,             /* the typical skill of this participant (1.0 is nominal, <1.0 lower skill, and >1.0 greater skill) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* t_assignee */

create table t_assignee (
        p_partner_key                         char(10)  not null,      /* assignee partner key in Kardia --  */
        t_task_id                             integer  not null,       /* unique task ID that is assigned to this person --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* t_task_state */

create table t_task_state (
        t_task_state_id                       integer  not null,       /* unique ID for the task state --  */
        t_task_state_label                    varchar(64)  not null,   /* short label for the task state --  */
        t_task_state_sequence                 integer  not null,       /* the order of the task states --  */
        t_task_state_type                     char(1)  not null,       /* Type of task state: 'N' = task not started, 'I' = task in progress, 'C' = task completion --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* t_task_history */

create table t_task_history (
        t_task_id                             integer  not null,       /* unique ID for the task state --  */
        t_history_id                          integer  not null,       /* unique ID for this task history record --  */
        t_task_state_id                       integer  null,           /* the current state for the task --  */
        t_task_hours                          float  null,             /* the number of hours overall for the task --  */
        t_task_percent                        float  null,             /* the percent done (0.0 = none, 1.0 = finished) of the task --  */
        t_transition_date                     datetime  not null,      /* The date and time of the task state/hours/percent change --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_config */

create table s_config (
        s_config_name                         char(16)  not null,      /* configuration parameter name --  */
        s_config_value                        varchar(900)  null,      /* configuration parameter value --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_user_data */

create table s_user_data (
        s_username                            varchar(20)  not null,   /* username of user --  */
        s_status                              varchar(255)  not null,  /* status of the user --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_user_loginhistory */

create table s_user_loginhistory (
        s_username                            varchar(20)  not null,   /* user who logged in. --  */
        s_sessionid                           integer  not null,       /* an incrementing value for this particular login record. --  */
        s_first_seen                          datetime  not null,      /* this login session began on this date/time --  */
        s_last_seen                           datetime  not null,      /* this login session ended on or around this date/time --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_subsystem */

create table s_subsystem (
        s_subsystem_code                      char(2)  not null,       /* Code for subsystem --  */
        s_subsystem_desc                      varchar(255)  not null,  /* description of subsystem. --  */
        s_subsystem_type                      char(1)  not null,       /* type of subsystem: P=partner module, A=accounting module, S=system mgmt module --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_process */

create table s_process (
        s_subsystem_code                      char(2)  not null,       /* Code for subsystem --  */
        s_process_code                        char(3)  not null,       /* Code for process --  */
        s_process_desc                        varchar(255)  not null,  /* description of process --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_process_status */

create table s_process_status (
        s_subsystem_code                      char(2)  not null,       /* Code for subsystem --  */
        s_process_code                        char(3)  not null,       /* Code for process --  */
        s_process_status_code                 char(1)  not null,       /* code for process status --  */
        s_process_status_desc                 varchar(255)  not null,  /* description of process status --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_motd */

create table s_motd (
        s_motd_id                             integer  not null,       /* id of the message --  */
        s_valid_days                          integer  null,           /* number of days the message is valid (NULL for indefinite validity) --  */
        s_message_title                       varchar(255)  not null,  /* the title of the message --  */
        s_message_text                        varchar(1536)  not null,
                                                                      /* the text of the message --  */
        s_enabled                             bit,                     /* whether the message should be shown or not --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_motd_viewed */

create table s_motd_viewed (
        s_motd_id                             integer  not null,       /* id of the message --  */
        s_username                            varchar(20)  not null,   /* user who viewed the message --  */
        s_viewed_date                         datetime  not null,      /* when the user viewed the message --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_sec_endorsement */

create table s_sec_endorsement (
        s_endorsement                         varchar(64)  not null,   /* endorsement to be granted --  */
        s_context                             varchar(255)  not null,  /* context of endorsement --  */
        s_subject                             varchar(20)  not null,   /* name of subject being granted the endorsement (username, group name) --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_sec_endorsement_type */

create table s_sec_endorsement_type (
        s_endorsement                         varchar(64)  not null,   /* endorsement to be granted --  */
        s_endorsement_desc                    varchar(255)  not null,  /* description of endorsement --  */
        s_endorsement_context_type            varchar(64)  not null,   /* type of context this endorsement operates within (e.g., "*" or "ledger") --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:sys_admin" as s_endorsement, "System Admin" as s_endorsement_desc, "kardia" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:gl_entry" as s_endorsement, "Enter GL Journal Batches" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:gl_manage" as s_endorsement, "Manage GL" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:disb" as s_endorsement, "View Disbursements" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:disb_entry" as s_endorsement, "Enter Disbursements" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:disb_manage" as s_endorsement, "Manage Disbursements" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:gift" as s_endorsement, "View Gift Data" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:gift_amt" as s_endorsement, "View Gift Amounts" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:gift_entry" as s_endorsement, "Enter Gift Batches" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:gift_manage" as s_endorsement, "Manage Gift Receipting" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:portal_manage" as s_endorsement, "Manage Missionary Portal" as s_endorsement_desc, "kardia" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:lists" as s_endorsement, "View Mailing Lists" as s_endorsement_desc, "kardia" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:lists_manage" as s_endorsement, "Manage Mailing Lists" as s_endorsement_desc, "kardia" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:ptnr_manage" as s_endorsement, "Manage Partner System" as s_endorsement_desc, "kardia" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:crm" as s_endorsement, "View CRM Data" as s_endorsement_desc, "kardia" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:crm_entry" as s_endorsement, "Update CRM Info" as s_endorsement_desc, "kardia" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:crm_manage" as s_endorsement, "Manage CRM System" as s_endorsement_desc, "kardia" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:pay_manage" as s_endorsement, "Manage Payroll" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;
insert into s_sec_endorsement_type (s_endorsement,s_endorsement_desc,s_endorsement_context_type,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia:gl" as s_endorsement, "View GL Data" as s_endorsement_desc, "kardia:ledger" as s_endorsement_context_type, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* s_sec_endorsement_context */

create table s_sec_endorsement_context (
        s_context                             varchar(255)  not null,  /* context of endorsement --  */
        s_context_desc                        varchar(255)  not null,  /* description of security endorsement context --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
insert into s_sec_endorsement_context (s_context,s_context_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "kardia" as s_context, "Kardia" as s_context_desc, '3-14-08' as s_date_created, 'IMPORT' as s_created_by,'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control;


/* s_mykardia */

create table s_mykardia (
        s_username                            varchar(20)  not null,   /* username of user --  */
        s_module                              varchar(20)  not null,   /* module that the plugin belongs to --  */
        s_plugin                              varchar(255)  not null,  /* filename of the plugin .cmp providing the UI element. --  */
        s_occurrence                          int  not null,           /* incrementing ID allowing for multiple instances of each plugin (such as a separator line, etc.) --  */
        s_sequence                            int  not null,           /* order that the plugin comes in on the start page --  */
        s_height                              int  null,               /* height, in pixels, occupied by the plugin. if null, defaults to height specified in the plugin itself. --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_request */

create table s_request (
        s_request_id                          integer  not null,       /* id of the request --  */
        s_request_type                        char(10)  not null,      /* type of request, see the s_request_type table --  */
        s_object_key_1                        varchar(255)  not null,  /* key value for object subject to the request --  */
        s_object_key_2                        varchar(255)  not null,  /* secondary key value for object subject to the request - if does not apply, leave empty (not null) --  */
        s_date_requested                      datetime  not null,      /*  --  */
        s_requested_by                        varchar(20)  not null,   /*  --  */
        s_request_comment                     varchar(255)  null,      /*  --  */
        s_request_sec_context                 varchar(255)  not null,  /* context for the required security endorsement --  */
        s_date_assigned                       datetime  null,          /*  --  */
        s_assigned_by                         varchar(20)  null,       /*  --  */
        s_assigned_to                         varchar(20)  null,       /*  --  */
        s_assigned_comment                    varchar(255)  null,      /*  --  */
        s_date_deleted                        datetime  null,          /*  --  */
        s_deleted_by                          varchar(20)  null,       /*  --  */
        s_deleted_comment                     varchar(255)  null,      /*  --  */
        s_date_approved                       datetime  null,          /*  --  */
        s_approved_by                         varchar(20)  null,       /*  --  */
        s_approved_comment                    varchar(255)  null,      /*  --  */
        s_date_completed                      datetime  null,          /*  --  */
        s_completed_by                        varchar(20)  null,       /*  --  */
        s_completed_comment                   varchar(255)  null,      /*  --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_request_type */

create table s_request_type (
        s_request_type                        char(10)  not null,      /* type of request --  */
        s_request_type_desc                   varchar(255)  not null,  /* description of request type --  */
        s_request_sec_endorsement             varchar(64)  not null,   /* required security endorsement for approval --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_audit */

create table s_audit (
        s_sequence                            int  not null,           /* audit record ID (incrementing integer) --  */
        s_table                               varchar(32)  not null,   /* table (entity type) being modified --  */
        s_key                                 varchar(255)  not null,  /* key (:name) of object being modified --  */
        s_attrname                            varchar(32)  not null,   /* name of attribute being modified or created --  */
        s_attrtype                            varchar(32)  not null,   /* data type of attribute being modified or created --  */
        s_valuestring                         varchar(255)  null,      /* string value --  */
        s_valueint                            int  null,               /* integer value --  */
        s_valuedouble                         float  null,             /* float/double value --  */
        s_valuemoney                          decimal(14,4)  null,     /* money value --  */
        s_valuedatetime                       datetime  null,          /* date/time value --  */
        s_date_created                        datetime  not null,      /* date the modification was made --  */
        s_created_by                          varchar(20)  not null,   /* user who made the modification --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_role */

create table s_role (
        s_role_id                             integer  not null,       /* id of this role --  */
        s_role_label                          varchar(32)  not null,   /* short label for this role --  */
        s_role_desc                           varchar(255)  null,      /* description of this role --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_role_exclusivity */

create table s_role_exclusivity (
        s_role1_id                            integer  not null,       /* id of role #1 --  */
        s_role2_id                            integer  not null,       /* id of role #2 --  */
        s_is_compatible                       bit,                     /* set to 1 if the roles are compatible with each other for simultaneous engagement --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_user_role */

create table s_user_role (
        s_role_id                             integer  not null,       /* id of this role --  */
        s_username                            varchar(20)  not null,   /* name of user --  */
        s_is_enabled                          bit,                     /* whether the user's access to this role is enabled or not --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_global_search */

create table s_global_search (
        s_search_id                           integer  not null,       /* ID of search, a unique integer. --  */
        s_username                            varchar(20)  not null,   /* User who performed the search --  */
        s_search_res_id                       integer  not null,       /* ID of search result, a unique integer. --  */
        s_score                               float  not null,         /* Relevance of the result (0.0 = none, 100.0 = full) --  */
        s_cri1                                int  not null,           /* Whether a given criteria was matched --  */
        s_cri2                                int  not null,           /* Whether a given criteria was matched --  */
        s_cri3                                int  not null,           /* Whether a given criteria was matched --  */
        s_cri4                                int  not null,           /* Whether a given criteria was matched --  */
        s_cri5                                int  not null,           /* Whether a given criteria was matched --  */
        s_type                                varchar(20)  not null,   /* Type of result (PAR = partner, etc.) --  */
        s_label                               varchar(255)  not null,  /* Brief label of search result --  */
        s_desc                                varchar(1536)  not null,
                                                                      /* Expanded description of search result --  */
        s_key                                 varchar(255)  not null,  /* Unique ID so we can find the actual relevant object for this result --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_stats_cache */

create table s_stats_cache (
        s_stat_type                           varchar(16)  not null,   /* unique identifier of the statistic type --  */
        s_stat_group                          varchar(64)  not null,   /* subgroup within the statistic type --  */
        s_stat                                varchar(64)  not null,   /* identifier of this particular statistic --  */
        s_string_value                        varchar(255)  null,      /* string value of the statistic --  */
        s_integer_value                       int  null,               /* integer value of the statistic --  */
        s_money_value                         decimal(14,4)  null,     /* currency value of the statistic --  */
        s_double_value                        float  null,             /* floating point value of the statistic --  */
        s_datetime_value                      datetime  null,          /* date/time value of the statistic --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* s_document_scanner */

create table s_document_scanner (
        s_scanner_id                          integer  not null,       /* unique ID of the scanner --  */
        s_scanner_desc                        varchar(255)  not null,  /* description of this scanner --  */
        s_scanner_type                        char(3)  not null,       /* type/protocol of scanner. Currently supported: CHK - Check Scanner using DM check-reader server. --  */
        s_scanner_host                        varchar(255)  null,      /* network address (IP address) of the scanner. For CHK, this is the address of the check-reader server. --  */
        s_scanner_port                        integer  null,           /* network port of the scanner, if needed. --  */
        s_scanner_auth_user                   varchar(255)  null,      /* username to authenticate to scanner server, if needed. (unused for CHK) --  */
        s_scanner_auth_token                  varchar(255)  null,      /* token/password to authenticate to scanner server, if needed. (token is used for CHK) --  */
        s_scanner_id_on_server                varchar(255)  null,      /* unique identifier for this scanner, if needed, on the document scanner server. For CHK, this is the profile ID. --  */
        s_date_last_used                      datetime  null,          /* date/time this scanner was last used --  */
        s_last_used_by                        varchar(20)  null,       /* username that last used this scanner --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);
