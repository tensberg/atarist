 GOTO Anfang
 DEF PROC Zentriere(A)
 FOR T=1 TO A
 IF LEFT$(A$(T),1)="" THEN
 PRINT SPC(20-( LEN(A$(T))-1)/2);"p";
 A$(T)= RIGHT$(A$(T), LEN(A$(T))-1)
 PRINT A$(T);"q"
 ELSE
 PRINT SPC(20- LEN(A$(T))/2);A$(T)
 ENDIF
 NEXT T
 RETURN
-Iterate
 Xa!=0
 Ya!=0
 Z!=2
 REPEAT
 X2!= ABS(Xa!)
 Y2!= ABS(Ya!)
 Xn!=X2!-Y2!-Xc!
 Ya!=2*(Ya!*Xa!)-Yc!
 Xa!=Xn!
 Z!=Z!-.05
 UNTIL Z!<-1E-4 OR X2!+Y2!>400
 RETURN
-Zeichne
 IF ABS(C!)>102 THEN C!=102* SGN(C!)
 Xxa=160+Ho
 Xxb=161+Ho
 Yya=98-C!
 Yyb=99-C!
 LINE COLOR =Weiss
 DRAW Xxb,200 TO Xxb,Yya
 LINE COLOR =Braun
 DRAW Xxa,200 TO Xxa,Yyb
 IF C!<0 THEN
 LINE COLOR =Fa
 DRAW Xxa,Yyb
 ENDIF
 IF C!>Ca!+.3 THEN
 LINE COLOR =Schwarz
 DRAW Xxa,99-Ca! TO Xxa,Yyb
 ENDIF
 LINE COLOR =Fa
 DRAW Xxa,Yya
 RETURN
-Anfang
 DEG
 DIM Farbe(15)
 Speicher= MEMORY(33256)
 PALETTE $777,$432,$337,$557,$151,$774,$777,0,0,0,0,0,0,0,0,0
 Farbe(0)=$777
 Farbe(1)=$432
 Farbe(2)=$337
 Farbe(3)=$557
 Farbe(4)=$151
 Farbe(5)=$774
 Farbe(6)=$777
 Farbe(7)=0
 Farbe(8)=0
 Farbe(9)=0
 Farbe(10)=0
 Farbe(11)=0
 Farbe(12)=0
 Farbe(13)=0
 Farbe(14)=0
 Farbe(15)=0
 Weiss=5
 Braun=2
 Blau=3
 Gruen=4
 Schwarz=1
 Sonne=7
 CLIP 0,0,320,200
-Start
 CLS
 PRINT "f"
 A$(1)="Fraktallandschaften"
 Zentriere(1)
 PRINT "B"*3
 A$(1)="Idee und Orginalprogramm :"
 A$(2)="Happy Computer"
 A$(3)="Umsetzung :"
 A$(4)="Cook Soft Company"
 Zentriere(4)
 A$= INPUT$(1)
 CLS
 PRINT "e";
 INPUT "X-Standort : ";X1!
 INPUT "Y-Standort : ";Y1!
 Xc!=X1!
 Yc!=Y1!
 GOSUB Iterate
 PRINT "Hoehe : ";Z!
-Hoeheneingabe
 INPUT "Deine H”he : ";H!
 IF H!<Z! THEN
 PRINT "A";
 GOTO Hoeheneingabe
 ENDIF
 INPUT "Blickrichtung : ";Ku!
 Ku!=Ku!* PI /180
 Si!= SIN(Ku!)
 Co!= COS(Ku!)
 INPUT "Tag oder Nacht ? ";Zeit$
 IF LOWER$( LEFT$(Zeit$,1))="t" THEN
 Himmel=6
 Durchmesser=10
 ELSE
 Himmel=15
 Durchmesser=7
 ENDIF
 INPUT "Linienabstand ? ";Wert!
 PRINT "f";
 CLS
 LINE COLOR =Himmel
 FILL COLOR =Himmel
 PBOX 0,0,319,100
 LINE COLOR =Weiss
 FOR Y=1 TO 100^(1/Wert!)
 DRAW 0,100-Y^Wert! TO 319,100-Y^Wert!
 NEXT Y
 LINE COLOR =Sonne
 FILL COLOR =Sonne
 PCIRCLE 290,34,Durchmesser
 FOR V=1 TO 600 STEP 2
 E!=H!/V*10
 FOR Ho=-160 TO 160
 Fa=Gruen
 Hc!=E!*Ho*9.3E-3
 Xc!=X1!+Hc!*Co!+E!*Si!
 Yc!=Y1!-Hc!*Si!+E!*Co!
 GOSUB Iterate
 IF Ho>-160 THEN Z!=Za!*.7+Z!*.3
 IF Z!<0 THEN
 Fa=Blau
 Z!=-1E-4
 ENDIF
 C!=(Z!-H!)*V/H!
 Za!=Z!
 GOSUB Zeichne
 Ca!=C!
 NEXT Ho
 IF INKEY$ >"" THEN EXIT TO Ende
 NEXT V
 A$= INPUT$(1)
-Ende
 BITBLT 0,0,320,200 TO Speicher
 CLS
 PRINT "e";
 INPUT "Filename : ";Filename$
 IF Filename$="" THEN GOTO Start
 PRINT "f";
 BSAVE Filename$+".pif"
 OPEN "o",1,Filename$+".col"
 FOR T=0 TO 15
 PRINT #1,Farbe(T)
 NEXT T
 CLOSE 1
 GOTO Start
