<%

	if request.querystring("action")="" then

		ocom.commandtext = "sp_listaccounts '" & SQLStr(request.cookies("cashiersessionkey")) & "';"
		set recordset = ocom.execute()

		''no recordsets returned
		if recordset.eof then

			set recordset = nothing

			response.write "<p>-- No Accounts Found --</p>"

		else

			response.write "<h2>Search Results</h2><table>"

			do while not recordset.eof

				response.write "<tr><td>" & recordset("accountid") & " - " & SanitiseInput(recordset("name")) & "</td>"

				if ousersession.accesslevel > 10 then
					response.write "<td><a href=""/accountadmin?account=" & recordset("accountid") & "&action=edit"">Edit Account</a></td><td><a href=""/accountadmin?account=" & recordset("accountid") & "&action=delete"">Delete Account</a></td></tr>"
				else
					response.write "</tr>"
				end if

				recordset.movenext

			loop

			response.write "</table>"

			recordset.close
			set recordset = nothing

		end if

	else

		select case request.querystring("action")
		case "delete"

			response.write "<p>Account <strong>" & request.querystring("account") & "</strong> has now been deleted.</p>"

		case "updated"

			response.write "<p>Account <strong>" & request.querystring("account") & "</strong> has now been updated.</p>"

		case "edit"

			if GetMode="normal" then

				ocom.commandtext = "sp_getaccount '" & SQLStr(request.cookies("cashiersessionkey")) & "'," & SQLNum(request.querystring("account")) & ";"
				set recordset = ocom.execute()

			else

				if ousersession.accesslevel>10 then

					ocom.commandtext = "sp_getaccount '" & SQLStr(request.cookies("cashiersessionkey")) & "'," & SQLNum(request.querystring("account")) & ";"
					set recordset = ocom.execute()

				else

					response.redirect "/cashier?error=accessdenied"

				end if

			end if

			if not recordset.eof then

		%>
			<form action="/accountadmin?action=updated" method="post" id="transferform">
			<input type="hidden" name="account" value="<%= request.querystring("account") %>" />
			<input type="hidden" name="token" value="<%= token %>" />
			<table>
			<tr>
			<td>Name:</td><td><input type="text" name="name" value="<%= recordset("accountname") %>" /></td>
			</tr>
			<tr>
			<td>Email Address:</td><td><input type="email" name="email" value="<%= recordset("accountemail") %>" /></td>
			</tr>
			<tr>
			<td colspan="2"><input style="float: right;" type="submit" name="submit" value="Update Account" /></td>
			</tr>
			</table>
			</form>
		<%

				recordset.close

			end if

			set recordset=nothing

		end select

	end if

%>