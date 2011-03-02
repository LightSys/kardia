CREATE TABLE ptnr_language (
	ptnr_language_code_c VARCHAR(20),

	ptnr_language_description_c VARCHAR(80),
	ptnr_congress_language_l BIT,
	ptnr_deletable_l BIT,

	PRIMARY KEY (ptnr_language_code_c)
)
