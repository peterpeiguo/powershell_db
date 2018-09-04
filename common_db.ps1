#this function takes information about the database, the user and the query, run the query
#the database is microsoft sql server
#it returns the result from the query
Function Query-Database {
    Param($server, $database, $user, $password, $query)
    $result = [pscustomobject]@{Exception = $null; Rows = @()}

    Try {
        $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
        $sqlConnection.ConnectionString = "Server={0};Database={1};UID={2};PWD={3}" -f $server, $database, $user, $password

        $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
        $sqlCommand.CommandText = $query
        $sqlCommand.Connection = $sqlConnection

        $sqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
        $sqlAdapter.SelectCommand = $sqlCommand

        $data = New-Object System.Data.DataSet

        $sqlAdapter.Fill($data) > $null
        $result.Rows = $data.Tables[0].Rows
    } Catch {
        $result.Exception = $_.Exception
    } Finally {
        if ($data) {
            $data.Dispose()
        }
        if ($sqlAdapter) {
            $sqlAdapter.Dispose()
        }
        if ($sqlConnection) {
            $sqlConnection.Dispose()
        }
        if ($sqlCommand) {
            $sqlCommand.Dispose()
        }
    }

    $result
}