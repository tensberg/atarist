 GOTO Anfang
 DEF PROC Zentriere(A)
 FOR T=1 TO A
 IF LEFT$(A$(T),1)="" THEN
 PRINT TAB (20-( LEN(A$(T))-1)/2);"p";
 A$(T)= RIGHT$(A$(T), LEN(A$(T))-1)
 PRINT A$(T);"q"
 ELSE
 PRINT TAB (20- LEN(A$(T))/2);A$(T)
 ENDIF
 NEXT T
 RETURN
-Auswahl
 Zeile= CSRLIN
 Zentriere(Anz)
 FOR T=(Zeile-1)*8-1 TO (Zeile-2)*8+Anz*8-1 STEP 8
 BOX 10,T TO 310,T+8
 NEXT T
 MOUSEON
-Tasten
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 UNTIL MOUSEBUT >0
 REPEAT
 UNTIL MOUSEBUT =0
 IF X<10 OR X>310 OR Y<(Zeile-1)*8-1 OR Y>(Zeile-1)*8+Anz*8-1 THEN GOTO Tasten
 MOUSEOFF
 WHILE (Y-(Zeile-1)*8)/8<> INT((Y-(Zeile-1)*8)/8)
 Y=Y-1
 WEND
 Stelle=(Y-(Zeile-1)*8)/8+1
 IF LEFT$(A$(Stelle),1)="[" THEN
 MOUSEON
 GOTO Tasten
 ENDIF
 RETURN
-Iteration
 X!=0:Y!=0:Xq!=0:Yq!=0
 FOR Iter=0 TO Su
 Y!=2*X!*Y!-Cy!
 X!=Xq!-Yq!-Cx!
 Xq!=X!*X!:Yq!=Y!*Y!
 IF Xq!+Yq!>4 THEN T=Iter+1: EXIT TO Iter2
 NEXT Iter
 LINE COLOR =0: FILL COLOR =0: GOTO Weiter
-Iter2
 IF T<Such!(15) THEN LINE COLOR =1: FILL COLOR =1: GOTO Weiter
 IF T<Such!(14) THEN LINE COLOR =2: FILL COLOR =2: GOTO Weiter
 IF T<Such!(13) THEN LINE COLOR =3: FILL COLOR =3: GOTO Weiter
 IF T<Such!(12) THEN LINE COLOR =4: FILL COLOR =4: GOTO Weiter
 IF T<Such!(11) THEN LINE COLOR =5: FILL COLOR =5: GOTO Weiter
 IF T<Such!(10) THEN LINE COLOR =6: FILL COLOR =6: GOTO Weiter
 IF T<Such!(9) THEN LINE COLOR =7: FILL COLOR =7: GOTO Weiter
 IF T<Such!(8) THEN LINE COLOR =8: FILL COLOR =8: GOTO Weiter
 IF T<Such!(7) THEN LINE COLOR =9: FILL COLOR =9: GOTO Weiter
 IF T<Such!(6) THEN LINE COLOR =10: FILL COLOR =10: GOTO Weiter
 IF T<Such!(5) THEN LINE COLOR =11: FILL COLOR =11: GOTO Weiter
 IF T<Such!(4) THEN LINE COLOR =12: FILL COLOR =12: GOTO Weiter
 IF T<Such!(3) THEN LINE COLOR =13: FILL COLOR =13: GOTO Weiter
 IF T<Such!(2) THEN LINE COLOR =14: FILL COLOR =14: GOTO Weiter
 LINE COLOR =15: FILL COLOR =15
-Weiter
 RETURN
-Anfang
 DIM Farbe(15),Such!(15),A$(10)
 CHDIR "A:\PROGRAMM.E\FRACBILD"
 Farbe(0)=0
 Farbe(1)=$777
 Farbe(2)=$774
 Farbe(3)=$762
 Farbe(4)=$651
 Farbe(5)=$650
 Farbe(6)=$540
 Farbe(7)=$630
 Farbe(8)=$720
 Farbe(9)=$610
 Farbe(10)=$600
 Farbe(11)=$500
 Farbe(12)=$400
 Farbe(13)=$300
 Farbe(14)=$200
 Farbe(15)=$100
 PALETTE Farbe(0),Farbe(2),Farbe(3),Farbe(6),Farbe(4),Farbe(7),Farbe(5),Farbe(8),Farbe(9),Farbe(10),Farbe(11),Farbe(14),Farbe(12),Farbe(15),Farbe(13),Farbe(1)
 Bild= MEMORY(32256)+30
 CLS
 PRINT "f";
 CHDIR ".."
 BLOAD "APFEL.PIC"
 CHDIR "FRACBILD"
 BITBLT 0,0,320,200 TO Bild
 PRINT "B"*11
 A$(1)="Mandeldraw  by C S C"
 Zentriere(1)
 Taste$= INPUT$(1)
 Xl!=-.75
 Xr!=2.1
 Yo!=-1.2
 Yu!=1.2
 Su=15
 Aufl=0
 Modus=0
 Schwarz=0
 Pixels!=1
 DEG
 Sinus!= SIN(45)
 Cosinus!= COS(45)
 FILL STYLE =1,1
