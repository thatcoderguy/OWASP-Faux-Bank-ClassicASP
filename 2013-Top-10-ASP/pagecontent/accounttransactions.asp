<%

	'##################################################
	'##### list all transactions in account #####
	'##################################################

	dim recordset,pagenumber

	pagenumber=request.querystring("page")
	if pagenumber="" then pagenumber="1"

	if GetMode()="secure" then

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

	end if

	ocom.commandtext = "sp_gettransactions '" & GetSessionKey() & "',1;"
	set recordset = ocom.execute()

	'''print out account's transactions
	if recordset.eof then

		set recordset = nothing

		response.write "<tr><td colspan=""4"">-- No Transactions--</td></tr>"

	else

		'##################################################
		'##### if we are in secure mode #####
		'##################################################
		if GetMode()="secure" then

			while not recordset.eof

				'##################################################
				'##### sanitise the account names (to & from) #####
				'##################################################
				response.write "<tr><td>" & recordset("transactionid") & "</td><td>" & SanitiseInput(recordset("fromname")) & " (" & recordset("fromaccount") & ")</td><td>" & SanitiseInput(recordset("toname")) & " (" & recordset("toaccount") & ")</td><td>&pound;" & recordset("amount") &"</tr>"

				recordset.movenext

			wend

		else

			while not recordset.eof

				response.write "<tr><td>" & recordset("transactionid") & "</td><td>" & recordset("fromname") & " (" & recordset("fromaccount") & ")</td><td>" & recordset("toname") & " (" & recordset("toaccount") & ")</td><td>&pound;" & recordset("amount") &"</tr>"

				recordset.movenext

			wend

		end if

		recordset.close
		set recordset = nothing

	end if

%>