<!-- #include file="../functions.asp" -->
<%

	'##################################################
	'##### account page - displays transactions for the account logged into #####
	'##################################################

	dim ousersession,recordset

	connecttodatabase()

	''validate user session with session token (returns user object with account details)
	set recordset = querydatabase("sp_authenticate 0,'','" & SQLStr(request.cookies("sessionkey")) & "';")
	set ousersession = validateSession(recordset)

	if ousersession is nothing then

		disconnectfromdatabase()
		response.redirect "/login?error=invalid"

	end if

	disposequery(recordset)

	''retrieve account's transactions - gets used further down
	set recordset = querydatabase("sp_gettransactions '" & SQLStr(request.cookies("sessionkey")) & "';")

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
                    		<li><a href="/account">Switch to insecure mode</a></li>
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
					<h3>Your account balance is: &pound;<%= ousersession.balance %></h3>
				</hgroup><br />

					<p><a href="/transfer">Transfer money to another account</a></p><br />

					<table id="transactions">
					<tr>
					<th>Transaction Ref</th><th>Account From</th><th>Account To</th><th>Amount</th>
					</tr>

					<%

						'''print out account's transactions
						if recordset.eof then

							response.write "<tr><td colspan=""4"">-- No Transactions--</td></tr>"

							disconnectfromdatabase()

						else

							while not recordset.eof

								response.write "<tr><td>" & recordset("transactionid") & "</td><td>" & recordset("fromname") & " (" & recordset("fromaccount") & ")</td><td>" & recordset("toname") & " (" & recordset("toaccount") & ")</td><td>&pound;" & recordset("amount") &"</tr>"

								recordset.movenext

							wend

							disposequery(recordset)
							disconnectfromdatabase()

						end if

					%>
					</table>

			</div>
		</section>

		<section class="content-wrapper main-content clear-fix">

		<ol class="round">

		</ol>

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


