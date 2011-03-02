#if 0
// ***************************************
// FAMILIES
// ***************************************
insert into ptnr_partner_relationship values ( // Luke -> Family
	100, 175,
	105, 175,
	'FAMILY',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Richard -> Family
	101, 175,
	105, 175,
	'FAMILY',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)

insert into ptnr_partner_relationship values ( // Judi -> Family
	102, 175,
	105, 175,
	'FAMILY',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)

insert into ptnr_partner_relationship values ( // Nathan -> Family
	103, 175,
	105, 175,
	'FAMILY',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
#endif
// ***************************************
// RELATIOSHIPS IN FAMILIES
// ***************************************
insert into ptnr_partner_relationship values ( // Luke -> Richard
	101, 175,
	100, 175,
	'CHILD',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Richard -> Luke
	100, 175,
	101, 175,
	'FATHER',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Nathan -> Richard
	101, 175,
	103, 175,
	'CHILD',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Richard -> Nathan
	103, 175,
	101, 175,
	'FATHER',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Judi -> Nathan
	103, 175,
	102, 175,
	'MOTHER',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Nathan -> Judi
	102, 175,
	103, 175,
	'CHILD',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Judi -> Luke
	100, 175,
	102, 175,
	'MOTHER',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Luke -> Judi
	102, 175,
	100, 175,
	'CHILD',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Luke -> Nathan
	103, 175,
	100, 175,
	'SIBLING',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Nathan -> Luke
	100, 175,
	103, 175,
	'SIBLING',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Richard -> Judi
	102, 175,
	101, 175,
	'HUSBAND',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values ( // Judi -> Richard
	101, 175,
	102, 175,
	'WIFE',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
// ***************************************
// CHURCHES
// ***************************************
insert into ptnr_partner_relationship values (
	100, 175,
	400, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	100, 175,
	402, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	101, 175,
	402, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	101, 175,
	401, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	102, 175,
	401, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	103, 175,
	401, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	100, 175,
	401, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	103, 175,
	404, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	103, 175,
	405, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	200, 175,
	404, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	200, 175,
	403, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	200, 175,
	405, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	201, 175,
	405, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	202, 175,
	405, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	203, 175,
	405, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	204, 175,
	405, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	205, 175,
	405, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	209, 175,
	403, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	209, 175,
	404, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	204, 175,
	404, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	205, 175,
	403, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
insert into ptnr_partner_relationship values (
	205, 175,
	402, 175,
	'SUPPCHURCH',
	'',
	'2002-04-23 13:01:47', // date created
	'2002-04-23 13:01:47', // date modified
	100, 175,
	100, 175
)
