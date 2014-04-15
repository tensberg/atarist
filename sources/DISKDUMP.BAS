 '
 DIM R%(9)
 PRINT "INITIALISIERE SERIELLE SCHNITTSTELLE"
 XBIOS (,15,0,2,128+8,-1,-1,-1)
 WHILE 1
 INPUT "Disk einlegen";T$
 BIOS (R,7,0)
 IF R=0 THEN
        PRINT "FEHLER BEIM LESEN DER DRIVE-INFO"
 ENDIF
 Steps=4
 Bps= WPEEK(R)
 Sepc= WPEEK(R+2)
 Ac= WPEEK(R+14)
 Seccount=Sepc*Ac
 PRINT "BYTES JE SEKTOR",Bps
 PRINT "SEKTOREN JE CLUSTER",Sepc
 PRINT "GESAMTZAHL CLUSTER",Ac
 PRINT "GESAMTZAHL SEKTOREN",Seccount
 Size=Bps*Steps
 Buf= MEMORY(Size)
 FOR Sector=0 TO Seccount STEP Steps
        PRINT "LESE SEKTOR ",Sector," VON ",Seccount
        REPEAT
            BIOS (R,4,0, HIGH(Buf), LOW(Buf),Steps,Sector,0)
            IF R<0 THEN
               PRINT "BIOS-Fehler ";R
               INPUT "Wiederholen? (j/n)";T$
               IF (T$<>"j") THEN R=0
            ENDIF
        UNTIL R=0
        GEMDOS (R,64,2, HIGH(Size), LOW(Size), HIGH(Buf), LOW(Buf))
 NEXT Sector
 WEND
