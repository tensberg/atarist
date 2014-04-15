 CLEAR 0,4096
 Speicher= FRE("")
 Speicher=Speicher-32256*9
 Bank=3
 CLS
 PRINT "f";
 WHILE NOT (Knopf=3)
 Text$="[0][ Freier Speicher :"+ STR$(Speicher)+" | SpeicherbÑnke   :"+ STR$(Bank)
 Text$=Text$+"][  <  |  >  | WEITER ]"
 MOUSEON
 FORM_ALERT (3,Text$,Knopf)
 MOUSEOFF
 IF Knopf=1 AND Bank>1 THEN
   Bank=Bank-1
   Speicher=Speicher+32256
 ENDIF
 IF Knopf=2 AND Speicher>32256 THEN
   Bank=Bank+1
   Speicher=Speicher-32256
 ENDIF
 WEND
 POKE LPEEK($44E),Bank
 CLEAR 32256*(6+Bank)
 Maxbank= PEEK( LPEEK($44E))+3
 POKE LPEEK($44E),0
 IPL 3+(1 SHL 31)
 COMPILER "Multitasking_between_Statements"
 COMPILER "Trace_On"
 ON ERROR GOTO Fehler
 Resourcedefs
 Get_Path
 IF RIGHT$(Path$,15)<>"DATAS\PRGDATAS\" THEN
   IF RIGHT$(Path$,7)<>"\DATAS\" THEN
     Path$=Path$+"DATAS\PRGDATAS\"
   ELSE
     Path$=Path$+"PRGDATAS\"
   ENDIF
 ENDIF
 CHDIR Path$
 Anfpath$=Path$
 Path$= LEFT$(Path$, LEN(Path$)-9)
 DIM Fuellm%(15),Feld%F(59,59),A$(10),Message(10),Bank(Maxbank),Speichern%F(Maxbank)
 DIM Drucker%B(5,5),Druck%F(1)
 ON ERROR GOTO Dfehler
 OPEN "i",1,"drucker.inf"
 ON ERROR GOTO Fehler
 IF Er=0 THEN
   INPUT #1,Druck%F(0)
   INPUT #1,Druck%F(1)
   FOR Y=0 TO 5
     FOR X=0 TO 4
       Drucker%B(Y,X)= ASC( INPUT$(1,1))
     NEXT X
   NEXT Y
   CLOSE 1
 ELSE
   Druck%F(0)=0' Parallelport
   Druck%F(1)=-1' Druckbytes doppelt ausgeben
   Drucker%B(0,0)=27:Drucker%B(1,0)=51:Drucker%B(2,0)=24
                                        ' Zeilenvorschub auf 24/180 Zoll
   Drucker%B(0,1)=27:Drucker%B(1,1)=42:Drucker%B(2,1)=1
                                        ' Grafikdruck einschalten
   Drucker%B(0,2)=248:Drucker%B(1,2)=2
                                        ' 760 Bytes Grafikdaten
   Drucker%B(0,3)=14:Drucker%B(1,3)=3
                                        ' 782 Bytes Grafikdaten
   Drucker%B(0,4)=10:Drucker%B(1,4)=13
                                        ' Line Feed + Carriage Return
 ENDIF
 Fillstyle=1:Index=1
 Bank=1
 Pbank=4
 Gew_Zchn=0
 Modus=0
 Bildcheck=0
 Ppointerx=0
 Ppointery=0
 Pmodus=0
 Sicher=0
 Bankb=-1
 Zeichen=-1
 Anfang=1' Flag ob Plan editiert wurde
 XBIOS (Aufl,4)
 IF Aufl<2 THEN
 PRINT "pFalsche Auflîsungq"
 PRINT "Bitte mit Auflîsung 640 X 400 neu laden !"
 Taste$= INPUT$(1)
 SYSTEM
 ENDIF
 Appl_Init
 MOUSEOFF
 CLIP
 CLS
 Load_Rsc
 V_Opnvwk
 XBIOS (Bild1,2)
 Bild2= MEMORY(32256)+255 AND $FFFF00
 Grabbild= MEMORY(32256)
 FOR T=1 TO Maxbank
 Bank(T)=( MEMORY(32256)+255 AND $FFFF00)-6
 BITBLT 0,0,640,400 TO Bank(T)
 NEXT T
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 CLS
 BOX 0,19,611,367
 FOR T=61 TO 550 STEP 61
 DRAW T,19 TO T,385
 NEXT T
 FOR T=80 TO 352 STEP 61
 DRAW 0,T TO 610,T
 NEXT T
 BITBLT 0,0,640,400 TO Bank(1)
 BITBLT 0,0,640,400 TO Bank(2)
 BITBLT 0,0,640,400 TO Bank(3)
 CLS
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 Chspeicher= MEMORY(742)
 Chspeicher2= MEMORY(742)
 BITBLT 0,0,60,60 TO Chspeicher
 BITBLT 0,0,60,60 TO Chspeicher2
-Hauptmenue
 LINE COLOR =1
 FILL COLOR =1
 CLS
 PRINT @(5,0)
 A$(1)="PLANMAKER V1.0"
 A$(2)=""
 A$(3)=""
 A$(4)="Ein Hilfsmittel zum erstellen"
 A$(5)="von Fantasy-SpielplÑnen"
 A$(6)="und Levels"
 Zentriere(6)
 PRINT @(23,0);
 A$(1)="by the Cook Soft Company in 1992"
 Zentriere(1)
-Mauswarten
 Menu_Bar(Hmenu_Adr)
-Mauswarten2
 IF Rand=0 THEN Menu_Icheck(Klebrand,0) ELSE Menu_Icheck(Klebrand,1)
 MOUSEON
 Evnt_Mesag(Mesag$)
 FOR T=1 TO 7
 Message(T)= CVI( MID$(Mesag$,T*2+1,2))
 NEXT T
 Menu_Tnormal(Message(3),1)
 IF Message(4)=Klebrand THEN Rand= NOT (Rand): GOTO Mauswarten2
 MOUSEOFF
 Menu_Bar
 IF Message(3)=Desk THEN
 GOSUB Info
 GOTO Hauptmenue
 ENDIF
 IF Message(3)=Chars THEN GOTO Charsselect
 IF Message(3)=Plan THEN GOTO Planselect
 IF Message(3)=Disk THEN GOTO Diskselect
 IF Message(3)=Drucken THEN GOTO Druckenselect
-Charsselect
 IF Message(4)=Chedit THEN GOTO Chedit
 IF Message(4)=Chanzeigen THEN GOTO Chanzeigen
 IF Message(4)=Chloeschen THEN GOTO Chloeschen
-Planselect
 IF Message(4)=Pedit THEN GOTO Pedit
 IF Message(4)=Pzeigen THEN GOTO Pzeigen
 IF Message(4)=Ploeschen THEN GOTO Ploeschen
-Diskselect
 IF Message(4)=Chladen THEN GOTO Chladen
 IF Message(4)=Chspeichern THEN GOTO Chspeichern
 IF Message(4)=Pladen THEN GOTO Pladen
 IF Message(4)=Pspeichern THEN GOTO Pspeichern
-Druckenselect
 IF Message(4)=Spdrucken THEN GOTO Spdrucken
 IF Message(4)=Gpdrucken THEN GOTO Gpdrucken
 IF Message(4)=Danpassung THEN GOTO Danpassung
 IF Message(4)=Ende THEN
 Graf_Growbox(0,0,20,20,260,150,120,100)
 MOUSEON
 FORM_ALERT (1,"[1][ | Programm beenden lîscht | alle nicht gespeicherten| Daten !][ ENDE | ZurÅck ]",Button)
 MOUSEOFF
 Graf_Shrinkbox(0,0,20,20,260,150,120,100)
 IF Button=2 THEN GOTO Hauptmenue
 IPL 3
 Rsrc_Free
 Appl_Exit
 IF COMPILER THEN CLEAR 0,512 ELSE CLEAR 65536,4096
 END
 ENDIF
-Chedit
 LINE COLOR =1
 FILL COLOR =1
 CLS
 BOX 120,40,400,320
 BOX 119,39,402,322
 BOX 120,25,400,12
 TEXT HEIGHT =6
 TEXT STYLE =1
 TEXT 270,33,"Chars editieren"
 TEXT STYLE =0
 BOX 124,42,392,12
 Text$="Char Nr."+ STR$(Gew_Zchn)+"   Bank Nr."+ STR$(Bank)
 TEXT 180,51,Text$
 BOX 124,56,301,301
 BOX 427,56,89,85
 BOX 429,58,85,10
 BOX 439,75,64,64
 TEXT HEIGHT =4
 TEXT 450,65,"Char :"
 FOR X=5 TO 295 STEP 5
 DRAW 124+X,56 TO 124+X,356
 DRAW 124,56+X TO 424,56+X
 NEXT X
 BITBLT Chspeicher TO 441,77,60,60
 Menu_Bar(Uchmenu_Adr)
 LINE COLOR =1
 FILL COLOR =1
 FOR Y=0 TO 59
 FOR X=0 TO 59
 IF POINT(441+X,77+Y) THEN PBOX 125+X*5,57+Y*5,4,4
 NEXT X
 NEXT Y
 FOR T=Zeichnen TO Ellipsen
 Menu_Icheck(T,0)
 NEXT T
 Menu_Icheck(Zeichnen+Modus,1)
 MOUSEON
-Mauswartenuch
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0 OR Y<18 AND X<320
 IF (X<124 OR X>424 OR Y<56 OR Y>356) AND (X<441 OR X>500 OR Y<77 OR Y>136) THEN REPEAT UNTIL MOUSEBUT =0
 IF Y<18 AND X<320 THEN
 Evnt_Multi(%10100,0,0,0,1,0,0,320,18,0,0,0,0,0,0,Mesag$,Maske,X,Y,Knopf,Keys,Keybrd,Klicks)
 IF BIT(4,Maske) THEN
 REPEAT UNTIL MOUSEBUT =0
 FOR T=1 TO 7
 Message(T)= CVI( MID$(Mesag$,T*2+1,2))
 NEXT T
 MOUSEOFF
 Menu_Tnormal(Message(3),1)
 IF Message(3)=Deskuch THEN
 Menu_Bar
 BITBLT 441,77,60,60 TO Chspeicher
 GOSUB Info
 GOTO Chedit
 ENDIF
 IF Message(3)=Charsuch THEN GOTO Charsuchselect
 IF Message(3)=Funktionenuch THEN GOTO Funkuchselect
 IF Message(3)=Specialsuch THEN GOTO Specialsuchselect
-Charsuchselect
 IF Message(4)=Chholenuch THEN
 BITBLT 441,77,60,60 TO Chspeicher
 Menu_Bar
 GOTO Chholenuch
 ENDIF
 IF Message(4)=Chspeichernuch THEN
 BITBLT 441,77,60,60 TO Chspeicher
 Menu_Bar
 GOTO Chspeichernuch
 ENDIF
 IF Message(4)=Chinvert THEN GOTO Chinvert
 IF Message(4)=Chloeschenuch THEN GOTO Chloeschenuch
-Funkuchselect
 IF Message(4)>=Zeichnen AND Message(4)<=Ellipsen THEN
 Modus=Message(4)-Zeichnen
 FOR T=Zeichnen TO Ellipsen
 Menu_Icheck(T,0)
 NEXT T
 Menu_Icheck(Message(4),1)
 MOUSEON
 GOTO Mauswartenuch
 ENDIF
 IF Message(4)=Faussuchen THEN
 BITBLT 441,77,60,60 TO Chspeicher
 Menu_Bar
 GOTO Faussuchen
 ENDIF
 IF Message(4)=Feditieren THEN
 BITBLT 441,77,60,60 TO Chspeicher
 Menu_Bar
 GOTO Feditieren
 ENDIF
-Specialsuchselect
 IF Message(4)=Verschieben THEN GOTO Verschieben
 IF Message(4)=Drehen THEN GOTO Drehen
 IF Message(4)=Spiegeln THEN GOTO Spiegeln
 IF Message(4)=Spray THEN GOTO Spray
 IF Message(4)=Grab THEN GOTO Grab
 IF Message(4)=Hauptmenueuch THEN
 BITBLT 441,77,60,60 TO Chspeicher
 Menu_Bar
 CLS
 GOTO Hauptmenue
 ENDIF
 ELSE
 GOTO Mauswartenuch
 ENDIF
 ENDIF
 IF X>124 AND X<425 AND Y>56 AND Y<357 THEN GOTO Zeichnen1
 IF X>440 AND X<501 AND Y>76 AND Y<137 THEN GOTO Zeichnen2
 GOTO Mauswartenuch
-Zeichnen1
 MOUSEOFF
 Xpos=(X-125)\5
 Ypos=(Y-57)\5
 IF Knopf=1 THEN LINE COLOR =1: FILL COLOR =1
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 IF Modus=0 THEN ' Zeichnen
 PBOX 125+Xpos*5,57+Ypos*5,4,4
 DRAW 441+Xpos,77+Ypos
 MOUSEON
 GOTO Mauswartenuch
 ENDIF
 IF Modus=1 THEN ' FÅllen
 CLIP 441,77,60,60
 FILL STYLE =Fillstyle,Index
 FILL 441+Xpos,77+Ypos,-1
 FILL STYLE =1,1
 CLIP
 ENDIF
 IF Modus=2 THEN ' Linien
 REPEAT UNTIL MOUSEBUT =0
 LINE COLOR =1
 MODE =3
 REPEAT
 X2= MOUSEX
 Y2= MOUSEY
 Knopf2= MOUSEBUT
 Xpos2=(X2-125)\5
 Ypos2=(Y2-57)\5
 CLIP 124,56 TO 422,357
 DRAW Xpos*5+127,Ypos*5+59 TO Xpos2*5+127,Ypos2*5+59
 DRAW Xpos*5+127,Ypos*5+59 TO Xpos2*5+127,Ypos2*5+59
 CLIP 441,77,60,60
 DRAW 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 DRAW 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 UNTIL Knopf2>0
 REPEAT UNTIL MOUSEBUT =0
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 MODE =1
 DRAW 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 Xmin= MIN(Xpos,Xpos2):Xmax= MAX(Xpos,Xpos2)
 Ymin= MIN(Ypos,Ypos2):Ymax= MAX(Ypos,Ypos2)
 IF Xmin<0 THEN Xmin=0
 IF Xmax>59 THEN Xmax=59
 IF Ymin<0 THEN Ymin=0
 IF Ymax>59 THEN Ymax=59
 ENDIF
 IF Modus=3 THEN ' Rechtecke
 REPEAT UNTIL MOUSEBUT =0
 LINE COLOR =1
 MODE =3
 REPEAT
 X2= MOUSEX
 Y2= MOUSEY
 Knopf2= MOUSEBUT
 Xpos2=(X2-125)\5
 Ypos2=(Y2-57)\5
 CLIP 124,56 TO 422,357
 BOX Xpos*5+127,Ypos*5+59 TO Xpos2*5+127,Ypos2*5+59
 BOX Xpos*5+127,Ypos*5+59 TO Xpos2*5+127,Ypos2*5+59
 CLIP 441,77,60,60
 BOX 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 BOX 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 UNTIL Knopf2>0
 REPEAT UNTIL MOUSEBUT =0
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 MODE =1
 BOX 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 Xmin= MIN(Xpos,Xpos2):Xmax= MAX(Xpos,Xpos2)
 Ymin= MIN(Ypos,Ypos2):Ymax= MAX(Ypos,Ypos2)
 IF Xmin<0 THEN Xmin=0
 IF Xmax>59 THEN Xmax=59
 IF Ymin<0 THEN Ymin=0
 IF Ymax>59 THEN Ymax=59
 ENDIF
 IF Modus=4 THEN ' Kreise
 REPEAT UNTIL MOUSEBUT =0
 LINE COLOR =1
 MODE =3
 REPEAT
 X2= MOUSEX
 Knopf2= MOUSEBUT
 Xpos2=(X2-125)\5
 CLIP 124,56 TO 422,357
 CIRCLE Xpos*5+127,Ypos*5+59,Xpos2*5
 CIRCLE Xpos*5+127,Ypos*5+59,Xpos2*5
 CLIP 441,77,60,60
 CIRCLE 441+Xpos,77+Ypos,Xpos2
 CIRCLE 441+Xpos,77+Ypos,Xpos2
 UNTIL Knopf2>0
 REPEAT UNTIL MOUSEBUT =0
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 MODE =1
 CIRCLE 441+Xpos,77+Ypos,Xpos2
 Xmin=Xpos- ABS(Xpos2):Xmax=Xpos+ ABS(Xpos2)
 Ymin=Ypos- ABS(Xpos2):Ymax=Ypos+ ABS(Xpos2)
 IF Xmin<0 THEN Xmin=0
 IF Xmax>59 THEN Xmax=59
 IF Ymin<0 THEN Ymin=0
 IF Ymax>59 THEN Ymax=59
 ENDIF
 IF Modus=5 THEN ' Ellipsen
 REPEAT UNTIL MOUSEBUT =0
 LINE COLOR =1
 MODE =3
 REPEAT
 X2= MOUSEX
 Y2= MOUSEY
 Knopf2= MOUSEBUT
 Xpos2=(X2-125)\5
 Ypos2=(Y2-57)\5
 CLIP 124,56 TO 422,357
 ELLIPSE Xpos*5+127,Ypos*5+59,Xpos2*5,Ypos2*5
 ELLIPSE Xpos*5+127,Ypos*5+59,Xpos2*5,Ypos2*5
 CLIP 441,77,60,60
 ELLIPSE 441+Xpos,77+Ypos,Xpos2,Ypos2
 ELLIPSE 441+Xpos,77+Ypos,Xpos2,Ypos2
 UNTIL Knopf2>0
 REPEAT UNTIL MOUSEBUT =0
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 MODE =1
 ELLIPSE 441+Xpos,77+Ypos,Xpos2,Ypos2
 Xmin=Xpos- ABS(Xpos2):Xmax=Xpos+ ABS(Xpos2)
 Ymin=Ypos- ABS(Ypos2):Ymax=Ypos+ ABS(Ypos2)
 IF Xmin<0 THEN Xmin=0
 IF Xmax>59 THEN Xmax=59
 IF Ymin<0 THEN Ymin=0
 IF Ymax>59 THEN Ymax=59
 ENDIF
 CLIP
 IF Modus=1 THEN
 FOR Y=0 TO 59
 FOR X=0 TO 59
 LINE COLOR = POINT(441+X,77+Y)
 FILL COLOR = POINT(441+X,77+Y)
 PBOX 125+X*5,57+Y*5,4,4
 NEXT X
 NEXT Y
 ELSE
 FOR Y=Ymin TO Ymax
 FOR X=Xmin TO Xmax
 IF POINT(441+X,77+Y)= ABS(Knopf-2) THEN PBOX 125+X*5,57+Y*5,4,4
 NEXT X
 NEXT Y
 ENDIF
 MOUSEON
 GOTO Mauswartenuch
