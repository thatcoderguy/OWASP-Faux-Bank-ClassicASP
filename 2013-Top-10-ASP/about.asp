<!-- #include file="includes/functions.asp" -->
<!-- #include file="includes/links.asp" -->
<%

	'##################################################
	'##### the about page #####
	'##################################################

%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>About - OWASP Faux Bank</title>
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
                    		<li><% displaysecurelink() %></li>
                    	</ul>
                    </section>
                    <nav>
                        <ul id="menu">
                            <li><a href="/">Home</a></li>
                            <li><a href="/About">About</a></li>
                            <li><a href="/Contact">Contact</a></li>
                            <li><% displayaccountlink() %></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </header>
        <div id="body">

            <section class="content-wrapper main-content clear-fix">


<hgroup class="title">
    <h1>About.</h1>
    <h2>OWASP Faux Bank is an open source project designed as a proof of concept for <a href="https://www.owasp.org/index.php/Top_10_2013-Top_10">oWASP's top 10 vulnerabilities</a> and as an educational tool for web developers.</h2>
</hgroup>

<article>
    <p>
        You can view the source code to this project and help contribute to it by going to <a href="http://www.github.com/thatcoderguy/owasp-faux-bank">github.com/thatcoderguy/owasp-faux-bank</a>.
    </p>

    <p>
        So far the following vulnerabilities has been implemented into the project:
        <ol>
        <li>Cross Site Request Forgery (CSRF or XSRF)</li>
        <li>Cross Site Scripting (XSS)</li>
        <li>SQL Injection</li>
        <li>Broken Authentication and Session Management</li>
        <li>Missing Function Level Access Control</li>
        </ol>

        The other 5 security vulnerabilities to implement are:
        <ol>
        <li>Insecure Direct Object Reference</li>
        <li>Security Misconfigration</li>
        <li>Sensitive Data Exposure</li>
        <li>Using Components With Know Vulnerabilities</li>
        <li>Unvalidated Redirects and Forwards</li>
        </ol>
        This list will increase as the project is developed further.
    </p>

    <p>
        Visit my blog at <a href="http://www.thatcoderguy.co.uk/blog">www.thatcoderguy.co.uk/blog</a> and see how these vulnerabilities work and how to exploit them.
    </p>
</article>

<aside>
    <h3>Aside Title</h3>
    <p>
        Use this area to provide additional information.
    </p>
    <ul>
                            <li><a href="/">Home</a></li>
                            <li><a href="/About">About</a></li>
                            <li><a href="/Contact">Contact</a></li>
                            <li><a href="/Login">Login</a></li>
    </ul>
</aside>
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
