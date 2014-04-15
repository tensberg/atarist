 GOTO Anfang
 DEF PROC Zentriere(A)
 FOR T=1 TO A
 IF LEFT$(A$(T),1)="" THEN
 PRINT SPC(41- LEN(A$(T))/2);"p";
 A$(T)= RIGHT$(A$(T), LEN(A$(T))-1)
 PRINT A$(T);"q"
 GOTO Centerweiter
 ENDIF
 IF LEFT$(A$(T),1)="@" THEN
 PRINT SPC(41- LEN(A$(T))/2); RIGHT$(A$(T), LEN(A$(T))-1)
 GOTO Centerweiter
 ENDIF
 PRINT SPC(40- LEN(A$(T))/2);A$(T)
-Centerweiter
 NEXT T
 RETURN
-Auswahl
 Zeile= CSRLIN
 Zentriere(Anz)
 FOR T=(Zeile-1)*16 TO (Zeile-2)*16+Anz*16 STEP 16
 BOX 20,T TO 620,T+16
 NEXT T
 MOUSEON
-Tasten
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 UNTIL MOUSEBUT >0
 IF X<20 OR X>620 OR Y<(Zeile-1)*16 OR Y>(Zeile-1)*16+Anz*16 THEN GOTO Tasten
 MOUSEOFF
 WHILE (Y-(Zeile-1)*16)/16<> INT((Y-(Zeile-1)*16)/16)
 Y=Y-1
 WEND
 Stelle=(Y-(Zeile-1)*16)/16+1
 IF LEFT$(A$(Stelle),1)="[" THEN
 MOUSEON
 GOTO Tasten
 ENDIF
 IF LEFT$(A$(Stelle),1)<>"@" THEN REPEAT UNTIL MOUSEBUT =0
 RETURN
 DEF PROC System_Zeichnen
 DRAW Mittex,0 TO Mittex,399
 DRAW 0,Mittey TO 639,Mittey
 DRAW Mittex-5,5 TO Mittex,0 TO Mittex+5,5
 IF Xachse=-1 THEN
 DRAW 634,Mittey-5 TO 639,Mittey TO 634,Mittey+5
 ELSE
 DRAW 5,Mittey-5 TO 0,Mittey TO 5,Mittey+5
 ENDIF
 IF Modus=2 OR Modus=5 THEN
 FOR X=Mittex-Aufloesung TO 7 STEP -Aufloesung
 DRAW X,Mittey-2 TO X,Mittey+2
 NEXT X
 FOR X=Mittex+Aufloesung TO 632 STEP Aufloesung
 DRAW X,Mittey-2 TO X,Mittey+2
 NEXT X
 IF Xachse=-1 THEN
 FOR Y=Mittey-Aufloesung TO 7 STEP -Aufloesung
 DRAW Mittex+2,Y TO Mittex-2,Y
 NEXT Y
 FOR Y=Mittey+Aufloesung TO 392 STEP Aufloesung
 DRAW Mittex+2,Y TO Mittex-2,Y
 NEXT Y
 ELSE
 FOR Y=Mittey-Aufloesung TO 7 STEP -Aufloesung
 DRAW Mittex-2,Y TO Mittex+2,Y
 NEXT Y
 FOR Y=Mittey+Aufloesung TO 392 STEP Aufloesung
 DRAW Mittex-2,Y TO Mittex+2,Y
 NEXT Y
 ENDIF
 ENDIF
 IF Modus>2 AND Modus<5 THEN
 FOR X=Mittex-Aufloesung/(Modus-2) TO 7 STEP -Aufloesung/(Modus-2)
 DRAW X,0 TO X,399
 NEXT X
 FOR X=Mittex+Aufloesung/(Modus-2) TO 632 STEP Aufloesung/(Modus-2)
 DRAW X,0 TO X,399
 NEXT X
 FOR Y=Mittey-Aufloesung/(Modus-2) TO 7 STEP -Aufloesung/(Modus-2)
 DRAW 0,Y TO 639,Y
 NEXT Y
 FOR Y=Mittey+Aufloesung/(Modus-2) TO 392 STEP Aufloesung/(Modus-2)
 DRAW 0,Y TO 639,Y
 NEXT Y
 DRAW Mittex-1,0 TO Mittex-1,399
 DRAW 0,Mittey+1 TO 639,Mittey+1
 ENDIF
 IF Modus=5 THEN
 FOR X=Mittex-Aufloesung TO 7 STEP -Aufloesung
 FOR Y=Mittey-Aufloesung TO 7 STEP -Aufloesung
 DRAW X,Y
 NEXT Y
 NEXT X
 FOR X=Mittex+Aufloesung TO 632 STEP Aufloesung
 FOR Y=Mittey-Aufloesung TO 7 STEP -Aufloesung
 DRAW X,Y
 NEXT Y
 NEXT X
 FOR X=Mittex-Aufloesung TO 7 STEP -Aufloesung
 FOR Y=Mittey+Aufloesung TO 392 STEP Aufloesung
 DRAW X,Y
 NEXT Y
 NEXT X
 FOR X=Mittex+Aufloesung TO 632 STEP Aufloesung
 FOR Y=Mittey+Aufloesung TO 392 STEP Aufloesung
 DRAW X,Y
 NEXT Y
 NEXT X
 ENDIF
 IF Xachse=-1 THEN
 TEXT ROTATION = 0
 TEXT Mittex-8,Mittey+8,"0"
 TEXT 630,Mittey+14,"X"
 TEXT Mittex-12,8,"Y"
 ELSE
 TEXT ROTATION = 900
 TEXT Mittex+8,Mittey+8,"0"
 TEXT 7,Mittey+14,"Y"
 TEXT Mittex+14,8,"X"
 ENDIF
 RETURN
 DEF PROC Funktion_Zeichnen
 Ywert2=0
 CLS
 IF Systemz=-1 THEN System_Zeichnen
 IF Xachse=-1 THEN
 FOR Xwert=0 TO 639
 X!=(Xwert-Mittex)/Aufloesung
 Y1=Mittey-(FN Y!(X!)*Aufloesung)
 IF Ywert2=0 THEN Ywert2=Y1
 IF Y1<-200 OR Y1>600 OR Ywert2<-200 OR Ywert2>600 THEN GOTO Funktionweiter
 IF Zeichenart=-1 THEN
 DRAW Xwert-1,Ywert2 TO Xwert,Y1
 ELSE
 DRAW Xwert,Y1
 ENDIF
