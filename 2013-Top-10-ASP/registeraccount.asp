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


if request.form("submitted")="1" then

	SET ocon=server.createobject("ADODB.connection")
	SET ocom=server.createobject("ADODB.command")
	SET ors=server.createobject("ADODB.recordset")

	ocon.open "Provider=sqloledb;Data Source=WEBWIZARD\SQLEXPRESS;Initial Catalog=CSRF;Integrated Security=SSPI"
	ocom.activeconnection=ocon
	ocom.commandtext="sp_registeraccount '" & SQLStr(request.form("email")) & "','" & SQLStr(request.form("password")) & "','" & SQLStr(request.form("name")) & "';"

	set ors=ocom.execute()

	if not ors.eof then

%>


<html>
<body>

<h1>Welcome to</h1><br /><br />

<h2>Account Registered</h2><br /><br />

<p>Thank you for registering, your account number is: <strong><%= ors("accountnumber") %></strong><p>
<p>Make a note of this, as you will need it to log into your account</p>
<br /><br />
<p><a href="login.asp">Log into your account</a></p>

<%

	ors.close
	ocon.close


	end if

else

%>


<html>
<body>

<h1>Welcome to</h1><br /><br />

<h2>Register New Account</h2><br /><br />

<form action="registeraccount.asp" method="post" id="loginform">
<input type="hidden" name="submitted" value="1" />
<table>
<tr>
<td>Name:</td><td><input type="text" name="name" value="" />
</tr>
<tr>
<td>Email Address:</td><td><input type="text" name="email" value="" />
</tr>
<tr>
<td>Password:</td><td><input type="password" name="password" value="" />
</tr>
<tr>
<td colspan="2"><input type="submit" name="submit" value="Register" /></td>
</tr>
<tr>
<td colspan="2"><a href="/registeraccount.asp">Register New Account</a></td>
</tr>
</table>
</form>
</body>
</html>

<%

end if

%>

