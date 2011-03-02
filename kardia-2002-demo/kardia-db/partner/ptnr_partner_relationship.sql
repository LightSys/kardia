CREATE TABLE ptnr_partner_relationship (
	ptnr_pkey_relation_i UNSIGNED INTEGER,
	ptnr_okey_relation_i UNSIGNED INTEGER,
	ptnr_pkey_partner_i UNSIGNED INTEGER,
	ptnr_okey_partner_i UNSIGNED INTEGER,

	ptnr_relation_name_c VARCHAR(20), // FK
	ptnr_comment_c TEXT,
	ptnr_date_created_d DATETIME,
	ptnr_date_modified_d DATETIME,
	smgr_pkey_modified_by_i UNSIGNED INTEGER, // FK
	smgr_okey_modified_by_i UNSIGNED INTEGER, // FK
	smgr_pkey_created_by_i UNSIGNED INTEGER, // FK
	smgr_okey_created_by_i UNSIGNED INTEGER, // FK

	constraint partner_relationship_PK PRIMARY KEY (ptnr_pkey_relation_i,ptnr_okey_relation_i,ptnr_pkey_partner_i,ptnr_okey_partner_i),

	constraint partner_relationship_FK1 FOREIGN KEY (ptnr_relation_name_c) REFERENCES ptnr_relation (ptnr_relation_name_c),
	constraint partner_relationship_FK2 FOREIGN KEY (smgr_pkey_modified_by_i,smgr_okey_modified_by_i) REFERENCES ptnr_partner (ptnr_pkey_i,ptnr_okey_i),
	constraint partner_relationship_FK3 FOREIGN KEY (smgr_pkey_created_by_i,smgr_okey_created_by_i) REFERENCES ptnr_partner (ptnr_pkey_i,ptnr_okey_i),
)
