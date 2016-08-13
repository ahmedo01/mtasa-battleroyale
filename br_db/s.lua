local MYSQL_LOGIN = "db_17647"
local MYSQL_PASSWORD = "7UK91GHCm3Uq"
local MYSQL_NAME = "db_17647"
local MYSQL_HOST = "mysql-fr1.ServerProject.pl"
local MYSQL_PORT = "3306"

local connection = false

function connectToDatabase()
	connection = dbConnect("mysql", "dbname="..MYSQL_NAME..";host="..MYSQL_HOST..";port="..MYSQL_PORT, MYSQL_LOGIN, MYSQL_PASSWORD)
	if connection then 
		outputDebugString("Połączono z bazą danych MySQL pomyślnie.", 3)
	else 
		outputDebugString("Nie można połączyć się z bazą danych MySQL!", 1)
	end 
end 
addEventHandler("onResourceStart", resourceRoot, connectToDatabase)

function getConnection()
	return connection
end 