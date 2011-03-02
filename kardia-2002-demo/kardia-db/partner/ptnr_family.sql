create table ptnr_family (
	ptnr_pkey_i UNSIGNED INTEGER,
	ptnr_okey_i UNSIGNED INTEGER,

	ptnr_title_c varchar(64),
	ptnr_family_name_c varchar(64),
	smgr_date_created_d datetime,
	smgr_date_modified_d datetime,
	smgr_pkey_modified_by_i UNSIGNED INTEGER, // FK
	smgr_okey_modified_by_i UNSIGNED INTEGER, // FK
	smgr_pkey_created_by_i UNSIGNED INTEGER, // FK
	smgr_okey_created_by_i UNSIGNED INTEGER, // FK
	ptnr_first_name_c varchar(64),
	ptnr_family_members_l BIT,
	ptnr_pkey_unit_i UNSIGNED INTEGER, // FK
	ptnr_okey_unit_i UNSIGNED INTEGER, // FK

	constraint ptnr_family_PK PRIMARY KEY (ptnr_pkey_i, ptnr_okey_i),

	constraint ptnr_family_FK1 FOREIGN KEY (smgr_pkey_modified_by_i, smgr_okey_modified_by_i) REFERENCES ptnr_partner (ptnr_pkey_i, ptnr_okey_i),
	constraint ptnr_family_FK2 FOREIGN KEY (smgr_pkey_created_by_i, smgr_okey_created_by_i) REFERENCES ptnr_partner (ptnr_pkey_i, ptnr_okey_i),
	constraint ptnr_family_FK3 FOREIGN KEY (ptnr_pkey_unit_i, ptnr_okey_unit_i) REFERENCES ptnr_partner (ptnr_pkey_i, ptnr_okey_i)
)
