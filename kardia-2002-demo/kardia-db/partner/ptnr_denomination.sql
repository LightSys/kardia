create table ptnr_denomination (
	ptnr_denomination_code_c varchar(16),
	
	ptnr_valid_denomination_l bit,
	ptnr_denomination_name_c varchar(80),
	ptnr_deleteable_l bit,
	
	PRIMARY KEY (ptnr_denomination_code_c)
)
