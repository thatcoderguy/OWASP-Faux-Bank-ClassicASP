<%

	dim ocon, ocom

	'##################################################
	'##### connect to the database #####
	'##################################################

	set ocon=server.createobject("adodb.connection")
	ocon.open GetConnectionString()

	'##################################################
	'##### setup command object #####
	'##################################################

	set ocom=server.createobject("adodb.command")
	ocom.activeconnection=ocon

%>