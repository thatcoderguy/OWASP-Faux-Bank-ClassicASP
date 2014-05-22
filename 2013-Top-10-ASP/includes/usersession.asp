<%

'##################################################
'##### validate a user session - ensure the user is still logged in and return a user object #####
'##################################################
function validateSession()

	dim ouser,recordset

	ocom.commandtext = "sp_authenticate 0,'','" & sqlstr(GetSessionKey()) & "';"
	set recordset = ocom.execute()

	if recordset.eof then

		set recordset = nothing
		set validateSession = nothing

	else

		''the first recordset contains the error code and error message
		''0=ok, 1=error
		if recordset("errorCode")="0" then

			''move to the next record set
			set recordset = recordset.nextrecordset

			set ouser = new usersession

			''create a user object and populate with userful user information
			ouser.username = recordset("name")
			ouser.accountnumber = recordset("account")
			ouser.balance = recordset("balance")

			recordset.close
			set recordset = nothing

			set validateSession = ouser

		else

			recordset.close
			set recordset = nothing
			set validateSession = nothing

		end if

	end if

end function


'##################################################
'##### user session class #####
'##################################################
class usersession

	public username
	public accountnumber
	public balance

end class

%>