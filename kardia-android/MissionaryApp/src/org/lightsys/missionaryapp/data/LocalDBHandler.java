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
			TABLE_FP_MAP = "fund_period_map";
			
	//table columns
	private static final String COLUMN_ID = "id",
				COLUMN_NAME = "name",
				COLUMN_ACCOUNT_ID = "account_id",
				COLUMN_PASSWORD = "password",
				COLUMN_SERVERADDRESS = "server_address",
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
				COLUMN_ANNOTATION = "annotation";
	
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
				+ COLUMN_ACCOUNT_ID + " INTEGER)";
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
		
		//GERNAL TRANSFER TABLE? OR MAYBE SEPERATE TABLES?
		
		//DONOR TABLE
		String CREATE_DONOR_TABLE = "CREATE TABLE " + TABLE_DONOR + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME + " TEXT," +
				COLUMN_EMAIL + " TEXT," + COLUMN_CELLNUMBER + " TEXT," +
				COLUMN_DONORIMAGE + " BOLB)";
		db.execSQL(CREATE_DONOR_TABLE);
		
		//Fund TABLE
		String CREATE_FUND_TABLE = "CREATE TABLE " + TABLE_FUND + "(" +
				COLUMN_ID + " INTGER PRIMARY KEY," + COLUMN_NAME + " TEXT," + 
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
	
	/* *** Get Methods (Display Lists) *** */

	//These methods (the next 5) need to return the id (from the local database) among other things
	//should return: id, name, amount (whole and part), date
	public ArrayList<HashMap<String, String>> getDisplayGifts() {
		// TODO WRITE THE METHOD.
		return null;
	}

	//(not sure what else is to be stored or displayed for payroll yet)
	//should return: id, name  
	public ArrayList<HashMap<String, String>> getDisplayPayroll() {
		// TODO WRITE THE METHOD.
		return null;
	}
	
	//should return: id, name, image (if one), (maybe something else?)
	public ArrayList<HashMap<String, String>> getDisplayDonors() {
		// TODO WRITE THE METHOD.
		return null;
	}

	//should return: id, name/title, date
	public ArrayList<HashMap<String, String>> getDisplayReports() {
		// TODO WRITE THE METHOD.
		return null;
	}

	//should return: id, name, amount/balance (whole and part) 
	public ArrayList<HashMap<String, String>> getDisplayAccounts() {
		// TODO WRITE THE METHOD.
		return null;
	}
	
	/* *** Get Methods *** */
	
	public Account getAccount(){
		Account account = new Account();
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery("SELECT * FROM accounts", null);
		
		if(c.moveToFirst()){
			account.setId(Integer.parseInt(c.getString(0)));
			account.setAccountName(c.getString(1));
			account.setAccountPassword(c.getString(2));
			account.setServerName(c.getString(3));
		}
		db.close();
		return account;
	}
	
	public boolean hasAccount(){
		boolean accountExists = false;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery("SELECT * FROM accounts", null);
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
