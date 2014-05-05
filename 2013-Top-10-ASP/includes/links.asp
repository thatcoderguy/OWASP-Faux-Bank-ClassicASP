<%

sub displayaccountlink()

	'##################################################
	'##### create the login/account link #####
	'##################################################

	if GetSessionKey()<>"" then

		response.write "<a href=""/Account"">Account</a>"

	else

		response.write "<a href=""/Login"">Login</a>"

	end if

end sub

sub displaysecurelink()

	'##################################################
	'##### create the security mode link #####
	'##################################################

	if GetMode()="normal" then

		response.write "<a href=""?setmode=secure"">Switch to secure mode</a>"

	else

		response.write "<a href=""?setmode=normal"">Switch to normal mode</a>"

	end if

end sub

%>