-Zeichnen2
 MOUSEOFF
 Xpos=X-441
 Ypos=Y-77
 IF Knopf=1 THEN LINE COLOR =1: FILL COLOR =1
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 IF Modus=0 THEN
 DRAW X,Y
 PBOX 125+Xpos*5,57+Ypos*5,4,4
 MOUSEON
 GOTO Mauswartenuch
 ENDIF
 IF Modus=1 THEN
 CLIP 441,77,60,60
 FILL STYLE =Fillstyle,Index
 FILL 441+Xpos,77+Ypos,-1
 FILL STYLE =1,1
 CLIP
 ENDIF
 IF Modus=2 THEN
 REPEAT UNTIL MOUSEBUT =0
 LINE COLOR =1
 MODE =3
 REPEAT
 X2= MOUSEX
 Y2= MOUSEY
 Knopf2= MOUSEBUT
 Xpos2=X2-441
 Ypos2=Y2-77
 CLIP 124,56 TO 422,357
 DRAW Xpos*5+127,Ypos*5+59 TO Xpos2*5+127,Ypos2*5+59
 DRAW Xpos*5+127,Ypos*5+59 TO Xpos2*5+127,Ypos2*5+59
 CLIP 441,77,60,60
 DRAW 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 DRAW 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 UNTIL Knopf2>0
 REPEAT UNTIL MOUSEBUT =0
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 MODE =1
 DRAW 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 Xmin= MIN(Xpos,Xpos2):Xmax= MAX(Xpos,Xpos2)
 Ymin= MIN(Ypos,Ypos2):Ymax= MAX(Ypos,Ypos2)
 IF Xmin<0 THEN Xmin=0
 IF Xmax>59 THEN Xmax=59
 IF Ymin<0 THEN Ymin=0
 IF Ymax>59 THEN Ymax=59
 ENDIF
 IF Modus=3 THEN
 REPEAT UNTIL MOUSEBUT =0
 LINE COLOR =1
 MODE =3
 REPEAT
 X2= MOUSEX
 Y2= MOUSEY
 Knopf2= MOUSEBUT
 Xpos2=X2-441
 Ypos2=Y2-77
 CLIP 124,56 TO 422,357
 BOX Xpos*5+127,Ypos*5+59 TO Xpos2*5+127,Ypos2*5+59
 BOX Xpos*5+127,Ypos*5+59 TO Xpos2*5+127,Ypos2*5+59
 CLIP 441,77,60,60
 BOX 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 BOX 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 UNTIL Knopf2>0
 REPEAT UNTIL MOUSEBUT =0
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 MODE =1
 BOX 441+Xpos,77+Ypos TO 441+Xpos2,77+Ypos2
 Xmin= MIN(Xpos,Xpos2):Xmax= MAX(Xpos,Xpos2)
 Ymin= MIN(Ypos,Ypos2):Ymax= MAX(Ypos,Ypos2)
 IF Xmin<0 THEN Xmin=0
 IF Xmax>59 THEN Xmax=59
 IF Ymin<0 THEN Ymin=0
 IF Ymax>59 THEN Ymax=59
 ENDIF
 IF Modus=4 THEN
 REPEAT UNTIL MOUSEBUT =0
 LINE COLOR =1
 MODE =3
 REPEAT
 X2= MOUSEX
 Knopf2= MOUSEBUT
 Xpos2=(441-X2)\5
 CLIP 124,56 TO 422,357
 CIRCLE Xpos*5+127,Ypos*5+59,Xpos2*5
 CIRCLE Xpos*5+127,Ypos*5+59,Xpos2*5
 CLIP 441,77,60,60
 CIRCLE 441+Xpos,77+Ypos,Xpos2
 CIRCLE 441+Xpos,77+Ypos,Xpos2
 UNTIL Knopf2>0
 REPEAT UNTIL MOUSEBUT =0
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 MODE =1
 CIRCLE 441+Xpos,77+Ypos,Xpos2
 Xmin=Xpos- ABS(Xpos2):Xmax=Xpos+ ABS(Xpos2)
 Ymin=Ypos- ABS(Xpos2):Ymax=Ypos+ ABS(Xpos2)
 IF Xmin<0 THEN Xmin=0
 IF Xmax>59 THEN Xmax=59
 IF Ymin<0 THEN Ymin=0
 IF Ymax>59 THEN Ymax=59
 ENDIF
 IF Modus=5 THEN
 REPEAT UNTIL MOUSEBUT =0
 LINE COLOR =1
 MODE =3
 REPEAT
 X2= MOUSEX
 Y2= MOUSEY
 Knopf2= MOUSEBUT
 Xpos2=(441-X2)\5
 Ypos2=(77-Y2)\5
 CLIP 124,56 TO 422,357
 ELLIPSE Xpos*5+127,Ypos*5+59,Xpos2*5,Ypos2*5
 ELLIPSE Xpos*5+127,Ypos*5+59,Xpos2*5,Ypos2*5
 CLIP 441,77,60,60
 ELLIPSE 441+Xpos,77+Ypos,Xpos2,Ypos2
 ELLIPSE 441+Xpos,77+Ypos,Xpos2,Ypos2
 UNTIL Knopf2>0
 REPEAT UNTIL MOUSEBUT =0
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 MODE =1
 ELLIPSE 441+Xpos,77+Ypos,Xpos2,Ypos2
 Xmin=Xpos- ABS(Xpos2):Xmax=Xpos+ ABS(Xpos2)
 Ymin=Ypos- ABS(Ypos2):Ymax=Ypos+ ABS(Ypos2)
 IF Xmin<0 THEN Xmin=0
 IF Xmax>59 THEN Xmax=59
 IF Ymin<0 THEN Ymin=0
 IF Ymax>59 THEN Ymax=59
 ENDIF
 CLIP
 IF Modus=1 THEN
 FOR Y=0 TO 59
 FOR X=0 TO 59
 LINE COLOR = POINT(441+X,77+Y)
 FILL COLOR = POINT(441+X,77+Y)
 PBOX 125+X*5,57+Y*5,4,4
 NEXT X
 NEXT Y
 ELSE
 FOR Y=Ymin TO Ymax
 FOR X=Xmin TO Xmax
 IF POINT(441+X,77+Y)= ABS(Knopf-2) THEN PBOX 125+X*5,57+Y*5,4,4
 NEXT X
 NEXT Y
 ENDIF
 MOUSEON
 GOTO Mauswartenuch
-Chholenuch
 Zeichen_Holen
 IF Over=1 THEN Over=0: GOTO Chholenuch
 GOTO Chedit
-Chspeichernuch
 CLS
 BITBLT Bank(Bank) TO 0,0,640,400
-Chspeichernuch2
 MODE =3
 Xpos2=( MOUSEX -1)\61
 Ypos2=( MOUSEY -20)\61
 IF Xpos2>9 THEN Xpos2=9
 IF Ypos2>5 THEN Ypos2=5
 BOX Xpos2*61+1,Ypos2*61+20,60,60
 Zaehler=0
 Text$="Char speichern       Bank Nr."+ STR$(Bank)+"     Char Nr."
 PRINT @(0,0);Text$; STR$(Ypos2*10+Xpos2);"K"
 Y2= MOUSEY
 IF Y2<18 THEN MOUSEON
 REPEAT
 X= MOUSEX
 Y1= MOUSEY
 IF Y1>18 THEN Zaehler=Zaehler+1
 IF Y1>=18 AND Y2<18 THEN
 MOUSEOFF
 Y2=Y1
 ELSE
 IF Y1<18 AND Y2>=18 THEN
 MOUSEON
 Y2=Y1
 ENDIF
 ENDIF
 Knopf= MOUSEBUT
 IF MOUSEY >18 THEN
 Xpos1=(X-1)\61
 Ypos1=(Y1-20)\61
 IF Xpos1>9 THEN Xpos1=9
 IF Ypos1>5 THEN Ypos1=5
 IF Xpos1<>Xpos2 OR Ypos1<>Ypos2 THEN
 IF Zaehler<3000 THEN
     BOX Xpos2*61+1,Ypos2*61+20,60,60
   ELSE
     BOX Xpos2*61+2,Ypos2*61+21,58,58
 ENDIF
 BOX Xpos1*61+1,Ypos1*61+20,60,60
 Zaehler=0
 PRINT @(0,0);Text$; STR$(Ypos1*10+Xpos1);"K"
 Xpos2=Xpos1
 Ypos2=Ypos1
 ENDIF
 ENDIF
 IF Zaehler=3000 THEN
 BOX Xpos2*61+1,Ypos2*61+20,60,60
 BOX Xpos2*61+2,Ypos2*61+21,58,58
 Zaehler=Zaehler+1
 ENDIF
 IF Zaehler=6000 THEN
 BOX Xpos2*61+2,Ypos2*61+21,58,58
 BOX Xpos2*61+1,Ypos2*61+20,60,60
 Zaehler=0
 ENDIF
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF Y1<18 THEN
 MOUSEOFF
 ELSE
   IF Zaehler<3000 THEN
     BOX Xpos1*61+1,Ypos1*61+20,60,60
   ELSE
     BOX Xpos1*61+2,Ypos1*61+21,58,58
   ENDIF
 ENDIF
 MODE =1
 IF Knopf=2 THEN GOTO Chedit
 IF Knopf=1 AND Y1<18 THEN
 Bank=Bank+1
 IF Bank=4 THEN Bank=1
 GOTO Chspeichernuch
 ENDIF
 BITBLT Chspeicher TO Xpos1*61+1,Ypos1*61+20,60,60
 PRINT @(0,0);"K";
 BITBLT 0,0,640,400 TO Bank(Bank)
 GOTO Chspeichernuch2
-Chloeschenuch
 BITBLT 441,77,60,60 TO 441,77,60,60,0
 BITBLT 124,56,301,301 TO 124,56,301,301,0
 LINE COLOR =1
 FILL COLOR =1
 BOX 124,56,301,301
 FOR X=5 TO 295 STEP 5
 DRAW 124+X,56 TO 124+X,356
 DRAW 124,56+X TO 424,56+X
 NEXT X
 MOUSEON
 GOTO Mauswartenuch
-Chinvert
 BITBLT 441,77,60,60 TO 441,77,60,60,12
 LINE COLOR =1
 FILL COLOR =1
 FOR Y=0 TO 59
 FOR X=0 TO 59
 LINE COLOR = POINT(441+X,77+Y)
 FILL COLOR = POINT(441+X,77+Y)
 PBOX 125+X*5,57+Y*5,4,4
 NEXT X
 NEXT Y
 LINE COLOR =1
 FILL COLOR =1
 MOUSEON
 GOTO Mauswartenuch
-Faussuchen
 CLS
 FILL COLOR =1
 FILL STYLE =1,1
 PBOX 120,20,438,40
 FOR T=1 TO 11
 FILL STYLE =2,T
 PBOX 80+40*T,62,38,40
 NEXT T
 FOR T=12 TO 22
 FILL STYLE =2,T
 PBOX 80+40*(T-11),132,38,40
 NEXT T
 FOR T=1 TO 11
 FILL STYLE =3,T
 PBOX 80+40*T,210,38,40
 NEXT T
 FILL STYLE =4,1
 PBOX 120,294,438,40
 MOUSEON
-Fills_2
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 UNTIL MOUSEBUT >0
 IF X<120 OR X>598 THEN GOTO Fills_2
 IF Y<20 OR Y>334 THEN GOTO Fills_2
 IF Y>=20 AND Y<=60 THEN
 Fillstyle=1
 Index=1
 GOTO Fills_3
 ENDIF
 IF Y>=62 AND Y<=102 THEN
 FOR T=1 TO 11
 IF X>=80+40*T AND X<=80+40*T+38 THEN
 Fillstyle=2
 Index=T
 EXIT TO Fills_3
 ENDIF
 NEXT T
 GOTO Fills_2
 ENDIF
 IF Y>=132 AND Y<=172 THEN
 FOR T=12 TO 22
 IF X>=80+40*(T-11) AND X<=80+40*(T-11)+38 THEN
 Fillstyle=2
 Index=T
 EXIT TO Fills_3
 ENDIF
 NEXT T
 GOTO Fills_2
 ENDIF
 IF Y>=210 AND Y<=250 THEN
 FOR T=1 TO 11
 IF X>=80+40*T AND X<=80+40*T+38 THEN
 Fillstyle=3
 Index=T
 EXIT TO Fills_3
 ENDIF
 NEXT T
 GOTO Fills_2
 ENDIF
 IF Y>=294 AND Y<=334 THEN
 IF X>=120 AND X<=558 THEN
 Fillstyle=4
 Index=1
 GOTO Fills_3
 ENDIF
 ENDIF
 GOTO Fills_2
-Fills_3
 REPEAT UNTIL MOUSEBUT =0
 MOUSEOFF
 FILL STYLE =1,1
 GOTO Chedit
-Feditieren
 LINE COLOR =1
 FILL COLOR =1
 CLS
 BOX 120,40,400,320
 BOX 119,39,402,322
 BOX 120,25,400,12
 TEXT HEIGHT =6
 TEXT STYLE =1
 TEXT 255,33,"FÅllmuster editieren"
 TEXT STYLE =0
 BOX 124,56,241,241
 BOX 427,56,89,38
 BOX 429,58,85,10
 BOX 462,70,20,20
 BOX 427,96,89,15
 BOX 427,113,89,89
 FILL STYLE =4,1
 FILL 428,114,-1
 FILL STYLE =1,1
 TEXT HEIGHT =6
 TEXT 450,106,"ZURöCK"
 TEXT HEIGHT =4
 TEXT 440,65,"FÅllmuster :"
 FOR X=15 TO 225 STEP 15
 DRAW 124+X,56 TO 124+X,296
 DRAW 124,56+X TO 364,56+X
 NEXT X
 FILL STYLE =1,1
 FOR Y=0 TO 15
 IF Fuellm%(Y)>=0 THEN
 Bit$= BIN$(Fuellm%(Y))
 ELSE
 Bit$= BIN$(Fuellm%(Y)+65536)
 ENDIF
 FOR X= LEN(Bit$) TO 2 STEP -1
 LINE COLOR = VAL( MID$(Bit$,X,1))
 FILL COLOR = VAL( MID$(Bit$,X,1))
 DRAW 479-( LEN(Bit$)-X),72+Y
 PBOX 125+(15-( LEN(Bit$)-X))*15,57+Y*15,14,14
 NEXT X
 NEXT Y
 LINE COLOR =1
 FILL COLOR =1
 MOUSEON
-Mauswartenuch2
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 IF X<124 OR X>365 OR Y<56 OR Y>297 THEN
 REPEAT UNTIL MOUSEBUT =0
 ELSE
 IF X>123 AND X<364 AND Y>55 AND Y<296 THEN
 MOUSEOFF
 IF Knopf=1 THEN LINE COLOR =1: FILL COLOR =1
 IF Knopf=2 THEN LINE COLOR =0: FILL COLOR =0
 Xpos=(X-124)\15
 Ypos=(Y-56)\15
 PBOX Xpos*15+125,Ypos*15+57,14,14
 DRAW 464+Xpos,72+Ypos
 LINE COLOR =1: FILL COLOR =1
 MOUSEON
 GOTO Mauswartenuch2
 ENDIF
 ENDIF
 IF X>427 AND Y>96 AND X<516 AND Y<111 THEN
 MOUSEOFF
 FOR Y=0 TO 15
 Bit$="%"
 FOR X=0 TO 15
 Bit$=Bit$+ RIGHT$( STR$( POINT(464+X,72+Y)),1)
 NEXT X
 IF MID$(Bit$,2,1)="1" THEN
 Fuellm%(Y)= VAL("%"+ RIGHT$(Bit$,15))-32768
 ELSE
 Fuellm%(Y)= VAL(Bit$)
 ENDIF
 NEXT Y
 FILL PATTERN = Fuellm%(0)
 GOTO Chedit
 ENDIF
 IF X>427 AND Y>113 AND X<516 AND Y<202 THEN
 MOUSEOFF
 FOR Y=0 TO 15
 Bit$="%"
 FOR X=0 TO 15
 Bit$=Bit$+ RIGHT$( STR$( POINT(464+X,72+Y)),1)
 NEXT X
 IF MID$(Bit$,2,1)="1" THEN
 Fuellm%(Y)= VAL("%"+ RIGHT$(Bit$,15))-32768
 ELSE
 Fuellm%(Y)= VAL(Bit$)
 ENDIF
 NEXT Y
 FILL PATTERN = Fuellm%(0)
 FILL STYLE =4,1
 BITBLT 428,114,87,87 TO 428,114,87,87,0
 FILL 428,114,-1
 FILL STYLE =1,1
 MOUSEON
 GOTO Mauswartenuch2
 ENDIF
 GOTO Mauswartenuch2
