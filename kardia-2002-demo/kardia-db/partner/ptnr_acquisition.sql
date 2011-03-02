create table ptnr_acquisition (
	ptnr_acquisition_code_c varchar(16),
	
	ptnr_acquisition_description_c varchar(160),
	ptnr_valid_acquisition_l BIT,
	ptnr_deleteable_l BIT,
	ptnr_recruiting_mission_l BIT,
	
	PRIMARY KEY (ptnr_acquisition_code_c)
)
