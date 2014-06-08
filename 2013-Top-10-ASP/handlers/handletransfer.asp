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

		'####################################################################
		'##### this is how to prevent CSRF   							#####
		'##### create a unique token   									#####
		'##### store it in a cookie and submit it in the form  		 	#####
		'##### then in the handler - verify that the two values match   #####
		'##### store it in a cookie and submit it in the form   		#####
		'##### "hackers" cant read or modify cookie data unless it   	#####
		'##### belongs to the same domain name as a site that has   	#####
		'##### been compromised   										#####
		'####################################################################

		if not request.cookies("token") is nothing then

			if request.cookies("token")=request.form("token") then

				ocom.commandtext = "sp_createtransaction '" & SQLStr(request.cookies("sessionkey")) & "'," & SqlNum(request.form("accountto")) & "," & SqlNum(request.form("amount"))& ";"
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


			else

				response.redirect "/Transfer?error=invalidtoken"


			end if

		else

			response.redirect "/Transfer?error=invalidtoken"

		end if


	'##################################################
	'##### if the site is in normal mode, then handle transfers this way #####
	'##################################################
	else

		ocom.commandtext = "sp_createtransaction '" & SQLStr(request.cookies("sessionkey")) & "'," & SqlNum(request.form("accountto")) & "," & SqlNum(request.form("amount"))& ";"
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