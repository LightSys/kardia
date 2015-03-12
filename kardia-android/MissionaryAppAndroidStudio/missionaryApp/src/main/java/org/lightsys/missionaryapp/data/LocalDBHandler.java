package org.lightsys.missionaryapp.data;

import java.util.ArrayList;
import java.util.HashMap;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

public class LocalDBHandler extends SQLiteOpenHelper{
	
	private static final int DATABASE_VERSION = 7;
	
	//tables
	private static final String TABLE_ACCOUNT = "accounts",
			TABLE_GIFT = "gifts",
			TABLE_DONOR = "donors",
			TABLE_PERIOD = "periods",
			TABLE_FUND = "funds",
			TABLE_PG_MAP = "period_gift_map",
			TABLE_FG_MAP = "fund_gift_map",
			TABLE_DG_MAP = "donor_gift_map",
			TABLE_FP_MAP = "fund_period_map",
            TABLE_PRAYER = "prayer_requests",
            TABLE_PRAYER_DONOR = "donors_praying";
			
	//table columns
	private static final String COLUMN_ID = "id",
				COLUMN_NAME = "name",
				COLUMN_ACCOUNT_ID = "account_id",
				COLUMN_PASSWORD = "password",
				COLUMN_SERVERADDRESS = "server_address",
                COLUMN_ACCOUNT_BALANCE = "account_balance",
				COLUMN_GIFTFUND = "gift_fund",
				COLUMN_GIFTFUNDDESC = "gift_fund_desc",
				COLUMN_AMOUNTWHOLE = "amount_whole",
				COLUMN_AMOUNTPART = "amount_part",
				COLUMN_DATE = "date",
				COLUMN_CHECKNUM = "check_num",
				COLUMN_EMAIL = "email",
				COLUMN_CELLNUMBER = "cell_number",
				COLUMN_DONORIMAGE = "donor_image",
				COLUMN_FUND_DESC = "fund_desc",
				COLUMN_PERIOD_ID = "period_id",
				COLUMN_GIFT_ID = "gift_id",
				COLUMN_FUND_ID = "fund_id",
				COLUMN_DONOR_ID = "donor_id",
				COLUMN_FUND_CLASS = "fund_class",
				COLUMN_ANNOTATION = "annotation",
                COLUMN_SUBJECT = "prayer_subject",
                COLUMN_PRAYERDESC = "prayer_desc";
	
	public LocalDBHandler(Context context, String name, CursorFactory factory, int version){
		super(context, "missionary.db", factory, DATABASE_VERSION);
	}
	
