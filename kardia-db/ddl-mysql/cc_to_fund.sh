#!/bin/bash
#
# Call from the repository root (kardia-git) directory.
#

find kardia-app/modules -type f -exec sed -i -f kardia-db/ddl-mysql/cc_to_fund.sed {} \;
git mv kardia-app/modules/gl/costctr_one_edit.cmp kardia-app/modules/gl/fund_one_edit.cmp
git mv kardia-app/modules/gl/costctrs_edit.cmp kardia-app/modules/gl/funds_edit.cmp
git mv kardia-app/modules/gl/costctrs.qyt kardia-app/modules/gl/funds.qyt
vi kardia-app/modules/gl/acct_one_edit.cmp
