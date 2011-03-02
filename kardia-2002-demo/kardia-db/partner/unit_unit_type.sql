CREATE TABLE unit_unit_type (
	unit_unit_type_code_c VARCHAR(24),
	unit_unit_type_name_c VARCHAR(64),

	ptnr_pkey_conference_i UNSIGNED INTEGER,
	ptnr_okey_conference_i UNSIGNED INTEGER,
	ptnr_type_deletable_l BIT,

	constraint unit_unit_type_PK PRIMARY KEY (unit_unit_type_code_c),

	constraint unit_unit_type_FK1 FOREIGN KEY (ptnr_pkey_conference_i,ptnr_okey_conference_i) REFERENCES ptnr_partner (ptnr_pkey_i,ptnr_okey_i),
)