-Funktionweiter
 Ywert2=Y1
-Fehlerzurueck
 NEXT Xwert
 ELSE
 FOR Xwert=0 TO 399
 X!=-(Xwert-Mittey)/Aufloesung
 Y1=Mittex-(FN Y!(X!)*Aufloesung)
 IF Ywert2=0 THEN Ywert2=Y1
 IF Y1<-200 OR Y1>840 OR Ywert2<-200 OR Ywert2>840 THEN GOTO Funktionweiter2
 IF Zeichenart=-1 THEN
 DRAW Ywert2,Xwert-1 TO Y1,Xwert
 ELSE
 DRAW Y1,Xwert
 ENDIF
-Funktionweiter2
 Ywert2=Y1
-Fehlerzurueck2
 NEXT Xwert
 ENDIF
 IF Drucken=-1 THEN HCOPY
 IF Speichern=-1 THEN
 BSAVE Filename$
 OPEN "o",1, LEFT$(Filename$, LEN(Filename$)-3)+"S-W"
 PRINT #1,1
 CLOSE 1
 ENDIF
 REPEAT UNTIL MOUSEBUT >0 OR INKEY$ <>""
 RETURN
 DEF PROC Mittelpunkt_Aussuchen
 CLS
 MODE =3
 REPEAT
 Mittex= MOUSEX
 Mittey= MOUSEY
 PRINT "H"; SPC(20);"HX: ";Mittex;" Y: ";Mittey
 DRAW Mittex,0 TO Mittex,399
 DRAW 0,Mittey TO 639,Mittey
 REPEAT
 UNTIL MOUSEX <>Mittex OR Mittey<> MOUSEY OR MOUSEBUT >0
 DRAW Mittex,0 TO Mittex,399
 DRAW 0,Mittey TO 639,Mittey
 UNTIL MOUSEBUT >0
 REPEAT UNTIL MOUSEBUT =0
 MODE =1
 RETURN
