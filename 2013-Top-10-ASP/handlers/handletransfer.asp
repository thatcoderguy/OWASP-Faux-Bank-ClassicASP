<%

dim transactioncomplete
transactioncomplete=false

''if the transaction for has been submitted
if request.form("submitted")="1" then

	dim recordset

	'##################################################
	'##### if the site is in secure mode, then handle transfers this way #####
	'##################################################
	if GetMode()="secure" then


	'##################################################
	'##### if the site is in normal mode, then handle transfers this way #####
	'##################################################
	else

		ocom.commandtext = "sp_createtransaction " & SqlNum(request.form("accountto")) & "," & SqlNum(request.form("amount"))& ",'" & SQLStr(request.cookies("sessionkey")) & "';"
		set recordset = ocom.execute()

		''no recordsets returned
		if recordset.eof then

			set recordset = nothing

			response.redirect "/Transfer?error=invalidaccount"

		else

			''transaction failed when checking for a valid account
			if recordset("message")="invalidaccount" then

				recordset.close
				set recordset = nothing

				response.redirect "/Transfer?error=invalidaccount"

			''transaction succeeded
			else

				recordset.close
				set recordset = nothing

				transactioncomplete=true

			end if

		end if

	end if

end if
%>