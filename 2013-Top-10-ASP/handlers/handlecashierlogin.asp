<!-- #include virtual="/includes/sha512.asp" -->
<%

'##################################################
'##### cashier account login handler - executes after the login form has been submitted #####
'#################################################

if request.form("submitted")="1" then

	dim recordset

	''create a SHA512 hash of the password (include the salt)
	passwordhash = HashString(request.form("password") & globalsalt)

	ocom.commandtext = "sp_employeeauthenticate '" & SQLStr(request.form("username")) & "','" & SQLStr(passwordhash) & "','','" & Request.ServerVariables("HTTP_USER_AGENT") & "','';"
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
				response.redirect "/cashierlogin?error=Username or password incorrect"

			''authenticated
			else

				''move to the next record set
				set recordset = recordset.nextrecordset

				response.cookies("cashiersessionkey")=recordset("sessionkey")

				recordset.close
				set recordset = nothing

				''if logged in
				response.redirect "/cashier"

			end if

		else

			set recordset = nothing

			''if not logged in
			response.redirect "/cashierlogin?error=Username or password incorrect"

		end if

	else

		set recordset = nothing

		''if not logged in
		response.redirect "/cashierlogin?error=Not Logged In"

	end if

end if

%>