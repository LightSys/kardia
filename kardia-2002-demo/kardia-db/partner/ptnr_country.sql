CREATE TABLE ptnr_country (
	ptnr_country_code_c VARCHAR(8),

	ptnr_country_name_c VARCHAR(80),
	ptnr_undercover_l BIT,
	ptnr_time_zone_minimum_n DECIMAL(17,2),
	ptnr_intl_access_code_c VARCHAR(8),
	ptnr_intl_telephone_code_i INTEGER,
	ptnr_intl_postal_type_code_c VARCHAR(16), // FK 
	ptnr_time_zone_maximum_n DECIMAL(17,2),
	ptnr_deletable_l BIT,
	ptnr_address_order_i INTEGER,
	ptnr_country_name_local_c VARCHAR(80),

	constraint ptnr_country_PK PRIMARY KEY (ptnr_country_code_c),

	constraint ptnr_country_FK1 FOREIGN KEY (ptnr_intl_postal_type_code_c) REFERENCES ptnr_intl_postal_type (ptnr_intl_postal_type_code_c)
)
