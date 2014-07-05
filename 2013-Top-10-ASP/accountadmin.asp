<!-- #include file="includes/cashierpagesetup.asp" -->
<!-- #include file="handlers/accountadminhandler.asp" -->
<%

	'##################################################
	'##### if there isnt a user session then redirect to the login page #####
	'##################################################
	if GetCashierSessionKey()="" or ousersession is nothing then

		response.redirect "/cashierlogin?error=notloggedin"

	else

		'##################################################
		'##### if the site is in secure mode,         #####
		'##### and we dont have a token cookie        #####
		'##### then we must create one, so that an    #####
		'##### attacker cant do a CSRF by submitting  #####
		'##### a blank token cookie					  #####
		'##################################################
		if GetToken()="" and GetMode="secure" then

			response.cookies("token") = GenerateToken()

		end if

	end if


	''if in secure mode, then check the user's access level
	if GetMode="secure" then

		if cint(ousersession.accesslevel) < 10 then
			response.redirect "/cashier?error=accessdenied"
		end if

	end if

%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>Account Admin - OWASP Faux Bank</title>
        <link href="/favicon.ico" rel="shortcut icon" type="image/x-icon" />
        <meta name="viewport" content="width=device-width" />
        <link href="/Content/site.css" rel="stylesheet"/>

        <script src="/Scripts/modernizr-2.6.2.js"></script>
        <script src="/Scripts/misc.js"></script>

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
                    		<li><% displaysecurelink()%></li>
                    	</ul>
                    </section>
                    <nav>
                        <ul id="menu">
                            <li><a href="/Cashierhome">Home</a></li>
                            <li><% displayaccountlink()%></li>
							<% displaysuperadminlink() %>
                        </ul>
                    </nav>
                </div>
            </div>
        </header>
        <div id="body">

		<section class="featured">
			<div class="content-wrapper">
				<hgroup class="title">
					<h1>Welcome to the cashier menu, <%= ousersession.username%></h1><br />
				</hgroup><br />

				<!-- #include file="pagecontent/accountadmincontent.asp" -->

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


