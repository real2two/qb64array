host = _OPENHOST("TCP/IP:7319") ' Opens Host
array$ = "text#hi#ffffff#none#C:\Windows\Fonts\times.ttf#30#30#30"

DO
    connection& = _OPENCONNECTION(host) ' Gets a new open connection.
    IF connection& THEN ' Checks if there was a new open connection.
        PUT connection&, , array$
    END IF
LOOP
