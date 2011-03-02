create view ptnr_partner_relationship_view as
select
	ptnr_pkey_relation_i,
	ptnr_okey_relation_i,
	ptnr_pkey_partner_i,
	ptnr_okey_partner_i,
	p1.ptnr_relation_name_c,
	ptnr_date_created_d,
	ptnr_date_modified_d,
	smgr_pkey_modified_by_i,
	smgr_okey_modified_by_i,
	smgr_pkey_created_by_i,
	smgr_okey_created_by_i,

	ptnr_relation_description_c,
	ptnr_deletable_l,
	ptnr_reciprocal_description_c,
	ptnr_valid_relation_l
from ptnr_partner_relationship p1, ptnr_relation p2
where p1.ptnr_relation_name_c=p2.ptnr_relation_name_c

union
select
	ptnr_pkey_partner_i,
	ptnr_okey_partner_i,
	ptnr_pkey_relation_i,
	ptnr_okey_relation_i,
	p1.ptnr_relation_name_c,
	ptnr_date_created_d,
	ptnr_date_modified_d,
	smgr_pkey_modified_by_i,
	smgr_okey_modified_by_i,
	smgr_pkey_created_by_i,
	smgr_okey_created_by_i,

	ptnr_reciprocal_description_c,
	ptnr_deletable_l,
	ptnr_relation_description_c,
	ptnr_valid_relation_l
from ptnr_partner_relationship p1, ptnr_relation p2
where p1.ptnr_relation_name_c=p2.ptnr_relation_name_c

//REFERENCES ptnr_partner_relationship
//REFERENCES ptnr_relation
