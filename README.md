Faux-Bank
=========

A proof of concept project that demonstrates oWASP.org's top 10 web vulnerabilities

This is the Classic ASP Version of Faux Bank.

To setup, you will need IIS and SQL Server

Run "fauxbank setup script.sql" to setup the database.

Edit the web.config file and add your SQL server instance name to this line:

<add connectionString="Provider=sqloledb;Server={PUT INSTANCE NAME HERE};Database=FauxBank;Integrated Security=SSPI;" name="DefaultConnection" />
