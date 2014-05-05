<%

'##################################################
'##### account registration handler - executes after the registration form has been submitted #####
'#################################################

''if the transaction for has been submitted
if request.form("submitted")="1" then

	dim recordset

	ocom.commandtext = "sp_createtransaction " & SqlNum(request.form("accountto")) & "," & SqlNum(request.form("amount"))& ",'" & SQLStr(request.cookies("sessionkey")) & "';"
	set recordset = ocom.execute()

	''no recordsets returned
	if recordset.eof then

		response.redirect "/Transfer?error=invalidaccount"

	else

		''transaction failed when checking for a valid account
		if recordset("message")="invalidaccount" then

			response.redirect "/Transfer?error=invalidaccount"

		''transaction succeeded
		else

			transactioncomplete=true

		end if

	end if

end if
%>