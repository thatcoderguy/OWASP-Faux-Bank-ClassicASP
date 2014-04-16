<%

function SQLStr(strTemp)
	'##################################################
	'##### prevents sql injection and some sql errors #####
	'##################################################

	if isnull(strTemp) then
		SQLStr=""
	else
		SQLStr=replace(strTemp,"'","''")
	end if
end function

function SQLNum(intTemp)
	'##################################################
	'##### prevents sql injection and some sql errors #####
	'##################################################

	if isnull(intTemp) then
		SQLNum="null"
	else
		intTemp=trim(intTemp)
		if isNumber(intTemp) then
			SQLNum=intTemp
		else
			SQLNum=0
		end if
	end if
end function

function SQLBit(intTemp)
	'##################################################
	'##### prevents sql injection and some sql errors #####
	'##################################################

	if isnull(intTemp) then intTemp=""
	if not cstr(trim(intTemp))="0" and not lcase(cstr(trim(intTemp)))="false" and not trim(intTemp)="" then
		SQLBit=1
	else
		SQLBit=0
	end if
end function


dim ocon,ocom,ors

	SET ocon=server.createobject("ADODB.connection")
	SET ocom=server.createobject("ADODB.command")
	SET ors=server.createobject("ADODB.recordset")

	ocon.open "Provider=sqloledb;Data Source=WEBWIZARD\SQLEXPRESS;Initial Catalog=CSRF;Integrated Security=SSPI"
	ocom.activeconnection=ocon
	ocom.commandtext="sp_authenticate 0,'','" & SQLStr(request.cookies("sessionkey")) & "';"

	SET ors=ocom.execute()

	if  ors.eof then

		ocon.close
		response.redirect "login.asp?error=invalid"

	end if


if request.form("submitted")="1" then

	ors.close

	ocom.commandtext="sp_createtransaction " & SqlNum(request.form("accountto")) & "," & SqlNum(request.form("amount"))& ",'" & SQLStr(request.cookies("sessionkey")) & "';"
	SET ors=ocom.execute()

	if ors.eof then

		ocon.close
		response.redirect "transfer.asp?error=invalidaccount"

	else

		if ors("message")="invalidaccount" then

			ors.close
			ocon.close
			response.redirect "transfer.asp?error=invalidaccount"

		else

			ors.close
			ocon.close

		%>

		<p>Thank you</P>
		<p>Your transfer of £<%= request.form("amount") %> to account <%= request.form("accountto") %> <br />
		has been completed</p>

		<p><a href="account.asp">Back to my account</p>

		<%

		end if


	end if

else

ocon.close

%>
<html>
<body>

<h1>Welcome to</h1><br /><br />

<p>Your account number: <%= accountnumber %></p><br /><br />

<h2>Transfer money</h2>

<form action="transfer.asp" method="post" id="transferform">
<input type="hidden" name="submitted" value="1" />
<table>
<tr>
<td>Transfer to account</td><td><input type="text" name="accountto" value="" />
</tr>
<tr>
<td>Amount:</td><td>£<input type="text" name="amount" value="0" /></td>
</tr>
<tr>
<td colspan="2"><input type="submit" name="submit" value="Transfer" /></td>
</tr>
</form>

<% if request.querystring("error")<>"" then %>

<strong>Sorry, but that the account number: <%= request.form("accountto") %>  was not found</strong>


<%

end if

end if %>