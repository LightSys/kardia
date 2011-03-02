CREATE TABLE ptnr_organization (
	ptnr_pkey_i UNSIGNED INTEGER,
	ptnr_okey_i UNSIGNED INTEGER,

	smgr_date_created_d DATETIME,
	ptnr_organization_name_c VARCHAR(64),
	ptnr_business_code_c VARCHAR(16), //FK
	ptnr_christian_l BIT,
	smgr_date_modified_d DATETIME,
	smgr_pkey_modified_by_i UNSIGNED INTEGER, //FK
	smgr_okey_modified_by_i UNSIGNED INTEGER, //FK
	smgr_pkey_created_by_i UNSIGNED INTEGER, //FK
	smgr_okey_created_by_i UNSIGNED INTEGER, //FK
	ptnr_pkey_contact_i UNSIGNED INTEGER, //FK
	ptnr_okey_contact_i UNSIGNED INTEGER, //FK

	constraint ptnr_organization_PK PRIMARY KEY (ptnr_pkey_i, ptnr_okey_i),

	constraint ptnr_organization_FK1 FOREIGN KEY (ptnr_business_code_c) REFERENCES ptnr_business (ptnr_business_code_c),
	constraint ptnr_organization_FK2 FOREIGN KEY (smgr_pkey_modified_by_i,smgr_okey_modified_by_i) REFERENCES ptnr_partner (ptnr_pkey_i,ptnr_okey_i),
	constraint ptnr_organization_FK3 FOREIGN KEY (smgr_pkey_created_by_i,smgr_okey_created_by_i) REFERENCES ptnr_partner (ptnr_pkey_i,ptnr_okey_i),
	constraint ptnr_organization_FK4 FOREIGN KEY (ptnr_pkey_contact_i,ptnr_okey_contact_i) REFERENCES ptnr_partner (ptnr_pkey_i,ptnr_okey_i),
)
