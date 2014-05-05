<%

dim ousersession

function validateSession()

	dim ouser,recordset

	ocom.commandtext = "sp_authenticate 0,'','" & GetSessionKey() & "';"
	set recordset = ocom.execute()

	'##################################################
	'##### validate a user session - ensure the user is still logged in and return a user object #####
	'##################################################

	if recordset.eof then

		set recordset = nothing
		set validateSession = nothing

	else

		set ouser = new usersession

		''create a user object and populate with userful user information
		ouser.username = recordset("name")
		ouser.accountnumber = recordset("account")
		ouser.balance = recordset("balance")

		recordset.close
		set recordset = nothing

		set validateSession = ouser

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

'##################################################
'##### if we have a session cookie, then validate the user #####
'##################################################

if GetSessionKey()<>"" then set ousersession = validateSession()

%>