-Hauptmenue
 CLS
 PRINT "B"*3
 A$(1)="Bild zeichnen"
 A$(2)="Bild zeigen"
 A$(3)="Lupe"
 A$(4)="Farbscrolling"
 A$(5)="Farben „ndern"
 A$(6)="Bild speichern"
 A$(7)="Bild laden"
 A$(8)="Parameter drucken"
 Anz=8
 GOSUB Auswahl
 ON Stelle GOTO Zeichnen,Zeigen,Lupe,Scroll,Aendern,Speicher,Laden,Druck
-Zeichnen
 CLS
 A$(1)="Auswahl der Koordinaten"
 Zentriere(1)
 PRINT "B"*3
 A$(1)="Linker Rand : "+ STR$(Xl!)
 A$(2)="Rechter Rand : "+ STR$(Xr!)
 A$(3)="Oberer Rand : "+ STR$(Yo!)
 A$(4)="Unterer Rand : "+ STR$(Yu!)
 A$(5)="Suchtiefe : "+ STR$(Su)
 A$(6)="Aufl”sung : "
 IF Aufl=0 THEN A$(6)=A$(6)+"Normal"
 IF Aufl=1 THEN A$(6)=A$(6)+"3 D"
 A$(7)="Pixels : "+ STR$(Pixels!)
 A$(8)="Zeichnen"
 A$(9)="Zurck"
 Anz=9
 GOSUB Auswahl
 ON Stelle GOTO Xl,Xr,Yo,Yu,Such,Aufloesung,Pixel,Z2eichnen,Hauptmenue
-Xl
 CLS
 PRINT "e";
 INPUT "Linker Rand ? ";Xl!
 IF Xr!<=Xl! THEN
 PRINT "A";
 GOTO Xl
 ENDIF
 PRINT "f";
 GOTO Zeichnen
-Xr
 CLS
 PRINT "e";
 INPUT "Rechter Rand ? ";Xr!
 IF Xr!<=Xl! THEN
 PRINT "A";
 GOTO Xr
 ENDIF
 PRINT "f";
 GOTO Zeichnen
-Yo
 CLS
 PRINT "e";
 INPUT "Oberer Rand ? ";Yo!
 IF Yu!<=Yo! THEN
 PRINT "A";
 GOTO Yo
 ENDIF
 PRINT "f";
 GOTO Zeichnen
-Yu
 CLS
 PRINT "e";
 INPUT "Unterer Rand ? ";Yu!
 IF Yu!<=Yo! THEN
 PRINT "A";
 GOTO Yu
 ENDIF
 PRINT "f";
 GOTO Zeichnen
-Such
 CLS
 PRINT "e";
 INPUT "Suchtiefe ? ";Su
 PRINT "f";
 GOTO Zeichnen
-Aufloesung
 Aufl=Aufl+1+(Aufl=1)*2
 GOTO Zeichnen
-Pixel
 CLS
 PRINT "e";
 INPUT "Pixels ? ";Pixels!
 PRINT "f";
 GOTO Zeichnen
-Z2eichnen
 CLS
 FOR T=2 TO 15
 Such!(T)=Su/T
 NEXT T
 IF Aufl=0 THEN
 Dx!= ABS((Xr!-Xl!))/(320/Pixels!)
 Dy!= ABS((Yu!-Yo!))/(200/Pixels!)
 Cx!=Xl!
 Cy!=Yo!
 FOR Ykoor=0 TO INT(199/Pixels!)
 FOR Xkoor=0 TO INT(319/Pixels!)
 IF INKEY$ >"" THEN
 IF Schwarz=0 THEN
 Schwarz=1
 PALETTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 ELSE
 Schwarz=0
 PALETTE Farbe(0),Farbe(2),Farbe(3),Farbe(6),Farbe(4),Farbe(7),Farbe(5),Farbe(8),Farbe(9),Farbe(10),Farbe(11),Farbe(14),Farbe(12),Farbe(15),Farbe(13),Farbe(1)
 ENDIF
 ENDIF
 GOSUB Iteration
 PBOX Xkoor*Pixels!,Ykoor*Pixels!,Pixels!,Pixels!
 Cx!=Cx!+Dx!
 NEXT Xkoor
 Cx!=Xl!
 Cy!=Cy!+Dy!
 NEXT Ykoor
 ENDIF
 IF Aufl=1 THEN
 LINE COLOR =1
 Faktor!=100/(199-Cosinus!*100)
 Faktor2!=10/Su
 Ykoor3=99-Cosinus!*100
 Dx!= ABS((Xr!-Xl!))/160
 Dy!= ABS((Yu!-Yo!))/100
 Cx!=Xl!
 Cy!=Yo!
 FOR Ykoor=0 TO 99
 FOR Xkoor=0 TO 159
 IF INKEY$ <>"" THEN
 IF Schwarz=0 THEN
 Schwarz=1
 PALETTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 ELSE
 Schwarz=0
 PALETTE Farbe(0),Farbe(2),Farbe(3),Farbe(6),Farbe(4),Farbe(7),Farbe(5),Farbe(8),Farbe(9),Farbe(10),Farbe(11),Farbe(14),Farbe(12),Farbe(15),Farbe(13),Farbe(1)
 ENDIF
 ENDIF
 GOSUB Iteration
 Xkoor2=Sinus!*(160-Ykoor)+Xkoor
 Ykoor2=99-Cosinus!*100+Ykoor*Faktor!
 IF T>=Su THEN LINE COLOR =8
 DRAW Xkoor2-1,Ykoor3 TO Xkoor2,Ykoor2+T*Faktor2!
 Ykoor3=Ykoor2+T*Faktor2!-1
 Cx!=Cx!+Dx!
 NEXT Xkoor
 Ykoor3=0
 Cx!=Xl!
 Cy!=Cy!+Dy!
 NEXT Ykoor
 ENDIF
