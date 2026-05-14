/*
=====================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=====================================================================================
Script Purpose:
This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions:
- Truncates the bronze tables before loading data.
- Uses the BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:

None.

This stored procedure does not accept any parameters or return any values.

Usage Example:
EXEC bronze.load_bronze;
=====================================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronz as
begin
	DECLARE @START_TIME DATETIME2, @END_TIME DATETIME2, @BATCH_START_TIME DATETIME2, @BATCH_END_TIME DATETIME2;
	BEGIN TRY
        SET @BATCH_START_TIME  = GETDATE();
		PRINT '-------------------------------------------';
		PRINT 'lOADING BRONZE LAYER';
		PRINT '-------------------------------------------';
		PRINT '===========================================';
		PRINT 'LOADING CRM TABLES';
		PRINT '===========================================';
		SET @START_TIME = GETDATE();
		PRINT '>>TRUNCATING TABLE : Bronze.CRM_Cust_info';
		TRUNCATE TABLE Bronze.CRM_Cust_info;
		PRINT '>>INSERTING DATA INTO : Bronze.CRM_Cust_info';
		BULK INSERT Bronze.CRM_Cust_info 
		from 'F:\SQL Server\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with ( 
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		SET @END_TIME = GETDATE();
		PRINT 'LOADING DURATION:' + CAST (DATEDIFF( SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + 'SECOND';
		--=============================================
		SET @START_TIME = GETDATE();
		PRINT '>>TRUNCATING TABLE : Bronze.CRM_prd_info';
		truncate table Bronze.CRM_prd_info;
		PRINT '>>INSERTING DATA INTO : Bronze.CRM_prd_info';
		BULK INSERT Bronze.CRM_prd_info 
		from 'F:\SQL Server\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with ( 
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		SET @END_TIME = GETDATE();
		PRINT 'LOADING DURATION:' + CAST (DATEDIFF( SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECOND';
	--==================================================
		SET @START_TIME = GETDATE();
		PRINT '>>TRUNCATING TABLE : Bronze.CRM_Sales_details';
		truncate table Bronze.CRM_Sales_details;
		PRINT '>>INSERTING DATA INTO : Bronze.CRM_Sales_details';
		bulk insert Bronze.CRM_Sales_details 
		from 'F:\SQL Server\sql-data-warehouse-project\datasets\source_crm\Sales_details.csv'
		with ( 
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		SET @END_TIME = GETDATE();
		PRINT 'LOADING DURATION:' + CAST (DATEDIFF( SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECOND';
	--================================================
		PRINT '===========================================';
		PRINT 'LOADING ERP TABLES';
		PRINT '===========================================';
		SET @START_TIME = GETDATE();
		PRINT '>>TRUNCATING TABLE : Bronze.erp_CUST_AZ12';
		truncate table Bronze.erp_CUST_AZ12;
		PRINT '>>INSERTING DATA INTO : Bronze.erp_CUST_AZ12';
		bulk insert Bronze.erp_CUST_AZ12 
		from 'F:\SQL Server\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with ( 
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		SET @END_TIME = GETDATE();
		PRINT 'LOADING DURATION:' + CAST (DATEDIFF( SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECOND';
	--=============================================
		SET @START_TIME = GETDATE();
		PRINT '>>TRUNCATING TABLE : Bronze.erp_LOC_A101';
		truncate table Bronze.erp_LOC_A101;
		PRINT '>>INSERTING DATA INTO : Bronze.erp_LOC_A101';
		bulk insert Bronze.erp_LOC_A101
		from 'F:\SQL Server\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with ( 
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		SET @END_TIME = GETDATE();
		PRINT 'LOADING DURATION:' + CAST (DATEDIFF( SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECOND';
	--=========================================
		SET @START_TIME = GETDATE();
		PRINT '>>TRUNCATING TABLE : Bronze.erp_PX_CAT_G1V2';
		truncate table Bronze.erp_PX_CAT_G1V2;
		PRINT '>>INSERTING DATA INTO : Bronze.erp_PX_CAT_G1V2';
		bulk insert Bronze.erp_PX_CAT_G1V2 
		from 'F:\SQL Server\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with ( 
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		SET @END_TIME = GETDATE();
		PRINT 'LOADING DURATION:' + CAST (DATEDIFF( SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' SECOND';
         SET @BATCH_END_TIME = GETDATE();
        PRINT '-------------------------------------------';
        PRINT 'LOADING BRONZE LAYER IS COMPLETED';
        PRINT 'TOTAL DURATION FOR LOADING BRONZE LAYER:' + CAST (DATEDIFF( SECOND, @BATCH_START_TIME, @BATCH_END_TIME) AS NVARCHAR) + ' SECOND';
        PRINT '-------------------------------------------';
    END TRY
	BEGIN CATCH
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
	PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
	PRINT 'ERROR MESSAGE' + CAST (ERROR_NUMBER() AS NVARCHAR);
	PRINT 'ERROR MESSAGE' + CAST (ERROR_STATE() AS NVARCHAR);
	PRINT 'ERROR MESSAGE' + ERROR_SEVERITY();
	PRINT 'ERROR MESSAGE' + ERROR_PROCEDURE();
	PRINT 'ERROR MESSAGE' + CAST (ERROR_LINE() AS NVARCHAR);
	END CATCH
END
