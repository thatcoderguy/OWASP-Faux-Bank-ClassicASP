<%

'##################################################
'##### account login handler - executes after the login form has been submitted #####
'#################################################

if request.form("submitted")="1" then

	dim recordset

	ocom.commandtext = "sp_authenticate " & cstr(sqlnum(request.form("number"))) & ",'" & SQLStr(request.form("password")) & "','';"
	set recordset = ocom.execute()

	if not recordset is nothing then

		''recordset returned
		if not recordset.eof then

			''if the username/password was incorrect
			if recordset("sessionkey")="SESSIONKEYINVALID" then

				recordset.close
				set recordset = nothing

				''if not logged in
				response.redirect "/login?error=invalid"

			''authenticated
			else

				''store sessionkey in a cookie
				response.cookies("sessionkey")=recordset("sessionkey")

				recordset.close
				set recordset = nothing

				''if logged in
				response.redirect "/Account"

			end if

		else

			set recordset = nothing

			''if not logged in
			response.redirect "/Login?error=invalid"

		end if

	else

		set recordset = nothing

		''if not logged in
		response.redirect "/Login?error=invalid"

	end if

end if

%>