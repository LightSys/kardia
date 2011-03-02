create table ptnr_marital_status (
	ptnr_marital_code_c varchar(2),

	ptnr_description_c varchar(80),
	ptnr_assignable_flag_l bit,
	ptnr_assignable_date_d datetime,
	ptnr_deletable_flag_l bit,

	PRIMARY KEY (ptnr_marital_code_c)
)
