 GOTO Anfang
 DEF PROC Input_Zeichen(Abst)
 Taste$=""
 PRINT "e"; TAB (Abst);
 INPUT "Neue Taste : ";Taste$ USING "0a>",Var,1
 PRINT "f"
 PRINT TAB (Abst);"AK";"A";"Neue Taste : ";Taste$
 RETURN
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
-Scrolltext
 DATA "","","","RUNNING POINTS"
 DATA "","by the","COOK SOFT COMPANY","in 1991","",""
 DATA "Programming , Soundfx","Michael Koch",""
 DATA "Programmiersprache :","compiliertes OMIKRON.Basic",""
 DATA "Die Anleitung","steht in der Datei","R_POINTS.TXT",""
 DATA "Viel Spaž !","","ENDE"
-Statanf
 PRINT "H";
 PRINT "Spieler 1: B";
 N=3- LEN( STR$(Anzb1))
 PRINT SPC(N);
 PRINT STR$(Anzb1);
 PRINT "  S";
 N=3- LEN( STR$(Anzs1))
 PRINT SPC(N);
 PRINT STR$(Anzs1);
 PRINT "|";
 PRINT "Spieler 2: B";
 N=3- LEN( STR$(Anzb2))
 PRINT SPC(N);
 PRINT STR$(Anzb2);
 PRINT "  S";
 N=3- LEN( STR$(Anzs2))
 IF N<0 THEN N=0
 PRINT SPC(N);
 PRINT STR$(Anzs2);
 PRINT "|";
 PRINT "Spieler 3: B";
 N=3- LEN( STR$(Anzb3))
 PRINT SPC(N);
 PRINT STR$(Anzb3);
 PRINT "  S";
 N=3- LEN( STR$(Anzs3))
 IF N<0 THEN N=0
 PRINT SPC(N);
 PRINT STR$(Anzs3);
 PRINT "| Zeit :";
 N=4- LEN( STR$(Zeit))
 PRINT SPC(N);
 PRINT STR$(Zeit)
 RETURN
-Status
 Zeit=Zeit+1
-Status2
 ON TIMER 1 GOSUB 0
 PRINT "H";
 A$= STR$(Anzb1)
 N=3- LEN(A$)
 PRINT TAB (12+N);A$;
 A$= STR$(Anzs1)
 N=3- LEN(A$)
 PRINT TAB (18+N);A$;
 A$= STR$(Anzb2)
 N=3- LEN(A$)
 PRINT TAB (34+N);A$;
 A$= STR$(Anzs2)
 N=3- LEN(A$)
 IF N<0 THEN N=0
 PRINT TAB (40+N);A$;
 A$= STR$(Anzb3)
 N=3- LEN(A$)
 PRINT TAB (56+N);A$;
 A$= STR$(Anzs3)
 N=3- LEN(A$)
 IF N<0 THEN N=0
 PRINT TAB (62+N);A$;
 A$= STR$(Zeit)
 N=4- LEN(A$)
 PRINT TAB (73+N);A$
 ON TIMER .1 GOSUB Soundupdate
 RETURN
-Anfang
 CLEAR 32256*8,60000
 COMPILER "Multitasking_Between_Statements"
 COMPILER "Trace_On"
 ON ERROR GOTO Fehler
 Resolution
 IF Aufl<>2 THEN
 PRINT "Leider l„uft dieses Spiel nur auf der h”chsten Aufl”sung (640x400) !"
 PRINT "Bitte laden sie neu !"
 PRINT "<Taste>"
 Taste$= INPUT$(1)
 END
 ENDIF
 Get_Path
 IPL 3+(1 SHL 31)
 DIM A$(20),Exlx(20),Exly(20),Exx(20),Exy(20),Name$(10),Xpos(10),Ypos(10),Compop%F(4)
 DIM Fenster(3,4),Menue$(20)
 Maxfenster=3
 Linienfarbe=1
 Fuellfarbe=1
 Init_Sound(11)
 PRINT "f";
 CLS
 MODE =1
 Bild1= LPEEK($44E)
 Bild2= MEMORY(32256)+255 AND $FFFF00
 Bild3= MEMORY(32256)
 Lvlspeicher= MEMORY(32256)
 Sspeicher= MEMORY(4970)
 Extramem= MEMORY(166)
 CHDIR Path$+"DATAS"
 Load_All(1,11,"R_POINTS.MSD")
 OPEN "i",1,"TASTEN.INF"
 INPUT #1,Sl1$
 INPUT #1,Sr1$
 INPUT #1,So1$
 INPUT #1,Su1$
 INPUT #1,Sb1$
 INPUT #1,Sw1$
 INPUT #1,Ss1$
 INPUT #1,Sl2$
 INPUT #1,Sr2$
 INPUT #1,So2$
 INPUT #1,Su2$
 INPUT #1,Sb2$
 INPUT #1,Sw2$
 INPUT #1,Ss2$
 CLOSE 1
 Startx1=240
 Starty1=200
 Startx2=320
 Starty2=200
 Startx3=400
 Starty3=200
 Warten!=.01
 Ausw=5
 Compop%F(2)=-1
 Compop%F(4)=-1
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 CLS
 RESTORE Extra
 FOR Y=0 TO 39
 FOR X=0 TO 4
 READ A
 POKE Bild2+X+Y*80,A
 NEXT X
 NEXT Y
 LINE COLOR =1: FILL COLOR =1
 BITBLT 0,0,30,40 TO Extramem
 CLS
 BOX 0,18 TO 639,399
 BITBLT 0,0,640,400 TO Lvlspeicher
 CLS
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild2), LOW(Bild2),-1)
 BLOAD "r_points.pic"
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 CHDIR Path$
 LPOKE $44E,Bild2
 RESTORE Scrolltext
 FOR T=1 TO 8
   READ A$(1)
   Zentriere(1)
 NEXT T
 Scounter=0
 REPEAT
 Scounter=Scounter+1
 IF Scounter=16 THEN
   LPOKE $44E,Bild2
   BITBLT 150,16,340,112 TO 150,0,340,112
   PRINT @(7,0);"K";
   READ A$(1)
   IF A$(1)="ENDE" THEN RESTORE Scrolltext: READ A$(1)
   Zentriere(1)
   Scounter=0
   LPOKE $44E,Bild1
 ENDIF
 FOR Y=0 TO 111
   Faktor=Y*80
   Adr1=Bild1+Faktor+326
   Adr2=Bild2+Faktor+Scounter*80+18
   FOR X=0 TO 10
     LPOKE Adr1, LPEEK(Adr2)
     Adr1=Adr1+4
     Adr2=Adr2+4
   NEXT X
 NEXT Y
 UNTIL INKEY$ >"" OR MOUSEBUT >0
 REPEAT UNTIL INKEY$ ="" AND MOUSEBUT =0
 LPOKE $44E,Bild2
 CLS
 LPOKE $44E,Bild1
-Hauptmenue
 CLS
 Menue$(1)="   RUNNING POINTS   "
 Wind_Text(Nr,-1,20,1,0)
 Menue$(1)="Spiel starten"
 Menue$(2)="Status"
 Menue$(3)="Options"
 Menue$(4)="Ende"
 Menue(4,Stelle)
 Wind_Close(Nr)
 ON Stelle GOTO Spiel,Stat,Options,Ende
-Spiel
 IF Name$(1)="" THEN GOTO Neues_Spiel
 Menue$(1)="SPIEL STARTEN"
 Wind_Text(Nr,-1,20,1,0)
 Menue$(1)="Altes Spiel fortsetzen"
 Menue$(2)="Neues Spiel"
 Menue$(3)="Zurck"
 Menue(3,Stelle)
 Wind_Close(Nr)
 ON Stelle GOTO Spielstart,Neues_Spiel,Hauptmenue
-Neues_Spiel
 Menue$(1)="NEUES SPIEL"
 Wind_Text(Nr,-1,20,1,0)
 Menue$(1)="3 Spieler"
 Menue$(2)="2 Spieler"
 Menue$(3)="1 Spieler"
 Menue$(4)="Zurck"
 Menue(4,Stelle)
 Wind_Close(Nr)
 IF Stelle=4 THEN GOTO Hauptmenue
 Anz_Spieler=4-Stelle
 Name$(1)=""
 Name$(2)=""
 Name$(3)=""
 Menue$(1)="SPIELERNAMEN"
 Wind_Text(Nr,-1,20,1,0)
 PRINT "e";"B"*5
 FOR T=1 TO Anz_Spieler
 PRINT "Name Spieler";
 Text$=""
 INPUT STR$(T)+" ";Text$
 IF Text$="" THEN PRINT "f";:Wind_Close(Nr): GOTO Hauptmenue
 Name$(T)=Text$
 NEXT T
 PRINT "f";
 Wind_Close(Nr)
 IF Anz_Spieler=2 THEN Name$(3)=Name$(2)
 IF Anz_Spieler=1 THEN Name$(3)=Name$(1)
 IF Anz_Spieler=2 THEN Name$(2)="Compi"
 IF Anz_Spieler=1 THEN Name$(1)="Atari":Name$(2)="Compi"
 Anz_Spiele=0
 Gew1=0
 Gew2=0
 Gew3=0
 Ges_Zeit=0
-Spielstart
 Anzb1=5:Anzs1=3
 Anzb2=5:Anzs2=3
 Anzb3=5:Anzs3=3
 X1=Startx1:Y1=Starty1
 X2=Startx2:Y2=Starty2
 X3=Startx3:Y3=Starty3
 Bewx1=0:Bewy1=-1
 Bewx2=0:Bewy2=-1
 Bewx3=0:Bewy3=-1
 Richt1=4
 Richt2=4
 Richt3=4
 Richt11=-1
 Richt22=-1
 Richt33=-1
 Zeit=0
 Baktiv1=0:Saktiv1=0:Bcounter1=0:Scounter1=0
 Baktiv2=0:Saktiv2=0:Bcounter2=0:Scounter2=0
 Baktiv3=0:Saktiv3=0:Bcounter3=0:Scounter3=0
 Speed1=1:Speed2=1:Speed3=1
 Unvaktiv1=0:Unvaktiv2=0:Unvaktiv3=0
 Unvcounter1=0:Unvcounter2=0:Unvcounter3=0
 Laehm1=0:Laehm2=0:Laehm3=0
 Anz_Spiele=Anz_Spiele+1
 Joy2=0:Kaputt=0
 Kaputt1=0:Kaputt2=0:Kaputt3=0
 Extra1=0:Extra2=0
 BITBLT Lvlspeicher TO 0,0,640,400
 GOSUB Statanf
 CLIP 0,19 TO 638,398
 FOR T=1 TO Anz_Extras
 Exx(T)=Exlx(T)
 Exy(T)=Exly(T)
 BITBLT Extramem TO Exx(T),Exy(T),30,40
 NEXT T
 CLIP
 DRAW Startx1-1,Starty1-1 TO Startx1+1,Starty1+1
 DRAW Startx1+1,Starty1-1 TO Startx1-1,Starty1+1
 DRAW Startx2-1,Starty2-1 TO Startx2+1,Starty2+1
 DRAW Startx2+1,Starty2-1 TO Startx2-1,Starty2+1
 DRAW Startx3-1,Starty3-1 TO Startx3+1,Starty3+1
 DRAW Startx3+1,Starty3-1 TO Startx3-1,Starty3+1
 TEXT HEIGHT =4
 TEXT Startx1+3,Starty1+5,"1"
 TEXT Startx2+3,Starty2+5,"2"
 TEXT Startx3+3,Starty3+5,"3"
 TEXT STYLE =16
 TEXT HEIGHT =20
 FOR T=3 TO 1 STEP -1
 TEXT 310,190, RIGHT$( STR$(T),1)
 WAIT 1
 NEXT T
 TEXT STYLE =0
 TEXT HEIGHT =Textsize
 BITBLT Lvlspeicher TO 0,0,640,400
 GOSUB Statanf
 CLIP 0,19 TO 638,398
 FOR T=1 TO Anz_Extras
 BITBLT Extramem TO Exx(T),Exy(T),30,40
 NEXT T
 CLIP
 MODE =3
 REPEAT UNTIL INKEY$ =""
 Statusz=9
-Spielstart2
 Taste$= INKEY$
 Joy= JOYSTICK(1):Joy=Joy OR ( MOUSEBUT SHL 5)
 IF Taste$>"" OR Joy<>Joy2 AND Joy>0 THEN GOSUB Taste
 IF Laehm1=1 OR Kaputt1=1 THEN GOTO Beweg2
 IF Unvaktiv1=1 AND Unvcounter1 MOD 2=0 THEN
 FOR T=1 TO Speed1
 X1=X1+Bewx1
 Y1=Y1+Bewy1
 IF X1<1 THEN X1=1
 IF X1>638 THEN X1=638
 IF Y1<19 THEN Y1=19
 IF Y1>398 THEN Y1=398
 NEXT T
 GOTO Beweg2
 ENDIF
 FOR Z=1 TO Speed1
 X1=X1+Bewx1
 Y1=Y1+Bewy1
 IF X1<1 THEN X1=1
 IF X1>638 THEN X1=638
 IF Y1<19 THEN Y1=19
 IF Y1>398 THEN Y1=398
 DRAW X1,Y1
 IF POINT(X1,Y1)=0 THEN GOTO Kollision1
 NEXT Z
-Beweg2
 IF Laehm2=1 OR Kaputt2=1 THEN GOTO Beweg3
 IF Unvaktiv2=1 AND Unvcounter2 MOD 2=0 THEN
 FOR T=1 TO Speed2
 X2=X2+Bewx2
 Y2=Y2+Bewy2
 IF X2<1 THEN X2=1
 IF X2>638 THEN X2=638
 IF Y2<19 THEN Y2=19
 IF Y2>398 THEN Y2=398
 NEXT T
 GOTO Beweg3
 ENDIF
 FOR Z=1 TO Speed2
 X2=X2+Bewx2
 Y2=Y2+Bewy2
 IF X2<1 THEN X2=1
 IF X2>638 THEN X2=638
 IF Y2<19 THEN Y2=19
 IF Y2>398 THEN Y2=398
 DRAW X2,Y2
 IF POINT(X2,Y2)=0 THEN GOTO Kollision2
 NEXT Z
