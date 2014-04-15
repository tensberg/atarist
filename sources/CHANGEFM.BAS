 CLS
 PRINT "f";
 CLEAR 32256*3
 Resolution
 Get_Path
 CLIP 0,0,Maxx,Maxy
 DIM Farbe(15),Farbe$(15),Muster(7,3),Muster2(15,1,1),Durchschnitt(15),X(10)
 DIM Fenster(3,4),Menue$(10)
 Maxfenster=3
 Speicher1= MEMORY(32512)
 Speicher2= LPEEK($44E)
 Speicher3= MEMORY(32256)
 Wandel=0
 Laden=0
 Routine=0
 Linienfarbe=1
 X= MOUSEX
 Y= MOUSEY
 CLS
-Hauptmenue
 Menue$(1)="      BILDWANDLER"
 Menue$(2)="by the Cook Soft Company"
 Menue$(3)="------------------------"
 Menue$(4)="Bild umwandeln"
 Menue$(5)="Bild laden"
 Menue$(6)="Routine festlegen"
 Menue$(7)="Gewandeltes Bild speichern"
 Menue$(8)="ENDE"
 Aktiv=%1101
 IF Laden=1 AND Routine=1 THEN BIT (4,Aktiv)=-1
 IF Wandel=1 THEN BIT (1,Aktiv)=-1
 Menue(X,Y,3,5,Aktiv,Stelle)
 ON Stelle GOTO Wandeln,Laden,Routine,Speichern,Prgende
-Laden
 Menue$(1)="BILD LADEN"
 Wind_Text(Nr,-1,10,1,0)
 Change_Ext(Path$,"*.PI1")
 Name$=""
 MOUSEON
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 Wind_Close(Nr)
 CLS
 IF Name$="" OR Flag<>1 THEN GOTO Hauptmenue
 Change_Ext(Path$,"")
 CHDIR Path$
 BLOAD Name$,Speicher1
 FOR T=2 TO 32 STEP 2
 Farbe((T-2)/2)= WPEEK(Speicher1+T)
 Farbe$((T-2)/2)= HEX$(Farbe((T-2)/2))
 NEXT T
 Laden=1
 FOR T=0 TO 3
 Muster(0,T)=%1111
 NEXT T
 Muster(1,0)=%1110
 Muster(1,1)=%111
 Muster(1,2)=%1101
 Muster(1,3)=%1011
 FOR T=0 TO 3
 Muster(2,T)=Muster(1,3-T)
 NEXT T
 Muster(3,0)=%1010
 Muster(3,1)=%1001
 Muster(3,2)=%101
 Muster(3,3)=%110
 Muster(4,0)=%110
 Muster(4,1)=%101
 Muster(4,2)=%1001
 Muster(4,3)=%1010
 Muster(5,0)=%1000
 Muster(5,1)=%1
 Muster(5,2)=%100
 Muster(5,3)=%10
 FOR T=0 TO 3
 Muster(6,T)=Muster(5,3-T)
 NEXT T
 FOR T=0 TO 3
 Muster(7,T)=0
 NEXT T
 FOR T=0 TO 15
 Durchschnitt(T)= VAL( MID$(Farbe$(T),2,1))+ VAL( MID$(Farbe$(T),3,1))+ VAL( RIGHT$(Farbe$(T),1))
 Durchschnitt(T)=Durchschnitt(T)/3
 NEXT T
 FOR T=0 TO 7
 X(T)=0
 NEXT T
 FOR T=0 TO 15
 IF Durchschnitt(T)=0 THEN Muster2(T,0,0)=(Muster(0,X(Durchschnitt(T))) AND %1100) SHR 2:Muster2(T,0,1)=Muster(0,X(Durchschnitt(T))) AND %11
 IF Durchschnitt(T)=1 THEN Muster2(T,0,0)=(Muster(1,X(Durchschnitt(T))) AND %1100) SHR 2:Muster2(T,0,1)=Muster(1,X(Durchschnitt(T))) AND %11
 IF Durchschnitt(T)=2 THEN Muster2(T,0,0)=(Muster(2,X(Durchschnitt(T))) AND %1100) SHR 2:Muster2(T,0,1)=Muster(2,X(Durchschnitt(T))) AND %11
 IF Durchschnitt(T)=3 THEN Muster2(T,0,0)=(Muster(3,X(Durchschnitt(T))) AND %1100) SHR 2:Muster2(T,0,1)=Muster(3,X(Durchschnitt(T))) AND %11
 IF Durchschnitt(T)=4 THEN Muster2(T,0,0)=(Muster(4,X(Durchschnitt(T))) AND %1100) SHR 2:Muster2(T,0,1)=Muster(4,X(Durchschnitt(T))) AND %11
 IF Durchschnitt(T)=5 THEN Muster2(T,0,0)=(Muster(5,X(Durchschnitt(T))) AND %1100) SHR 2:Muster2(T,0,1)=Muster(5,X(Durchschnitt(T))) AND %11
 IF Durchschnitt(T)=6 THEN Muster2(T,0,0)=(Muster(6,X(Durchschnitt(T))) AND %1100) SHR 2:Muster2(T,0,1)=Muster(6,X(Durchschnitt(T))) AND %11
 IF Durchschnitt(T)=7 THEN Muster2(T,0,0)=(Muster(7,X(Durchschnitt(T))) AND %1100) SHR 2:Muster2(T,0,1)=Muster(7,X(Durchschnitt(T))) AND %11
 X(Durchschnitt(T))=0
 FOR S=0 TO T-1
 IF Durchschnitt(T)=Durchschnitt(S) THEN X(Durchschnitt(T))=X(Durchschnitt(T))+1
 IF X(Durchschnitt(T))>=4 THEN X(Durchschnitt(T))=X(Durchschnitt(T))-(X(Durchschnitt(T))\4)*4
 NEXT S
 NEXT T
 FOR T=0 TO 15
 IF VAL( MID$(Farbe$(T),2,1))<3 THEN BIT (0,Muster2(T,1,0))=-1
 IF VAL( MID$(Farbe$(T),3,1))<3 THEN BIT (1,Muster2(T,1,0))=-1
 IF VAL( RIGHT$(Farbe$(T),1))<3 THEN BIT (0,Muster2(T,1,1))=-1
 Durchschnitt= VAL( MID$(Farbe$(T),2,1))+ VAL( MID$(Farbe$(T),3,1))+ VAL( RIGHT$(Farbe$(T),1))
 Durchschnitt=Durchschnitt\3
 IF Durchschnitt<2 THEN BIT (1,Muster2(T,1,1))=-1
 NEXT T
 GOTO Hauptmenue
