<%

sub DisplayLoginError()

	if request.querystring("error")<>"" then

			response.write "<p><strong>Sorry, but the account number or password was invalid</strong></p>"

	end if

end sub


sub DisplayTransferError()

	if request.querystring("error")<>"" then

			response.write "<p><strong>Sorry, but the account number was invalid</strong></p>"

	end if

end sub

%>