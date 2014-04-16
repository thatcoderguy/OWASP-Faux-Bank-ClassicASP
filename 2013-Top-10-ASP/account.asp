<%

dim ocon,ocom,ors

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


''authenticate
''store details

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

	else

		dim username,accountnumber,balance
		username=ors("name")
		accountnumber=ors("account")
		balance=ors("balance")

		ors.close

%>
<html>
<body>

<h1>Welcome to</h1><br /><br />

<p>Hello <%= name %>,<br />Your account number is: <%= accountnumber %></p><br /><br />

<p><a href="transfer.asp">Transfer to another account</a></p>

<h2>Account Statement:</h2><br /><br />

<table>
<tr>
<td>Transaction Ref</td><th>Account From</th><th>Account To</th><th>Amount</th>
</tr>

<%

	ocom.commandtext="sp_gettransactions '" & SQLStr(request.cookies("sessionkey")) & "';"
	set ors=ocom.execute()

	if ors.eof then

		response.write "<tr><td colspan=""4"">-- No Transactions--</td></tr>"
		ocon.close

	else

		while not ors.eof

			response.write "<tr><td>" & rs("transactionid") & "</td><td>" & ors("fromname") & "(" & ors("fromaccount") & ")</td><td>" & ors("toname") & "(" & ors("toaccount") & ")</td><td>£" & ors("amount") &"</tr>"

			ors.movenext

		wend

	ors.close
	ocon.close

	end if


''get transactions

%>

</table>

