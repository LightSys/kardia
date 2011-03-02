CREATE TABLE ptnr_relation (
	ptnr_relation_name_c VARCHAR(20), //PK

	ptnr_relation_description_c VARCHAR(60),
	ptnr_deletable_l BIT,
	ptnr_reciprocal_description_c VARCHAR(60),
	ptnr_valid_relation_l BIT,

	PRIMARY KEY (ptnr_relation_name_c)
)
