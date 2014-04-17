<%

	dim link

	if not request.cookies("sessionkey") is nothing then

		if request.cookies("sessionkey")<>"SESSIONKEYINVALID" and request.cookies("sessionkey")<>"" then
			link="<a href=""/Account"">Account</a>"
		else
			link="<a href=""/Login"">Login</a>"
		end if

	else

		link="<a href=""/Login"">Login</a>"

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
                            <li><%= link %></li>
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
                <h2>The only bank with all of <a href="https://www.owasp.org/index.php/Top_10_2013-Top_10">oWASP.org's top 10 web vulnerabilities</a>!</h2>
            </hgroup><br />
            <p>
                Open up an account with us today and we'll credit your account with &pound;100!.
            </p>
            <p>It only takes seconds to register an account, all we need is your name, email address and password.</p>
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
        The source to this project has been published on GitHub, why not contribute, and port this project to other languages.
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

</body>
</html>