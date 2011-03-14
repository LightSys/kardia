-- MySQL dump 10.11
--
-- Host: localhost    Database: Kardia_DB
-- ------------------------------------------------------
-- Server version	5.0.77

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `Kardia_DB`
--

USE `Kardia_DB`;


--
-- Dumping data for table `a_account`
--

LOCK TABLES `a_account` WRITE;
/*!40000 ALTER TABLE `a_account` DISABLE KEYS */;
INSERT INTO `a_account` (`a_account_code`, `a_ledger_number`, `a_parent_account_code`, `a_acct_type`, `a_account_class`, `a_reporting_level`, `p_banking_details_key`, `a_is_contra`, `a_is_posting`, `a_is_inverted`, `a_is_intrafund_xfer`, `a_is_interfund_xfer`, `a_acct_desc`, `a_acct_comment`, `a_legacy_code`, `a_default_category`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('1000','DEMO',NULL,'A','GEN',1,NULL,'\0','','\0','\0','\0','All Assets',NULL,NULL,'10','2011-03-11 14:20:30','gbeeley','2011-03-13 17:50:04','gbeeley',NULL),('1100','DEMO','1000','A','GEN',1,NULL,'\0','','\0','\0','\0','Cash',NULL,NULL,'10','2011-03-11 14:21:24','gbeeley','2011-03-13 17:50:10','gbeeley',NULL),('2000','DEMO',NULL,'L','GEN',1,NULL,'\0','','','\0','\0','All Liabilities',NULL,NULL,'20','2011-03-11 14:22:31','gbeeley','2011-03-13 17:50:23','gbeeley',NULL),('1900','DEMO','1000','A','GEN',1,NULL,'\0','','\0','\0','\0','Interfund Assets',NULL,NULL,'19','2011-03-11 14:23:14','gbeeley','2011-03-13 17:50:18','gbeeley',NULL),('3000','DEMO',NULL,'Q','GEN',1,NULL,'\0','','','\0','\0','All Equity',NULL,NULL,'30','2011-03-11 14:23:50','gbeeley','2011-03-13 17:50:26','gbeeley',NULL),('3970','DEMO','3000','Q','GEN',1,NULL,'\0','','','\0','\0','Opening Equity',NULL,NULL,'30','2011-03-11 14:24:40','gbeeley','2011-03-13 17:50:29','gbeeley',NULL),('4000','DEMO',NULL,'R','GEN',1,NULL,'\0','','','\0','\0','All External Revenue',NULL,NULL,'40','2011-03-11 14:25:42','gbeeley','2011-03-13 17:50:32','gbeeley',NULL),('5000','DEMO',NULL,'E','GEN',1,NULL,'\0','','\0','\0','\0','All External Expense',NULL,NULL,'50','2011-03-11 14:26:09','gbeeley','2011-03-13 17:50:40','gbeeley',NULL),('4910','DEMO',NULL,'R','GEN',1,NULL,'\0','','','','\0','Within-Fund Xfer Revenue',NULL,NULL,'41','2011-03-11 14:27:28','gbeeley','2011-03-13 17:50:35','gbeeley',NULL),('4920','DEMO',NULL,'R','GEN',1,NULL,'\0','','','\0','','Interfund Xfer Revenue',NULL,NULL,'42','2011-03-11 14:27:56','gbeeley','2011-03-13 17:50:38','gbeeley',NULL),('5910','DEMO',NULL,'E','GEN',1,NULL,'\0','','\0','','\0','Within-Fund Xfer Expense',NULL,NULL,'51','2011-03-11 14:28:35','gbeeley','2011-03-13 17:50:43','gbeeley',NULL),('5920','DEMO',NULL,'E','GEN',1,NULL,'\0','','\0','\0','','Interfund Xfer Expense',NULL,NULL,'52','2011-03-11 14:29:04','gbeeley','2011-03-13 17:50:47','gbeeley',NULL),('4100','DEMO','4000','R','GEN',1,NULL,'\0','','','\0','\0','Gift Revenue','',NULL,'40','2011-03-13 18:38:38','gbeeley','2011-03-13 18:38:38','gbeeley',NULL),('2120','DEMO','2000','L','GEN',1,NULL,'\0','','','\0','\0','Gifts Payable to Missionary','',NULL,'20','2011-03-13 18:39:29','gbeeley','2011-03-13 18:40:57','gbeeley',NULL);
/*!40000 ALTER TABLE `a_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_account_category`
--

LOCK TABLES `a_account_category` WRITE;
/*!40000 ALTER TABLE `a_account_category` DISABLE KEYS */;
INSERT INTO `a_account_category` (`a_account_category`, `a_ledger_number`, `a_acct_type`, `a_is_intrafund_xfer`, `a_is_interfund_xfer`, `a_acct_cat_desc`, `a_acct_cat_comment`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('10','DEMO','A','\0','\0','Assets',NULL,'2011-03-11 14:30:05','gbeeley','2011-03-11 14:30:06','gbeeley',NULL),('19','DEMO','A','\0','','Interfund Assets',NULL,'2011-03-11 14:30:32','gbeeley','2011-03-11 14:30:33','gbeeley',NULL),('20','DEMO','L','\0','\0','Liabilities',NULL,'2011-03-11 14:30:50','gbeeley','2011-03-11 14:30:51','gbeeley',NULL),('30','DEMO','Q','\0','\0','Equity',NULL,'2011-03-11 14:31:08','gbeeley','2011-03-11 14:31:08','gbeeley',NULL),('40','DEMO','R','\0','\0','Revenues',NULL,'2011-03-11 14:31:23','gbeeley','2011-03-11 14:31:24','gbeeley',NULL),('41','DEMO','R','','\0','Within Fund Revenue',NULL,'2011-03-11 14:31:54','gbeeley','2011-03-11 14:31:55','gbeeley',NULL),('42','DEMO','R','\0','','Interfund Revenue',NULL,'2011-03-11 14:32:11','gbeeley','2011-03-11 14:32:12','gbeeley',NULL),('50','DEMO','E','\0','\0','Expenses',NULL,'2011-03-11 14:32:31','gbeeley','2011-03-11 14:32:32','gbeeley',NULL),('51','DEMO','E','','\0','Within Fund Expense',NULL,'2011-03-11 14:32:44','gbeeley','2011-03-11 14:32:46','gbeeley',NULL),('52','DEMO','E','\0','','Interfund Expense',NULL,'2011-03-11 14:32:59','gbeeley','2011-03-11 14:33:00','gbeeley',NULL);
/*!40000 ALTER TABLE `a_account_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_account_class`
--

LOCK TABLES `a_account_class` WRITE;
/*!40000 ALTER TABLE `a_account_class` DISABLE KEYS */;
INSERT INTO `a_account_class` (`a_account_class`, `a_ledger_number`, `a_acct_class_desc`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('GEN','DEMO','General Purpose','2011-03-13 17:46:52','gbeeley','2011-03-13 17:46:54','gbeeley',NULL);
/*!40000 ALTER TABLE `a_account_class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_account_usage`
--

LOCK TABLES `a_account_usage` WRITE;
/*!40000 ALTER TABLE `a_account_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_account_usage` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Dumping data for table `a_acct_analysis_attr`
--

LOCK TABLES `a_acct_analysis_attr` WRITE;
/*!40000 ALTER TABLE `a_acct_analysis_attr` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_acct_analysis_attr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_admin_fee_type`
--

LOCK TABLES `a_admin_fee_type` WRITE;
/*!40000 ALTER TABLE `a_admin_fee_type` DISABLE KEYS */;
INSERT INTO `a_admin_fee_type` (`a_ledger_number`, `a_admin_fee_type`, `a_admin_fee_subtype`, `a_admin_fee_type_desc`, `a_is_default_subtype`, `a_default_percentage`, `a_tmp_total_percentage`, `a_tmp_fixed_percentage`, `a_comment`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('DEMO','GEN','A','General Admin Fees','',0.1,0.1,0,NULL,'2011-03-12 12:12:37','gbeeley','2011-03-12 12:12:37','gbeeley',NULL);
/*!40000 ALTER TABLE `a_admin_fee_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_admin_fee_type_item`
--

LOCK TABLES `a_admin_fee_type_item` WRITE;
/*!40000 ALTER TABLE `a_admin_fee_type_item` DISABLE KEYS */;
INSERT INTO `a_admin_fee_type_item` (`a_ledger_number`, `a_admin_fee_type`, `a_admin_fee_subtype`, `a_dest_cost_center`, `a_percentage`, `a_is_fixed`, `a_comment`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('DEMO','GEN','A','GEN000',0.1,'\0','10% to General Fund','2011-03-12 12:14:12','gbeeley','2011-03-12 12:14:12','gbeeley',NULL);
/*!40000 ALTER TABLE `a_admin_fee_type_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_admin_fee_type_item_tmp`
--

LOCK TABLES `a_admin_fee_type_item_tmp` WRITE;
/*!40000 ALTER TABLE `a_admin_fee_type_item_tmp` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_admin_fee_type_item_tmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_admin_fee_type_tmp`
--

LOCK TABLES `a_admin_fee_type_tmp` WRITE;
/*!40000 ALTER TABLE `a_admin_fee_type_tmp` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_admin_fee_type_tmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_analysis_attr`
--

LOCK TABLES `a_analysis_attr` WRITE;
/*!40000 ALTER TABLE `a_analysis_attr` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_analysis_attr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_analysis_attr_value`
--

LOCK TABLES `a_analysis_attr_value` WRITE;
/*!40000 ALTER TABLE `a_analysis_attr_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_analysis_attr_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_batch`
--

LOCK TABLES `a_batch` WRITE;
/*!40000 ALTER TABLE `a_batch` DISABLE KEYS */;
INSERT INTO `a_batch` (`a_batch_number`, `a_ledger_number`, `a_period`, `a_batch_desc`, `a_next_journal_number`, `a_next_transaction_number`, `a_default_effective_date`, `a_origin`, `s_process_code`, `s_process_status_code`, `a_corrects_batch_number`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES (100005,'DEMO','2011.03','Demo Receipting',1,1,'2011-03-13 17:53:45','CR',NULL,NULL,NULL,'2011-03-13 17:53:45','gbeeley','2011-03-13 17:53:45','gbeeley',NULL);
/*!40000 ALTER TABLE `a_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_cc_acct`
--

LOCK TABLES `a_cc_acct` WRITE;
/*!40000 ALTER TABLE `a_cc_acct` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_cc_acct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_cc_admin_fee`
--

LOCK TABLES `a_cc_admin_fee` WRITE;
/*!40000 ALTER TABLE `a_cc_admin_fee` DISABLE KEYS */;
INSERT INTO `a_cc_admin_fee` (`a_cost_center`, `a_ledger_number`, `a_admin_fee_type`, `a_default_subtype`, `a_percentage`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('PRJ000','DEMO','GEN','A',NULL,'2011-03-12 12:15:55','gbeeley','2011-03-12 12:15:55','gbeeley',NULL);
/*!40000 ALTER TABLE `a_cc_admin_fee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_cc_analysis_attr`
--

LOCK TABLES `a_cc_analysis_attr` WRITE;
/*!40000 ALTER TABLE `a_cc_analysis_attr` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_cc_analysis_attr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_cc_auto_subscribe`
--

LOCK TABLES `a_cc_auto_subscribe` WRITE;
/*!40000 ALTER TABLE `a_cc_auto_subscribe` DISABLE KEYS */;
INSERT INTO `a_cc_auto_subscribe` (`a_cost_center`, `a_ledger_number`, `m_list_code`, `a_minimum_gift`, `a_subscribe_months`, `a_comments`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('GEN000','DEMO','M000','0.0000',NULL,NULL,'2011-03-12 12:20:20','gbeeley','2011-03-12 12:20:20','gbeeley',NULL),('PRJ000','DEMO','M001','0.0000',NULL,NULL,'2011-03-12 12:20:34','gbeeley','2011-03-12 12:20:34','gbeeley',NULL);
/*!40000 ALTER TABLE `a_cc_auto_subscribe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_cc_receipting`
--

LOCK TABLES `a_cc_receipting` WRITE;
/*!40000 ALTER TABLE `a_cc_receipting` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_cc_receipting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_cc_receipting_accts`
--

LOCK TABLES `a_cc_receipting_accts` WRITE;
/*!40000 ALTER TABLE `a_cc_receipting_accts` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_cc_receipting_accts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_cost_center`
--

LOCK TABLES `a_cost_center` WRITE;
/*!40000 ALTER TABLE `a_cost_center` DISABLE KEYS */;
INSERT INTO `a_cost_center` (`a_cost_center`, `a_ledger_number`, `a_parent_cost_center`, `a_bal_cost_center`, `a_cost_center_class`, `a_reporting_level`, `a_is_posting`, `a_is_external`, `a_is_balancing`, `a_restricted_type`, `a_cc_desc`, `a_cc_comments`, `a_legacy_code`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('GEN000','DEMO',NULL,'GEN000','ORG',1,'',NULL,'','N','General Fund',NULL,'','2011-03-12 12:07:39','gbeeley','2011-03-13 17:51:16','gbeeley',NULL),('PRJ000','DEMO',NULL,'PRJ000','PRO',1,'','','','T','Demo Project',NULL,'','2011-03-12 12:14:56','gbeeley','2011-03-13 17:51:37','gbeeley',NULL);
/*!40000 ALTER TABLE `a_cost_center` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_cost_center_class`
--

LOCK TABLES `a_cost_center_class` WRITE;
/*!40000 ALTER TABLE `a_cost_center_class` DISABLE KEYS */;
INSERT INTO `a_cost_center_class` (`a_cost_center_class`, `a_ledger_number`, `a_acct_class_desc`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('DEP','DEMO','Department','2011-03-13 17:47:32','gbeeley','2011-03-13 17:47:34','gbeeley',NULL),('FLD','DEMO','Field','2011-03-13 17:47:43','gbeeley','2011-03-13 17:47:43','gbeeley',NULL),('MIS','DEMO','Missionary','2011-03-13 17:47:51','gbeeley','2011-03-13 17:47:52','gbeeley',NULL),('ORG','DEMO','Organization','2011-03-13 17:48:01','gbeeley','2011-03-13 17:48:01','gbeeley',NULL),('PRO','DEMO','Project','2011-03-13 17:48:08','gbeeley','2011-03-13 17:48:09','gbeeley',NULL),('SPC','DEMO','Special','2011-03-13 17:48:17','gbeeley','2011-03-13 17:48:18','gbeeley',NULL);
/*!40000 ALTER TABLE `a_cost_center_class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_cost_center_prefix`
--

LOCK TABLES `a_cost_center_prefix` WRITE;
/*!40000 ALTER TABLE `a_cost_center_prefix` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_cost_center_prefix` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_ledger`
--

LOCK TABLES `a_ledger` WRITE;
/*!40000 ALTER TABLE `a_ledger` DISABLE KEYS */;
INSERT INTO `a_ledger` (`a_ledger_number`, `a_is_posting`, `a_next_batch_number`, `a_ledger_desc`, `a_ledger_comment`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('DEMO','',100006,'Demonstration',NULL,'2011-03-11 14:19:18','gbeeley','2011-03-11 14:19:20','gbeeley',NULL);
/*!40000 ALTER TABLE `a_ledger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_payroll`
--

LOCK TABLES `a_payroll` WRITE;
/*!40000 ALTER TABLE `a_payroll` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_payroll` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_payroll_form_group`
--

LOCK TABLES `a_payroll_form_group` WRITE;
/*!40000 ALTER TABLE `a_payroll_form_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_payroll_form_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_payroll_group`
--

LOCK TABLES `a_payroll_group` WRITE;
/*!40000 ALTER TABLE `a_payroll_group` DISABLE KEYS */;
INSERT INTO `a_payroll_group` (`a_ledger_number`, `a_payroll_group_id`, `a_payroll_group_name`, `a_payroll_interval`, `a_cost_center`, `a_liab_cost_center`, `a_cash_cost_center`, `a_service_bureau_id`, `a_service_bureau_group_name`, `a_start_date`, `a_end_date`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('DEMO',1,'Demo Group','5','GEN000','GEN000','GEN000',NULL,NULL,NULL,NULL,'2011-03-12 00:09:38','gbeeley','2011-03-12 00:09:39','gbeeley',NULL);
/*!40000 ALTER TABLE `a_payroll_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_payroll_import`
--

LOCK TABLES `a_payroll_import` WRITE;
/*!40000 ALTER TABLE `a_payroll_import` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_payroll_import` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_payroll_item`
--

LOCK TABLES `a_payroll_item` WRITE;
/*!40000 ALTER TABLE `a_payroll_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_payroll_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_payroll_item_class`
--

LOCK TABLES `a_payroll_item_class` WRITE;
/*!40000 ALTER TABLE `a_payroll_item_class` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_payroll_item_class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_payroll_item_import`
--

LOCK TABLES `a_payroll_item_import` WRITE;
/*!40000 ALTER TABLE `a_payroll_item_import` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_payroll_item_import` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_payroll_item_type`
--

LOCK TABLES `a_payroll_item_type` WRITE;
/*!40000 ALTER TABLE `a_payroll_item_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_payroll_item_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_period`
--

LOCK TABLES `a_period` WRITE;
/*!40000 ALTER TABLE `a_period` DISABLE KEYS */;
INSERT INTO `a_period` (`a_period`, `a_ledger_number`, `a_parent_period`, `a_status`, `a_summary_only`, `a_start_date`, `a_end_date`, `a_first_opened`, `a_last_closed`, `a_archived`, `a_period_desc`, `a_period_comment`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('2011YEAR','DEMO',NULL,'O','','2011-01-01 00:00:00','2011-12-31 23:59:00','2011-01-01 00:00:00',NULL,NULL,'Calendar Year 2011',NULL,'2011-03-11 14:34:27','gbeeley','2011-03-11 14:34:29','gbeeley',NULL),('2011.01','DEMO','2011YEAR','O','\0','2011-01-01 00:00:00','2011-01-31 23:59:00','2011-01-01 00:00:00',NULL,NULL,'January 2011',NULL,'2011-03-11 14:35:13','gbeeley','2011-03-11 14:35:14','gbeeley',NULL),('2011.02','DEMO','2011YEAR','O','\0','2011-02-01 00:00:00','2011-02-28 23:59:00','2011-02-01 00:00:00',NULL,NULL,'February 2011',NULL,'2011-03-11 14:35:41','gbeeley','2011-03-11 14:35:42','gbeeley',NULL),('2011.03','DEMO','2011YEAR','O','\0','2011-03-01 00:00:00','2011-03-31 23:59:00','2011-03-01 00:00:00',NULL,NULL,'March 2011',NULL,'2011-03-11 14:36:17','gbeeley','2011-03-11 14:36:18','gbeeley',NULL),('2011.04','DEMO','2011YEAR','N','\0','2011-04-01 00:00:00','2011-04-30 23:59:00',NULL,NULL,NULL,'April 2011',NULL,'2011-03-11 14:36:55','gbeeley','2011-03-11 14:36:56','gbeeley',NULL);
/*!40000 ALTER TABLE `a_period` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_period_usage`
--

LOCK TABLES `a_period_usage` WRITE;
/*!40000 ALTER TABLE `a_period_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_period_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_reporting_level`
--

LOCK TABLES `a_reporting_level` WRITE;
/*!40000 ALTER TABLE `a_reporting_level` DISABLE KEYS */;
INSERT INTO `a_reporting_level` (`a_reporting_level`, `a_ledger_number`, `a_level_desc`, `a_level_rpt_desc`, `a_level_comment`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES (1,'DEMO','All Reports','Basic Detail',NULL,'2011-03-11 14:37:36','gbeeley','2011-03-11 14:37:42','gbeeley',NULL);
/*!40000 ALTER TABLE `a_reporting_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_subtrx_cashdisb`
--

LOCK TABLES `a_subtrx_cashdisb` WRITE;
/*!40000 ALTER TABLE `a_subtrx_cashdisb` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_subtrx_cashdisb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_subtrx_cashxfer`
--

LOCK TABLES `a_subtrx_cashxfer` WRITE;
/*!40000 ALTER TABLE `a_subtrx_cashxfer` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_subtrx_cashxfer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_subtrx_deposit`
--

LOCK TABLES `a_subtrx_deposit` WRITE;
/*!40000 ALTER TABLE `a_subtrx_deposit` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_subtrx_deposit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_subtrx_gift`
--

LOCK TABLES `a_subtrx_gift` WRITE;
/*!40000 ALTER TABLE `a_subtrx_gift` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_subtrx_gift` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_subtrx_gift_group`
--

LOCK TABLES `a_subtrx_gift_group` WRITE;
/*!40000 ALTER TABLE `a_subtrx_gift_group` DISABLE KEYS */;
INSERT INTO `a_subtrx_gift_group` (`a_ledger_number`, `a_batch_number`, `a_gift_number`, `a_period`, `a_amount`, `a_posted`, `a_posted_to_gl`, `a_gift_type`, `a_receipt_number`, `p_donor_partner_id`, `a_receipt_sent`, `a_receipt_desired`, `a_first_gift`, `a_goods_provided`, `a_gift_received_date`, `a_gift_postmark_date`, `a_receipt_sent_date`, `a_comment`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('DEMO',100005,1,'2011.03','100.0000','','','K','30000','100001','','I','\0','0.0000','2011-03-13 17:56:49','2011-03-10 17:56:58','2011-03-13 18:45:15',NULL,'2011-03-13 17:56:49','gbeeley','2011-03-13 17:56:49','gbeeley',NULL);
/*!40000 ALTER TABLE `a_subtrx_gift_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_subtrx_gift_item`
--

LOCK TABLES `a_subtrx_gift_item` WRITE;
/*!40000 ALTER TABLE `a_subtrx_gift_item` DISABLE KEYS */;
INSERT INTO `a_subtrx_gift_item` (`a_ledger_number`, `a_batch_number`, `a_gift_number`, `a_split_number`, `a_period`, `a_cost_center`, `a_account_code`, `a_amount`, `a_recv_document_id`, `a_posted`, `a_posted_to_gl`, `a_gift_admin_fee`, `a_gift_admin_subtype`, `a_calc_admin_fee`, `a_calc_admin_fee_type`, `a_calc_admin_fee_subtype`, `p_recip_partner_id`, `a_anonymous_gift`, `a_personal_gift`, `a_comment`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('DEMO',100005,1,1,'2011.03','PRJ000','4100','100.0000','1234','','',NULL,'A',0.1,'GEN','A',NULL,'\0','\0',NULL,'2011-03-13 17:57:01','gbeeley','2011-03-13 17:57:01','gbeeley',NULL);
/*!40000 ALTER TABLE `a_subtrx_gift_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_subtrx_gift_rcptcnt`
--

LOCK TABLES `a_subtrx_gift_rcptcnt` WRITE;
/*!40000 ALTER TABLE `a_subtrx_gift_rcptcnt` DISABLE KEYS */;
INSERT INTO `a_subtrx_gift_rcptcnt` (`a_ledger_number`, `a_next_receipt_number`, `__cx_osml_control`) VALUES ('DEMO',30001,NULL);
/*!40000 ALTER TABLE `a_subtrx_gift_rcptcnt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_subtrx_xfer`
--

LOCK TABLES `a_subtrx_xfer` WRITE;
/*!40000 ALTER TABLE `a_subtrx_xfer` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_subtrx_xfer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_tax_allowance_table`
--

LOCK TABLES `a_tax_allowance_table` WRITE;
/*!40000 ALTER TABLE `a_tax_allowance_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_tax_allowance_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_tax_filingstatus`
--

LOCK TABLES `a_tax_filingstatus` WRITE;
/*!40000 ALTER TABLE `a_tax_filingstatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_tax_filingstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_tax_table`
--

LOCK TABLES `a_tax_table` WRITE;
/*!40000 ALTER TABLE `a_tax_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `a_tax_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_transaction`
--

LOCK TABLES `a_transaction` WRITE;
/*!40000 ALTER TABLE `a_transaction` DISABLE KEYS */;
INSERT INTO `a_transaction` (`a_ledger_number`, `a_batch_number`, `a_journal_number`, `a_transaction_number`, `a_period`, `a_effective_date`, `a_transaction_type`, `a_cost_center`, `a_account_category`, `a_account_code`, `a_amount`, `a_posted`, `a_modified`, `a_corrected`, `a_correcting`, `a_corrected_batch`, `a_corrected_journal`, `a_corrected_transaction`, `a_reconciled`, `a_postprocessed`, `a_postprocess_type`, `a_origin`, `a_recv_document_id`, `a_sent_document_id`, `p_ext_partner_id`, `p_int_partner_id`, `a_legacy_code`, `a_receipt_sent`, `a_receipt_desired`, `a_first_gift`, `a_gift_type`, `a_goods_provided`, `a_gift_received_date`, `a_gift_postmark_date`, `a_comment`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('DEMO',100005,1,1,'2011.03','2011-03-13 17:53:45','T','PRJ000','40','4100','-100.0000','\0','\0','\0','\0',NULL,NULL,NULL,'\0','\0','XX','CR',NULL,NULL,NULL,NULL,NULL,'','','\0',NULL,'0.0000',NULL,NULL,'1 Gifts for PRJ000','2011-03-13 19:46:58','gbeeley','2011-03-13 19:46:58','gbeeley',NULL),('DEMO',100005,1,2,'2011.03','2011-03-13 17:53:45','T','GEN000','10','1100','100.0000','\0','\0','\0','\0',NULL,NULL,NULL,'\0','\0','XX','CR',NULL,NULL,NULL,NULL,NULL,'\0','\0','\0',NULL,'0.0000',NULL,NULL,'1 Gifts deposited','2011-03-13 19:46:58','gbeeley','2011-03-13 19:46:58','gbeeley',NULL),('DEMO',100005,2,1,'2011.03','2011-03-13 17:53:45','T','PRJ000','52','5700','10.0000','\0','\0','\0','\0',NULL,NULL,NULL,'\0','\0','XX','CR',NULL,NULL,NULL,NULL,NULL,'\0','\0','\0',NULL,'0.0000',NULL,NULL,'Admin fee to GEN000 for gift(s) totaling $100.00 (10% to General Fund)','2011-03-13 19:46:58','gbeeley','2011-03-13 19:46:58','gbeeley',NULL),('DEMO',100005,2,2,'2011.03','2011-03-13 17:53:45','T','GEN000','42','4700','-10.0000','\0','\0','\0','\0',NULL,NULL,NULL,'\0','\0','XX','CR',NULL,NULL,NULL,NULL,NULL,'\0','\0','\0',NULL,'0.0000',NULL,NULL,'Admin fee revenue','2011-03-13 19:46:58','gbeeley','2011-03-13 19:46:58','gbeeley',NULL),('DEMO',100005,1,3,'2011.03','2011-03-13 17:53:45','T','GEN000','19','1900','-100.0000','\0','\0','\0','\0',NULL,NULL,NULL,'\0','\0','XX','CR',NULL,NULL,NULL,NULL,NULL,'\0','\0','\0',NULL,'0.0000',NULL,NULL,'1 transactions for GEN000','2011-03-13 19:46:58','gbeeley','2011-03-13 19:46:58','gbeeley',NULL),('DEMO',100005,1,4,'2011.03','2011-03-13 17:53:45','T','PRJ000','19','1900','100.0000','\0','\0','\0','\0',NULL,NULL,NULL,'\0','\0','XX','CR',NULL,NULL,NULL,NULL,NULL,'\0','\0','\0',NULL,'0.0000',NULL,NULL,'1 transactions for PRJ000','2011-03-13 19:46:58','gbeeley','2011-03-13 19:46:58','gbeeley',NULL),('DEMO',100005,2,3,'2011.03','2011-03-13 17:53:45','T','GEN000','19','1900','10.0000','\0','\0','\0','\0',NULL,NULL,NULL,'\0','\0','XX','CR',NULL,NULL,NULL,NULL,NULL,'\0','\0','\0',NULL,'0.0000',NULL,NULL,'1 transactions for GEN000','2011-03-13 19:46:58','gbeeley','2011-03-13 19:46:58','gbeeley',NULL),('DEMO',100005,2,4,'2011.03','2011-03-13 17:53:45','T','PRJ000','19','1900','-10.0000','\0','\0','\0','\0',NULL,NULL,NULL,'\0','\0','XX','CR',NULL,NULL,NULL,NULL,NULL,'\0','\0','\0',NULL,'0.0000',NULL,NULL,'1 transactions for PRJ000','2011-03-13 19:46:58','gbeeley','2011-03-13 19:46:58','gbeeley',NULL);
/*!40000 ALTER TABLE `a_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `a_transaction_tmp`
--

LOCK TABLES `a_transaction_tmp` WRITE;
/*!40000 ALTER TABLE `a_transaction_tmp` DISABLE KEYS */;
INSERT INTO `a_transaction_tmp` (`a_ledger_number`, `a_batch_number`, `a_journal_number`, `a_transaction_number`, `a_period`, `a_effective_date`, `a_transaction_type`, `a_cost_center`, `a_account_category`, `a_account_code`, `a_amount`, `a_posted`, `a_modified`, `a_corrected`, `a_correcting`, `a_corrected_batch`, `a_corrected_journal`, `a_corrected_transaction`, `a_reconciled`, `a_postprocessed`, `a_postprocess_type`, `a_origin`, `a_recv_document_id`, `a_sent_document_id`, `p_ext_partner_id`, `p_int_partner_id`, `a_legacy_code`, `a_receipt_sent`, `a_receipt_desired`, `a_first_gift`, `a_gift_type`, `a_goods_provided`, `a_gift_received_date`, `a_gift_postmark_date`, `a_comment`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('DEMO',100005,2,1,'2011.03','2011-03-13 17:53:45','T','PRJ000','52','5700','10.0000','\0','\0','\0','\0',NULL,NULL,NULL,'\0','\0','XX','CR',NULL,'GEN000',NULL,NULL,NULL,'\0','\0','\0',NULL,'100.0000',NULL,NULL,'10% to General Fund','2011-03-13 19:46:58','gbeeley','2011-03-13 19:46:58','gbeeley',NULL);
/*!40000 ALTER TABLE `a_transaction_tmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `m_list`
--

LOCK TABLES `m_list` WRITE;
/*!40000 ALTER TABLE `m_list` DISABLE KEYS */;
INSERT INTO `m_list` (`m_list_code`, `m_list_parent`, `m_list_description`, `m_list_status`, `m_list_type`, `m_discard_after`, `m_list_frozen`, `m_date_sent`, `m_charge_ledger`, `p_postal_mode`, `m_charge_cost_ctr`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('M000',NULL,'General Updates','A','P',NULL,'\0',NULL,'DEMO',NULL,'GEN000','2011-03-12 12:18:17','gbeeley','2011-03-12 12:18:19','gbeeley',NULL),('M001',NULL,'Demo Project Updates','A','P',NULL,'\0',NULL,'DEMO',NULL,'PRJ000','2011-03-12 12:18:53','gbeeley','2011-03-12 12:18:53','gbeeley',NULL);
/*!40000 ALTER TABLE `m_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `m_list_membership`
--

LOCK TABLES `m_list_membership` WRITE;
/*!40000 ALTER TABLE `m_list_membership` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_list_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_banking_details`
--

LOCK TABLES `p_banking_details` WRITE;
/*!40000 ALTER TABLE `p_banking_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `p_banking_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_bulk_postal_code`
--

LOCK TABLES `p_bulk_postal_code` WRITE;
/*!40000 ALTER TABLE `p_bulk_postal_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `p_bulk_postal_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_church`
--

LOCK TABLES `p_church` WRITE;
/*!40000 ALTER TABLE `p_church` DISABLE KEYS */;
/*!40000 ALTER TABLE `p_church` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_contact_info`
--

LOCK TABLES `p_contact_info` WRITE;
/*!40000 ALTER TABLE `p_contact_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `p_contact_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_country`
--

LOCK TABLES `p_country` WRITE;
/*!40000 ALTER TABLE `p_country` DISABLE KEYS */;
/*!40000 ALTER TABLE `p_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_donor`
--

LOCK TABLES `p_donor` WRITE;
/*!40000 ALTER TABLE `p_donor` DISABLE KEYS */;
INSERT INTO `p_donor` (`p_partner_key`, `a_gl_ledger_number`, `a_gl_account_code`, `p_account_with_donor`, `p_allow_contributions`, `p_location_id`, `p_contact_id`, `p_org_name_first`, `p_receipt_desired`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('100001','DEMO',NULL,NULL,'',NULL,NULL,'\0','I','2011-03-12 22:39:29','gbeeley','2011-03-12 22:39:31','gbeeley',NULL);
/*!40000 ALTER TABLE `p_donor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_location`
--

LOCK TABLES `p_location` WRITE;
/*!40000 ALTER TABLE `p_location` DISABLE KEYS */;
INSERT INTO `p_location` (`p_partner_key`, `p_location_id`, `p_location_type`, `p_date_effective`, `p_date_good_until`, `p_purge_date`, `p_in_care_of`, `p_address_1`, `p_address_2`, `p_address_3`, `p_city`, `p_state_province`, `p_country_code`, `p_postal_code`, `p_postal_mode`, `p_bulk_postal_code`, `p_certified_date`, `p_postal_status`, `p_record_status_code`, `p_location_comments`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('100000',1,'W',NULL,NULL,NULL,NULL,'1234 Some St.',NULL,NULL,'Anywhere','GA','US','30000',NULL,NULL,NULL,NULL,'A',NULL,'2011-03-12 22:37:50','gbeeley','2011-03-12 22:37:52','gbeeley',NULL),('100001',1,'H',NULL,NULL,NULL,NULL,'5555 Donor Ln',NULL,NULL,'Somewhere','CA',NULL,'90000',NULL,NULL,NULL,NULL,'A',NULL,'2011-03-12 22:38:40','gbeeley','2011-03-12 22:38:40','gbeeley',NULL);
/*!40000 ALTER TABLE `p_location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_partner`
--

LOCK TABLES `p_partner` WRITE;
/*!40000 ALTER TABLE `p_partner` DISABLE KEYS */;
INSERT INTO `p_partner` (`p_partner_key`, `p_creating_office`, `p_parent_key`, `p_partner_class`, `p_status_code`, `p_status_change_date`, `p_title`, `p_given_name`, `p_preferred_name`, `p_surname`, `p_surname_first`, `p_localized_name`, `p_org_name`, `p_gender`, `p_language_code`, `p_acquisition_code`, `p_comments`, `p_record_status_code`, `p_no_solicitations`, `p_no_mail`, `p_cost_center`, `p_best_contact`, `p_merged_with`, `p_legacy_key_1`, `p_legacy_key_2`, `p_legacy_key_3`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES ('100000','100000',NULL,'MIS','A','2011-03-12 22:35:06',NULL,NULL,NULL,NULL,NULL,NULL,'Demo Organization','C',NULL,NULL,NULL,'A','\0','\0','GEN000',NULL,NULL,NULL,NULL,NULL,'2011-03-12 22:35:39','gbeeley','2011-03-12 22:35:42','gbeeley',NULL),('100001','100000',NULL,'IND','A','2011-03-12 22:36:03',NULL,'John',NULL,'Smith','\0',NULL,NULL,'M',NULL,NULL,NULL,'A','\0','\0',NULL,NULL,NULL,NULL,NULL,NULL,'2011-03-12 22:36:36','gbeeley','2011-03-12 22:36:37','gbeeley',NULL);
/*!40000 ALTER TABLE `p_partner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_partner_relationship`
--

LOCK TABLES `p_partner_relationship` WRITE;
/*!40000 ALTER TABLE `p_partner_relationship` DISABLE KEYS */;
/*!40000 ALTER TABLE `p_partner_relationship` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_payee`
--

LOCK TABLES `p_payee` WRITE;
/*!40000 ALTER TABLE `p_payee` DISABLE KEYS */;
/*!40000 ALTER TABLE `p_payee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_person`
--

LOCK TABLES `p_person` WRITE;
/*!40000 ALTER TABLE `p_person` DISABLE KEYS */;
/*!40000 ALTER TABLE `p_person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `p_zipranges`
--

LOCK TABLES `p_zipranges` WRITE;
/*!40000 ALTER TABLE `p_zipranges` DISABLE KEYS */;
/*!40000 ALTER TABLE `p_zipranges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `s_motd`
--

LOCK TABLES `s_motd` WRITE;
/*!40000 ALTER TABLE `s_motd` DISABLE KEYS */;
INSERT INTO `s_motd` (`s_motd_id`, `s_valid_days`, `s_message_title`, `s_message_text`, `s_enabled`, `s_date_created`, `s_created_by`, `s_date_modified`, `s_modified_by`, `__cx_osml_control`) VALUES (1,10,'Welcome to Kardia!','Thank you for trying out the Kardia / Centrallix VM Appliance!\n\nThis version of Kardia is currently incomplete.  We\'re in the process of converting over all of the pieces from a client-specific deployment of Kardia to a very generalized project.  So, you\'ll probably find a few pieces here and there missing or non-functional.\n\nWe hope you enjoy your visit!!','','2011-03-10 15:50:38','gbeeley','2011-03-11 15:24:28','gbeeley',NULL),(4,NULL,'More About Kardia and Centrallix...','The vision of Kardia is for a free ministry administration system built entirely using open source tools and technologies, and which helps to enable local management and customization at each ministry where it is deployed.\n\nCentrallix is an open source application platform that aims to help Kardia reach its goals by implementing a Rich Internet Applicaion (RIA) Declarative Domain Specific Language (D-DSL) infrastructure.  One of the first platforms to use AJAX type technologies, Centrallix has been in development for 12 years.','','2011-03-11 13:15:16','gbeeley','2011-03-11 13:15:16','gbeeley',NULL),(3,NULL,'Need Assistance?','Need some assistance getting started with Kardia or with the VM Appliance?\n\nIf so, subscribe to and drop us a note on the kardia-users mailing list.  See http://kardia.sf.net/ for details.','','2011-03-11 13:13:00','gbeeley','2011-03-11 13:13:00','gbeeley',NULL),(2,NULL,'We Need Your Help!','Interested in contributing to the project?  We\'d love to have you join and help!\n\nThis VM Appliance is set up for development.  If you\'re a C / SQL / Javascript / HTML developer, you can jump right in.  You can SSH to the VM and use \"vi\", or connect to the VM\'s network drives and use your favorite development environment or programmer\'s editor.  The VM automates the whole build process and has the (gdb) debugger available.\n\nBe sure to create a SourceForge account, and subscribe to (and drop us a note on) the \"centrallix-devel\" mailing list - see www.centrallix.net.','','2011-03-11 13:03:59','gbeeley','2011-03-11 13:50:51','gbeeley',NULL);
/*!40000 ALTER TABLE `s_motd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `s_process`
--

LOCK TABLES `s_process` WRITE;
/*!40000 ALTER TABLE `s_process` DISABLE KEYS */;
/*!40000 ALTER TABLE `s_process` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `s_process_status`
--

LOCK TABLES `s_process_status` WRITE;
/*!40000 ALTER TABLE `s_process_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `s_process_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `s_subsystem`
--

LOCK TABLES `s_subsystem` WRITE;
/*!40000 ALTER TABLE `s_subsystem` DISABLE KEYS */;
/*!40000 ALTER TABLE `s_subsystem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `s_user_data`
--

LOCK TABLES `s_user_data` WRITE;
/*!40000 ALTER TABLE `s_user_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `s_user_data` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-03-14  0:07:12
