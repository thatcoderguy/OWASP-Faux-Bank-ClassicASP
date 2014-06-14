<%

	if request.querystring("action")="delete" then

		if GetMode="normal" then

			ocom.commandtext = "sp_deleteaccount '" & SQLStr(request.cookies("cashiersessionkey")) & "'," & SQLNum(request.querystring("account")) & ";"
			ocom.execute()

		else

			if ousersession.accesslevel>10 then

				ocom.commandtext = "sp_deleteaccount '" & SQLStr(request.cookies("cashiersessionkey")) & "'," & SQLNum(request.querystring("account")) & ";"
				ocom.execute()

			else

				response.redirect "/cashier?error=accessdenied"

			end if

		end if

	elseif request.querystring("action")="updated" then

		if GetMode="normal" then

			ocom.commandtext = "sp_updateaccount '" & SQLStr(request.cookies("cashiersessionkey")) & "'," & SQLNum(request.form("account")) & ",'" & SQLStr(request.form("name")) & "','" & SQLStr(request.form("email")) & "';"
			ocom.execute()

		else

			if ousersession.accesslevel>10 then

				ocom.commandtext = "sp_updateaccount '" & SQLStr(request.cookies("cashiersessionkey")) & "'," & SQLNum(request.form("account")) & ",'" & SQLStr(request.form("name")) & "','" & SQLStr(request.form("email")) & "';"
				ocom.execute()

			else

				response.redirect "/cashier?error=accessdenied"

			end if

		end if

	end if

%>