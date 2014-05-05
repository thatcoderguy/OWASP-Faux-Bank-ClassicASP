<%

	'##################################################
	'##### list all transactions in account #####
	'##################################################

	dim recordset,pagenumber


	''handle pagination
	if isnumeric(request.querystring("page")) then

		if cint(request.querystring("page"))>1 then

			pagenumber = cint(request.querystring("page"))

		else

			pagenumber = 1

		end if

	else

		pagenumber = 1

	end if



	ocom.commandtext = "sp_gettransactions '" & GetSessionKey() & "'," & cstr(pagenumber) & ";"
	set recordset = ocom.execute()

	'''print out account's transactions
	if recordset.eof then

		response.write "<tr><td colspan=""4"">-- No Transactions--</td></tr>"

	else

		while not recordset.eof

			response.write "<tr><td>" & recordset("transactionid") & "</td><td>" & recordset("fromname") & " (" & recordset("fromaccount") & ")</td><td>" & recordset("toname") & " (" & recordset("toaccount") & ")</td><td>&pound;" & recordset("amount") &"</tr>"

			recordset.movenext

		wend

	end if

%>