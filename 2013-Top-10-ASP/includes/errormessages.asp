<%

sub DisplayLoginError()

	if request.querystring("error")<>"" then

			response.write "<p><strong>Sorry, but the account number or password was invalid</strong></p>"

	end if

end sub

sub DisplayCashierLoginError()

	if request.querystring("error")="Username or password incorrect" then

		response.write "<p><strong>Sorry, but the username or password was invalid.</strong></p>"

	else

		response.write "<p><strong>You have been logged out.</strong></p>"

	end if

end sub


sub DisplayTransferError()

	if request.querystring("error")="invalidaccount" then

			response.write "<p><strong>Sorry, but the account number was invalid</strong></p>"

	elseif request.querystring("error")="invalidtoken" then

			response.write "<p><strong>Sorry, but the token submitted is invalid</strong></p>"

	end if

end sub

%>