<%

dim ocon,ocom,ors

'''login form has been submitted, so try to log in.
if request.form("submitted")="1" then

	SET ocon=server.createobject("ADODB.connection")
	SET ocom=server.createobject("ADODB.command")
	SET ors=server.createobject("ADODB.recordset")

	ocon.open GetConnectionString()
	ocom.activeconnection=ocon
	ocom.commandtext="sp_authenticate " & SQLNum(request.form("number")) & ",'" & SQLStr(request.form("password")) & "','';"

	SET ors=ocom.execute()

	if not ors.eof then

		if ors("sessionkey")="SESSIONKEYINVALID" then

			ors.close
			ocon.close

			''if not logged in
			response.redirect "/login?error=invalid"

		else

			response.cookies("sessionkey")=ors("sessionkey")

			ors.close
			ocon.close

			''if logged in
			response.redirect "/account"

		end if

	else

		ocon.close

		''if not logged in
		response.redirect "/login?error=invalid"

	end if

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
                    </section>
                    <nav>
                        <ul id="menu">
                            <li><a href="/">Home</a></li>
                            <li><a href="/About">About</a></li>
                            <li><a href="/Contact">Contact</a></li>
                            <li><a href="/Login">Login</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </header>
        <div id="body">

    <section class="featured">
        <div class="content-wrapper">
            <hgroup class="title">
                <h1>Welcome to Faux Bank.</h1><br />
                <h2>Log into your account.</h2>
            </hgroup><br />
			<form action="/login" method="post" id="loginform">
			<input type="hidden" name="submitted" value="1" />
			<table>
			<tr>
			<td>Account Number:</td><td><input type="text" name="number" value="" />
			</tr>
			<tr>
			<td>Password:</td><td><input type="password" name="password" value="" />
			</tr>
			<tr>
			<td colspan="2"><input type="submit" name="submit" value="Login" /></td>
			</tr>
			<tr>
			<td colspan="2"><a href="/register">Register New Account</a></td>
			</tr>
			</table>
			</form>

			<% if request.querystring("error")<>"" then %>

			<p><strong>Sorry, but the account number or password was invalid</strong></p>

			<% end if %>

        </div>
    </section>

            <section class="content-wrapper main-content clear-fix">

<h3>We suggest the following:</h3>
<ol class="round">
    <li class="one">
        <h5>We just keep getting better!</h5>
        Faux Bank has just been voted the world's most insecure online bank. Seriously, if you put money in your account,
        dont count on it being there in the morning! You could store your money in a plastic bag, and put it in the middle of Somalia, and it would be more safe than with us!
        <a href="/about">Learn more..</a>
    </li>

    <li class="two">
        <h5>Open source banking software</h5>
        The source to this project has been published on GitHub, why contribute and port this project to other languages.
        <a href="http://www.github.com/thatcoderguy/faux-bank">Learn more...</a>
    </li>

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



<!-- Visual Studio Browser Link -->
<script type="application/json" id="__browserLink_initializationData">
    {"appName":"InternetExplorer","requestId":"0e0039cd49f84be0bdacc7fcd4e8f746"}
</script>
<script type="text/javascript" src="http://localhost:61364/0db510cd2104488a90ce78f1ef33b787/browserLink" async="async"></script>
<!-- End Browser Link -->

</body>
</html>


<%


function SQLStr(strTemp)
	'##################################################
	'##### prevents sql injection and some sql errors #####
	'##################################################

	if isnull(strTemp) then
		SQLStr=""
	else
		SQLStr=replace(strTemp,"'","''")
	end if
end function

function SQLNum(intTemp)
	'##################################################
	'##### prevents sql injection and some sql errors #####
	'##################################################

	if isnull(intTemp) then
		SQLNum="null"
	else
		intTemp=trim(intTemp)
		if isNumber(intTemp) then
			SQLNum=intTemp
		else
			SQLNum=0
		end if
	end if
end function

function SQLBit(intTemp)
	'##################################################
	'##### prevents sql injection and some sql errors #####
	'##################################################

	if isnull(intTemp) then intTemp=""
	if not cstr(trim(intTemp))="0" and not lcase(cstr(trim(intTemp)))="false" and not trim(intTemp)="" then
		SQLBit=1
	else
		SQLBit=0
	end if
end function

function GetConnectionString()

	'##################################################
	'##### read the web.config file to get the connection string #####
	'##################################################

dim xmlDoc,xmlappSettings,xmladd

set xmlDoc=server.CreateObject("Microsoft.XMLDOM")
set xmlappSettings=server.CreateObject("Microsoft.XMLDOM")
set xmladd=server.CreateObject("Microsoft.XMLDOM")

xmlDoc.async="false"
xmlDoc.load(server.MapPath("web.config"))

set xmlappSettings = xmldoc.GetElementsByTagName("appSettings").Item(0)
set xmladd = xmlappSettings.GetElementsByTagName("add")

for each x in xmladd

	'Check for the Atrribute Value
	if  x.getAttribute("key") ="DefaultConnection" then
		ReadWebConfig = x.getAttribute("value")
		exit for
	end if

next

end function

%>