USE [FauxBank]
GO
/****** Object:  Table [dbo].[tblAccount]    Script Date: 16/04/2014 12:09:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAccount](
	[accountid] [bigint] IDENTITY(34534454536,1) NOT NULL,
	[name] [nvarchar](256) NOT NULL,
	[email] [nvarchar](256) NOT NULL,
	[password] [nvarchar](128) NOT NULL,
	[securepasswordhash] [nvarchar](500) NOT NULL,
	[salt] [nvarchar](50) NOT NULL,
	[passwordreminder] [nvarchar](4000) NOT NULL,
	[sessionkey] [nvarchar](50) NULL,
	[balance] [decimal](18, 5) NOT NULL,
	[lastactivitiy] [datetime] NULL,
	[useragent] [nvarchar](50) NOT NULL,
	[accountdeleted] [bit] NOT NULL,
 CONSTRAINT [PK_tblAccount] PRIMARY KEY CLUSTERED 
(
	[accountid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblTransaction]    Script Date: 16/04/2014 12:09:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTransaction](
	[transactionid] [bigint] IDENTITY(1,1) NOT NULL,
	[accountid_to] [bigint] NOT NULL,
	[accountid_from] [bigint] NOT NULL,
	[amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_tblTransaction] PRIMARY KEY CLUSTERED 
(
	[transactionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblAccount] ADD  CONSTRAINT [DF_tblAccount_balance]  DEFAULT ((100)) FOR [balance]
GO

ALTER TABLE [dbo].[tblAccount] ADD  CONSTRAINT [DF_tblAccount_passwordreminder]  DEFAULT ('') FOR [passwordreminder]
GO

ALTER TABLE [dbo].[tblAccount] ADD  CONSTRAINT [DF_tblAccount_salt]  DEFAULT ('') FOR [salt]
GO

ALTER TABLE [dbo].[tblAccount] ADD  CONSTRAINT [DF_tblAccount_accountdeleted]  DEFAULT ((0)) FOR [accountdeleted]
GO

CREATE TABLE [dbo].[tblEmployee](
	[employeeID] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](300) NOT NULL,
	[username] [nvarchar](300) NOT NULL,
	[password] [nvarchar](128) NOT NULL,
	[uniquehash] [nvarchar](128) NOT NULL,
	[sessionkey] [nvarchar](50) NULL,
	[accesslevel] [int] NOT NULL,
	[lastactivity] [datetime] NULL,
	[useragent] [nvarchar](50) NOT NULL,
	[ipaddress] [nvarchar] (20) NOT NULL,
 CONSTRAINT [PK_tblEmployee] PRIMARY KEY CLUSTERED 
(
	[employeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblEmployee] ADD  CONSTRAINT [DF_Table_1_employeeAccessLevel]  DEFAULT ((0)) FOR [accesslevel]
GO

ALTER TABLE [dbo].[tblEmployee] ADD  CONSTRAINT [DF_tblEmployee_useragent]  DEFAULT ('') FOR [useragent]
GO

ALTER TABLE [dbo].[tblEmployee] ADD  CONSTRAINT [DF_tblEmployee_ipaddress]  DEFAULT ('') FOR [ipaddress]
GO


CREATE PROCEDURE sp_registeraccount
	@strEmail nvarchar(256),
	@strPassword nvarchar(128),
	@strName nvarchar(256),
	@strPasswordReminder nvarchar(4000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO tblAccount(email,password,sessionkey,name,passwordreminder)
	VALUES (@strEmail,@strPassword,NULL,@strName,@strPasswordReminder)

	SELECT SCOPE_IDENTITY() as accountnumber
END
GO


CREATE PROCEDURE sp_authenticate
	@intAccountNumber bigint,
	@strPassword nvarchar(500),
	@strSessionKey nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @intbalance as decimal(18,5)
	DECLARE @userID2 as bigint
	DECLARE @strName nvarchar(500)

	IF @strSessionKey='' AND @intAccountNumber>0 AND @strPassword<>'' BEGIN

		SELECT @intAccountNumber=MIN(accountid) FROM tblAccount WHERE accountid=@intAccountNumber AND [password]=@strPassword

		IF @intAccountNumber IS NOT NULL BEGIN

			DECLARE @strCodeCharacters varchar(50)
			DECLARE @index as int
			SET @strCodeCharacters='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

			WHILE @strSessionKey='' OR @userID2 IS NOT NULL BEGIN
				SET @index=0
				WHILE @index<48 BEGIN
					SET @strSessionKey=@strSessionKey+SUBSTRING(@strCodeCharacters,CAST(RAND()*LEN(@strCodeCharacters) AS tinyint)+1,1)
					SET @index=@index+1
				END
				SET @strSessionKey='n'+@strSessionKey+'n'
			
				SELECT @userID2=MIN(accountid) FROM tblAccount WHERE CAST(sessionkey AS varbinary(50))=CAST(@strSessionKey AS varbinary(50))
			END

			UPDATE tblAccount 
			SET sessionkey=@strSessionKey
			WHERE accountid=@intAccountNumber

			SELECT @intbalance=balance,@strName=name FROM tblAccount WHERE accountid=@intAccountNumber

			SET NOCOUNT OFF;
			
			SELECT 0 as errorCode,'' as errorMessage
			
			SELECT @strSessionKey as sessionkey,@intAccountNumber as account,@intbalance as balance,@strName as name

		END ELSE BEGIN
		
			SET NOCOUNT OFF;
		
			SELECT 1 as errorCode,'Invalid Session Key' as errorMessage
			
		END

	END ELSE IF @strSessionKey<>'' AND (@intAccountNumber=0 OR  @intAccountNumber IS NULL) AND @strPassword='' BEGIN

		SELECT @intAccountNumber=MIN(accountid) FROM tblAccount WHERE sessionkey=@strSessionKey

		IF @intAccountNumber IS NOT NULL BEGIN

			SELECT @intbalance=balance,@strName=name FROM tblAccount WHERE accountid=@intAccountNumber

			SET NOCOUNT OFF;
			
			SELECT 0 as errorCode,'' as errorMessage

			SELECT @strSessionKey as sessionkey,@intAccountNumber as account,@intbalance as balance,@strName as name

		END ELSE BEGIN

			SET NOCOUNT OFF;
		
			SELECT 1 as errorCode,'Invalid Session Key' as errorMessage
			
		END


	END ELSE BEGIN

		SET NOCOUNT OFF;
	
		SELECT 1 as errorCode,'Invalid Session Key' as errorMessage

	END

END
GO

CREATE PROCEDURE sp_gettransactions
	@strSessionKey nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @intAccountID bigint
	SELECT @intAccountID=MIN(accountID) FROM tblAccount WHERE sessionkey=@strSessionKey

SET NOCOUNT OFF;

	SELECT a1.accountid as toaccount,a1.name as toname,a2.accountid as fromaccount,a2.name as fromname,t.amount,t.transactionid
	FROM tblTransaction t
	INNER JOIN tblAccount a1 ON a1.accountid=t.accountid_to
	INNER JOIN tblAccount a2 ON a2.accountid=t.accountid_from
	WHERE a2.accountid=@intAccountID OR a1.accountid=@intAccountID

END
GO

CREATE PROCEDURE sp_createtransaction
	@strSessionKey nvarchar(50),
	@intToAccountID bigint,
	@intAmount decimal(18,5)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @intFromAccountID bigint

	SELECT @intToAccountID=MIN(accountid) FROM tblAccount WHERE accountID=@intToAccountID

	IF @intToAccountID IS NOT NULL BEGIN

		SELECT @intFromAccountID=MIN(accountid) FROM tblAccount WHERE sessionkey=@strSessionKey

		IF @intToAccountID IS NOT NULL BEGIN

			INSERT INTO tblTransaction (accountid_to,accountid_from,amount) VALUES (@intToAccountID,@intFromAccountID,@intAmount)

			UPDATE tblAccount
			SET balance=balance-@intAmount
			WHERE accountid=@intFromAccountID

			UPDATE tblAccount
			SET balance=balance+@intAmount
			WHERE accountid=@intToAccountID

			SET NOCOUNT OFF;

			SELECT 'ok' as message

		END ELSE BEGIN

			SET NOCOUNT OFF;

			SELECT 'invalidaccount' as message

		END

	END ELSE BEGIN

		SET NOCOUNT OFF;

		SELECT 'invalidaccount' as message

	END

END
GO


CREATE PROCEDURE [dbo].[sp_employeeauthenticate]
	@strUsername nvarchar(300),
	@strPassword nvarchar(128),
	@strSessionKey nvarchar(50),
	@strUserAgent nvarchar(50),
	@strIPAddress nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @intAccountNumber bigint
	DECLARE @intaccesslevel as int
	DECLARE @userID2 as bigint
	DECLARE @strName nvarchar(500)
	DECLARE @strCodeCharacters varchar(50)
	DECLARE @index as int

	IF @strSessionKey='' AND @strUsername<>'' AND @strPassword<>'' BEGIN

		SELECT @intAccountNumber=MIN(employeeid) FROM tblEmployee WHERE username=@strUsername AND [password]=@strPassword

		IF @intAccountNumber IS NOT NULL BEGIN

			----create a session key
			SET @strCodeCharacters='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

			WHILE @strSessionKey='' OR @userID2 IS NOT NULL BEGIN
				SET @index=0
				WHILE @index<48 BEGIN
					SET @strSessionKey=@strSessionKey+SUBSTRING(@strCodeCharacters,CAST(RAND()*LEN(@strCodeCharacters) AS tinyint)+1,1)
					SET @index=@index+1
				END
				SET @strSessionKey='n'+@strSessionKey+'n'
			
				SELECT @userID2=MIN(employeeid) FROM tblEmployee WHERE CAST(sessionkey AS varbinary(50))=CAST(@strSessionKey AS varbinary(50))
			END

			--store the session key, last activity and user agent
			UPDATE tblEmployee 
			SET sessionkey=@strSessionKey,lastactivity=getdate(),useragent=@strUserAgent
			WHERE employeeID=@intAccountNumber

			SELECT @intaccesslevel=accesslevel,@strName=name FROM tblEmployee WHERE employeeid=@intAccountNumber

			SET NOCOUNT OFF;
			
			SELECT 0 as errorCode,'' as errorMessage
			
			SELECT @strSessionKey as sessionkey,@strUsername as username,@intaccesslevel as accesslevel,@strName as name

		END ELSE BEGIN
		
			SET NOCOUNT OFF;
		
			SELECT 1 as errorCode,'Invalid Session Key' as errorMessage
			
		END

	END ELSE IF @strSessionKey<>'' AND (@intAccountNumber=0 OR  @intAccountNumber IS NULL) AND @strPassword='' BEGIN

		IF @strUserAgent='' BEGIN

			--just check the sesion key
			SELECT @intAccountNumber=MIN(employeeid) FROM tblEmployee WHERE sessionkey=@strSessionKey

		END ELSE BEGIN --security mode
		
			--make sure the session is less than 30 mins old and the user agent matches
			SELECT @intAccountNumber=MIN(employeeid) FROM tblEmployee WHERE sessionkey=@strSessionKey AND DATEDIFF(n,lastactivity,GETDATE())<30 AND useragent=@strUserAgent--- AND ipaddress=@strIPAddress

			----create a new session key
			SET @strCodeCharacters='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

			WHILE @strSessionKey='' OR @userID2 IS NOT NULL BEGIN
				SET @index=0
				WHILE @index<48 BEGIN
					SET @strSessionKey=@strSessionKey+SUBSTRING(@strCodeCharacters,CAST(RAND()*LEN(@strCodeCharacters) AS tinyint)+1,1)
					SET @index=@index+1
				END
				SET @strSessionKey='n'+@strSessionKey+'n'
			
				SELECT @userID2=MIN(employeeid) FROM tblEmployee WHERE CAST(sessionkey AS varbinary(50))=CAST(@strSessionKey AS varbinary(50))
			END
			
			--rotate the session key
			UPDATE tblEmployee
			SET sessionkey=@strSessionKey
			WHERE employeeid=@intAccountNumber
		
		END

		IF @intAccountNumber IS NOT NULL BEGIN

			SELECT @intaccesslevel=accesslevel,@strName=name FROM tblEmployee WHERE employeeid=@intAccountNumber

			UPDATE tblEmployee
			SET lastactivity=GETDATE()
			WHERE employeeid=@intAccountNumber 

			SET NOCOUNT OFF;
			
			SELECT 0 as errorCode,'' as errorMessage

			SELECT @strSessionKey as sessionkey,@strUsername as username,@intaccesslevel as accesslevel,@strName as name

		END ELSE BEGIN

			SET NOCOUNT OFF;
		
			SELECT 1 as errorCode,'Invalid Session Key' as errorMessage
			
		END


	END ELSE BEGIN

		SET NOCOUNT OFF;
	
		SELECT 1 as errorCode,'Invalid Session Key' as errorMessage

	END

END

GO

CREATE PROCEDURE [dbo].[sp_searchaccounts] 
	@strSessionKey nvarchar(50),
	@strAccountName nvarchar(256),
	@intAccountNumber bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @intAccountID bigint
	SELECT @intAccountID=MIN(employeeid) FROM tblEmployee WHERE sessionkey=@strSessionKey

	IF @intAccountID IS NOT NULL BEGIN

		SET NOCOUNT OFF;

		SELECT name,accountid
		FROM tblAccount 
		WHERE ((name LIKE '%' + @strAccountName + '%' AND @strAccountName<>'') OR accountid=@intAccountNumber AND accountdeleted=0)
		
	END
	
END
GO

CREATE PROCEDURE [dbo].[sp_listaccounts] 
	@strSessionKey nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @intAccountID bigint
	SELECT @intAccountID=MIN(employeeid) FROM tblEmployee WHERE sessionkey=@strSessionKey

	IF @intAccountID IS NOT NULL BEGIN

		SET NOCOUNT OFF;

		SELECT name,accountid
		FROM tblAccount 
		WHERE accountdeleted=0
		
	END
	
END
GO

CREATE PROCEDURE sp_deleteaccount
	@strSessionKey nvarchar(50),
	@intAccountID bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @intEmployeeID bigint
	SELECT @intEmployeeID=MIN(employeeid) FROM tblEmployee WHERE sessionkey=@strSessionKey

	IF @intEmployeeID IS NOT NULL BEGIN
		UPDATE tblAccount 
		SET accountdeleted=1
		WHERE accountID=@intAccountID
	END
END
GO
CREATE PROCEDURE [dbo].[sp_getaccount]
	@strSessionKey nvarchar(50),
	@intAccountID bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @intEmployeeID bigint
	SELECT @intEmployeeID=MIN(employeeid) FROM tblEmployee WHERE sessionkey=@strSessionKey

	IF @intEmployeeID IS NOT NULL BEGIN
		SELECT name as accountname,email as accountemail,accountid FROM tblAccount WHERE accountid=@intAccountID
	END
END
GO

CREATE PROCEDURE [dbo].[sp_updateaccount]
	@strSessionKey nvarchar(50),
	@intAccountID bigint,
	@strName nvarchar(256),
	@strEmail nvarchar(256)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @intEmployeeID bigint
	SELECT @intEmployeeID=MIN(employeeid) FROM tblEmployee WHERE sessionkey=@strSessionKey

	IF @intEmployeeID IS NOT NULL BEGIN
		UPDATE tblAccount 
		SET name=@strName,email=@strEmail
		WHERE accountID=@intAccountID
	END
END
GO
