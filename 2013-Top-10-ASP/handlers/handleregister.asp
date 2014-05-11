<!-- #include virtual="/includes/sha512.asp" -->
<%

'##################################################
'##### account registration handler - executes after the registration form has been submitted #####
'#################################################

dim accountnumber

if request.form("submitted")="1" then


	dim recordset, passwordhash, sanitizedname

	'##################################################
	'##### if the site is in secure mode, then handle registrations this way #####
	'##################################################
	if GetMode()="secure" then

		''create a SHA512 hash of the password (include the salt)
		passwordhash = HashString(request.form("password") & globalsalt)

		sanitizedname = SanitiseInput(request.form("name"))

		ocom.commandtext = "sp_registeraccount '" & SQLStr(request.form("email")) & "','" & SQLStr(passwordhash) & "','" & SQLStr(sanitizedname) & "','" & SQLStr(request.form("passwordreminder")) & "';"
		set recordset = ocom.execute()

		if not recordset is nothing then

			''recordset was returned
			if not recordset.eof then

				''get new account number that was created
				accountnumber = recordset("accountnumber")

				recordset.close
				set recordset = nothing

			''recordset not returned
			else

				accountnumber=""
				set recordset = nothing

			end if

		else

			accountnumber=""

		end if

	'##################################################
	'##### if the site is in normal mode, then handle registrations this way #####
	'##################################################
	else

		''create a SHA512 hash of the password (include the salt)
		passwordhash = HashString(request.form("password") & globalsalt)

		ocom.commandtext = "sp_registeraccount '" & SQLStr(request.form("email")) & "','" & SQLStr(passwordhash) & "','" & SQLStr(request.form("name")) & "','" & SQLStr(request.form("passwordreminder")) & "';"
		set recordset = ocom.execute()

		if not recordset is nothing then

			''recordset was returned
			if not recordset.eof then

				''get new account number that was created
				accountnumber = recordset("accountnumber")

				recordset.close
				set recordset = nothing

			''recordset not returned
			else

				accountnumber=""
				set recordset = nothing

			end if

		else

			accountnumber=""

		end if

	end if

else

	accountnumber=""

end if

%>