	/**
	 * Creates all tables in the database
	 */
	@Override
	public void onCreate(SQLiteDatabase db) {
		
		//ACCOUNT TABLE
		String CREATE_ACCOUNTS_TABLE = "CREATE TABLE " + TABLE_ACCOUNT + "(" +
				COLUMN_ID +" INTEGER PRIMARY KEY, " + COLUMN_NAME + " TEXT, " 
				+ COLUMN_PASSWORD + " TEXT," + COLUMN_SERVERADDRESS + " TEXT,"
				+ COLUMN_ACCOUNT_ID + " INTEGER" + COLUMN_ACCOUNT_BALANCE + " INTEGER)";
		db.execSQL(CREATE_ACCOUNTS_TABLE);
		
		//GIFT TABLE
		String CREATE_GIFT_TABLE = "CREATE TABLE " + TABLE_GIFT + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY, " + COLUMN_NAME + " TEXT, " +
				COLUMN_GIFTFUND +" TEXT, " + COLUMN_GIFTFUNDDESC + " TEXT, " +
				COLUMN_AMOUNTWHOLE + " INTEGER, " +
				COLUMN_AMOUNTPART + " INTEGER, " + COLUMN_DATE + " TEXT, " + 
				COLUMN_CHECKNUM + " TEXT)";
		db.execSQL(CREATE_GIFT_TABLE);
		//PAYROLL TABLE
		
		//GENERAL TRANSFER TABLE? OR MAYBE SEPERATE TABLES?
		
		//DONOR TABLE
		String CREATE_DONOR_TABLE = "CREATE TABLE " + TABLE_DONOR + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME + " TEXT," +
				COLUMN_EMAIL + " TEXT," + COLUMN_CELLNUMBER + " TEXT," +
				COLUMN_DONORIMAGE + " BOLB)";
		db.execSQL(CREATE_DONOR_TABLE);
		
		//Fund TABLE
		String CREATE_FUND_TABLE = "CREATE TABLE " + TABLE_FUND + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME + " TEXT," +
				COLUMN_FUND_DESC + " TEXT," +
				COLUMN_FUND_CLASS + " TEXT," + COLUMN_ANNOTATION + " TEXT)";
		db.execSQL(CREATE_FUND_TABLE);
		
		//Period Table
		String CREATE_PERIOD_TABLE = "CREATE TABLE " + TABLE_PERIOD + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME + " TEXT," +
				COLUMN_DATE + " TEXT)";
		db.execSQL(CREATE_PERIOD_TABLE);
		
		//Period Gift Map Table
		String CREATE_PG_TABLE = "CREATE TABLE " + TABLE_PG_MAP + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_PERIOD_ID + " INTEGER," +
				COLUMN_GIFT_ID + " INTEGER)";
		db.execSQL(CREATE_PG_TABLE);
		
		//Fund Gift Map Table
		String CREATE_FG_TABLE = "CREATE TABLE " + TABLE_FG_MAP + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_FUND_ID + " INTEGER," +
				COLUMN_GIFT_ID + " INTEGER)";
		db.execSQL(CREATE_FG_TABLE);
		
		//Donor Gift Map Table
		String CREATE_DG_TABLE = "CREATE TABLE " + TABLE_DG_MAP + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_DONOR_ID + " INTEGER," +
				COLUMN_GIFT_ID + " INTEGER)";
		db.execSQL(CREATE_DG_TABLE);
		
		String CREATE_FP_TABLE = "CREATE TABLE " + TABLE_FP_MAP + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_FUND_ID + " INTEGER," +
				COLUMN_PERIOD_ID + " INTEGER)";
		db.execSQL(CREATE_FP_TABLE);

        //Prayer Table
        String CREATE_PRAYER_TABLE = "CREATE TABLE " + TABLE_PRAYER + "(" +
                COLUMN_DATE + " TEXT," + COLUMN_SUBJECT + " TEXT," +
                COLUMN_PRAYERDESC + " TEXT," + COLUMN_ID + "INTEGER)";
        db.execSQL(CREATE_PRAYER_TABLE);

        //Prayer-Donor Table
        String CREATE_PRAYER_DONOR_TABLE = "CREATE TABLE " + TABLE_PRAYER_DONOR + "(" +
                COLUMN_ID + " INTEGER," + COLUMN_DONOR_ID + " INTEGER)";
        db.execSQL(CREATE_PRAYER_DONOR_TABLE);
		
		//MAP TABLE FOR GIFT AND DONOR (OR HAVE A DONOR ID WITHIN THE GIFT TABLE?)
		
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		
	}
	
	/* *** Add Methods *** */
	
	public void addAccount(Account account){
		ContentValues values = new ContentValues();
		values.put(COLUMN_NAME, account.getAccountName());
		values.put(COLUMN_PASSWORD, account.getAccountPassword());
		values.put(COLUMN_SERVERADDRESS, account.getServerName());
		values.put(COLUMN_ACCOUNT_ID, account.getAccountID());
        values.put(COLUMN_ACCOUNT_BALANCE, account.getAccountBalance());
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		db.insert(TABLE_ACCOUNT, null, values);
		db.close();
	}
	
	public void addFund(Fund fund){
		ContentValues values = new ContentValues();
		values.put(COLUMN_NAME, fund.getName());
		values.put(COLUMN_FUND_DESC, fund.getFund_desc());
		values.put(COLUMN_FUND_CLASS, fund.getFund_class());
		values.put(COLUMN_ANNOTATION, fund.getAnnotation());
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		db.insert(TABLE_FUND, null, values);
		db.close();
	}
	
	public void addPeriod(Period period){
		ContentValues values = new ContentValues();
		values.put(COLUMN_NAME, period.getName());
		values.put(COLUMN_DATE, period.getDate());
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		db.insert(TABLE_PERIOD, null, values);
		db.close();
	}
	