-Routine
 Menue$(1)="UMWANDLUNGSROUTINE FESTLEGEN"
 Menue$(2)="----------------------------"
 Menue$(3)="Muster"
 Menue$(4)="Farbwert"
 Menue(X,Y,2,2,Stelle)
 Allgr=Stelle-1
 Routine=1
 GOTO Hauptmenue
-Wandeln
 Adresse=Speicher2
 REPEAT UNTIL INKEY$ =""
 FOR Y=0 TO 399 STEP 2
 FOR X=0 TO 639 STEP 32
 Poke1=0
 Poke2=0
 Peek1= WPEEK(Speicher1+34+X\4+Y*80)
 Peek2= WPEEK(Speicher1+36+X\4+Y*80)
 Peek3= WPEEK(Speicher1+38+X\4+Y*80)
 Peek4= WPEEK(Speicher1+40+X\4+Y*80)
 FOR X2=15 TO 0 STEP -1
 Cfarbe= ABS( BIT(X2,Peek4) SHL 3+ BIT(X2,Peek3) SHL 2+ BIT(X2,Peek2) SHL 1+ BIT(X2,Peek1))
 Poke1=Poke1 OR Muster2(Cfarbe,Allgr,0) SHL (2*X2)
 Poke2=Poke2 OR Muster2(Cfarbe,Allgr,1) SHL (2*X2)
 NEXT X2
 LPOKE Adresse,Poke1
 LPOKE Adresse+80,Poke2
 Adresse=Adresse+4
 NEXT X
 Adresse=Adresse+80
 NEXT Y
 Wandel=1
 BITBLT 0,0,640,400 TO Speicher3
 GOTO Hauptmenue
-Speichern
 Menue$(1)="BILD SPEICHERN"
 Wind_Text(Nr,-1,10,1,0)
 Change_Ext(Path$,"*.PI3")
 MOUSEON
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 Wind_Close(Nr)
 CLS
 IF Flag=0 OR Name$="" THEN GOTO Hauptmenue
 Change_Ext(Path$,"")
 CHDIR Path$
 BSAVE Name$,Speicher3+6,32000
 GOTO Hauptmenue
