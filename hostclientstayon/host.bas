$CONSOLE:ONLY
_DEST _CONSOLE

array$ = "text#hi#ffffff#none#C:\Windows\Fonts\times.ttf#30#30#30"

host = _OPENHOST("TCP/IP:7319")
IF host THEN
    DIM connection&(10)
    DO
        ' New Connections
        connection& = _OPENCONNECTION(host)
        IF connection& THEN
            FOR loopnum = 1 TO 10
                IF loopnum > 10 THEN ' max players
                    PRINT _CONNECTIONADDRESS$(connection&) + " tried to join the game."
                    CLOSE connection&
                    GOTO endnewconnections
                END IF
                IF connection&(loopnum) THEN
                    IF connection&(loopnum) <> 0 THEN
                        IF _CONNECTED(connection&(loopnum)) THEN
                        ELSE
                            CLOSE connection&(loopnum)
                            GOTO newconnectionsopen
                        END IF
                    ELSE
                        CLOSE connection&(loopnum)
                        GOTO newconnectionsopen
                    END IF
                ELSE
                    newconnectionsopen:
                    connection&(loopnum) = connection&
                    PRINT _CONNECTIONADDRESS$(connection&) + " has joined the game."
                    leavemsg$(loopnum) = _CONNECTIONADDRESS$(connection&) + " has left the game."
                    GOTO endnewconnections
                END IF
            NEXT
        END IF
        endnewconnections:

        'Kick out players who leave
        FOR loopnum = 1 TO 10
            IF connection&(loopnum) <> 0 THEN
                IF _CONNECTED(connection&(loopnum)) THEN
                    'playercount = playercount + 1
                ELSE
                    IF leavemsg$(loopnum) <> "" THEN
                        PRINT leavemsg$(loopnum)
                        leavemsg$(loopnum) = ""
                    END IF
                END IF
            END IF
        NEXT

        'Send stuff
        FOR loopnum = 1 TO 10
            IF connection&(loopnum) <> 0 THEN
                IF _CONNECTED(connection&(loopnum)) THEN
                    PUT connection&(loopnum), , array$
                END IF
            END IF
        NEXT
    LOOP
ELSE
    PRINT "The port 7319 is already taken."
END IF
