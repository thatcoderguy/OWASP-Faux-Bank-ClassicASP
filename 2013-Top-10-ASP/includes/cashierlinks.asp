<%

sub displayaccountlink()

	'##################################################
	'##### create the login/account link #####
	'##################################################

	if request.querystring("session")<>"" then

		response.write "<a href=""/Cashier?session=" & request.querystring("session") & """>Account</a>"

	else

		response.write "<a href=""/Login?session=" & request.querystring("session") & """>Login</a>"

	end if

end sub

sub displaysecurelink()

	'##################################################
	'##### create the security mode link #####
	'##################################################

	if GetMode()="normal" then

		response.write "<a href=""?setmode=secure&session=" & request.querystring("session") & """>Switch to secure mode</a>"

	else

		response.write "<a href=""?setmode=normal&session=" & request.querystring("session") & """>Switch to normal mode</a>"

	end if

end sub

%>