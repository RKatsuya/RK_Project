


/****************************		1)	DDL – Data Definition Language					**********************************************/

----1)CREATE		 Creates a new table, a view of a table, or other object in database
----2)ALTER			 Modifies an existing database object, such as a table.
----3)DROP			 Deletes an entire table, a view of a table or other object in the database.

--DDL Commands;
-- We first create the database using the DDL command -* CREATE

DROP DATABASE AMAZONSHOP;
GO

DROP DATABASE IF EXISTS AMAZONSHOP;
GO

CREATE DATABASE AMAZONSHOP;
GO

USE AMAZONSHOP;
GO

----------WHAT IS A SCHEMA
----------A schema is a collection of database objects including tables, views, triggers, stored procedures, indexes, etc. 
----------A schema is associated with a username which is known as the schema owner, who is the owner of the logically related database objects.

CREATE SCHEMA SALES;
GO

CREATE TABLE SALES.CUSTOMER
(
 CUSTOMERID           INT IDENTITY(1, 1) NOT NULL, 
 CUSTOMERID_ALTERNATE INT NOT NULL, 
 TITLE                NVARCHAR(8) NULL, 
 FIRSTNAME            VARCHAR(100) NOT NULL, 
 MNAME_INITIAL        CHAR(5) NULL, 
 LASTNAME             VARCHAR(100) NOT NULL, 
 SUFFIX               NVARCHAR(10) NULL, 
 DOB                  DATE NOT NULL, 
 GENDER               CHAR(1) NOT NULL, 
 COMPANY              NVARCHAR(256) NULL, 
 RELATIONSHIPMANAGER  NVARCHAR(256) NULL, 
 EMAIL                NVARCHAR(256) NULL, 
 PHONE                NUMERIC NULL, 
 MODIFIEDDATE         DATETIME NOT NULL
);
GO

----DROP TABLE IF EXISTS SALES.CUSTOMER;
----GO


--  PRIMARY KEY - column of table used to uniquely identify records in a table. It ensures what we all ENTITY INTEGRITY on a table

--To create a make "Customerid" the primary key,  we use the alter command to modify the table and then using ADD CONSTRAINT.
-- Don't forget to use primary command to identify the 'Customerid' 

ALTER TABLE SALES.CUSTOMER
ADD CONSTRAINT PK_CUSTOMER_CUSTOMERID PRIMARY KEY (CUSTOMERID);	-- REMEMBER: --constraint enforces rigidity to ensure that the PK cannot be changed
GO


CREATE TABLE SALES.ADDRESS
(
  ADDRESSID	INT IDENTITY(1,1) NOT NULL
, ADDRESSID_ALTERNATE	VARCHAR(5) NOT NULL
, ADDRESSLINE1	NVARCHAR(60) NOT NULL
, ADDRESSLINE2	NVARCHAR(60) NOT NULL
, CITY	NVARCHAR(30) NOT NULL
, [STATE] VARCHAR NOT NULL
, COUNTRY VARCHAR NOT NULL
, POSTALCODE NVARCHAR(15) NOT NULL
, MODIFIEDDATE DATETIME NOT NULL
);
GO

ALTER TABLE SALES.[ADDRESS]
ADD CONSTRAINT PK_ADDRESS_ADDRESSID PRIMARY KEY (ADDRESSID);
GO


CREATE TABLE [SALES].[CUSTOMERADDRESS]
(
  CUSTOMERID	INT NOT NULL
, ADDRESSID	INT NOT NULL
, ADDRESSTYPE	VARCHAR(30) NOT NULL
, MODIFIEDDATE DATETIME NOT NULL
);
GO

ALTER TABLE SALES.[CUSTOMERADDRESS]
ADD CONSTRAINT PK_CUSTOMERADDRESS_ADDRESSID PRIMARY KEY (ADDRESSID);
GO

--DROP PRIMARY KEY
ALTER TABLE SALES.CUSTOMERADDRESS
DROP CONSTRAINT PK_CUSTOMERADDRESS_ADDRESSID;
GO


--COMPOSITE KEY - case where/when we use 2 or more attributes/columns in a table to uniquely identify a record in a table
ALTER TABLE SALES.[CUSTOMERADDRESS]
ADD CONSTRAINT PK_CUSTOMERADDRESS_CUSTOMERID_ADDRESSID PRIMARY KEY (CUSTOMERID, ADDRESSID);
GO 


-- HOW DO WE LINK ALL THESE 3 TABLES
-- (Notice the CustomerAddress table is having the customerid column, which is a PK in the customer table and the address column, which is a PK in the address table
-- We can reference these columns in the customeraddress to  their parent tables)

--  FOREIGN KEY - column in a table used to reference a primary key in another table
ALTER TABLE SALES.CUSTOMERADDRESS
ADD CONSTRAINT [FK_CUSTOMERADDRESS_CUSTOMER_CUSTOMERID] FOREIGN KEY(CUSTOMERID) REFERENCES SALES.CUSTOMER(CUSTOMERID);
GO

ALTER TABLE SALES.CUSTOMERADDRESS
ADD CONSTRAINT [FK_CUSTOMERADDRESS_ADDRESS_ADDRESSID] FOREIGN KEY(ADDRESSID) REFERENCES SALES.ADDRESS(ADDRESSID);
GO


--------SQL CONSTRAINTS
--------------Constraints are the rules enforced on data columns on table. 
--------------These are used to limit the type of data that can go into a table.
--------------This ensures the accuracy and reliability of the data in the database.

--------------Constraints could be column level or table level. Column level constraints are applied only to one column, whereas table level constraints are applied to the whole table.

--------------Following are commonly used constraints available in SQL:
--------------			NOT NULL Constraint:		Ensures that a column cannot have NULL value.
--------------			DEFAULT Constraint:		Provides a default value for a column when none is specified.
--------------			UNIQUE Constraint:			Ensures that all values in a column are different.
--------------			PRIMARY Key:				Uniquely identified each rows/records in a database table.
--------------			FOREIGN Key:				Uniquely identified a rows/records in any another database table.
--------------			CHECK Constraint:			The CHECK constraint ensures that all values in a column satisfy certain conditions.
--------------			INDEX:						Use to create and retrieve data from the database very quickly.


-- ADDING A NEW COLUMN TO AN ALREADY EXISTING TABLE

-- Say The business rules have changed and we now want to collect customer SSN
ALTER TABLE SALES.CUSTOMER
ADD SSN VARCHAR(9) NOT NULL;
GO

ALTER TABLE SALES.CUSTOMER
ADD CONSTRAINT CHK_CUSTOMER_SSN CHECK(LEN(SSN)=9);
GO

ALTER TABLE SALES.CUSTOMER
ALTER COLUMN PHONE VARCHAR(20) NULL;
GO

ALTER TABLE SALES.CUSTOMER
ADD CONSTRAINT CHK_CUSTOMER_PHONE CHECK(LEN(PHONE)=12 OR LEN(PHONE)=10);
GO

-- Say, we only want our customers to be over 18 years old.
-- So we set a check constraint on customer to ensure that  the date entered on DOB is AT LEAST 18 years ago from the exact date when it is being entered

ALTER TABLE SALES.CUSTOMER
ADD CONSTRAINT CHK_CUSTOMER_DOB CHECK(DOB<= DATEADD(YEAR, -18, GETDATE()));
GO

/********* DEFAULT CONSTRAINT  **********/
-- DEFAULT CONSTRAINTS ARE USED TO PROVIDE A DEFAULT VALUE TO A COLUMN. IF NO VALUE IS ENTERED TO THE FIELD
--, THE DEFAULT VALUE IS APPLIED

USE [AMAZONSHOP]
GO

ALTER TABLE SALES.CUSTOMER
ADD CONSTRAINT df_CUSTOMER_GENDER DEFAULT('N') FOR GENDER;
GO

-- FOR THE TABLES CUSTOMER
--, ADDRESS AND CUSTOMERADDRESS MAKE THE MODIFIEDDATE COLUMN TO DEFAULT TO GETDATE()

ALTER TABLE SALES.CUSTOMER
ADD CONSTRAINT DF_CUSTOMER_MODIFIEDDATE DEFAULT(GETDATE()) FOR MODIFIEDDATE;
GO
ALTER TABLE SALES.ADDRESS
ADD CONSTRAINT DF_ADDRESS_MODIFIEDDATE DEFAULT(GETDATE()) FOR MODIFIEDDATE;
GO
ALTER TABLE SALES.CUSTOMERADDRESS
ADD CONSTRAINT DF_CUSTOMERADDRESS_MODIFIEDDATE DEFAULT(GETDATE()) FOR MODIFIEDDATE;
GO


/**** DROP CONSTRAINT		***/

ALTER TABLE SALES.CUSTOMER
ADD CONSTRAINT DF_CUSTOMER_PHONE DEFAULT('1234567890') FOR PHONE;
GO

ALTER TABLE SALES.CUSTOMER
DROP CONSTRAINT DF_CUSTOMER_PHONE;
GO


/*		UNIQUE CONSTRAINT		*/
-- THE BUSINESS HAS REQUESTED THAT WE MAKE PHONE NUMBERS AND SSN UNIQUE TO EACH CUSTOMER
ALTER TABLE SALES.CUSTOMER
ADD CONSTRAINT UC_CUSTOMER_PHONE UNIQUE(PHONE);
GO

ALTER TABLE SALES.CUSTOMER
ADD CONSTRAINT UC_CUSTOMER_SSN UNIQUE(SSN);
GO

-- THE SALES DEPARTMENT HAS INTRODUCED NEW BUSINESS RULE THAT COMBINATION OF FIRST NAME AND LAST
-- OF A CUSTOMER HAVE TO BE UNIQUE

ALTER TABLE SALES.CUSTOMER
ADD CONSTRAINT UC_CUSTOMER_FIRSTNAME_LASTNAME UNIQUE(FIRSTNAME, LASTNAME);
GO

-- HOW TO DROP A UNIQUE CONSTRAINT
ALTER TABLE SALES.CUSTOMER
DROP CONSTRAINT UC_CUSTOMER_FIRSTNAME_LASTNAME;
GO



/******************		CREATE INDEX		**********/
-------- SYNTAX
---THIS INDEX WILL ALLOW DUPLICATES

-----CREATE INDEX <INDEX_NAME>
-----ON TABLE_1 (COL_1, COL_2, COL_3......);

CREATE INDEX IDX_LASTNAME
ON SALES.CUSTOMER(LASTNAME);
GO

CREATE UNIQUE INDEX IDX_EMAIL
ON SALES.CUSTOMER(EMAIL);
GO

CREATE INDEX IDX_PNAME
ON SALES.CUSTOMER(LASTNAME, FIRSTNAME);
GO


/************************		 CLUSTERED INDEX	************************/
CREATE CLUSTERED INDEX IX_CALENDAR_CALENDARDATE
ON SKYBARRELBANK_UAT.DBO.CALENDAR(CALENDARDATE ASC);
GO


/*************			NON-CLUSTERED INDEX			***********/
CREATE NONCLUSTERED INDEX IX_CUSTOMER_PHONE
ON SALES.CUSTOMER(PHONE ASC);
GO

--- TO SEE THE INDEXES ON A TABLE, WE EXECUTE THE BELOW STORED PROCEDURE
EXECUTE sp_helpindex 'SALES.CUSTOMER';


--- TO TRUNCATE THE TABLE CUSTOMER, WE SIMPLY RUN THE BELOW CODE
TRUNCATE TABLE SALES.CUSTOMER;

-- THE ABOCE CODE THROWS AN ERROR -> Cannot truncate table 'SALES.CUSTOMER' because it is being referenced by a FOREIGN KEY constraint.
-- THIS IS BECAUSE YOU CANNOT DELETE DATA FROM A TABLE WHO'S PRIMARY KEY IS BEING REFERENCED AS A
-- FOREIGN KEY IN ANOTHER TABLE.

-- TO DELETE IT, WE WILL HAVE TO DROP THE FOREIGN KEY
-- ALTERNATIVELY, WE COULD HAVE CREATED A FOREIGN KEY ON THE CUSTOMERADDRESS TABLE THAT DELETES ON CASCADE

ALTER TABLE SALES.CUSTOMERADDRESS
DROP CONSTRAINT [FK_CUSTOMERADDRESS_CUSTOMER_CUSTOMERID];
GO

-- FIRST LETS TEST THE TRUNCATION ON CUSTOMER TABLE
TRUNCATE TABLE SALES.CUSTOMER;

ALTER TABLE SALES.CUSTOMERADDRESS
ADD CONSTRAINT [FK_CUSTOMERADDRESS_CUSTOMER_CUSTOMERID] FOREIGN KEY(CUSTOMERID) 
REFERENCES SALES.CUSTOMER(CUSTOMERID) ON DELETE CASCADE;
GO

-- LET'S TRY AND TRUNCATE THE CUSTOMER TABLE
TRUNCATE TABLE SALES.CUSTOMER;



/*********************		DML COMMANDS			**********************/
--	SELECT
--	INSERT
--	UPDATE
--	DELETE

-- LET'S SAY WE WANT TO INSERT SOME RECORDS INTO THE CUSTOMERADDRESS TABLE
USE AMAZONSHOP
GO

INSERT INTO SALES.CUSTOMERADDRESS( CUSTOMERID, ADDRESSID, ADDRESSTYPE, MODIFIEDDATE)
VALUES ( '29485', '1086', 'MAIN OFFICE', '01-01-2019');
GO

ALTER TABLE SALES.CUSTOMERADDRESS 
DROP CONSTRAINT FK_CUSTOMERADDRESS_ADDRESS_ADDRESSID
GO

ALTER TABLE SALES.CUSTOMERADDRESS 
DROP CONSTRAINT FK_CUSTOMERADDRESS_CUSTOMER_CUSTOMERID
GO

INSERT INTO SALES.CUSTOMERADDRESS( CUSTOMERID, ADDRESSID, ADDRESSTYPE, MODIFIEDDATE)
VALUES ( '29485', '1086', 'MAIN OFFICE', '01-01-2019');
GO

