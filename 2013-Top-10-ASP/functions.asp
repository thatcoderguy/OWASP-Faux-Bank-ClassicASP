

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

function GetConnectionString()

	'##################################################
	'##### read the web.config file to get the connection string #####
	'##################################################

dim xmlDoc,xmlappSettings,xmladd

set xmlDoc=server.CreateObject("Microsoft.XMLDOM")
set xmlappSettings=server.CreateObject("Microsoft.XMLDOM")
set xmladd=server.CreateObject("Microsoft.XMLDOM")

xmlDoc.async="false"
xmlDoc.load(server.MapPath("web.config"))

set xmlappSettings = xmldoc.GetElementsByTagName("appSettings").Item(0)
set xmladd = xmlappSettings.GetElementsByTagName("add")

for each x in xmladd

	'Check for the Atrribute Value
	if  x.getAttribute("key") ="DefaultConnection" then
		ReadWebConfig = x.getAttribute("value")
		exit for
	end if

next

end function