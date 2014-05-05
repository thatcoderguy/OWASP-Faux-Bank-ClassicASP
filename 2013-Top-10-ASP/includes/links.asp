<%

function createaccountlink()

	'##################################################
	'##### create the login/account link #####
	'##################################################

	if GetSessionKey()<>"" then

		createaccountlink="<a href=""/Account"">Account</a>"

	else

		createaccountlink="<a href=""/Login"">Login</a>"

	end if

end function

function createsecurelink()

	'##################################################
	'##### create the security mode link #####
	'##################################################

	if GetMode()="normal" then

		createsecurelink="<a href=""?setmode=secure"">Switch to secure mode</a>"

	else

		createsecurelink="<a href=""?setmode=normal"">Switch to normal mode</a>"

	end if

end function

%>