-- LETS ENTER THE RECORD INTO THE TABLE (THIS TIME WE WILL NOT ENTER THE MODIFIEDDATE
INSERT INTO SALES.CUSTOMERADDRESS( CUSTOMERID, ADDRESSID, ADDRESSTYPE)
VALUES (1, 1, '1 N. BALTIMORE STREET')
GO

SELECT * FROM SALES.CUSTOMERADDRESS


INSERT INTO	[Sales].[Customer](Customerid_Alternate,	Title,	FirstName, 	Mname_Initial,	LastName,	Suffix,	DOB,	Gender,		Company,	Relationshipmanager,	Email,	Phone, SSN)
 VALUES
  (121,		'Mr.',		'Orlando',		'N',	'Gee',			NULL,		'03-28-1998',	'M',	'A Bike Store',					'adventure-works\pamela0',			'orlando0@adventure-works.com',		'245-555-0173', '118881111')
, (122,		'Mr.',		'Keith',		NULL,	'Harris',		NULL,		'03-28-1998',	'M',	'Progressive Sports',			'adventure-works\david8',			'keith0@adventure-works.com',		'170-555-0127', '118881112')
, (123,		'Ms.',		'Donna',		'F',	'Carreras',		NULL,		'03-28-1998',	'M',	'Advanced Bike Components',		'adventure-works\jillian0',			'donna0@adventure-works.com',		'279-555-0130', '118881113')
, (124,		'Ms.',		'Janet',		'M',	'Gates',		NULL,		'03-28-1998',	'F',	'Modular Cycle Systems',		'adventure-works\jillian0',			'anet1@adventure-works.com',		'710-555-0173', '118881114')
, (125,		'Mr.',		'Lucy',			NULL,	'Harrington',	NULL,		'03-28-1998',	'F',	'Metropolitan Sports Supply',	'adventure-works\shu0',				'lucy0@adventure-works.com',		'828-555-0186', '118881115')
, (126,		'Ms.',		'Rosmarie',		'J',	'Carroll',		NULL,		'03-28-1998',	'F',	'Aerobic Exercise Company',		'adventure-works\linda3',			'rosmarie0@adventure-works.com',	'244-555-0112', '118881116')
, (127,		'Mr.',		'Dominic',		'P',	'Gash',			NULL,		'03-28-1998',	'F',	'Associated Bikes',				'adventure-works\shu0',				'dominic0@adventure-works.com',		'192-555-0173', '118881117')
, (1210,	'Ms.',		'Kathleen',		'M',	'Garza',		NULL,		'03-28-1998',	'M',	'Rural Cycle Emporium',			'adventure-works\josé1',			'kathleen0@adventure-works.com',	'150-555-0127', '118881118')
;

SELECT *
FROM SALES.CUSTOMER

INSERT INTO	[Sales].[Customer]
(Customerid_Alternate,	Title,	FirstName, 	Mname_Initial,	LastName,	Suffix,	DOB,	Company,	Relationshipmanager,	Email,	Phone, SSN)
 VALUES
  (3,	'ÇÉÁÚ',	'CALVINCE',	'SAMUE', 'KISUMU', '', '01-01-2000',	'SKYBARREL',	'LUCY',	'CAL@SKY.NET',	'4104512348', '999999999')


  SELECT *
FROM SALES.CUSTOMER


INSERT INTO	[Sales].[Customer](Customerid_Alternate,	Title,	FirstName, 	Mname_Initial,	LastName,	Suffix,	DOB,	Company,	Relationshipmanager,	Email,	Phone, SSN)
 VALUES
  (1211,	'Ms.',		'Katherine',	NULL,	'Harding',		NULL,		'03-28-1998',		'Sharp Bikes',					'adventure-works\josé1',			'katherine0@adventure-works.com',	'926-555-0159', '118881119')
, (1212,	'Mr.',		'Johnny',		'A',	'Caprio',		'Jr.',		'03-28-1998',		'Bikes and Motorbikes',			'adventure-works\garrett1',			'johnny0@adventure-works.com',		'112-555-0191', '118881110')


INSERT INTO	[Sales].[Customer](Customerid_Alternate,	Title,	FirstName, 	Mname_Initial,	LastName,	Suffix,	DOB,	Company,	Relationshipmanager,	Email,	Phone, SSN, MODIFIEDDATE)
 VALUES
  (1220,	'Ms.',		'Katherine',	NULL,	'Harding',		NULL,		'03-28-1998',		'Sharp Bikes',					'adventure-works\josé1',			'kathine0@adventure-works.com',	'926-555-0157', '118881159', '01-01-2000')
, (1230,	'Mr.',		'Johnny',		'A',	'Caprio',		'Jr.',		'03-28-1998',		'Bikes and Motorbikes',			'adventure-works\garrett1',			'jny0@adventure-works.com',		'112-555-0194', '118881910', GETDATE())


SELECT *
FROM SALES.CUSTOMER
WHERE CUSTOMERID_ALTERNATE = 1220 OR CUSTOMERID_ALTERNATE = 1230

-- THERE ARE TWO WAYS TO ENTER NULL VALUE TO A COLUMN THAT CAN TAKE NULL VALUES.
-- THE FIRST APPROACH CAN TO EXPLICITLY STATE NULL ON THE LIST OF VALUES ALLIGNED TO THAT COLUMN
-- THE SECOND APPROACH IS TO OMMIT THE COLUMN NAME FROM THE LIST OF COLUMNS ON THSERT STATEMENT



--------------------------------insert into TABLE1 (column1, column2, column4)
--------------------------------values(1, 2, 4)

--------------------------------OR

--------------------------------insert into TABLE1 (column1, column2, column3, column4)
--------------------------------values(1, 2, NULL, 4)



INSERT INTO	[Sales].[Customer](Customerid_Alternate,	Title,	FirstName, 	Mname_Initial,	LastName,	DOB,	Company,	Relationshipmanager,	Email,	Phone, SSN, MODIFIEDDATE)
 VALUES
  (12222,	'Ms.',		'Katherine',	NULL,	'Harding',			'03-28-1998',		'Sharp Bikes',					'adventure-works\josé1',			'katYhine0@adventure-works.com',	'926-567-0157', '118884559', '01-01-2000')
, (125667,	'Mr.',		'Johnny',		'A',	'Caprio',			'03-28-1998',		'Bikes and Motorbikes',			'adventure-works\garrett1',			'jnyY0@adventure-works.com',		'112-555-0178', '118671910', GETDATE())

SELECT *
FROM SALES.CUSTOMER
WHERE CUSTOMERID_ALTERNATE = 12222 OR CUSTOMERID_ALTERNATE = 125667


---		SELECT * FROM TABLENAME
---		SELECT TOP(100) * FROM TABLENAME
---		SELECT COLUMN1, COLUMN4, COLUMN5 FROM TABLE1



/******			UPDATE COMMAND		****/

-- SAY CUSTOMER, OF CUSTOMERID = 5 HAS GOTTEN MARRIED AND NOW CHANGED THEIR NAME TO 'RICHARDSON'. WE NEED TO UPDATE HER LAST NAME ON THE DB TABLE

UPDATE SALES.CUSTOMER
SET LASTNAME = 'RICHARDSON'
WHERE CUSTOMERID = 5;


SELECT * FROM SALES.CUSTOMER WHERE CUSTOMERID = 5

--LETS ASSUME THAT ALL OF OURR CUSTOMERS HAVE GOTTEN A PHD AND NOW THEIR TITLES ARE 'DR'.

UPDATE SALES.CUSTOMER
SET TITLE = 'Dr.'

SELECT * FROM SALES.CUSTOMER

--- FOR SOME REASON, THE BUSINESS RULES HAVE CHANGED AND WE NEED TO ADD A NEW COLUMN FOR NICKNAMES. THE BUSINESS HAS ASKED THAT WE SET THE 
--- NICKNAME TO HAVE SAME VALUES AS THE FIRSTNAME

ALTER TABLE SALES.CUSTOMER
ADD NICKNAME VARCHAR(100) NULL
GO

UPDATE SALES.CUSTOMER
SET NICKNAME = FIRSTNAME;
GO

SELECT * FROM SALES.CUSTOMER


DELETE FROM SALES.CUSTOMER
WHERE CUSTOMERID = 7


---- LET'S SAY THAT THERE WAS AN ERROR IN THE INSERTION OF CUSTOMER (16) COMPANY AND 
---- THAT WE SHOULD DELETE THE COMPANY ENTERED THERE AND LEAVE WITH OUT A VALUE AND NOT DELETE THE ENTIRE RECORD
UPDATE SALES.CUSTOMER
SET COMPANY = NULL
	, RELATIONSHIPMANAGER = 'TOLU'
	, TITLE = NULL
WHERE CUSTOMERID = 9



/**************		THE SELECT STATEMENT	*****/
-- SELECT COMMAND HELPS TO PULL RECORDS FROM DATABASE TABLE/VIEW
-- IT CAN PULL SPECIFIC RECORDS FROM COMBINATIONS OF TABLES
-- A SELECT STATEMENT IS USED TO RETRIEVE DATA FROM A DATABASE'S TABLE/VIEW/CTE ETC

/********	FROM HERE NOW WE WILL USE THE SKYBARRELBANK_UAT DATABASE		***/
USE SkyBarrelBank_UAT;
GO

SELECT *
FROM DBO.State

SELECT STATEID, STATENAME, CREATEDATE
FROM DBO.State

SELECT TOP(10) STATEID, STATENAME
FROM DBO.State

-- YOUR DATA ANALYTICS MANAGER HAS REQUESTED YOU TO RETURN A LIST OF ALL BORROWERS IN THE DATABASE
-- THE LIST WILL BE USED BY SERVICING TO CONTACT THE CUSTOMERS
-- PLEASE RETURN THEIR FIRSTNAMES, LAST NAMES AND PHONE NUMBERS AND EMAILS
SELECT BorrowerFirstName, BorrowerLastName, PhoneNumber, EMAIL
FROM DBO.Borrower

-- PLEASE RENAME THE COLUMN NAMES ON YOUR OUTPUT TO MAKE THEN PRESENTABLE
SELECT BorrowerFirstName AS [FIRST NAME], 
       BorrowerLastName AS [LAST NAME], 
       PhoneNumber AS [PHONE NUMBER], 
       EMAIL AS [EMAIL ADDRESS]
FROM DBO.Borrower;


---- THE MARKETING HAS REQUEST FOR THE OF BORROWER ADDRESSES OF BORROWERS IN CERTAIN ZIPCODES. THIS WILL BE USED TO 
-- TO SEND OUT MAILS SINCE THEY WAS BADLY AFFECTED IN THE WINTER
SELECT StreetAddress,ZIP
FROM DBO.BorrowerAddress
WHERE ZIP = '19095' OR ZIP = '12121'OR ZIP = '12570';

--- THE ACCOUNTING TEAM HAS REQUESTED FOR A LIST OF LOANNUMBERS AND PURCHASE AMOUNT 
---WHERE THE PURCHASE AMOUNT IS ABOVE OR EQUAL TO 500,000
SELECT LoanNumber, PurchaseAmount, PurchaseDate
FROM DBO.LoanSetupInformation
WHERE PurchaseAmount >= 5000000


/**********		AND, OR and NOT OPERATORS	******/
-- THESE OPERATORS ARE USED AT THE FILTERING CLAUSE (WHICH ARE THE WHERE CLAUSE OR THE HAVING CLAUSE)
-- tHEY CAN BE USED SEPERATELY OR COMBINE

--- THE AND  and OR OPERATORS ARE USED TO  FILTER RECORDS BASED ON ONE OR MORE CONDITIONS
--- AND - ALL CONDITIONS MUST BE MET
--- OR  -	EITHER CONDITIONS MUST BE MET
--- NOT	-	DISPLAYS A RECORD IF THE CONDITION(S) IS NOT TRUE

--- THE MARKETING TEAM HAS A PROMOTION THAT TARGETS FEMALE BORROWERS WHO ARE US CITZENS.
--- THE HAVE REQUESTED FOR A LIST OF FROM YOU
SELECT BorrowerFirstName, BorrowerLastName, GENDER, CITIZENSHIP
FROM DBO.Borrower
WHERE CITIZENSHIP = 'UNITED STATES' AND GENDER = 'F';


--- LET'S SEE WHERE EITH CONDITION IS MET
SELECT BorrowerFirstName, BorrowerLastName, GENDER, CITIZENSHIP
FROM DBO.Borrower
WHERE CITIZENSHIP = 'UNITED STATES' OR GENDER = 'F';


-- LETS SEE A SCENARIO WHERE CITIZENSHIP IS NOT UNITED STATE
SELECT BorrowerFirstName, BorrowerLastName, GENDER, CITIZENSHIP
FROM DBO.Borrower
WHERE NOT (CITIZENSHIP = 'UNITED STATES' ) ;

SELECT BorrowerFirstName, BorrowerLastName, GENDER, CITIZENSHIP
FROM DBO.Borrower
WHERE CITIZENSHIP <> 'UNITED STATES' ;

SELECT BorrowerFirstName, BorrowerLastName, GENDER, CITIZENSHIP
FROM DBO.Borrower
WHERE CITIZENSHIP != 'UNITED STATES' ;


----	LET'S SEE FILTERING STATEMENTS THAT DEAL WITH NULL AND NOT NOT NULL
SELECT BorrowerFirstName, BeneficiaryName
FROM Borrower
WHERE BeneficiaryName IS NULL

SELECT BorrowerFirstName, BeneficiaryName
FROM Borrower
WHERE BeneficiaryName IS NOT NULL


/*******	 GREATE THAN  EQUAL TO  OR  LES THAN OR GREATER THAN OR EQUAL TO OR LESS THAN OR EQUAL TO ******/

SELECT LoanNumber, ProductID, PurchaseAmount
FROM LoanSetupInformation
WHERE PurchaseAmount > 100000

SELECT LoanNumber, ProductID, PurchaseAmount
FROM LoanSetupInformation
WHERE PurchaseAmount < 500000;

SELECT LoanNumber, ProductID, PurchaseAmount
FROM LoanSetupInformation
WHERE PurchaseAmount <= 5000000;

SELECT LoanNumber, ProductID, PurchaseAmount
FROM LoanSetupInformation
WHERE PurchaseAmount >= 5000000;

SELECT LoanNumber, ProductID, PurchaseAmount
FROM LoanSetupInformation
WHERE PurchaseAmount >= 5000000 AND PurchaseAmount <= 8000000;


---			THE BETWEEN OPERATOR:	WILL RETURN RECORDS THAT ARE BETWEEN THE SPECIFIED BOUNDARIES AND ALSO
--			ANY RECORDS THAT ARE HAVE VALUES EQUAL TO THOSE BOUDARIES
SELECT LoanNumber, ProductID, PurchaseAmount
FROM LoanSetupInformation
WHERE PurchaseAmount BETWEEN 5000000 AND 8000000;


--- THE AND OPERATOR IS MUCH TIGHTER AND IT REQUIRES ALL CONDITIONS TO BE MET. SO THE LOAN MUST A PURCHASE AMOUNT OF
---LESS THAN 5m AND GREATER THAN 8m TO BE RETURNED AS AN OUTPUT
SELECT LoanNumber, ProductID, PurchaseAmount
FROM LoanSetupInformation
WHERE PurchaseAmount < 5000000 AND PurchaseAmount > 8000000;  -- THIS WILL not GENERATE ANY RECORDS/OUTPUT

--- THE OR OPERATOR IS MUCH FLEXIBLE
---	AND & OR ARE USED AT THE WHERE CLAUSE OR THE HAVING CLAUSE OF A SELECT STATEMENT BASED ON THE CONDITIONS OF GIVEN FILTERS
SELECT LoanNumber, ProductID, PurchaseAmount
FROM LoanSetupInformation
WHERE PurchaseAmount < 5000000 OR PurchaseAmount > 8000000;


/***			LIKE OPERATOR		***/

--THE BUSINESS WANTS A LIST OF ALL BORROWERS WHO COME ANY COUNTRY THAT BEGINS WITH 'UNITED'
SELECT BorrowerFirstName, BorrowerLastName, DoB, Citizenship
 FROM SkyBarrelBank_UAT.dbo.Borrower
WHERE Citizenship = 'UNITED STATES' OR Citizenship = 'UNITED KINGDOM';

--- THIS IS A MORE EFFICIENT WAY TO DO THIS
SELECT BorrowerFirstName, BorrowerLastName, DoB, Citizenship
 FROM SkyBarrelBank_UAT.dbo.Borrower
WHERE Citizenship LIKE 'United%';

--- RETURN LIST WHERE BORROWER HAS A PHONE NUMBER BEGINNING WITH '410'OR THE CITIZZENSHIP BEGINS WITH 'UNITED'
SELECT BorrowerFirstName, BorrowerLastName, DoB, Citizenship, PhoneNumber
 FROM SkyBarrelBank_UAT.dbo.Borrower
WHERE PhoneNumber LIKE '410%' or Citizenship LIKE 'United%';

--- RETURN LIST WHERE PHONE NUMBER ENDS WITH '410'
SELECT BorrowerFirstName, BorrowerLastName, DoB, Citizenship, PhoneNumber
 FROM SkyBarrelBank_UAT.dbo.Borrower
WHERE PhoneNumber LIKE '%410';

--- RETURN LIST WHERE PHONE NUMBER CONTAINS THE PATTERN '410'
SELECT BorrowerFirstName, BorrowerLastName, DoB, Citizenship, PhoneNumber
 FROM SkyBarrelBank_UAT.dbo.Borrower
WHERE PhoneNumber LIKE '%410%';

--- RETURN LIST WHERE PHONE NUMBER CONTAINS THE CHARACTER '4'
SELECT BorrowerFirstName, BorrowerLastName, DoB, Citizenship, PhoneNumber
 FROM SkyBarrelBank_UAT.dbo.Borrower
WHERE PhoneNumber LIKE '%4%';

--- RETURN A LIST OF STATES WHERE THE STATEID BEGINS WITH 'M'
SELECT StateID, StateName, CreateDate
FROM State
WHERE StateID LIKE 'M_';

--- RETURN A LIST OF STATES WHERE THE STATEID ENDS WITH 'A'
SELECT StateID, StateName, CreateDate
FROM State
WHERE StateID LIKE '_A';

--- RETURN A LIST OF STATES WHERE THE 4th CHARACTER IS A AND IS OF CHARACTER LENGTH 4;
SELECT StateID, StateName, CreateDate
FROM State
WHERE StateName LIKE '___A';

--- RETURN A LIST OF STATES WHERE THE 4th CHARACTER IS A AND IS OF ANY CHARACTER LENGTH;
SELECT StateID, StateName, CreateDate
FROM State
WHERE StateName LIKE '___A%';

---- RETURN A LIST OF STATES WHERE THE CHARACTERS ( A, B, C, D, E, F) EXISTS
SELECT StateID, StateName, CreateDate
FROM State
WHERE StateName LIKE '%[A-F]%';

---- RETURN A LIST OF STATES WHERE THE FIRST CHARACTER IS ONE OF THESE ( A, B, C, D, E, F) 
SELECT StateID, StateName, CreateDate
FROM State
WHERE StateName LIKE '[A-F]%';

---- RETURN A LIST OF STATES WHERE THE SECOND CHARACTER IS ONE OF THESE ( A, B, C, D, E, F) 
SELECT StateID, StateName, CreateDate
FROM State
WHERE StateName LIKE '_[A-F]%';

--- RETURN LIST WHERE PHONE NUMBER CONTAINS THE AT LEAST ONE OF THESE NUMBERS '3, 4, 5, 6'
SELECT BorrowerFirstName, BorrowerLastName, DoB, Citizenship, PhoneNumber
 FROM SkyBarrelBank_UAT.dbo.Borrower
WHERE PhoneNumber LIKE '%[3-6]%';

SELECT BorrowerFirstName, BorrowerLastName, DoB, Citizenship, PhoneNumber
 FROM SkyBarrelBank_UAT.dbo.Borrower
WHERE PhoneNumber LIKE '[7-9]%';



/****		SQL IN-BUILT FUNCTIONS		**/

/** MATH FUNCTIONS		**/

--- ABS()
select -5 as thenumber;

select abs(-5) as [absolute], -5 as thenumber;


--- SIGN() FUNCTION
DECLARE @Num INT= -5;
SELECT SIGN(@Num) AS Signofnum, SIGN(-5) AS Sign2, SIGN(+5) AS SignOfPlusFive; 

--- SQRT()
SELECT SQRT(9), SQRT(7);

--- POWER()
SELECT POWER(5,2)

----ROUND()
SELECT ROUND(5.98697, 3), ROUND(123, 2), ROUND(0.1, 4)

SELECT ROUND(123*1.00, 2), 123*1.00

SELECT 58.56*1.0000000

SELECT 123*5.6


---- CEILING()		&		FLOOR()
SELECT CEILING(5.124), CEILING(5.999999), FLOOR(5.124), FLOOR(5.999999)

---- AVG() & SUM() & COUNT()

SELECT ROUND(AVG(PurchaseAmount), 2) AS _ROUNDED_AVERAGE, 
       CAST(ROUND(AVG(PurchaseAmount), 2) AS NUMERIC(18,2)) AS CAST_ROUNDED_AVERAGE,
       CAST(AVG(PurchaseAmount) AS NUMERIC(18,2)) AS CASTED_AVERAGE,  
       AVG(PurchaseAmount) AS AVERAGE, 
	   CEILING(AVG(PurchaseAmount)) AS CEILING_AVERAGE,
       FLOOR(AVG(PurchaseAmount)) AS FLOOR_AVERAGE,
	   COUNT(LOANNUMBER) AS NUMBER_OF_LOANS, 
       SUM(PURCHASEAMOUNT) AS TOTAL_LOAN_VOLUME, 
       MIN(PURCHASEAMOUNT) AS MIN_PURCHASED_AMOUNT,
       MAX(PURCHASEAMOUNT) AS MAX_PURCHASED_AMOUNT
FROM SkyBarrelBank_UAT.DBO.LoanSetupInformation;



/*****		STRING FUNCTIONS			****/

----CAST()		&		CONVERT()

DECLARE @date1 DATE= '2021-01-01';
SELECT CAST(@date1  AS VARCHAR) AS DateDatatype, CONVERT(NVARCHAR, @date1) AS DateDataype1 ;
GO

DECLARE @date1 DATETIME= '2021-01-01';
SELECT CAST(@date1  AS VARCHAR) AS DateDatatype, CONVERT(NVARCHAR, @date1) AS DateDataype1 ;
GO

SELECT TOP(100) *
FROM SkyBarrelBank_UAT.DBO.Borrower;

SELECT TaxPayerID_SSN, 
       CAST(TaxPayerID_SSN AS INT) AS SSN_INT, 
       CONVERT(NUMERIC(18, 2), TaxPayerID_SSN) AS SSN_NUMERIC
FROM SkyBarrelBank_UAT.DBO.Borrower;



---- TRY_CAST()			&			try_convert()

--- THE BELOW CODE WILL THROW THIS ERROR --> Error converting data type varchar to bigint.
SELECT PHONE, 
       TRY_CAST(PHONE AS BIGINT)
FROM AMAZONSHOP.SALES.CUSTOMER;


GO
DECLARE @date1 DATE= '2021-01-01';
SELECT       TRY_CAST(@date1  AS INT) AS IntDatatype
	, TRY_CAST(@date1  AS VARCHAR) AS VarcharDatatype
	, TRY_CONVERT(INT, @date1) AS IntDataype1
	, TRY_CONVERT(DATETIME, @date1) AS DateimeDataype1;

SELECT CAST('THIS IS IT' AS VARCHAR(100))

----- CONCAT()		& CONCAT_ws()

SELECT CONCAT('THIS', '-', 'IS', '-', 'IT') AS STRING_CONCATED
, CONCAT_WS('-', 'THIS', 'IS', 'IT')  AS STRING_CONCATED_WS

--- PLEASE RETURN A LIST OF BORROWER FULL NAMES ON ONE COLUMN
SELECT CONCAT(BORROWERFIRSTNAME, ' ', BORROWERLASTNAME) AS BORROWER
          ,  CONCAT_WS(' ', BORROWERFIRSTNAME, BORROWERLASTNAME) AS BORROWER
FROM SKYBARRELBANK_UAT.DBO.BORROWER

SELECT 'THIS' + ' IS ' + 'ME'

SELECT CONCAT(BORROWERFIRSTNAME, ' ', BORROWERLASTNAME, '- ', CAST(DOB AS DATE)) AS BORROWER
          ,  CONCAT_WS('-', BORROWERFIRSTNAME, BORROWERLASTNAME, DOB) AS BORROWER
FROM SKYBARRELBANK_UAT.DBO.BORROWER


---- LEFT()   &   RIGHT()

SELECT 	RIGHT('Samfred', 4) AS ExtractstringRight
	,LEFT('Samfred', 4) AS ExtractstringLeft;

SELECT RIGHT(45858585 , 4)


SELECT RIGHT(CAST(45858585.25525 AS NUMERIC(18,5)) , 4)


----USE CASES

SELECT DISTINCT LEFT(PHONENUMBER, 3) AS AREA_CODES
FROM SKYBARRELBANK_UAT.DBO.BORROWER


--- SUBSTRING()

SELECT SUBSTRING('industry', 3, 4) AS Extractsubstring;

---- CHARINDEX()
--- WILL RETURN THE POSITION OF A CHARACTER IN A STRING
-- THE FIRST PARAMETER IS THE CHARACTER TO BE SEARCHED FOR
--- THE SECOND CHARACTER IS THE CHARACTER TO SEARCHED
-- THE OUTPUT IS ALWAYS AN INTEGER
SELECT CHARINDEX('U', 'INDUSTRY')

--- PATINDEX()
--- WILL RETURN THE POSITION OF A SUBSTRING IN A STRING
-- THE SUBSTRING CAN BE A SINGLE CHARACTER OR A CHARACTER OF ANY LENGTH

SELECT PATINDEX('%DUST%', 'INDUSTRY')

SELECT TOP (100) EMAIL, 
                 CHARINDEX('@', EMAIL) AS CHAR_EMAIL, 
                 PATINDEX('%@%', EMAIL) AS PAT_EMAIL, 
                 REVERSE(EMAIL) AS REVERSED, 
                 CHARINDEX('.', REVERSE(EMAIL)) AS LAST_DOT, 
                 LEN(EMAIL) AS LENGTH_OF_EMAIL, 
                 1 + LEN(EMAIL) - CHARINDEX('.', REVERSE(EMAIL)) AS ACTUAL_POSITION_OF_LAST_DOT, 
                 LEN(EMAIL) - CHARINDEX('@', EMAIL) - CHARINDEX('.', REVERSE(EMAIL)) AS LENGTH_OF_EXAMPLE, 
                 SUBSTRING(EMAIL, CHARINDEX('@', EMAIL) + 1, (LEN(EMAIL) - CHARINDEX('@', EMAIL) - CHARINDEX('.', REVERSE(EMAIL)))) AS EMAIL_DOMAIN
FROM SkyBarrelBank_UAT.DBO.Borrower;

--- GIVE US A COUNT OF EMAIL DOMAINS AND THE NUMBER OF USERS
SELECT SUBSTRING(EMAIL, CHARINDEX('@', EMAIL) + 1, (LEN(EMAIL) - CHARINDEX('@', EMAIL) - CHARINDEX('.', REVERSE(EMAIL)))) AS EMAIL_DOMAIN
, COUNT(*) NUMBER_OF_BORROWERS
FROM SkyBarrelBank_UAT.DBO.Borrower
GROUP BY SUBSTRING(EMAIL, CHARINDEX('@', EMAIL) + 1, (LEN(EMAIL) - CHARINDEX('@', EMAIL) - CHARINDEX('.', REVERSE(EMAIL))));



---- LEN() FUNCTION

SELECT LEN('Tysons Corner') AS Mylength;	-- even the space is counted. Result = 13
SELECT LEN('Tysons Corner  ') AS Mylength;	-- Trailing space is not counted. Result = 13
SELECT LEN('  Tysons Corner  ') AS Mylength;	-- Leading space is counted. Trailing space is not counted. Result = 15

---DATALENGTH() FUNCTION
SELECT DATALENGTH('Tysons Corner') AS Mylength;	-- even the space is counted. Result = 13
SELECT DATALENGTH('Tysons Corner  ') AS Mylength;	-- Trailing space is ARE counted. Result = 15
SELECT DATALENGTH('  Tysons Corner  ') AS Mylength;	-- Leading space is counted. Trailing space is not counted. Result = 15


DECLARE @STRING_VAR VARCHAR(15)= 'SKYBARREL';
DECLARE @STRING_NVAR NVARCHAR(30)= 'SKYBARREL';
DECLARE @STRING_CHAR CHAR(30)= 'SKYBARREL';
SELECT DATALENGTH(@STRING_VAR) DATALEN_STRING_VAR, 
       DATALENGTH(@STRING_NVAR) DATA_LEN_STRING_NVAR, 
       DATALENGTH(@STRING_CHAR) DATA_LEN_STRING_CHAR;



	   --- LTRIM(), RTRIM(), TRIM()
SELECT LTRIM('   Tysons Corner   ') 	-- (Tysons Corner   )
SELECT RTRIM('   Tysons Corner  ') 	 	-- (   Tysons Corner)
SELECT TRIM('  Tysons Corner    ') 	-- (Tysons Corner)


----REPLACE()
SELECT REPLACE('Tysons Corner', 's', 'Z') AS Replaced;
SELECT REPLACE('Tysons Corner', 'TYSONS', 'samfreds') AS Replaced;

---USECASE
SELECT EMAIL, REPLACE(EMAIL, 'EXAMPLE', 'GMAIL')
FROM SkyBarrelBank_UAT.DBO.Borrower;


--- ISNULL()	&	COALESCE()

SELECT ISNULL('MAJOR', 'ERROR'), 
       ISNULL(NULL, 'REPLACEMENT'), 
       COALESCE('MAJOR', 'ERROR'), 
       COALESCE(NULL, 'REPLACEMENT'), 
       COALESCE(NULL, NULL, NULL, NULL, 'THIS', NULL, 'REPLACEMENT');



SELECT [CUSTOMERID_ALTERNATE], 
       [TITLE], 
       [FIRSTNAME], 
       [LASTNAME], 
       --ISNULL([MNAME_INITIAL], 'X') AS MNAME_INITIAL_WITH_ISNULL, 
       ISNULL([MNAME_INITIAL], [FIRSTNAME]) AS MNAME_INITIAL_WITH_ISNULL, 
       --COALESCE([MNAME_INITIAL], 'X') AS MNAME_INITIAL_COALESCE, 
       --COALESCE(SUFFIX, 'X') AS SUFFIX_COALESCE, 
       [MNAME_INITIAL], 
       [SUFFIX]
       --COALESCE(MNAME_INITIAL, SUFFIX, 'X') AS MNAME_INITIAL_SUFFIX_COALESCE, 
       --COALESCE(SUFFIX, MNAME_INITIAL,  'X') AS MNAME_INITIAL_SUFFIX_COALESCE
FROM [AMAZONSHOP].[SALES].[CUSTOMER];



-----DATE FUNCTIONS

--- GETDATE(), GETDATEUTC()

SELECT GETDATE(), GETUTCDATE(), SYSDATETIME(), SYSUTCDATETIME()



----	DATEDIFF()	&		DATEADD()

-----DATEDIFF(INTERVAL, STARTDATE, ENDDATE)
-----DATEADD(INTERVAL, INCREMENT, DATE)

SELECT DATEDIFF(Day,  '01-01-2020', GETDATE());
SELECT DATEDIFF(week, '01-01-2020', '02-08-2025');

SELECT DATEADD(day, 200, GETDATE());
SELECT DATEADD(week, 200, GETDATE());
SELECT DATEADD(hour, 12200, '01-01-2021');


----DATEPART()		&		DATENAME()

SELECT DATEPART(month, GETDATE()) as [month];
SELECT DATEPART(YEAR, GETDATE());

SELECT datename(Weekday, GETDATE());
SELECT datename(month, GETDATE());
SELECT datename(YEAR, GETDATE());
SELECT datename(HOUR, GETDATE());


SELECT DAY(GETDATE()), YEAR(GETDATE()), MONTH(GETDATE())


/*********************************************		SQL JOINS			********************************/

-----CROSS JOIN
------The SQL CROSS JOIN produces a result set which is the number of rows in the first table multiplied by the number of rows in
------the second table if no WHERE clause is used along with CROSS JOIN.
------This kind of result is called as CARTESIAN PRODUCT.

------Not a common join. Some of the data it relates are useless
------used to append data
------Does not involve use of any JOIN predicate
------If WHERE clause is used with CROSS JOIN, it functions like an INNER JOIN.

----SYNTAX:     	SELECT * 
----	             FROM table1 
----		CROSS JOIN table2;

----EXAMPLE:	
SELECT *
FROM [AMAZONSHOP].[SALES].[CUSTOMER]
     CROSS JOIN [AMAZONSHOP].[SALES].[CUSTOMERADDRESS];

SELECT *
FROM [AMAZONSHOP].[SALES].[CUSTOMER], 
     [AMAZONSHOP].[SALES].[CUSTOMERADDRESS];


-------- SELF JOIN

--A self join allows you to join a table to itself. 
--It is useful for querying hierarchical data or comparing rows within the same table.
--A self join can use the inner join or left join clause.
--Is a regular join, but the table is joined with itself.
--In a case where a table has a Foreign Key which references its own key, and a self join is performed, we call that Unary Relationship
--The self join can be viewed as a join of two copies of the same table. The table is not actually copied, but SQL performs the command as though it were.
--The syntax of the command for joining a table to itself is almost same as that for joining two different tables. To distinguish the column names from one another, aliases for the actual table name are used, since both the tables have the same name. Table name aliases are defined in the FROM clause of the SELECT statement. 
--See the syntax (next Page)

--SYNTAX: 
--SELECT a.column_name, b.column_name... 
--FROM table1 a, table1 b 
--WHERE a.common_field = b.common_field;

----SCENARIO
--Using self join to query hierarchical data
-- Consider the following  EMPLOYEE table from the SKyBarrel_UAT DB
--Davis Sara has no manager. To get who reports to whom, you use the self join as shown in the following query:
--The HR dept has asked you to generate a list of employeeid, full names, and their manager's id and manager's full name

---- PURE SELF JOIN (plus Concat)


SELECT EmpTable.empid AS EMPLOYEEID
	  ,CONCAT(EmpTable.firstname, ' ', EmpTable.lastname) AS EMPLOYEE_NAME
	  ,EmpTable.[title] AS EMPLOYEE_TITLE
	  ,EmpTable.mgrid AS EMPLOYEES_MANAGER_ID
	  ,MgrTable.empid AS EMPLOYEE_ID_OF_THE_MANAGER
	  ,MgrTable.mgrid AS MANAGERID
	  ,MgrTable.[title] AS MANAGERTITLE
	  ,MgrTable.firstname AS MANAGER_NAME
	  ,MgrTable.lastname AS MANAGER_LASTNAME
FROM SkyBarrelBank_UAT.HR.Employees AS EmpTable,
SkyBarrelBank_UAT.HR.Employees AS MgrTable
WHERE EmpTable.mgrid = MgrTable.empid;



--We can achieve the same result by using an inner join: (Inner Joins are better optimized than Self-Joins)

SELECT EmpTable.empid AS EMPLOYEEID
	  ,CONCAT(EmpTable.firstname, ' ', EmpTable.lastname) AS EMPLOYEE_NAME
	  ,EmpTable.[title] AS EMPLOYEE_TITLE
	  ,EmpTable.mgrid AS EMPLOYEES_MANAGER_ID
	  ,MgrTable.empid AS EMPLOYEE_ID_OF_THE_MANAGER
	  ,MgrTable.mgrid AS MANAGERID
	  ,MgrTable.[title] AS MANAGERTITLE
	  ,MgrTable.firstname AS MANAGER_NAME
	  ,MgrTable.lastname AS MANAGER_LASTNAME
FROM SkyBarrelBank_UAT.HR.Employees AS EmpTable
INNER JOIN SkyBarrelBank_UAT.HR.Employees AS MgrTable
ON EmpTable.mgrid = MgrTable.empid;


SELECT EmpTable.empid AS EMPLOYEEID
	  ,CONCAT(EmpTable.firstname, ' ', EmpTable.lastname) AS EMPLOYEE_NAME
	  ,EmpTable.[title] AS EMPLOYEE_TITLE
	  ,EmpTable.mgrid AS EMPLOYEES_MANAGER_ID
	  ,MgrTable.empid AS EMPLOYEE_ID_OF_THE_MANAGER
	  ,MgrTable.mgrid AS MANAGERID
	  ,MgrTable.[title] AS MANAGERTITLE
	  ,MgrTable.firstname AS MANAGER_NAME
	  ,MgrTable.lastname AS MANAGER_LASTNAME
FROM SkyBarrelBank_UAT.HR.Employees AS EmpTable
JOIN SkyBarrelBank_UAT.HR.Employees AS MgrTable
ON EmpTable.mgrid = MgrTable.empid


SELECT EmpTable.empid AS EMPLOYEEID
	  ,CONCAT(EmpTable.firstname, ' ', EmpTable.lastname) AS EMPLOYEE_NAME
	  ,EmpTable.[title] AS EMPLOYEE_TITLE
	  ,EmpTable.mgrid AS EMPLOYEES_MANAGER_ID
	  ,MgrTable.empid AS EMPLOYEE_ID_OF_THE_MANAGER
	  ,MgrTable.mgrid AS MANAGERID
	  ,MgrTable.[title] AS MANAGERTITLE
	  ,MgrTable.firstname AS MANAGER_NAME
	  ,MgrTable.lastname AS MANAGER_LASTNAME
FROM SkyBarrelBank_UAT.HR.Employees AS EmpTable
LEFT JOIN SkyBarrelBank_UAT.HR.Employees AS MgrTable
ON EmpTable.mgrid = MgrTable.empid



-------   INNER JOIN 
----The INNER JOIN selects all rows from both participating tables as long as there is a match between the columns. A SQL INNER JOIN is same as JOIN clause
----Returns ONLY RECORDS COMMON to BOTH TABLES based on the Predicate

----SYNTAX:  SELECT * 
----	   FROM table1 INNER JOIN table2 
----	  ON table1.column_name = table2.column_name;
----OR
----SYNTAX:  SELECT * 
----	   FROM table1 
----	  JOIN table2 
----	  ON table1.column_name = table2.column_name;
----EXAMPLE: JOIN THE ZIP TABLE TO THE STATE TABLE

SELECT A.CUSTOMERID, 
       B.CUSTOMERID, 
       CONCAT(A.FIRSTNAME, A.LASTNAME, ' WAS BORN ON - ', DOB) AS CUSTOMERNAME_AND_DOB,
	   B.ADDRESSID, B.ADDRESSTYPE
FROM AMAZONSHOP.SALES.CUSTOMER AS A
     INNER JOIN AMAZONSHOP.SALES.CUSTOMERADDRESS AS B ON A.CUSTOMERID = B.CUSTOMERID;

SELECT A.CUSTOMERID, 
       B.CUSTOMERID, 
       CONCAT(A.FIRSTNAME, A.LASTNAME, ' WAS BORN ON - ', DOB) AS CUSTOMERNAME_AND_DOB,
	   B.ADDRESSID, B.ADDRESSTYPE
FROM AMAZONSHOP.SALES.CUSTOMER AS A
     JOIN AMAZONSHOP.SALES.CUSTOMERADDRESS AS B ON A.CUSTOMERID = B.CUSTOMERID;

SELECT IsSurrogateKey
	  ,[city]
	  ,[ZIP]
      ,[state_id]
	  ,[StateID]
	  ,[stateName]
  FROM [SkyBarrelBank_UAT].[dbo].[US_ZipCodes] 
  INNER JOIN [SkyBarrelBank_UAT].[dbo].[State] 
  ON [state_id] = [StateID]
  ORDER BY IsSurrogateKey ASC

SELECT A.IsSurrogateKey
	  ,A.[city]
	  ,A.[ZIP]
      ,A.[state_id]
	  ,B.[StateID]
	  ,B.[stateName]
  FROM [SkyBarrelBank_UAT].[dbo].[US_ZipCodes] AS A
  INNER JOIN [SkyBarrelBank_UAT].[dbo].[State] AS B
  ON A.[state_id] = B.[StateID]
  ORDER BY IsSurrogateKey ASC


SELECT AMAZONSHOP.SALES.CUSTOMERADDRESS.CUSTOMERID, 
       AMAZONSHOP.SALES.CUSTOMER.CUSTOMERID, 
       CONCAT(FIRSTNAME, LASTNAME, ' WAS BORN ON - ', DOB) AS CUSTOMERNAME_AND_DOB, 
       ADDRESSID, 
       ADDRESSTYPE
FROM AMAZONSHOP.SALES.CUSTOMER 
     INNER JOIN AMAZONSHOP.SALES.CUSTOMERADDRESS 
	 ON AMAZONSHOP.SALES.CUSTOMER.CUSTOMERID = AMAZONSHOP.SALES.CUSTOMERADDRESS.CUSTOMERID;


--- ANSWER TO A TRAINEE'S QUESTION

DECLARE @FULLNAME VARCHAR(100) = 'MICHELLE OBAMA';

SELECT CHARINDEX(' ', @FULLNAME) AS POSITION_OF_SPACE
, LEFT(@FULLNAME, CHARINDEX(' ', @FULLNAME)-1) AS FIRSTNAME
, RIGHT(@FULLNAME, LEN(@FULLNAME)-CHARINDEX(' ', @FULLNAME)) AS LASTNAME
, SUBSTRING(@FULLNAME, 1, CHARINDEX(' ', @FULLNAME)-1) AS FIRSTNAME_SECONDAPPROACH
, SUBSTRING(@FULLNAME, CHARINDEX(' ', @FULLNAME)+1, LEN(@FULLNAME)-CHARINDEX(' ', @FULLNAME)) AS LASTNAME_SECONDAPPROACH
, REVERSE(LEFT(REVERSE(@FULLNAME), CHARINDEX(' ', REVERSE(@FULLNAME))-1)) AS LASTNAME_REVERSED

GO

DECLARE @FULLNAME VARCHAR(100) = 'MICHELLE OBAMA';
SELECT
  SUBSTRING(@FULLNAME, 1, CHARINDEX(' ', @FULLNAME) - 1) AS FirstName,
  SUBSTRING(@FULLNAME, CHARINDEX(' ', @FULLNAME) + 1, LEN(@FULLNAME)) AS LastName

  
GO

DECLARE @FULLNAME VARCHAR(100) = 'MICHELLE OBAMA ROBINSON';

SELECT REVERSE(PARSENAME(REVERSE(REPLACE(@FULLNAME, ' ', '.')), 1)), REVERSE(PARSENAME(REVERSE(REPLACE(@FULLNAME, ' ', '.')), 2))

SELECT PARSENAME('125.12.36.32', 1)


/****			LEFT JOIN			****/
----Returns the record ALL RECORDS FROM the left table, even the ones that do not have a match in the right table
----Joins two tables and fetches all matching rows of two tables for which the SQL-EXPRESSION is true, plus rows from the first(LEFT) table that do not match any row in the second(RIGHT) table
----It fetches a complete set of records from table1(LEFT), with the matching records (depending on availability) in table2(RIGHT). 
----The result is NULL in the right side when no matching will take place.

----SYNTAX
----SELECT *
----FROM <table1>
----LEFT [OUTER] JOIN <table2>
----ON <table1.column_name>  = <table2.column_name>


SELECT borr.[BorrowerID]
      ,[BORROWER NAME]	= REPLACE(CONCAT_WS(' ', borr.[BorrowerFirstName], borr.[BorrowerMiddleInitial] ,borr.[BorrowerLastName]), '  ', ' ')
	  ,LoanNumber
	  ,[SSN]=	RIGHT(borr.[TaxPayerID_SSN], 4)
	  ,[YEAR OF PURCHASE]=YEAR(setup.PURCHASEDATE)
	  ,[PURCHASE AMOUNT (IN THOUSANDS)]=FORMAT(setup.PurchaseAmount/1000, 'C0')+'K'
  FROM [SkyBarrelBank_UAT].[dbo].[Borrower] AS borr
  LEFT JOIN [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS setup
  ON borr.BorrowerID = setup.BorrowerID

  -----RIGHT JOIN
----Is the OPPOSITE of a LEFT JOIN
----Returns the record ALL RECORDS FROM the RIGHT table, even the ones that do not have a match in the left table
----Fetches a complete set of records from table2(RIGHT), i.e. the rightmost table after JOIN clause, with the matching records (depending on the availability) in table1(LEFT). The result is NULL in the left side when no matching will take place.

----SYNTAX
----SELECT *
----FROM <table1>
----RIGHT [OUTER] JOIN <table2>
----ON <table1.column_name>  = <table2.column_name>

---- RIGHT JOIN
SELECT borr.[BorrowerID]
      ,[BORROWER NAME]	= REPLACE(CONCAT_WS(' ', borr.[BorrowerFirstName], borr.[BorrowerMiddleInitial] ,borr.[BorrowerLastName]), '  ', ' ')
	  ,[SSN]=	RIGHT(borr.[TaxPayerID_SSN], 4)
	  ,[YEAR OF PURCHASE]=YEAR(setup.PURCHASEDATE)
	  ,[PURCHASE AMOUNT (IN THOUSANDS)]=FORMAT(setup.PurchaseAmount/1000, 'C0')+'K'
  FROM  [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS setup
  RIGHT JOIN [SkyBarrelBank_UAT].[dbo].[Borrower] AS borr
  ON borr.BorrowerID = setup.BorrowerID



---INNER JOIN
SELECT borr.[BorrowerID]
      ,[BORROWER NAME]	= REPLACE(CONCAT_WS(' ', borr.[BorrowerFirstName], borr.[BorrowerMiddleInitial] ,borr.[BorrowerLastName]), '  ', ' ')
	  ,[SSN]=	RIGHT(borr.[TaxPayerID_SSN], 4)
	  ,[YEAR OF PURCHASE]=YEAR(setup.PURCHASEDATE)
	  ,[PURCHASE AMOUNT (IN THOUSANDS)]=FORMAT(setup.PurchaseAmount/1000, 'C0')+'K'
  FROM  [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS setup
  INNER JOIN [SkyBarrelBank_UAT].[dbo].[Borrower] AS borr
  ON borr.BorrowerID = setup.BorrowerID


----- EXAMPLE OF A MULTI-TABLE JOIN (******** THIS IS NOT A TYPE OF A JOIN)
SELECT borr.[BorrowerID]
      ,[BORROWER NAME]	= REPLACE(CONCAT_WS(' ', borr.[BorrowerFirstName], borr.[BorrowerMiddleInitial] ,borr.[BorrowerLastName]), '  ', ' ')
	  ,LoanNumber
	  ,[SSN]=	RIGHT(borr.[TaxPayerID_SSN], 4)
	  ,[YEAR OF PURCHASE]=YEAR(setup.PURCHASEDATE)
	  ,[PURCHASE AMOUNT (IN THOUSANDS)]=FORMAT(setup.PurchaseAmount/1000, 'C0')+'K'
	  ,PF.PaymentFrequency
	  ,PF.PaymentFrequency_Description
	  ,PF.PaymentIsMadeEvery
  FROM [SkyBarrelBank_UAT].[dbo].[Borrower] AS borr
  LEFT JOIN [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS setup
  ON borr.BorrowerID = setup.BorrowerID
  RIGHT JOIN SkyBarrelBank_UAT.dbo.LU_PaymentFrequency AS PF
  ON SETUP.PaymentFrequency = PF.PaymentFrequency
OPTION (FORCE ORDER);


------EXAMPLE OF A JOIN WITH MORE THAN 1 PREDICATE
--EXAMPLE: GET THE FIRST PAID INSTALLMENT OF A LOAN
 SELECT SETUP.LoanNumber
      ,P.Loannumber
	  ,SETUP.PurchaseDate
	  ,[PURCHASE AMOUNT]	=	setup.PurchaseAmount
	  ,SETUP.FirstInterestPaymentDate
	  ,P.Cycledate
	  ,P.Unpaidprincipalbalance
	  ,P.Paidinstallment
	  ,P.Actualendschedulebalance
  FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS setup
  LEFT JOIN [SkyBarrelBank_UAT].[dbo].Loanperiodic AS P
  ON SETUP.LoanNumber = P.Loannumber
  AND SETUP.FirstInterestPaymentDate = P.Cycledate
  WHERE SETUP.Loannumber = '00285'
  ----AND FirstInterestPaymentDate = Cycledate

  


  /*				SET OPERATORS		*/

  /*		UNION		*/
----  Used to unify the result-sets of two or more input queries without duplicates
---- Select all distinct rows by either query.
---- The UNION operator is used to combine the result-set of two or more SELECT statements
----It UNIFIES the ROWS from BOTH QUERIES
----Each SELECT statement within UNION must have the same number of columns
----The columns must also have similar data types
----The columns in each SELECT statement must also be in the same order
 
----SYNTAX
----		SELECT column_name(s) FROM table1
----		UNION
----		SELECT column_name(s) FROM table2;

--REQUIREMENT
--There are tables that carry the countries, cities and regions 
--The CEO would like a list of all countries, cities and regions in which SkyBarrelBank’s customers and employees come from.
---(You do not want to generate a list with duplicates)

Select [city], [region], [country]
FROM [TSQLV3].[HR].[Employees]
UNION
Select [city], [region], [country]
FROM [TSQLV3].[Sales].[Customers]

-- below is an illustration of what the output would look like if we don't have the columns arranged in order
Select [city], [country], [region]
FROM [TSQLV3].[HR].[Employees]
UNION
Select [city], [region], [country]
FROM [TSQLV3].[Sales].[Customers]


-- below is an illustration of what the output would look like if we do not have same number of columns
Select [city], [country], [region], [postalcode]
FROM [TSQLV3].[HR].[Employees]
UNION
Select [city], [region], [country]
FROM [TSQLV3].[Sales].[Customers]



-- below is an illustration of what the output would look like if we HAVE DIFFERECT DATATYPES ON A COLUMN
Select [city], [country], birthdate
FROM [TSQLV3].[HR].[Employees]
UNION
Select [city], [country], region
FROM [TSQLV3].[Sales].[Customers]



------------------ UNION ALL
--UNION ALL will return ALL RECORDS from both suqueries, even those that are duplicates
-- The UNION operator selects only distinct values by default. To allow duplicate values, use UNION ALL
--So a quick cheat sheet UNION (DISTINCT aka WITHOUT DUPLICATES). UNION ALL (ALL RECORDS INCLUDING DUPLICATES)
-- used to unify the result-set of two or more input queries WITH DUPICATES
 
--SYNTAX
--		SELECT column_name(s) FROM table1
--		UNION ALL
--		SELECT column_name(s) FROM table2;


--REQUIREMENT
-- There are tables that carry the countries, cities and regions 
-- The analytics manager would like a list of all countries, cities and regions in which SkyBarrelBank’s customers and employees come from.
-- (They have requested you to include, even, duplicate records)


Select [city], [region], [country]
FROM [TSQLV3].[HR].[Employees]
UNION ALL
Select [city], [region], [country]
FROM [TSQLV3].[Sales].[Customers]


----------- INTERSECT
----It returns only distinct rows that are common to both set of queries
---- The SQL INTERSECT operator is used to return the results of 2 or more SELECT statements. However, it only returns the rows selected by all queries or data sets. If a record exists in one query and not in the other, it will be omitted from the INTERSECT results.
----So in short, the INTERSECT operator checks and makes sure that the records returned exist in each and every of those subqueries

---- SYNTAX
----			SELECT expression1, expression2, ... expression_n
----			FROM tables
----			INTERSECT
----			SELECT expression1, expression2, ... expression_n
----			FROM tables

--REQUIREMENT
-- There are tables that carry the countries, cities and regions 
-- Due to work from home arrangements, as a result of COVID-19, the company is making a few changes in how they are going to do business.
-- We want to focus only on those cities where we have an employee and customer.
-- The board of directors would like a list of ONLY THOSE countries, cities and regions in which SkyBarrelBank has both a customers and employee.

Select [city], [region], [country]
FROM [TSQLV3].[HR].[Employees]
INTERSECT
Select [city], [region], [country]
FROM [TSQLV3].[Sales].[Customers]


-------	EXCEPT
--  The SQL EXCEPT operator is used to return all rows in the first SELECT statement that are not returned by the second SELECT statement. Each SELECT statement will define a dataset. 
--The EXCEPT operator will retrieve all records from the first dataset and then remove from the results all records from the second dataset.
--TIP: The EXCEPT operator is not supported in all SQL databases. It can be used in databases such as SQL Server, PostgreSQL, and SQLite. IN Oracle, use the MINUS operator
-- SYNTAX
--		SELECT expression1, expression2, ... expression_n
--		FROM tables
--		EXCEPT
--		SELECT expression1, expression2, ... expression_n
--		FROM tables

--REQUIREMENT
--  There are tables that carry the countries, cities and regions 
-- Due to work from home arrangements, as a result of COVID-19, the company is making a few changes in how they are going to do business.
-- We want to make a few changes to the cities where we have employees and no customers 
-- The board of directors would like a list of ONLY THOSE countries, cities and regions in which SkyBarrelBank’s has only employees.

Select [city], [region], [country]
FROM [TSQLV3].[HR].[Employees]
EXCEPT
Select [city], [region], [country]
FROM [TSQLV3].[Sales].[Customers]



/***		SUBQUERIES		***/
--A subquery is a SQL query nested inside a larger query.
-- A subquery may occur in :
-- A SELECT clause
--A FROM clause
--A WHERE clause
-- You can use a subquery in a SELECT, INSERT, DELETE, or UPDATE statement to perform the following tasks:
--a) Compare an expression to the result of the query.
--b) Determine if an expression is included in the results of the query.
--c) Check whether the query selects any rows.


---TWO TYPES
---1) SELF-CONTAINED SUBQUERY
---2) CORRELATED SUBQUERY



