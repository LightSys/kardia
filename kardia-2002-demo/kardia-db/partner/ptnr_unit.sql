create table ptnr_unit (
	ptnr_pkey_i unsigned integer,
	ptnr_okey_i unsigned integer,

	unit_unit_type_code_c varchar(24),
	ptnr_unit_name_c varchar(64),
	ptnr_description_c text,
	unit_default_entry_conf_key_n Decimal(15,0),
	unit_minimum_i integer,
	unit_maximum_i integer,
	unit_present_i integer,
	unit_part_timers_i integer,
	smgr_date_created_d datetime,
	smgr_date_modified_d datetime,
	smgr_pkey_modified_by_i unsigned integer,
	smgr_okey_modified_by_i unsigned integer,
	smgr_pkey_created_by_i unsigned integer,
	smgr_okey_created_by_i unsigned integer,
	ptnr_campaign_code_c varchar(26),
	ptnr_country_code_c varchar(8),

	constraint ptnr_unit_PK PRIMARY KEY (ptnr_pkey_i, ptnr_okey_i),

	constraint ptnr_unit_FK1 FOREIGN KEY (unit_unit_type_code_c) REFERENCES unit_unit_type (unit_unit_type_code_c),
	constraint ptnr_unit_FK2 FOREIGN KEY (ptnr_pkey_i, ptnr_okey_i) REFERENCES ptnr_partner (ptnr_pkey_i, ptnr_okey_i),
	constraint ptnr_unit_FK3 FOREIGN KEY (smgr_pkey_modified_by_i, smgr_okey_modified_by_i) REFERENCES ptnr_partner (ptnr_pkey_i, ptnr_okey_i),
	constraint ptnr_unit_FK4 FOREIGN KEY (smgr_pkey_created_by_i, smgr_okey_created_by_i) REFERENCES ptnr_partner (ptnr_pkey_i, ptnr_okey_i)
)
