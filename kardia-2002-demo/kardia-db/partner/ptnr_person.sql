create table ptnr_person (
	ptnr_pkey_i UNSIGNED INTEGER,
	ptnr_okey_i UNSIGNED INTEGER,

	ptnr_pkey_unit_i UNSIGNED INTEGER, // FK
	ptnr_okey_unit_i UNSIGNED INTEGER, // FK
	ptnr_title_c varchar(64),
	ptnr_first_name_c varchar(64),
	ptnr_prefered_name_c varchar(64),
	ptnr_middle_name_c varchar(64),
	ptnr_family_name_c varchar(64),
	ptnr_decorations_c varchar(64),
	ptnr_previous_family_name_c varchar(64),
	ptnr_date_of_birth_d datetime,
	ptnr_gender_c TINYINT,
	ptnr_marital_status_c varchar(2), // FK
	ptnr_occupation_code_c varchar(32), // FK
	smgr_date_created_d datetime,
	smgr_pkey_modified_by_i UNSIGNED INTEGER, // FK
	smgr_okey_modified_by_i UNSIGNED INTEGER, // FK
	smgr_pkey_created_by_i UNSIGNED INTEGER, // FK
	smgr_okey_created_by_i UNSIGNED INTEGER, // FK
	ptnr_academic_title_c varchar(48),

	constraint ptnr_person_PK PRIMARY KEY (ptnr_pkey_i,ptnr_okey_i),

	constraint ptnr_person_FK1 FOREIGN KEY (ptnr_marital_status_c) REFERENCES ptnr_marital_status (ptnr_marital_code_c),
	constraint ptnr_person_FK2 FOREIGN KEY (ptnr_occupation_code_c) REFERENCES ptnr_occupation (ptnr_occupation_code_c), 
	constraint ptnr_person_FK3 FOREIGN KEY (ptnr_pkey_unit_i, ptnr_okey_unit_i) REFERENCES ptnr_partner (ptnr_pkey_i, ptnr_okey_i),
	constraint ptnr_person_FK4 FOREIGN KEY (smgr_pkey_modified_by_i,smgr_okey_modified_by_i) REFERENCES ptnr_partner (ptnr_pkey_i,ptnr_okey_i),
	constraint ptnr_person_FK5 FOREIGN KEY (smgr_pkey_created_by_i,smgr_okey_created_by_i) REFERENCES ptnr_partner (ptnr_pkey_i,ptnr_okey_i)
)