---1) SELF-CONTAINED SUBQUERY
--   Is a select statement/query that is at the FILTERING clause of an outer select query
--This type of Subquery is INDEPENDENT of the outer query 

-- SYNTAX
--SELECT Column(s)
--FROM Table
--WHERE Table.Column (=, IN) (Select column(s) From Table1)

--EXAMPLE OF SELF-CONTAINED SUBQUERY IN A WHERE CLAUSE

--REQUIREMENT
--  RETURN THE BORROWER WITH THE SMALLEST LOAN AMOUNT (PURCHASE AMOUNT)

SELECT borr.[BorrowerID]
      ,[BORROWER NAME]	= REPLACE(CONCAT_WS(' ', borr.[BorrowerFirstName], borr.[BorrowerMiddleInitial] ,borr.[BorrowerLastName]), '  ', ' ')
	  ,[PURCHASE AMOUNT]	=	setup.PurchaseAmount
  FROM [SkyBarrelBank_UAT].[dbo].[Borrower] AS borr
  INNER JOIN [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS setup
  ON borr.BorrowerID = setup.BorrowerID
  WHERE PurchaseAmount = ( SELECT MIN(PurchaseAmount) FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] )


  -------- THIS IS ANOTHER APPROCACH FOR THE SAME RESULT BUT DOES NOT INCLUDE A SELF-CONTAINED QUERY