	public void addFundPeriod(int fund_id, int period_id){
		ContentValues values = new ContentValues();
		values.put(COLUMN_FUND_ID, fund_id);
		values.put(COLUMN_PERIOD_ID, period_id);
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		db.insert(TABLE_FP_MAP, null, values);
		db.close();
	}
	
	public void addGift(Gift gift){
		ContentValues values = new ContentValues();
		values.put(COLUMN_GIFT_ID, gift.getId());
		values.put(COLUMN_NAME, gift.getName());
		values.put(COLUMN_GIFTFUND, gift.getGift_fund());
		values.put(COLUMN_GIFTFUNDDESC, gift.getGift_fund_desc());
		values.put(COLUMN_DATE, gift.getGift_date());
		values.put(COLUMN_AMOUNTWHOLE, gift.getGift_amount()[0]);
		values.put(COLUMN_AMOUNTPART, gift.getGift_amount()[1]);
		values.put(COLUMN_CHECKNUM, gift.getGift_check_num());
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		db.insert(TABLE_GIFT, null, values);
		db.close();
	}
	
	public void addFundGift(int fund_id, int gift_id){
		ContentValues values = new ContentValues();
		values.put(COLUMN_FUND_ID, fund_id);
		values.put(COLUMN_GIFT_ID, gift_id);
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		db.insert(TABLE_FG_MAP, null, values);
		db.close();
	}

    public void addPrayer(Prayer prayer) {
        ContentValues values = new ContentValues();
        values.put(COLUMN_DATE, prayer.getDate());
        values.put(COLUMN_SUBJECT, prayer.getSubject());
        values.put(COLUMN_PRAYERDESC, prayer.getDescription());
        values.put(COLUMN_ID, prayer.getID());

        SQLiteDatabase db = this.getWritableDatabase();

        db.insert(TABLE_PRAYER, null, values);
        db.close();
    }

    public void addPraying(Prayer prayer, Donor donor) {
        ContentValues values = new ContentValues();
        values.put(COLUMN_ID, prayer.getID());
        values.put(COLUMN_DONOR_ID, donor.getId());

        SQLiteDatabase db = this.getWritableDatabase();

        db.insert(TABLE_PRAYER_DONOR, null, values);
        db.close();
    }

    public void updatePrayer(int id, String update) {
        SQLiteDatabase db = this.getWritableDatabase();
        Cursor c = db.rawQuery("SELECT * from " + TABLE_PRAYER + "WHERE ID = " + id, null);
        if (c.moveToNext()) {
            String sub = c.getString(1);
            String desc = c.getString(2);
            db.delete(TABLE_PRAYER, "Integer.parseInt(values.getAsString(id)) = id", null);
            Prayer prayer = new Prayer(sub, desc, id);
            prayer.Update(update);
            addPrayer(prayer);
        }
        db.close();
    }
	
	/* *** Get Methods (Display Lists) *** */

	//These methods (the next 5) need to return the id (from the local database) among other things
	//should return: id, name, amount (whole and part), date
	public ArrayList<HashMap<String, String>> getDisplayGifts() {
		// TODO WRITE THE METHOD <!--Should be done-->.
        ArrayList<HashMap<String,String>> arrayList = new ArrayList<HashMap<String, String>>();
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery("SELECT * FROM " + TABLE_GIFT, null);
        while (c.moveToNext()) {
            if (c.getString(0) == null) {
                break;
            }
            HashMap<String, String> hashMap = new HashMap<String, String>();
            hashMap.put("id", c.getString(0));
            hashMap.put("name", c.getString(1));
            hashMap.put("amount_whole", c.getString(4));
            hashMap.put("amount_part", c.getString(5));
            hashMap.put("date", c.getString(6));
            arrayList.add(hashMap);
        }
		return arrayList;
	}

	//(not sure what else is to be stored or displayed for payroll yet)
	//should return: id, name  
	public ArrayList<HashMap<String, String>> getDisplayPayroll() {
		// TODO WRITE THE METHOD (5).
        ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
        HashMap<String,String> hashMap = new HashMap<String, String>();
        hashMap.put("Hello", "Hello");
        arrayList.add(hashMap);
		return arrayList;
	}
	
