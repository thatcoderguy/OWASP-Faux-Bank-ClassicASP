<%

'##################################################
'##### if the has not transaction succeeded, then display the transfer form. #####
'##################################################

if not transactioncomplete then

	'##################################################
	'##### if in secure mode, then create a unique token cookie (and submit in form). #####
	'##################################################

	if GetMode()="secure" then



%>

		<form action="/Transfer" method="post" id="transferform">
		<input type="hidden" name="submitted" value="1" />
		<table>
		<tr>
		<td>Transfer to Account:</td><td>&nbsp;<input type="text" name="accountto" value="" />
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
		<td>Transfer to Account:</td><td>&nbsp;<input type="text" name="accountto" value="" />
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