-Anfang
 DIM A$(20)
 ON ERROR GOTO Fehler
 CLIP 0,0,640,400
 TEXT COLOR =1
 TEXT STYLE =0
 TEXT HEIGHT =6
 Xachse=-1
 Systemz=-1
 Mittex=320
 Mittey=200
 Aufloesung=30
 Modus=5
 Zeichenart=-1
 Filename$="FUNKTION.PI3"
 Pathname$="A:ACCESSOR.IES\PROGRAMM.E\*.PI3"
 PRINT "f";
-Hauptmenue
 CLS
 PRINT
 A$(1)="Funktionenzeichner"
 Zentriere(1)
 PRINT "B"*6
 A$(1)="Funktion zeichnen"
 A$(2)="Zeichenart : "
 IF Zeichenart=-1 THEN
 A$(2)=A$(2)+"Linien"
 ELSE
 A$(2)=A$(2)+"Punkte"
 ENDIF
 A$(3)="[Aufl”sung : "+ STR$(Aufloesung)+"]"
 A$(4)="@Aufl”sung gr”sser"
 A$(5)="@Aufl”sung kleiner"
 A$(6)="X-Achse (Bildschirm) = "
 IF Xachse=-1 THEN
 A$(6)=A$(6)+"X-Achse (Funktion)"
 ELSE
 A$(6)=A$(6)+"Y-Achse (Funktion)"
 ENDIF
 A$(7)="Mittelpunkt aussuchen"
 A$(8)="System zeichnen "
 IF Systemz=-1 THEN
 A$(8)=A$(8)+"an"
 ELSE
 A$(8)=A$(8)+"aus"
 ENDIF
 A$(9)="Modus : "
 IF Modus=1 THEN A$(9)=A$(9)+"Ohne Markierung"
 IF Modus=2 THEN A$(9)=A$(9)+"Mit Markierung"
 IF Modus=3 THEN A$(9)=A$(9)+"Kariert 1"
 IF Modus=4 THEN A$(9)=A$(9)+"Kariert 0.5"
 IF Modus=5 THEN A$(9)=A$(9)+"Punkte"
 A$(10)="Drucken : "
 IF Drucken=-1 THEN
 A$(10)=A$(10)+"an"
 ELSE
 A$(10)=A$(10)+"aus"
 ENDIF
 A$(11)="Speichern : "
 IF Speichern=-1 THEN
 A$(11)=A$(11)+"Ja"
 ELSE
 A$(11)=A$(11)+"Nein"
 ENDIF
 A$(12)="Filename : "+Filename$
 Anz=12
 GOSUB Auswahl
 IF Stelle=1 THEN Funktion_Zeichnen
 IF Stelle=2 THEN Zeichenart= NOT (Zeichenart)
 IF Stelle=4 THEN Aufloesung=Aufloesung+1
 IF Stelle=5 AND Aufloesung>1 THEN Aufloesung=Aufloesung-1
 IF Stelle=6 THEN Xachse= NOT (Xachse)
 IF Stelle=7 THEN Mittelpunkt_Aussuchen
 IF Stelle=8 THEN Systemz= NOT (Systemz)
 IF Stelle=9 THEN Modus=Modus+1+(Modus=5)*5
 IF Stelle=10 THEN Drucken= NOT (Drucken)
 IF Stelle=11 THEN Speichern= NOT (Speichern)
 IF Stelle=12 THEN
 CLS
 MOUSEON
 FILESELECT (Pathname$,Filename$,Flag)
 MOUSEOFF
 ENDIF
 GOTO Hauptmenue
-Fehler
 Y1=-300
 IF ERL =86 THEN RESUME Fehlerzurueck
 IF ERL =100 THEN RESUME Fehlerzurueck2
 RESUME NEXT
 '
 ' Diese Funktion „ndern
 DEF FN Y!(X!)=1/ ABS(X!)
