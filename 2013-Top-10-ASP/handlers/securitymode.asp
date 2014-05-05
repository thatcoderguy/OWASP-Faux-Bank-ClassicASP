<%

'##################################################
'##### handle the setmode querystring #####
'#################################################

if request.querystring("setmode")="secure" then

	response.cookies("securitymode")="secure"

elseif request.querystring("setmode")="normal" then

	response.cookies("securitymode")="normal"

end if

%>