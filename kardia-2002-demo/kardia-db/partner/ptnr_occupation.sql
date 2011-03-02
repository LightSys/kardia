create table ptnr_occupation (
	ptnr_occupation_code_c varchar(32),

	ptnr_occupation_description_c varchar(80),
	ptnr_valid_occupation_l bit,
	ptnr_deletable_l bit,

	PRIMARY KEY (ptnr_occupation_code_c)
)
