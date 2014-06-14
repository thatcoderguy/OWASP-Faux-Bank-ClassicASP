<%

sub displayaccountlink()

	'##################################################
	'##### create the login/account link #####
	'##################################################

	if GetCashierSessionKey()<>"" then

		response.write "<a href=""/Cashier"">Cashier</a>"

	else

		response.write "<a href=""/Cashierlogin"">Login</a>"

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

sub displaysuperadminlink()

	if cint(ousersession.accesslevel) > 5 then

		response.write "<li><a href=""/accountadmin"">Account Admin</a></li>"

    end if

end sub

%>