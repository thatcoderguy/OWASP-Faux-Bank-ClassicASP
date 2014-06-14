<% if request.querystring("findaccountnumber")<>"" or request.querystring("findaccountname")<>"" then

	'''normal mode - use inline query
	if GetMode()="normal" then

		ocom.commandtext = "SELECT accountid,name FROM tblAccount WHERE (name LIKE '%" & request.querystring("findaccountname") & "%' AND '" & request.querystring("findaccountname") & "'<>'') OR accountid=0" & request.querystring("findaccountnumber") & ";"

	''secure mode - use storedprocedure
	else

		ocom.commandtext = "sp_searchaccounts '" & SQLStr(request.cookies("cashiersessionkey")) & "','" & SQLStr(request.querystring("findaccountname")) & "'," & SQLNum(request.querystring("findaccountnumber")) & ";"

	end if

	set recordset = ocom.execute()

	''no recordsets returned
	if recordset.eof then

		set recordset = nothing

		response.write "<p>-- No Accounts Found --</p>"

	else

		response.write "<h2>Search Results</h2><table>"

		do while not recordset.eof

			response.write "<tr><td>" & recordset("accountid") & " - " & SanitiseInput(recordset("name")) & "</td><td><a href=""/manageaccount?account=" & recordset("accountid") & """>Manage Account</a></td></tr>"

			recordset.movenext

		loop

		response.write "</table>"

		recordset.close
		set recordset = nothing

	end if

elseif request.querystring("account")<>"" then


end if %>