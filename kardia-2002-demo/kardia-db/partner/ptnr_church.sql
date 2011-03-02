create table ptnr_church (
	ptnr_pkey_i UNSIGNED INTEGER, // PK
	ptnr_okey_i UNSIGNED INTEGER, // PK

	ptnr_accomodation_type_c varchar(16),
	ptnr_church_name_c varchar(64),
	ptnr_approximate_size_i integer,
	ptnr_denomination_code_c varchar(16), // FK
	ptnr_accomodation_l BIT,
	ptnr_prayer_cel_l BIT,
	ptnr_map_on_file_l BIT,
	ptnr_accomodation_size_n integer,
	smgr_date_created_d DATETIME,
	smgr_date_modified_d DATETIME,
	smgr_pkey_modified_by_i UNSIGNED INTEGER, //FK
	smgr_okey_modified_by_i UNSIGNED INTEGER, //FK
	smgr_pkey_created_by_i UNSIGNED INTEGER, //FK
	smgr_okey_created_by_i UNSIGNED INTEGER, //FK
	ptnr_pkey_contact_i UNSIGNED INTEGER, //FK
	ptnr_okey_contact_i UNSIGNED INTEGER, //FK

	constraint ptnr_church_PK PRIMARY KEY (ptnr_pkey_i, ptnr_okey_i),

	constraint ptnr_church_FK1 FOREIGN KEY (ptnr_denomination_code_c) REFERENCES ptnr_denomination,
	constraint ptnr_church_FK2 FOREIGN KEY (smgr_pkey_modified_by_i, smgr_okey_modified_by_i) REFERENCES ptnr_partner (ptnr_pkey_i, ptnr_okey_i),
	constraint ptnr_church_FK3 FOREIGN KEY (smgr_pkey_created_by_i, smgr_okey_created_by_i) REFERENCES ptnr_partner (ptnr_pkey_i, ptnr_okey_i),
	constraint ptnr_church_FK4 FOREIGN KEY (ptnr_pkey_contact_i, ptnr_okey_contact_i) REFERENCES ptnr_partner (ptnr_pkey_i, ptnr_okey_i)
)