-Verschieben
 Taste$=""
 Taste2$=""
 PRINT @(23,15);"e";
 INPUT "Richtung (O/U/R/L/E) : ";Taste$ USING "+o+u+r+l+e+O+U+R+L+E>",Var,1
 Taste$= LOWER$(Taste$)
 IF Taste$="e" OR Taste$="" THEN
 PRINT @(23,0);"fK";
 MOUSEON
 GOTO Mauswartenuch
 ENDIF
 PRINT
-Verschieben2
 INPUT @(23,15);"KAnzahl   (1-59)    : ";Taste2$ USING "0>",Var,2
 Taste= VAL(Taste2$)
 IF Taste<1 OR Taste>59 THEN
 PRINT CHR$(7);
 GOTO Verschieben2
 ENDIF
 PRINT @(23,0);"K";
 PRINT "f";
 IF Taste$="o" THEN
 Taste=60-Taste
 Taste$="u"
 ENDIF
 IF Taste$="l" THEN
 Taste=60-Taste
 Taste$="r"
 ENDIF
 IF Taste$="u" THEN
 BITBLT 441,137-Taste,60,Taste TO Chspeicher
 BITBLT 441,77,60,60-Taste TO 441,77+Taste,60,60-Taste
 BITBLT Chspeicher TO 441,77,60,Taste
 ENDIF
 IF Taste$="r" THEN
 BITBLT 501-Taste,77,60,Taste TO Chspeicher
 BITBLT 441,77,60-Taste,60 TO 441+Taste,77,60-Taste,60
 BITBLT Chspeicher TO 441,77,Taste,60
 ENDIF
 BITBLT 441,77,60,60 TO Chspeicher
 FOR Y=0 TO 59
 FOR X=0 TO 59
 Farbe= POINT(441+X,77+Y)
 LINE COLOR =Farbe
 FILL COLOR =Farbe
 PBOX 125+X*5,57+Y*5,4,4
 NEXT X
 NEXT Y
 MOUSEON
 GOTO Mauswartenuch
-Drehen
 Taste$=""
 PRINT @(23,15);"e";
 INPUT "Gegen/Im Uhrzeigersinn (G/I/E) : ";Taste$ USING "+g+i+e+G+I+E>",Var,1
 Taste$= LOWER$(Taste$)
 PRINT @(23,0);"Kf";
 IF Taste$="e" OR Taste$="" THEN MOUSEON : GOTO Mauswartenuch
 FOR Y=0 TO 59
 FOR X=0 TO 59
 Feld%F(X,Y)= POINT(441+X,77+Y)
 NEXT X
 NEXT Y
 IF Taste$="i" THEN
 FOR Y=0 TO 59
 FOR X=0 TO 59
 LINE COLOR = ABS(Feld%F(X,Y))
 DRAW 500-Y,77+X
 NEXT X
 NEXT Y
 ENDIF
 IF Taste$="g" THEN
 FOR Y=0 TO 59
 FOR X=0 TO 59
 LINE COLOR = ABS(Feld%F(X,Y))
 DRAW 441+Y,136-X
 NEXT X
 NEXT Y
 ENDIF
 BITBLT 441,77,60,60 TO Chspeicher
 FOR Y=0 TO 59
 FOR X=0 TO 59
 Farbe= POINT(441+X,77+Y)
 LINE COLOR =Farbe
 FILL COLOR =Farbe
 PBOX 125+X*5,57+Y*5,4,4
 NEXT X
 NEXT Y
 MOUSEON
 GOTO Mauswartenuch
-Spiegeln
 Taste$=""
 PRINT @(23,15);"e";
 INPUT "X\Y-Achse (X/Y/E) : ";Taste$ USING "+x+y+e+X+Y+E>",Var,1
 Taste$= LOWER$(Taste$)
 PRINT @(23,0);"Kf";
 IF Taste$="e" OR Taste$="" THEN MOUSEON : GOTO Mauswartenuch
 FOR Y=0 TO 59
 FOR X=0 TO 59
 Feld%F(X,Y)= POINT(441+X,77+Y)
 NEXT X
 NEXT Y
 IF Taste$="x" THEN
 FOR Y=0 TO 59
 FOR X=0 TO 59
 LINE COLOR = ABS(Feld%F(X,Y))
 DRAW 441+X,136-Y
 NEXT X
 NEXT Y
 ENDIF
 IF Taste$="y" THEN
 FOR Y=0 TO 59
 FOR X=0 TO 59
 LINE COLOR = ABS(Feld%F(X,Y))
 DRAW 500-X,77+Y
 NEXT X
 NEXT Y
 ENDIF
 BITBLT 441,77,60,60 TO Chspeicher
 FOR Y=0 TO 59
 FOR X=0 TO 59
 Farbe= POINT(441+X,77+Y)
 LINE COLOR =Farbe
 FILL COLOR =Farbe
 PBOX 125+X*5,57+Y*5,4,4
 NEXT X
 NEXT Y
 MOUSEON
 GOTO Mauswartenuch
-Spray
 Taste$=""
 PRINT @(23,15);"e";
 INPUT "Anzahl Punkte : ";Taste$ USING "0+e+E>",Var,2
 Taste$= LOWER$(Taste$)
 PRINT @(23,0);"Kf";
 IF Taste$="e" OR Taste$="" OR VAL(Taste$)=0 THEN MOUSEON : GOTO Mauswartenuch
 Taste= VAL(Taste$)
 BITBLT 441,77,60,60 TO Chspeicher
 LINE COLOR =1
 FOR T=1 TO Taste
 X= INT( RND(60))
 Y= INT( RND(60))
 DRAW 441+X,77+Y
 NEXT T
 Taste$=""
 PRINT @(23,15);"e";
 INPUT "Annehmen ? ";Taste$ USING "+j+n+J+N>",Var,1
 PRINT @(23,0);"Kf";
 IF LOWER$(Taste$)="j" THEN
 BITBLT 441,77,60,60 TO Chspeicher
 FOR Y=0 TO 59
 FOR X=0 TO 59
 Farbe= POINT(441+X,77+Y)
 LINE COLOR =Farbe
 FILL COLOR =Farbe
 PBOX 125+X*5,57+Y*5,4,4
 NEXT X
 NEXT Y
 ELSE
 BITBLT Chspeicher TO 441,77,60,60
 ENDIF
 MOUSEON
 GOTO Mauswartenuch
-Grab
 CLS
 A$(1)="Grab Char"
 Zentriere(1)
 Change_Ext("*.*")
 Name$=""
 MOUSEON
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 IF Flag=0 OR Name$="" THEN GOTO Chedit
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\")+1)
 IF Path$<>Path2$ OR Name$<>Name2$ THEN
 CLS
 BLOAD Name$
 BITBLT 0,0,640,400 TO Grabbild
 ENDIF
 Name2$=Name$
 Path2$=Path$
 BITBLT Grabbild TO 0,0,640,400
 MODE =3
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 IF X>580 THEN X=580
 IF Y>340 THEN Y=340
 BOX X,Y,60,60
 BOX X,Y,60,60
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 MODE =1
 IF Knopf=2 THEN GOTO Chedit
 BITBLT X,Y,60,60 TO Chspeicher
 Bildcheck=0
 GOTO Chedit
-Chanzeigen
 Banknr=1
-Chanzeigen2
 CLS
 BITBLT Bank(Banknr) TO 0,0,640,400
 PRINT "Chars anzeigen     Bank :"; STR$(Banknr)
 PRINT @(0,40);"Weiter   ZurÅck   Ende"
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 451,0 TO 451,17
 MOUSEON
-Chanzeigen3
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Banknr=Banknr+1
 IF Banknr=4 THEN Banknr=1
 GOTO Chanzeigen2
 ENDIF
 IF X>451 THEN GOTO Hauptmenue
 Banknr=Banknr-1
 IF Banknr=0 THEN Banknr=3
 GOTO Chanzeigen2
 ENDIF
 GOTO Chanzeigen3
-Chloeschen
 Banknr=1
 Loeschen=0
-Chloeschen2
 CLS
 BITBLT Bank(Banknr) TO 0,0,640,400
-Chloeschen3
 PRINT @(0,0);"KChars lîschen     Bank :"; STR$(Banknr)
 IF Loeschen=0 THEN
 Loesch$="Weiter  Lîschen   Ende"
 ELSE
 Loesch$="Weiter  pLîschenq   Ende"
 ENDIF
 PRINT @(0,40);Loesch$
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 451,0 TO 451,17
 MOUSEON
-Chloeschen4
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Loeschen=0
 Banknr=Banknr+1
 IF Banknr=4 THEN Banknr=1
 GOTO Chloeschen2
 ENDIF
 IF X>451 THEN GOTO Hauptmenue
 IF Loeschen=0 THEN
 Loeschen=1
 GOTO Chloeschen3
 ELSE
 CLS
 BOX 0,19,611,367
 FOR T=61 TO 550 STEP 61
 DRAW T,19 TO T,385
 NEXT T
 FOR T=80 TO 352 STEP 61
 DRAW 0,T TO 610,T
 NEXT T
 BITBLT 0,0,640,400 TO Bank(Banknr)
 Loeschen=0
 GOTO Chloeschen3
 ENDIF
 ENDIF
 GOTO Chloeschen4
-Chladen
 Banknr=1
 FOR T=1 TO 3
 Speichern%F(T)=0
 NEXT T
-Chladen2
 CLS
 BITBLT Bank(Banknr) TO 0,0,640,400
-Chladen3
 PRINT @(0,0);"Chars laden     Bank :"; STR$(Banknr)
 IF Speichern%F(Banknr) THEN
 Speichern$="Weiter    pladenq    Ende"
 ELSE
 Speichern$="Weiter    laden    Ende"
 ENDIF
 PRINT @(0,40);Speichern$
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 458,0 TO 458,17
 MOUSEON
-Chladen4
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Banknr=Banknr+1
 IF Banknr=4 THEN Banknr=1
 GOTO Chladen2
 ENDIF
 IF X>458 THEN
 FOR T=1 TO 3
 IF Speichern%F(T) THEN
 CLS
 A$(1)="Chars laden"
 A$(2)="Bank :"+ STR$(T)
 Zentriere(2)
 Change_Ext("*.CHR")
 Name$=""
 MOUSEON
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 IF Flag=0 OR Name$="" THEN GOTO Chladen5
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\")+1)
 CLS
 BLOAD Name$,Bank(T)+6
 ENDIF
-Chladen5
 NEXT T
 GOTO Hauptmenue
 ENDIF
 Speichern%F(Banknr)= NOT (Speichern%F(Banknr))
 GOTO Chladen3
 ENDIF
 GOTO Chladen3
-Chspeichern
 Banknr=1
 FOR T=1 TO 3
 Speichern%F(T)=0
 NEXT T
-Chspeichern2
 CLS
 BITBLT Bank(Banknr) TO 0,0,640,400
-Chspeichern3
 PRINT @(0,0);"Chars speichern     Bank :"; STR$(Banknr)
 IF Speichern%F(Banknr) THEN
 Speichern$="Weiter  pspeichernq  Ende"
 ELSE
 Speichern$="Weiter  speichern  Ende"
 ENDIF
 PRINT @(0,40);Speichern$
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 458,0 TO 458,17
 MOUSEON
-Chspeichern4
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Banknr=Banknr+1
 IF Banknr=4 THEN Banknr=1
 GOTO Chspeichern2
 ENDIF
 IF X>458 THEN
 FOR T=1 TO 3
 IF Speichern%F(T) THEN
 CLS
 A$(1)="Chars Speichern"
 A$(2)="Bank :"+ STR$(T)
 Zentriere(2)
 Change_Ext("*.CHR")
 Name$=""
 MOUSEON
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 IF Flag=0 OR Name$="" THEN GOTO Chspeichern5
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\")+1)
 CLS
 BSAVE Name$,Bank(T)+6,32000
 ENDIF
-Chspeichern5
 NEXT T
 GOTO Hauptmenue
 ENDIF
 Speichern%F(Banknr)= NOT (Speichern%F(Banknr))
 GOTO Chspeichern3
 ENDIF
 GOTO Chspeichern4
-Pedit
 IF Anfang=1 THEN Anfang=0' beim Laden wird jetzt der Plan gezeichnet
 IF Bankb=-1 THEN Bankb=Bank
 IF Zeichen=-1 THEN Zeichen=Gew_Zchn
 IF Zeichen<1 THEN Zeichen=1
 IF Zeichen>58 THEN Zeichen=58
 IF Zeichen MOD 2=0 THEN Zeichen=Zeichen+1
 CLS
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Bank(Bank) TO 0,0,640,400
 X=(Gew_Zchn-(Gew_Zchn\10)*10)*61+1
 Y=(Gew_Zchn\10)*61+20
 BITBLT X,Y,60,60 TO Chspeicher
 BITBLT Bank(Bankb) TO 0,0,640,400
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 BOX 0,20,120,380
 TEXT HEIGHT =6
 TEXT STYLE =1
 TEXT 2,31,"Plan editieren"
 TEXT STYLE =0
 TEXT 4,44,"Bank :"+ STR$(Bank)
 TEXT 4,52,"Char :"+ STR$(Gew_Zchn)
 BOX 2,35 TO 117,126
 BOX 28,57,64,64
 BITBLT Chspeicher TO 30,59,60,60' AngewÑhlter Char
 BOX 2,130 TO 117,302
 TEXT 4,139,"Bank :"+ STR$(Bankb)
 TEXT 4,147,"Char :"+ STR$(Zeichen-1)+" -"+ STR$(Zeichen)
 FILL COLOR =1
 FILL STYLE =1,1
 BOX 28,150,64,10' Scrollbox Chars nach oben
 BOX 28,160,64,64' Char Zeichen-1
 BOX 28,224,64,64' Char Zeichen
 BOX 28,288,64,10' Scrollbox Chars nach unten
 BOX 2,304 TO 117,397' Textbox
 DRAW 60,152 TO 80,157 TO 40,157 TO 60,152
 FILL 60,153,-1
 DRAW 40,290 TO 80,290 TO 60,295 TO 40,290
 FILL 60,291,-1
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 X=(Zeichen-1-((Zeichen-1)\10)*10)*61+1
 Y=((Zeichen-1)\10)*61+20
 BITBLT X,Y,60,60 TO Chspeicher2
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Chspeicher2 TO 30,162,60,60
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 X=(Zeichen-(Zeichen\10)*10)*61+1
 Y=(Zeichen\10)*61+20
 BITBLT X,Y,60,60 TO Chspeicher2
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Chspeicher2 TO 30,226,60,60
 BOX 123,20 TO 639,399
 BOX 125,22 TO 637,32' Scrollbox Plan nach oben
 BOX 125,34 TO 135,385' Scrollbox Plan nach links
 BOX 627,34 TO 637,385' Scrollbox Plan nach rechts
 BOX 125,387 TO 637,397' Scrollbox Plan nach unten
 DRAW 381,24 TO 422,30 TO 340,30 TO 381,24' Pfeil nach oben
 FILL 381,25,-1
 DRAW 381,395 TO 422,389 TO 340,389 TO 381,395' Pfeil nach unten
 FILL 381,390,-1
 DRAW 127,209 TO 132,250 TO 132,168 TO 127,209' Pfeil nach links
 FILL 128,210,-1
 DRAW 635,209 TO 629,250 TO 629,168 TO 635,209' Pfeil nach rechts
 FILL 630,210,-1
 BOX 139,58 TO 622,361' Rahmen fÅr Plan
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 FOR Xplan=Ppointerx TO Ppointerx+7
 FOR Yplan=Ppointery TO Ppointery+4
 Planzeichnen
 NEXT Yplan
 NEXT Xplan
 TEXT 139,41,"Bank :"+ STR$(Pbank)
 TEXT 225,41,"X :"+ STR$(Ppointerx)+"  "
 TEXT 295,41,"Y :"+ STR$(Ppointery)+"  "
 Xpos2=0
 Ypos2=0
 X2=145
 Y2=61
 BOX 141,60,60,60
 BOX 143,62,56,56
 LINE COLOR =0
 BOX 142,61,58,58
 LINE COLOR =1
 Menu_Bar(Upmenu_Adr)
 FOR T=Ch1setzen TO Loeschenup
 Menu_Icheck(T,0)
 NEXT T
 Menu_Icheck(Ch1setzen+Pmodus,1)
