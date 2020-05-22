SCREEN _NEWIMAGE(500, 500, 32)
screenx = 500
screeny = 500

client = _OPENCLIENT("TCP/IP:7319:localhost") ' Opens Client
IF client THEN
    DO
        GET client, , array$
    LOOP UNTIL array$ <> ""

    DO
        CLS
        _LIMIT 10
        _FONT 16
        _PRINTMODE _FILLBACKGROUND
        COLOR &HFFFFFFFF, &HFF000000

        ' ============
        ' Array Reader
        ' ============
        test$ = array$ ' Sets the test variable.

        DO
            CALL loopUntil(test$, "#", type$)
            IF type$ = "" GOTO endLoop
            IF type$ = "image" THEN
                CALL loopUntil(test$, "#", image$)
                IF image$ = "" GOTO endLoop
                CALL loopUntil(test$, "#", x$)
                IF x$ = "" GOTO endLoop
                CALL loopUntil(test$, "#", y$)
                IF y$ = "" GOTO endLoop
                image& = _LOADIMAGE(image$, 32)
                IF image& < -1 THEN
                    _PUTIMAGE (VAL(x$), VAL(y$)), image&
                    _FREEIMAGE image&
                ELSE SYSTEM
                END IF
            ELSEIF type$ = "text" THEN
                CALL loopUntil(test$, "#", text$)
                IF text$ = "" GOTO endLoop
                CALL loopUntil(test$, "#", fgcolor$)
                IF fgcolor$ = "" GOTO endLoop
                CALL loopUntil(test$, "#", bgcolor$)
                IF bgcolor$ = "" GOTO endLoop
                CALL loopUntil(test$, "#", font$)
                IF font$ = "" GOTO endLoop
                CALL loopUntil(test$, "#", fontsize$)
                IF fontsize$ = "" GOTO endLoop
                CALL loopUntil(test$, "#", x$)
                IF x$ = "" GOTO endLoop
                CALL loopUntil(test$, "#", y$)
                IF y$ = "" GOTO endLoop
                IF bgcolor$ = "none" THEN
                    _PRINTMODE _KEEPBACKGROUND
                    COLOR VAL("&HFF" + fgcolor$)
                ELSE
                    _PRINTMODE _FILLBACKGROUND
                    COLOR VAL("&HFF" + fgcolor$), VAL("&HFF" + bgcolor$)
                END IF
                f& = _LOADFONT(font$, VAL(fontsize$))
                IF f& > 0 THEN
                    _FONT f&
                    _PRINTSTRING (VAL(x$), VAL(y$)), text$
                    _FONT 16
                    _FREEFONT f&
                ELSE SYSTEM
                END IF
                _PRINTMODE _FILLBACKGROUND
                COLOR &HFFFFFFFF, &HFF000000
            ELSEIF type$ = "sound" THEN
                CALL loopUntil(test$, "#", sound$)
                IF sound$ = "" GOTO endLoop
                s& = _SNDOPEN(sound$)
                IF s& = 0 THEN SYSTEM
                _SNDPLAY s&
                _SNDCLOSE s&
            ELSEIF type$ = "title" THEN
                CALL loopUntil(test$, "#", title$)
                IF title$ = "" GOTO endLoop
                _TITLE title$
            ELSEIF type$ = "screen" THEN
                CALL loopUntil(test$, "#", screenx$)
                IF screenx$ = "" GOTO endLoop
                CALL loopUntil(test$, "#", screeny$)
                IF screeny$ = "" GOTO endLoop
                IF screenx <> VAL(screenx$) OR screeny <> VAL(screeny$) THEN
                    screenx = VAL(screenx$)
                    screeny = VAL(screeny$)
                    SCREEN _NEWIMAGE(screenx, screeny)
                END IF
            END IF
        LOOP UNTIL test$ = ""

        _DISPLAY

        endLoop:
    LOOP
END IF

SUB loopUntil (text$, until$, new$)
    IF LEN(until$) = 1 THEN
        test$ = text$
        new$ = ""
        done = 0
        DO
            IF test$ <> "" THEN
                IF LEFT$(test$, 1) = until$ THEN
                    test$ = RIGHT$(test$, LEN(test$) - 1)
                    text$ = test$
                    done = 1
                ELSE
                    new$ = new$ + LEFT$(test$, 1)
                    test$ = RIGHT$(test$, LEN(test$) - 1)
                END IF
            ELSE
                text$ = ""
                done = 1
            END IF
        LOOP UNTIL done = 1
        done = 0
    END IF
END SUB
