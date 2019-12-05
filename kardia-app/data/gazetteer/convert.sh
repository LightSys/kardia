#!/bin/bash

echo "country_code,postal_code,place_name,admin_name_1,admin_code_1,admin_name_2,admin_code_2,admin_name_3,admin_code_3,latitude,longitude,accuracy" > US.csv
sed 's/	/,/g' < US.txt >> US.csv