-Beweg3
 IF Laehm3=1 OR Kaputt3=1 THEN GOTO Spielstart3
 IF Unvaktiv3=1 AND Unvcounter3 MOD 2=0 THEN
 FOR T=1 TO Speed3
 X3=X3+Bewx3
 Y3=Y3+Bewy3
 IF X3<1 THEN X3=1
 IF X3>638 THEN X3=638
 IF Y3<19 THEN Y3=19
 IF Y3>398 THEN Y3=398
 NEXT T
 GOTO Spielstart3
 ENDIF
 FOR Z=1 TO Speed3
 X3=X3+Bewx3
 Y3=Y3+Bewy3
 IF X3<1 THEN X3=1
 IF X3>638 THEN X3=638
 IF Y3<19 THEN Y3=19
 IF Y3>398 THEN Y3=398
 DRAW X3,Y3
 IF POINT(X3,Y3)=0 THEN GOTO Kollision3
 NEXT Z
-Spielstart3
 Taste$= INKEY$
 Joy= JOYSTICK(1):Joy=Joy OR ( MOUSEBUT SHL 5)
 IF Taste$>"" OR Joy<>Joy2 AND Joy>0 THEN GOSUB Taste
 IF Baktiv1=1 THEN Bcounter1=Bcounter1+1: IF Bcounter1=50 THEN GOSUB Bombe1
 IF Saktiv1=1 THEN Scounter1=Scounter1+1: IF Scounter1=15 THEN GOSUB Sprenger1
 IF Baktiv2=1 THEN Bcounter2=Bcounter2+1: IF Bcounter2=50 THEN GOSUB Bombe2
 IF Saktiv2=1 THEN Scounter2=Scounter2+1: IF Scounter2=15 THEN GOSUB Sprenger2
 IF Baktiv3=1 THEN Bcounter3=Bcounter3+1: IF Bcounter3=50 THEN GOSUB Bombe3
 IF Saktiv3=1 THEN Scounter3=Scounter3+1: IF Scounter3=15 THEN GOSUB Sprenger3
 IF Unvaktiv1=1 OR Laehm1=1 THEN Unvcounter1=Unvcounter1+1: IF Unvcounter1=850 THEN Unvaktiv1=0
 IF Unvcounter1=500 THEN Laehm1=0
 IF Unvaktiv2=1 OR Laehm2=1 THEN Unvcounter2=Unvcounter2+1: IF Unvcounter2=850 THEN Unvaktiv2=0
 IF Unvcounter2=500 THEN Laehm2=0
 IF Unvaktiv3=1 OR Laehm3=1 THEN Unvcounter3=Unvcounter3+1: IF Unvcounter3=850 THEN Unvaktiv3=0
 IF Unvcounter3=500 THEN Laehm3=0
 IF Raendern1>0 THEN Raendern1=Raendern1-1
 IF Raendern2>0 THEN Raendern2=Raendern2-1
 Taste$= INKEY$
 Joy= JOYSTICK(1):Joy=Joy OR ( MOUSEBUT SHL 5)
 IF Taste$>"" OR Joy<>Joy2 AND Joy>0 THEN GOSUB Taste
 IF Anz_Spieler<3 THEN IF Kaputt2=0 THEN GOSUB Compi2
 IF Anz_Spieler=1 AND Kaputt1=0 THEN GOSUB Compi1
 WAIT Warten!
 GOTO Spielstart2
-Taste
 IF Taste$>"" THEN
 Taste$= LOWER$( CHR$( CVIL(Taste$) AND $FF))
 IF Anz_Spieler=1 AND Kaputt3=1 THEN CLIP : MODE =1:Stop_All:Gew1=Gew1+2:Gew2=Gew2+2:Statusz=0:Ges_Zeit=Ges_Zeit+Zeit: GOTO Hauptmenue
 IF Anz_Spieler>1 THEN
 IF Taste$=Sl1$ THEN Bewx1=-1:Bewy1=0:Richt1=1: RETURN
 IF Taste$=Sr1$ THEN Bewx1=1:Bewy1=0:Richt1=3: RETURN
 IF Taste$=So1$ THEN Bewx1=0:Bewy1=-1:Richt1=4: RETURN
 IF Taste$=Su1$ THEN Bewx1=0:Bewy1=1:Richt1=2: RETURN
 IF Taste$=Ss1$ THEN Speed1= ABS(3-Speed1): RETURN
 IF Taste$=Sb1$ AND Baktiv1=0 AND Anzb1>0 THEN Anzb1=Anzb1-1:Baktiv1=1:Bx1=X1:By1=Y1:Bcounter1=0: GOSUB Status2: RETURN
 IF Taste$=Sw1$ AND Saktiv1=0 AND Anzs1>0 THEN Anzs1=Anzs1-1:Saktiv1=1:Sx1=X1:Sy1=Y1:Scounter1=0: GOSUB Status2: RETURN
 ELSE
 IF Taste$=Sl1$ THEN Bewx3=-1:Bewy3=0:Richt3=1: RETURN
 IF Taste$=Sr1$ THEN Bewx3=1:Bewy3=0:Richt3=3: RETURN
 IF Taste$=So1$ THEN Bewx3=0:Bewy3=-1:Richt3=4: RETURN
 IF Taste$=Su1$ THEN Bewx3=0:Bewy3=1:Richt3=2: RETURN
 IF Taste$=Ss1$ THEN Speed3= ABS(3-Speed3): RETURN
 IF Taste$=Sb1$ AND Baktiv3=0 AND Anzb3>0 THEN Anzb3=Anzb3-1:Baktiv3=1:Bx3=X3:By3=Y3:Bcounter3=0: GOSUB Status2: RETURN
 IF Taste$=Sw1$ AND Saktiv3=0 AND Anzs3>0 THEN Anzs3=Anzs3-1:Saktiv3=1:Sx3=X3:Sy3=Y3:Scounter3=0: GOSUB Status2: RETURN
 ENDIF
 IF Anz_Spieler=1 THEN RETURN
 IF Anz_Spieler>2 THEN
 IF Taste$=Sl2$ THEN Bewx2=-1:Bewy2=0:Richt2=1: RETURN
 IF Taste$=Sr2$ THEN Bewx2=1:Bewy2=0:Richt2=3: RETURN
 IF Taste$=So2$ THEN Bewx2=0:Bewy2=-1:Richt2=4: RETURN
 IF Taste$=Su2$ THEN Bewx2=0:Bewy2=1:Richt2=2: RETURN
 IF Taste$=Ss2$ THEN Speed2= ABS(3-Speed2): RETURN
 IF Taste$=Sb2$ AND Baktiv2=0 AND Anzb2>0 THEN Anzb2=Anzb2-1:Baktiv2=1:Bx2=X2:By2=Y2:Bcounter2=0: GOSUB Status2: RETURN
 IF Taste$=Sw2$ AND Saktiv2=0 AND Anzs2>0 THEN Anzs2=Anzs2-1:Saktiv2=1:Sx2=X2:Sy2=Y2:Scounter2=0: GOSUB Status2: RETURN
 ELSE
 IF Taste$=Sl2$ THEN Bewx3=-1:Bewy3=0:Richt3=1: RETURN
 IF Taste$=Sr2$ THEN Bewx3=1:Bewy3=0:Richt3=3: RETURN
 IF Taste$=So2$ THEN Bewx3=0:Bewy3=-1:Richt3=4: RETURN
 IF Taste$=Su2$ THEN Bewx3=0:Bewy3=1:Richt3=2: RETURN
 IF Taste$=Ss2$ THEN Speed3= ABS(3-Speed3): RETURN
 IF Taste$=Sb2$ AND Baktiv3=0 AND Anzb3>0 THEN Anzb3=Anzb3-1:Baktiv3=1:Bx3=X3:By3=Y3:Bcounter3=0: GOSUB Status2: RETURN
 IF Taste$=Sw2$ AND Saktiv3=0 AND Anzs3>0 THEN Anzs3=Anzs3-1:Saktiv3=1:Sx3=X3:Sy3=Y3:Scounter3=0: GOSUB Status2: RETURN
 ENDIF
 ENDIF
 IF Joy<>Joy2 AND Joy>0 THEN
 IF Joy=4 THEN Bewx3=-1:Bewy3=0:Richt3=1: RETURN
 IF Joy=8 THEN Bewx3=1:Bewy3=0:Richt3=3: RETURN
 IF Joy=1 THEN Bewx3=0:Bewy3=-1:Richt3=4: RETURN
 IF Joy=2 THEN Bewx3=0:Bewy3=1:Richt3=2: RETURN
 IF Joy=65 THEN Speed3= ABS(3-Speed3):Joy2=Joy: RETURN
 IF Joy=68 AND Baktiv3=0 AND Anzb3>0 THEN Anzb3=Anzb3-1:Baktiv3=1:Bx3=X3:By3=Y3:Bcounter3=0: GOSUB Status2:Joy2=Joy: RETURN
 IF Joy=72 AND Saktiv3=0 AND Anzs3>0 THEN Anzs3=Anzs3-1:Saktiv3=1:Sx3=X3:Sy3=Y3:Scounter3=0: GOSUB Status2:Joy2=Joy: RETURN
 Joy2=Joy
 ENDIF
 RETURN
-Kollision1
 ON TIMER 1 GOSUB 0
 Extranr=0
 FOR T=1 TO Anz_Extras
 IF X1>=Exx(T) AND Y1>=Exy(T) AND X1<Exx(T)+4 AND Y1<Exy(T)+4 THEN Extranr=T
 NEXT T
 IF Extranr>0 THEN GOTO Extra1
 IF Unvaktiv1=1 THEN
 DRAW X1,Y1
 IF X1<1 THEN X1=1
 IF X1>638 THEN X1=638
 IF Y1<19 THEN Y1=19
 IF Y1>398 THEN Y1=398
 ON TIMER .1 GOSUB Soundupdate
 GOTO Beweg2
 ENDIF
 Statusz=0
 ON TIMER .1 GOSUB Soundupdate
 CLIP 1,19 TO 638,398
 Start_Sound(0, INT( RND(5))+1,100,2000)
 MODE =1
 FOR T=1 TO 30
 CIRCLE X1,Y1,T
 WAIT .01
 NEXT T
 Kaputt1=1:Kaputt=Kaputt+1
 IF Kaputt<2 THEN MODE =3:Statusz=9: GOTO Beweg2
 CLIP
 REPEAT UNTIL INKEY$ =""
 IF Kaputt2=0 THEN
 Menue$(1)=Name$(2)+" gewinnt !!!"
 Wind_Text(Nr,-1,200,1,0)
 Gew2=Gew2+2
 Gew1=Gew1+1
 ELSE
 Menue$(1)=Name$(3)+" gewinnt !!!"
 Wind_Text(Nr,-1,200,1,0)
 Gew1=Gew1+1
 Gew3=Gew3+2
 ENDIF
 Ges_Zeit=Ges_Zeit+Zeit
 REPEAT UNTIL INKEY$ >"" OR MOUSEBUT >0
 REPEAT UNTIL INKEY$ ="" AND MOUSEBUT =0
 Wind_Close(Nr)
 Stop_All
 GOTO Hauptmenue
-Kollision2
 ON TIMER 1 GOSUB 0
 Extranr=0
 FOR T=1 TO Anz_Extras
 IF X2>=Exx(T) AND Y2>=Exy(T) AND X2<Exx(T)+4 AND Y2<Exy(T)+4 THEN Extranr=T
 NEXT T
 IF Extranr>0 THEN GOTO Extra2
 IF Unvaktiv2=1 THEN
 DRAW X2,Y2
 IF X2<1 THEN X2=1
 IF X2>638 THEN X2=638
 IF Y2<19 THEN Y2=19
 IF Y2>398 THEN Y2=398
 ON TIMER .1 GOSUB Soundupdate
 GOTO Beweg3
 ENDIF
 Statusz=0
 ON TIMER .1 GOSUB Soundupdate
 CLIP 1,19 TO 638,398
 Start_Sound(1, INT( RND(5))+1,100,2000)
 MODE =1
 FOR T=1 TO 30
 CIRCLE X2,Y2,T
 WAIT .01
 NEXT T
 Kaputt2=1:Kaputt=Kaputt+1
 IF Kaputt<2 THEN MODE =3:Statusz=9: GOTO Beweg3
 CLIP
 REPEAT UNTIL INKEY$ =""
 IF Kaputt1=0 THEN
 Menue$(1)=Name$(1)+" gewinnt !!!"
 Wind_Text(Nr,-1,200,1,0)
 Gew1=Gew1+2
 Gew2=Gew2+1
 ELSE
 Menue$(1)=Name$(3)+" gewinnt !!!"
 Wind_Text(Nr,-1,200,1,0)
 Gew2=Gew2+1
 Gew3=Gew3+2
 ENDIF
 Ges_Zeit=Ges_Zeit+Zeit
 REPEAT UNTIL INKEY$ >"" OR MOUSEBUT >0
 REPEAT UNTIL INKEY$ ="" AND MOUSEBUT =0
 Wind_Close(Nr)
 Stop_All
 GOTO Hauptmenue
-Kollision3
 ON TIMER 1 GOSUB 0
 Extranr=0
 FOR T=1 TO Anz_Extras
 IF X3>=Exx(T) AND Y3>=Exy(T) AND X3<Exx(T)+4 AND Y3<Exy(T)+4 THEN Extranr=T
 NEXT T
 IF Extranr>0 THEN GOTO Extra3
 IF Unvaktiv3=1 THEN
 DRAW X3,Y3
 IF X3<1 THEN X3=1
 IF X3>638 THEN X3=638
 IF Y3<19 THEN Y3=19
 IF Y3>398 THEN Y3=398
 ON TIMER .1 GOSUB Soundupdate
 GOTO Spielstart3
 ENDIF
 Statusz=0
 ON TIMER .1 GOSUB Soundupdate
 CLIP 1,19 TO 638,398
 Start_Sound(2, INT( RND(5))+1,100,2000)
 MODE =1
 FOR T=1 TO 30
 CIRCLE X3,Y3,T
 WAIT .01
 NEXT T
 Kaputt3=1:Kaputt=Kaputt+1
 REPEAT UNTIL INKEY$ =""
 IF Kaputt<2 THEN MODE =3:Statusz=9: GOTO Spielstart3
 CLIP
 REPEAT UNTIL INKEY$ =""
 IF Kaputt1=0 THEN
 Menue$(1)=Name$(1)+" gewinnt !!!"
 Wind_Text(Nr,-1,200,1,0)
 Gew1=Gew1+2
 Gew3=Gew3+1
 ELSE
 Menue$(1)=Name$(2)+" gewinnt !!!"
 Wind_Text(Nr,-1,200,1,0)
 Gew3=Gew3+1
 Gew2=Gew2+2
 ENDIF
 Ges_Zeit=Ges_Zeit+Zeit
 REPEAT UNTIL INKEY$ >"" OR MOUSEBUT >0
 REPEAT UNTIL INKEY$ ="" AND MOUSEBUT =0
 Wind_Close(Nr)
 Stop_All
 GOTO Hauptmenue
