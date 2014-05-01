<%

''handle set security mode
if request.querystring("setmode")="secure" then

	response.cookies("securitymode")="secure"

elseif request.querystring("setmode")="normal" then

	response.cookies("securitymode")="normal"

end if

function createaccountlink()

	'##################################################
	'##### create the login/account link #####
	'##################################################

	''if we have a sessionkey cookie
	if not request.cookies("sessionkey") is nothing then

		''and the sessionkey is valid, then display an account link instead of login link
		if request.cookies("sessionkey")<>"SESSIONKEYINVALID" and request.cookies("sessionkey")<>"" then

			createaccountlink="<a href=""/Account"">Account</a>"

		else

			createaccountlink="<a href=""/Login"">Login</a>"

		end if

	''we dont have a sessionkey cookie
	else

		createaccountlink="<a href=""/Login"">Login</a>"

	end if

end function

function createsecurelink()

	'##################################################
	'##### create the security mode link #####
	'##################################################

	if getmode()="normal" then

		createsecurelink="<a href=""?setmode=secure"">Switch to secure mode</a>"

	else

		createsecurelink="<a href=""?setmode=normal"">Switch to normal mode</a>"

	end if

end function

%>