SELECT TOP(1) borr.[BorrowerID]
      ,[BORROWER NAME]	= REPLACE(CONCAT_WS(' ', borr.[BorrowerFirstName], borr.[BorrowerMiddleInitial] ,borr.[BorrowerLastName]), '  ', ' ')
	  ,[PURCHASE AMOUNT]	=	setup.PurchaseAmount
  FROM [SkyBarrelBank_UAT].[dbo].[Borrower] AS borr
  INNER JOIN [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS setup
  ON borr.BorrowerID = setup.BorrowerID
  ORDER BY [PURCHASE AMOUNT] ASC



SELECT borr.[BorrowerID]
      ,[BORROWER NAME]	= REPLACE(CONCAT_WS(' ', borr.[BorrowerFirstName], borr.[BorrowerMiddleInitial] ,borr.[BorrowerLastName]), '  ', ' ')
	  ,[PURCHASE AMOUNT]	=	setup.PurchaseAmount
  FROM [SkyBarrelBank_UAT].[dbo].[Borrower] AS borr
  INNER JOIN [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS setup
  ON borr.BorrowerID = setup.BorrowerID
  WHERE PurchaseAmount = ( SELECT MAX(PurchaseAmount) FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] )



--  EXAMPLE OF SELF-CONTAINED SUBQUERY IN A HAVING CLAUSE

--REQUIREMENT
--  RETURN THE  COUNTRY/COUNTRIES WITH THE HIGHEST NUMBER OF BORROWERS

SELECT [Citizenship], 
       [COUNT OF BORROWERS] = COUNT(BorrowerID)
FROM [SkyBarrelBank_UAT].[dbo].[Borrower]
GROUP BY Citizenship
HAVING COUNT(BorrowerID) = (SELECT MAX(BORROWER_COUNT)
                            FROM
                            (
                                SELECT COUNT(BorrowerID) AS BORROWER_COUNT, 
                                       Citizenship
                                FROM [SkyBarrelBank_UAT].[dbo].[Borrower]
                                GROUP BY Citizenship
                            ) A);




							----- CORRELATED SUBQUERIES
-- Correlated Subqueries have references known as correlations to columns from  tables in the outer query
--This type of Subquery is DEPENDENT on the outer query



--EXAMPLE OF Correlated SUBQUERY IN A where clause

--REQUIREMENT
--  RETURN, FOR EACH PRODUCTID, THE LOAN WITH THE LEAST PURCHASE AMOUNT

SELECT s1.LoanNumber, 
       PurchaseDate, 
       ProductID, 
       [PURCHASE AMOUNT] = s1.PurchaseAmount
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS s1
WHERE s1.PurchaseAmount =
(
    SELECT MIN(s2.purchaseamount)
    FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS s2
    WHERE s1.ProductID = s2.ProductID
)
ORDER BY [PURCHASE AMOUNT] DESC;


SELECT s1.LoanNumber, 
       S1.PurchaseDate, 
       S1.ProductID, 
       [PURCHASE AMOUNT] = s1.PurchaseAmount
FROM SkyBarrelBank_UAT.DBO.LoanSetupInformation AS S1
WHERE PURCHASEAMOUNT = (	SELECT MIN(PURCHASEAMOUNT) 
							FROM SkyBarrelBank_UAT.DBO.LoanSetupInformation AS S2
							WHERE S2.PRODUCTID = S1.ProductID)



--EXAMPLE OF Correlated SUBQUERY IN A SELECT clause

--REQUIREMENT
--  FOR EACH LOAN RECORD, SHOW THE MAXIMUM PURCHASE AMOUNT WITHIN IT’S PRODUCT ID

SELECT s1.LoanNumber, 
       PurchaseDate, 
       [PURCHASE AMOUNT] = s1.PurchaseAmount, 
       max_PurchaseAmountPER_PRODUCTID =
							(
							    SELECT MAX(s2.purchaseamount)
							    FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS s2
							    WHERE s1.ProductID = s2.ProductID
							), 
       ProductID
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS s1
ORDER BY ProductID DESC;


/*			THE EXIST PREDICATE			*/
--The EXIST predicate accepts a subquery as input and returns true or false depending on whether the subquery returns a nonempty set or an empty one, respectively.

--EXAMPLE:
--RETURN LOAN RECORDS FROM THE LOANSETUPINFORMATION_FULL TABLE THAT ALSO EXIST IN THE LOANSETUPINFORMATION TABLE

SELECT LOANNUMBER, 
       PURCHASEAMOUNT, 
       BORROWERID
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation_FULL] AS s1
WHERE EXISTS
(
    SELECT *
    FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS s2
    WHERE S1.LoanNumber = S2.LoanNumber
)


/*			TABLE EXPRESSION		*/
 -- Are usually what we call NAMED QUERIES ( A select statement that is given an ALIAS is a named query). 
 --You write an inner query that will return a relational result set(a set without the ORDER BY clause)

--/* TYPES OF TABLE EXPRESSIONS  */
--	1) DERIVED TABLES
--	2) COMMON TABLE EXPRESSIONS (CTEs)
--	3) VIEWS
--	4) INLINE TABLE-VALUED FUNCTIONS



/*************		DERIVED TABLES			**************/
----closely resembles a subquery BUT IS NOT a subquery. It is NAMED QUERY
---- It is only visible(can only be seen) to statements that defines it
----DEFINITION: Is a select statement/query that is positioned at the FROM clause of an outer select statement
----DEFINITION: It is a virtual table returned from a SELECT statement and is positioned at the FROM clause of the outer select statement. 
----It is similar to a temporary table, but using a derived table in the SELECT statement is much simpler than a temporary table because it does not require steps of creating the temporary table.
----The term derived table and subquery is often used interchangeably. When a stand-alone subquery is used in the FROM clause of a SELECT statement, we call it a derived table
----NOTE: The stand-alone subquery is a subquery which can execute independently of the statement containing it
----Unlike a subquery, a derived table must have an alias so that you can reference its name later in the query. Otherwise, an error message is returned

------ SYNTAX
----SELECT column_name
----FROM  (SELECT column_name FROM table_1) derived_table_name;	

SELECT *
FROM
(
    SELECT LOANNUMBER, 
           PURCHASEAMOUNT, 
           BORROWERID
    FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation]
) AS A;



SELECT *
FROM
(
    SELECT borr.[BorrowerID], 
           [BORROWER NAME] = REPLACE(CONCAT_WS(' ', borr.[BorrowerFirstName], borr.[BorrowerMiddleInitial], borr.[BorrowerLastName]), '  ', ' '), 
           [PURCHASE AMOUNT] = setup.PurchaseAmount
    FROM [SkyBarrelBank_UAT].[dbo].[Borrower] AS borr
         INNER JOIN [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS setup ON borr.BorrowerID = setup.BorrowerID
    WHERE PurchaseAmount =
    (
        SELECT MAX(PurchaseAmount)
        FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation]
    )
) AS A;



-- Query with nested derived tables
SELECT YEAR(orderdate) AS orderyear, custid
FROM Sales.Orders


SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM (SELECT YEAR(orderdate) AS orderyear, custid
            FROM Sales.Orders) AS D1
GROUP BY orderyear



SELECT orderyear, numcusts
FROM (SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
      FROM (SELECT YEAR(orderdate) AS orderyear, custid
            FROM Sales.Orders) AS D1
      GROUP BY orderyear) AS D2
WHERE numcusts > 70;


-- Num of orders per year and the diff from prev year


-- THE LEFT TABLE
USE TSQLV3
GO

SELECT YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
      FROM Sales.Orders
      GROUP BY YEAR(orderdate)
--- THE RIGHT TABLE
SELECT YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
      FROM Sales.Orders
      GROUP BY YEAR(orderdate)


SELECT CUR.orderyear, 
       CUR.numorders,
	   prv.orderyear, 
       PRV.numorders, 
       CUR.numorders - PRV.numorders AS diff
FROM
(
    SELECT YEAR(orderdate) AS orderyear, 
           COUNT(*) AS numorders
    FROM Sales.Orders
    GROUP BY YEAR(orderdate)
) AS CUR
LEFT OUTER JOIN
(
    SELECT YEAR(orderdate) AS orderyear, 
           COUNT(*) AS numorders
    FROM Sales.Orders
    GROUP BY YEAR(orderdate)
) AS PRV 
ON CUR.orderyear = PRV.orderyear + 1;
GO


USE SkyBarrelBank_UAT
GO

------------		ANOTHER EXAMPLE OF DERIVED TABLE

DECLARE @PENALTY NUMERIC= 10000;
SELECT [Loannumber], 
       [TOTAL EXTRA PAYMENTS] = FORMAT([TOTAL EXTRA PAYMENTS], 'C2'), 
       [TOTAL PAID INSTALLMENTS] = FORMAT([TOTAL PAID INSTALLMENTS], 'C2'), 
       [TOTAL INTEREST] = FORMAT([TOTAL INTEREST], 'C2'), 
       [TOTAL PENALTY] = FORMAT([TOTAL PENALTY], 'C2')
FROM
(
    SELECT [Loannumber], 
           [TOTAL EXTRA PAYMENTS] = SUM([Extramonthlypayment]), 
           [TOTAL PAID INSTALLMENTS] = SUM([Paidinstallment]), 
           [TOTAL INTEREST] = SUM([Interestportion]), 
           [TOTAL PENALTY] = SUM([DEFAULTPENALTY])
    FROM SkyBarrelBank_UAT.[dbo].[Loanperiodic]
    GROUP BY LOANNUMBER
) AS A
WHERE [TOTAL PENALTY] >= @PENALTY;
GO


/*****************		COMMON TABLE EXPRESSION		*******************/
/*COMMON TABLE EXPRESSIONS (CTEs)*/
-- DEFINITION: it's a temporary named result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement. 
-- You can also use a CTE in a CREATE a view, as part of the view’s SELECT query
-- Is like a derived table, difference is that the SELECT query that we'll be pivoting from will come first then we select data from it. IT is also a NAMED QUERY

-- SYNTAX
--		WITH <cte_name>
--		AS (   <inner_query>  )
--			<outer_query>

-- REQUIREMENT
--- ACHEIEVE THE SAME REQUREMENT FROM THE STEP ABOVE USING A CTE

DECLARE @PENALTY NUMERIC= 100;

;WITH CTE_FROM_PERIODIC_TABLE AS
(
    SELECT [Loannumber], 
           [TOTAL EXTRA PAYMENTS] = SUM([Extramonthlypayment]), 
           [TOTAL PAID INSTALLMENTS] = SUM([Paidinstallment]), 
           [TOTAL INTEREST] = SUM([Interestportion]), 
           [TOTAL PENALTY] = SUM([DEFAULTPENALTY])
    FROM SkyBarrelBank_UAT.[dbo].[Loanperiodic]
    GROUP BY LOANNUMBER
) 
SELECT [Loannumber], 
       [TOTAL EXTRA PAYMENTS] = FORMAT([TOTAL EXTRA PAYMENTS], 'C2'), 
       [TOTAL PAID INSTALLMENTS] = FORMAT([TOTAL PAID INSTALLMENTS], 'C2'), 
       [TOTAL INTEREST] = FORMAT([TOTAL INTEREST], 'C2'), 
       [TOTAL PENALTY] = FORMAT([TOTAL PENALTY], 'C2')
FROM CTE_FROM_PERIODIC_TABLE
WHERE [TOTAL PENALTY] >= @PENALTY;
GO


-----
-- Defining multiple CTEs

----PERFORM THE SAME REQUIREMENT AS ABOVE AND ADD BORROWER DATA
DECLARE @PENALTY NUMERIC= 10000;

;WITH CTE_FROM_PERIODIC_TABLE AS
(
    SELECT [Loannumber], 
           [TOTAL EXTRA PAYMENTS] = SUM([Extramonthlypayment]), 
           [TOTAL PAID INSTALLMENTS] = SUM([Paidinstallment]), 
           [TOTAL INTEREST] = SUM([Interestportion]), 
           [TOTAL PENALTY] = SUM([DEFAULTPENALTY])
    FROM SkyBarrelBank_UAT.dbo.Loanperiodic
    GROUP BY LOANNUMBER
)
, CTE_CALCULATED AS
(
SELECT [Loannumber], 
       [TOTAL EXTRA PAYMENTS] = FORMAT([TOTAL EXTRA PAYMENTS], 'C2'), 
       [TOTAL PAID INSTALLMENTS] = FORMAT([TOTAL PAID INSTALLMENTS], 'C2'), 
       [TOTAL INTEREST] = FORMAT([TOTAL INTEREST], 'C2'), 
       [TOTAL PENALTY] = FORMAT([TOTAL PENALTY], 'C2')
FROM CTE_FROM_PERIODIC_TABLE
WHERE [TOTAL PENALTY] >= @PENALTY
) 
, CTE_BORROWER AS
(
    SELECT [BorrowerID], 
           [BORROWER NAME] = REPLACE(CONCAT_WS(' ', [BorrowerFirstName], [BorrowerMiddleInitial], [BorrowerLastName]), '  ', ' '), 
           [Citizenship], 
           [AGE OF BORROWER]	=	FLOOR((DATEDIFF(day, [DOB], GETDATE())) / 365.25)           
    FROM SkyBarrelBank_UAT.[dbo].[Borrower]
)
, CTE_SETUP AS
(
    SELECT [BorrowerID], 
           LoanNumber, 
           ProductID, 
           [AGE OF LOAN (MONTHS)]	=	DATEDIFF(MONTH, PurchaseDate, GETDATE())      
    FROM SkyBarrelBank_UAT.[dbo].LoanSetupInformation
)
    SELECT A.[BorrowerID], 
           A.[BORROWER NAME],
           A.[Citizenship], 
           A.[AGE OF BORROWER],
           C.LoanNumber, 
           C.ProductID, 
           C.[AGE OF LOAN (MONTHS)],
		   B.[TOTAL EXTRA PAYMENTS], 
		   B.[TOTAL PAID INSTALLMENTS], 
		   B.[TOTAL INTEREST], 
		   B.[TOTAL PENALTY] 
FROM CTE_BORROWER AS A
INNER JOIN CTE_SETUP AS C
ON A.BorrowerID = C.BorrowerID
INNER JOIN CTE_CALCULATED AS B
ON B.Loannumber = C.LoanNumber;
GO



/*****************		RECURSIVE CTEs		*******************/
------A recursive common table expression (CTE) is a CTE that references itself. By doing so, the CTE repeatedly executes, returns subsets of data,
------until it returns the complete result set.
------A recursive CTE is useful in querying hierarchical data such as organization charts where one employee reports to a manager 
------or multi-level bill of materials when a product consists of many components, and each component itself also consists of many other components.
------The following shows the syntax of a recursive CTE:

------WITH expression_name (column_list)
------AS
------(
------    -- Anchor member
------    initial_query  
------    UNION ALL
------    -- Recursive member that references expression_name.
------    recursive_query  
------)
-------- references expression name
------SELECT *
------FROM   expression_name
------Code language: SQL (Structured Query Language) (sql)



------In general, a recursive CTE has three parts:
------1)An initial query that returns the base result set of the CTE. The initial query is called an anchor member.
------2)A recursive query that references the common table expression, therefore, it is called the recursive member. 
------The recursive member is union-ed with the anchor member using the UNION ALL operator.
------3)A termination condition specified in the recursive member that terminates the execution of the recursive member.

------The execution order of a recursive CTE is as follows:

------1) execute the anchor member to form the base result set (R0), use this result for the next iteration.
------2) execute the recursive member with the input result set from the previous iteration (Ri-1) and return a sub-result set (Ri) until the termination condition is met.
------3) combine all result sets R0, R1, … Rn using UNION ALL operator to produce the final result set.

;WITH cte_numbers
AS (
    SELECT 
        0 AS COLUMN_1, 
        DATENAME(DW, 0) AS [weekday]
    UNION ALL
    SELECT    
        COLUMN_1 + 1 AS COLUMN_1, 
        DATENAME(DW, COLUMN_1 + 1) AS [weekday]
    FROM    
        cte_numbers
    WHERE COLUMN_1 < 6
)
SELECT 
    [weekday]
FROM 
    cte_numbers;

	   	  
-----REQUIREMENTS:
----- T-SQL SUPPORTS A SPECIALIZED FORM OF A CTE WITH RECURSICE SYNTAX. TO DESCRIBE AND DEMONSTRATE RECURSIVE CTEs,  I'LL USE A TABLE CALLED EMPLOYEES
----- THAT YOU CREATE AND POPULATE BY RUNNING THE FOLLOWING CODE:



---------------------------------------------------------------------
------ Recursive CTEs
---------------------------------------------------------------------
go
-- DDL & Sample Data for Employees
SET NOCOUNT ON;
USE tempdb;

IF OBJECT_ID(N'dbo.Employees', N'U') IS NOT NULL DROP TABLE dbo.Employees;

CREATE TABLE dbo.Employees
(
  empid   INT         NOT NULL
    CONSTRAINT PK_Employees PRIMARY KEY,
  mgrid   INT         NULL
    CONSTRAINT FK_Employees_Employees FOREIGN KEY REFERENCES dbo.Employees(empid),
  empname VARCHAR(25) NOT NULL,
  salary  MONEY       NOT NULL
);

INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(1,  NULL, 'David'  , $10000.00),
        (2,     1, 'Eitan'  ,  $7000.00),
        (3,     1, 'Ina'    ,  $7500.00),
        (4,     2, 'Seraph' ,  $5000.00),
        (5,     2, 'Jiru'   ,  $5500.00),
        (6,     2, 'Steve'  ,  $4500.00),
        (7,     3, 'Aaron'  ,  $5000.00),
        (8,     5, 'Lilach' ,  $3500.00),
        (9,     7, 'Rita'   ,  $3000.00),
        (10,    5, 'Sean'   ,  $3000.00),
        (11,    7, 'Gabriel',  $3000.00),
        (12,    9, 'Emilia' ,  $2000.00),
        (13,    9, 'Michael',  $2000.00),
        (14,    9, 'Didi'   ,  $1500.00);

CREATE UNIQUE INDEX idx_nc_mgr_emp_i_name_sal
  ON dbo.Employees(mgrid, empid) INCLUDE(empname, salary);
GO


--- THE ABOVE WAS TO SET UP AN ENVIRONMENT. BELOW IS THE RECURSIVE CTE
-- Subtree
WITH EmpsCTE AS
(
  SELECT empid, mgrid, empname, salary
  FROM dbo.Employees
  WHERE empid = 3

  UNION ALL

  SELECT C.empid, C.mgrid, C.empname, C.salary
  FROM EmpsCTE AS P
    JOIN dbo.Employees AS C
      ON C.mgrid = P.empid
)
SELECT empid, mgrid, empname, salary
FROM EmpsCTE;



/**********************	views		*******************************/
 ------is a virtual table whose contents are defined by a query and is based in the result set of a SQL query
 ------A VIEW is a virtual table, defined by a query, that does not exist until it is invoked by name in an SQL statement.
 ------In fact, a VIEW definition can be copied as in-line text, just like a CTE. But with a good optimizer, 
 ------the SQL engine can decide that enough sessions are using the same VIEW
 ------and materialize it as a shared table. The CTE, in contrast, is strictly local to the statement in which it is declared.
 ------Is virtual because it doesn't occupy a physical space in the database
 ------MATERIALIZED VIEW updates automatically when data in the underlying table changes. For SSMS, it updates automatically
 ------SYNTAX
	------		CREATE VIEW <view_name>
	------		AS   <select_query>


-----CREATE A VIEW TO SHOW THE MOST RECENT BALANCE FOR EACH LOAN
-----
USE [SkyBarrelBank_UAT]
GO

DROP VIEW IF EXISTS DBO.vw_CURRENT_BALANCE;
GO
-------------------------------
--- THE CODE BELOW IS THE ACTUAL VIEW CREATION 
-------------------------------------------
CREATE VIEW DBO.vw_CURRENT_BALANCE
AS
(
SELECT [Loannumber], 
       [Cycledate], 
       [CURRENT BALANCE] = [Actualendschedulebalance], 
       [MOST RECENT PAYMENT] = [Paidinstallment], 
       [CUMMULATIVE INTEREST PAID] = [Totalinterestaccrued], 
       [CUMMULATIVE PRINCIPAL PAID] = [Totalprincipalaccrued]
FROM [SkyBarrelBank_UAT].[dbo].[Loanperiodic]
WHERE CONCAT(LOANNUMBER, '-',  CYCLEDATE) IN
(
    SELECT CONCAT(LOANNUMBER, '-', MAX(CYCLEDATE))
    FROM [SkyBarrelBank_UAT].[dbo].[Loanperiodic]
    GROUP BY LOANNUMBER
)
)
;
GO

------SELECT FROM THE VIEW
SELECT *
FROM SkyBarrelBank_UAT.DBO.vw_CURRENT_BALANCE;
GO


----------------------------------------------------------------
-----------------	IN-LINE TABLE VALUED FUNCTIONS
----------------------------------------------------------------
--------A table-valued function is a user-defined function that returns data of a table type.
--------The return type of a table-valued function is a table, therefore, you can use the table-valued function just like you would use a table.

----------------
----REQUIREMENT
---- CREATE A FUNCTION THAT WILL RETURN BALANCES OF A LOAN FOR ANY USER ENTERED MONTH


DROP FUNCTION IF EXISTS DBO.fn_CURRENT_BALANCE;
GO


CREATE FUNCTION DBO.fn_CURRENT_BALANCE
(@CYCLEDATE DATETIME
)
RETURNS TABLE
AS
     RETURN
	 -------------
SELECT [Loannumber], 
       [Cycledate], 
       [CURRENT BALANCE] = [Actualendschedulebalance], 
       [MOST RECENT PAYMENT] = [Paidinstallment], 
       [CUMMULATIVE INTEREST PAID] = [Totalinterestaccrued], 
       [CUMMULATIVE PRINCIPAL PAID] = [Totalprincipalaccrued]
FROM [SkyBarrelBank_UAT].[dbo].[Loanperiodic]
WHERE Cycledate = @CYCLEDATE
;

GO


SELECT *
FROM DBO.fn_CURRENT_BALANCE ('2015-07-31')



/*********		IIF		****/
-----Returns one of two values, depending on whether the Boolean expression evaluates to true or false in SQL Server

 ------SYNTAX
	------IIF(condition, value_if_true, value_if_false)

--------EXAMPLE:
SELECT IIF(500<1000, 'YES', 'NO');


--- IMPLEMENTATION ON A BUSINESS CASE SCENARIO
SELECT [LoanNumber], 
       [PurchaseAmount], 
       AppraisalValue, 
	   CAST(ROUND([PurchaseAmount] / AppraisalValue, 2) AS FLOAT),
       [CHECK] = IIF([PurchaseAmount] / AppraisalValue < 0.5, 'LOW LTV', 'HIGH LTV')
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation];



/****** CASE EXPRESSION*************/
-- Used to provide conditional logic for a return value within a SQL query
-- The CASE statement has the functionality of an IF-THEN-ELSE statement. You can use the CASE statement within a SQL statement.
-- There are 2 forms of case expression
-- TWO FORMS
--			a) SIMPLE FORM
--			b) SEARCH FORM
-- The general STRUCTURE of a CASE EXPRESSION:
--			CASE <specify the column_name>                 --(specify the column_name in case of a simple form)
--			WHEN <specify the conditional staement>
--			THEN <specify the outcome the condition is met>
--			ELSE <specify the outcome if the condition not met>
--			END                                                   -- every case expression must be closed with an END
--				AS <derived column>
-- SYNTAX
--			CASE
--			WHEN <condition_1>		THEN <result_1>			(Search form)
--			WHEN <condition_2>		THEN <result_2>
--			WHEN <condition_n>		THEN resul<t_n>
--			ELSE <result>
--			END

--   *** The IF_THEN_ELSE is similar to CASE expressions but it is used in programmatic SQL, not QUERY SQL
-- DIFFERENCE between SIMPLE and SEARCH
--		in SIMPLE FORM, we have to list the column name(right after typing CASE) that we are going to apply the logic on. In the SEARCH FORM, we dont
--  Simple case expression only applies the conditional logic on the value of a single column  
--  while the search expression application of the the condition conditional logic is not tied to one column

/*SIMPLE CASE EXPRESSION*/

SELECT [BorrowerID], 
       [BORROWER NAME] = REPLACE(CONCAT_WS(' ', [BorrowerFirstName], [BorrowerMiddleInitial], [BorrowerLastName]), '  ', ' '), 
       [Citizenship], 
       [GENDER], 
       [FULL Gender] = CASE [GENDER]
                           WHEN 'F'
                           THEN 'FEMALE'
                           WHEN 'M'
                           THEN 'MALE'
                           WHEN ''
                           THEN 'NOT-VALID'
                           ELSE 'NOT-DEFINED'
                       END
FROM SkyBarrelBank_UAT.[dbo].[Borrower];


SELECT [BorrowerID], 
       [BORROWER NAME] = REPLACE(CONCAT_WS(' ', [BorrowerFirstName], [BorrowerMiddleInitial], [BorrowerLastName]), '  ', ' '), 
       [Citizenship], 
       [GENDER],
	   --- SIMPLE CASE EXPRESSION
	   [FULL GENDER]	=	CASE GENDER 
							WHEN 'F' THEN 'FEMALE'
							WHEN 'M' THEN 'MALE'
							ELSE 'NOT DEFINED'
							END
	-----SEARCH CASE EXPRESSION
	, [FULL GENDER_2]	=	CASE WHEN GENDER = 'F' THEN 'FEMALE'
							 WHEN GENDER = 'M' THEN 'MALE'
							 WHEN Citizenship = 'ETHIOPIA' THEN 'AFRICA'
						END
FROM SkyBarrelBank_UAT.[dbo].[Borrower];