-Prgende
 Wind_Close(-1)
 END
 ' Prozedurteil
 '
 ' Fensterprozeduren V1.00   10.8.1992   by the C S C
 '
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
       GOTO Prgende
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
   FILL STYLE =1,1
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
     GOTO Prgende
   ENDIF
   Nr=Nr-1
   BITBLT Fenster(Nr,0) TO Fenster(Nr,1),Fenster(Nr,2),Fenster(Nr,3)+2*Xfak,Fenster(Nr,4)+2*Yfak
   Mfree(Fenster(Nr,0))
   Fenster(Nr,0)=-1
 RETURN
 '
 DEF PROC Menue(R X,R Y,Anz_Kopfzeilen,Anz_Menuepunkte,R Auswahl)
 ' Kurzform von Menue(...
   Menue(X,Y,Anz_Kopfzeilen,Anz_Menuepunkte,2^Anz_Menuepunkte-1,Auswahl)
 RETURN
 '
 DEF PROC Menue(R X,R Y,Anz_Kopfzeilen,Anz_Menuepunkte,Enabled,R Auswahl)
 ' Stellt ein Menue dar
   LOCAL Maxlength,Xp,Yp,Nr,T,Xm,Ym,Ym2,Knopf
   FOR T=1 TO Anz_Kopfzeilen+Anz_Menuepunkte
     IF LEN(Menue$(T))>Maxlength THEN Maxlength= LEN(Menue$(T))
   NEXT T
   Xp=(Maxlength+2*Xfak)*8\Xfak
   Yp=(Anz_Kopfzeilen+Anz_Menuepunkte+2)*8-Yfak*4
   Wind_Open(Nr,X,Y,Xp,Yp)
   TEXT HEIGHT =Textsize
   FOR T=1 TO Anz_Kopfzeilen
     TEXT X+8*Xfak,Y+8*Yfak*T+4,Menue$(T)
   NEXT T
   FOR T=1 TO Anz_Menuepunkte
     IF FN Enabled(T-1) THEN
       TEXT X+8*Xfak,Y+8*Yfak*(T+Anz_Kopfzeilen)+4,Menue$(T+Anz_Kopfzeilen)
     ELSE
       TEXT STYLE =2
       TEXT X+8*Xfak,Y+8*Yfak*(T+Anz_Kopfzeilen)+4,Menue$(T+Anz_Kopfzeilen)
       TEXT STYLE =0
     ENDIF
   NEXT T
   Xm= MOUSEX
   Ym2= INT(( MOUSEY -Y-2*Yfak^2)\(8*Yfak))-Anz_Kopfzeilen
   IF Ym2<0 OR Ym2>=Anz_Menuepunkte THEN Ym2=0
   IF FN Enabled(Ym2) THEN BITBLT 0,0,Maxlength*8+2,7*Yfak+1 TO X+8*Xfak-1,Y+8*Yfak*(Anz_Kopfzeilen+Ym2)+6+(Yfak\2)*2,Maxlength*8+2,7*Yfak+1,10
   Auswahl=0
   MOUSEON
   REPEAT ' Warten bis Mausknopf gedrckt
     Xm= MOUSEX
     Ym= INT(( MOUSEY -Y-2*Yfak^2)\(8*Yfak))-Anz_Kopfzeilen
     Knopf= MOUSEBUT
     IF Xm>X+8*Xfak-2 AND Xm<X+8*Xfak+Maxlength*8+6 AND Ym<>Ym2 AND Ym>=0 AND Ym<Anz_Menuepunkte THEN
       MOUSEOFF
       IF FN Enabled(Ym) THEN BITBLT 0,0,Maxlength*8+2,7*Yfak+1 TO X+8*Xfak-1,Y+8*Yfak*(Anz_Kopfzeilen+Ym)+6+(Yfak\2)*2,Maxlength*8+2,7*Yfak+1,10
       IF FN Enabled(Ym2) THEN BITBLT 0,0,Maxlength*8+2,7*Yfak+1 TO X+8*Xfak-1,Y+8*Yfak*(Anz_Kopfzeilen+Ym2)+6+(Yfak\2)*2,Maxlength*8+2,7*Yfak+1,10
       MOUSEON
       Ym2=Ym
     ENDIF
   UNTIL (Knopf>0 AND FN Enabled(Ym2)) OR Knopf=2
   REPEAT UNTIL MOUSEBUT =0
   MOUSEOFF
   IF Knopf=2 THEN
     Wind_Close(Nr)
     X= MOUSEX
     Y= MOUSEY
     Menue(X,Y,Anz_Kopfzeilen,Anz_Menuepunkte,Enabled,Auswahl)
     RETURN
     ' Rekursiver Aufruf der Prozedur bewikt eine neue Positionierung des Menuefensters
   ENDIF
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
   IF X=-1 THEN X=FN Centerx(Xp) ELSE X=X*Xfak
   IF Y=-1 THEN Y=FN Centery(Yp) ELSE Y=Y*Yfak
   Wind_Open(Nr,X,Y,Xp,Yp)
   Mitte=X*Xfak+Xp*Xfak\2
   TEXT HEIGHT =Textsize
   IF Zentriert=0 THEN
     FOR T=1 TO Zeilen
       TEXT X+8,Y+(8*T)*Yfak+2*Yfak,Menue$(T)
     NEXT T
   ELSE
     FOR T=1 TO Zeilen
       TEXT Mitte- LEN(Menue$(T))*4,Y+(8*T)*Yfak+2*Yfak,Menue$(T)
     NEXT T
   ENDIF
 RETURN
 '
 DEF FN Centerx(Xb)=((320-Xb)\2)*Xfak
 DEF FN Centery(Yb)=((200-Yb)\2)*Yfak
 DEF FN Enabled(Bitnr)=( BIT(Anz_Menuepunkte-Bitnr-1,Enabled))
 '
 'Fensterprozeduren Ende
 '
 DEF PROC Get_Path
 ' Ermittelt den Diskettenpfad
   LOCAL Drive,A
   GEMDOS (Drive,25)
   Path$= CHR$(0)*66
   A= LPEEK( VARPTR(Path$))+ LPEEK( SEGPTR +28)
   GEMDOS (,71, HIGH(A), LOW(A),Drive+1)
   Path$= LEFT$(Path$, INSTR(Path$, CHR$(0))-1)
   Path$= CHR$(Drive+65)+":"+Path$+"\"
 RETURN
 '
 DEF PROC Change_Ext(R Path$,Ext$)
 ' Žndert die Extension im Pfad
   Path$= LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\")+1)+Ext$
 RETURN
