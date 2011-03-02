create table ptnr_partner_status (
	ptnr_status_code_c VARCHAR(16),

	ptnr_partner_status_desc_c VARCHAR(120),
	ptnr_include_on_report_l BIT,
	ptnr_deletable_l BIT,

	PRIMARY KEY (ptnr_status_code_c)
)
