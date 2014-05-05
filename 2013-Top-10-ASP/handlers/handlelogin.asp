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

			''the first recordset contains the error code and error message
			''0=ok, 1=error
			if recordset("errorCode")<>"0" then

				recordset.close
				set recordset = nothing

				''if not logged in
				response.redirect "/login?error=invalid"

			''authenticated
			else

				''move to the next record set
				set recordset = recordset.nextrecordset

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