-Mauswartenup
 Czaehler=0
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 IF X<141 OR Y<60 OR X>619 OR Y>358 THEN
 IF X2>140 AND Y2>59 AND X2<620 AND Y2<359 THEN
 IF Czaehler>=2000 AND Czaehler<4000 THEN
 WVBL
 BOX Xpos*60+141,Ypos*60+60,60,60
 BOX Xpos*60+143,Ypos*60+62,56,56
 LINE COLOR =0
 BOX Xpos*60+142,Ypos*60+61,58,58
 WVBL
 LINE COLOR =1
 ENDIF
 MOUSEON
 ENDIF
 ENDIF
 IF X>140 AND Y>59 AND X<620 AND Y<359 THEN '  Mauspfeil innerhalb Planfeld
 IF X2<141 OR Y2<60 OR X2>619 OR Y2>358 THEN MOUSEOFF
 Czaehler=Czaehler+1
 Xpos=(X-141)\60
 Ypos=(Y-60)\60
 IF Xpos<>Xpos2 OR Ypos<>Ypos2 THEN
 Czaehler=0
 Xplan=Xpos2+Ppointerx
 Yplan=Ypos2+Ppointery
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Planzeichnen
 BOX Xpos*60+141,Ypos*60+60,60,60
 BOX Xpos*60+143,Ypos*60+62,56,56
 LINE COLOR =0
 BOX Xpos*60+142,Ypos*60+61,58,58
 LINE COLOR =1
 TEXT 225,41,"X :"+ STR$(Xpos+Ppointerx)+"  "
 TEXT 295,41,"Y :"+ STR$(Ypos+Ppointery)+"  "
 Xpos2=Xpos
 Ypos2=Ypos
 ENDIF
 ENDIF
 IF Czaehler=2000 THEN
 LINE COLOR =0
 WVBL
 BOX Xpos*60+141,Ypos*60+60,60,60
 BOX Xpos*60+143,Ypos*60+62,56,56
 LINE COLOR =1
 BOX Xpos*60+142,Ypos*60+61,58,58
 WVBL
 ENDIF
 IF Czaehler=4000 THEN
 Czaehler=0
 WVBL
 BOX Xpos*60+141,Ypos*60+60,60,60
 BOX Xpos*60+143,Ypos*60+62,56,56
 LINE COLOR =0
 BOX Xpos*60+142,Ypos*60+61,58,58
 WVBL
 LINE COLOR =1
 ENDIF
 X2=X
 Y2=Y
 UNTIL Knopf>0 OR Y<18 AND X<250
 IF Czaehler>=200 AND Czaehler<400 THEN
 WVBL
 BOX Xpos*60+141,Ypos*60+60,60,60
 BOX Xpos*60+143,Ypos*60+62,56,56
 LINE COLOR =0
 BOX Xpos*60+142,Ypos*60+61,58,58
 WVBL
 LINE COLOR =1
 ENDIF
 IF Y<18 AND X<250 THEN ' Menuezeile angewÑhlt
 MOUSEOFF
 MOUSEON
 Evnt_Multi(%10100,0,0,0,1,0,0,320,18,0,0,0,0,0,0,Mesag$,Maske,X,Y,Knopf,Keys,Keybrd,Klicks)
 IF BIT(4,Maske) THEN
 FOR T=1 TO 7
 Message(T)= CVI( MID$(Mesag$,T*2+1,2))
 NEXT T
 MOUSEOFF
 Menu_Tnormal(Message(3),1)
 IF Message(3)=Deskup THEN
 Menu_Bar
 GOSUB Info
 GOTO Pedit
 ENDIF
 IF Message(3)=Modusup THEN GOTO Modusselect
 IF Message(3)=Funktionen THEN GOTO Funktionenselect
-Modusselect
 Menu_Icheck(Pmodus+Ch1setzen,0)
 Pmodus=Message(4)-Ch1setzen
 Menu_Icheck(Pmodus+Ch1setzen,1)
 MOUSEON
 GOTO Mauswartenup
-Funktionenselect
 IF Message(4)=Kopierenup THEN GOTO Kopierenup
 IF Message(4)=Replaceup THEN GOTO Replaceup
 IF Message(4)=Loeschen2up THEN GOTO Loeschen2up
 IF Message(4)=Chaussuchenup THEN GOTO Chausup
 IF Message(4)=Uebersicht THEN GOTO Uebersicht
 IF Message(4)=Baussuchenup THEN GOTO Baussuchenup
 IF Message(4)=Stelle THEN GOTO Stelle
 IF Message(4)=Infofile THEN GOTO Infofile
 IF Message(4)=Hauptmenueup THEN
 Menu_Bar
 CLS
 GOTO Hauptmenue
 ENDIF
 ELSE
 GOTO Mauswartenup
 ENDIF
 ENDIF
 IF X>27 AND Y>149 AND X<91 AND Y<159 OR X>27 AND Y>287 AND X<91 AND Y<297 THEN
                                          ' Chars nach oben/unten verschieben
 REPEAT UNTIL MOUSEBUT =0
 MOUSEOFF
 IF X>27 AND Y>149 AND X<91 AND Y<159 THEN
 Zeichen=Zeichen-2
 IF Zeichen<1 THEN
 Zeichen=60+Zeichen
 Bankb=Bankb-1
 IF Bankb=0 THEN Bankb=3
 ENDIF
 ELSE
 Zeichen=Zeichen+2
 IF Zeichen>59 THEN
 Zeichen=Zeichen-60
 Bankb=Bankb+1
 IF Bankb=4 THEN Bankb=1
 ENDIF
 ENDIF
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Bank(Bankb) TO 0,0,640,400
 X=(Zeichen-1-((Zeichen-1)\10)*10)*61+1
 Y=((Zeichen-1)\10)*61+20
 BITBLT X,Y,60,60 TO Chspeicher2
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Chspeicher2 TO 30,162,60,60
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 X=(Zeichen-(Zeichen\10)*10)*61+1
 Y=(Zeichen\10)*61+20
 BITBLT X,Y,60,60 TO Chspeicher2
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Chspeicher2 TO 30,226,60,60
 TEXT 4,139,"Bank :"+ STR$(Bankb)+"  "
 TEXT 100,147,"  "
 TEXT 4,147,"Char :"+ STR$(Zeichen-1)+" -"+ STR$(Zeichen)
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 IF X>27 AND Y>159 AND X<91 AND Y<223 THEN ' Neuer Char angewÑhlt
 REPEAT UNTIL MOUSEBUT =0
 Gew_Zchn=Zeichen-1
 Bank=Bankb
 MOUSEOFF
 BITBLT 30,162,60,60 TO Chspeicher
 BITBLT Chspeicher TO 30,59,60,60
 TEXT 4,44,"Bank :"+ STR$(Bank)
 TEXT 4,52,"Char :"+ STR$(Gew_Zchn)+"  "
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 IF X>27 AND Y>223 AND X<91 AND Y<287 THEN ' Neuer Char angewÑhlt
 REPEAT UNTIL MOUSEBUT =0
 Gew_Zchn=Zeichen
 Bank=Bankb
 MOUSEOFF
 BITBLT 30,226,60,60 TO Chspeicher
 BITBLT Chspeicher TO 30,59,60,60
 TEXT 4,44,"Bank :"+ STR$(Bank)
 TEXT 4,52,"Char :"+ STR$(Gew_Zchn)+"  "
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 IF X>125 AND Y>22 AND X<637 AND Y<32 THEN ' Planverschiebung nach oben
 IF Ppointery=0 THEN GOTO Mauswartenup
 MOUSEOFF
 Xplan=Xpos+Ppointerx
 Yplan=Ypos+Ppointery
 Xx=141
 Yy=60
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Planzeichnen
 Ppointery=Ppointery-1
 CLIP 141,60 TO 621,359
 BITBLT 141,60,480,241 TO 141,120,480,241
 CLIP
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Yplan=Ppointery
 FOR Xplan=Ppointerx TO Ppointerx+7
 Planzeichnen
 NEXT Xplan
 TEXT 225,41,"X :"+ STR$(Xpos+Ppointerx)+"  "
 TEXT 295,41,"Y :"+ STR$(Ypos+Ppointery)+"  "
 BOX Xpos*60+141,Ypos*60+60,60,60
 BOX Xpos*60+143,Ypos*60+62,56,56
 LINE COLOR =0
 BOX Xpos*60+142,Ypos*60+61,58,58
 LINE COLOR =1
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 IF X>125 AND Y>387 AND X<637 AND Y<397 THEN ' Planverschiebung nach unten
 IF Ppointery=45 THEN GOTO Mauswartenup
 MOUSEOFF
 Xplan=Xpos+Ppointerx
 Yplan=Ypos+Ppointery
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Planzeichnen
 Ppointery=Ppointery+1
 CLIP 141,60 TO 621,359
 BITBLT 141,60,480,300 TO 141,0,480,300
 CLIP
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Yplan=Ppointery+4
 FOR Xplan=Ppointerx TO Ppointerx+7
 Planzeichnen
 NEXT Xplan
 TEXT 225,41,"X :"+ STR$(Xpos+Ppointerx)+"  "
 TEXT 295,41,"Y :"+ STR$(Ypos+Ppointery)+"  "
 BOX Xpos*60+141,Ypos*60+60,60,60
 BOX Xpos*60+143,Ypos*60+62,56,56
 LINE COLOR =0
 BOX Xpos*60+142,Ypos*60+61,58,58
 LINE COLOR =1
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 IF X>125 AND Y>34 AND X<135 AND Y<385 THEN ' Planverschiebung nach links
 IF Ppointerx=0 THEN GOTO Mauswartenup
 MOUSEOFF
 Xplan=Xpos+Ppointerx
 Yplan=Ypos+Ppointery
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Planzeichnen
 Ppointerx=Ppointerx-1
 CLIP 141,60 TO 620,359
 BITBLT 141,60,480,300 TO 201,60,480,300
 CLIP
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Xplan=Ppointerx
 FOR Yplan=Ppointery TO Ppointery+4
 Planzeichnen
 NEXT Yplan
 TEXT 225,41,"X :"+ STR$(Xpos+Ppointerx)+"  "
 TEXT 295,41,"Y :"+ STR$(Ypos+Ppointery)+"  "
 BOX Xpos*60+141,Ypos*60+60,60,60
 BOX Xpos*60+143,Ypos*60+62,56,56
 LINE COLOR =0
 BOX Xpos*60+142,Ypos*60+61,58,58
 LINE COLOR =1
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 IF X>627 AND Y>43 AND X<637 AND Y<385 THEN ' Planverschiebung nach rechts
 IF Ppointerx=72 THEN GOTO Mauswartenup
 MOUSEOFF
 Xplan=Xpos+Ppointerx
 Yplan=Ypos+Ppointery
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Planzeichnen
 Ppointerx=Ppointerx+1
 CLIP 141,60 TO 620,359
 BITBLT 141,60,480,300 TO 81,60,480,300
 CLIP
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Xplan=Ppointerx+7
 FOR Yplan=Ppointery TO Ppointery+4
 Planzeichnen
 NEXT Yplan
 TEXT 225,41,"X :"+ STR$(Xpos+Ppointerx)+"  "
 TEXT 295,41,"Y :"+ STR$(Ypos+Ppointery)+"  "
 BOX Xpos*60+141,Ypos*60+60,60,60
 BOX Xpos*60+143,Ypos*60+62,56,56
 LINE COLOR =0
 BOX Xpos*60+142,Ypos*60+61,58,58
 LINE COLOR =1
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 IF X>140 AND Y>61 AND X<621 AND Y<360 THEN ' Maus innerhalb des Plans
 REPEAT UNTIL MOUSEBUT =0
 MOUSEOFF
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 IF Knopf=2 THEN ' Infos anzeigen
 TEXT 4,312,"Char   :     "
 TEXT 68,312, STR$(Charnr)
 TEXT 4,321,"Char 2 :     "
 TEXT 68,321, STR$(Charnr2)
 TEXT 4,330,"AusgÑnge : "
 TEXT 4,339,"           "
 TEXT 4,348,"           "
 IF BIT(0,Ausgang) THEN TEXT 4,339,"N"
 IF BIT(1,Ausgang) THEN TEXT 16,339,"S"
 IF BIT(2,Ausgang) THEN TEXT 34,339,"W"
 IF BIT(3,Ausgang) THEN TEXT 49,339,"O"
 IF BIT(4,Ausgang) THEN TEXT 4,348,"N"
 IF BIT(5,Ausgang) THEN TEXT 16,348,"S"
 IF BIT(6,Ausgang) THEN TEXT 34,348,"W"
 IF BIT(7,Ausgang) THEN TEXT 49,348,"O"
 TEXT 4,357,"WÑnde :"
 TEXT 4,366,"           "
 IF BIT(0,Wand) THEN TEXT 4,366,"N"
 IF BIT(1,Wand) THEN TEXT 16,366,"S"
 IF BIT(2,Wand) THEN TEXT 34,366,"W"
 IF BIT(3,Wand) THEN TEXT 49,366,"O"
 TEXT 4,375,"Monster :     "
 TEXT 75,375, CHR$(Monster)
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 IF Pmodus=0 THEN ' Char 1 setzen
 Gew_Zchn_Holen
 Charnr=Gew_Zchn
 Banknr=Bank
 Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 IF Pmodus=1 THEN ' Char 2 setzen
 Gew_Zchn_Holen
 Charnr2=Gew_Zchn
 Banknr2=Bank
 Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 IF Pmodus=2 THEN ' AusgÑnge setzen
 Taste$=""
 PRINT "e";
 INPUT @(23,18);"Normal/Geheim (N\G\E) : ";Taste$ USING "+n+g+e+N+G+E>",Var,1
 Taste$= LOWER$(Taste$)
 IF Taste$="e" OR Taste$="" THEN
 PRINT "f";
 Zeile_Loeschen
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Zeile_Loeschen
 Taste2$=""
 INPUT @(23,18);"N/S/W/O : ";Taste2$ USING "+n+s+w+o+N+S+W+O>",Var,1
 Taste2$= LOWER$(Taste2$)
 PRINT "f";
 Zeile_Loeschen
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 IF Taste$="g" THEN
 Pointer=4
 ELSE
 Pointer=0
 ENDIF
 IF Taste2$="n" THEN
   BIT (Pointer,Ausgang)= NOT ( BIT(Pointer,Ausgang))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
   IF Ypos+Ppointery>0 THEN
     Decodiere(Xpos+Ppointerx,Ypos+Ppointery-1,Pbank)
     BIT (Pointer+1,Ausgang)= NOT ( BIT(Pointer+1,Ausgang))
     Codiere(Xpos+Ppointerx,Ypos+Ppointery-1,Pbank)
     IF Ypos>0 THEN
       Xplan=Xpos+Ppointerx
       Yplan=Ypos+Ppointery-1
       Charnr3=-1
       Charnr4=-1
       Banknr3=-1
       Banknr4=-1
       Xx=141
       Yy=60
       Planzeichnen
     ENDIF
   ENDIF
 ENDIF
 IF Taste2$="s" THEN
   BIT (1+Pointer,Ausgang)= NOT ( BIT(1+Pointer,Ausgang))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
   IF Ypos+Ppointery<49 THEN
     Decodiere(Xpos+Ppointerx,Ypos+Ppointery+1,Pbank)
     BIT (Pointer,Ausgang)= NOT ( BIT(Pointer,Ausgang))
     Codiere(Xpos+Ppointerx,Ypos+Ppointery+1,Pbank)
     IF Ypos<4 THEN
       Xplan=Xpos+Ppointerx
       Yplan=Ypos+Ppointery+1
       Charnr3=-1
       Charnr4=-1
       Banknr3=-1
       Banknr4=-1
       Xx=141
       Yy=60
       Planzeichnen
     ENDIF
   ENDIF
 ENDIF
 IF Taste2$="w" THEN
   BIT (Pointer+2,Ausgang)= NOT ( BIT(Pointer+2,Ausgang))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
   IF Xpos+Xpointery>0 THEN
     Decodiere(Xpos+Ppointerx-1,Ypos+Ppointery,Pbank)
     BIT (Pointer+3,Ausgang)= NOT ( BIT(Pointer+3,Ausgang))
     Codiere(Xpos+Ppointerx-1,Ypos+Ppointery,Pbank)
     IF Xpos>0 THEN
       Xplan=Xpos+Ppointerx-1
       Yplan=Ypos+Ppointery
       Charnr3=-1
       Charnr4=-1
       Banknr3=-1
       Banknr4=-1
       Xx=141
       Yy=60
       Planzeichnen
     ENDIF
   ENDIF
 ENDIF
 IF Taste2$="o" THEN
   BIT (Pointer+3,Ausgang)= NOT ( BIT(Pointer+3,Ausgang))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
   IF Xpos+Ppointerx<79 THEN
     Decodiere(Xpos+Ppointerx+1,Ypos+Ppointery,Pbank)
     BIT (Pointer+2,Ausgang)= NOT ( BIT(Pointer+2,Ausgang))
     Codiere(Xpos+Ppointerx+1,Ypos+Ppointery,Pbank)
     IF Xpos<7 THEN
       Xplan=Xpos+Ppointerx+1
       Yplan=Ypos+Ppointery
       Charnr3=-1
       Charnr4=-1
       Banknr3=-1
       Banknr4=-1
       Xx=141
       Yy=60
       Planzeichnen
     ENDIF
   ENDIF
 ENDIF
 ENDIF
 IF Pmodus=3 THEN ' WÑnde setzen
 Taste$=""
 PRINT "e";
 INPUT @(23,18);"N/S/W/O/E : ";Taste$ USING "+n+s+w+o+e+N+S+W+O+E>",Var,1
 Taste$= LOWER$(Taste$)
 PRINT "f";
 Zeile_Loeschen
 IF Taste$="e" OR Taste$="" THEN
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 IF Taste$="n" THEN
   BIT (0,Wand)= NOT ( BIT(0,Wand))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
   IF Ypos+Ppointery>0 THEN
     Decodiere(Xpos+Ppointerx,Ypos+Ppointery-1,Pbank)
     BIT (1,Wand)= NOT ( BIT(1,Wand))
     Codiere(Xpos+Ppointerx,Ypos+Ppointery-1,Pbank)
     IF Ypos>0 THEN
       Xplan=Xpos+Ppointerx
       Yplan=Ypos+Ppointery-1
       Charnr3=-1
       Charnr4=-1
       Banknr3=-1
       Banknr4=-1
       Xx=141
       Yy=60
       Planzeichnen
     ENDIF
   ENDIF
 ENDIF
 IF Taste$="s" THEN
   BIT (1,Wand)= NOT ( BIT(1,Wand))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
   IF Ypos+Ppointery<49 THEN
     Decodiere(Xpos+Ppointerx,Ypos+Ppointery+1,Pbank)
     BIT (0,Wand)= NOT ( BIT(0,Wand))
     Codiere(Xpos+Ppointerx,Ypos+Ppointery+1,Pbank)
     IF Ypos<4 THEN
       Xplan=Xpos+Ppointerx
       Yplan=Ypos+Ppointery+1
       Charnr3=-1
       Charnr4=-1
       Banknr3=-1
       Banknr4=-1
       Xx=141
       Yy=60
       Planzeichnen
     ENDIF
   ENDIF
 ENDIF
 IF Taste$="w" THEN
   BIT (2,Wand)= NOT ( BIT(2,Wand))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
   IF Xpos+Ppointerx>0 THEN
     Decodiere(Xpos+Ppointerx-1,Ypos+Ppointery,Pbank)
     BIT (3,Wand)= NOT ( BIT(3,Wand))
     Codiere(Xpos+Ppointerx-1,Ypos+Ppointery,Pbank)
     IF Xpos>0 THEN
       Xplan=Xpos+Ppointerx-1
       Yplan=Ypos+Ppointery
       Charnr3=-1
       Charnr4=-1
       Banknr3=-1
       Banknr4=-1
       Xx=141
       Yy=60
       Planzeichnen
     ENDIF
   ENDIF
 ENDIF
 IF Taste$="o" THEN
   BIT (3,Wand)= NOT ( BIT(3,Wand))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
   IF Xpos+Ppointerx<79 THEN
     Decodiere(Xpos+Ppointerx+1,Ypos+Ppointery,Pbank)
     BIT (2,Wand)= NOT ( BIT(2,Wand))
     Codiere(Xpos+Ppointerx+1,Ypos+Ppointery,Pbank)
     IF Xpos<7 THEN
       Xplan=Xpos+Ppointerx+1
       Yplan=Ypos+Ppointery
       Charnr3=-1
       Charnr4=-1
       Banknr3=-1
       Banknr4=-1
       Xx=141
       Yy=60
       Planzeichnen
     ENDIF
   ENDIF
 ENDIF
 ENDIF
 IF Pmodus=4 THEN ' Ecken setzen
 Taste$=""
 PRINT "e";
 INPUT @(23,18);"NW/NO/SW/SO/E : ";Taste$ USING "+n+s+w+o+e+N+S+W+O+E>",Var,2
 Taste$= LOWER$(Taste$)
 PRINT "f";
 Zeile_Loeschen
 IF Taste$="e" OR Taste$="" THEN
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 IF Taste$="nw" THEN
   BIT (4,Wand)= NOT ( BIT(4,Wand))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 IF Taste$="no" THEN
   BIT (5,Wand)= NOT ( BIT(5,Wand))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 IF Taste$="sw" THEN
   BIT (6,Wand)= NOT ( BIT(6,Wand))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 IF Taste$="so" THEN
   BIT (7,Wand)= NOT ( BIT(7,Wand))
   Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 ENDIF
 IF Pmodus=5 THEN ' Monster setzen
 Taste$=""
 PRINT "e";
 INPUT @(23,18);"Zeichen : ";Taste$ USING "0a+*>",Var,1
 PRINT "f";
 Zeile_Loeschen
 IF Taste$="e" OR Taste$="E" OR Taste$="" THEN
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 Monster= ASC(Taste$)
 IF Taste$="*" OR Taste$="" THEN Monster=0
 Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 IF Pmodus=6 THEN ' Infos setzen
 Taste$=""
 PRINT "e";
 INPUT @(23,18);"Zahl : ";Taste$ USING "0>",Var,2
 PRINT "f";
 Taste= VAL(Taste$)
 Zeile_Loeschen
 IF Taste=0 THEN
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 IF Taste=99 THEN Taste=0
 Infos=Taste
 Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 IF Pmodus=7 THEN ' Felder lîschen
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 IF ( BIT(0,Wand) OR BIT(0,Ausgang) OR BIT(4,Ausgang)) AND Ypos+Ppointery>0 THEN
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery-1,Pbank)
 BIT (1,Wand)=0
 BIT (1,Ausgang)=0
 BIT (5,Ausgang)=0
 Codiere(Xpos+Ppointerx,Ypos+Ppointery-1,Pbank)
 IF Ypos>0 THEN
 Xplan=Xpos+Ppointerx
 Yplan=Ypos+Ppointery-1
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Planzeichnen
 ENDIF
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 IF ( BIT(1,Wand) OR BIT(1,Ausgang) OR BIT(5,Ausgang)) AND Ypos+Ppointery<49 THEN
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery+1,Pbank)
 BIT (0,Wand)=0
 BIT (0,Ausgang)=0
 BIT (4,Ausgang)=0
 Codiere(Xpos+Ppointerx,Ypos+Ppointery+1,Pbank)
 IF Ypos<4 THEN
 Xplan=Xpos+Ppointerx
 Yplan=Ypos+Ppointery+1
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Planzeichnen
 ENDIF
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 IF ( BIT(2,Wand) OR BIT(2,Ausgang) OR BIT(6,Ausgang)) AND Xpos+Ppointerx>0 THEN
 Decodiere(Xpos+Ppointerx-1,Ypos+Ppointery,Pbank)
 BIT (3,Wand)=0
 BIT (3,Ausgang)=0
 BIT (7,Ausgang)=0
 Codiere(Xpos+Ppointerx-1,Ypos+Ppointery,Pbank)
 IF Xpos>0 THEN
 Xplan=Xpos+Ppointerx-1
 Yplan=Ypos+Ppointery
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Planzeichnen
 ENDIF
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 IF ( BIT(3,Wand) OR BIT(3,Ausgang) OR BIT(7,Ausgang)) AND Xpos+Ppointerx<79 THEN
 Decodiere(Xpos+Ppointerx+1,Ypos+Ppointery,Pbank)
 BIT (2,Wand)=0
 BIT (2,Ausgang)=0
 BIT (6,Ausgang)=0
 Codiere(Xpos+Ppointerx+1,Ypos+Ppointery,Pbank)
 IF Xpos<7 THEN
 Xplan=Xpos+Ppointerx+1
 Yplan=Ypos+Ppointery
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Planzeichnen
 ENDIF
 Decodiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 Charnr=-1
 Charnr2=-1
 Banknr=1
 Banknr2=1
 Wand=0
 Ausgang=0
 Monster=0
 Infos=0
 Codiere(Xpos+Ppointerx,Ypos+Ppointery,Pbank)
 ENDIF
 Xplan=Xpos+Ppointerx
 Yplan=Ypos+Ppointery
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xx=141
 Yy=60
 Planzeichnen
 BOX Xpos*60+141,Ypos*60+60,60,60
 BOX Xpos*60+143,Ypos*60+62,56,56
 LINE COLOR =0
 BOX Xpos*60+142,Ypos*60+61,58,58
 LINE COLOR =1
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 MOUSEON
 REPEAT UNTIL MOUSEBUT =0
 GOTO Mauswartenup