-Bombe1
 Statusz2=Statusz
 Statusz=0
 Start_Sound(0,6,40,2000)
 MODE =1
 Bcounter1=0
 Baktiv1=0
 CLIP 1,19 TO 638,398
 FOR T=1 TO 30
 CIRCLE Bx1,By1,T
 NEXT T
 CLIP
 MODE =3
 Statusz=Statusz2
 RETURN
-Sprenger1
 Statusz2=Statusz
 Statusz=0
 Start_Sound(0,7,40,2000)
 MODE =1
 Scounter1=0
 Saktiv1=0
 CLIP 1,19 TO 638,398
 LINE COLOR =0
 FILL COLOR =0
 PCIRCLE Sx1,Sy1,40
 CLIP
 MODE =3
 LINE COLOR =1
 FILL COLOR =1
 Statusz=Statusz2
 RETURN
-Bombe2
 Statusz2=Statusz
 Statusz=0
 Start_Sound(1,6,40,2000)
 MODE =1
 Bcounter2=0
 Baktiv2=0
 CLIP 1,19 TO 638,398
 FOR T=1 TO 30
 CIRCLE Bx2,By2,T
 NEXT T
 CLIP
 MODE =3
 Statusz=Statusz2
 RETURN
-Sprenger2
 Statusz2=Statusz
 Statusz=0
 Start_Sound(1,7,40,2000)
 MODE =1
 Scounter2=0
 Saktiv2=0
 CLIP 1,19 TO 638,398
 LINE COLOR =0
 FILL COLOR =0
 PCIRCLE Sx2,Sy2,40
 CLIP
 LINE COLOR =1
 FILL COLOR =1
 MODE =3
 Statusz=Statusz2
 RETURN
-Bombe3
 Statusz2=Statusz
 Statusz=0
 Start_Sound(2,6,40,2000)
 MODE =1
 Bcounter3=0
 Baktiv3=0
 CLIP 1,19 TO 638,398
 FOR T=1 TO 30
 CIRCLE Bx3,By3,T
 NEXT T
 CLIP
 MODE =3
 Statusz=Statusz2
 RETURN
-Sprenger3
 Statusz2=Statusz
 Statusz=0
 Start_Sound(2,7,40,2000)
 MODE =1
 Scounter3=0
 Saktiv3=0
 CLIP 1,19 TO 638,398
 LINE COLOR =0
 FILL COLOR =0
 PCIRCLE Sx3,Sy3,40
 CLIP
 LINE COLOR =1
 FILL COLOR =1
 MODE =3
 Statusz=Statusz2: IF Statusz=0 THEN PRINT "Test"
 RETURN
-Extra1
 IF Extra1=Extra2 THEN Extra2=0
 Extra1=0
 Statusz2=Statusz
 Statusz=0
 ON TIMER .1 GOSUB Soundupdate
 Start_Sound(0,10,10,1000)
 CLIP 1,19 TO 638,398
 BITBLT Extramem TO Exx(Extranr),Exy(Extranr),30,40,4
 CLIP
 DRAW X1,Y1
 Exx(Extranr)=-150
 Exy(Extranr)=-150
 Zufall= INT( RND(11))+1
 ON Zufall GOSUB Bkette,Skette,Mg,Bsplus1,Bsminus1,Speed1,Kreis1,Unv1,Teleport1,Laehm1,Bonus1
 Statusz=Statusz2
 IF Bspieler=1 THEN Bspieler=0: GOTO Extra1
 GOTO Beweg2
-Bonus1
 Bspieler=1
 Zufall= INT( RND(3))
 IF Zufall>0 OR Anz_Spieler=1 THEN RETURN
 GOTO Bonus
-Bkette
 FOR S=1 TO 6
 Xpos(S)= INT( RND(640))
 Ypos(S)= INT( RND(380))+20
 NEXT S
 Start_Sound(0,8,40,2000)
 MODE =1
 CLIP 1,19 TO 638,398
 FOR Bkette=1 TO 30
 IF Bkette=10 THEN Start_Sound(1,8,40,2000)
 IF Bkette=16 THEN Start_Sound(2,8,40,2000)
 FOR Bkette2=1 TO 6
 CIRCLE Xpos(Bkette2),Ypos(Bkette2),Bkette
 NEXT Bkette2
 NEXT Bkette
 FOR Bkette2=1 TO Anz_Extras
 BITBLT Extramem TO Exx(Bkette2),Exy(Bkette2),30,40
 NEXT Bkette2
 CLIP
 MODE =3
 RETURN
-Skette
 MODE =1
 CLIP 1,19 TO 638,398
 LINE COLOR =0
 FILL COLOR =0
 FOR T=1 TO 6
 PCIRCLE INT( RND(640)), INT( RND(380))+20,50
 NEXT T
 LINE COLOR =1
 FILL COLOR =1
 FOR T=1 TO Anz_Extras
 BITBLT Extramem TO Exx(T),Exy(T),30,40
 NEXT T
 CLIP
 MODE =3
 RETURN
-Mg
 MODE =1
 CLIP 1,19 TO 638,398
 FOR T=1 TO 30
 IF T MOD 2=0 THEN Start_Sound(0,9,5,1000)
 PCIRCLE INT( RND(640)), INT( RND(380))+20,6
 NEXT T
 CLIP
 MODE =3
 RETURN
-Bsplus1
 Anzb1=Anzb1+5
 Anzs1=Anzs1+5
 GOSUB Status2
 RETURN
-Bsminus1
 Anzb2=0:Anzb3=0
 Anzs2=0:Anzs3=0
 GOSUB Status2
 RETURN
-Speed1
 Speed1=4
 RETURN
-Kreis1
 MODE =1
 CLIP 1,19 TO 639,398
 CIRCLE X2,Y2,60
 CIRCLE X3,Y3,60
 CLIP
 MODE =3
 RETURN
-Unv1
 Unvaktiv1=1
 Unvcounter1=0
 RETURN
-Teleport1
 Tx= INT( RND(640))
 Ty= INT( RND(380))+20
 Tx2= INT( RND(640))
 Ty2= INT( RND(380))+20
 IF POINT(Tx,Ty)=1 OR POINT(Tx2,Ty2)=1 THEN GOTO Teleport1
 DRAW X2,Y2 TO Tx,Ty
 DRAW X3,Y3 TO Tx2,Ty2
 WAIT .5
 DRAW X2,Y2 TO Tx,Ty
 DRAW X3,Y3 TO Tx2,Ty2
 DRAW Tx,Ty
 DRAW Tx2,Ty2
 X2=Tx:X3=Tx2
 Y2=Ty:Y3=Ty2
 RETURN
-Laehm1
 Unv2=0:Unv3=0
 Unvcounter2=0:Unvcounter3=0
 Laehm2=1:Laehm3=1
 RETURN
-Extra2
 IF Extra1=Extra2 THEN Extra1=0
 Extra2=0
 Statusz2=Statusz
 Statusz=0
 ON TIMER .1 GOSUB Soundupdate
 Start_Sound(1,10,10,1005)
 CLIP 1,19 TO 638,398
 BITBLT Extramem TO Exx(Extranr),Exy(Extranr),30,40,4
 CLIP
 DRAW X2,Y2
 Exx(Extranr)=-150
 Exy(Extranr)=-150
 Zufall= INT( RND(11))+1
 ON Zufall GOSUB Bkette,Skette,Mg,Bsplus2,Bsminus2,Speed2,Kreis2,Unv2,Teleport2,Laehm2,Bonus2
 Statusz=Statusz2
 IF Bspieler=2 THEN Bspieler=0: GOTO Extra2
 GOTO Beweg3
-Bonus2
 Bspieler=2
 Zufall= INT( RND(3))
 IF Zufall>0 OR Anz_Spieler<3 THEN RETURN
 GOTO Bonus
-Bsplus2
 Anzb2=Anzb2+5
 Anzs2=Anzs2+5
 GOSUB Status2
 RETURN
-Bsminus2
 Anzb1=0:Anzb3=0
 Anzs1=0:Anzs3=0
 GOSUB Status2
 RETURN
-Speed2
 Speed2=4
 RETURN
-Kreis2
 MODE =1
 CLIP 1,19 TO 639,398
 CIRCLE X1,Y1,60
 CIRCLE X3,Y3,60
 CLIP
 MODE =3
 RETURN
-Unv2
 Unvaktiv2=1
 Unvcounter2=0
 RETURN
-Teleport2
 Tx= INT( RND(640))
 Ty= INT( RND(380))+20
 Tx2= INT( RND(640))
 Ty2= INT( RND(380))+20
 IF POINT(Tx,Ty)=1 OR POINT(Tx2,Ty2)=1 THEN GOTO Teleport3
 DRAW X1,Y1 TO Tx,Ty
 DRAW X3,Y3 TO Tx2,Ty2
 WAIT .5
 DRAW X1,Y1 TO Tx,Ty
 DRAW X3,Y3 TO Tx2,Ty2
 DRAW Tx,Ty
 DRAW Tx2,Ty2
 X1=Tx:X3=Tx2
 Y1=Ty:Y3=Ty2
 RETURN
-Laehm2
 Unv1=0:Unv3=0
 Unvcounter1=0:Unvcounter3=0
 Laehm1=1:Laehm3=1
 RETURN
-Extra3
 Statusz2=Statusz
 Statusz=0
 Start_Sound(2,10,10,995)
 ON TIMER .1 GOSUB Soundupdate
 CLIP 1,19 TO 638,398
 BITBLT Extramem TO Exx(Extranr),Exy(Extranr),30,40,4
 CLIP
 DRAW X3,Y3
 Exx(Extranr)=-150
 Exy(Extranr)=-150
 Zufall= INT( RND(11))+1
 ON Zufall GOSUB Bkette,Skette,Mg,Bsplus3,Bsminus3,Speed3,Kreis3,Unv3,Teleport3,Laehm3,Bonus3
 Statusz=Statusz2
 IF Bspieler=3 THEN Bspieler=0: GOTO Extra3
 GOTO Spielstart3
-Bonus3
 Bspieler=3
 Zufall= INT( RND(3))
 IF Zufall>0 THEN RETURN
 GOTO Bonus
-Bsplus3
 Anzb3=Anzb3+5
 Anzs3=Anzs3+5
 GOSUB Status2
 RETURN
-Bsminus3
 Anzb1=0:Anzb2=0
 Anzs1=0:Anzs2=0
 GOSUB Status2
 RETURN
-Speed3
 Speed3=4
 RETURN
-Kreis3
 MODE =1
 CLIP 1,19 TO 639,398
 CIRCLE X1,Y1,60
 CIRCLE X2,Y2,60
 CLIP
 MODE =3
 RETURN
-Unv3
 Unvaktiv3=1
 Unvcounter3=0
 RETURN
-Teleport3
 Tx= INT( RND(640))
 Ty= INT( RND(380))+20
 Tx2= INT( RND(640))
 Ty2= INT( RND(380))+20
 IF POINT(Tx,Ty)=1 OR POINT(Tx2,Ty2)=1 THEN GOTO Teleport3
 DRAW X1,Y1 TO Tx,Ty
 DRAW X2,Y2 TO Tx2,Ty2
 WAIT .5
 DRAW X1,Y1 TO Tx,Ty
 DRAW X2,Y2 TO Tx2,Ty2
 DRAW Tx,Ty
 DRAW Tx2,Ty2
 X1=Tx:X2=Tx2
 Y1=Ty:Y2=Ty2
 RETURN
-Laehm3
 Unv1=0:Unv2=0
 Unvcounter1=0:Unvcounter2=0
 Laehm1=1:Laehm2=1
 RETURN
