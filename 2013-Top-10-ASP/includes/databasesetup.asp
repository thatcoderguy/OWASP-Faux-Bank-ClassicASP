<%

	dim ocon, ocom, ors

	'##################################################
	'##### connect to the database #####
	'##################################################

	set ocon=server.createobject("adodb.connection")
	ocon.open GetConnectionString()

%>