	//should return: id, name, image (if one), (maybe something else?)
	public ArrayList<HashMap<String, String>> getDisplayDonors() {
		// TODO WRITE THE METHOD (6) <!--Should be done-->.
        ArrayList<HashMap<String,String>> arrayList = new ArrayList<HashMap<String, String>>();
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery("SELECT * FROM " + TABLE_DONOR, null);

        while (c.moveToNext()) {
            if (c.getString(0) == null) {
                break;
            }
            HashMap<String, String> hashMap = new HashMap<String, String>();
            hashMap.put("id", c.getString(0));
            hashMap.put("name", c.getString(1));
            hashMap.put("donor_image", c.getString(4));
            arrayList.add(hashMap);
        }
        return arrayList;
	}

	//should return: id, name/title, date
	public ArrayList<HashMap<String, String>> getDisplayReports() {
		// TODO WRITE THE METHOD (7).
        /*ArrayList<> arrayList = new ArrayList(HashMap<>());
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery("SELECT * FROM accounts", null);
        while (c.moveToNext()) {
            if(c.getString(0) == null) {
                break;
            }
            HashMap hashMap = new HashMap();
            hashMap.put()
        }*/
        ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
        HashMap<String,String> hashMap = new HashMap<String, String>();
        hashMap.put("Hello", "Hello");
        arrayList.add(hashMap);
        return arrayList;
	}

    //should return: id, short name, long description;
    public ArrayList<HashMap<String, String>> getDisplayPrayers() {
        // TODO WRITE THE METHOD (8) <!--Should be done-->.

        ArrayList<HashMap<String, String>> arrayList = new ArrayList();
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor c = db.rawQuery("SELECT * FROM " + TABLE_PRAYER, null);

        while (c.moveToNext()) {
            if (c.getString(0) == null) {
                break;
            }
            HashMap<String, String> hashMap = new HashMap<String, String>();
            hashMap.put("date", c.getString(0));
            hashMap.put("prayer_subject", c.getString(1));
            hashMap.put("prayer_desc", c.getString(2));
            hashMap.put("id", c.getString(3));
            arrayList.add(hashMap);
        }
        return arrayList;
    }

	//should return: id, name, amount/balance (whole and part) 
	public ArrayList<HashMap<String, String>> getDisplayAccounts() {
		// TODO WRITE THE METHOD <!--Should be done-->.

        ArrayList<HashMap<String,String>> arrayList = new ArrayList<HashMap<String, String>>();
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery("SELECT * FROM " + TABLE_ACCOUNT, null);

        while (c.moveToNext()) {
            if (c.getString(0) == null) {
                break;
            }
            HashMap<String, String> hashMap = new HashMap<String, String>();
            hashMap.put("id", c.getString(0));
            hashMap.put("account_id", c.getString(1));
            hashMap.put("password", c.getString(2));
            hashMap.put("server_address", c.getString(3));
            hashMap.put("account_balance", c.getString(4));
            arrayList.add(hashMap);
        }
		return arrayList;
	}

    public ArrayList<HashMap<String, String>> getDisplayPraying(Donor donor) {
        ArrayList<HashMap<String,String>> arrayList = new ArrayList<HashMap<String, String>>();
        SQLiteDatabase db = this.getReadableDatabase();
        String qstring = "SELECT * FROM " + TABLE_PRAYER_DONOR + " WHERE " + COLUMN_DONOR_ID + " = " + donor.getId();
        Cursor c = db.rawQuery(qstring, null);
        while (c.moveToNext()) {
            if(c.getString(0) == null) {
                break;
            }
            HashMap<String, String> hashMap = new HashMap<String, String>();
            hashMap.put("id", c.getString(0));
            arrayList.add(hashMap);
        }
        return arrayList;
    }

    public ArrayList<HashMap<String, String>> getDisplayPraying(Prayer prayer) {
        ArrayList<HashMap<String,String>> arrayList = new ArrayList<HashMap<String, String>>();
        SQLiteDatabase db = this.getReadableDatabase();
        String qstring = "SELECT * FROM " + TABLE_PRAYER_DONOR + " WHERE " + COLUMN_ID + " = " + prayer.getID();
        Cursor c = db.rawQuery(qstring, null);
        while (c.moveToNext()) {
            if(c.getString(0) == null) {
                break;
            }
            HashMap<String, String> hashMap = new HashMap<String, String>();
            hashMap.put("id", c.getString(1));
            arrayList.add(hashMap);
        }
        return arrayList;
    }
	