-Bonus
 Stop_All
 BITBLT 0,0,640,400 TO Bild3
 MODE =1
 TEXT HEIGHT =20
 TEXT STYLE =16
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 CLS
 TEXT 100,100,"Bonuskammer",440,1,1
 TEXT 150,350,"Spieler"+ STR$(Bspieler),340,1,1
 BOX 245,150,150,150
 BOX 225,130,190,190
 FILL STYLE =2, INT( RND(23))+1
 FILL 228,133,-1
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 Fadepic(Bild2,Bild1,2)
 Start_Sound(0,11,-1,1000)
 Xb=320:Yb=200
 DRAW 320,200
 IF Bspieler=1 THEN Bewx=Bewx1:Bewy=Bewy1:Bewx1=0:Bewy1=-1
 IF Bspieler=2 THEN Bewx=Bewx2:Bewy=Bewy2:Bewx2=0:Bewy2=-1
 IF Bspieler=3 THEN Bewx=Bewx3:Bewy=Bewy3:Bewx3=0:Bewy3=-1
 FOR T=3 TO 1 STEP -1
 TEXT 310,190, RIGHT$( STR$(T),1)
 Bzeit= TIMER
 REPEAT UNTIL TIMER -Bzeit>=200
 NEXT T
 TEXT 310,190," "
 DRAW 320,200
 Bzeit= TIMER
 MODE =3
 REPEAT UNTIL JOYSTICK(0)=0 AND INKEY$ =""
 REPEAT
 Taste$= INKEY$
 Joy= JOYSTICK(1):Joy=Joy OR ( MOUSEBUT SHL 5)
 IF Taste$>"" OR Joy<>Joy2 AND Joy>0 THEN GOSUB Taste
 IF Bspieler=1 THEN Xb=Xb+Bewx1:Yb=Yb+Bewy1
 IF Bspieler=2 THEN Xb=Xb+Bewx2:Yb=Yb+Bewy2
 IF Bspieler=3 THEN Xb=Xb+Bewx3:Yb=Yb+Bewy3
 DRAW Xb,Yb
 WAIT 1/150
 UNTIL POINT(Xb,Yb)=0
 Bzeit=( TIMER -Bzeit)\400
 Stop_Sound(0)
 MODE =1
 FOR T=1 TO 10
 CIRCLE Xb,Yb,T
 WAIT .05
 NEXT T
 IF Bspieler=1 THEN Gew1=Gew1+Bzeit
 IF Bspieler=2 THEN Gew2=Gew2+Bzeit
 IF Bspieler=3 THEN Gew3=Gew3+Bzeit
 IF Bzeit<>1 THEN TEXT 150,380, STR$(Bzeit)+" Punkte",340,1,1 ELSE TEXT 150,380, STR$(Bzeit)+" Punkt",340,1,1
 REPEAT UNTIL INKEY$ ="" AND MOUSEBUT =0
 REPEAT UNTIL INKEY$ >"" OR MOUSEBUT >0
 REPEAT UNTIL INKEY$ ="" AND MOUSEBUT =0
 Fadepic(Bild3+6,Bild1, INT( RND(3)))
 IF Bspieler=1 THEN Bewx1=Bewx:Bewy1=Bewy
 IF Bspieler=2 THEN Bewx2=Bewx:Bewy2=Bewy
 IF Bspieler=3 THEN Bewx3=Bewx:Bewy3=Bewy
 FOR T=3 TO 1 STEP -1
 TEXT 310,190, RIGHT$( STR$(T),1)
 WAIT 1
 NEXT T
 BITBLT Bild3 TO 0,0,640,400
 CLIP 1,19 TO 638,398
 MODE =3
 Bspieler=0
 FILL STYLE =1,1
 TEXT HEIGHT =Textsize
 TEXT STYLE =0
 RETURN
-Compi1
 Richt111=Richt1
 Zufall= INT( RND(100))
 IF Extra1=0 THEN IF Compop%F(4) THEN
 FOR T=1 TO Anz_Extras
 IF Exx(T)=X1 OR Exy(T)=Y1 THEN
 Ptest=0
 IF Exx(T)=X1 THEN IF ABS(Exy(T)-Y1)<50 AND Zufall>50 OR ABS(Exy(T)-Y1)<20 THEN
 FOR S= MIN(Exy(T),Y1)+3 TO MAX(Exy(T),Y1)-1
 IF POINT(X1,S)=1 THEN Ptest=1: EXIT
 NEXT S
 IF Ptest=0 THEN Extra1=T:Bewy1= SGN(Exy(T)-Y1):Bewx1=0:Raendern1= ABS(Exy(T)-Y1)+5:Speed1=2: EXIT
 ENDIF
 IF Exy(T)=Y1 THEN IF ABS(Exx(T)-X1)<50 AND Zufall>50 OR ABS(Exx(T)-X1)<20 THEN
 Entf1= ABS(Exx(T)-X1)
 FOR S= MIN(Exx(T),X1)+3 TO MAX(Exx(T),X1)-1
 IF POINT(S,Y1)=1 THEN Ptest=1: EXIT
 NEXT S
 IF Ptest=0 THEN Extra1=T:Bewx1= SGN(Exx(T)-X1):Bewy1=0:Raendern1= ABS(Exx(T)-X1)+5:Speed1=2: EXIT
 ENDIF
 ENDIF
 NEXT T
 IF Extra1>0 THEN
 IF Bewx1=-1 THEN Richt1=1
 IF Bewx1=1 THEN Richt1=3
 IF Bewy1=-1 THEN Richt1=4
 IF Bewy1=1 THEN Richt1=2
 ENDIF
 ENDIF
 IF Zufall<Ausw AND Raendern1=0 THEN
 IF Compop%F(0)=0 AND Compop%F(1)=0 THEN
 Zufall2= INT( RND(2))
 IF Zufall2=0 THEN Richt11=1 ELSE Richt11=-1
 Richt1=Richt1+Richt11
 IF Richt1=0 THEN Richt1=4
 IF Richt1=5 THEN Richt1=1
 ELSE
 IF SQR(X2^2+Y2^2)< SQR(X3^2+Y3^2) AND Kaputt2=0 OR Kaputt3=1 THEN
   IF Richt1=2 OR Richt1=4 THEN
     Bewx1= SGN(X2-X1)*( SGN(Compop%F(1))*2+1)
     Bewy1=0
   ELSE
     Bewx1=0
     Bewy1= SGN(Y2-Y1)*( SGN(Compop%F(1))*2+1)
   ENDIF
 ELSE
   IF Richt1=2 OR Richt1=4 THEN
     Bewx1= SGN(X3-X1)*( SGN(Compop%F(1))*2+1)
     Bewy1=0
   ELSE
     Bewx1=0
     Bewy1= SGN(Y3-Y1)*( SGN(Compop%F(1))*2+1)
   ENDIF
 ENDIF
 IF Bewx1=-1 THEN Richt1=1
 IF Bewx1=1 THEN Richt1=3
 IF Bewy1=-1 THEN Richt1=4
 IF Bewy1=1 THEN Richt1=2
 ENDIF
 ENDIF
 IF Zufall=3 THEN IF Raendern1=0 AND Speed1=1 OR Speed1=2 THEN Speed1= ABS(3-Speed1)
 IF Compop%F(3) THEN IF Zufall>20 THEN IF Zufall<30 THEN IF Baktiv1=0 THEN IF Anzb1>0 THEN
 IF (X1-X3)*Bewx3<60 AND (X1-X3)*Bewx3>40 AND ABS(Y1-Y3)<10 OR (Y1-Y3)*Bewy3<60 AND (Y1-Y3)*Bewy3>40 AND ABS(X1-X3)<10 THEN
 Punkt=0
 FOR T=1 TO 20
 IF POINT(X1+Bewx1*T,Y1+Bewy1*T)>0 THEN Punkt=1: EXIT
 NEXT T
 IF Punkt=0 THEN
 Anzb1=Anzb1-1:Baktiv1=1:Bx1=X1:By1=Y1:Bcounter1=0: GOSUB Status2
 Raendern1=35
 Bausw1=20
 ENDIF
 ENDIF
 IF (X1-X2)*Bewx2<60 AND (X1-X2)*Bewx2>40 AND ABS(Y1-Y2)<10 OR (Y1-Y2)*Bewy2<60 AND (Y1-Y2)*Bewy2>40 AND ABS(X1-X2)<10 THEN
 Punkt=0
 FOR T=1 TO 20
 IF POINT(X1+Bewx1*T,Y1+Bewy1*T)>0 THEN Punkt=1: EXIT
 NEXT T
 IF Punkt=0 THEN
 Anzb1=Anzb1-1:Baktiv1=1:Bx1=X1:By1=Y1:Bcounter1=0: GOSUB Status2
 Raendern1=35
 Bausw1=20
 ENDIF
 ENDIF
 ENDIF
 IF Bausw1>0 THEN Bausw1=Bausw1-1
 IF Baktiv1=1 THEN IF Bausw1=0 THEN IF ABS(Bx1-X1)<30 THEN IF ABS(By1-Y1)<300 THEN
 IF Xaus1=0 OR Xaus1=Richt1 THEN
 Bewx1=- SGN(Bx1-X1)
 Bewy1=0
 IF Bewx1=-1 THEN Richt1=1
 IF Bewx1=1 THEN Richt1=3
 Xaus1=Richt1
 Bausw1=30
 ELSE
 Bewx1=0
 Bewy1=- SGN(By1-Y1)
 IF Bewy1=-1 THEN Richt1=4
 IF Bewy1=1 THEN Richt1=2
 Xaus1=Richt1
 Bausw1=30
 ENDIF
 ENDIF
 IF Baktiv2=1 THEN IF ABS(Bx2-X1)<30 THEN IF ABS(By2-Y1)<30 THEN IF Bausw1=0 THEN
 IF Xaus1=0 OR Xaus1=Richt1 THEN
 Bewx1=- SGN(Bx2-X1)
 Bewy1=0
 IF Bewx1=-1 THEN Richt1=1
 IF Bewx1=1 THEN Richt1=3
 Xaus1=Richt1
 Bausw1=30
 ELSE
 Bewx1=0
 Bewy1=- SGN(By2-Y1)
 IF Bewy1=-1 THEN Richt1=4
 IF Bewy1=1 THEN Richt1=2
 Xaus1=Richt1
 Bausw1=30
 ENDIF
 ENDIF
 IF Baktiv3=1 THEN IF ABS(Bx3-X1)<30 THEN IF ABS(By3-Y1)<30 THEN IF Bausw1=0 THEN
 IF Xaus1=0 OR Xaus1=Richt1 THEN
 Bewx1=- SGN(Bx3-X1)
 Bewy1=0
 IF Bewx1=-1 THEN Richt1=1
 IF Bewx1=1 THEN Richt1=3
 Xaus1=Richt1
 Bausw1=30
 ELSE
 Bewx1=0
 Bewy1=- SGN(By3-Y1)
 IF Bewy1=-1 THEN Richt1=4
 IF Bewy1=1 THEN Richt1=2
 Xaus1=Richt1
 Bausw1=30
 ENDIF
 ENDIF
 IF Laehm1=1 THEN RETURN
 IF Cricht1=2 THEN Richt11=Cricht11
 Richt11=-Richt11
 Richt1=Richt1-Richt11
 IF Richt1=0 THEN Richt1=4
 IF Richt1=5 THEN Richt1=1
 IF Unvaktiv1=1 THEN IF X1>3 THEN IF X1<637 THEN IF Y1>22 THEN IF Y1<397 THEN RETURN
 FOR A= INT( RND(2)) TO 2
 FOR B=1 TO 4
 Punkt=0
 Richt1=Richt1+Richt11
 IF Richt1=5 THEN Richt1=1
 IF Richt1=0 THEN Richt1=4
 GOSUB Richttrans1
 IF Cricht1<2 THEN D=4-A ELSE D=2:Cricht1=0
 FOR C=D TO 1 STEP -1
 Xpos=X1+Bewx1*C
 Ypos=Y1+Bewy1*C
 IF Xpos<0 THEN Xpos=0
 IF Xpos>639 THEN Xpos=639
 IF Ypos<18 THEN Ypos=18
 IF Ypos>399 THEN Ypos=399
 IF POINT(Xpos,Ypos)=1 THEN
 IF Extra1=0 THEN
 Punkt=1: EXIT TO Compi13
 ELSE
 IF Xpos>=Exx(Extra1) AND Xpos<Exx(Extra1)+3 AND Ypos>=Exy(Extra1) AND Ypos<Exy(Extra1)+3 THEN
 ELSE
 Punkt=1: EXIT TO Compi13
 ENDIF
 ENDIF
 ENDIF
 NEXT C
 EXIT
-Compi13
 NEXT B
 IF Punkt=0 THEN
 IF A=2 THEN IF Compop%F(2) THEN IF Anzs1>0 THEN IF Saktiv1=0 THEN Anzs1=Anzs1-1:Saktiv1=1:Sx1=X1:Sy1=Y1:Scounter1=10: GOSUB Status2:Speed1=1
 EXIT
 ENDIF
 NEXT A
 IF Punkt=1 THEN
 Richt1=Richt1+Richt11
 IF Richt1=0 THEN Richt1=4
 IF Richt1=5 THEN Richt1=1
 GOSUB Richttrans1
 ENDIF
 IF Richt1-Richt11=Richt111 THEN Cricht1=Cricht1+1:Cricht11=Richt11 ELSE Cricht1=0
 IF Richt1<>Richt111 THEN Raendern1=60-Ausw:Bausw1=0
 RETURN
-Richttrans1
 IF Richt1=1 THEN Bewx1=-1:Bewy1=0: RETURN
 IF Richt1=2 THEN Bewx1=0:Bewy1=1: RETURN
 IF Richt1=3 THEN Bewx1=1:Bewy1=0: RETURN
 IF Richt1=4 THEN Bewx1=0:Bewy1=-1: RETURN