/*SEARCH CASE EXPRESSION*/
SELECT [LoanNumber], 
       [PurchaseAmount], 
       [PurchaseAmount CATEGORY] = CASE
                                       WHEN [PurchaseAmount] <= 1000000
                                       THEN '<= 1 Mil'
                                       WHEN [PurchaseAmount] <= 10000000
                                       THEN '1 Mil TO 10 Mil'
                                       WHEN [PurchaseAmount] <= 50000000
                                       THEN '10 Mil TO 50 Mil'
                                       WHEN [PurchaseAmount] > 50000000
                                       THEN '>= 50 Mil'
                                       ELSE 'ERROR'
                                   END
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation];

SELECT [LoanNumber], 
       [PurchaseAmount], 
	   --CAST(ROUND([PurchaseAmount] / AppraisalValue, 2) AS FLOAT),
       [PurchaseAmount CATEGORY] = CASE WHEN PurchaseAmount <= 1000000 THEN ' <= 1 Mil'
										WHEN PurchaseAmount <= 10000000 THEN ' 1 Mil - 10 Mil' 
										WHEN PurchaseAmount > 10000000 THEN ' >10 Mil' 
									ELSE 'NOT DEFINED'
									END,
       [PurchaseAmount ADJUSTED] = CASE WHEN ([PurchaseAmount] / AppraisalValue) < 0.3 THEN [PurchaseAmount] * 1.3
										WHEN ([PurchaseAmount] / AppraisalValue) < 0.5 THEN [PurchaseAmount] * 1.5 
										WHEN ([PurchaseAmount] / AppraisalValue) < 0.7 THEN [PurchaseAmount] * 1.7
									ELSE [PurchaseAmount] * 2
									END
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation];



/**************		WINDOWING FUNCTIONS		&	ANALYTICAL FUNCTIONS	&		AGGREGATE FUNCTIONS		***************/

-----SQL Server Window Functions calculate an aggregate value based on a group of rows and return multiple rows for each group

----SQL Server Window Functions calculate an aggregate value based on a group of rows and return multiple rows for each group.

----In contrast to group functions which are applied to groups of rows defined by a grouped query, window functions are applied to windows of rows defined by a windowed query
----Where a GROUP BY clause determines groups, an OVER  clause determines windows.

----FEATURES OF WINDOW FUNCTIONS:
----FRAME SPECIFICATIONS FOR AGGREGATE WINDOW FUNCTIONS (ORDER BY AND ROWS OR RANGE window frame units)
----OFFSET WINDOW FUNCTIONS (FIRST_VALUE, LAST_VALUE, LAG, & LEAD)
----STATISTICAL WINDOW FUNCTIONS (PERCENT_RANK, CUME_DIST, PERCENTILE_CONT, and PERCENTILE_DISC)


----------	OVER() CLAUSE 
--There is no window without an OVER() clause

--DEFINITION: Determines the partitioning and ordering of a rowset before the associated window function is applied.
-- That is, the OVER clause defines a window or user-specified set of rows within a query result set.
-- A window function then computes a value for each row in the window. 
--You can use the OVER clause with functions to compute aggregated values such as moving averages, cumulative aggregates, running totals, or a top N per group results.


SELECT BORROWERID, SUM(PurchaseAmount) AS PURCHASEDAMOUNT, COUNT(LOANNUMBER) AS No_Of_Loans
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation]
GROUP BY BORROWERID
ORDER BY No_Of_Loans DESC


SELECT SUM(PurchaseAmount) AS PURCHASEDAMOUNT
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation];


SELECT PRODUCTID, SUM(PurchaseAmount) AS PURCHASEDAMOUNT, COUNT(LOANNUMBER) AS No_Of_Loans
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation]
GROUP BY PRODUCTID


----RETURN THE  LOANNUMBER, PRODUCTID, NUMBER OF LOANS WITHIN THE PRODUCT OF THIS LOAN, TOTAL LOANS FOR THE PRODUCT OF THIS LOAN

;WITH CTE_BY_PRODUCT AS
(
SELECT PRODUCTID, SUM(PurchaseAmount) AS PURCHASEDAMOUNT, COUNT(LOANNUMBER) AS No_Of_Loans, avg(PurchaseAmount) AS AVG_PURCHASEDAMOUNT
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation]
WHERE PurchaseDate >= '2018-01-01'
GROUP BY PRODUCTID
)
SELECT A.LOANNUMBER, A.PURCHASEAMOUNT, A.PRODUCTID, AVG_PURCHASEDAMOUNT, B.PURCHASEDAMOUNT AS [TOTAL Vol. PURCHASED WITHIN GROUP]
, B.No_Of_Loans AS [NO OF LOANS IN THE PRODUCT]
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS A
INNER JOIN CTE_BY_PRODUCT AS B
ON A.ProductID = B.ProductID
WHERE A.PurchaseDate >= '2018-01-01'
ORDER BY ProductID, LOANNUMBER


---------------- TO PERFORM THE SAME WITH WINDOWING FUNCTIONS
SELECT LOANNUMBER, 
       PURCHASEAMOUNT, 
       PRODUCTID, 
	   Yr = YEAR(PURCHASEDATE),
       AVG_PURCHASEDAMOUNT_BY_YEAR = AVG(PURCHASEAMOUNT) OVER(PARTITION BY PRODUCTID, YEAR(PURCHASEDATE)), 
       AVG_PURCHASEDAMOUNT = AVG(PURCHASEAMOUNT) OVER(PARTITION BY PRODUCTID), 
       AVG_PURCHASEDAMOUNT_ALL = AVG(PURCHASEAMOUNT) OVER(), 
       [TOTAL Vol. PURCHASED WITHIN GROUP] = SUM(PURCHASEAMOUNT) OVER(PARTITION BY PRODUCTID), 
       [NO OF LOANS IN THE PRODUCT] = COUNT(PURCHASEAMOUNT) OVER(PARTITION BY PRODUCTID) ,
       [NO OF LOANS IN THE PRODUCT ALL] = COUNT(PURCHASEAMOUNT) OVER()
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation]
------WHERE PurchaseDate >= '2018-01-01'
ORDER BY ProductID, YR,
         LOANNUMBER;

SELECT COUNT(LOANNUMBER) AS No_Of_Loans
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation]



--------------		AGGREGATE WINDOWING FUNCTION

----Are the same functions you know as the grouped functions (SUM, AVG, MAX, MIN, COUNT etc)
----ONLY DIFFERENCE IS: When using them  as windowing functions, you apply them to a window instead of a group

----EXAMPLE: 

SELECT [productname], 
       [categoryid], 
       [unitprice], 
       [max UNIT PRICE IN THE CATEGORY] = MAX([unitprice]) OVER(PARTITION BY [categoryid]), 
       [MIN UNIT PRICE IN THE CATEGORY] = MIN([unitprice]) OVER(PARTITION BY [categoryid]), 
       [SUM OF UNIT PRICES IN THE CATEGORY] = SUM([unitprice]) OVER(PARTITION BY [categoryid]), 
       [COUNT OF PRODUCTS IN THE CATEGORY] = COUNT([unitprice]) OVER(PARTITION BY [categoryid])
FROM [TSQLV3].[Production].[Products]
ORDER BY [categoryid], 
         [unitprice] DESC;



SELECT [LoanNumber], 
       [ProductID], 
       [PurchaseAmount], 
       [max Loan Amount IN Product] = MAX([PurchaseAmount]) OVER(PARTITION BY [ProductID]), 
       [max Loan Amount] = MAX([PurchaseAmount]) OVER(), ----WITHOUT THE PARTITION RETURNS THE MAXIMUM Loan Amount OF THE WHOLE RESUT SET
       [MIN Loan Amount IN Product] = MIN([PurchaseAmount]) OVER(PARTITION BY [ProductID]), 
       [MIN Loan Amount] = MIN([PurchaseAmount]) OVER(), 
       [SUM OF Loan Amount IN Product] = SUM([PurchaseAmount]) OVER(PARTITION BY [ProductID]), 
       [SUM OF Loan Amount] = SUM([PurchaseAmount]) OVER(), 
       [COUNT OF PRODUCTS IN Product] = COUNT(CASE
                                                     WHEN [ProductID] IN('MA', 'ME')
                                                     THEN [PurchaseAmount]
                                                     ELSE NULL
                                                 END) OVER(PARTITION BY [ProductID]), 
       [COUNT OF PRODUCTS IN THE CATEGORY] = COUNT([LoanNumber]) OVER(PARTITION BY [ProductID]), 
       [COUNT OF PRODUCTS] = COUNT([LoanNumber]) OVER()
FROM [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation]
ORDER BY [ProductID], 
         [PurchaseAmount] DESC;


-- /*WINDOWING /ANALYTICAL FUNCTIONs*/
--	1) ROW_NUMBER()		-- Numbers the output of a result set.  returns the sequential number of a row within a partition of a result set, starting at 1 for the first row in each partition.
--	2) RANK()			-- Retains the rank order of each row within a result set.	
						-- assigns a rank to each row in the partition of a result set. 
						-- Ties are assigned the same rank, with the next ranking(s) skipped. Example 1, 2, 2, 2, 5, 6, 
--	3) DENSE_RANK()		-- gives you the ranking within your ordered partition, but the ranks are consecutive 
						-- No ranks are skipped if there are ranks with multiple items. Example 1, 2, 3, 4, 5, 6
--	4) NTILE()			-- Distributes the rows in an ordered partition into a specified number of groups. The groups are numbered, starting at one.
--						   For each row, NTILE returns the number of the group to which the row belongs


---------------------------------------------------------------------
-- Ranking Window Functions
---------------------------------------------------------------------

-- Creating and populating the Orders table
SET NOCOUNT ON;
USE tempdb;

IF OBJECT_ID(N'dbo.Orders', N'U') IS NOT NULL DROP TABLE dbo.Orders;

CREATE TABLE dbo.Orders
(
  orderid   INT        NOT NULL,
  orderdate DATE       NOT NULL,
  empid     INT        NOT NULL,
  custid    VARCHAR(5) NOT NULL,
  qty       INT        NOT NULL,
  CONSTRAINT PK_Orders PRIMARY KEY (orderid)
);
GO

INSERT INTO dbo.Orders(orderid, orderdate, empid, custid, qty)
  VALUES(30001, '20130802', 3, 'B', 10),
        (10001, '20131224', 1, 'C', 10),
        (10005, '20131224', 1, 'A', 30),
        (40001, '20140109', 4, 'A', 40),
        (10006, '20140118', 1, 'C', 10),
        (20001, '20140212', 2, 'B', 20),
        (40005, '20140212', 4, 'A', 10),
        (20002, '20140216', 2, 'C', 20),
        (30003, '20140418', 3, 'B', 15),
        (30004, '20140418', 3, 'B', 20),
        (30007, '20140907', 3, 'C', 30);
GO


SELECT *
FROM  dbo.Orders


----------------- PERFORM SOME RANKING ON THE TABLE
SELECT ORDERID
		, QTY
		,ROW_NUMBER() OVER( ORDER BY QTY) AS ROWNNUM
		,RANK() OVER(ORDER BY QTY) AS RANKED
		,DENSE_RANK() OVER(ORDER BY QTY) AS DENSE_RANKED
		,NTILE(4) OVER(ORDER BY QTY) AS N_TILED
FROM  dbo.Orders


SELECT ORDERID
		, empid
		, QTY
		,ROW_NUMBER() OVER( PARTITION BY empid ORDER BY QTY) AS ROWNNUM
		,RANK() OVER( PARTITION BY empid ORDER BY QTY) AS RANKED
		,DENSE_RANK() OVER( PARTITION BY empid ORDER BY QTY) AS DENSE_RANKED
		,NTILE(4) OVER( PARTITION BY empid ORDER BY QTY) AS N_TILED
FROM  dbo.Orders



---------------------------------------------
----- OFFSET WINDOW FUNCTIONS
---------------------------------------------
;WITH CTE_A
AS
(
SELECT DISTINCT 
		  MONTH_NUMBER	=	DATEPART(MONTH, [CalendarDate])
		  ,MONTH_NAME	=	DATENAME(MONTH, [CalendarDate])
FROM [SkyBarrelBank_UAT].[dbo].[Calendar]

)
SELECT DISTINCT MONTH_NUMBER,
		  THIS_LAG	=	LAG(MONTH_NAME, 2, 'NO VALUE') OVER(ORDER BY MONTH_NUMBER ASC)
		 ,MONTH_NAME	
		 ,THIS_LEAD	=	LEAD(MONTH_NAME, 2, 'NO VALUE') OVER(ORDER BY MONTH_NUMBER ASC)
FROM CTE_A

ORDER BY MONTH_NUMBER ASC

---------------------------------------------------------------------
-- Offset Window Functions
---------------------------------------------------------------------

-- FIRST_VALUE and LAST_VALUE
SELECT custid, orderid, orderdate, qty,
  FIRST_VALUE(qty) OVER(PARTITION BY custid ORDER BY orderdate, orderid
                        ROWS BETWEEN UNBOUNDED PRECEDING
                                 AND CURRENT ROW) AS firstqty,
  LAST_VALUE(qty)  OVER(PARTITION BY custid
                        ORDER BY orderdate, orderid
                        ROWS BETWEEN CURRENT ROW
                                 AND UNBOUNDED FOLLOWING) AS lastqty
FROM dbo.Orders
ORDER BY custid, orderdate, orderid;

-- LAG and LEAD
SELECT custid, orderid, orderdate, qty,
  LAG(qty)  OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS prevqty,
  LEAD(qty) OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS nextqty
FROM dbo.Orders
ORDER BY custid, orderdate, orderid;

----------------------
---EXAMPLE:

WITH CTE_A AS
(
SELECT [Loannumber]
      ,CYCLEDATE
	  ,[Paidinstallment]
	  ,[Unpaidprincipalbalance]
	  ,PRIOR_MONTH_PAID_INSTALLMENT =	LAG([Unpaidprincipalbalance], 1, 0) OVER(PARTITION BY [Loannumber] ORDER BY CYCLEDATE ASC)
  FROM [SkyBarrelBank_UAT].[dbo].[Loanperiodic]
  )
SELECT [Loannumber]
      ,CYCLEDATE
	  ,[Paidinstallment]
	  ,[Unpaidprincipalbalance]
	  ,PRIOR_MONTH_PAID_INSTALLMENT 
	  ,DIFF_BTW_LASTMO_THISMO = [Unpaidprincipalbalance] - PRIOR_MONTH_PAID_INSTALLMENT
  FROM CTE_A






/**** multi-statement table-valued function or MSTVF *****/
-- MSTVF is a table-valued function that returns the result of multiple statements.
-- MSTVF is very useful because you can execute multiple queries within the function and aggregate results into the returned table.
-- To define MSTVF, you use a table variable as the return value. Inside the function, you execute one or more queries and insert data into this table variable


---------------------------------------------------------------------
-- Multi-Statement TVFs
---------------------------------------------------------------------

-- DDL and sample data for Employees table
SET NOCOUNT ON;
USE tempdb;
GO
IF OBJECT_ID(N'dbo.Employees', N'U') IS NOT NULL DROP TABLE dbo.Employees;
GO
CREATE TABLE dbo.Employees
(
  empid   INT         NOT NULL CONSTRAINT PK_Employees PRIMARY KEY,
  mgrid   INT         NULL     CONSTRAINT FK_Employees_Employees REFERENCES dbo.Employees,
  empname VARCHAR(25) NOT NULL,
  salary  MONEY       NOT NULL,
  CHECK (empid <> mgrid)
);

INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(1, NULL, 'David', $10000.00),
        (2, 1, 'Eitan', $7000.00),
        (3, 1, 'Ina', $7500.00),
        (4, 2, 'Seraph', $5000.00),
        (5, 2, 'Jiru', $5500.00),
        (6, 2, 'Steve', $4500.00),
        (7, 3, 'Aaron', $5000.00),
        (8, 5, 'Lilach', $3500.00),
        (9, 7, 'Rita', $3000.00),
        (10, 5, 'Sean', $3000.00),
        (11, 7, 'Gabriel', $3000.00),
        (12, 9, 'Emilia' , $2000.00),
        (13, 9, 'Michael', $2000.00),
        (14, 9, 'Didi', $1500.00);


CREATE UNIQUE INDEX idx_unc_mgr_emp_i_name_sal ON dbo.Employees(mgrid, empid)
  INCLUDE(empname, salary);
GO

-- Definition of GetSubtree function
IF OBJECT_ID(N'dbo.GetSubtree', N'TF') IS NOT NULL DROP FUNCTION dbo.GetSubtree;
GO


CREATE FUNCTION DBO.GETSUBTREE (@MGRID AS INT, @MAXLEVELS AS INT = NULL )
RETURNS @TREE TABLE
( 
  empid   INT          NOT NULL PRIMARY KEY,
  mgrid   INT          NULL,
  empname VARCHAR(25)  NOT NULL,
  salary  MONEY        NOT NULL,
  lvl     INT          NOT NULL
)
AS
BEGIN
	DECLARE @LVL INT = 0;

---INSERT SUBTREE ROOT NODE INTO THE @TREE
INSERT INTO @TREE
SELECT  empid, mgrid, empname, salary, @lvl
    FROM dbo.Employees
    WHERE empid = @mgrid;

	WHILE @@ROWCOUNT > 0 AND ( @LVL < @MAXLEVELS OR @MAXLEVELS = NULL )
	BEGIN
	SET
	@LVL += 1;

	---INSERT CHILDREN NODES FROM
    INSERT INTO @Tree
      SELECT E.empid, E.mgrid, E.empname, E.salary, @lvl
      FROM dbo.Employees AS E
        INNER JOIN @Tree AS T
          ON E.mgrid = T.empid AND T.lvl = @lvl - 1;
END;

RETURN;

END;

GO

-- test
SELECT empid, empname, mgrid, salary, lvl
FROM GetSubtree(3, NULL);
GO




/**** TEMP TABLES********/
-- Temporary tables are tables that exist temporarily on the SQL Server.
-- The temporary tables are useful for storing the immediate result sets that are accessed multiple times
-- DEFINITION: Is a table that exists within a session or a batch of a sql statement. Doesn't exist at all within the schema. Is only visible to the batch as long as the batch is open

-- TYPES
--		1) LOCAL TEMP TABLE
--		2) GLOBAL TEMP TABLE

-- # -- local
-- ## -- Global

-- A LOCAL TEMP TABLE is visible for the batch that created it
-- For a GLOBAL TEMP TABLE, the batch that created it and other batches can also access it, and any other person on the server online at that time can access it.
-- SQL Server provided two ways to create temporary tables via SELECT INTO and CREATE TABLE statements.

--		a) Create Temp Table Using SELECT INTO Statement
-- SYNTAX
--			SELECT column_1, column_2,
--			INTO #temp_table			 --- temporary table
--			FROM  table_1
--			WHERE column_3 = 9;
--The statement created the temporary table and populated data from the table_1 table into the temporary table
-- Once you execute the statement, you can find the temporary table name created in the system database named tempdb, using the following path System Databases > tempdb > Temporary Tables


--		b) Create temporary tables using CREATE TABLE statement
-- SYNTAX
--			CREATE TABLE #temp_table ( column_1 datatype, column_2 datatype )
--			FROM  table_1
--			WHERE column_3 = 9;
--
--			INSERT INTO #temp_table
--			SELECT  column_1, column_2
--			FROM table_1
--			WHERE column_3 = 2;