-Uebersicht
 Menu_Bar
 CLS
 Uebersicht_Darstellen
 MOUSEON
 REPEAT UNTIL INKEY$ >"" OR MOUSEBUT >0
 REPEAT UNTIL INKEY$ ="" AND MOUSEBUT =0
 MOUSEOFF
 GOTO Pedit
-Kopierenup
 Kopie=1
 Bereich_Aussuchen
 Kopie=0
 Xabst=Xpos2-Xpos
 Yabst=Ypos2-Ypos
 LINE STYLE =3
 BOX Xpos*8,Ypos*8 TO Xpos2*8,Ypos2*8
 LINE STYLE =1
 REPEAT
 Xpos3= MOUSEX \8
 Ypos3= MOUSEY \8
 Knopf= MOUSEBUT
 IF Xpos3+Xabst>79 THEN Xpos3=79-Xabst
 IF Ypos3+Yabst>49 THEN Ypos3=49-Yabst
 BOX Xpos3*8,Ypos3*8,Xabst*8+1,Yabst*8+1
 BOX Xpos3*8,Ypos3*8,Xabst*8+1,Yabst*8+1
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 MODE =1
 IF Knopf=2 THEN GOTO Pedit
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Bank(Pbank) TO 0,0,640,400
 BITBLT Xpos*8,Ypos*8,Xabst*8,Yabst*8 TO Xpos3*8,Ypos3*8,Xabst*8,Yabst*8
 BITBLT 0,0,640,400 TO Bank(Pbank)
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 IF Ypos3>0 THEN
 Y=Ypos3
 FOR X=Xpos3 TO Xpos3+Xabst
 Decodiere(X,Y,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X,Y-1,Pbank)
 IF BIT(0,Wand2) OR BIT(0,Ausgang2) OR BIT(4,Ausgang2) OR BIT(1,Wand) OR BIT(1,Ausgang) OR BIT(5,Ausgang) THEN
 IF BIT(0,Wand2) THEN BIT (1,Wand)=-1
 IF BIT(0,Ausgang2) THEN BIT (1,Ausgang)=-1
 IF BIT(4,Ausgang2) THEN BIT (5,Ausgang)=-1
 Codiere(X,Y-1,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X,Y,Pbank)
 IF BIT(1,Wand2) THEN BIT (0,Wand)=-1
 IF BIT(1,Ausgang2) THEN BIT (0,Ausgang)=-1
 IF BIT(5,Ausgang2) THEN BIT (4,Ausgang)=-1
 Codiere(X,Y,Pbank)
 ENDIF
 NEXT X
 ENDIF
 IF Ypos3+Yabst<49 THEN
 Y=Ypos3+Yabst-1
 FOR X=Xpos3 TO Xpos3+Xabst
 Decodiere(X,Y,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X,Y+1,Pbank)
 IF BIT(1,Wand2) OR BIT(1,Ausgang2) OR BIT(5,Ausgang2) OR BIT(0,Wand) OR BIT(0,Ausgang) OR BIT(4,Ausgang) THEN
 IF BIT(1,Wand2) THEN BIT (0,Wand)=-1
 IF BIT(1,Ausgang2) THEN BIT (0,Ausgang)=-1
 IF BIT(5,Ausgang2) THEN BIT (4,Ausgang)=-1
 Codiere(X,Y+1,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X,Y,Pbank)
 IF BIT(0,Wand2) THEN BIT (1,Wand)=-1
 IF BIT(0,Ausgang2) THEN BIT (1,Ausgang)=-1
 IF BIT(4,Ausgang2) THEN BIT (5,Ausgang)=-1
 Codiere(X,Y,Pbank)
 ENDIF
 NEXT X
 ENDIF
 IF Xpos3>0 THEN
 X=Xpos3
 FOR Y=Ypos3 TO Ypos3+Yabst
 Decodiere(X,Y,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X-1,Y,Pbank)
 IF BIT(2,Wand2) OR BIT(2,Ausgang2) OR BIT(6,Ausgang2) OR BIT(3,Wand) OR BIT(3,Ausgang) OR BIT(7,Ausgang) THEN
 IF BIT(2,Wand2) THEN BIT (3,Wand)=-1
 IF BIT(2,Ausgang2) THEN BIT (3,Ausgang)=-1
 IF BIT(6,Ausgang2) THEN BIT (7,Ausgang)=-1
 Codiere(X-1,Y,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X,Y,Pbank)
 IF BIT(3,Wand2) THEN BIT (2,Wand)=-1
 IF BIT(3,Ausgang2) THEN BIT (2,Ausgang)=-1
 IF BIT(7,Ausgang2) THEN BIT (6,Ausgang)=-1
 Codiere(X,Y,Pbank)
 ENDIF
 NEXT Y
 ENDIF
 IF Xpos3+Xabst<79 THEN
 X=Xpos3+Xabst-1
 FOR Y=Ypos3 TO Ypos3+Yabst
 Decodiere(X,Y,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X+1,Y,Pbank)
 IF BIT(3,Wand2) OR BIT(3,Ausgang2) OR BIT(7,Ausgang2) OR BIT(2,Wand) OR BIT(2,Ausgang) OR BIT(6,Ausgang) THEN
 IF BIT(3,Wand2) THEN BIT (2,Wand)=-1
 IF BIT(3,Ausgang2) THEN BIT (2,Ausgang)=-1
 IF BIT(7,Ausgang2) THEN BIT (6,Ausgang)=-1
 Codiere(X+1,Y,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X,Y,Pbank)
 IF BIT(2,Wand2) THEN BIT (3,Wand)=-1
 IF BIT(2,Ausgang2) THEN BIT (3,Ausgang)=-1
 IF BIT(6,Ausgang2) THEN BIT (7,Ausgang)=-1
 Codiere(X,Y,Pbank)
 ENDIF
 NEXT Y
 ENDIF
 GOTO Pedit
-Replaceup
 PRINT "e";
 Taste$=""
 INPUT @(23,18);"Replace Char : ";Taste$ USING "0+E+e",Var,2
 Zeile_Loeschen
 IF LOWER$(Taste$)="e" THEN
 PRINT "f";
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Taste1= VAL(Taste$)
 IF Taste1>59 OR Taste1<0 THEN
 PRINT "f";
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Taste$=""
 INPUT @(23,18);"Bank : ";Taste$ USING "0+E+e",Var,1
 Zeile_Loeschen
 IF LOWER$(Taste$)="e" THEN
 PRINT "f";
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Taste2= VAL(Taste$)
 IF Taste2>3 OR Taste2<1 THEN
 PRINT "f";
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Taste$=""
 INPUT @(23,18);"Replace by : ";Taste$ USING "0+E+e",Var,2
 Zeile_Loeschen
 IF LOWER$(Taste$)="e" THEN
 PRINT "f";
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Taste3= VAL(Taste$)
 IF Taste3>59 OR Taste3<0 THEN
 PRINT "f";
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Taste$=""
 INPUT @(23,18);"Bank : ";Taste$ USING "0+E+e",Var,1
 Zeile_Loeschen
 PRINT "f";
 IF LOWER$(Taste$)="e" THEN
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Taste4= VAL(Taste$)
 IF Taste4>3 OR Taste4<1 THEN
 MOUSEON
 GOTO Mauswartenup
 ENDIF
 Repl=1
 Bereich_Aussuchen
 MODE =1
 FOR Y=Ypos TO Ypos2-1
 FOR X=Xpos TO Xpos2-1
 Repl=0
 Decodiere(X,Y,Pbank)
 IF Charnr=Taste1 AND Banknr=Taste2 OR Charnr2=Taste1 AND Banknr2=Taste2 THEN
 IF Charnr=Taste1 AND Banknr=Taste2 THEN
 Charnr=Taste3
 Banknr=Taste4
 ENDIF
 IF Charnr2=Taste1 AND Banknr2=Taste2 THEN
 Charnr2=Taste3
 Banknr2=Taste4
 ENDIF
 Codiere(X,Y,Pbank)
 ENDIF
 NEXT X
 NEXT Y
 GOTO Pedit
-Loeschen2up
 Loesch=1
 Bereich_Aussuchen
 Xabst=Xpos2-Xpos
 Yabst=Ypos2-Ypos
 Loesch=0
 MODE =1
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Bank(Pbank) TO 0,0,640,400
 BITBLT Xpos*8,Ypos*8,Xabst*8,Yabst*8 TO Xpos*8,Ypos*8,Xabst*8,Yabst*8,0
 BITBLT 0,0,640,400 TO Bank(Pbank)
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 IF Ypos>0 THEN
 Y=Ypos
 FOR X=Xpos TO Xpos+Xabst
 Decodiere(X,Y-1,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X,Y,Pbank)
 IF BIT(1,Wand2) THEN BIT (0,Wand)=-1
 IF BIT(1,Ausgang2) THEN BIT (0,Ausgang)=-1
 IF BIT(5,Ausgang2) THEN BIT (4,Ausgang)=-1
 Codiere(X,Y,Pbank)
 NEXT X
 ENDIF
 IF Ypos+Yabst<49 THEN
 Y=Ypos+Yabst-1
 FOR X=Xpos TO Xpos+Xabst
 Decodiere(X,Y+1,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X,Y,Pbank)
 IF BIT(0,Wand2) THEN BIT (1,Wand)=-1
 IF BIT(0,Ausgang2) THEN BIT (1,Ausgang)=-1
 IF BIT(4,Ausgang2) THEN BIT (5,Ausgang)=-1
 Codiere(X,Y,Pbank)
 NEXT X
 ENDIF
 IF Xpos>0 THEN
 X=Xpos
 FOR Y=Ypos TO Ypos+Yabst
 Decodiere(X-1,Y,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X,Y,Pbank)
 IF BIT(3,Wand2) THEN BIT (2,Wand)=-1
 IF BIT(3,Ausgang2) THEN BIT (2,Ausgang)=-1
 IF BIT(7,Ausgang2) THEN BIT (6,Ausgang)=-1
 Codiere(X,Y,Pbank)
 NEXT Y
 ENDIF
 IF Xpos+Xabst<79 THEN
 X=Xpos+Xabst-1
 FOR Y=Ypos TO Ypos+Yabst
 Decodiere(X+1,Y,Pbank)
 Wand2=Wand
 Ausgang2=Ausgang
 Decodiere(X,Y,Pbank)
 IF BIT(2,Wand2) THEN BIT (3,Wand)=-1
 IF BIT(2,Ausgang2) THEN BIT (3,Ausgang)=-1
 IF BIT(6,Ausgang2) THEN BIT (7,Ausgang)=-1
 Codiere(X,Y,Pbank)
 NEXT Y
 ENDIF
 GOTO Pedit
