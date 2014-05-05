USE [CSRF]
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
	[passwordhash] [nvarchar](500) NOT NULL,
	[securepasswordhash] [nvarchar](500) NOT NULL,
	[salt] [nvarchar](50) NOT NULL,
	[passwordreminder] [nvarchar](4000) NOT NULL,
	[sessionkey] [nvarchar](50) NULL,
	[balance] [decimal](18, 5) NOT NULL,
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



CREATE PROCEDURE sp_registeraccount
	@strEmail nvarchar(256),
	@strPassword nvarchar(500),
	@strPasswordReminder nvarchar(4000),
	@strName nvarchar(256)
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
	@intToAccountID bigint,
	@intAmount decimal(18,5),
	@strSessionKey nvarchar(50)
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