-- This temp table can be queried wth a simple select statement. However, if you open another connection and try the query above query, you will get the following error:
-- Invalid object name '#haro_products'.	This is because the temporary tables are only accessible within the session that created them.


/**** Global temporary tables    *****/
-- Sometimes, you may want to create a temporary table that is accessible across connections. In this case, you can use global temporary tables.
-- Unlike a temporary table, the name of a global temporary table starts with a double hash symbol (##).
-- The following statements first create a global temporary table named ##heller_products and then populate data from the production.products table into this table:

----SYNTAX
----CREATE TABLE ##temp_table (column_1, datatype, column_2 datatype );
----INSERT INTO ##temp_table
----SELECT  column_1, column_2
----FROM table_1
----WHERE column_3 = 2;			--	Now, you can access the ##temp_table table from any session.


/**** Dropping temporary tables   ****/
--			a) Automatic removal
				-- SQL Server drops a temporary table automatically when you close the connection that created it.
				-- SQL Server drops a global temporary table once the connection that created it closed and the queries against this table from other connections completes.

--			b) Manual Deletion
				-- From the connection in which the temporary table created, you can manually remove the temporary table by using the DROP TABLE statement:
--					DROP TABLE ##temp_table;


-- FROM CLASS
-- LOCAL TEMP TABLE
CREATE TABLE #Employees
(
 Custid INT NOT NULL, 
 Name   VARCHAR(30) NOT NULL
);
SELECT *
INTO #Employees
FROM [TSQLV3].Hr.Employees;

SELECT *
FROM #Employees;

-- FROM CLASS
-- GLOBAL TEMP TABLE
CREATE TABLE ##Employees
(Custid INT NOT NULL, 
 Name   VARCHAR(30) NOT NULL
);

SELECT *
INTO ##Employees
FROM [TSQLV3].Hr.Employees;

SELECT *
FROM ##Employees;

-- In this example, we create a global temp table that has the same structure as the HR.Employees and name it ##employeeTEST. 
-- We then import data from hr.employees and insert it into ##employeeTEST
CREATE TABLE ##Employeestest
([Empid]           [INT] IDENTITY(1, 1) NOT NULL, 
 [Lastname]        [NVARCHAR](20) NOT NULL, 
 [Firstname]       [NVARCHAR](10) NOT NULL, 
 [Title]           [NVARCHAR](30) NOT NULL, 
 [Titleofcourtesy] [NVARCHAR](25) NOT NULL, 
 [Birthdate]       [DATETIME] NOT NULL, 
 [Hiredate]        [DATETIME] NOT NULL, 
 [Address]         [NVARCHAR](60) NOT NULL, 
 [City]            [NVARCHAR](15) NOT NULL, 
 [Region]          [NVARCHAR](15) NULL, 
 [Postalcode]      [NVARCHAR](10) NULL, 
 [Country]         [NVARCHAR](15) NOT NULL, 
 [Phone]           [NVARCHAR](24) NOT NULL, 
 [Mgrid]           [INT] NULL, 
 CONSTRAINT [Pk_Employees] PRIMARY KEY CLUSTERED([Empid] ASC)
);

INSERT INTO ##Employeestest(Lastname, Firstname, Title, Titleofcourtesy, Birthdate, Hiredate, Address, City, Region, Postalcode, Country, Phone, Mgrid)	-- Now we can avoid typing all these if we want to import the whole table
       SELECT Lastname, Firstname, Title, Titleofcourtesy, Birthdate, Hiredate, Address, City, Region, Postalcode, Country, Phone, Mgrid
       FROM [TSQLV3].Hr.Employees;

 SELECT *
FROM ##Employeestest;		-- returns a table with no values in the cells

drop table IF EXISTS ##Employeestest


----------------------------------------------
------CREATE THE LOCAL TEMP TABLE
------------------------------------------------

---- USE DDL TO CREATE THE TEMP TABLE
DROP TABLE IF EXISTS #CURRENT_PRIOR_MONTH_BALANCES;
GO

CREATE TABLE #CURRENT_PRIOR_MONTH_BALANCES
(
	 [Loannumber] VARCHAR(100)
	,CYCLEDATE DATE
	,CURRENT_BALANCE MONEY
	,PRIOR_MONTH_BALANCE MONEY
)
GO

INSERT INTO #CURRENT_PRIOR_MONTH_BALANCES
(
	 [Loannumber] 
	,CYCLEDATE
	,CURRENT_BALANCE 
	,PRIOR_MONTH_BALANCE 
)
SELECT [Loannumber]
      ,CYCLEDATE = CAST(CYCLEDATE AS DATE)
	  ,CURRENT_BALANCE = Unpaidprincipalbalance
	  ,PRIOR_MONTH_BALANCE =	LAG([Unpaidprincipalbalance], 1, 0) OVER(PARTITION BY [Loannumber] ORDER BY CYCLEDATE ASC)
  FROM [SkyBarrelBank_UAT].[dbo].[Loanperiodic]
 

 SELECT COUNT(*) 
 FROM #CURRENT_PRIOR_MONTH_BALANCES

 SELECT [Loannumber]
      ,CYCLEDATE
	  ,CURRENT_BALANCE	
	  ,PRIOR_MONTH_BALANCE
	  ,DIFF_BTW_LASTMO_THISMO = CURRENT_BALANCE - PRIOR_MONTH_BALANCE
  FROM #CURRENT_PRIOR_MONTH_BALANCES



  
------------------
-------ALTERNATIVELY: SELECT INTO
-------------------------

SELECT [Loannumber]
      ,CYCLEDATE = CAST(CYCLEDATE AS DATE)
	  ,CURRENT_BALANCE = Unpaidprincipalbalance
	  ,PRIOR_MONTH_BALANCE =	LAG([Unpaidprincipalbalance], 1, 0) OVER(PARTITION BY [Loannumber] ORDER BY CYCLEDATE ASC)
 INTO #2ND_LOCAL_TEMP_TABLE
 FROM [SkyBarrelBank_UAT].[dbo].[Loanperiodic]

-------------
 

 SELECT COUNT(*) 
 FROM #2ND_LOCAL_TEMP_TABLE

 SELECT [Loannumber]
      ,CYCLEDATE
	  ,CURRENT_BALANCE	
	  ,PRIOR_MONTH_BALANCE
	  ,DIFF_BTW_LASTMO_THISMO = CURRENT_BALANCE - PRIOR_MONTH_BALANCE
  FROM #2ND_LOCAL_TEMP_TABLE







----------------------------------------------
------CREATE THE GLOBAL TEMP TABLE
------------------------------------------------

---- USE DDL TO CREATE THE TEMP TABLE
DROP TABLE IF EXISTS ##CURRENT_PRIOR_MONTH_BALANCES;
GO

CREATE TABLE ##CURRENT_PRIOR_MONTH_BALANCES
(
	 [Loannumber] VARCHAR(100)
	,CYCLEDATE DATE
	,CURRENT_BALANCE MONEY
	,PRIOR_MONTH_BALANCE MONEY
)
GO

INSERT INTO ##CURRENT_PRIOR_MONTH_BALANCES
(
	 [Loannumber] 
	,CYCLEDATE
	,CURRENT_BALANCE 
	,PRIOR_MONTH_BALANCE 
)
SELECT [Loannumber]
      ,CYCLEDATE = CAST(CYCLEDATE AS DATE)
	  ,CURRENT_BALANCE = Unpaidprincipalbalance
	  ,PRIOR_MONTH_BALANCE =	LAG([Unpaidprincipalbalance], 1, 0) OVER(PARTITION BY [Loannumber] ORDER BY CYCLEDATE ASC)
  FROM [SkyBarrelBank_UAT].[dbo].[Loanperiodic]
 

 SELECT COUNT(*) 
 FROM ##CURRENT_PRIOR_MONTH_BALANCES

 SELECT [Loannumber]
      ,CYCLEDATE
	  ,CURRENT_BALANCE	
	  ,PRIOR_MONTH_BALANCE
	  ,DIFF_BTW_LASTMO_THISMO = CURRENT_BALANCE - PRIOR_MONTH_BALANCE
  FROM ##CURRENT_PRIOR_MONTH_BALANCES

------------------
-------ALTERNATIVELY: SELECT INTO
-------------------------

SELECT [Loannumber]
      ,CYCLEDATE = CAST(CYCLEDATE AS DATE)
	  ,CURRENT_BALANCE = Unpaidprincipalbalance
	  ,PRIOR_MONTH_BALANCE =	LAG([Unpaidprincipalbalance], 1, 0) OVER(PARTITION BY [Loannumber] ORDER BY CYCLEDATE ASC)
 INTO ##2ND_GLOBAL_TEMP_TABLE
 FROM [SkyBarrelBank_UAT].[dbo].[Loanperiodic]

-------------
 

 SELECT COUNT(*) 
 FROM ##2ND_GLOBAL_TEMP_TABLE

 SELECT [Loannumber]
      ,CYCLEDATE
	  ,CURRENT_BALANCE	
	  ,PRIOR_MONTH_BALANCE
	  ,DIFF_BTW_LASTMO_THISMO = CURRENT_BALANCE - PRIOR_MONTH_BALANCE
  FROM ##2ND_GLOBAL_TEMP_TABLE



  -----DROPPING A TEMP TABLE

--DROP TABLE IF EXISTS ##CURRENT_PRIOR_MONTH_BALANCES;
--GO

--DROP TABLE IF EXISTS ##2ND_GLOBAL_TEMP_TABLE;
--GO





/* SQL ROUTINES  */
-- SQL routines are programmabilities
-- ROUTINES are things that are literally done repetitively
-- a stored procedure, cursor, a trigger, a function are all called SQL routines
-- A stored procedure is created and stored because it is used over and over again.
-- TYPES
--		a) STORED PROCEDURES
--		b) USER-DEFINED FUNCTIONS
--		c)TRIGGERS
--		d) CURSORS


--				a) STORED PROCEDURES
-- Is basically a SQL code that is stored within the database that has already precompiled the data so it can be used over and over again
-- Is a precompiled SQL query
-- It encapulates SQL codes
-- A SQL Server stored procedure groups one or more Transact-SQL statements into a logical unit and is stored as an object in the Database Server.
-- When a stored procedure is called at the first time, SQL Server creates an execution plan and stores it in the plan cache.
-- In the subsequent executions of the stored procedure, SQL Server reuses the plan so that the stored procedure can execute very fast with reliable performance.

-- SYNTAX
--			CREATE PROCEDURE Stored_Procedure_Name
--			AS											-- AS keyword separates the heading and the body of the stored procedure
--				BEGIN
--					SELECT ( column_1, column_2 )
--					FROM  table_1
--					ORDER BY column_1;
--				END;						-- If stored procedure has one statement, BEGIN & END keywords surrounding the statement are optional. However, it is a good practice to include them

-- Yu can find the stored procedure in the Object Explorer, under Programmability > Stored Procedures
-- To execute the Stored Procedure, h
--										EXECUTE Stored_Procedure_Name

-- To modify an existing stored procedure, we use ALTER PROCEDURE
--			ALTER PROCEDURE Stored_Procedure_Name
--			AS							
--				BEGIN
--					SELECT ( column_1, column_2 )
--					FROM  table_1
--					ORDER BY Column_2;
--				END;						

-- To delete an existing stored procedure, we use DROP PROCEDURE
--																	DROP Stored_Procedure_Name


-- PROBLEM:
-- Create a report to show all the orders placed by a customer with ID 37 in the second quarter of the year 2007
--SOLUTION
-- From our prior knowledge:

SELECT Orderid, Custid, Shipperid, Orderdate, Requireddate, Shippeddate
FROM [TSQLV3].Sales.Orders
WHERE Custid = 37
      AND Orderdate BETWEEN '04-01-2007' AND '06-30-2007';

-- Now, any time we need to pull similar data for another customer and maybe with different dates, we'd have to go back to the query and change the entire. This will be too much work

-- So this is how we solve it

DECLARE @Custid AS INT= 37,
		@Orderdatefrom AS DATE= '04-01-2007',
		@Orderdateto AS DATE= '06-30-2007';
SELECT Orderid, Custid, Shipperid, Orderdate, Requireddate, Shippeddate
FROM [TSQLV3].Sales.Orders
WHERE Custid = @Custid
      AND Orderdate BETWEEN @Orderdatefrom AND @Orderdateto;




IF OBJECT_ID('Sales.CustomersOrders', 'P') IS NOT NULL		-- P is the acronymn of a procedure
    DROP PROC Sales.Customersorders;
GO

CREATE PROC Sales.Customersorders @Custid AS        INT  = 37, 
                                  @Orderdatefrom AS DATE = '04-01-2007', 
                                  @Orderdateto AS   DATE = '06-30-2007'
AS
    BEGIN
        SELECT Orderid, Custid, Shipperid, Orderdate, Requireddate, Shippeddate
        FROM [TSQLV3].Sales.Orders
        WHERE Custid = @Custid
              AND Orderdate BETWEEN @Orderdatefrom AND @Orderdateto;
    END;
-- Our Stored Procedute is created. Now we execute it
EXEC Sales.Customersorders;

EXEC Sales.Customersorders 
     @Custid = 32, 
     @Orderdatefrom = '07-01-2007', 
     @Orderdateto = '09-30-2007';


EXEC Sales.Customersorders 
     @Custid = 21, 
     @Orderdatefrom = '01-01-2007', 
     @Orderdateto = '09-30-2007';



--------------------------------------------------------
--------------- EXAMPLE 2
---------------------------------------------------------


--------REQUIREMENT

---------- CREATE A STORED PROCEDURE THAT TAKES A BORROWER SSN, AND MONTH AND YEAR AND RETURNS THE TOTAL BALANCE OF THEIR LOANS
---------- AND THE PRIOR MONTHS BALANCE AND THE DIFFERENCE BETWEEN THE TWO

WITH CTE_A AS
(
SELECT BORROWER	=	CONCAT_WS(' ', BORROWERFIRSTNAME, BORROWERLASTNAME)
	  ,SSN = CONCAT('*****',RIGHT(TaxPayerID_SSN, 4))
	  ,LS.[Loannumber]
      ,CYCLEDATE
	  ,[Paidinstallment]
	  ,[Unpaidprincipalbalance]
	  ,PRIOR_MONTH_PAID_INSTALLMENT =	LAG([Unpaidprincipalbalance], 1, 0) OVER(PARTITION BY LS.[Loannumber] ORDER BY CYCLEDATE ASC)
  FROM [SkyBarrelBank_UAT].[dbo].[Loanperiodic] AS LP
  INNER JOIN [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS LS
  ON LP.Loannumber = LS.LoanNumber
  INNER JOIN [SkyBarrelBank_UAT].[dbo].[Borrower] AS B
  ON LS.BorrowerID = B.BorrowerID
  WHERE B.TaxPayerID_SSN = '402858525'
  AND MONTH(LP.Cycledate) = 12 AND YEAR(LP.Cycledate) = 2020
)
SELECT BORROWER
	  ,SSN
      ,CYCLEDATE
	  ,[Paidinstallment]	=	SUM([Paidinstallment])
	  ,[Unpaidprincipalbalance]	=	SUM([Unpaidprincipalbalance])
	  ,PRIOR_MONTH_PAID_INSTALLMENT 	=	SUM(PRIOR_MONTH_PAID_INSTALLMENT)
	  ,DIFF_BTW_LASTMO_THISMO = SUM([Unpaidprincipalbalance]) - SUM(PRIOR_MONTH_PAID_INSTALLMENT)
  FROM CTE_A
  GROUP BY BORROWER,SSN,CYCLEDATE




  -------------HERE IS THE STORED PROCEDURE NOW BUILD
  GO

CREATE PROCEDURE dbo.DIFF_BTW_LASTMO_THISMO 
     @SSN VARCHAR(9)
	,@CYCLE_YEAR INT
	,@CYCLE_MONTH INT
AS

BEGIN

WITH CTE_A AS
(
SELECT BORROWER	=	CONCAT_WS(' ', BORROWERFIRSTNAME, BORROWERLASTNAME)
	  ,SSN = CONCAT('*****',RIGHT(TaxPayerID_SSN, 4))
	  ,LS.[Loannumber]
      ,CYCLEDATE
	  ,[Paidinstallment]
	  ,[Unpaidprincipalbalance]
	  ,PRIOR_MONTH_PAID_INSTALLMENT =	LAG([Unpaidprincipalbalance], 1, 0) OVER(PARTITION BY LS.[Loannumber] ORDER BY CYCLEDATE ASC)
  FROM [SkyBarrelBank_UAT].[dbo].[Loanperiodic] AS LP
  INNER JOIN [SkyBarrelBank_UAT].[dbo].[LoanSetupInformation] AS LS
  ON LP.Loannumber = LS.LoanNumber
  INNER JOIN [SkyBarrelBank_UAT].[dbo].[Borrower] AS B
  ON LS.BorrowerID = B.BorrowerID
  WHERE B.TaxPayerID_SSN = @SSN
  AND MONTH(LP.Cycledate) = @CYCLE_MONTH AND YEAR(LP.Cycledate) = @CYCLE_YEAR
)
SELECT BORROWER
	  ,SSN
      ,CYCLEDATE
	  ,[Paidinstallment]	=	SUM([Paidinstallment])
	  ,[Unpaidprincipalbalance]	=	SUM([Unpaidprincipalbalance])
	  ,PRIOR_MONTH_PAID_INSTALLMENT 	=	SUM(PRIOR_MONTH_PAID_INSTALLMENT)
	  ,DIFF_BTW_LASTMO_THISMO = SUM([Unpaidprincipalbalance]) - SUM(PRIOR_MONTH_PAID_INSTALLMENT)
  FROM CTE_A
  GROUP BY BORROWER,SSN,CYCLEDATE
;

END

GO



-------- EXECUTE THE STORED PROCEDURE
EXECUTE [dbo].[DIFF_BTW_LASTMO_THISMO]  '570798392', 2002, 10

EXEC [dbo].[DIFF_BTW_LASTMO_THISMO]  '402858525', 2020, 12

EXECUTE [dbo].[DIFF_BTW_LASTMO_THISMO]  '402858525', 2020, 12



-- IF/ELSE
-- the IF...ELSE statement is a control-flow statement that allows you to execute or skip a statement block based on a specified condition.
--	

-- The following ilustrates the syntax of IF - STATEMENT
-- SYNTAX
--				IF boolean_expression   
--				BEGIN
--				    { statement_block }
--				END


-- In this syntax, if the Boolean_expression evaluates to TRUE then the statement_block in the BEGIN...END block is executed. 
-- Otherwise, the statement_block is skipped and the control of the program is passed to the statement after the END keyword.
-- Note that if the Boolean expression contains a SELECT statement, you must enclose the SELECT statement in parentheses

-- IF ELSE statement
-- When the condition in the IF clause evaluates to FALSE and you want to execute another statement block, you can use the ELSE clause.

--The following illustrates the IF ELSE statement:

-- SYNTAX
--				IF boolean_expression   
--				BEGIN
--				    { statement_block }		---- Statement block executes when the Boolean expression is TRUE
--				END
--				ELSE
--				BEGIN
--				    { statement_block }		---- Statement block executes when the Boolean expression is FALSE
--				END


-- EXAMPLE

DECLARE @Var1 AS INT, @Var2 AS INT;
SET @Var1 = 1;
SET @Var2 = 1;


IF @Var1 = @Var2
BEGIN
DECLARE @OUTPUT_TRUE VARCHAR(100) = CONCAT('The Variables ', @var1, ' and ', @var2, ' are Equal');

    PRINT @OUTPUT_TRUE;
END
ELSE
    BEGIN
	DECLARE @OUTPUT_FALSE VARCHAR(100) = CONCAT('The Variables ', @var1, ' and ', @var2, ' are NOT Equal');

    PRINT @OUTPUT_FALSE;
END;
GO



-- WHILE CONTRAST/LOOP
-- Creates a loop/s inside a SQL in order to execute a statement block as long as the statement continue to evaluate as true
-- It can be used in CURSORS or even by itself
-- DEFINITION: The WHILE statement is a control-flow statement that allows you to execute a statement block repeatedly as long as a specified is TRUE.

--The following illustrates the syntax of the WHILE statement:
--	SYNTAX
--			WHILE Boolean_expression				-- Boolean_expression is an expression that evaluates to TRUE or FALSE
--			    { sql_statement | statement_block}	-- is any Transact-SQL statement or a set of Transact-SQL statements. A statement block is defined using the BEGIN...END statement.

-- If the Boolean_expression evaluates to FALSE when entering the loop, no statement inside the WHILE loop will be executed.
-- Inside the WHILE loop, you must change some values to make the Boolean_expression returns FALSE at some points. Otherwise, you will have an indefinite loop.
-- Note that if the Boolean_expression contains a SELECT statement, it must be enclosed in parentheses.
-- To exit the current iteration of the loop immediately, you use the BREAK statement. To skip the current iteration of the loop and start the new one, you use the CONTINUE statement.


-- EXAMPLE
-- Use the WHILE LOOP to count numbers 1 to 10 and quit


DECLARE @Count AS INT= 1;
WHILE @Count <= 10
    BEGIN
        PRINT CAST(@Count AS VARCHAR);
        SET @Count = @Count + 1;
    END;

GO
----------------------------
------- EXAMPLE 2
----------------------------
DECLARE @Count AS INT= 1;
DECLARE @THIS_TABLE TABLE
(LOOP_VALUE  INT, 
 COUNT_VALUE VARCHAR(1000)
);
WHILE @Count <= 10
    BEGIN
        INSERT INTO @THIS_TABLE
        (LOOP_VALUE, 
         COUNT_VALUE
        )
               SELECT LOOP_VALUE = @COUNT, 
                      COUNT_VALUE = CONCAT('THIS IS LOOP ', CAST(@Count AS VARCHAR));
        ------ INCREMENT THE VALUE OF THE LOOPING VARIABLE
        SET @Count = @Count + 1;
    END;
SELECT LOOP_VALUE, 
       COUNT_VALUE
FROM @THIS_TABLE
ORDER BY LOOP_VALUE ASC;
GO


/***** TRIGGERS ******/
-- Is a special kind of stored procedure that is associated with a selected DML in a table of view
 --DEFINITION: SQL Server triggers are special stored procedures that are executed automatically in response to the database object, database, and server event

 --SQL Server provides three type of triggers:
	--	a) (DML) triggers which are invoked automatically in response to INSERT, UPDATE, and DELETE events against tables.
	--	b) (DDL) triggers which fire in response to CREATE, ALTER, and DROP statements. DDL triggers also fire in response to some system stored procedures that perform DDL-like operations.
	--	c) Logon triggers which fire in response to LOGON events

 --INTRO TO CREATE TRIGGER statement
 --It allows you to create a new trigger that is fired automatically whenever an event such as INSERT, DELETE, or UPDATE occurs against a table


 --TYPES OF TRIGGERS
	--	a)	AFTER TRIGGER		- is that type of trigger that fires after the event it is associated with. can only be defined on PERMANENT TABLES, NOT VIEWS
	--	b) INSTEAD OF			- fires INSTEAD of the event it is associated with. Can only DEFINED on PERMANENT tables and VIEWS

	--SYNTAX
	--		CREATE TRIGGER trigger_name
	--		ON table_name
	--		FOR  events
	--		AS
	--			BEGIN
	--				block of sql_statements
	--			END


