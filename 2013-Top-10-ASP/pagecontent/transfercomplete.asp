<%
'##################################################
'##### if the transaction succeeded, then display the succeeded message. #####
'##################################################

if transactioncomplete then

%>
	<p>Thank you</p>
	<p>Your transfer of &pound;<%= request.form("amount") %> to account <%= request.form("accountto") %> <br />has been completed</p>

	<p><a href="/Account">Back to my account</p>

<%

end if

%>