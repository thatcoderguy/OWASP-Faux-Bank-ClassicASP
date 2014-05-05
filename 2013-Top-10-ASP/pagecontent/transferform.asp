<%
	''if the transaction succeeded, then display the succeeded message.
	if transactioncomplete then
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

<% end if %>