CREATE TABLE ptnr_partner (
		ptnr_pkey_i UNSIGNED INTEGER,  //1
		ptnr_okey_i UNSIGNED INTEGER,  //2

		ptnr_partner_class_c VARCHAR(24), //3
		ptnr_partner_short_name_c VARCHAR(100), //4
		ptnr_acquisition_code_c VARCHAR(16),  	//5
		ptnr_language_code_c VARCHAR(20),		//6
		ptnr_status_code_c VARCHAR(16),			//7
		ptnr_comment_c VARCHAR(255),			//8
		ptnr_restricted_i UNSIGNED INTEGER,		//9
		ptnr_group_id_c VARCHAR(40),			//10
		ptnr_deleted_partner_l BIT,				//11
		ptnr_user_id_c VARCHAR(40),				//12
		smgr_date_created_d DATETIME,			//13
		smgr_date_modified_d DATETIME,			//14
		smgr_pkey_modified_by_i UNSIGNED INTEGER,//15
		smgr_okey_modified_by_i UNSIGNED INTEGER,//16
		smgr_pkey_created_by_i UNSIGNED INTEGER,//17
		smgr_okey_created_by_i UNSIGNED INTEGER,//18
		ptnr_receipt_letter_freq_c VARCHAR(24),	//19
		ptnr_bank_account_number_c VARCHAR(32),	//20
		ptnr_child_indicator_l BIT,				//21
		ptnr_addressee_type_code_c VARCHAR(24),	//22
		ptnr_bank_name_c VARCHAR(64),			//23
		ptnr_sort_code_c VARCHAR(32),			//24
		ptnr_status_change_d DATETIME,			//25
		ptnr_receipt_each_gift_l BIT,			//26
		ptnr_email_gift_statement_l BIT,		//27
		ptnr_partner_short_name_loc_c VARCHAR(96),//28
		ptnr_no_solicitations_l BIT,			//29
		ptnr_anonymous_donor_l BIT,				//30
		ptnr_bank_account_name_c VARCHAR(128),	//31
		ptnr_finance_comment_c VARCHAR(255),	//32
		ptnr_regular_discount_percnt_n DECIMAL(17,2),//33
		ptnr_regular_credit_terms_i UNSIGNED INTEGER,//34
		ptnr_usual_currency_code_c VARCHAR(10), //35
		ptnr_regular_discount_terms_i UNSIGNED INTEGER,//36
		
		constraint ptnr_partner_PK PRIMARY KEY (ptnr_pkey_i, ptnr_okey_i),
		
		constraint ptnr_partner_FK1 FOREIGN KEY (ptnr_acquisition_code_c) REFERENCES ptnr_acquisition (ptnr_acquisition_code_c),
		constraint ptnr_partner_FK2 FOREIGN KEY (ptnr_language_code_c) REFERENCES ptnr_language (ptnr_language_code_c),
		constraint ptnr_partner_FK3 FOREIGN KEY (ptnr_status_code_c) REFERENCES ptnr_partner_status (ptnr_status_code_c),
		constraint ptnr_partner_FK4 FOREIGN KEY (ptnr_addressee_type_code_c) REFERENCES ptnr_addressee_type (ptnr_addressee_type_code_c),
		constraint ptnr_partner_FK5 FOREIGN KEY (smgr_pkey_modified_by_i,smgr_okey_modified_by_i) REFERENCES ptnr_partner (ptnr_pkey_i,ptnr_okey_i),
		constraint ptnr_partner_FK6 FOREIGN KEY (smgr_pkey_created_by_i,smgr_okey_created_by_i) REFERENCES ptnr_partner (ptnr_pkey_i,ptnr_okey_i),
		/*FOREIGN KEY (ptnr_usual_currency_code_c) REFERENCES ??? (???),*/
		/*FOREIGN KEY (ptnr_receipt_letter_frequency_c) REFERENCES ??? (???)*/
)
