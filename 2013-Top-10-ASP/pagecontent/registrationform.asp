<% if accountnumber<>"" then %>

	<p>Thank you for creating a new account.<Br />
	Your new account number is: <strong><%= accountnumber %></strong></p>
	<p>Please do not lose this number, as you will need it to log into your account</p>
	<p><a href="/login">Log into your account</a></p>

<% else %>

	<form action="/register" method="post" id="loginform">
	<input type="hidden" name="submitted" value="1" />
	<table>
	<tr>
	<td>Name:</td><td><input type="text" name="name" required  value="" /></td>
	</tr>
	<tr>
	<td>Email Address:</td><td><input type="email" name="email" required value="" /></td>
	</tr>
	<tr>
	<td>Password:</td><td><input type="password" name="password" required  value="" /></td>
	</tr>
	<tr>
	<td>Password Reminder:</td><td><input type="text" name="passwordreminder" required  value="" /></td>
	</tr>
	<tr>
	<td colspan="2"><input  style="float: right;" type="submit" name="submit" value="Register" /></td>
	</tr>
	</table>
	</form>

<% end if %>