-Compi2
 Richt222=Richt2
 Zufall= INT( RND(100))
 IF Extra2=0 THEN IF Zufall>50 THEN IF Compop%F(4) THEN
 FOR T=1 TO Anz_Extras
 IF Exx(T)=X2 OR Exy(T)=Y2 THEN
 Ptest=0
 IF Exx(T)=X2 THEN IF ABS(Exy(T)-Y2)<50 AND Zufall>50 OR ABS(Exy(T)-Y2)<20 THEN
 FOR S= MIN(Exy(T),Y2)+3 TO MAX(Exy(T),Y2)-1
 IF POINT(X2,S)=1 THEN Ptest=1: EXIT
 NEXT S
 IF Ptest=0 THEN Extra2=T:Bewy2= SGN(Exy(T)-Y2):Bewx2=0:Raendern2= ABS(Exy(T)-Y2)+5:Speed2=2: EXIT
 ENDIF
 IF Exy(T)=Y2 THEN IF ABS(Exx(T)-X2)<50 AND Zufall>50 OR ABS(Exx(T)-X2)<20 THEN
 FOR S= MIN(Exx(T),X2)+3 TO MAX(Exx(T),X2)-1
 IF POINT(S,Y2)=1 THEN Ptest=1: EXIT
 NEXT S
 IF Ptest=0 THEN Extra2=T:Bewx2= SGN(Exx(T)-X2):Bewy2=0:Raendern2= ABS(Exx(T)-X2)+5:Speed2=2: EXIT
 ENDIF
 ENDIF
 NEXT T
 IF Extra2>0 THEN
 IF Bewx2=-1 THEN Richt2=1
 IF Bewx2=1 THEN Richt2=3
 IF Bewy2=-1 THEN Richt2=4
 IF Bewy2=1 THEN Richt2=2
 ENDIF
 ENDIF
 IF Zufall<Ausw AND Raendern2=0 THEN
 IF Compop%F(0)=0 AND Compop%F(1)=0 THEN
 Zufall2= INT( RND(2))
 IF Zufall2=0 THEN Richt22=1 ELSE Richt22=-1
 Richt2=Richt2+Richt22
 IF Richt2=0 THEN Richt2=4
 IF Richt2=5 THEN Richt2=1
 ELSE
 IF SQR(X1^2+Y1^2)< SQR(X3^2+Y3^2) AND Kaputt1=0 OR Kaputt3=1 THEN
   IF Richt2=2 OR Richt2=4 THEN
     Bewx2= SGN(X1-X2)*( SGN(Compop%F(1))*2+1)
     Bewy2=0
   ELSE
     Bewx2=0
     Bewy2= SGN(Y1-Y2)*( SGN(Compop%F(1))*2+1)
   ENDIF
 ELSE
   IF Richt2=2 OR Richt2=4 THEN
     Bewx2= SGN(X3-X2)*( SGN(Compop%F(1))*2+1)
     Bewy2=0
   ELSE
     Bewx2=0
     Bewy2= SGN(Y3-Y2)*( SGN(Compop%F(1))*2+1)
   ENDIF
 ENDIF
 IF Bewx2=-1 THEN Richt2=1
 IF Bewx2=1 THEN Richt2=3
 IF Bewy2=-1 THEN Richt2=4
 IF Bewy2=1 THEN Richt2=2
 ENDIF
 ENDIF
 IF Zufall=3 THEN IF Raendern2=0 AND Speed2=1 OR Speed2=2 THEN Speed2= ABS(3-Speed2)
 IF Compop%F(3) THEN IF Zufall>20 THEN IF Zufall<30 THEN IF Baktiv2=0 THEN IF Anzb2>0 THEN
 IF (X2-X3)*Bewx3<60 AND (X2-X3)*Bewx3>40 AND ABS(Y2-Y3)<10 OR (Y2-Y3)*Bewy3<60 AND (Y2-Y3)*Bewy3>40 AND ABS(X2-X3)<10 THEN
 Punkt=0
 FOR T=1 TO 20
 IF POINT(X2+Bewx2*T,Y2+Bewy2*T)>0 THEN Punkt=1: EXIT
 NEXT T
 IF Punkt=0 THEN
 Anzb2=Anzb2-1:Baktiv2=1:Bx2=X2:By2=Y2:Bcounter2=0: GOSUB Status2
 Raendern2=35
 Bausw2=20
 ENDIF
 ENDIF
 IF (X2-X1)*Bewx1<60 AND (X2-X1)*Bewx1>40 AND ABS(Y2-Y1)<10 OR (Y2-Y1)*Bewy1<60 AND (Y2-Y1)*Bewy1>40 AND ABS(X2-X1)<10 THEN
 Punkt=0
 FOR T=1 TO 20
 IF POINT(X2+Bewx2*T,Y2+Bewy2*T)>0 THEN Punkt=1: EXIT
 NEXT T
 IF Punkt=0 THEN
 Anzb2=Anzb2-1:Baktiv2=1:Bx2=X2:By2=Y2:Bcounter2=0: GOSUB Status2
 Raendern2=35
 Bausw2=30
 ENDIF
 ENDIF
 ENDIF
 IF Bausw2>0 THEN Bausw2=Bausw2-1
 IF Baktiv1=1 THEN IF ABS(Bx1-X2)<30 THEN IF ABS(By1-Y2)<30 THEN IF Bausw2=0 THEN
 IF Xaus2=0 OR Xaus2=Richt2 THEN
 Bewx2=- SGN(Bx1-X2)
 Bewy2=0
 IF Bewx2=-1 THEN Richt2=1
 IF Bewx2=1 THEN Richt2=3
 Xaus2=Richt2
 Bausw2=30
 ELSE
 Bewx2=0
 Bewy2=- SGN(By1-Y2)
 IF Bewy2=-1 THEN Richt2=4
 IF Bewy2=1 THEN Richt2=2
 Xaus2=Richt2
 Bausw2=30
 ENDIF
 ENDIF
 IF Baktiv2=1 THEN IF Bausw2=0 THEN IF ABS(Bx2-X2)<30 THEN IF ABS(By2-Y2)<30 THEN
 IF Xaus2=0 OR Xaus2=Richt2 THEN
 Bewx2=- SGN(Bx2-X2)
 Bewy2=0
 IF Bewx2=-1 THEN Richt2=1
 IF Bewx2=1 THEN Richt2=3
 Xaus2=Richt2
 Bausw2=30
 ELSE
 Bewx2=0
 Bewy2=- SGN(By2-Y2)
 IF Bewy2=-1 THEN Richt2=4
 IF Bewy2=1 THEN Richt2=2
 Xaus2=Richt2
 Bausw2=30
 ENDIF
 ENDIF
 IF Baktiv3=1 THEN IF ABS(Bx3-X2)<30 THEN IF ABS(By3-Y2)<30 THEN IF Bausw2=0 THEN
 IF Xaus2=0 OR Xaus2=Richt2 THEN
 Bewx2=- SGN(Bx3-X2)
 Bewy2=0
 IF Bewx2=-1 THEN Richt2=1
 IF Bewx2=1 THEN Richt2=3
 Xaus2=Richt2
 Bausw2=30
 ELSE
 Bewx2=0
 Bewy2=- SGN(By3-Y2)
 IF Bewy2=-1 THEN Richt2=4
 IF Bewy2=1 THEN Richt2=2
 Xaus2=Richt2
 Bausw2=30
 ENDIF
 ENDIF
 IF Laehm2=1 THEN RETURN
 IF Cricht2=2 THEN Richt22=Cricht22
 Richt22=-Richt22
 Richt2=Richt2-Richt22
 IF Richt2=0 THEN Richt2=4
 IF Richt2=5 THEN Richt2=1
 IF Unvaktiv2=1 THEN IF X2>3 THEN IF X2<637 THEN IF Y2>22 THEN IF Y2<397 THEN RETURN
 FOR A= INT( RND(2)) TO 2
 FOR B=1 TO 4
 Punkt=0
 Richt2=Richt2+Richt22
 IF Richt2=5 THEN Richt2=1
 IF Richt2=0 THEN Richt2=4
 GOSUB Richttrans2
 IF Cricht2<2 THEN D=4-A ELSE D=2:Cricht2=0
 FOR C=4-A TO 1 STEP -1
 Xpos=X2+Bewx2*C
 Ypos=Y2+Bewy2*C
 IF Xpos<0 THEN Xpos=0
 IF Xpos>639 THEN Xpos=639
 IF Ypos<18 THEN Ypos=18
 IF Ypos>399 THEN Ypos=399
 IF POINT(Xpos,Ypos)=1 THEN
 IF Extra2=0 THEN
 Punkt=1: EXIT TO Compi23
 ELSE
 IF Xpos>=Exx(Extra2) AND Xpos<Exx(Extra2)+3 AND Ypos>=Exy(Extra2) AND Ypos<Exy(Extra2)+3 THEN
 ELSE
 Punkt=1: EXIT TO Compi23
 ENDIF
 ENDIF
 ENDIF
 NEXT C
 EXIT
-Compi23
 NEXT B
 IF Punkt=0 THEN
 IF A=2 THEN IF Compop%F(2) THEN IF Anzs2>0 THEN IF Saktiv2=0 THEN Speed2=1:Anzs2=Anzs2-1:Saktiv2=1:Sx2=X2:Sy2=Y2:Scounter2=10: GOSUB Status2
 EXIT
 ENDIF
 NEXT A
 IF Punkt=1 THEN
 Richt2=Richt2+Richt22
 IF Richt2=0 THEN Richt2=4
 IF Richt2=5 THEN Richt2=1
 GOSUB Richttrans2
 ENDIF
 IF Richt2-Richt22=Richt222 THEN Cricht2=Cricht2+1:Cricht22=Richt22 ELSE Cricht2=0
 IF Richt2<>Richt222 THEN Raendern2=60-Ausw:Bausw2=0
 RETURN
-Richttrans2
 IF Richt2=1 THEN Bewx2=-1:Bewy2=0: RETURN
 IF Richt2=2 THEN Bewx2=0:Bewy2=1: RETURN
 IF Richt2=3 THEN Bewx2=1:Bewy2=0: RETURN
 IF Richt2=4 THEN Bewx2=0:Bewy2=-1: RETURN
-Stat
 IF Anz_Spiele=0 THEN GOTO Hauptmenue
 Menue$(1)="STATUS"
 Wind_Text(Nr,-1,20,1,0)
 Menue$(1)=Name$(1)+" vs "+Name$(2)+" vs "+Name$(3)
 Menue$(2)=""
 Menue$(3)="Gespielte Spiele :"+ STR$(Anz_Spiele)
 Menue$(4)="Gespielte Zeit :"+ STR$(Ges_Zeit)+" Sek."
 Menue$(5)=""
 Menue$(6)="Punkte"
 Menue$(7)=Name$(1)+" :"+ STR$(Gew1)
 Menue$(8)=Name$(2)+" :"+ STR$(Gew2)
 Menue$(9)=Name$(3)+" :"+ STR$(Gew3)
 Wind_Text(Nr2,-1,100,9,-1)
 REPEAT UNTIL INKEY$ >"" OR MOUSEBUT >0
 REPEAT UNTIL INKEY$ ="" AND MOUSEBUT =0
 Wind_Close(Nr2)
 Wind_Close(Nr)
 GOTO Hauptmenue
-Options
 Menue$(1)="OPTIONS"
 Wind_Text(Nr,-1,20,1,0)
 Menue$(1)="Level editieren"
 Menue$(2)="Level laden"
 Menue$(3)="Level l”schen"
 Menue$(4)="Zufallslevel generieren"
 Menue$(5)="Spielstand speichern"
 Menue$(6)="Spielstand laden"
 Menue$(7)="Tastaturbelegung „ndern"
 Menue$(8)="Computergegner"
 Menue$(9)="Geschwindigkeit „ndern"
 Menue$(10)="Zurck"
 Menue(10,Stelle)
 Wind_Close(Nr)
 ON Stelle GOTO Levedi,Levla,Levlo,Zuflev,Spielsp,Spiella,Tastaen,Computer,Speedaen,Hauptmenue
-Zuflev
 Menue$(1)="Generiere Zufallslevel"
 Wind_Text(Nr,-1,20,1,0)
 LPOKE $44E,Bild2
 BITBLT 0,0,640,400 TO 0,0,640,400,0
 BOX 0,18 TO 639,399
 CLIP 1,19 TO 638,398
 Zufall= INT( RND(7))
 FOR T=1 TO Zufall
 BOX INT( RND(640)), INT( RND(380))+20, INT( RND(300)), INT( RND(200))
 NEXT T
 Zufall= INT( RND(7))
 FOR T=1 TO Zufall
 CIRCLE INT( RND(640)), INT( RND(380))+20, INT( RND(100))
 NEXT T
 Zufall= INT( RND(10))
 Anz_Extras=Zufall
 FOR T=1 TO Zufall
 Exlx(T)= INT( RND(640))
 Exly(T)= INT( RND(380))+20
 NEXT T
 BITBLT 0,0,640,400 TO Lvlspeicher
 CLIP
 LPOKE $44E,Bild1
 Wind_Close(Nr)
 GOTO Hauptmenue
-Levlo
 CLS
 BITBLT Lvlspeicher TO 0,0,640,400
 CLIP 1,19 TO 638,398
 FOR T=1 TO Anz_Extras
 BITBLT Extramem TO Exlx(T),Exly(T),30,40
 NEXT T
 MOUSEON
 FORM_ALERT (2,"[2][ | LEVEL L™SCHEN ?| ][  JA  |ZURšCK]",Button)
 MOUSEOFF
 CLS
 IF Button=2 THEN GOTO Hauptmenue
 Anz_Extras=0
 CLIP
 LPOKE $44E,Bild2
 CLS
 BOX 0,18 TO 639,399
 BITBLT 0,0,640,400 TO Lvlspeicher
 CLS
 LPOKE $44E,Bild1
 GOTO Options
-Levla
 Menue$(1)="LEVEL LADEN"
 Wind_Text(Nr,-1,20,1,0)
 Change_Ext("*.LEV")
 MOUSEON
 FILESELECT (Path$,Levname$,Flag)
 MOUSEOFF
 Wind_Close(Nr)
 CLS
 IF Flag=0 OR Levname$="" THEN GOTO Options
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 OPEN "i",1,Levname$
 INPUT #1,Bildname$
 INPUT #1,Bildpath$
 INPUT #1,Anz_Extras
 FOR T=1 TO Anz_Extras
 INPUT #1,Exlx(T)
 INPUT #1,Exly(T)
 NEXT T
 INPUT #1,Startx1
 INPUT #1,Starty1
 INPUT #1,Startx2
 INPUT #1,Starty2
 INPUT #1,Startx3
 INPUT #1,Starty3
 CLOSE 1
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild2), LOW(Bild2),-1)
 CHDIR Bildpath$
 BLOAD Bildname$
 BITBLT 0,0,640,400 TO Lvlspeicher
 CLS
 GOTO Hauptmenue
-Levedi
 Menue$(1)="LEVEL EDITIEREN"
 Wind_Text(Nr,-1,20,1,0)
 Menue$(1)="Hintergrund laden"
 Menue$(2)="Extras setzen"
 Menue$(3)="Extras l”schen"
 Menue$(4)="Start 1 setzen"
 Menue$(5)="Start 2 setzen"
 Menue$(6)="Start 3 setzen"
 Menue$(7)="Reset"
 Menue$(8)="Speichern"
 Menue$(9)="Zurck"
 Menue(9,Stelle)
 Wind_Close(Nr)
 ON Stelle GOTO Hladen,Exsetzen,Exloeschen,Starts,Starts,Starts,Reset,Levsp,Options
