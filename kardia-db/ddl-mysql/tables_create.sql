
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

insert ra values('a_cost_center','Cost Centers',':a_cc_desc');

insert ra values('a_cost_center_prefix','CostCtr Prefixes',':a_cc_prefix_desc');

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
        p_cost_center                         varchar(20)  null,       /* The cost center number (see a_cost_center) associated with the partner, if applicable. --  */
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


/* p_partner_relationship */

create table p_partner_relationship (
        p_partner_key                         char(10)  not null,      /* source of relationship --  */
        p_relation_type                       char(1)  not null,       /* brother, wife, son, etc. --  */
        p_relation_key                        char(10)  not null,      /* the one the source is related to --  */
        p_relation_comments                   varchar(1536)  null,     /*  --  */
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


/* p_banking_details */

create table p_banking_details (
        p_banking_details_key                 integer  not null,       /* banking details key (autonumbered) --  */
        p_banking_type                        char(1)  not null,       /* type of account (C=checking, S=savings, R=revolving credit account such as VISA/MC) --  */
        p_banking_card_type                   char(2)  null,           /* type of revolving credit - VI = visa, MC = mastercard, AE = american express, DI = discover, etc. --  */
        p_partner_id                          char(10)  null,          /* partner id of the account owner (if relevant) --  */
        p_bank_partner_id                     char(10)  null,          /* partner id of the financial institution itself (if available) --  */
        p_bank_account_name                   varchar(80)  not null,   /* name on the account (e.g., name on visa card, etc.) --  */
        p_bank_account_number                 varchar(32)  not null,   /* number of the account --  */
        p_bank_routing_number                 varchar(32)  null,       /* routing number, if applicable --  */
        p_next_check_number                   integer  null,           /* next check number to use when writing checks --  */
        p_bank_expiration                     datetime  null,          /* expiration date on account --  */
        p_comment                             varchar(255)  null,      /* comments / description of bank account --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


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
        m_charge_ledger                       char(10)  null,          /* who to charge for publ. costs --  */
        p_postal_mode                         char(1)  null,           /* B-Bulk F-FirstClass Used to set postal modes on mailings --  */
        m_charge_cost_ctr                     varchar(20)  null,       /*  --  */
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


/* r_group */

create table r_group (
        r_group_name                          char(8)  not null,       /* short name of the report group. --  */
        r_group_description                   varchar(255)  null,      /* description of the report group --  */
        r_group_module                        varchar(20)  not null,   /* directory name of the module containing the report to run (e.g., 'base', 'rcpt', 'disb', etc.) --  */
        r_group_file                          varchar(255)  not null,  /* file name of the .rpt file in the above module. --  */
        r_is_active                           bit,                     /* Whether or not the group is 'active'. Kardia may come with many preconfigured report groups that are not activated by the user yet. --  */
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
        r_is_required                         bit,                     /* whether this parameter MUST be supplied --  */
        r_param_cmp_module                    varchar(64)  null,       /* component module (directory name) used for getting user input on this parameter. --  */
        r_param_cmp_file                      varchar(256)  null,      /* component file (.cmp) used for getting user input on this parameter. --  */
        r_param_default                       varchar(1536)  null,     /* default value for the parameter (in string format). --  */
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
        a_cc_enab                             bit  not null,           /* whether to enable this attr for cost centers --  */
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


/* a_cc_analysis_attr */

create table a_cc_analysis_attr (
        a_attr_code                           char(8)  not null,       /* analysis attribute code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this attribute --  */
        a_cost_center                         char(20)  not null,      /* cost center --  */
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


/* a_cost_center */

create table a_cost_center (
        a_cost_center                         char(20)  not null,      /* cost center code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this cost center --  */
        a_parent_cost_center                  char(20)  null,          /* cost center that this data rolls up into for reporting (within same ledger) --  */
        a_bal_cost_center                     char(20)  not null,      /* a_bal_cost_center = a_is_balancing?a_cost_center:a_parent_cost_center --  */
        a_cost_center_class                   char(3)  null,           /* classification (could be others too): (ADM)inistration & General, (FUN)draising, (MIN)istry / Program Services. --  */
        a_reporting_level                     int  not null,           /* at what detail level should this costctr be shown (in reports); smaller number = less detail, more generalized report --  */
        a_is_posting                          bit,                     /* enables posting to this cost center --  */
        a_is_external                         bit,                     /* Does the cost center represent a subdivision of the local entity, or is it foreign/external? --  */
        a_is_balancing                        bit,                     /* Is this a true cost center which self-balances (satisfies the accounting equation), or is it merely a fund within a cost center? --  */
        a_restricted_type                     char(1)  not null,       /* Fund restriction code: N = not restricted, T = temporarily restricted, P = permanently restricted --  */
        a_cc_desc                             char(32)  null,          /* short description of cost center, for reporting --  */
        a_cc_comments                         varchar(255)  null,      /* comments / long description of cost center --  */
        a_legacy_code                         varchar(32)  null,       /* Legacy cost center code, from data import --  */
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
        a_account_class                       char(3)  null,           /* classification (used for managing which accts go with which cost centers) --  */
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
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "IFTE" as a_acct_usage_code, "E" as a_acct_type, "Inter-Fund Transfer Expense" as a_acct_usage_desc, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "IFTR" as a_acct_usage_code, "R" as a_acct_type, "Inter-Fund Transfer Revenue" as a_acct_usage_desc, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "ICTE" as a_acct_usage_code, "E" as a_acct_type, "Inter-CostCtr Transfer Expense" as a_acct_usage_desc, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "ICTR" as a_acct_usage_code, "R" as a_acct_type, "Inter-CostCtr Transfer Revenue" as a_acct_usage_desc, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "ILTE" as a_acct_usage_code, "E" as a_acct_type, "Inter-Ledger Transfer Expense" as a_acct_usage_desc, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_account_usage_type (a_acct_usage_code,a_acct_type,a_acct_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "ILTR" as a_acct_usage_code, "R" as a_acct_type, "Inter-Ledger Transfer Revenue" as a_acct_usage_desc, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;


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


/* a_cc_acct */

create table a_cc_acct (
        a_ledger_number                       char(10)  not null,      /* ledger number --  */
        a_period                              char(8)  not null,       /* the high level accounting period (i.e., year) --  */
        a_cost_center                         char(20)  not null,      /* cost center code --  */
        a_account_code                        char(16)  not null,      /* GL account code --  */
        a_cc_acct_class                       char(3)  null,           /* classification (could be others too): (ADM)inistration & General, (FUN)draising, (MIN)istry / Program Services. --  */
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
insert into a_period_usage_type (a_period_usage_code,a_period_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "GIFT" as a_period_usage_code, "Gift Entry Default Period" as a_period_usage_desc, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_period_usage_type (a_period_usage_code,a_period_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "CURR" as a_period_usage_code, "General Default Period" as a_period_usage_desc, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_period_usage_type (a_period_usage_code,a_period_usage_desc,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "YEAR" as a_period_usage_code, "General Default Year" as a_period_usage_desc, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;


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
        a_cost_center                         char(20)  not null,      /* Cost center this transaction is posted to. --  */
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
        a_cost_center                         char(20)  not null,      /* Cost center this transaction is posted to. --  */
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


/* a_cost_center_class */

create table a_cost_center_class (
        a_cost_center_class                   char(3)  not null,       /* costctr class (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this costctr class --  */
        a_acct_class_desc                     varchar(255)  not null,  /* description of costctr class --  */
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


/* a_cost_center_prefix */

create table a_cost_center_prefix (
        a_cost_center_prefix                  char(20)  not null,      /* cost center prefix (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this cost center prefix --  */
        a_cc_prefix_desc                      char(32)  null,          /* short description of cost center prefix, for reporting --  */
        a_cc_prefix_comments                  varchar(255)  null,      /* comments / long description of cost center prefix --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_cc_staff */

create table a_cc_staff (
        a_ledger_number                       char(10)  not null,      /* ledger number (a_ledger) --  */
        a_cost_center                         char(20)  not null,      /* cost center code (a_cost_center) --  */
        p_staff_partner_key                   varchar(10)  not null,   /* Partner key (p_partner) --  */
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


/* a_payroll */

create table a_payroll (
        a_ledger_number                       char(10)  not null,      /* ledger number that will be doing the payroll. --  */
        a_payroll_group_id                    integer  not null,       /* group ID for this payroll entry --  */
        a_payroll_id                          integer  not null,       /* unique ID for this payroll entry --  */
        p_payee_partner_key                   char(10)  not null,      /* partner ID of the payee. --  */
        a_payee_name                          char(80)  null,          /* if necessary, this can be used to adjust the name used in payroll. --  */
        a_priority                            integer  null,           /* if more than one payroll in a cost ctr, this sets the priority (higher number = higher priority) --  */
        a_payroll_interval                    char(2)  not null,       /* interval (OW = once weekly, BW = biweekly, OD = daily, SM = semimonthly, OM = once monthly, MS = misc) --  */
        a_cost_center                         char(20)  not null,      /* cost center that this payroll takes place within --  */
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
        a_cost_center                         char(20)  not null,      /* default cost center that this payroll takes place within (can be overridden on payee entries) --  */
        a_liab_cost_center                    char(20)  null,          /* cost center to xfer payroll liabilities to, if any --  */
        a_cash_cost_center                    char(20)  null,          /* cost center for handling cash for payroll, if any --  */
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
        a_priority                            integer  null,           /* if more than one payroll in a cost ctr, this sets the priority (higher number = higher priority) --  */
        a_payroll_interval                    char(2)  not null,       /* interval (OW = once weekly, BW = biweekly, OD = daily, SM = semimonthly, OM = once monthly, MS = misc) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that will be doing the payroll. --  */
        a_cost_center                         char(20)  not null,      /* cost center that this payroll takes place within --  */
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
        a_ref_cost_center                     char(20)  null,          /* for receivables/payables/etc, the cost center to check --  */
        a_ref_account_code                    char(10)  null,          /* for receivables/payables/etc, the gl account to check --  */
        a_xfer_cost_center                    char(20)  null,          /* for line items that reference an outside cost ctr / fund. --  */
        a_xfer_account_code                   char(10)  null,          /* gl acct to use in outside cost ctr / fund. --  */
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
        a_ref_cost_center                     char(20)  null,          /* for receivables/payables/etc, the cost center to check --  */
        a_ref_account_code                    char(10)  null,          /* for receivables/payables/etc, the gl account to check --  */
        a_xfer_cost_center                    char(20)  null,          /* for line items that reference an outside cost ctr / fund. --  */
        a_xfer_account_code                   char(10)  null,          /* gl acct to use in outside cost ctr / fund. --  */
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
        a_payroll_item_form_sequence          integer  null,           /* order this item comes in on the payroll form. --  */
        a_ref_account_code                    char(10)  null,          /* default GL account code to use for items of this type --  */
        a_xfer_cost_center                    char(20)  null,          /* default cost center to use when this item involves an xfer --  */
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


/* a_cc_admin_fee */

create table a_cc_admin_fee (
        a_cost_center                         char(20)  not null,      /* cost center code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this cost center --  */
        a_admin_fee_type                      char(3)  not null,       /* admin fee type to apply to this cost center (and subsidiaries) --  */
        a_default_subtype                     char(1)  null,           /* default subtype to use for gifts to this costctr --  */
        a_percentage                          float  null,             /* percent to deduct for this cost center, if different from a_admin_fee_type:a_default_percentage --  */
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
        a_dest_cost_center                    char(20)  not null,      /* destination cost center for the admin fee proceeds --  */
        a_percentage                          float  not null,         /* percent of gift to go to the above cost center --  */
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
        a_dest_cost_center                    char(20)  not null,      /* destination cost center for the admin fee proceeds --  */
        a_percentage                          float  not null,         /* percent of gift to go to the above cost center --  */
        a_is_fixed                            bit  default 0,          /* if fee is scaled up or down, will the scaling apply to this fee item? --  */
        a_comment                             varchar(255)  null,      /* comments for this admin fee type item --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_cc_receipting */

create table a_cc_receipting (
        a_cost_center                         char(20)  not null,      /* cost center code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this cost center --  */
        a_receiptable                         bit  default 1,          /* can we receipt revenue (gifts) into this account? --  */
        s_date_created                        datetime  not null,      /*  --  */
        s_created_by                          varchar(20)  not null,   /*  --  */
        s_date_modified                       datetime  not null,      /*  --  */
        s_modified_by                         varchar(20)  not null,   /*  --  */
        __cx_osml_control                     varchar(255)  null       /*  --  */

);


/* a_cc_receipting_accts */

create table a_cc_receipting_accts (
        a_cost_center                         char(20)  not null,      /* cost center code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this cost center --  */
        a_account_code                        char(16)  not null,      /* a GL account that we can receipt into for this fund. --  */
        a_non_tax_deductible                  bit  default 0,          /* are cash receipts tax deductible? --  */
        a_is_default                          bit  default 0,          /* is this the default receipting acct for this fund? --  */
        a_receipt_comment                     varchar(64)  null,       /* text to use in place of a_cc_desc from a_cost_center, when printing receipts. --  */
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
insert into a_receipt_type (a_receipt_type,a_receipt_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "I" as a_receipt_type, "Immediate" as a_receipt_type_desc, 1 as a_is_default, 1 as a_is_enabled, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_receipt_type (a_receipt_type,a_receipt_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "N" as a_receipt_type, "None" as a_receipt_type_desc, 0 as a_is_default, 1 as a_is_enabled, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_receipt_type (a_receipt_type,a_receipt_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "A" as a_receipt_type, "Annual" as a_receipt_type_desc, 0 as a_is_default, 0 as a_is_enabled, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_receipt_type (a_receipt_type,a_receipt_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "Q" as a_receipt_type, "Quarterly" as a_receipt_type_desc, 0 as a_is_default, 0 as a_is_enabled, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;
insert into a_receipt_type (a_receipt_type,a_receipt_type_desc,a_is_default,a_is_enabled,s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control) select "M" as a_receipt_type, "Monthly" as a_receipt_type_desc, 0 as a_is_default, 0 as a_is_enabled, '3-14-08' as s_date_created, 'gbeeley' as s_created_by,'3-14-08' as s_date_modified, 'gbeeley' as s_modified_by, null as __cx_osml_control;


/* a_subtrx_gift */

create table a_subtrx_gift (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        a_batch_number                        integer  not null,       /* Batch id for this gift. --  */
        a_gift_number                         integer  not null,       /* sequential gift number in the batch. --  */
        a_period                              char(8)  not null,       /* Accounting period this transaction is recorded in. --  */
        a_cost_center                         char(20)  not null,      /* Which fund the gift is given to. --  */
        a_account_code                        char(16)  not null,      /* Which GL Account this gift posts to in the above fund. --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of the gift. --  */
        a_posted                              bit  default 0,          /* Has this transaction been posted (in this table)? --  */
        a_posted_to_gl                        bit  default 0,          /* Has this transaction been posted to the GL - yes (1) or no (0)? --  */
        a_gift_type                           char(1)  not null,       /* Type of gift: (C)ash, chec(K), credit car(D), (E)FT --  */
        a_gift_admin_fee                      float  null,             /* Total administration fee percent to use (optionally specified by user) --  */
        a_gift_admin_subtype                  char(1)  null,           /* Admin fee subtype to use (overrides that specified in a_cc_admin_fee) --  */
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
        a_posted                              bit  default 0,          /* Has this transaction been posted (in this table)? --  */
        a_posted_to_gl                        bit  default 0,          /* Has this transaction been posted to the GL - yes (1) or no (0)? --  */
        a_gift_type                           char(1)  not null,       /* Type of gift: (C)ash, chec(K), credit car(D), (E)FT --  */
        a_receipt_number                      varchar(64)  null,       /* Receipt number that we sent out --  */
        p_donor_partner_id                    char(10)  null,          /* Partner ID of donor --  */
        a_receipt_sent                        bit  default 0,          /* Receipt sent to donor --  */
        a_receipt_desired                     char(1)  default 'I'  null,
                                                                      /* Receipt needed -- 'I' for immediate, 'A' for annual, 'N' for no receipt --  */
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


/* a_subtrx_gift_item */

create table a_subtrx_gift_item (
        a_ledger_number                       char(10)  not null,      /* ledger number for this gift. --  */
        a_batch_number                        integer  not null,       /* Batch id for this gift. --  */
        a_gift_number                         integer  not null,       /* sequential gift number in the batch. --  */
        a_split_number                        integer  not null,       /* sequential split number for line items in a gift (split gift between multiple designations) --  */
        a_period                              char(8)  not null,       /* Accounting period this transaction is recorded in. --  */
        a_cost_center                         char(20)  not null,      /* Which fund the gift is given to. --  */
        a_account_code                        char(16)  not null,      /* Which GL Account this gift posts to in the above fund. --  */
        a_amount                              decimal(14,4)  not null,
                                                                      /* Amount of the gift. --  */
        a_recv_document_id                    varchar(64)  null,       /* Check number, transaction number, etc., for received gift. --  */
        a_posted                              bit  default 0,          /* Has this transaction been posted (in this table)? --  */
        a_posted_to_gl                        bit  default 0,          /* Has this transaction been posted to the GL - yes (1) or no (0)? --  */
        a_gift_admin_fee                      float  null,             /* Total administration fee percent to use (optionally specified by user) --  */
        a_gift_admin_subtype                  char(1)  null,           /* Admin fee subtype to use (overrides that specified in a_cc_admin_fee) --  */
        a_calc_admin_fee                      float  null,             /* Total administration fee percent as calculated by the system (set by admin fee logic) --  */
        a_calc_admin_fee_type                 char(3)  null,           /* admin fee type as calculated by the system (set by admin fee logic) --  */
        a_calc_admin_fee_subtype              char(1)  null,           /* admin fee subtype as calculated by the system (set by admin fee logic) --  */
        p_recip_partner_id                    char(10)  null,          /* Partner ID of gift recipient. May not be needed for non-pool based financial setups. --  */
        a_confidential                        bit  default 0,          /* Set this if the donor wishes to remain anonymous (to the recipient) --  */
        a_non_tax_deductible                  bit  default 0,          /* Set this if the gift is a non-tax-deductible gift, such as a personal gift (i.e., payable to missionary instead of support gift) --  */
        a_motivational_code                   varchar(16)  null,       /* Optional motivational code that indicates what motivated the donor to give this gift. --  */
        a_comment                             varchar(255)  null,      /* Gift comments --  */
        p_dn_donor_partner_id                 char(10)  null,          /* **Denormalized** Partner ID of gift donor. --  */
        a_dn_receipt_number                   varchar(64)  null,       /* **Denormalized** Receipt number we sent out. --  */
        a_dn_gift_received_date               datetime  null,          /* **Denormalized** Date gift was received --  */
        a_dn_gift_postmark_date               datetime  null,          /* **Denormalized** Date gift was postmarked --  */
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


/* a_cc_auto_subscribe */

create table a_cc_auto_subscribe (
        a_cost_center                         char(20)  not null,      /* cost center code (alphanumeric allowed) --  */
        a_ledger_number                       char(10)  not null,      /* ledger number that uses this cost center --  */
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
        a_cost_center                         varchar(20)  null,       /* Optional cost center associated with this motivational code --  */
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
        a_cost_center                         char(20)  not null,      /* Cost center for the expense / liability side of the transaction --  */
        a_account_code                        char(10)  not null,      /* GL account for the expense / liability side of the transaction --  */
        a_payee_partner_key                   char(10)  not null,      /* Partner id of the payee (recipient) --  */
        a_check_number                        integer  not null,       /* Check number being issued --  */
        a_posted                              bit  default 0,          /* Has this disbursement been posted (in this file) --  */
        a_posted_to_gl                        bit  default 0,          /* Has this disbursement been posted into the GL - yes (1) or no (0)? --  */
        a_voided                              bit  default 0,          /* Has this check been voided --  */
        a_comment                             varchar(255)  null,      /* Xfer comments --  */
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
        a_source_cost_center                  char(20)  not null,      /* Cost center the funds are coming from --  */
        a_dest_cost_center                    char(20)  not null,      /* Cost center the funds are going to --  */
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
        a_cost_center                         char(20)  not null,      /* Cost Center in which to perform the cash transfer --  */
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
        i_eg_gift_uuid                        char(36)  not null,      /* eGiving.com UUID for the gift record (xml:gift-id) --  */
        i_eg_trx_uuid                         char(36)  not null,      /* eGiving.com UUID for the transaction record (xml:txn-id) --  */
        i_eg_donor_uuid                       char(36)  not null,      /* eGiving.com UUID for the donor (xml:giver-id) --  */
        i_eg_status                           varchar(16)  not null,   /* processing status (paid, pending, returned) (xml:status) --  */
        i_eg_returned_status                  varchar(16)  null,       /* Reason for a return (xml:returned-status) --  */
        i_eg_processor                        varchar(80)  not null,   /* Name of payment processor (xml:processor) --  */
        i_eg_donor_name                       varchar(80)  not null,   /* Name (given name and surname) of the donor (xml:name) --  */
        i_eg_donor_addr1                      varchar(80)  null,       /* Address line 1 of donor. (xml:address-line-1) --  */
        i_eg_donor_addr2                      varchar(80)  null,       /* Address line 2 of donor. (xml:address-line-2) --  */
        i_eg_donor_city                       varchar(80)  null,       /* City of donor. (xml:city) --  */
        i_eg_donor_state                      varchar(80)  null,       /* State of donor. (xml:state) --  */
        i_eg_donor_postal                     varchar(80)  null,       /* Postal Code of donor. (xml:postal) --  */
        i_eg_donor_country                    varchar(80)  null,       /* Country of donor. (xml:country) --  */
        i_eg_donor_phone                      varchar(80)  null,       /* Phone number of donor. (xml:phone) --  */
        i_eg_donor_email                      varchar(80)  null,       /* Email address of donor. (xml:email) --  */
        i_eg_gift_amount                      decimal(14,4)  not null,
                                                                      /* amount of gift (xml:amount) --  */
        i_eg_gift_pmt_type                    varchar(16)  not null,   /* Payment type (xml:payment-type) --  */
        i_eg_gift_lastfour                    char(4)  not null,       /* Last four digits of account number (xml:last-four) --  */
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
        i_eg_deposit_gross_amt                decimal(14,4)  null,     /* gross amount of the deposit before fees (xml:deposit-gross) --  */
        i_eg_deposit_amt                      decimal(14,4)  null,     /* net amount of the deposit (xml:deposit-net) --  */
        p_donor_partner_key                   char(10)  null,          /* Kardia partner key assigned by import process --  */
        i_eg_donormap_confidence              integer  null,           /* Confidence of mapping: 0=none or guessed by system, 1=just this time, 9=remember this mapping for the future --  */
        a_cost_center                         char(20)  null,          /* Kardia fund assigned by import process --  */
        i_eg_fundmap_confidence               integer  null,           /* Confidence of mapping: 0=none or guessed by system, 1=just this time, 9=remember this mapping for the future --  */
        a_account_code                        char(16)  null,          /* Kardia GL account code assigned by import process --  */
        i_eg_acctmap_confidence               integer  null,           /* Confidence of mapping: 0=none or guessed by system, 1=just this time, 9=remember this mapping for the future --  */
        a_batch_number                        integer  null,           /* Kardia GL batch used to process this gift record --  */
        a_batch_number_fees                   integer  null,           /* Kardia GL batch used to process the fees for this gift record --  */
        a_batch_number_deposit                integer  null,           /* Kardia GL batch used to process the deposit for this gift record --  */
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
        s_date_assigned                       datetime  null,          /*  --  */
        s_assigned_by                         varchar(20)  null,       /*  --  */
        s_assigned_to                         varchar(20)  null,       /*  --  */
        s_assigned_comment                    varchar(255)  null,      /*  --  */
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