-- EXAMPLE
-- We are going to create a trigger on the sales.orderdetails to give us a feedback(ALERT US) of how many rows are in the inserted and deleted table

-- SOLUTION

USE [TSQLV3]
GO

DROP TRIGGER IF EXISTS Sales.Tr_Salesorderdetail_REMINDER;
GO

DROP TRIGGER IF EXISTS Sales.Tr_Salesorderdetail_CALCULATE_ORDER_AMOUNT;
GO

--ALTER TABLE [TSQLV3].[Sales].[OrderDetails]
--ADD ORDER_AMOUNT VARCHAR(10) NULL
--GO

SELECT *
FROM [TSQLV3].Sales.Orderdetails
WHERE ORDERID = 10248 AND productid = 11;
GO
-- SOLUTION

DELETE FROM [TSQLV3].Sales.Orderdetails
WHERE ORDERID = 10248 AND productid = 11;
GO



CREATE TRIGGER Sales.Tr_Salesorderdetail_REMINDER 
ON Sales.Orderdetails
AFTER DELETE, INSERT, UPDATE
AS 
	BEGIN
	DECLARE @MESSAGE VARCHAR(100);
	SELECT @MESSAGE = CONCAT('INSERTION/DELETION/UPDATE OF ', @@ROWCOUNT, ' ROWS BY x', /*ORIGINAL_LOGIN(),  */' SUCCESSFUL');

	PRINT @MESSAGE ;
	END
GO


CREATE TRIGGER Sales.Tr_Salesorderdetail_CALCULATE_ORDER_AMOUNT
ON Sales.Orderdetails
AFTER INSERT, UPDATE
AS 
	BEGIN
		UPDATE Sales.Orderdetails 
        SET ORDER_AMOUNT = FORMAT(I.unitprice*I.qty, 'C2')
        FROM Sales.Orderdetails t 
		INNER JOIN inserted i 
		ON t.[orderid] = i.[orderid]
		AND T.productid = I.productid
	END
GO



INSERT INTO [TSQLV3].Sales.Orderdetails ([orderid],[productid],[unitprice] , [qty], [discount])
VALUES(10248, 11, 14.00, 22, 0.000);
GO

SELECT *
FROM [TSQLV3].Sales.Orderdetails
WHERE orderid = 10248 AND productid = 11
-- Let's create a new trigger



IF OBJECT_ID('Production.tr_ProductionCategories_categoryname', 'TR') IS NOT NULL		-- TR acronymn for TRIGGER
    DROP TRIGGER Production.Tr_Productioncategories_Categoryname;
GO
CREATE TRIGGER Production.Tr_Productioncategories_Categoryname ON Production.Categories
AFTER INSERT, UPDATE
AS
     BEGIN
         IF @@RowCount = 0			-- always important to initialize the system rowcount to trigger
             RETURN;
         SET NOCOUNT ON;
         IF EXISTS(SELECT COUNT(*)
                   FROM Inserted AS I
                        JOIN Production.Categories AS C
                        ON I.Categoryname = C.Categoryname
                   GROUP BY I.Categoryname
                   HAVING COUNT(*) > 1)
             BEGIN
                 THROW 50000, 'Duplicate category names not allowed', 0;
         END;
     END;
	  GO

INSERT INTO Production.Categories(Categoryname, Description)
VALUES('TestedCategory2', 'Test2 description');

UPDATE Production.Categories
  SET 
      Categoryname = 'Beverages'
WHERE Categoryname = 'TestedCategory2';

DELETE FROM Production.Categories
WHERE Categoryname = 'TestCategory2';



/**** SQL CURSORS  ****/

-- SQL statements always produce a result set, but there are times when it's best to process one row at a time
-- The dataType should be CURSOR
-- DEFINITION: Cursor is a Database object which allows us to process each row and manipulate its data.
-- A Cursor is always associated with a Select Query and it will process each row returned by the Select Query one by one.
-- Using Cursor, we can verify each row data, modify it or perform calculations which are not possible when we get all records at once.
-- A simple example would be a case where you have records of Employees and you need to calculate Salary of each employee after deducting Taxes and Leaves.

-- STEPS OF DECLARING A CURSOR
-- 1) Declare the variables for each attributes(columns) that we want to fetch in our select query
-- 2) DELARE THE CURSOR   (give it a name then set its type as READ_ONLY. Then add FOR)
-- 3) USE THE SELECT STATEMENT		 
-- 4) Open the cursor and fetch the contents in the same order as were in the select statement
-- 5) It's important to get the first row before the while loop, so that the loop condition will be satisfied to start with. We use the @@FETCH_STATUS built-in t-SQL variable 
--		which controls the exit condition. And at the end, we use the same fetch content which we had used previously.
--		(Whenever a record is fetched the @@FETCH_STATUS has value 0 and as soon as all the records returned by the Select Query are fetched, its value changes to -1)
--		(A Cursor is associated with a WHILE LOOP which executes until the @@FETCH_STATUS has value 0).
--		(Inside the WHILE LOOP, the processing is done for the current record and then again the next record is fetched and this process continues until @@FETCH_STATUS is 0)
-- 7) Finally the Cursor is closed and deallocated using CLOSE and DEALLOCATE commands respectively.
--		It is important to clean the rtesource which frees up the memory space and improves the server up-time
--		Note: It is very important to DEALLOCATE a Cursor as otherwise it will stay in database and when you declare a Cursor with same name again, 
--				SQL Server will throw an error: A cursor with the name 'Cursor1' already exists.



-- EXAMPLE
-- Let's use a cursor to write a code that will execute a store procedure for each customer on the customer table

-- We first create that stored procedure


IF OBJECT_ID('sales.processCustomer', 'P') IS NOT NULL
    DROP PROC Sales.Processcustomer;
GO
CREATE PROC Sales.Processcustomer @Custid AS INT
AS
     PRINT 'Processing Customer' + ' ' + CAST(@Custid AS VARCHAR(10));
GO
EXECUTE Sales.Processcustomer 
        @Custid = 1;
-- Then We now write the code for the cursor

SET NOCOUNT ON;			-- We do not want any count to display
DECLARE @CursorCustid AS INT;
DECLARE Cust_Cursor CURSOR
FOR SELECT Custid
    FROM Sales.Customers;
OPEN Cust_Cursor;
FETCH NEXT FROM Cust_Cursor INTO @CursorCustid;
WHILE @@Fetch_Status = 0
    BEGIN
        EXECUTE Sales.Processcustomer 
                @Custid = @CursorCustid;
        FETCH NEXT FROM Cust_Cursor INTO @Cursorcustid;
    END;
CLOSE Cust_Cursor;
DEALLOCATE Cust_Cursor;



---------------------------------------------------------------------
-- Dynamic SQL
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Using the EXEC Command
---------------------------------------------------------------------
---- CREATE A DYNAMIC SQL THAT WILL TAKE IN A LAST NAME AND RETURNS THE BORROWERS WITH THAT LAST NAME

USE [SkyBarrelBank_UAT]

--- STEP 1
SELECT BorrowerID, BorrowerFirstName, BorrowerLastName, PhoneNumber, SSN = CONCAT('*****', RIGHT(TaxPayerID_SSN, 4))
FROM DBO.Borrower 
WHERE BorrowerLastName = 'DAVIS'
GO

---- DECLARE A VARIABLE
DECLARE @BorrowerLastName VARCHAR(100)= 'DAVIS';

SELECT BorrowerID, BorrowerFirstName, BorrowerLastName, PhoneNumber, SSN = CONCAT('*****', RIGHT(TaxPayerID_SSN, 4))
FROM DBO.Borrower 
WHERE BorrowerLastName = @BorrowerLastName
GO

--------------------------------------------------------------------------------
SET NOCOUNT ON;

DECLARE @BorrowerLastName NVARCHAR(100);
SET @BorrowerLastName = 'DAVIS';	--- USER INPUT

----HERE IS OUR DYNAMIC SQL
DECLARE @SQL NVARCHAR (1000);
SET @SQL = concat('SELECT BorrowerID, BorrowerFirstName, BorrowerLastName, PhoneNumber, SSN = CONCAT(''*****'', RIGHT(TaxPayerID_SSN, 4))
FROM DBO.Borrower
WHERE BorrowerLastName = ''', @BorrowerLastName, '''');

PRINT @SQL

EXEC(@SQL)

GO
------SQL INJECTION

DECLARE @BorrowerLastName NVARCHAR(100);
SET @BorrowerLastName = 'ABC''; PRINT ''SQL INJECTION! YOU HAVE BEEN HACKED!!!!!'';--';	--- USER INPUT

----HERE IS OUR DYNAMIC SQL
DECLARE @SQL NVARCHAR (1000);
SET @SQL = concat('SELECT BorrowerID, BorrowerFirstName, BorrowerLastName, PhoneNumber, SSN = CONCAT(''*****'', RIGHT(TaxPayerID_SSN, 4))
FROM DBO.Borrower
WHERE BorrowerLastName = ''', @BorrowerLastName, '''');

--PRINT @SQL

EXEC(@SQL)

GO

DECLARE @BorrowerLastName NVARCHAR(1000);
SET @BorrowerLastName = 'ABC'' UNION ALL SELECT object_id, SCHEMA_NAME(schema_id), name, NULL, null FROM sys.objects WHERE type IN (''U'', ''V'');--';	--- USER INPUT

----HERE IS OUR DYNAMIC SQL
DECLARE @SQL NVARCHAR (4000);
SET @SQL = concat('SELECT BorrowerID, BorrowerFirstName, BorrowerLastName, PhoneNumber, SSN = CONCAT(''*****'', RIGHT(TaxPayerID_SSN, 4))
FROM DBO.Borrower
WHERE BorrowerLastName = ''', @BorrowerLastName, '''');

--PRINT @SQL

EXEC(@SQL)

GO


GO

DECLARE @BorrowerLastName NVARCHAR(1000);
SET @BorrowerLastName = 'ABC'' UNION ALL SELECT NULL, name, NULL, NULL, NULL FROM sys.columns WHERE object_id = 1429580131; --';	--- USER INPUT

----HERE IS OUR DYNAMIC SQL
DECLARE @SQL NVARCHAR (4000);
SET @SQL = concat('SELECT BorrowerID, BorrowerFirstName, BorrowerLastName, PhoneNumber, SSN = CONCAT(''*****'', RIGHT(TaxPayerID_SSN, 4))
FROM DBO.Borrower
WHERE BorrowerLastName = ''', @BorrowerLastName, '''');

--PRINT @SQL

EXEC(@SQL)

GO

DECLARE @BorrowerLastName NVARCHAR(1000);
SET @BorrowerLastName = 'ABC'' UNION ALL SELECT NULL, BorrowerFirstName, BorrowerLastName, PhoneNumber, TaxPayerID_SSN FROM DBO.Borrower; --';	--- USER INPUT

----HERE IS OUR DYNAMIC SQL
DECLARE @SQL NVARCHAR (4000);
SET @SQL = concat('SELECT BorrowerID, BorrowerFirstName, BorrowerLastName, PhoneNumber, SSN = CONCAT(''*****'', RIGHT(TaxPayerID_SSN, 4))
FROM DBO.Borrower
WHERE BorrowerLastName = ''', @BorrowerLastName, '''');

--PRINT @SQL

EXEC(@SQL)


GO
---------------------------------------------------------------------
-- Using the sp_executesql Procedure
---------------------------------------------------------------------
-- Has Interface
-- Input Parameters
DECLARE @lastname AS NVARCHAR(200);
SET @lastname = N'Davis';

DECLARE @sql AS NVARCHAR(1000);
SET @sql = N'SELECT BorrowerID, BorrowerFirstName, BorrowerLastName, PhoneNumber
FROM DBO.Borrower WHERE BorrowerLastName = @lastname;';

PRINT @sql; -- For debug purposes

EXEC sp_executesql
  @stmt = @sql,
  @params = N'@lastname AS NVARCHAR(200)',
  @lastname = @lastname;
GO



----------------- DYNAMICALLY CHOOSE THE COLUMN TO BE OUTPUT
DECLARE @COLUMNNAME AS NVARCHAR(200);
SET @COLUMNNAME = N'EMAIL';

DECLARE @sql AS NVARCHAR(1000);
SET @sql = CONCAT(N'SELECT TOP (10) BorrowerID, BorrowerFirstName, BorrowerLastName, ', @COLUMNNAME, ' 
FROM DBO.Borrower;');

PRINT @sql; -- For debug purposes

EXEC (@SQL)









































---------------------------------------------------------------------
-- Dynamic SQL
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Using the EXEC Command
---------------------------------------------------------------------

-- Simple example with EXEC
SET NOCOUNT ON;
USE [SkyBarrelBank_UAT];

DECLARE @s AS NVARCHAR(200);
SET @s = N'Davis'; -- originates in user input

DECLARE @sql AS NVARCHAR(1000);
SET @sql = N'SELECT BorrowerID, BorrowerFirstName, BorrowerLastName, PhoneNumber
FROM DBO.Borrower WHERE BorrowerLastName = N''' + @s + N''';';

PRINT @sql; -- for debug purposes
EXEC (@sql);
GO

-- SQL Injection

-- Try with
-- SET @s = N'abc''; PRINT ''SQL injection!''; --';

-- Try with
-- SET @s = N'abc'' UNION ALL SELECT object_id, SCHEMA_NAME(schema_id), name, NULL FROM sys.objects WHERE type IN (''U'', ''V''); --';

-- Try with
-- SET @s = N'abc'' UNION ALL SELECT NULL, name, NULL, NULL FROM sys.columns WHERE object_id = 485576768; --';

-- Try with
-- SET @s = N'abc'' UNION ALL SELECT NULL, companyname, phone, NULL FROM Sales.Customers; --';

---------------------------------------------------------------------
-- Using EXEC AT
---------------------------------------------------------------------

-- Create a linked server
EXEC sp_addlinkedserver
  @server = N'YourServer',
  @srvproduct = N'SQL Server';
GO

-- Construct and execute code
DECLARE @sql AS NVARCHAR(1000), @pid AS INT;

SET @sql = 
N'SELECT productid, productname, unitprice
FROM TSQLV3.Production.Products
WHERE productid = ?;';

SET @pid = 3;

EXEC(@sql, @pid) AT [YourServer];
GO

---------------------------------------------------------------------
-- Using the sp_executesql Procedure
---------------------------------------------------------------------

-- Has Interface

-- Input Parameters
DECLARE @s AS NVARCHAR(200);
SET @s = N'Davis';

DECLARE @sql AS NVARCHAR(1000);
SET @sql = N'SELECT BorrowerID, BorrowerFirstName, BorrowerLastName, PhoneNumber
FROM DBO.Borrower WHERE BorrowerLastName = @lastname;';

PRINT @sql; -- For debug purposes

EXEC sp_executesql
  @stmt = @sql,
  @params = N'@lastname AS NVARCHAR(200)',
  @lastname = @s;
GO