	/* *** Get Methods *** */
	
	public Account getAccount(){
		Account account = new Account();
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery("SELECT * FROM " + TABLE_ACCOUNT, null);
		
		if(c.moveToFirst()){
			account.setId(Integer.parseInt(c.getString(0)));
			account.setAccountName(c.getString(1));
			account.setAccountPassword(c.getString(2));
			account.setServerName(c.getString(3));
            account.setAccountBalance(Integer.parseInt(c.getString(4)));
		}
		db.close();
		return account;
	}
	
	public boolean hasAccount(){
		boolean accountExists = false;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery("SELECT * FROM " + TABLE_ACCOUNT, null);
		Log.d("BasicAuth", "Returned accounts by \"hasAccount\": " + c.getCount());
		if(c.moveToFirst()){
			accountExists = true;
		}
		db.close();
		return accountExists;
	}
	
	public Gift getGift(int id){
		Gift gift = new Gift();
		
		String qString = "SELECT * FROM gifts WHERE id = " + id;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(qString, null);
		
		if(c.moveToFirst()){
			gift.setId(Integer.parseInt(c.getString(0)));
			gift.setName(c.getString(1));
			gift.setGift_fund(c.getString(2));
			gift.setGift_fund_desc(c.getString(3));
			gift.setGift_amount(new int []{
				Integer.parseInt(c.getString(4)),
				Integer.parseInt(c.getString(5))
			});
			gift.setGift_date(c.getString(6));
			gift.setGift_check_num(c.getString(7));
		}
		db.close();
		return gift;
	}
	
	public Donor getDonor(int id){
		Donor donor = new Donor();
		
		String qString = "SELECT * FROM " + TABLE_DONOR + " WHERE " 
				+ COLUMN_ID + " = " + id;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(qString, null);
		
		if(c.moveToFirst()){
			donor.setId(Integer.parseInt(c.getString(0)));
			donor.setName(c.getString(1));
			donor.setEmail(c.getString(2));
			donor.setCellNumber(c.getString(3));
			donor.setImage(c.getString(4).getBytes());
		}
		db.close();
		return donor;
	}
	
	public ArrayList<Fund> getFunds(){
		ArrayList<Fund> funds = new ArrayList<Fund>();
		
		String qString = "SELECT * FROM " + TABLE_FUND;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(qString, null);
		
		while(c.moveToNext()){
			Fund fund = new Fund();
            if (c.getString(0) == null) {
                break;
            }
			fund.setId(Integer.parseInt(c.getString(0)));
			fund.setName(c.getString(1));
			fund.setFund_desc(c.getString(2));
			fund.setFund_class(c.getString(3));
			fund.setAnnotation(c.getString(4));
			
			funds.add(fund);
		}
		db.close();
		return funds;
	}
	
	public Fund getFund(int id){
		Fund fund = new Fund();
		
		String qString = "SELECT * FROM " + TABLE_FUND + " WHERE "
				+ COLUMN_ID + " = " + id;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(qString, null);
		
		if(c.moveToFirst()){
			fund.setId(Integer.parseInt(c.getString(0)));
			fund.setName(c.getString(1));
			fund.setFund_desc(c.getString(2));
			fund.setFund_class(c.getString(3));
			fund.setAnnotation(c.getString(4));
		}
		db.close();
		return fund;
	}
	
	public ArrayList<String> getFundNames(){
		ArrayList<String> fundNames = new ArrayList<String>();
		
		String qString = "SELECT " + COLUMN_NAME + " FROM " + TABLE_FUND;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(qString, null);
		
		while(c.moveToNext()){
			fundNames.add(c.getString(0));
		}
		db.close();
		return fundNames;
	}
	
	
	public ArrayList<Period> getPeriods(int fund_id){
		ArrayList<Period> periods = new ArrayList<Period>();
		
		String qString = "SELECT Y.* FROM " + TABLE_PERIOD + " AS Y "
				+ "INNER JOIN " + TABLE_FP_MAP + " AS YFM ON Y."
				+ COLUMN_ID + " = YFM." + COLUMN_PERIOD_ID
				+ " WHERE YFM." + COLUMN_FUND_ID + " = " + fund_id;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(qString, null);
		
		while(c.moveToNext()){
			Period period = new Period();
			period.setId(Integer.parseInt(c.getString(0)));
			period.setName(c.getString(1));
			period.setDate(c.getString(2));
			
			periods.add(period);
		}
		db.close();
		return periods;
	}
	
	
	public ArrayList<String> getPeriodNames(){
		ArrayList<String> periodNames = new ArrayList<String>();
		
		String qString = "SELECT " + COLUMN_NAME + " FROM " + TABLE_PERIOD;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(qString, null);
		
		while(c.moveToNext()){
			periodNames.add(c.getString(0));
		}
		db.close();
		return periodNames;
	}
	
