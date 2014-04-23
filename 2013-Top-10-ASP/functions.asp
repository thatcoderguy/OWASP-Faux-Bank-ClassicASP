<%
''global vars for database queries, so 1 connection can be used throughout a page load
dim ocon,ocom

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
		if isNumeric(intTemp) then
			SQLNum=cstr(intTemp)
		else
			SQLNum="0"
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

function GetConnectionString()

	'##################################################
	'##### read the web.config file to get the connection string #####
	'##################################################

	dim xmlDoc,xmlappSettings,xmladd

	set xmlDoc=server.CreateObject("Microsoft.XMLDOM")
	set xmlConfig=server.CreateObject("Microsoft.XMLDOM")
	set xmlConStrings=server.CreateObject("Microsoft.XMLDOM")
	set xmladd=server.CreateObject("Microsoft.XMLDOM")

	GetConnectionString=""

	xmlDoc.async="false"
	xmlDoc.load(server.MapPath("web.config"))

	set xmlConfig = xmldoc.GetElementsByTagName("connectionStrings").Item(0)
	set xmladd = xmlConfig.GetElementsByTagName("add")

	for each x in xmladd

		'Check for the Atrribute Value
		if x.getAttribute("name") ="DefaultConnection" then
			GetConnectionString = x.getAttribute("connectionString")
			exit for
		end if

	next

	set xmladd=nothing
	set xmlappSettings=nothing
	set xmlDoc=nothing


end function

sub connecttodatabase()

	'##################################################
	'##### connect to the database #####
	'##################################################

	set ocon=server.createobject("adodb.connection")
	ocon.open GetConnectionString()

end sub

sub disconnectfromdatabase()

	ocon.close
	set ocon = nothing

end sub

function querydatabase(query)

	'##################################################
	'##### return a recordset from the query #####
	'##################################################

	dim ors

	set ocom=server.createobject("adodb.command")
	set ors=server.createobject("adodb.recordset")

	ocom.activeconnection=ocon
	ocom.commandtext=query
	set ors=ocom.execute()

	if ors.eof then

		set ocom = nothing
		set ors = nothing

		set querydatabase = nothing

	else

		set querydatabase = ors

	end if

end function

sub disposequery(recordset)

	'##################################################
	'##### dispose of the recordset returned from the function above #####
	'##################################################

	if recordset.State=1 then recordset.close
	set recordset = nothing
	set ocom = nothing

end sub

function validateSession(recordset)

	'##################################################
	'##### validate a user session - ensure the user is still logged in and return a user object #####
	'##################################################

	dim ousersession

	if not recordset is nothing then

		if recordset.eof then

			set validateSession = nothing

		else

			set ousersession = new usersession

			ousersession.username = recordset("name")
			ousersession.accountnumber = recordset("account")
			ousersession.balance = recordset("balance")

			disposequery(recordset)

			set validateSession = ousersession

		end if

	else


		set validateSession = nothing

	end if

end function


'##################################################
'##### user session class #####
'##################################################
class usersession

	public username
	public accountnumber
	public balance

end class

%>