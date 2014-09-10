<!-- #include virtual="/includes/sha512.asp" -->
<%

'##################################################
'##### account login handler - executes after the login form has been submitted #####
'#################################################

if request.form("submitted")="1" then

	dim recordset

	''create a SHA512 hash of the password (include the salt)
	passwordhash = HashString(request.form("password") & globalsalt)

	ocom.commandtext = "sp_authenticate " & cstr(sqlnum(request.form("number"))) & ",'" & SQLStr(passwordhash) & "','';"
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

				''if there is a return url, then we want to redirect to that
				if request.querystring("returnurl") <> "" then

					//if in secure mode, then check that the redirect url is only a local address
					if GetMode()="secure" then

						if isLocalURL(request.querystring("returnurl")) then

							//redirect to the return url
							response.redirect request.querystring("returnurl")

						else

							response.redirect "/Account"

						end if

					else

						//redirect to the return url
						response.redirect request.querystring("returnurl")

					end if

				else

					''if logged in
					response.redirect "/Account"

				end if

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