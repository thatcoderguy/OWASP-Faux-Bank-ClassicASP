
dim recordset,osession,link

''if user has submitted form
if request.form("submitted")="1" then

	''connect to db and try to authenticate
	connecttodatabase()
	set recordset = querydatabase("sp_authenticate " & cstr(sqlnum(request.form("number"))) & ",'" & SQLStr(request.form("password")) & "','';")

	if not recordset is nothing then

		''recordset retutned
		if not recordset.eof then

			''if the username/password was incorrect
			if recordset("sessionkey")="SESSIONKEYINVALID" then

				disposequery(recordset)
				disconnectfromdatabase()

				''if not logged in
				response.redirect "/login?error=invalid"

			''authenticated
			else

				''store sessionkey in a cookie
				response.cookies("sessionkey")=recordset("sessionkey")

				disposequery(recordset)
				disconnectfromdatabase()

				''if logged in
				response.redirect "/Account"

			end if

		else

			disconnectfromdatabase()

			''if not logged in
			response.redirect "/Login?error=invalid"

		end if

	else

		disconnectfromdatabase()

		''if not logged in
		response.redirect "/Login?error=invalid"

	end if

end if

''if we have a sessionkey cookie
if not request.cookies("sessionkey") is nothing then

	''if the sessionkey is valid, display account link instead of login link
	if request.cookies("sessionkey")<>"SESSIONKEYINVALID" and request.cookies("sessionkey")<>"" then
		link="<a href=""/Account"">Account</a>"
	else
		link="<a href=""/Login"">Login</a>"
	end if

''we dont have a sessionkey cookie
else

	link="<a href=""/Login"">Login</a>"

end if