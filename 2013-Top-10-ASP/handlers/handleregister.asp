<%

'##################################################
'##### account registration handler - executes after the registration form has been submitted #####
'#################################################

dim accountnumber

if request.form("submitted")="1" then

	dim recordset

	ocom.commandtext = "sp_registeraccount '" & SQLStr(request.form("email")) & "','" & SQLStr(request.form("password")) & "','" & SQLStr(request.form("name")) & "','" & SQLStr(request.form("passwordreminder")) & "';"
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

else

	accountnumber=""

end if

%>