-Hladen
 Menue$(1)="HINTERGRUND LADEN"
 Wind_Text(Nr,-1,20,1,0)
 Change_Ext("*.*")
 Bildname$=""
 MOUSEON
 FILESELECT (Path$,Bildname$,Flag)
 MOUSEOFF
 Wind_Close(Nr)
 CLS
 IF Flag=0 OR Bildname$="" THEN GOTO Levedi
 Bildpath$= LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))
 CHDIR Bildpath$
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild2), LOW(Bild2),-1)
 BLOAD Bildname$
 LINE COLOR =0
 FILL COLOR =0
 PBOX 0,0 TO 639,18
 LINE COLOR =1
 FILL COLOR =1
 BOX 0,18 TO 639,399
 BITBLT 0,0,640,400 TO Lvlspeicher
 CLS
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 GOTO Levedi
-Exsetzen
 IF Anz_Extras=20 THEN
 CLS
 PRINT CHR$(7);
 PRINT "p20 Extras gesetzt !"
 PRINT "Um neue Extras zu setzen,mssen erst andere gel”scht werden !q"
 REPEAT UNTIL INKEY$ >"" OR MOUSEBUT >0
 REPEAT UNTIL INKEY$ ="" AND MOUSEBUT =0
 CLS
 GOTO Levedi
 ENDIF
 BITBLT Lvlspeicher TO 0,0,640,400
 FOR T=1 TO Anz_Extras
 BITBLT Extramem TO Exlx(T),Exly(T),30,40
 NEXT T
-Mauswartenex
 X2= MOUSEX
 Y2= MOUSEY
 IF Y2<19 THEN Y2=19
 IF X2=612 THEN Y2=612
 IF X2=0 THEN X2=1
 IF Y2=361 THEN Y2=361
 BITBLT Extramem TO X2,Y2,30,40,6
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 IF Y<19 THEN Y=19
 IF X>612 THEN X=612
 IF X=0 THEN X=1
 IF Y>361 THEN Y=361
 Knopf= MOUSEBUT
 IF X<>X2 OR Y<>Y2 THEN
 BITBLT Extramem TO X2,Y2,30,40,6
 BITBLT Extramem TO X,Y,30,40,6
 X2=X
 Y2=Y
 ENDIF
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 BITBLT Extramem TO X,Y,30,40,6
 IF Knopf=2 THEN CLS : GOTO Levedi
 IF Anz_Extras=20 THEN PRINT CHR$(7);: GOTO Mauswartenex
 Anz_Extras=Anz_Extras+1
 Exlx(Anz_Extras)=X
 Exly(Anz_Extras)=Y
 BITBLT Extramem TO X,Y,30,40
 GOTO Mauswartenex
-Exloeschen
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Lvlspeicher TO 0,0,640,400
 FOR T=1 TO Anz_Extras
 BITBLT Extramem TO Exlx(T),Exly(T),30,40
 NEXT T
 BITBLT 0,0,640,400 TO Bild3
 CLS
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Bild3 TO 0,0,640,400
 MOUSEON
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 IF Y<19 THEN Y=19
 IF X>638 THEN X=638
 IF X=0 THEN X=1
 IF Y>398 THEN Y=398
 Knopf= MOUSEBUT
 UNTIL Knopf>0
 MOUSEOFF
 IF Knopf=2 THEN REPEAT UNTIL MOUSEBUT =0: CLS : GOTO Levedi
 IF Y<19 THEN Y=19
 IF X>638 THEN X=638
 IF X=0 THEN X=1
 IF Y>398 THEN Y=398
 MODE =3
 REPEAT
 X2= MOUSEX
 Y2= MOUSEY
 IF Y2<19 THEN Y2=19
 IF X2>638 THEN X2=638
 IF X2=0 THEN X2=1
 IF Y2>398 THEN Y2=398
 IF Y2<Y+3 THEN Y2=Y+3
 IF X2<X+3 THEN X2=X+3
 BOX X,Y TO X2,Y2
 BOX X,Y TO X2,Y2
 Knopf= MOUSEBUT
 UNTIL Knopf=0
 MODE =1
 FOR T=1 TO Anz_Extras
 IF Exlx(T)>=X AND Exlx(T)<=X2 AND Exly(T)>=Y AND Exly(T)<=Y2 THEN
 Exlx(T)=0
 Exly(T)=0
 Change=1
 ENDIF
 NEXT T
 WHILE Change=1
 Change=0
 FOR T=1 TO Anz_Extras
 IF Exlx(T)=0 AND Exly(T)=0 THEN
 Anz_Extras=Anz_Extras-1
 FOR S=T TO Anz_Extras
 Exlx(S)=Exlx(S+1)
 Exly(S)=Exly(S+1)
 NEXT S
 Change=1
 EXIT
 ENDIF
 NEXT T
 WEND
 GOTO Exloeschen
-Starts
 Start=Stelle-3
 XBIOS (,5, HIGH(Bild2), LOW(Bild2), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Lvlspeicher TO 0,0,640,400
 FOR T=1 TO Anz_Extras
 BITBLT Extramem TO Exlx(T),Exly(T),30,40
 NEXT T
 BITBLT 0,0,640,400 TO Bild3
 CLS
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 BITBLT Bild3 TO 0,0,640,400
 Text$="Start"+ STR$(Start)+" X:"
 CLIP 1,19 TO 638,398
 DRAW Startx1-1,Starty1-1 TO Startx1+1,Starty1+1
 DRAW Startx1+1,Starty1-1 TO Startx1-1,Starty1+1
 DRAW Startx2-1,Starty2-1 TO Startx2+1,Starty2+1
 DRAW Startx2+1,Starty2-1 TO Startx2-1,Starty2+1
 DRAW Startx3-1,Starty3-1 TO Startx3+1,Starty3+1
 DRAW Startx3+1,Starty3-1 TO Startx3-1,Starty3+1
 TEXT HEIGHT =4
 TEXT STYLE =0
 TEXT Startx1+3,Starty1+5,"1"
 TEXT Startx2+3,Starty2+5,"2"
 TEXT Startx3+3,Starty3+5,"3"
 MODE =3
 X2= MOUSEX
 Y2= MOUSEY
 IF Y2<19 THEN Y2=19
 IF X2>638 THEN X2=638
 IF X2=0 THEN X2=1
 IF Y2>398 THEN Y2=398
 DRAW 0,Y2 TO 639,Y2
 DRAW X2,0 TO X2,399
 TEXT X2+2,Y2+6,Text$+ STR$(X2)+" Y:"+ STR$(Y2)
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 Knopf= MOUSEBUT
 IF Y<19 THEN Y=19
 IF X>638 THEN X=638
 IF X=0 THEN X=1
 IF Y>398 THEN Y=398
 IF X<>X2 OR Y<>Y2 THEN
 DRAW 0,Y2 TO 639,Y2
 DRAW X2,0 TO X2,399
 TEXT X2+2,Y2+6,Text$+ STR$(X2)+" Y:"+ STR$(Y2)
 X2=X
 Y2=Y
 DRAW 0,Y2 TO 639,Y2
 DRAW X2,0 TO X2,399
 TEXT X2+2,Y2+6,Text$+ STR$(X2)+" Y:"+ STR$(Y2)
 ENDIF
 UNTIL Knopf>0
 REPEAT UNTIL MOUSEBUT =0
 DRAW 0,Y TO 639,Y
 DRAW X,0 TO X,399
 TEXT X+2,Y+6,Text$+ STR$(X)+" Y:"+ STR$(Y)
 MODE =1
 CLIP
 TEXT HEIGHT =Textsize
 IF Knopf=2 THEN GOTO Levedi
 IF Start=1 THEN Startx1=X:Starty1=Y
 IF Start=2 THEN Startx2=X:Starty2=Y
 IF Start=3 THEN Startx3=X:Starty3=Y
 GOTO Levedi
-Reset
 CLS
 Anz_Extras=0
 LPOKE $44E,Bild2
 CLS
 BOX 0,18 TO 639,399
 BITBLT 0,0,640,400 TO Lvlspeicher
 CLS
 LPOKE $44E,Bild1
 Levname$=""
 Startx1=240
 Starty1=200
 Startx2=320
 Starty2=200
 Startx3=400
 Starty3=200
 GOTO Levedi
-Levsp
 Menue$(1)="LEVEL SPEICHERN"
 Wind_Text(Nr,-1,20,1,0)
 Change_Ext("*.LEV")
 MOUSEON
 FILESELECT (Path$,Levname$,Flag)
 MOUSEOFF
 Wind_Close(Nr)
 CLS
 IF Flag=0 OR Levname$="" THEN GOTO Levedi
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))
 OPEN "o",1,Levname$
 PRINT #1,Bildname$
 PRINT #1,Bildpath$
 PRINT #1,Anz_Extras
 FOR T=1 TO Anz_Extras
 PRINT #1,Exlx(T)
 PRINT #1,Exly(T)
 NEXT T
 PRINT #1,Startx1
 PRINT #1,Starty1
 PRINT #1,Startx2
 PRINT #1,Starty2
 PRINT #1,Startx3
 PRINT #1,Starty3
 CLOSE 1
 GOTO Levedi
-Spielsp
 Menue$(1)="SPIELSTAND SPEICHERN"
 Wind_Text(Nr,-1,20,1,0)
 Menue$(1)=Name$(1)+" vs "+Name$(2)+" vs "+Name$(3)
 Menue$(2)=""
 Menue$(3)="Gespielte Spiele :"+ STR$(Anz_Spiele)
 Menue$(4)="Gespielte Zeit :"+ STR$(Ges_Zeit)+" Sek."
 Menue$(5)=""
 Menue$(6)="Punkte"
 Menue$(7)=Name$(1)+" :"+ STR$(Gew1)
 Menue$(8)=Name$(2)+" :"+ STR$(Gew2)
 Menue$(9)=Name$(3)+" :"+ STR$(Gew3)
 Wind_Text(Nr2,-1,100,9,-1)
 PRINT "e";"B"*14
 Taste$=""
 INPUT "Speichern ? ";Taste$ USING "+j+n+J+N>",Var,1
 PRINT "f";
 Wind_Close(Nr2)
 Wind_Close(Nr)
 IF LOWER$(Taste$)="j" THEN
 Menue$(1)="SPIELSTAND SPEICHERN"
 Wind_Text(Nr,-1,20,1,0)
 Change_Ext("*.SAV")
 Name$=""
 MOUSEON
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 Wind_Close(Nr)
 CLS
 IF Flag=0 OR Name$="" THEN GOTO Options
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))
 OPEN "o",1,Name$
 PRINT #1,Name$(1)
 PRINT #1,Name$(2)
 PRINT #1,Anz_Spiele
 PRINT #1,Ges_Zeit
 PRINT #1,Gew1
 PRINT #1,Gew2
 PRINT #1,Gew3
 PRINT #1,Anz_Spieler
 CLOSE 1
 ENDIF
 GOTO Hauptmenue
-Spiella
 Menue$(1)="SPIELSTAND LADEN"
 Wind_Text(Nr,-1,20,1,0)
 Change_Ext("*.SAV")
 Name$=""
 MOUSEON
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 Wind_Close(Nr)
 CLS
 IF Flag=0 OR Name$="" THEN GOTO Options
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))
 OPEN "i",1,Name$
 INPUT #1,Name$(1)
 INPUT #1,Name$(2)
 INPUT #1,Anz_Spiele
 INPUT #1,Ges_Zeit
 INPUT #1,Gew1
 INPUT #1,Gew2
 INPUT #1,Gew3
 INPUT #1,Anz_Spieler
 CLOSE 1
 GOTO Hauptmenue
-Speedaen
 Menue$(1)="GESCHWINDIGKEIT ŽNDERN"
 Wind_Text(Nr,-1,20,1,0)
 PRINT "B"*4
 PRINT "Alte Geschwindigkeit : "; STR$(Warten!*10000)
 PRINT
 PRINT "0 = sehr schnell   1000 = sehr langsam"
 PRINT "A"*2;
-Speedaen2
 Text$=""
 PRINT "e";
 INPUT "Neue Geschwindigkeit (0-1000) ? ";Text$ USING "0",Var,4
 PRINT "f";
 IF Text$="" THEN GOTO Options
 Gesch= VAL(Text$)
 IF Gesch<0 OR Gesch>1000 THEN PRINT CHR$(7): PRINT "A";: GOTO Speedaen2
 Warten!=Gesch/10000
 Wind_Close(Nr)
 GOTO Hauptmenue
-Tastaen
 Menue$(1)="TASTENBELEGUNG ŽNDERN"
 Wind_Text(Nr,-1,20,1,0)
 PRINT "B"*4
 PRINT "Spieler 1 :"
 PRINT "Links :"
 PRINT "Alte Taste : ";Sl1$
 Input_Zeichen(0)
 IF Taste$="" THEN GOTO Tastaen2
 Sl1$=Taste$
 PRINT "Rechts :"
 PRINT "Alte Taste : ";Sr1$
 Input_Zeichen(0)
 IF Taste$="" THEN GOTO Tastaen2
 Sr1$=Taste$
 PRINT "Oben :"
 PRINT "Alte Taste : ";So1$
 Input_Zeichen(0)
 IF Taste$="" THEN GOTO Tastaen2
 So1$=Taste$
 PRINT "Unten :"
 PRINT "Alte Taste : ";Su1$
 Input_Zeichen(0)
 IF Taste$="" THEN GOTO Tastaen2
 Su1$=Taste$
 PRINT "Bomben :"
 PRINT "Alte Taste : ";Sb1$
 Input_Zeichen(0)
 IF Taste$="" THEN GOTO Tastaen2
 Sb1$=Taste$
 PRINT "Sprenger :"
 PRINT "Alte Taste : ";Sw1$
 Input_Zeichen(0)
 IF Taste$="" THEN GOTO Tastaen2
 Sw1$=Taste$
 PRINT "Speed :"
 PRINT "Alte Taste : ";Ss1$
 Input_Zeichen(0)
 IF Taste$="" THEN GOTO Tastaen2
 Ss1$=Taste$
 PRINT @(3,0)
 PRINT TAB (30);"Spieler 2 :"
 PRINT TAB (30);"Links :"
 PRINT TAB (30);"Alte Taste : ";Sl2$
 Input_Zeichen(30)
 IF Taste$="" THEN GOTO Tastaen2
 Sl2$=Taste$
 PRINT TAB (30);"Rechts :"
 PRINT TAB (30);"Alte Taste : ";Sr2$
 Input_Zeichen(30)
 IF Taste$="" THEN GOTO Tastaen2
 Sr2$=Taste$
 PRINT TAB (30);"Oben :"
 PRINT TAB (30);"Alte Taste : ";So2$
 Input_Zeichen(30)
 IF Taste$="" THEN GOTO Tastaen2
 So2$=Taste$
 PRINT TAB (30);"Unten :"
 PRINT TAB (30);"Alte Taste : ";Su2$
 Input_Zeichen(30)
 IF Taste$="" THEN GOTO Tastaen2
 Su2$=Taste$
 PRINT TAB (30);"Bomben :"
 PRINT TAB (30);"Alte Taste : ";Sb2$
 Input_Zeichen(30)
 IF Taste$="" THEN GOTO Tastaen2
 Sb2$=Taste$
 PRINT TAB (30);"Sprenger :"
 PRINT TAB (30);"Alte Taste : ";Sw2$
 Input_Zeichen(30)
 IF Taste$="" THEN GOTO Tastaen2
 Sw2$=Taste$
 PRINT TAB (30);"Speed :"
 PRINT TAB (30);"Alte Taste : ";Ss2$
 Input_Zeichen(30)
 IF Taste$="" THEN GOTO Tastaen2
 Ss2$=Taste$
 PRINT @(20,0);
 Taste$=""
 PRINT "e";
 INPUT "Speichern ? ";Taste$ USING "+j+n+J+N>",Var,1
 PRINT "f";
 IF LOWER$(Taste$)="j" THEN
 CHDIR Path$+"\DATAS"
 OPEN "o",1,"TASTEN.INF"
 PRINT #1,Sl1$
 PRINT #1,Sr1$
 PRINT #1,So1$
 PRINT #1,Su1$
 PRINT #1,Sb1$
 PRINT #1,Sw1$
 PRINT #1,Ss1$
 PRINT #1,Sl2$
 PRINT #1,Sr2$
 PRINT #1,So2$
 PRINT #1,Su2$
 PRINT #1,Sb2$
 PRINT #1,Sw2$
 PRINT #1,Ss2$
 CLOSE 1
 CHDIR Path$
 ENDIF