-Chausup
 Menu_Bar
-Chausup2
 Zeichen_Holen
 IF Over=1 THEN Over=0: GOTO Chausup2
 Zeichen=-1
 Bankb=-1
 GOTO Pedit
-Baussuchenup
 Bbanknr=4
-Baussuchenup2
 CLS
 Uebersicht_Darstellen(Bbanknr)
 PRINT "KBank aussuchen     Bank :"; STR$(Bbanknr)
 PRINT @(0,40);"Weiter   ZurÅck   Ende"
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 451,0 TO 451,17
 MOUSEON
-Baussuchenup3
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Bbanknr=Bbanknr+1
 IF Bbanknr=Maxbank+1 THEN Bbanknr=4
 GOTO Baussuchenup2
 ENDIF
 IF X>451 THEN Pbank=Bbanknr: GOTO Pedit
 Bbanknr=Bbanknr-1
 IF Bbanknr=3 THEN Bbanknr=Maxbank
 GOTO Baussuchenup2
 ENDIF
 GOTO Baussuchenup3
-Stelle
 Menu_Bar
 CLS
 Uebersicht_Darstellen
 MODE =3
 REPEAT
 X= MOUSEX \8
 Y= MOUSEY \8
 IF X>72 THEN X=72
 IF Y>45 THEN Y=45
 Knopf= MOUSEBUT
 BOX X*8,Y*8,65,41
 BOX X*8,Y*8,65,41
 UNTIL Knopf>0
 MODE =1
 IF Knopf=2 THEN GOTO Pedit
 Ppointerx=X
 Ppointery=Y
 GOTO Pedit
