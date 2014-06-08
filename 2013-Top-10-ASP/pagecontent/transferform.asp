<%

'##################################################
'##### if the has not transaction succeeded, then display the transfer form. #####
'##################################################

if not transactioncomplete then

	'##################################################
	'##### if in secure mode #####
	'##################################################

	if GetMode()="secure" then

		dim token


		'####################################################################
		'##### this is how to prevent CSRF   							#####
		'##### create a unique token   									#####
		'##### store it in a cookie and submit it in the form  		 	#####
		'##### then in the handler - verify that the two values match   #####
		'##### store it in a cookie and submit it in the form   		#####
		'##### "hackers" cant read or modify cookie data unless it   	#####
		'##### belongs to the same domain name as a site that has   	#####
		'##### been compromised   										#####
		'####################################################################

		token = GenerateToken()

		response.cookies("token") = token


%>

		<form action="/Transfer" method="post" id="transferform">
		<input type="hidden" name="submitted" value="1" />
		<input type="hidden" name="token" value="<%= token %>" />
		<table>
		<tr>
		<td>Transfer to Account:</td><td>&nbsp;<input type="text" name="accountto" value="" /></td>
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

	else

%>

		<form action="/Transfer" method="post" id="transferform">
		<input type="hidden" name="submitted" value="1" />
		<table>
		<tr>
		<td>Transfer to Account:</td><td>&nbsp;<input type="text" name="accountto" value="" /></td>
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

end if

%>