-Tastaen2
 Wind_Close(Nr)
 CLS
 GOTO Options
-Computer
 Menue$(1)="COMPUTERGEGNER"
 Wind_Text(Nr,-1,20,1,0)
-Computer2
 Menue$(1)="spielt "
 IF Compop%F(0) THEN Menue$(1)=Menue$(1)+"offensiv" ELSE IF Compop%F(1) THEN Menue$(1)=Menue$(1)+"defensiv" ELSE Menue$(1)=Menue$(1)+"neutral"
 Menue$(2)="   wirft Sprenger   "
 IF Compop%F(2) THEN Menue$(2)="->"+Menue$(2)+"<-" ELSE Menue$(2)="  "+Menue$(2)+"  "
 Menue$(3)="    wirft Bomben    "
 IF Compop%F(3) THEN Menue$(3)="->"+Menue$(3)+"<-" ELSE Menue$(3)="  "+Menue$(3)+"  "
 Menue$(4)="   sammelt Extras   "
 IF Compop%F(4) THEN Menue$(4)="->"+Menue$(4)+"<-" ELSE Menue$(4)="  "+Menue$(4)+"  "
 Menue$(5)="Richtungswechsel :"+ STR$(Ausw)
 Menue$(6)="Zurck"
 Menue(6,Stelle)
 IF Stelle=6 THEN Wind_Close(Nr): GOTO Options
 IF Stelle=5 THEN
 Wind_Close(Nr)
 PRINT "e";
 REPEAT
 INPUT @(0,0);"Richtungswechsel : K";Ausw
 UNTIL Ausw>0 AND Ausw<60
 PRINT "f";
 CLS
 GOTO Computer
 ENDIF
 IF Stelle=1 THEN
 IF Compop%F(1) THEN Compop%F(0)=-1:Compop%F(1)=0: GOTO Computer2
 IF Compop%F(0) THEN Compop%F(0)=0:Compop%F(1)=0 ELSE Compop%F(1)=-1
 ENDIF
 IF Stelle>1 THEN Compop%F(Stelle)= NOT (Compop%F(Stelle))
 GOTO Computer2
-Ende
 CLS
 MOUSEON
 FORM_ALERT (1,"[2][ | Wollen sie wirklich | nicht noch eine | Runde spielen ?][ NEIN ! | DOCH,JA ]",Knopf)
 MOUSEOFF
 IF Knopf=2 THEN GOTO Hauptmenue
 IPL 3
 Exit_Sound
 END
-Fehler
 XBIOS (,5, HIGH(Bild1), LOW(Bild1), HIGH(Bild1), LOW(Bild1),-1)
 Text$="[3][ Ein Fehler ist aufgetreten | "+ ERR$ +" | in "+ STR$( ERL )+" ]"
 Text$=Text$+"[NEUVERSUCH|WEITER|ENDE]"
 MOUSEON
 FORM_ALERT (1,Text$,Knopf)
 MOUSEOFF
 IF Knopf=1 THEN RESUME
 IF Knopf=2 THEN RESUME NEXT
 IPL 3
 STOP
-Extra
 DATA %11100000,%0,%0,%0,%0,%11100000,%0,%0,%0,%0,%11100000,%0,%0,%0,%0
 DATA %0,%0,%0,%0,%0,%1111,%0,%0,%0,%0,%1110,%0,%0,%0,%0,%1111,%0,%0,%0,%0
 DATA %1011,%10000000,%0,%0,%0,%1,%11000000,%0,%0,%0,%0,%11000000,%0,%0,%0
 DATA %0,%0,%0,%0,%0,%0,%0,%0,%0,%0,%0,%11,%11111111,%11100000,%0
 DATA %0,%111,%11111111,%11000000,%0,%0,%1111,%11111111,%10000000,%0
 DATA %0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0
 DATA %0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0
 DATA %0,%1111,%11111111,%11100000,%0,%0,%1111,%11111111,%11000000,%0
 DATA %0,%1111,%11111111,%10000000,%0,%0,%1110,%0,%0,%0
 DATA %0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0
 DATA %0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0,%0,%1110,%0,%0,%0
 DATA %0,%1111,%11111111,%10000000,%0,%0,%111,%11111111,%11000000,%0
 DATA %0,%11,%11111111,%11100000,%0,%0,%0,%0,%0,%0,%0,%0,%0,%0,%0
 ' Die Soundroutinen
 DEF PROC Init_Sound(Anz)
 Anz_Sounds=Anz
 DIM Huellkurve%B(200,Anz-1),Rhuellkurve%B(200,Anz-1)
 DIM Rauschan%F(Anz-1),Tonan%F(Anz-1)
 DIM Tremolo%B(200,Anz-1),Tfaktor%B(Anz-1)
 DIM Frequenz%(2),Schrittzaehler%(2)
 DIM Hzeiger%B(2),Rzeiger%B(0),Tzeiger%B(2)
 DIM Stimme%B(2),Huell(2),Trem(2),Huell2(2),Trem2(2)
 DIM Rauschoff%B(0),Rsound%B(0)
 DIM Effect(19,9)
 Click_Off
 Stop_All
 FOR T=1 TO Anz
 Tfaktor%B(T-1)=1
 Tonan%F(T-1)=1
 Rauschan%F(T-1)=0
 FOR S=0 TO 199
 Tremolo%B(S,T-1)=128
 NEXT S
 NEXT T
 ON TIMER .1 GOSUB Soundupdate
 RETURN
 '
 DEF PROC Exit_Sound
 ON TIMER 1 GOSUB 0
 NOISE 0,0
 VOLUME 1,0
 VOLUME 2,0
 VOLUME 3,0
 TUNE 1,0
 TUNE 2,0
 TUNE 3,0
 Click_On
 RETURN
 '
 DEF PROC Click_On
 POKE $484,15
 RETURN
 '
 DEF PROC Click_Off
 POKE $484,10
 RETURN
 '
 DEF PROC Start_Sound(Istimme,Sound,Dauer,Hoehe)
 ON TIMER 1 GOSUB 0
 Stimme%B(Istimme)=Sound
 Hzeiger%B(Istimme)=0
 Rzeiger%B(0)=0
 Tzeiger%B(Istimme)=0
 Schrittzaehler%(Istimme)=Dauer
 Frequenz%(Istimme)=Hoehe
 IF NOT Tonan%F(Sound-1) THEN TUNE Istimme+1,0
 BIT (Istimme,Rauschoff%B(0))=Rauschan%F(Sound-1)
 IF Rauschan%F(Sound-1) THEN Rsound%B(0)=Sound
 NOISE Rauschoff%B(0),Rhuellkurve%B(Rzeiger%B(0), MAX(0,Rsound%B(0)-1))
 ON TIMER .1 GOSUB Soundupdate
 RETURN
 '
 DEF PROC Start_All(Sound1,Sound2,Sound3,Dauer1,Dauer2,Dauer3,Hoehe1,Hoehe2,Hoehe3,Rauschst)
 ON TIMER 1 GOSUB 0
 Stimme%B(0)=Sound1
 Hzeiger%B(0)=0
 Tzeiger%B(0)=0
 Schrittzaehler%(0)=Dauer1
 Frequenz%(0)=Hoehe1
 IF NOT Tonan%F(0) THEN TUNE 1,0
 BIT (0,Rauschoff%B(0))=Rauschan%F(0)
 Rsound%B(0)=Rauschst
 Stimme%B(1)=Sound2
 Hzeiger%B(1)=0
 Tzeiger%B(1)=0
 Schrittzaehler%(1)=Dauer2
 Frequenz%(1)=Hoehe2
 IF NOT Tonan%F(1) THEN TUNE 2,0
 BIT (1,Rauschoff%B(0))=Rauschan%F(1)
 Stimme%B(2)=Sound3
 Hzeiger%B(2)=0
 Rzeiger%B(0)=0
 Tzeiger%B(2)=0
 Schrittzaehler%(2)=Dauer3
 Frequenz%(2)=Hoehe3
 IF NOT Tonan%F(2) THEN TUNE 3,0
 BIT (2,Rauschoff%B(0))=Rauschan%F(2)
 NOISE Rauschoff%B(0),Rhuellkurve%B(Rzeiger%B(0), MAX(0,Rsound%B(0)-1))
 ON TIMER .1 GOSUB Soundupdate
 RETURN
 '
 DEF PROC Stop_Sound(Istimme)
 ON TIMER 1 GOSUB 0
 Stimme%B(Istimme)=0
 VOLUME Istimme+1,0
 TUNE Istimme+1,0
 ON TIMER .1 GOSUB Soundupdate
 RETURN
 '
 DEF PROC Stop_All
 Stop_Sound(0)
 Stop_Sound(1)
 Stop_Sound(2)
 RETURN
 '
 DEF PROC Load_All(Sound,Anz,Sndname$)
 ON TIMER 1 GOSUB 0
 OPEN "i",1,Sndname$
 FOR S=Sound-1 TO Sound+Anz-2
 FOR T=0 TO 199
 A$= INPUT$(1,1)
 IF ASC(A$)<254 THEN
 Huellkurve%B(T,S)= ASC(A$)-128
 ELSE
 Huellkurve%B(T,S)= ASC(A$)
 ENDIF
 NEXT T
 FOR T=0 TO 199
 A$= INPUT$(1,1)
 IF ASC(A$)<254 THEN
 Rhuellkurve%B(T,S)= ASC(A$)-128
 ELSE
 Rhuellkurve%B(T,S)= ASC(A$)
 ENDIF
 NEXT T
 FOR T=0 TO 199
 A$= INPUT$(1,1)
 Tremolo%B(T,S)= ASC(A$)
 NEXT T
 INPUT #1,Zahl$
 Zahl= ASC(Zahl$)
 Tfaktor%B(S)=Zahl AND %111111
 Tonan%F(S)= BIT(7,Zahl)
 Rauschan%F(S)= BIT(6,Zahl)
 NEXT S
 CLOSE 1
 ON TIMER .1 GOSUB Soundupdate
 RETURN
 '
-Soundupdate
 ON TIMER 1 GOSUB 0
 FOR Schl=0 TO 2
 IF Stimme%B(Schl)>0 THEN
 Huell(Schl)=Huellkurve%B(Hzeiger%B(Schl),Stimme%B(Schl)-1)
 Trem(Schl)=Tremolo%B(Tzeiger%B(Schl),Stimme%B(Schl)-1)
 IF Huell(Schl)=254 THEN Hzeiger%B(Schl)=0:Huell(Schl)=Huellkurve%B(0,Stimme%B(Schl)-1)
 IF Huell(Schl)=255 OR Trem(Schl)=255 THEN Stimme%B(Schl)=0: VOLUME Schl+1,0: TUNE Schl+1,0: GOTO Soundupdate2
 IF Trem(Schl)=254 THEN Tzeiger%B(Schl)=0:Trem(Schl)=Tremolo%B(0,Stimme%B(Schl)-1)
 IF Hzeiger%B(Schl)=0 OR Huell2(Schl)<>Huell(Schl) THEN VOLUME Schl+1,Huell(Schl)
 IF Tonan%F(Stimme%B(Schl)-1) AND (Tzeiger%B(Schl)=0 OR Trem2(Schl)<>Trem(Schl)) THEN TUNE Schl+1,Frequenz%(Schl)+(128-Trem(Schl))*Tfaktor%B(Stimme%B(Schl)-1)
 Huell2(Schl)=Huell(Schl)
 Trem2(Schl)=Trem(Schl)
 Hzeiger%B(Schl)=Hzeiger%B(Schl)+1
 Tzeiger%B(Schl)=Tzeiger%B(Schl)+1
 IF Hzeiger%B(Schl)=200 OR Tzeiger%B(Schl)=200 THEN Stimme%B(Schl)=0: VOLUME Schl+1,0: TUNE Schl+1,0
 IF Schrittzaehler%(Schl)>-1 THEN Schrittzaehler%(Schl)=Schrittzaehler%(Schl)-1
 IF Schrittzaehler%(Schl)=0 THEN VOLUME Schl+1,0: TUNE Schl+1,0:Stimme%B(Schl)=0
 ENDIF
