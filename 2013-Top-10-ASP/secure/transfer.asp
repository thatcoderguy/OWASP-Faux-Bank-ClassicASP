<!-- #include file="../functions.asp" -->
<%

	'##################################################
	'##### transfer page - for a customer to transfer money from one account to another #####
	'##################################################

	dim ousersession,recordset,link,transactionok

	transactionok=false

	''establish global connection to the database
	connecttodatabase()

	''validate user session with session token (returns user object with account details)
	set recordset = querydatabase("sp_authenticate 0,'','" & SQLStr(request.cookies("sessionkey")) & "';")
	set ousersession = validateSession(recordset)

	''if a user session was not returned
	if ousersession is nothing then

		disconnectfromdatabase()
		response.redirect "/login?error=invalid"

	end if

	disposequery(recordset)

	''if the transaction for has been submitted
	if request.form("submitted")="1" then

		''try to create a transaction
		set recordset = querydatabase("sp_createtransaction " & SqlNum(request.form("accountto")) & "," & SqlNum(request.form("amount"))& ",'" & SQLStr(request.cookies("sessionkey")) & "';")

		''no recordsets returned
		if recordset.eof then

			discountfromdatabase()
			response.redirect "transfer.asp?error=invalidaccount"

		else

			''transaction failed when checking for a valid account
			if recordset("message")="invalidaccount" then

				disposequery(recordset)
				disconnectfromdatabase()

				response.redirect "/Transfer?error=invalidaccount"

			''transaction succeeded
			else

				transactionok=true
				disposequery(recordset)

			end if

		end if

		disconnectfromdatabase()

	end if

%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>Home Page - My ASP.NET MVC Application</title>
        <link href="/favicon.ico" rel="shortcut icon" type="image/x-icon" />
        <meta name="viewport" content="width=device-width" />
        <link href="/Content/site.css" rel="stylesheet"/>

        <script src="/Scripts/modernizr-2.6.2.js"></script>

    </head>
    <body>
        <header>
            <div class="content-wrapper">
                <div class="float-left">
                    <p class="site-title"><a href="/"><img src="/images/logo.png" /></a></p>
                </div>
                <div class="float-right">
                    <section id="login">
                    	<ul>
                    		<li><a href="/transfer">Switch to insecure mode</a></li>
                    	</ul>
                    </section>
                    <nav>
                        <ul id="menu">
                            <li><a href="/">Home</a></li>
                            <li><a href="/About">About</a></li>
                            <li><a href="/Contact">Contact</a></li>
                            <li><a href="/Account">Account</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </header>
        <div id="body">

    <section class="featured">
        <div class="content-wrapper">
            <hgroup class="title">
                <h1>Welcome to Faux Bank, <%= ousersession.username %> .</h1><br />
                <h3>Statement for account number: <strong><%= ousersession.accountnumber %></strong></h3>

            </hgroup><br />

				<%
					''if the transaction succeeded, then display the succeeded message.
					if transactionok then
				%>

					<p>Thank you</p>
					<p>Your transfer of &pound;<%= request.form("amount") %> to account <%= request.form("accountto") %> <br />has been completed</p>

					<p><a href="/Account">Back to my account</p>

				<%
					''otherwise display the form again with a failed message
					else
				%>

					<form action="/Transfer" method="post" id="transferform">
					<input type="hidden" name="submitted" value="1" />
					<table>
					<tr>
					<td>Transfer to Account:</td><td><input type="text" name="accountto" value="" />
					</tr>
					<tr>
					<td>Amount:</td><td>&pound;<input type="text" name="amount" value="0" /></td>
					</tr>
					<tr>
					<td colspan="2"><input style="float: right;" type="submit" name="submit" value="Transfer" /></td>
					</tr>
					</table>
					</form>

				<%
					end if
					if request.querystring("error")<>"" then
				%>

					<p><strong>Sorry, but the account number was invalid</strong></p>

				<%
					end if
				%>

        </div>
    </section>

            <section class="content-wrapper main-content clear-fix">

            </section>
        </div>
        <footer>
            <div class="content-wrapper">
                <div class="float-left">
                    <p>&copy; 2014 - That Coder Guy <a href="http://www.thatcoderguy.co.uk">www.thatcoderguy.co.uk</a></p>
                </div>
            </div>
        </footer>

        <script src="/Scripts/jquery-1.8.2.js"></script>

</body>
</html>