-Ende
 PALETTE Farbe(0),Farbe(2),Farbe(3),Farbe(6),Farbe(4),Farbe(7),Farbe(5),Farbe(8),Farbe(9),Farbe(10),Farbe(11),Farbe(14),Farbe(12),Farbe(15),Farbe(13),Farbe(1)
 Schwarz=0
 BITBLT 0,0,320,200 TO Bild
 Taste$= INPUT$(1)
 LINE COLOR =1
 GOTO Hauptmenue
-Zeigen
 BITBLT Bild TO 0,0,320,200
 Taste$= INPUT$(1)
 GOTO Hauptmenue
-Lupe
 BITBLT Bild TO 0,0,320,200
 MOUSEON
 LINE COLOR =1
 MODE =3
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 UNTIL MOUSEBUT >0
 MOUSEOFF
 REPEAT
 X2= MOUSEX
 Y2= MOUSEY
 IF X2<X+2 THEN X2=X+2
 IF Y2<Y+2 THEN Y2=Y+2
 BOX X,Y TO X2,Y2
 BOX X,Y TO X2,Y2
 UNTIL MOUSEBUT =0
 MODE =1
 Su=Su*(320/(X2-X))
 Dx!= ABS((Xr!-Xl!))/320
 Dy!= ABS((Yu!-Yo!))/200
 Xr!=Xl!
 Xl!=Xl!+X*Dx!
 Xr!=Xr!+X2*Dx!
 Yu!=Yo!
 Yo!=Yo!+Y*Dy!
 Yu!=Yu!+Y2*Dy!
 GOTO Hauptmenue
-Speicher
 Path$="A:\PROGRAMM.E\FRACBILD\*.PIF"
 CLS
 MOUSEON
 FILESELECT (Path$,Name$,Button)
 MOUSEOFF
 IF Button=0 THEN GOTO Hauptmenue
 FOR T=0 TO 15
 WPOKE Bild-28+T*2,Farbe(T)
 NEXT T
 BSAVE Name$,Bild-30,32066
 WPOKE Bild,8
 WPOKE Bild+2,320
 WPOKE Bild+4,200
 OPEN "o",1, LEFT$(Name$, LEN(Name$)-3)+"PAR"
 PRINT #1,Xl!
 PRINT #1,Xr!
 PRINT #1,Yo!
 PRINT #1,Yu!
 PRINT #1,Su
 PRINT #1,Pixels!
 PRINT #1,Aufl
 CLOSE 1
 GOTO Hauptmenue
-Laden
 Path$="A:\PROGRAMM.E\FRACBILD\*.PIF"
 CLS
 MOUSEON
 FILESELECT (Path$,Name$,Button)
 MOUSEOFF
 IF Button=0 THEN GOTO Hauptmenue
 BLOAD Name$,Bild-30
 WPOKE Bild,8
 WPOKE Bild+2,320
 WPOKE Bild+4,200
-Ladenweiter
 OPEN "i",1, LEFT$(Name$, LEN(Name$)-3)+"PAR"
 INPUT #1,Xl!
 INPUT #1,Xr!
 INPUT #1,Yo!
 INPUT #1,Yu!
 INPUT #1,Su
 INPUT #1,Pixels!
 INPUT #1,Aufl
 CLOSE 1
 PALETTE Farbe(0),Farbe(2),Farbe(3),Farbe(6),Farbe(4),Farbe(7),Farbe(5),Farbe(8),Farbe(9),Farbe(10),Farbe(11),Farbe(14),Farbe(12),Farbe(15),Farbe(13),Farbe(1)
 BLOAD Name$
 BITBLT 0,0,320,200 TO Bild
 GOTO Hauptmenue
-Scroll
 GOTO Hauptmenue
-Druck
 GOTO Hauptmenue
-Aendern
 GOTO Hauptmenue