	public ArrayList<String> getPeriodNames(int fund_id){
		ArrayList<String> periodNames = new ArrayList<String>();
		
		String qString = "SELECT Y." + COLUMN_NAME + " FROM " + TABLE_PERIOD + " AS Y "
				+ "INNER JOIN " + TABLE_FP_MAP + " AS YFM ON Y."
				+ COLUMN_ID + " = YFM." + COLUMN_PERIOD_ID
				+ " WHERE YFM." + COLUMN_FUND_ID + " = " + fund_id;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(qString, null);
		
		while(c.moveToNext()){
			periodNames.add(c.getString(0));
		}
		db.close();
		return periodNames;
	}
	
	public int getPeriodId(String name){
		int id = -1;
		
		String qString = "SELECT " + COLUMN_ID + " FROM " + TABLE_PERIOD
				+ " WHERE " + COLUMN_NAME + " = " + name;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(qString, null);
		
		if(c.moveToFirst()){
			id = Integer.parseInt(c.getString(0));
		}
		db.close();
		return id;
	}
	
	public ArrayList<String> getTransactions(){
		ArrayList<String> transactions = new ArrayList<String>();
		
		String qString = "SELECT " + COLUMN_NAME + " FROM " + TABLE_GIFT;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(qString, null);
		
		while(c.moveToNext()){
			transactions.add(c.getString(0));
		}
		db.close();
		return transactions;
	}
	
	/**
	 * @param type, which table to pull from - 'fund','gift', or 'year'
	 * @return the id of the last element in the given table
	 */
	public int getLastId(String type){
		int id = 0;
		
		String queryString = "SELECT " + COLUMN_ID + " FROM ";
		
		if(type.equals("fund")){
			queryString += TABLE_FUND;
		}
		else if(type.equals("gift")){
			queryString += TABLE_GIFT;
		}
		else if(type.equals("period")){
			queryString += TABLE_PERIOD;
		}
		
		queryString += " ORDER BY " + COLUMN_ID + " DESC LIMIT 1";
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		if(c.moveToFirst()){
			id = Integer.parseInt(c.getString(0));
		}
		db.close();
		return id;
		
	}

    public Prayer getPrayer() {
        Prayer prayer = new Prayer();
        String queryString = "SELECT * FROM " + TABLE_PRAYER;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);
        if(c.moveToFirst()){
            prayer.setDate(c.getString(0));
            prayer.setDescription(c.getString(1));
            prayer.setSubject(c.getString(2));
            prayer.setID(Integer.parseInt(c.getString(3)));
        }
        db.close();
        return prayer;
    }

    public Prayer getPrayer(String type, String content) {
        Prayer prayer = new Prayer();
        String queryString = "SELECT * FROM " + TABLE_PRAYER + " WHERE ";

        if(type.equals("date")){
            queryString += COLUMN_DATE;
        }
        else if(type.equals("subject")){
            queryString += COLUMN_SUBJECT;
        }

        queryString += " = " + content;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);
        if(c.moveToFirst()){
            prayer.setDate(c.getString(0));
            prayer.setDescription(c.getString(1));
            prayer.setSubject(c.getString(2));
            prayer.setID(Integer.parseInt(c.getString(3)));
        }
        db.close();
        return prayer;
    }
	
	
	/* *** Delete Methods *** */
	
	public void deleteAll(){
		SQLiteDatabase db = this.getWritableDatabase();
			
		String[] delStrings = {
			TABLE_ACCOUNT,
			TABLE_GIFT,
			TABLE_DONOR
		};
			
		for(String s : delStrings){
			db.delete(s, null, null);
		}
		db.close();
	}

}