-Soundupdate2
 NEXT Schl
 IF Rauschoff%B(0)>0 THEN
 IF Rhuellkurve%B(Rzeiger%B(0),Rsound%B(0)-1)=254 THEN Rzeiger%B(0)=0
 IF Rhuellkurve%B(Rzeiger%B(0),Rsound%B(0)-1)=255 THEN NOISE 0,0:Rauschoff%B(0)=0: ON TIMER .1 GOSUB Soundupdate: RETURN
 IF (Rzeiger%B(0)=0 OR Rhuellkurve%B( MAX(0,Rzeiger%B(0)-1),Rsound%B(0)-1)<>Rhuellkurve%B(Rzeiger%B(0),Rsound%B(0)-1)) THEN NOISE Rauschoff%B(0),Rhuellkurve%B(Rzeiger%B(0),Rsound%B(0)-1)
 Rzeiger%B(0)=Rzeiger%B(0)+1: IF Rzeiger%B(0)=200 THEN Rauschoff%B(0)=0: NOISE 0,0
 ENDIF
 IF Statusz>0 THEN Statusz=Statusz-1: IF Statusz=0 THEN Statusz=9: GOSUB Status
 ON TIMER .1 GOSUB Soundupdate
 RETURN
 DEF PROC Fadepic(Adr1,Adr2,Modus)
 ' Adr1 : Adresse, von der kopiert wird
 ' Adr2 : Adresse, zu der kopiert wird
 LOCAL X,X2,Y,Y2,Speicher,Adresse
 IF Modus=0 THEN
 Speicher=Adr1+2
 Adresse=Adr2+2
 FOR Y=0 TO 399 STEP 32
 FOR Y2=0 TO 15
 FOR X=0 TO 19
 WPOKE Adresse, WPEEK(Speicher)
 Speicher=Speicher+4
 Adresse=Adresse+4
 NEXT X
 NEXT Y2
 Speicher=Speicher-2:Adresse=Adresse-2
 FOR Y2=0 TO 15
 FOR X=0 TO 19
 WPOKE Adresse, WPEEK(Speicher)
 Speicher=Speicher+4
 Adresse=Adresse+4
 NEXT X
 NEXT Y2
 Speicher=Speicher+2:Adresse=Adresse+2
 NEXT Y
 Speicher=Adr1+31996
 Adresse=Adr2+31996
 FOR Y=0 TO 399 STEP 32
 FOR Y2=0 TO 15
 FOR X=0 TO 19
 WPOKE Adresse, WPEEK(Speicher)
 Speicher=Speicher-4
 Adresse=Adresse-4
 NEXT X
 NEXT Y2
 Speicher=Speicher+2:Adresse=Adresse+2
 FOR Y2=0 TO 15
 FOR X=0 TO 19
 WPOKE Adresse, WPEEK(Speicher)
 Speicher=Speicher-4
 Adresse=Adresse-4
 NEXT X
 NEXT Y2
 Speicher=Speicher-2:Adresse=Adresse-2
 NEXT Y
 ENDIF
 IF Modus=1 THEN
 Speicher=Adr1
 Adresse=Adr2
 FOR Y=0 TO 399
 FOR X=0 TO 39
 POKE Adresse, PEEK(Speicher)
 Speicher=Speicher+2
 Adresse=Adresse+2
 NEXT X
 NEXT Y
 Speicher=Adr1+1
 Adresse=Adr2+1
 FOR Y=0 TO 399
 FOR X=0 TO 39
 POKE Adresse, PEEK(Speicher)
 Speicher=Speicher+2
 Adresse=Adresse+2
 NEXT X
 NEXT Y
 ENDIF
 IF Modus=2 THEN
 Speicher=Adr1
 Adresse=Adr2
 FOR Y=0 TO 404
 FOR X=0 TO 9
 FOR X2=0 TO 3
 POKE Adresse, PEEK(Speicher)
 Speicher=Speicher+1
 Adresse=Adresse+1
 NEXT X2
 Speicher=Speicher+4
 Adresse=Adresse+4
 NEXT X
 Speicher=Speicher-1
 Adresse=Adresse-1
 NEXT Y
 FOR X2=0 TO 3
 POKE Adresse, PEEK(Speicher)
 Speicher=Speicher+1
 Adresse=Adresse+1
 NEXT X2
 Speicher=Adr1+4
 Adresse=Adr2+4
 FOR Y=0 TO 404
 FOR X=0 TO 9
 FOR X2=0 TO 3
 POKE Adresse, PEEK(Speicher)
 Speicher=Speicher+1
 Adresse=Adresse+1
 NEXT X2
 Speicher=Speicher+4
 Adresse=Adresse+4
 NEXT X
 Speicher=Speicher-1
 Adresse=Adresse-1
 NEXT Y
 FOR X2=0 TO 3
 POKE Adresse, PEEK(Speicher)
 Speicher=Speicher+1
 Adresse=Adresse+1
 NEXT X2
 ENDIF
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
 DEF PROC Resolution
 ' Fragt die Aufl”sung ab
   XBIOS (Aufl,4)
   IF Aufl=0 THEN ' 320*200 Punkte
     Xfak=1
     Yfak=1
     Textsize=6
     Farben=16
   ENDIF
   IF Aufl=1 THEN ' 640*200 Punkte
     Xfak=2
     Yfak=1
     Textsize=6
     Farben=4
   ENDIF
   IF Aufl=2 THEN ' 640*400 Punkte
     Xfak=2
     Yfak=2
     Textsize=13
     Farben=2
   ENDIF
   Maxx=320*Xfak
   Maxy=200*Yfak
 RETURN
 '
 DEF PROC Malloc(R Bytes)
 ' Reserviert Speicher
   LOCAL Adresse,Frei
   Frei= MEMORY(-1)
   IF Bytes>Frei THEN ERROR 7
   GEMDOS (Adresse,72, HIGH(Bytes), LOW(Bytes))
   Bytes=Adresse
 RETURN
 '
 DEF PROC Mfree(Adresse)
 ' L”scht reservierten Speicher
   GEMDOS (,73, HIGH(Adresse), LOW(Adresse))
 RETURN
 '
 DEF PROC Wind_Open(R Nr,R X,R Y,Xb,Yb)
 ' ™ffnet ein Fenster (nicht GEM)
 ' Fenster(Nr,0) : Adresse des Bitblocks
 ' Fenster(Nr,1) : X-Position
 ' Fenster(Nr,2) : Y-Position
 ' Fenster(Nr,3) : Breite
 ' Fenster(Nr,4) : H”he
   LOCAL T
   Nr=0
   IF X+Xb*Xfak>Maxx THEN X=Maxx-Xb*Xfak
   IF Y+Yb*Yfak>Maxy THEN Y=Maxy-Yb*Yfak
   FOR T=1 TO Anzfenster
     IF Fenster(T-1,0)=-1 THEN Nr=T: EXIT
   NEXT T
   IF Nr=0 THEN
     Anzfenster=Anzfenster+1
     IF Anzfenster=Maxfenster+1 THEN
       PRINT CHR$(7);"? Zu viele Fenster ge”ffnet !"
       WAIT 2
       GOTO Ende
     ENDIF
     Nr=Anzfenster
   ENDIF
   Fenster(Nr-1,0)=((Xb+3)*2+15) SHR 4*((Yb+3)*2)*2+261
   Malloc(Fenster(Nr-1,0))
   Fenster(Nr-1,1)=X
   Fenster(Nr-1,2)=Y
   Fenster(Nr-1,3)=Xb*Xfak
   Fenster(Nr-1,4)=Yb*Yfak
   BITBLT Fenster(Nr-1,1),Fenster(Nr-1,2),Fenster(Nr-1,3)+2*Xfak,Fenster(Nr-1,4)+2*Yfak TO Fenster(Nr-1,0)
   BOX Fenster(Nr-1,1),Fenster(Nr-1,2),Fenster(Nr-1,3),Fenster(Nr-1,4)' Fensterrand
   BOX Fenster(Nr-1,1)+Xfak\2,Fenster(Nr-1,2)+Yfak\2,Fenster(Nr-1,3)-(Xfak\2)*2,Fenster(Nr-1,4)-(Yfak\2)*2
   FILL STYLE =1,1
   PBOX Fenster(Nr-1,1)+3*Xfak,Fenster(Nr-1,2)+Fenster(Nr-1,4) TO Fenster(Nr-1,1)+Fenster(Nr-1,3)+2*Xfak-1,Fenster(Nr-1,2)+Fenster(Nr-1,4)+2*Yfak-1' Schatten
   PBOX Fenster(Nr-1,1)+Fenster(Nr-1,3),Fenster(Nr-1,2)+3*Yfak TO Fenster(Nr-1,1)+Fenster(Nr-1,3)+2*Xfak-1,Fenster(Nr-1,2)+Fenster(Nr-1,4)' Schatten
   FILL STYLE =0,0
   PBOX Fenster(Nr-1,1)+2*Xfak,Fenster(Nr-1,2)+2*Yfak,Fenster(Nr-1,3)-4*Xfak,Fenster(Nr-1,4)-4*Yfak' Fensterinhalt
   FILL STYLE =Muster,Index
   LINE COLOR =0
   BOX Fenster(Nr-1,1)+Xfak,Fenster(Nr-1,2)+Yfak,Fenster(Nr-1,3)-2*Xfak,Fenster(Nr-1,4)-2*Yfak' Rahmen abheben
   BOX Fenster(Nr-1,1)+Xfak+Xfak\2,Fenster(Nr-1,2)+Yfak+Yfak\2,Fenster(Nr-1,3)-2*Xfak-(Xfak\2)*2,Fenster(Nr-1,4)-2*Yfak-(Yfak\2)*2
   LINE COLOR =Linienfarbe
 RETURN
 '
 DEF PROC Wind_Close(Nr)
 ' Schliežt ein Fenster
   LOCAL T
   IF Nr=-1 THEN ' Alle Fenster schliežen
     FOR T=Anzfenster TO 1 STEP -1
       IF Fenster(T-1,0)>0 THEN Wind_Close(T)
     NEXT T
     RETURN
   ENDIF
   IF Fenster(Nr-1,0)<=0 THEN
     PRINT CHR$(7);"? Fenster";Nr;" nicht ge”ffnet !"
     WAIT 2
     GOTO Ende
   ENDIF
   Nr=Nr-1
   BITBLT Fenster(Nr,0) TO Fenster(Nr,1),Fenster(Nr,2),Fenster(Nr,3)+2*Xfak,Fenster(Nr,4)+2*Yfak
   Mfree(Fenster(Nr,0))
   Fenster(Nr,0)=-1
 RETURN
 '
 DEF PROC Menue(Anz_Menuepunkte,R Auswahl)
 ' Stellt ein Menue dar
   LOCAL Maxlength,X,Y,Xp,Yp,Nr,T,Xm,Ym,Ym2,Knopf
   Maxlength=25
   Xp=(Maxlength+2*Xfak)*8\Xfak
   Yp=(Anz_Menuepunkte+2)*8-Yfak*4
   X=FN Centerx(Xp)
   Y=150
   Wind_Open(Nr,X,Y,Xp,Yp)
   TEXT HEIGHT =Textsize
   FOR T=1 TO Anz_Menuepunkte
     TEXT X+8*Xfak,Y+8*Yfak*T+4,Menue$(T)
   NEXT T
   Xm= MOUSEX
   Ym2= INT(( MOUSEY -Y-2*Yfak^2)\(8*Yfak))
   IF Ym2<0 OR Ym2>=Anz_Menuepunkte THEN Ym2=0
   BITBLT 0,0,Maxlength*8+2,7*Yfak+1 TO X+8*Xfak-1,Y+8*Yfak*Ym2+6+(Yfak\2)*2,Maxlength*8+2,7*Yfak+1,10
   Auswahl=0
   MOUSEON
   REPEAT ' Warten bis Mausknopf gedrckt
     Xm= MOUSEX
     Ym= INT(( MOUSEY -Y-2*Yfak^2)\(8*Yfak))
     Knopf= MOUSEBUT
     IF Xm>X+8*Xfak-2 AND Xm<X+8*Xfak+Maxlength*8+6 AND Ym<>Ym2 AND Ym>=0 AND Ym<Anz_Menuepunkte THEN
       MOUSEOFF
       BITBLT 0,0,Maxlength*8+2,7*Yfak+1 TO X+8*Xfak-1,Y+8*Yfak*Ym+6+(Yfak\2)*2,Maxlength*8+2,7*Yfak+1,10
       BITBLT 0,0,Maxlength*8+2,7*Yfak+1 TO X+8*Xfak-1,Y+8*Yfak*Ym2+6+(Yfak\2)*2,Maxlength*8+2,7*Yfak+1,10
       MOUSEON
       Ym2=Ym
     ENDIF
   UNTIL Knopf>0
   REPEAT UNTIL MOUSEBUT =0
   MOUSEOFF
   Auswahl=Ym2+1
   Wind_Close(Nr)
 RETURN
 '
 DEF PROC Wind_Text(R Nr,X,Y,Zeilen,Zentriert)
 ' Gibt ein Fenster mit Text aus
   LOCAL Maxlength,Xp,Yp,T,Mitte
   FOR T=1 TO Zeilen
     IF LEN(Menue$(T))>Maxlength THEN Maxlength= LEN(Menue$(T))
   NEXT T
   Xp=(Maxlength+2)*(8\Xfak)
   Yp=(Zeilen+1)*8
   IF X=-1 THEN X=FN Centerx(Xp)
   IF Y=-1 THEN Y=FN Centery(Yp)
   Wind_Open(Nr,X,Y,Xp,Yp)
   Mitte=X+Xp*Xfak\2
   TEXT HEIGHT =Textsize
   IF NOT (Zentriert) THEN
     FOR T=1 TO Zeilen
       TEXT X+8,Y+(8*T)*Yfak+2*Yfak,Menue$(T)
     NEXT T
   ELSE
     FOR T=1 TO Zeilen
       TEXT Mitte- LEN(Menue$(T))*4,Y+8*T*Yfak+2*Yfak,Menue$(T)
     NEXT T
   ENDIF
 RETURN
 '
 DEF FN Centerx(Xb)=((320-Xb)\2)*Xfak
 DEF FN Centery(Yb)=((200-Yb)\2)*Yfak
