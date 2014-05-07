<%

'##################################################
'##### SHA512 hashing functions - 			  #####
'##### Classic ASP cant do these by default   #####
'##### so we have to "patch into" .NET        #####
'##################################################
Function HashString(strValue)
	Dim aBytes
	Dim aBinResult

	Set oEncoding = CreateObject("System.Text.UTF8Encoding")
	Set oCrypt = Server.CreateObject("System.Security.Cryptography.SHA512Managed")

	aBytes = oEncoding.GetBytes_4(strValue)
	aBinResult = oCrypt.ComputeHash_2((aBytes))

	HashString = BinToHexString(aBinResult)

End Function

Function BinToHexString(rabyt)
	Dim xml: Set xml = CreateObject("MSXML2.DOMDocument.3.0")

	xml.LoadXml "<root />"
	xml.documentElement.dataType = "bin.hex"
	xml.documentElement.nodeTypedValue = rabyt

	BinToHexString = Replace(xml.documentElement.Text, VbLf, "")

End Function


%>