-Infofile
 Menu_Bar
 CLS
 A$(1)="Infofile aussuchen"
 Zentriere(1)
 IF Infopath$="" THEN Infopath$="A:\PLANMAKE.R\DATAS\"
 Infopath$=Infopath$+"*.TXT"
 MOUSEON
 FILESELECT (Infopath$,Infofile$,Flag)
 MOUSEOFF
 IF Infofile$="" OR Flag=0 THEN GOTO Pedit
 Infopath$= LEFT$(Infopath$, LEN(Infopath$)- INSTR( MIRROR$(Infopath$),"\")+1)
 GOTO Pedit
-Pspeichern
 Sbanknr=4
 FOR T=1 TO Maxbank-3
 Speichern%F(T)=0
 NEXT T
-Pspeichern2
 CLS
 Uebersicht_Darstellen(Sbanknr)
-Pspeichern3
 PRINT @(0,0);"KPlan speichern     Bank :"; STR$(Sbanknr)
 IF Speichern%F(Sbanknr-3) THEN
 Speichern$="Weiter  pspeichernq  Ende"
 ELSE
 Speichern$="Weiter  speichern  Ende"
 ENDIF
 PRINT @(0,40);Speichern$
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 458,0 TO 458,17
 MOUSEON
-Pspeichern4
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Sbanknr=Sbanknr+1
 IF Sbanknr=Maxbank+1 THEN Sbanknr=4
 GOTO Pspeichern2
 ENDIF
 IF X>458 THEN
 FOR T=1 TO Maxbank-3
 IF Speichern%F(T) THEN
 CLS
 A$(1)="Plan speichern"
 A$(2)="Bank :"+ STR$(T+3)
 Zentriere(2)
 Path$= LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\")+1)+"*.PLN"
 Name$=""
 MOUSEON
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 IF Flag=0 OR Name$="" THEN GOTO Pspeichern5
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\")+1)
 CLS
 BSAVE Name$,Bank(T+3)+6,32000
 ENDIF
-Pspeichern5
 NEXT T
 GOTO Hauptmenue
 ENDIF
 Speichern%F(Sbanknr-3)= NOT (Speichern%F(Sbanknr-3))
 GOTO Pspeichern3
 ENDIF
 GOTO Pspeichern4
-Pladen
 Sbanknr=4
 FOR T=1 TO Maxbank-3
 Speichern%F(T)=0
 NEXT T
-Pladen2
 CLS
 IF Anfang=0 THEN Uebersicht_Darstellen(Sbanknr)
-Pladen3
 PRINT @(0,0);"KPlan laden     Bank :"; STR$(Sbanknr)
 IF Speichern%F(Sbanknr-3) THEN
 Speichern$="Weiter    pladenq    Ende"
 ELSE
 Speichern$="Weiter    laden    Ende"
 ENDIF
 PRINT @(0,40);Speichern$
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 458,0 TO 458,17
 MOUSEON
-Pladen4
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Sbanknr=Sbanknr+1
 IF Sbanknr=Maxbank+1 THEN Sbanknr=4
 GOTO Pladen2
 ENDIF
 IF X>458 THEN
 FOR T=1 TO Maxbank-3
 IF Speichern%F(T) THEN
 Anfang=0
 CLS
 A$(1)="Plan laden"
 A$(2)="Bank :"+ STR$(T+3)
 Zentriere(2)
 Change_Ext("*.PLN")
 Name$=""
 MOUSEON
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 IF Flag=0 OR Name$="" THEN GOTO Pladen5
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\")+1)
 CLS
 BLOAD Name$,Bank(T+3)+6
 ENDIF
-Pladen5
 NEXT T
 GOTO Hauptmenue
 ENDIF
 Speichern%F(Sbanknr-3)= NOT (Speichern%F(Sbanknr-3))
 GOTO Pladen3
 ENDIF
 GOTO Pladen3
-Pzeigen
 Bbanknr=4
-Pzeigen2
 CLS
 Uebersicht_Darstellen(Bbanknr)
 PRINT "KPlan zeigen     Bank :"; STR$(Bbanknr)
 PRINT @(0,40);"Weiter   ZurÅck   Ende"
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 451,0 TO 451,17
 MOUSEON
-Pzeigen3
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Bbanknr=Bbanknr+1
 IF Bbanknr=Maxbank+1 THEN Bbanknr=4
 GOTO Pzeigen2
 ENDIF
 IF X>451 THEN GOTO Hauptmenue
 Bbanknr=Bbanknr-1
 IF Bbanknr=3 THEN Bbanknr=Maxbank
 GOTO Pzeigen2
 ENDIF
 GOTO Pzeigen3
-Ploeschen
 Lbanknr=4
 Loeschen=0
-Ploeschen2
 CLS
 Uebersicht_Darstellen(Lbanknr)
-Ploeschen3
 PRINT @(0,0);"KPlan lîschen     Bank :"; STR$(Lbanknr)
 IF Loeschen=0 THEN
 Loesch$="Weiter  Lîschen   Ende"
 ELSE
 Loesch$="Weiter  pLîschenq   Ende"
 ENDIF
 PRINT @(0,40);Loesch$
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 451,0 TO 451,17
 MOUSEON
-Ploeschen4
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Loeschen=0
 Lbanknr=Lbanknr+1
 IF Lbanknr=Maxbank+1 THEN Lbanknr=4
 GOTO Ploeschen2
 ENDIF
 IF X>451 THEN GOTO Hauptmenue
 IF Loeschen=0 THEN
 Loeschen=1
 GOTO Ploeschen3
 ELSE
 CLS
 BITBLT 0,0,640,400 TO Bank(Lbanknr)
 Loeschen=0
 GOTO Ploeschen3
 ENDIF
 ENDIF
 GOTO Ploeschen4
-Spdrucken
 Bbanknr=4
-Spdrucken2
 CLS
 Uebersicht_Darstellen(Bbanknr)
 PRINT "KBank aussuchen     Bank :"; STR$(Bbanknr)
 PRINT @(0,40);"Weiter   ZurÅck   Ende"
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 451,0 TO 451,17
 MOUSEON
-Spdrucken3
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Bbanknr=Bbanknr+1
 IF Bbanknr=9 THEN Bbanknr=4
 GOTO Spdrucken2
 ENDIF
 IF X>451 THEN GOTO Spdrucken4
 Bbanknr=Bbanknr-1
 IF Bbanknr=3 THEN Bbanknr=8
 GOTO Spdrucken2
 ENDIF
 GOTO Spdrucken3
-Spdrucken4
 Uebersicht_Darstellen2(Bbanknr)
 Druck=1
 Bereich_Aussuchen2
 MODE =1
 IF Knopf=2 THEN GOTO Hauptmenue
 IF Druck%F(0) THEN OPEN "v",1 ELSE OPEN "p",1
 FOR T=0 TO 5' Zeilenvorschub einstellen
 IF Drucker%B(T,0)>0 THEN PRINT #1, CHR$(Drucker%B(T,0));
 NEXT T
 CLIP 0,0,640,400
 Xx=0
 Yy=0
 Ppx=Ppointerx
 Ppy=Ppointery
 REPEAT UNTIL INKEY$ =""
 FOR Yd1=0 TO (Ypos2-Ypos-1)\6
 FOR Xd1=0 TO (Xpos2-Xpos-1)\10
 IF INKEY$ >"" THEN
 REPEAT UNTIL INKEY$ =""
 EXIT TO Spdrucken5
 ENDIF
 CLS
 FOR Xd2=0 TO MIN(9,Xpos2-Xpos-1-Xd1*10)
 FOR Yd2=0 TO MIN(5,Ypos2-Ypos-1-Yd1*6)
 Charnr3=-1
 Charnr4=-1
 Banknr3=-1
 Banknr4=-1
 Xplan=Xpos+Xd1*10+Xd2
 Yplan=Ypos+Yd1*6+Yd2
 Ppointerx=Xpos+Xd1*10
 Ppointery=Ypos+Yd1*6
 Planzeichnen
 NEXT Yd2
 NEXT Xd2
 IF Rand AND Yd1<(Ypos2-Ypos-1)\6 THEN DRAW 0,360 TO 20,379 TO 580,379 TO 599,360
 IF Xd1=0 THEN DRAW 0,0 TO 0,359
 IF Yd1=0 THEN DRAW 0,0 TO 599,0
 IF Xd1=(Xpos2-Xpos-1)\10 THEN DRAW (Xpos2-Xpos-Xd1*10)*60-1,0 TO (Xpos2-Xpos-Xd1*10)*60-1,359
 IF Yd1=(Ypos2-Ypos-1)\6 THEN DRAW 0,(Ypos2-Ypos-Yd1*6)*60-1 TO 599,(Ypos2-Ypos-Yd1*6)*60-1
 FOR Xp=0 TO 74
 FOR T=0 TO 5
 IF Drucker%B(T,1)>0 THEN PRINT #1, CHR$(Drucker%B(T,1));' Grafikdruck ein
 NEXT T
 FOR T=0 TO 5
 IF Drucker%B(T,2)>0 THEN PRINT #1, CHR$(Drucker%B(T,2));' Anzahl Grafikbytes pro Zeile
 NEXT T
 FOR Yp=Bild1+Xp+80*379 TO Bild1+Xp STEP -80
 IF Druck%F(1) THEN
   PRINT #1, CHR$( PEEK(Yp)); CHR$( PEEK(Yp));
 ELSE
   PRINT #1, CHR$( PEEK(Yp));
 ENDIF
 NEXT Yp
 FOR T=0 TO 5
 IF Drucker%B(T,4)>0 THEN PRINT #1, CHR$(Drucker%B(T,4));' LF + CR
 NEXT T
 NEXT Xp
 NEXT Xd1
 FOR T=0 TO 5
 IF Drucker%B(T,4)>0 THEN PRINT #1, CHR$(Drucker%B(T,4));' LF + CR
 NEXT T
 NEXT Yd1
 Ppointerx=Ppx
 Ppointery=Ppy
-Spdrucken5
 Druck=0
 CLOSE 1
 GOTO Hauptmenue
-Gpdrucken
 Bbanknr=4
-Gpdrucken2
 CLS
 Uebersicht_Darstellen(Bbanknr)
 PRINT "KBank aussuchen     Bank :"; STR$(Bbanknr)
 PRINT @(0,40);"Weiter   ZurÅck   Ende"
 BOX 306,0 TO 508,17
 DRAW 379,0 TO 379,17
 DRAW 451,0 TO 451,17
 MOUSEON
-Gpdrucken3
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF X>306 AND X<508 AND Y<18 THEN
 MOUSEOFF
 IF X<379 THEN
 Bbanknr=Bbanknr+1
 IF Bbanknr=9 THEN Bbanknr=4
 GOTO Gpdrucken2
 ENDIF
 IF X>451 THEN GOTO Gpdrucken4
 Bbanknr=Bbanknr-1
 IF Bbanknr=3 THEN Bbanknr=8
 GOTO Gpdrucken2
 ENDIF
 GOTO Gpdrucken3
-Gpdrucken4
 Uebersicht_Darstellen2(Bbanknr)
 Druck=1
 Bereich_Aussuchen2
 MODE =1
 IF Knopf=2 THEN GOTO Hauptmenue
 IF Druck%F(0) THEN OPEN "v",1 ELSE OPEN "p",1
 FOR T=0 TO 5' Zeilenvorschub einstellen
 IF Drucker%B(T,0)>0 THEN PRINT #1, CHR$(Drucker%B(T,0));
 NEXT T
 Xx=1
 Yy=1
 Ppx=Ppointerx
 Ppy=Ppointery
 TEXT HEIGHT =4
 REPEAT UNTIL INKEY$ =""
 FOR Yd1=0 TO (Ypos2-Ypos-1)\26
 FOR Xd1=0 TO (Xpos2-Xpos-1)\40
 IF INKEY$ >"" THEN
 REPEAT UNTIL INKEY$ =""
 EXIT TO Gpdrucken5
 ENDIF
 CLS
 FOR Xd2=0 TO MIN(39,Xpos2-Xpos-1-Xd1*40)
 FOR Yd2=0 TO MIN(25,Ypos2-Ypos-1-Yd1*26)
 X=Xpos+Xd1*40+Xd2
 Y=Ypos+Yd1*26+Yd2
 Decodiere(X,Y,Bbanknr)
 X=(X-Xpos-Xd1*40)*15
 Y=(Y-Ypos-Yd1*26)*15
 IF Charnr>-1 OR Charnr2>-1 THEN BOX X,Y,16,16
 IF Wand>0 THEN
 IF BIT(0,Wand) THEN DRAW X,Y+1 TO X+15,Y+1
 IF BIT(1,Wand) THEN DRAW X,Y+14 TO X+15,Y+14
 IF BIT(2,Wand) THEN DRAW X+1,Y TO X+1,Y+15
 IF BIT(3,Wand) THEN DRAW X+14,Y TO X+14,Y+15
 IF BIT(4,Wand) THEN DRAW X+1,Y+1
 IF BIT(5,Wand) THEN DRAW X+14,Y+1
 IF BIT(6,Wand) THEN DRAW X+1,Y+14
 IF BIT(7,Wand) THEN DRAW X+14,Y+14
 ENDIF
 IF Ausgang>0 THEN
 LINE COLOR =0
 IF BIT(0,Ausgang) THEN DRAW X+4,Y TO X+11,Y
 IF BIT(1,Ausgang) THEN DRAW X+4,Y+15 TO X+11,Y+15
 IF BIT(2,Ausgang) THEN DRAW X,Y+4 TO X,Y+11
 IF BIT(3,Ausgang) THEN DRAW X+15,Y+4 TO X+15,Y+11
 IF BIT(4,Ausgang) THEN
 FOR X2=X+4 TO X+11 STEP 2
 DRAW X2,Y
 NEXT X2
 ENDIF
 IF BIT(5,Ausgang) THEN
 FOR X2=X+4 TO X+11 STEP 2
 DRAW X2,Y+15
 NEXT X2
 ENDIF
 IF BIT(6,Ausgang) THEN
 FOR Y2=Y+4 TO Y+11 STEP 2
 DRAW X,Y2
 NEXT Y2
 ENDIF
 IF BIT(7,Ausgang) THEN
 FOR Y2=Y+4 TO Y+11 STEP 2
 DRAW X+15,Y2
 NEXT Y2
 ENDIF
 LINE COLOR =1
 ENDIF
 IF Monster>0 THEN TEXT X+5,Y+6, CHR$(Monster)
 IF Infos>0 THEN TEXT X+2,Y+12, RIGHT$( STR$(Infos), LEN( STR$(Infos))-1)
 NEXT Yd2
 NEXT Xd2
 FOR Xp=0 TO 74
 FOR T=0 TO 5' Grafikdruck ein
 IF Drucker%B(T,1)>0 THEN PRINT #1, CHR$(Drucker%B(T,1));
 NEXT T
 FOR T=0 TO 5' Anzahl der Grafikbytes
 IF Drucker%B(T,3)>0 THEN PRINT #1, CHR$(Drucker%B(T,3));
 NEXT T
 FOR Yp=Bild1+Xp+80*390 TO Bild1+Xp STEP -80
 PRINT #1, CHR$( PEEK(Yp)); CHR$( PEEK(Yp));
 NEXT Yp
 FOR T=0 TO 5' LF + CR
 IF Drucker%B(T,4)>0 THEN PRINT #1, CHR$(Drucker%B(T,4));
 NEXT T
 NEXT Xp
 NEXT Xd1
 FOR T=0 TO 5' LF + CR
 IF Drucker%B(T,4)>0 THEN PRINT #1, CHR$(Drucker%B(T,4));
 NEXT T
 NEXT Yd1
 Druck=0
 CLOSE 1
 IF Infofile$>"" THEN
 CHDIR Infopath$
 OPEN "i",1,Infofile$
 OPEN "p",2
 WHILE NOT ( EOF(1))
 LINE INPUT #1,Text$
 PRINT #2,Text$
 WEND
 CLOSE 1
 CLOSE 2
 ENDIF
 Ppointerx=Ppx
 Ppointery=Ppy
-Gpdrucken5
 GOTO Hauptmenue
-Danpassung
 CLS
 A$(1)="Druckeranpassung"
 Zentriere(1)
 PRINT "B"*2
 PRINT TAB (24);"Druckerport :    Druckbytes    :"
 PRINT TAB (24);
 IF Druck%F(0) THEN PRINT "Seriell          "; ELSE PRINT "Parallel         ";
 IF Druck%F(1) THEN PRINT "Doppelt" ELSE PRINT "Einfach"
 PRINT
 PRINT TAB (24);"Zeilenvorschub auf 24/180 Zoll :"
 PRINT TAB (24);
 Ausgabe(0)
 PRINT TAB (24);"Grafikdruck ein :"
 PRINT TAB (24);
 Ausgabe(1)
 PRINT TAB (24);"380 bzw. 760 Bytes Grafikdaten :"
 PRINT TAB (24);
 Ausgabe(2)
 PRINT TAB (24);"391 bzw. 782 Bytes Grafikdaten :"
 PRINT TAB (24);
 Ausgabe(3)
 PRINT TAB (24);"Line Feed + Carriage Return :"
 PRINT TAB (24);
 Ausgabe(4)
 PRINT TAB (24);"   Speichern         ZurÅck"
 FOR T=0 TO 5
 BOX 187,62+T*48,264,36
 BOX 188,63+T*48,262,34
 DRAW 188,79+T*48 TO 450,79+T*48
 NEXT T
 BOX 187,350,262,20
 BOX 188,351,260,18
 DRAW 319,64 TO 319,95
 DRAW 320,64 TO 320,95
 DRAW 319,352 TO 319,367
 DRAW 320,352 TO 320,367
 MOUSEON
-Mauswartenud
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 Knopf=0
 IF X>187 AND X<451 THEN
 FOR T=1 TO 6
 IF Y>62+(T-1)*48 AND Y<98+(T-1)*48 THEN
 Knopf=T
 EXIT
 ENDIF
 NEXT T
 IF Y>350 AND Y<370 THEN Knopf=7
 ENDIF
 IF Knopf=0 THEN GOTO Mauswartenud
 MOUSEOFF
 IF Knopf=1 THEN
   IF X<319 THEN
     Druck%F(0)= NOT (Druck%F(0))
     PRINT @(5,24);
     IF Druck%F(0) THEN
       PRINT "Seriell "
     ELSE
       PRINT "Parallel"
     ENDIF
   ELSE
     Druck%F(1)= NOT (Druck%F(1))
     PRINT @(5,41);
     IF Druck%F(1) THEN
       PRINT "Doppelt"
     ELSE
       PRINT "Einfach"
     ENDIF
   ENDIF
 MOUSEON
 GOTO Mauswartenud
 ENDIF
 IF Knopf>1 AND Knopf<7 THEN
   Eingabe(Knopf-1)
   MOUSEON
   GOTO Mauswartenud
 ENDIF
 IF Knopf=7 THEN
   IF X<320 THEN
     CHDIR Anfpath$
     OPEN "o",1,"Drucker.inf"
     PRINT #1,Druck%F(0)
     PRINT #1,Druck%F(1)
     FOR Y=0 TO 5
       FOR X=0 TO 4
         PRINT #1, CHR$(Drucker%B(Y,X));
       NEXT X
     NEXT Y
     CLOSE 1
     MOUSEON
     GOTO Mauswartenud
   ELSE
     GOTO Hauptmenue
   ENDIF
 ENDIF
-Info
 Form_Center(Info_Adr,X,Y,B,H)
 Form_Dial(0,X,Y,B,H)
 Objc_Draw(0,1,X,Y,B,H,Info_Adr)
 MOUSEON
 Form_Do(0,Info_Adr,Button)
 MOUSEOFF
 Form_Dial(3,X,Y,B,H)
 IF Button=Inanleit THEN
   CLS
   CHDIR "A:\PLANMAKE.R\DATAS\PRGDATAS"
   OPEN "i",1,"PLANMAKE.TXT"
   Lcounter=0
   WHILE NOT EOF(1)
   Lcounter=Lcounter+1
   LINE INPUT #1,Infotext$
   PRINT LEFT$(Infotext$,79)
   IF Lcounter MOD 23=0 THEN
   PRINT @(24,0);"<SPACE> : Weiter      <RETURN> : Ende";
   Taste$= INPUT$(1)
   IF ASC(Taste$)=13 THEN EXIT TO Info2
   CLS
   ENDIF
   WEND
   PRINT @(24,0);"<SPACE> : Weiter";
   Taste$= INPUT$(1)
  -Info2
   CLOSE 1
 ENDIF
 CLS
 Objc_Change(Button,0,0,0,0,0,Info_Adr)
 RETURN
-Ende
 IPL 3
 Rsrc_Free
 Appl_Exit
 CLEAR 0,512
 END
-Fehler
 Text$="[3][ | Ein Fehler ist aufgetreten ! | | "+ ERR$ +" | in"+ STR$( ERL )
 Text$=Text$+"][NEUVERSUCH|WEITER|ENDE]"
 Graf_Growbox(0,0,20,20,260,150,120,100)
 MOUSEON
 FORM_ALERT (1,Text$,Knopf)
 MOUSEOFF
 Graf_Shrinkbox(0,0,20,20,260,150,120,100)
 IF ERR =65 THEN CHDIR "A:\"
 IF Knopf=1 THEN RESUME
 IF Knopf=2 THEN RESUME NEXT
 IF Knopf=3 THEN
 CLS
 IPL 3
 Rsrc_Free
 Appl_Exit
 STOP
 ENDIF
 Rsrc_Free
 Appl_Exit
 END
 DEF PROC Zentriere(A)
 LOCAL T
 FOR T=1 TO A
 IF LEFT$(A$(T),1)="" THEN
 PRINT SPC(40-( LEN(A$(T))-1)/2);"p";
 A$(T)= RIGHT$(A$(T), LEN(A$(T))-1)
 PRINT A$(T);"q"
 ELSE
 PRINT SPC(40- LEN(A$(T))/2);A$(T)
 ENDIF
 NEXT T
 RETURN
 DEF PROC Resourcedefs
 Planmaker=0
 Charedit=1
 Planedit=2
 Infodial=3
 Desk=3
 Chars=4
 Plan=5
 Disk=6
 Drucken=7
 Info=10
 Chedit=19
 Chanzeigen=20
 Chloeschen=21
 Pedit=23
 Pzeigen=24
 Ploeschen=25
 Chladen=27
 Chspeichern=28
 Pladen=30
 Pspeichern=31
 Spdrucken=33
 Gpdrucken=34
 Klebrand=35
 Danpassung=37
 Ende=39
 Deskuch=3
 Charsuch=4
 Funktionenuch=5
 Specialsuch=6
 Infouch=9
 Chholenuch=18
 Chspeichernuch=19
 Chloeschenuch=20
 Chinvert=21
 Zeichnen=23
 Fuellen=24
 Linien=25
 Rechteck=26
 Kreis=27
 Ellipsen=28
 Faussuchen=30
 Fedit=31
 Verschieben=33
 Drehen=34
 Spiegeln=35
 Spray=36
 Grab=38
 Hauptmenueuch=40
 Deskup=3
 Modusup=4
 Funktionen=5
 Infoup=8
 Ch1setzen=17
 Ch2setzen=18
 Ausgsetzen=19
 Waendesetzen=20
 Ecksetzen=21
 Mosetzen=22
 Insetzen=23
 Loeschenup=24
 Kopierenup=26
 Replaceup=27
 Loeschen2up=28
 Chaussuchenup=30
 Baussuchenup=31
 Uebersicht=32
 Stelle=33
 Infofile=35
 Hauptmenueup=37
 Inweiter=5
 Inanleit=6
 RETURN
 DEF PROC Load_Rsc
 Counter=0
-Load_Rsc_Hmenue2
 CHDIR "A:\PLANMAKE.R\DATAS\PRGDATAS"
 Rsrc_Load("PLANMAKE.RSC",Check)
 IF Check<>1 THEN
 PRINT "pFehler beim laden der Resource-Dateiq"
 CLS
 Taste$= INPUT$(1)
 Counter=Counter+1
 IF Counter<3 THEN GOTO Load_Rsc_Hmenue2
 Appl_Exit
 END
 ENDIF
 Rsrc_Gaddr(0,Planmaker,Hmenu_Adr)
 Rsrc_Gaddr(0,Charedit,Uchmenu_Adr)
 Rsrc_Gaddr(0,Planedit,Upmenu_Adr)
 Rsrc_Gaddr(0,Infodial,Info_Adr)
 RETURN
 DEF PROC Codiere(X,Y,Bank)
 IF Bank<4 OR X>79 OR Y>49 THEN
 PRINT "pFehler beim codierenq"
 Taste$= INPUT$(1)
 Appl_Exit
 END
 ENDIF
 LOCAL Adresse
 Adresse=Bank(Bank)+6+Y*640+X
 Charnr=Charnr+60*(Banknr-1)
 Charnr2=Charnr2+60*(Banknr2-1)
 POKE Adresse,Charnr+1
 POKE Adresse+80,Charnr2+1
 POKE Adresse+160,Ausgang
 POKE Adresse+240,Wand
 POKE Adresse+320,Infos
 POKE Adresse+400,Monster
 RETURN
 DEF PROC Decodiere(X,Y,Bank)
 IF Bank<4 OR X>79 OR Y>49 THEN
 PRINT "pFehler beim decodierenq"
 Taste$= INPUT$(1)
 Rsrc_Free
 Appl_Exit
 END
 ENDIF
 Xdec=X
 Ydec=Y
 LOCAL Adresse
 IF Y=Ydec+1 AND X=Xdec THEN
   Adresse=Adresse+640
 ELSE
   IF Y=Ydec AND X=Xdec+1 THEN
     Adresse=Adresse+1
   ELSE
     Adresse=Bank(Bank)+6+Y*640+X
   ENDIF
 ENDIF
 Charnr= PEEK(Adresse)-1
 Charnr2= PEEK(Adresse+80)-1
 Ausgang= PEEK(Adresse+160)
 ' Bit 0 : Norden
 ' Bit 1 : SÅden
 ' Bit 2 : Westen
 ' Bit 3 : Osten
 Wand= PEEK(Adresse+240)
 Infos= PEEK(Adresse+320)
 Monster= PEEK(Adresse+400)
 Banknr=Charnr\60+1
 Banknr2=Charnr2\60+1
 Charnr=Charnr-60*(Banknr-1)
 Charnr2=Charnr2-60*(Banknr2-1)
 RETURN
 DEF PROC Planzeichnen
 Decodiere(Xplan,Yplan,Pbank)
 IF Charnr>-1 OR Charnr2>-1 THEN
 IF Charnr=-1 THEN Charnr=Charnr2:Banknr=Banknr2
 IF Charnr2=-1 THEN Charnr2=Charnr:Banknr2=Banknr
 IF NOT (Charnr=Charnr3 AND Charnr2=Charnr4 AND Banknr=Banknr3 AND Banknr2=Banknr4) THEN
 XBIOS (,5, HIGH(Bank(Banknr)+6), LOW(Bank(Banknr)+6), HIGH(Bild1), LOW(Bild1),-1)
 X2plan=(Charnr-(Charnr\10)*10)*61+1
 Y2plan=(Charnr\10)*61+20
 BITBLT X2plan,Y2plan,60,60 TO Chspeicher
 IF Charnr2<>Charnr OR Banknr2<>Banknr THEN
 XBIOS (,5, HIGH(Bank(Banknr2)+6), LOW(Bank(Banknr2)+6), HIGH(Bild1), LOW(Bild1),-1)
 X2plan=(Charnr2-(Charnr2\10)*10)*61+1
 Y2plan=(Charnr2\10)*61+20
 BITBLT X2plan,Y2plan,60,60 TO Chspeicher2
 ENDIF
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 ENDIF
 ENDIF
 Xp_Ppx=(Xplan-Ppointerx)*60
 Yp_Ppy=(Yplan-Ppointery)*60
 IF Charnr>-1 THEN BITBLT Chspeicher TO Xx+Xp_Ppx,Yy+Yp_Ppy,60,60
 IF Charnr2<>Charnr OR Banknr2<>Banknr THEN BITBLT Chspeicher2 TO Xx+Xp_Ppx,Yy+Yp_Ppy,60,60,7
 IF Charnr=-1 THEN
 LINE COLOR =0
 FILL COLOR =0
 PBOX Xx+Xp_Ppx,Yy+Yp_Ppy,60,60
 LINE COLOR =1
 FILL COLOR =1
 ENDIF
 IF Wand>0 THEN
 IF BIT(0,Wand) THEN
 LINE COLOR =0
 DRAW Xx+Xp_Ppx,Yy+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+Yp_Ppy
 DRAW Xx+Xp_Ppx,Yy+1+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+1+Yp_Ppy
 LINE COLOR =1
 DRAW Xx+Xp_Ppx,Yy+2+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+2+Yp_Ppy
 DRAW Xx+Xp_Ppx,Yy+3+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+3+Yp_Ppy
 ENDIF
 IF BIT(1,Wand) THEN
 LINE COLOR =0
 DRAW Xx+Xp_Ppx,Yy+59+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+59+Yp_Ppy
 DRAW Xx+Xp_Ppx,Yy+58+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+58+Yp_Ppy
 LINE COLOR =1
 DRAW Xx+Xp_Ppx,Yy+57+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+57+Yp_Ppy
 DRAW Xx+Xp_Ppx,Yy+56+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+56+Yp_Ppy
 ENDIF
 IF BIT(2,Wand) THEN
 LINE COLOR =0
 DRAW Xx+Xp_Ppx,Yy+Yp_Ppy TO Xx+Xp_Ppx,Yy+59+Yp_Ppy
 DRAW Xx+1+Xp_Ppx,Yy+Yp_Ppy TO Xx+1+Xp_Ppx,Yy+59+Yp_Ppy
 LINE COLOR =1
 DRAW Xx+2+Xp_Ppx,Yy+Yp_Ppy TO Xx+2+Xp_Ppx,Yy+59+Yp_Ppy
 DRAW Xx+3+Xp_Ppx,Yy+Yp_Ppy TO Xx+3+Xp_Ppx,Yy+59+Yp_Ppy
 IF BIT(0,Wand) THEN
 LINE COLOR =0
 DRAW Xx+Xp_Ppx,Yy+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+Yp_Ppy
 DRAW Xx+Xp_Ppx,Yy+1+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+1+Yp_Ppy
 LINE COLOR =1
 ENDIF
 IF BIT(1,Wand) THEN
 LINE COLOR =0
 DRAW Xx+Xp_Ppx,Yy+59+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+59+Yp_Ppy
 DRAW Xx+Xp_Ppx,Yy+58+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+58+Yp_Ppy
 LINE COLOR =1
 ENDIF
 ENDIF
 IF BIT(3,Wand) THEN
 LINE COLOR =0
 DRAW Xx+59+Xp_Ppx,Yy+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+59+Yp_Ppy
 DRAW Xx+58+Xp_Ppx,Yy+Yp_Ppy TO Xx+58+Xp_Ppx,Yy+59+Yp_Ppy
 LINE COLOR =1
 DRAW Xx+57+Xp_Ppx,Yy+Yp_Ppy TO Xx+57+Xp_Ppx,Yy+59+Yp_Ppy
 DRAW Xx+56+Xp_Ppx,Yy+Yp_Ppy TO Xx+56+Xp_Ppx,Yy+59+Yp_Ppy
 IF BIT(0,Wand) THEN
 LINE COLOR =0
 DRAW Xx+Xp_Ppx,Yy+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+Yp_Ppy
 DRAW Xx+Xp_Ppx,Yy+1+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+1+Yp_Ppy
 LINE COLOR =1
 ENDIF
 IF BIT(1,Wand) THEN
 LINE COLOR =0
 DRAW Xx+Xp_Ppx,Yy+59+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+59+Yp_Ppy
 DRAW Xx+Xp_Ppx,Yy+58+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+58+Yp_Ppy
 LINE COLOR =1
 ENDIF
 ENDIF
 IF BIT(4,Wand) THEN
 LINE COLOR =0
 FILL COLOR =0
 PBOX Xx+Xp_Ppx,Yy+Yp_Ppy,4,4
 LINE COLOR =1
 FILL COLOR =1
 DRAW Xx+2+Xp_Ppx,Yy+Yp_Ppy TO Xx+2+Xp_Ppx,Yy+2+Yp_Ppy TO Xx+Xp_Ppx,Yy+2+Yp_Ppy
 DRAW Xx+3+Xp_Ppx,Yy+Yp_Ppy TO Xx+3+Xp_Ppx,Yy+3+Yp_Ppy TO Xx+Xp_Ppx,Yy+3+Yp_Ppy
 ENDIF
 IF BIT(5,Wand) THEN
 LINE COLOR =0
 FILL COLOR =0
 PBOX Xx+56+Xp_Ppx,Yy+Yp_Ppy,4,4
 LINE COLOR =1
 FILL COLOR =1
 DRAW Xx+57+Xp_Ppx,Yy+Yp_Ppy TO Xx+57+Xp_Ppx,Yy+2+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+2+Yp_Ppy
 DRAW Xx+56+Xp_Ppx,Yy+Yp_Ppy TO Xx+56+Xp_Ppx,Yy+3+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+3+Yp_Ppy
 ENDIF
 IF BIT(6,Wand) THEN
 LINE COLOR =0
 FILL COLOR =0
 PBOX Xx+Xp_Ppx,Yy+56+Yp_Ppy,4,4
 LINE COLOR =1
 FILL COLOR =1
 DRAW Xx+2+Xp_Ppx,Yy+59+Yp_Ppy TO Xx+2+Xp_Ppx,Yy+57+Yp_Ppy TO Xx+Xp_Ppx,Yy+57+Yp_Ppy
 DRAW Xx+3+Xp_Ppx,Yy+59+Yp_Ppy TO Xx+3+Xp_Ppx,Yy+56+Yp_Ppy TO Xx+Xp_Ppx,Yy+56+Yp_Ppy
 ENDIF
 IF BIT(7,Wand) THEN
 LINE COLOR =0
 FILL COLOR =0
 PBOX Xx+56+Xp_Ppx,Yy+56+Yp_Ppy,4,4
 LINE COLOR =1
 FILL COLOR =1
 DRAW Xx+57+Xp_Ppx,Yy+59+Yp_Ppy TO Xx+57+Xp_Ppx,Yy+57+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+57+Yp_Ppy
 DRAW Xx+56+Xp_Ppx,Yy+59+Yp_Ppy TO Xx+56+Xp_Ppx,Yy+56+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+56+Yp_Ppy
 ENDIF
 ENDIF
 IF Ausgang>0 THEN IF Druck<>1 THEN
 IF BIT(0,Ausgang) OR BIT(4,Ausgang) THEN
 LINE COLOR =0
 FILL COLOR =0
 PBOX Xx+15+Xp_Ppx,Yy+Yp_Ppy,30,4
 LINE COLOR =1
 FILL COLOR =1
 DRAW Xx+15+Xp_Ppx,Yy+Yp_Ppy TO Xx+15+Xp_Ppx,Yy+3+Yp_Ppy
 DRAW Xx+44+Xp_Ppx,Yy+Yp_Ppy TO Xx+44+Xp_Ppx,Yy+3+Yp_Ppy
 IF BIT(4,Ausgang) THEN
 LINE STYLE =3
 DRAW Xx+16+Xp_Ppx,Yy+Yp_Ppy TO Xx+43+Xp_Ppx,Yy+Yp_Ppy
 LINE STYLE =1
 ENDIF
 ENDIF
 IF BIT(1,Ausgang) OR BIT(5,Ausgang) THEN
 LINE COLOR =0
 FILL COLOR =0
 PBOX Xx+15+Xp_Ppx,Yy+56+Yp_Ppy,30,4
 LINE COLOR =1
 FILL COLOR =1
 DRAW Xx+15+Xp_Ppx,Yy+56+Yp_Ppy TO Xx+15+Xp_Ppx,Yy+59+Yp_Ppy
 DRAW Xx+44+Xp_Ppx,Yy+56+Yp_Ppy TO Xx+44+Xp_Ppx,Yy+59+Yp_Ppy
 IF BIT(5,Ausgang) THEN
 LINE STYLE =3
 DRAW Xx+16+Xp_Ppx,Yy+59+Yp_Ppy TO Xx+43+Xp_Ppx,Yy+59+Yp_Ppy
 LINE STYLE =1
 ENDIF
 ENDIF
 IF BIT(2,Ausgang) OR BIT(6,Ausgang) THEN
 LINE COLOR =0
 FILL COLOR =0
 PBOX Xx+Xp_Ppx,Yy+15+Yp_Ppy,4,30
 LINE COLOR =1
 FILL COLOR =1
 DRAW Xx+Xp_Ppx,Yy+15+Yp_Ppy TO Xx+3+Xp_Ppx,Yy+15+Yp_Ppy
 DRAW Xx+Xp_Ppx,Yy+44+Yp_Ppy TO Xx+3+Xp_Ppx,Yy+44+Yp_Ppy
 IF BIT(6,Ausgang) THEN
 LINE STYLE =3
 DRAW Xx+Xp_Ppx,Yy+16+Yp_Ppy TO Xx+Xp_Ppx,Yy+43+Yp_Ppy
 LINE STYLE =1
 ENDIF
 ENDIF
 IF BIT(3,Ausgang) OR BIT(7,Ausgang) THEN
 LINE COLOR =0
 FILL COLOR =0
 PBOX Xx+55+Xp_Ppx,Yy+15+Yp_Ppy,4,30
 LINE COLOR =1
 FILL COLOR =1
 DRAW Xx+56+Xp_Ppx,Yy+15+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+15+Yp_Ppy
 DRAW Xx+56+Xp_Ppx,Yy+44+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+44+Yp_Ppy
 IF BIT(7,Ausgang) THEN
 LINE STYLE =3
 DRAW Xx+59+Xp_Ppx,Yy+16+Yp_Ppy TO Xx+59+Xp_Ppx,Yy+43+Yp_Ppy
 LINE STYLE =1
 ENDIF
 ENDIF
 ENDIF
 IF Monster>0 THEN IF Druck<>1 THEN TEXT Xx+5+Xp_Ppx,Yy+54+Yp_Ppy, CHR$(Monster)
 IF Infos>0 THEN IF Druck<>1 THEN TEXT Xx+32+Xp_Ppx,Yy+54+Yp_Ppy, RIGHT$( STR$(Infos), LEN( STR$(Infos))-1)
 IF Charnr=-1 THEN IF Charnr2=-1 THEN RETURN
 Charnr3=Charnr
 Charnr4=Charnr2
 Banknr3=Banknr
 Banknr4=Banknr2
 RETURN
 DEF PROC Char_Holen(Zeichen,Bank)
 XBIOS (,5, HIGH(Bank(Bank)), LOW(Bank(Bank)), HIGH(Bild1), LOW(Bild1),-1)
 Xchar=(Zeichen-(Zeichen\10)*10)*61+1
 Ychar=(Zeichen\10)*61+20
 BITBLT Xchar,Ychar,60,60 TO Chspeicher
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 RETURN
 DEF PROC Gew_Zchn_Holen
 Char_Holen(Gew_Zchn,Bank)
 RETURN
 DEF PROC Zeile_Loeschen
 PRINT @(23,18);"K";
 WVBL
 BOX 627,34 TO 637,385
 DRAW 639,350 TO 639,385
 RETURN
 DEF PROC Uebersicht_Darstellen
 Uebersicht_Darstellen(Pbank)
 RETURN
 DEF PROC Uebersicht_Darstellen(Ubank)
 Uebersicht_Darstellen(Ubank,0,0,79,49)
 RETURN
 DEF PROC Uebersicht_Darstellen2(Ubank)
 PRINT "HK"
 PRINT "K"
 Ueber2=1
 Uebersicht_Darstellen(Ubank,0,0,79,3)
 Ueber2=0
 RETURN
 DEF PROC Uebersicht_Darstellen(Ubank,X1,Y1,X2,Y2)
 IF Ueber2=0 THEN CLS
 CLIP 0,0,640,400
 FOR X=X1 TO X2
 FOR Y=Y1 TO Y2
 Adresse=Bank(Ubank)+6+Y*640+X
 IF PEEK(Adresse)>0 OR PEEK(Adresse+80)>0 OR PEEK(Adresse+240)>0 THEN
 Decodiere(X,Y,Ubank)
 X3=X*8
 Y3=Y*8
 IF Charnr>0 OR Charnr2>0 THEN BOX X3,Y3,9,9
 IF Wand>0 THEN
 IF BIT(0,Wand) THEN DRAW X3,Y3+1 TO X3+8,Y3+1
 IF BIT(1,Wand) THEN DRAW X3,Y3+7 TO X3+8,Y3+7
 IF BIT(2,Wand) THEN DRAW X3+1,Y3 TO X3+1,Y3+8
 IF BIT(3,Wand) THEN DRAW X3+7,Y3 TO X3+7,Y3+8
 IF BIT(4,Wand) THEN DRAW X3+1,Y3+1
 IF BIT(5,Wand) THEN DRAW X3+7,Y3+1
 IF BIT(6,Wand) THEN DRAW X3+1,Y3+7
 IF BIT(7,Wand) THEN DRAW X3+7,Y3+7
 ENDIF
 IF Ausgang>0 THEN
 LINE COLOR =0
 IF BIT(0,Ausgang) OR BIT(4,Ausgang) THEN DRAW X3+3,Y3 TO X3+5,Y3
 IF BIT(1,Ausgang) OR BIT(5,Ausgang) THEN DRAW X3+3,Y3+8 TO X3+5,Y3+8
 IF BIT(2,Ausgang) OR BIT(6,Ausgang) THEN DRAW X3,Y3+3 TO X3,Y3+5
 IF BIT(3,Ausgang) OR BIT(7,Ausgang) THEN DRAW X3+8,Y3+3 TO X3+8,Y3+5
 LINE COLOR =1
 ENDIF
 IF Repl=1 AND (Taste1=Charnr AND Taste2=Banknr OR Taste1=Charnr2 AND Taste2=Banknr2) THEN
 DRAW X3,Y3 TO X3+8,Y3+8
 DRAW X3+8,Y3 TO X3,Y3+8
 ENDIF
 ENDIF
 NEXT Y
 NEXT X
 CLIP
 RETURN
 DEF PROC Bereich_Aussuchen
 Menu_Bar
 CLS
 Uebersicht_Darstellen
 Bereich_Aussuchen2
 RETURN
 DEF PROC Bereich_Aussuchen2
 MOUSEON
 MODE =3
 CLIP 0,0,640,400
 Text$=""
 IF Kopie=1 THEN Text$="Kopieren"
 IF Loesch=1 THEN Text$="Lîschen"
 IF Repl=1 THEN Text$="Ersetzen"
 X2= MOUSEX
 Y2= MOUSEY
 TEXT X2+50,Y2+10,Text$
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 IF X<>X2 OR Y<>Y2 THEN
 IF X-X2>10 THEN MOUSEOFF
 TEXT X2+50,Y2+10,Text$
 TEXT X+50,Y+10,Text$
 IF X-X2>10 THEN MOUSEON
 X2=X
 Y2=Y
 ENDIF
 UNTIL Knopf>0
 TEXT X+50,Y+10,Text$
 MOUSEOFF
 CLIP
 IF Knopf=2 THEN
 Kopie=0
 Loesch=0
 Repl=0
 MODE =1
 REPEAT UNTIL MOUSEBUT =0
 IF Druck=0 THEN GOTO Pedit ELSE GOTO Hauptmenue
 ENDIF
 Xpos=X\8
 Ypos=Y\8
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Xpos2=X\8
 Ypos2=Y\8
 IF Xpos2<=Xpos THEN Xpos2=Xpos+1
 IF Ypos2<=Ypos THEN Ypos2=Ypos+1
 BOX Xpos*8,Ypos*8 TO Xpos2*8,Ypos2*8
 BOX Xpos*8,Ypos*8 TO Xpos2*8,Ypos2*8
 UNTIL MOUSEBUT =0
 RETURN
 DEF PROC Zeichen_Holen
 CLS
 BITBLT Bank(Bank) TO 0,0,640,400
 MODE =3
 Xpos2=( MOUSEX -1)\61
 Ypos2=( MOUSEY -20)\61
 IF Xpos2>9 THEN Xpos2=9
 IF Ypos2>5 THEN Ypos2=5
 BOX Xpos2*61+1,Ypos2*61+20,60,60
 Zaehler=0
 Text$="Char holen       Bank Nr."+ STR$(Bank)+"     Char Nr."
 PRINT @(0,0);Text$; STR$(Ypos2*10+Xpos2);"K"
 Y2= MOUSEY
 IF Y2<18 THEN MOUSEON
 REPEAT
 X= MOUSEX
 Y1= MOUSEY
 IF Y1>18 THEN Zaehler=Zaehler+1
 IF Y1>=18 AND Y2<18 THEN
 MOUSEOFF
 Y2=Y1
 ELSE
 IF Y1<18 AND Y2>=18 THEN
 MOUSEON
 Y2=Y1
 ENDIF
 ENDIF
 Knopf= MOUSEBUT
 IF Y1>18 THEN
 Xpos1=(X-1)\61
 Ypos1=(Y1-20)\61
 IF Xpos1>9 THEN Xpos1=9
 IF Ypos1>5 THEN Ypos1=5
 IF Xpos1<>Xpos2 OR Ypos1<>Ypos2 THEN
 IF Zaehler<3000 THEN
     BOX Xpos2*61+1,Ypos2*61+20,60,60
   ELSE
     BOX Xpos2*61+2,Ypos2*61+21,58,58
 ENDIF
 BOX Xpos1*61+1,Ypos1*61+20,60,60
 Zaehler=0
 PRINT @(0,0);Text$; STR$(Ypos1*10+Xpos1);"K"
 Xpos2=Xpos1
 Ypos2=Ypos1
 ENDIF
 ENDIF
 IF Zaehler=3000 THEN
 BOX Xpos2*61+1,Ypos2*61+20,60,60
 BOX Xpos2*61+2,Ypos2*61+21,58,58
 Zaehler=Zaehler+1
 ENDIF
 IF Zaehler=6000 THEN
 BOX Xpos2*61+2,Ypos2*61+21,58,58
 BOX Xpos2*61+1,Ypos2*61+20,60,60
 Zaehler=0
 ENDIF
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 IF Y1<18 THEN
 MOUSEOFF
 ELSE
   IF Zaehler<3000 THEN
     BOX Xpos1*61+1,Ypos1*61+20,60,60
   ELSE
     BOX Xpos1*61+2,Ypos1*61+21,58,58
   ENDIF
 ENDIF
 MODE =1
 IF Knopf=2 THEN RETURN
 IF Knopf=1 AND Y1<18 THEN
 Bank=Bank+1
 IF Bank=4 THEN Bank=1
 Over=1
 Zaehler=0
 RETURN
 ENDIF
 BITBLT Xpos1*61+1,Ypos1*61+20,60,60 TO Chspeicher
 Gew_Zchn=Ypos1*10+Xpos1
 RETURN
 DEF PROC Get_Path
 LOCAL Drive,A
 GEMDOS (Drive,25)
 Path$= CHR$(0)*66
 A= LPEEK( VARPTR(Path$))+ LPEEK( SEGPTR +28)
 GEMDOS (,71, HIGH(A), LOW(A),Drive+1)
 Path$= LEFT$(Path$, INSTR(Path$, CHR$(0))-1)
 Path$= CHR$(Drive+65)+":"+Path$+"\"
 RETURN
 DEF PROC Change_Ext(Ext$)
 Path$= LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))+"\"+Ext$
 RETURN
 DEF PROC Eingabe(Knopf)
 PRINT @(5+Knopf*3,24);
 Ein$=""
 FOR T=0 TO 5
 IF Drucker%B(T,Knopf-1)>0 THEN Ein$=Ein$+ STR$(Drucker%B(T,Knopf-1))
 NEXT T
 PRINT "e";
 INPUT "";Ein$ USING "0a%^+ ",Var,31
 PRINT "f";
 Zeiger=1
 Drucker=0
 Fehler=0
 Zahl=0
 FOR T=0 TO 5
   Drucker%B(T,5)=0
 NEXT T
 WHILE Zeiger<= LEN(Ein$)
 A$= MID$(Ein$,Zeiger,1)
 A= VAL(A$)
 IF A$<>" " THEN
   IF A>0 AND A<10 OR A$="0" THEN
     Zahl=10*Zahl+ VAL(A$)
   ELSE
     Zahl=0
     Drucker%B(Drucker,5)= ASC(A$)
     Drucker=Drucker+1
   ENDIF
 ELSE
   IF Zahl>0 THEN
     IF Zahl<=255 THEN
       Drucker%B(Drucker,5)=Zahl
       Drucker=Drucker+1
     ELSE
       PRINT CHR$(7);
       Zeiger= LEN(Ein$)
       Fehler=1
     ENDIF
     Zahl=0
   ENDIF
 ENDIF
 IF Drucker>5 THEN
   PRINT CHR$(7);
   Zeiger= LEN(Ein$)
   Fehler=1
 ENDIF
 Zeiger=Zeiger+1
 WEND
 IF Fehler=0 THEN
 IF Zahl>0 AND Zahl<256 THEN Drucker%B(Drucker,5)=Zahl
 FOR T=0 TO 5
   Drucker%B(T,Knopf-1)=Drucker%B(T,5)
 NEXT T
 ENDIF
 PRINT @(5+Knopf*3,24);
 Ausgabe(Knopf-1)
 RETURN
 DEF PROC Ausgabe(Knopf)
 FOR T=0 TO 5
 IF Drucker%B(T,Knopf)>0 THEN PRINT Drucker%B(T,Knopf);
 NEXT T
 WHILE NOT ( POS(0)=56)
 PRINT " ";
 WEND
 PRINT
 PRINT
 RETURN
-Dfehler
 IF ERR =53 THEN Er=1 ELSE ON ERROR GOTO Fehler: RESUME
 RESUME NEXT
 LIBRARY CODE Gem
