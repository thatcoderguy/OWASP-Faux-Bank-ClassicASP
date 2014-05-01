<%

dim osession

function validateSession(recordset)

	'##################################################
	'##### validate a user session - ensure the user is still logged in and return a user object #####
	'##################################################

	dim ousersession

	if not recordset is nothing then

		if recordset.eof then

			set validateSession = nothing

		else

			set ousersession = new usersession

			ousersession.username = recordset("name")
			ousersession.accountnumber = recordset("account")
			ousersession.balance = recordset("balance")

			disposequery(recordset)

			set validateSession = ousersession

		end if

	else


		set validateSession = nothing

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