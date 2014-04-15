 GOTO Anfang
 DEF PROC Zentriere(A)
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
-Raumtransform
 IF Zraum=-200 THEN
 Xraum=Xraum+320
 Yraum=Yraum+200
 RETURN
 ENDIF
 Xraum=Xraum*200/(Zraum+200)+320
 Yraum=Yraum*200/(Zraum+200)+200
 RETURN
-Drehenz
 ' Wn ist Drehwinkel
 S!= SQR(Xdrehen^2+Ydrehen^2)
 IF Xdrehen>0 THEN Wa!= ARCTAN(Ydrehen/Xdrehen)
 IF Xdrehen=0 THEN Wa!= SGN(Ydrehen)*90
 IF Xdrehen<0 THEN Wa!= ARCTAN(Ydrehen/Xdrehen)+180
 Wg!=Wa!+Wn
 Xdrehen= COS(Wg!)*S!
 Ydrehen= SIN(Wg!)*S!
 RETURN
-Drehenx
 S!= SQR(Zdrehen^2+Ydrehen^2)
 IF Zdrehen>0 THEN Wa!= ARCTAN(Ydrehen/Zdrehen)
 IF Zdrehen=0 THEN Wa!= SGN(Ydrehen)*90
 IF Zdrehen<0 THEN Wa!= ARCTAN(Ydrehen/Zdrehen)+180
 Wg!=Wa!+Wn
 Zdrehen= COS(Wg!)*S!
 Ydrehen= SIN(Wg!)*S!
 RETURN
-Dreheny
 S!= SQR(Xdrehen^2+Zdrehen^2)
 IF Zdrehen>0 THEN Wa!= ARCTAN(Xdrehen/Zdrehen)
 IF Zdrehen=0 THEN Wa!= SGN(Xdrehen)*90
 IF Zdrehen<0 THEN Wa!= ARCTAN(Xdrehen/Zdrehen)+180
 Wg!=Wa!+Wn
 Zdrehen= COS(Wg!)*S!
 Xdrehen= SIN(Wg!)*S!
 RETURN
 DEF PROC Resourcedefs
 Animation=0
 Desk=3
 Editor=4
 Animation=5
 Disk=6
 Info=9
 Objekt_Edi=18
 Objekt_Loeschen=19
 Animation_Edi=21
 Animation_Zeigen=22
 Animation_Loeschen=23
 Objekt_Laden=25
 Objekt_Speichern=26
 Animation_Laden=28
 Animation_Speichern=29
 Ende=31
 RETURN
 DEF PROC Objmenue_Aufbauen
 LOCAL T
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 CLS
 BITBLT Objmenue TO 0,0,80,400
 DRAW 80,18 TO 639,18
 PRINT "H"; TAB (11);Objansicht$(Page1);Objname$
 IF Teil=1 THEN
 DRAW 80,191 TO 639,191
 DRAW 80,209 TO 639,209
 PRINT "B"*11; TAB (11);Objansicht$(Page2);Objname$
 ENDIF
 LINE COLOR =1
 BOX 41,FN Ypos(Modus),38,38
 BOX 42,FN Ypos(Modus)+1,36,36
 IF Obenunten=1 THEN
 BOX 41,361,38,38
 BOX 42,362,36,36
 ENDIF
 IF Teil=0 THEN
 CLIP 81,19,559,387
 Vs_Clip(81,19,639,399)
 Counter=0
 FOR T=1 TO Anz_Punkte
 Obj_Zerlegen(0,T)
 IF Page1=0 THEN
 X=Xobj+360+Xpos
 Y=Yobj+209+Ypos
 ENDIF
 IF Page1=1 THEN
 X=Zobj+360+Zpos
 Y=Yobj+209+Ypos
 ENDIF
 IF Page1=2 THEN
 X=Xobj+360+Xpos
 Y=Zobj+209+Zpos
 ENDIF
 Zeichnen
 NEXT T
 ENDIF
 IF Teil=1 THEN
 Counter=0
 FOR T=1 TO Anz_Punkte
 Obj_Zerlegen(0,T)
 CLIP 81,19 TO 639,191
 Vs_Clip(81,19,639,191)
 IF Page1=0 THEN
 X=Xobj+360+Xpos
 Y=Yobj+104+Ypos
 ENDIF
 IF Page1=1 THEN
 X=Zobj+360+Zpos
 Y=Yobj+104+Ypos
 ENDIF
 IF Page1=2 THEN
 X=Xobj+360+Xpos
 Y=Zobj+104+Zpos
 ENDIF
 Zeichnen
 NEXT T
 Counter=0
 FOR T=1 TO Anz_Punkte
 Obj_Zerlegen(0,T)
 CLIP 81,210,558,189
 Vs_Clip(81,210,639,399)
 IF Page2=0 THEN
 X=Xobj+360+Xpos
 Y=Yobj+304+Ypos
 ENDIF
 IF Page2=1 THEN
 X=Zobj+360+Zpos
 Y=Yobj+304+Ypos
 ENDIF
 IF Page2=2 THEN
 X=Xobj+360+Xpos
 Y=Zobj+304+Zpos
 ENDIF
 Zeichnen
 NEXT T
 ENDIF
 CLIP
 Vs_Clip
 BITBLT 0,0,640,400 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 0,0,640,400
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 RETURN
 DEF FN Ypos(Modus)
 IF Modus=1 THEN RETURN 161
 IF Modus=2 THEN RETURN 201
 IF Modus=3 THEN RETURN 241
 IF Modus=4 THEN RETURN 281
 IF Modus=5 THEN RETURN 321
 DEF PROC Zeichnen
 DRAW X,Y
 IF Art=1 THEN
 Ptsin%(0,Counter)=X
 Ptsin%(1,Counter)=Y
 Counter=Counter+1
 ENDIF
 IF Art=2 THEN
 Ptsin%(0,Counter)=X
 Ptsin%(1,Counter)=Y
 V_Pline(Counter+1)
 Counter=0
 ENDIF
 IF Art=3 THEN
 Ptsin%(0,Counter)=X
 Ptsin%(1,Counter)=Y
 Vsl_Type(2)
 V_Pline(Counter+1)
 Vsl_Type(1)
 Counter=0
 ENDIF
 RETURN
 DEF PROC Obj_Absuchen
 LOCAL T
 IF Anz_Punkte<1 THEN Gefunden=0
 FOR T=1 TO Anz_Punkte
 Obj_Zerlegen(0,T)
 IF Xobj=X3 AND Yobj=Y3 AND Zobj=Z3 THEN
 Gefunden=-1
 Punktnr=T
 EXIT
 ELSE
 Gefunden=0
 ENDIF
 NEXT T
 RETURN
 DEF PROC Obj_Zerlegen(Nummer,Objnr)
 Objadresse=Anispeicher+Nummer*600+Objnr*20
 Xobj= WPEEK(Objadresse)
 Yobj= WPEEK(Objadresse+2)
 Zobj= WPEEK(Objadresse+4)
 Art= WPEEK(Objadresse+6)
 IF Nummer>0 AND Objnr=1 THEN
 Xpos= WPEEK(Objadresse+8)
 Ypos= WPEEK(Objadresse+10)
 Zpos= WPEEK(Objadresse+12)
 Xwinkel= WPEEK(Objadresse+14)
 Ywinkel= WPEEK(Objadresse+16)
 Zwinkel= WPEEK(Objadresse+18)
 ENDIF
 RETURN
 DEF PROC Obj_Anzeigen(Zeiger)
 LOCAL T
 Counter=0
 FOR T=1 TO Anz_Punkte
 Obj_Zerlegen(Zeiger,T)
 Xraum=Xobj
 Yraum=Yobj
 Zraum=Zobj
 GOSUB Raumtransform
 IF Art=0 THEN DRAW Xraum,Yraum
 IF Art=1 THEN
 Ptsin%(0,Counter)=Xraum
 Ptsin%(1,Counter)=Yraum
 Counter=Counter+1
 ENDIF
 IF Art=2 THEN
 Ptsin%(0,Counter)=Xraum
 Ptsin%(1,Counter)=Yraum
 V_Pline(Counter+1)
 Counter=0
 ENDIF
 IF Art=3 THEN
 Ptsin%(0,Counter)=Xraum
 Ptsin%(1,Counter)=Yraum
 V_Fillarea(Counter+1)
 Counter=0
 ENDIF
 NEXT T
 CLIP
 Vs_Clip
 RETURN
-Obenuntencheck
 IF Xstore=0 AND Ystore=0 AND Zstore=0 THEN
 IF Y2<191 THEN
 Ansicht=Page1
 ELSE
 Ansicht=Page2
 ENDIF
 IF Ansicht=0 THEN
 Xstore=X3
 Ystore=Y3
 ENDIF
 IF Ansicht=1 THEN
 Ystore=Y3
 Zstore=Z3
 ENDIF
 IF Ansicht=2 THEN
 Xstore=X3
 Ystore=Y3
 ENDIF
 X3=0
 Y3=0
 Z3=0
 RETURN
 ELSE
 IF Y2<191 THEN
 Ansicht=Page1
 ELSE
 Ansicht=Page2
 ENDIF
 IF Ansicht=0 THEN
 IF Xstore=X3 THEN
 Ystore=Y3
 GOTO Obenunten2
 ENDIF
 IF Ystore=Y3 THEN
 Xstore=X3
 GOTO Obenunten2
 ENDIF
 PRINT CHR$(7);
 GOTO Mauswarten
 ENDIF
 IF Ansicht=1 THEN
 IF Ystore=Y3 THEN
 Zstore=Z3
 GOTO Obenunten2
 ENDIF
 IF Zstore=Z3 THEN
 Ystore=Y3
 GOTO Obenunten2
 ENDIF
 PRINT CHR$(7);
 GOTO Mauswarten
 ENDIF
 IF Ansicht=1 THEN
 IF Xstore=X3 THEN
 Zstore=Z3
 GOTO Obenunten2
 ENDIF
 IF Zstore=Z3 THEN
 Xstore=X3
 GOTO Obenunten2
 ENDIF
 PRINT CHR$(7);
 GOTO Mauswarten
 ENDIF
-Obenunten2
 IF Xstore<>0 AND Ystore<>0 AND Zstore<>0 THEN
 X3=Xstore
 Y3=Ystore
 Z3=Zstore
 Xstore=0
 Ystore=0
 Zstore=0
 ELSE
 PRINT CHR$(7);
 GOTO Mauswarten
 ENDIF
 ENDIF
 RETURN
 DEF PROC Animmenue_Aufbauen
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 CLS
 BITBLT Animmenue TO 0,0,80,400
 IF Reset=1 THEN BOX 0,41,40,38: BOX 0,42,38,36
 DRAW 79,50 TO 639,50
 Daten_Anzeigen
 CLIP 79,51 TO 639,399
 Vs_Clip(79,51,639,399)
 Obj_Anzeigen(Pointer)
 CLIP
 Vs_Clip
 BITBLT 0,0,640,400 TO Pic3
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 0,0,640,400
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 RETURN
 DEF PROC Daten_Anzeigen
 PRINT "H"; TAB (11);"K";Objname$;
 PRINT TAB (21);"Pos X    : "; SPC(4- LEN( STR$(Posx))); STR$(Posx);" ";
 IF Movx>0 THEN PRINT "+";
 IF Movx<0 THEN PRINT "-";
 IF Movx=0 THEN PRINT " ";
 PRINT RIGHT$( STR$(Movx), LEN( STR$(Movx))-1);
 PRINT TAB (40);"Pos Y    : "; SPC(4- LEN( STR$(Posy))); STR$(Posy);" ";
 IF Movy>0 THEN PRINT "+";
 IF Movy<0 THEN PRINT "-";
 IF Movy=0 THEN PRINT " ";
 PRINT RIGHT$( STR$(Movy), LEN( STR$(Movy))-1);
 PRINT TAB (59);"Pos Z    : "; SPC(4- LEN( STR$(Posz))); STR$(Posz);" ";
 IF Movz>0 THEN PRINT "+";
 IF Movz<0 THEN PRINT "-";
 IF Movz=0 THEN PRINT " ";
 PRINT RIGHT$( STR$(Movz), LEN( STR$(Movz))-1)
 PRINT TAB (21);"KWinkel X : "; SPC(4- LEN( STR$(Winkelx))); STR$(Winkelx);" ";
 IF Drehx>0 THEN PRINT "+";
 IF Drehx<0 THEN PRINT "-";
 IF Drehx=0 THEN PRINT " ";
 PRINT RIGHT$( STR$(Drehx), LEN( STR$(Drehx))-1);
 PRINT TAB (40);"Winkel Y : "; SPC(4- LEN( STR$(Winkely))); STR$(Winkely);" ";
 IF Drehy>0 THEN PRINT "+";
 IF Drehy<0 THEN PRINT "-";
 IF Drehy=0 THEN PRINT " ";
 PRINT RIGHT$( STR$(Drehy), LEN( STR$(Drehy))-1);
 PRINT TAB (59);"Winkel Z : "; SPC(4- LEN( STR$(Winkelz))); STR$(Winkelz);" ";
 IF Drehz>0 THEN PRINT "+";
 IF Drehz<0 THEN PRINT "-";
 IF Drehz=0 THEN PRINT " ";
 PRINT RIGHT$( STR$(Drehz), LEN( STR$(Drehz))-1)
 PRINT TAB (22);"KAnzahl Schritte : ";
 PRINT SPC(4- LEN( RIGHT$( STR$(Anz_Anim), LEN( STR$(Anz_Anim))-1)));
 PRINT RIGHT$( STR$(Anz_Anim), LEN( STR$(Anz_Anim))-1);
 PRINT TAB (45);"Counter : ";
 PRINT SPC(4- LEN( RIGHT$( STR$(Pointer), LEN( STR$(Pointer))-1)));
 PRINT RIGHT$( STR$(Pointer), LEN( STR$(Pointer))-1);
 IF Reset=1 THEN BOX 0,41,40,38: BOX 0,42,38,36
 RETURN
-Anfang
 CLEAR 32256*8+256
 CHDIR "A:\CSCANIM\DATAS"
 COMPILER "Multitasking_Between_Statements"
 COMPILER "Trace_On"
 IPL 3+(1 SHL 31)
 Appl_Init
 CLIP
 MOUSEOFF
 DIM Mesag(7),Ptsin%(1,30),A$(10),Objansicht$(10)
 Objansicht$(0)="Frontansicht    "
 Objansicht$(1)="Seitenansicht   "
 Objansicht$(2)="Draufsicht      "
 DEG
 CLS
 PRINT "f";
 V_Opnvwk
 XBIOS (Pic1,2)
 Anispeicher= MEMORY(60256)
 Pic2= MEMORY(32256)+255 AND $FFFF00
 Pic3= MEMORY(32256)
 Hipic1= HIGH(Pic1)
 Lopic1= LOW(Pic1)
 Hipic2= HIGH(Pic2)
 Lopic2= LOW(Pic2)
 Objmenue= MEMORY(4262)
 Animmenue= MEMORY(4262)
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 BLOAD "menue.dat"
 BITBLT 0,0,80,400 TO Objmenue
 BITBLT 81,0,80,400 TO Animmenue
 CLS
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 Rsrc_Load("ANIM.RSC",Test)
 Rsrc_Gaddr(0,Menue,Menue_Adr)
 IF Test<>1 THEN
 MOUSEON
 FORM_ALERT (1,"[1][ |Fehler beim|laden der|Resource-Datei !][ENDE]")
 MOUSEOFF
 END
 ENDIF
 Resourcedefs
-Hauptmenue
 CLS
 Menu_Bar(Menue_Adr)
 IF Objname$="" OR Anz_Punkte=0 THEN
 Menu_Ienable(Animation_Edi,0)
 Menu_Ienable(Animation_Zeigen,0)
 Menu_Ienable(Objekt_Speichern,0)
 Menu_Ienable(Animation_Speichern,0)
 ELSE
 Menu_Ienable(Animation_Edi,1)
 Menu_Ienable(Animation_Zeigen,1)
 Menu_Ienable(Objekt_Speichern,1)
 Menu_Ienable(Animation_Speichern,1)
 ENDIF
 IF Anz_Anim<2 THEN
 Menu_Ienable(Animation_Zeigen,0)
 Menu_Ienable(Animation_Speichern,0)
 ELSE
 Menu_Ienable(Animation_Zeigen,1)
 Menu_Ienable(Animation_Speichern,1)
 ENDIF
 IF Anz_Punkte>0 THEN
 CLIP 0,19 TO 639,399
 Vs_Clip(0,19,639,399)
 Obj_Anzeigen(Pointer)
 ENDIF
 MOUSEON
 Evnt_Mesag(Mesag$)
 FOR T=0 TO 7
 Mesag(T)= CVI( MID$(Mesag$,T*2+1,2))
 NEXT T
 MOUSEOFF
 Menu_Tnormal(Desk,1)
 Menu_Tnormal(Editor,1)
 Menu_Tnormal(Animation,1)
 Menu_Tnormal(Disk,1)
 Menu_Bar
 IF Mesag(3)=Desk THEN GOTO Anleitung
 IF Mesag(3)=Editor THEN GOTO Editorcheck
 IF Mesag(3)=Animation THEN GOTO Animationcheck
 IF Mesag(3)=Disk THEN GOTO Diskcheck
-Editorcheck
 IF Mesag(4)=Objekt_Edi THEN GOTO Objekteditor
 IF Mesag(4)=Objekt_Loeschen THEN GOSUB Objektloeschen
 GOTO Hauptmenue
-Animationcheck
 IF Mesag(4)=Animation_Edi THEN GOTO Animationeditor
 IF Mesag(4)=Animation_Zeigen THEN GOSUB Animationzeigen
 IF Mesag(4)=Animation_Loeschen THEN GOSUB Animationloeschen
 GOTO Hauptmenue
-Diskcheck
 IF Mesag(4)=Objekt_Laden THEN GOSUB Objektladen
 IF Mesag(4)=Objekt_Speichern THEN GOSUB Objektspeichern
 IF Mesag(4)=Animation_Laden THEN GOSUB Animationladen
 IF Mesag(4)=Animation_Speichern THEN GOSUB Animationspeichern
 IF Mesag(4)=Ende THEN GOTO Ende
 GOTO Hauptmenue
-Ende
 Appl_Exit
 END
-Objekteditor
 CLS
 IF Objname$="" THEN
 A$(1)="Neues Objekt"
 Zentriere(1)
 PRINT "e";"B"*3
 INPUT "Objektname ? ";Objname$ USING "0a%",Returnvar,8
 PRINT "f";
 Modus=1
 ' Punkte setzen
 Teil=0
 ' Bildschirm nicht unterteilt
 Page1=0
 ' Teil 1 : Frontansicht
 Page2=1
 ' Teil 2 : Seitenansicht
 Aktiv=0
 ' Oberer Teil aktiv
 Obenunten=0
 ' Punkte setzen durch Anklicken im oberen und unteren Bildschirm aus
 Xpos=0
 Ypos=0
 Zpos=0
 Anz_Punkte=0
 ENDIF
 IF Modus=0 THEN
 Modus=1
 Teil=0
 Page1=0
 Page2=1
 Aktiv=0
 Obenunten=0
 Xpos=0
 Ypos=0
 Zpos=0
 ENDIF
 Objmenue_Aufbauen
-Mauswarten
 X= MOUSEX
 Y= MOUSEY
 IF X<80 OR Y<18 OR Teil=1 AND Y>191 AND Y<209 THEN
 Graf_Mouse(3)
 ELSE
 Graf_Mouse(0)
 ENDIF
 MOUSEON
 REPEAT
 X2= MOUSEX
 Y2= MOUSEY
 Mausknopf= MOUSEBUT
 IF X>79 AND X2<80 OR Y>18 AND Y2<19 OR Teil=1 AND Y2>190 AND Y2<210 AND (Y<191 OR Y>209) THEN
 Graf_Mouse(3): PRINT "H"; TAB (50);"K"
 IF Teil=1 THEN PRINT "B"*11; TAB (50);"K"
 ENDIF
 IF X<80 AND X2>79 AND Y2>18 OR X>80 AND X2>80 AND Y<19 AND Y2>18 OR Teil=1 AND Y>190 AND Y<210 AND (Y2<191 OR Y2>209) AND X2>80 THEN Graf_Mouse(0)
 IF Teil=0 AND X2>80 AND Y2>18 AND (X<>X2 OR Y<>Y2) THEN
 IF Page1=0 THEN
 X3=X2-360-Xpos
 Y3=Y2-209-Ypos
 Z3=Zpos
 ENDIF
 IF Page1=1 THEN
 X3=Xpos
 Y3=Y2-209-Ypos
 Z3=X2-360-Zpos
 ENDIF
 IF Page1=2 THEN
 X3=X2-360-Xpos
 Y3=Ypos
 Z3=Y2-209-Zpos
 ENDIF
 PRINT "H"; TAB (50);"KX: "; STR$(X3); TAB (60);"Y: "; STR$(Y3); TAB (70);"Z: "; STR$(Z3)
 ENDIF
 IF Teil=1 AND X2>80 AND Y2>18 AND Y2<191 AND (X<>X2 OR Y<>Y2) THEN
 IF Page1=0 THEN
 X3=X2-360-Xpos
 Y3=Y2-104-Ypos
 Z3=Zpos
 ENDIF
 IF Page1=1 THEN
 X3=Xpos
 Y3=Y2-104-Ypos
 Z3=X2-360-Zpos
 ENDIF
 IF Page1=2 THEN
 X3=X2-360-Xpos
 Y3=Ypos
 Z3=Y2-104-Zpos
 ENDIF
 PRINT "H"; TAB (50);"KX: "; STR$(X3); TAB (60);"Y: "; STR$(Y3); TAB (70);"Z: "; STR$(Z3)
 ENDIF
 IF Teil=1 AND X2>80 AND Y2>209 AND (X<>X2 OR Y<>Y2) THEN
 IF Page2=0 THEN
 X3=X2-360-Xpos
 Y3=Y2-304-Ypos
 Z3=Zpos
 ENDIF
 IF Page2=1 THEN
 X3=Xpos
 Y3=Y2-304-Ypos
 Z3=X2-360-Zpos
 ENDIF
 IF Page2=2 THEN
 X3=X2-360-Xpos
 Y3=Ypos
 Z3=Y2-304-Zpos
 ENDIF
 PRINT "H"; TAB (50);"K"
 PRINT "B"*11; TAB (50);"KX: "; STR$(X3); TAB (60);"Y: "; STR$(Y3); TAB (70);"Z: "; STR$(Z3)
 ENDIF
 X=X2
 Y=Y2
 UNTIL Mausknopf>0
 REPEAT UNTIL MOUSEBUT =0
 MOUSEOFF
 IF X2<81 THEN
 Xfeld= INT(X2/40)
 Yfeld= INT(Y2/40)
 IF Xfeld=0 THEN
 IF Yfeld=0 THEN
 Graf_Mouse(0)
 GOTO Hauptmenue
 ENDIF
 IF Yfeld=1 THEN
 IF Mausknopf=1 THEN
 Ypos=Ypos-15
 ELSE
 Ypos=Ypos-1
 ENDIF
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=2 THEN
 IF Mausknopf=1 THEN
 Ypos=Ypos+15
 ELSE
 Ypos=Ypos+1
 ENDIF
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=3 THEN
 IF Mausknopf=1 THEN
 Xpos=Xpos-15
 ELSE
 Xpos=Xpos-1
 ENDIF
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=4 THEN
 IF Mausknopf=1 THEN
 Xpos=Xpos+15
 ELSE
 Xpos=Xpos+1
 ENDIF
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=5 THEN
 IF Mausknopf=1 THEN
 Zpos=Zpos+15
 ELSE
 Zpos=Zpos+1
 ENDIF
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=6 THEN
 IF Mausknopf=1 THEN
 Zpos=Zpos-15
 ELSE
 Zpos=Zpos-1
 ENDIF
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=7 THEN
 Xpos=0
 Ypos=0
 Zpos=0
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=8 THEN
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 CLIP 0,0,640,400
 Vs_Clip(0,0,639,399)
 CLS
 Obj_Anzeigen(0)
 XBIOS (,5,Hipic2,Lopic2,Hipic2,Lopic2,-1)
 REPEAT UNTIL INKEY$ >"" OR MOUSEBUT >0
 REPEAT UNTIL MOUSEBUT =0 AND INKEY$ =""
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Mauswarten
 ENDIF
 ENDIF
 IF Xfeld=1 THEN
 IF Yfeld=0 THEN
 GOSUB Objektspeichern
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=1 THEN
 GOSUB Objektladen
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=2 THEN
 IF Teil=1 THEN
 Teil=0
 Obenunten=0
 Objmenue_Aufbauen
 ENDIF
 GOTO Mauswarten
 ENDIF
 IF Yfeld=3 THEN
 IF Teil=0 THEN
 Teil=1
 Objmenue_Aufbauen
 ENDIF
 GOTO Mauswarten
 ENDIF
 IF Yfeld>3 AND Yfeld<9 THEN
 Modus=Yfeld-3
 IF Modus=2 OR Modus=3 OR Modus=5 THEN Lincheck=0
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 ENDIF
 IF Yfeld=9 THEN
 IF Obenunten=0 THEN
 Xstore=0
 Ystore=0
 Zstore=0
 Teil=1
 Obenunten=1
 Objmenue_Aufbauen
 GOTO Mauswarten
 ELSE
 Obenunten=0
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 ENDIF
 ENDIF
 IF Y2<19 AND X2>80 THEN
 Page1=Page1+1+(Page1=2)*3
 IF Teil=1 AND Page1=Page2 THEN Page1=Page1+1+(Page1=2)*3
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Teil=1 AND Y2>190 AND Y2<210 AND X2>80 THEN
 Page2=Page2+1+(Page2=2)*3
 IF Page2=Page1 THEN Page2=Page2+1+(Page2=2)*3
 Objmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF X2>80 THEN
 IF Modus=1 THEN
 IF Xpos>999 OR Xpos<-999 OR Ypos>999 OR Ypos<-999 OR Zpos>999 OR Zpos<-999 THEN PRINT CHR$(7);: GOTO Mauswarten
 IF Anz_Punkte=30 THEN PRINT CHR$(7);: GOTO Mauswarten
 IF Obenunten=1 THEN GOSUB Obenuntencheck
 IF X3<>0 OR Y3<>0 OR Z3<>0 THEN
 Obj_Absuchen
 IF Gefunden THEN PRINT CHR$(7);: GOTO Mauswarten
 Anz_Punkte=Anz_Punkte+1
 Objadr=Anispeicher+Anz_Punkte*20
 WPOKE Objadr,X3
 WPOKE Objadr+2,Y3
 WPOKE Objadr+4,Z3
 WPOKE Objadr+6,0
 Objmenue_Aufbauen
 ENDIF
 GOTO Mauswarten
 ENDIF
 IF Modus=2 THEN
 IF Mausknopf=2 THEN
 Lincheck=0
 GOTO Mauswarten
 ENDIF
 IF Anz_Punkte=30 THEN PRINT CHR$(7);: GOTO Mauswarten
 IF Obenunten=1 THEN GOSUB Obenuntencheck
 IF X3<>0 OR Y3<>0 OR Z3<>0 THEN
 Obj_Absuchen
 IF Gefunden THEN PRINT CHR$(7);: GOTO Mauswarten
 Anz_Punkte=Anz_Punkte+1
 Objadr=Anispeicher+Anz_Punkte*20
 IF Lincheck=0 THEN
 Lincheck=1
 ELSE
 WPOKE Objadr-14,1
 ENDIF
 WPOKE Objadr,X3
 WPOKE Objadr+2,Y3
 WPOKE Objadr+4,Z3
 WPOKE Objadr+6,2
 Objmenue_Aufbauen
 ENDIF
 GOTO Mauswarten
 ENDIF
 IF Modus=3 THEN
 IF Mausknopf=2 THEN
 Lincheck=0
 GOTO Mauswarten
 ENDIF
 IF Anz_Punkte=30 THEN PRINT CHR$(7);: GOTO Mauswarten
 IF Obenunten=1 THEN GOSUB Obenuntencheck
 IF X3<>0 OR Y3<>0 OR Z3<>0 THEN
 Obj_Absuchen
 IF Gefunden THEN PRINT CHR$(7);: GOTO Mauswarten
 Anz_Punkte=Anz_Punkte+1
 Objadr=Anispeicher+Anz_Punkte*20
 IF Lincheck=0 THEN
 Lincheck=1
 ELSE
 WPOKE Objadr-14,1
 ENDIF
 WPOKE Objadr,X3
 WPOKE Objadr+2,Y3
 WPOKE Objadr+4,Z3
 WPOKE Objadr+6,3
 Objmenue_Aufbauen
 ENDIF
 GOTO Mauswarten
 ENDIF
 IF Modus=4 THEN
 IF Obenunten=1 THEN GOSUB Obenuntencheck
 IF X3<>0 OR Y3<>0 OR Z3<>0 THEN
 Obj_Absuchen
 IF NOT (Gefunden) THEN PRINT CHR$(7);: GOTO Mauswarten
 Obj_Zerlegen(0,Punktnr)
 Objadr=Anispeicher+Punktnr*20-20
 IF WPEEK(Objadr+6)=1 THEN WPOKE Objadr+6,Art
 Objadr=Objadr+20
 FOR T=Punktnr+1 TO Anz_Punkte
 Objadr=Objadr+20
 WPOKE Objadr-20, WPEEK(Objadr)
 WPOKE Objadr-18, WPEEK(Objadr+2)
 WPOKE Objadr-16, WPEEK(Objadr+4)
 WPOKE Objadr-14, WPEEK(Objadr+6)
 NEXT T
 WPOKE Objadr,0
 WPOKE Objadr+2,0
 WPOKE Objadr+4,0
 WPOKE Objadr+6,0
 Anz_Punkte=Anz_Punkte-1
 Objmenue_Aufbauen
 ENDIF
 GOTO Mauswarten
 ENDIF
 IF Modus=5 THEN
 IF Mausknopf=2 THEN
 Lincheck=0
 GOTO Mauswarten
 ENDIF
 IF Obenunten=1 THEN GOSUB Obenuntencheck
 IF X3<>0 OR Y3<>0 OR Z3<>0 THEN
 IF Lincheck=0 THEN
 Obj_Absuchen
 IF NOT (Gefunden) THEN PRINT CHR$(7);: GOTO Mauswarten
 Lincheck=Punktnr
 GOTO Mauswarten
 ENDIF
 Obj_Absuchen
 IF Gefunden THEN PRINT CHR$(7);: GOTO Mauswarten
 Obj_Zerlegen(0,Lincheck)
 Objadr=Anispeicher+Lincheck*20
 WPOKE Objadr,X3
 WPOKE Objadr+2,Y3
 WPOKE Objadr+4,Z3
 WPOKE Objadr+6,Art
 Objmenue_Aufbauen
 ENDIF
 GOTO Mauswarten
 ENDIF
 ENDIF
-Objektloeschen
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 CLS
 CLIP 0,0,640,400
 Vs_Clip(0,0,639,399)
 Obj_Anzeigen(0)
 BITBLT 0,0,640,400 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 0,0,640,400
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 MOUSEON
 FORM_ALERT (2,"[2][ | Objekt l”schen ? ][ JA |ABBRUCH]",Button)
 MOUSEOFF
 IF Button=2 THEN RETURN
 Objadr=Anispeicher
 FOR T=1 TO Anz_Punkte
 Objadr=Objadr+20
 WPOKE Objadr,0
 WPOKE Objadr+2,0
 WPOKE Objadr+4,0
 WPOKE Objadr+6,0
 NEXT T
 Anz_Punkte=0
 Objname$=""
 RETURN
-Objektspeichern
 CLS
 Path$="A:\CSCANIM\ANIMS\*.OBJ"
 A$(1)="Objekt speichern"
 Zentriere(1)
 IF Objname$>"" THEN Objname$=Objname$+".OBJ"
 MOUSEON
 FILESELECT (Path$,Objname$,Flag)
 MOUSEOFF
 IF Flag=0 THEN
 IF Objname$>"" THEN Objname$= LEFT$(Objname$, LEN(Objname$)-4)
 ENDIF
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))
 POKE Anispeicher,Anz_Punkte
 BSAVE Objname$,Anispeicher,600
 Objname$= LEFT$(Objname$, LEN(Objname$)-4)
 RETURN
-Objektladen
 CLS
 Path$="A:\CSCANIM\ANIMS\*.OBJ"
 A$(1)="Objekt laden"
 Zentriere(1)
 IF Objname$>"" THEN Objname$=Objname$+".OBJ"
 MOUSEON
 FILESELECT (Path$,Objname$,Flag)
 MOUSEOFF
 IF Flag=0 THEN
 IF Objname$>"" THEN Objname$= LEFT$(Objname$, LEN(Objname$)-4)
 RETURN
 ENDIF
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))
 BLOAD Objname$,Anispeicher
 Anz_Punkte= PEEK(Anispeicher)
 Objname$= LEFT$(Objname$, LEN(Objname$)-4)
 RETURN
-Animationeditor
 CLS
 IF Anz_Anim=0 OR Animname$<>Objname$ AND Animname$<>"" THEN
 Animname$=Objname$
 Posx=0
 Posy=0
 Posz=0
 ' Position des Objekts zum Achsenkreuz
 Movx=0
 Movy=0
 Movz=0
 ' Bewegung entlang des Achsenkreuzes
 Winkelx=0
 Winkely=0
 Winkelz=0
 ' Winkel des Objektes
 Drehx=0
 Drehy=0
 Drehz=0
 ' Drehwinkel
 Speichern=0
 ' Animation nicht speichern
 Anz_Anim=1
 ' Eine Animation gespeichert
 Pointer=1
 ' Zeiger auf Animationssequenz
 Objadr=Anispeicher+600
 FOR T=1 TO Anz_Punkte
 WPOKE Objadr+T*20, WPEEK(Anispeicher+T*20)
 WPOKE Objadr+T*20+2, WPEEK(Anispeicher+T*20+2)
 WPOKE Objadr+T*20+4, WPEEK(Anispeicher+T*20+4)
 WPOKE Objadr+T*20+6, WPEEK(Anispeicher+T*20+6)
 NEXT T
 ' Objekt als erster Animationsschritt
 ENDIF
 Animmenue_Aufbauen
 X= MOUSEX
 Y= MOUSEY
 IF X<79 THEN
 Graf_Mouse(3)
 ELSE
 Graf_Mouse(0)
 ENDIF
-Animmauswarten
 MOUSEON
 REPEAT
 X2= MOUSEX
 Y2= MOUSEY
 Mausknopf= MOUSEBUT
 IF X2<79 AND X>78 THEN Graf_Mouse(3)
 IF X2>78 AND X<79 THEN Graf_Mouse(0)
 X=X2
 Y=Y2
 UNTIL Mausknopf>0
 MOUSEOFF
 IF X>78 THEN PRINT CHR$(7);: REPEAT UNTIL MOUSEBUT =0: GOTO Animmauswarten
 Xfeld= INT(X2/40)
 Yfeld= INT(Y2/40)
 IF Xfeld=0 THEN
 IF Yfeld=0 THEN
 REPEAT UNTIL MOUSEBUT =0
 Graf_Mouse(0)
 GOTO Hauptmenue
 ENDIF
 IF Yfeld=1 THEN
 REPEAT UNTIL MOUSEBUT =0
 IF Reset=0 THEN GOTO Animmauswarten
 Reset=0
 Obj_Zerlegen(Pointer,1)
 Posx=Xpos
 Posy=Ypos
 Posz=Zpos
 Winkelx=Xwinkel
 Winkely=Ywinkel
 Winkelz=Zwinkel
 Animmenue_Aufbauen
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=2 THEN
 IF Mausknopf=1 THEN
 Movx=Movx+1
 ELSE
 Movx=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=3 THEN
 IF Mausknopf=1 THEN
 Movy=Movy+1
 ELSE
 Movy=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=4 THEN
 IF Mausknopf=1 THEN
 Movz=Movz+1
 ELSE
 Movz=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=5 THEN
 IF Mausknopf=1 THEN
 Drehz=Drehz+1
 ELSE
 Drehz=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=6 THEN
 IF Mausknopf=1 THEN
 Drehx=Drehx+1
 ELSE
 Drehx=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=7 THEN
 IF Mausknopf=1 THEN
 Drehy=Drehy+1
 ELSE
 Drehy=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=8 THEN
 IF Reset=0 THEN Reset=1
 Posx=Posx+Movx
 Posy=Posy+Movy
 Posz=Posz+Movz
 Winkelx=Winkelx+Drehx
 IF Winkelx<0 THEN Winkelx=360+Winkelx
 IF Winkelx>360 THEN Winkelx=Winkelx-360
 Winkely=Winkely+Drehy
 IF Winkely<0 THEN Winkely=360+Winkely
 IF Winkely>360 THEN Winkely=Winkely-360
 Winkelz=Winkelz+Drehz
 IF Winkelz<0 THEN Winkelz=360+Winkelz
 IF Winkelz>360 THEN Winkelz=Winkelz-360
 Objadr=Anispeicher+59400
 FOR T=1 TO Anz_Punkte
 Obj_Zerlegen(0,T)
 Objadr=Objadr+20
 Xdrehen=Xobj
 Ydrehen=Yobj
 Zdrehen=Zobj
 Wn=Winkelx
 IF Wn>0 THEN GOSUB Drehenx
 Wn=Winkely
 IF Wn>0 THEN GOSUB Dreheny
 Wn=Winkelz
 IF Wn>0 THEN GOSUB Drehenz
 Xobj=Xdrehen
 Yobj=Ydrehen
 Zobj=Zdrehen
 Xobj=Xobj+Posx
 Yobj=Yobj+Posy
 Zobj=Zobj+Posz
 WPOKE Objadr,Xobj
 WPOKE Objadr+2,Yobj
 WPOKE Objadr+4,Zobj
 WPOKE Objadr+6,Art
 IF T=1 THEN
 WPOKE Objadr+8,Posx
 WPOKE Objadr+10,Posy
 WPOKE Objadr+12,Posz
 WPOKE Objadr+14,Winkelx
 WPOKE Objadr+16,Winkely
 WPOKE Objadr+18,Winkelz
 ENDIF
 NEXT T
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 CLIP 79,51,639,399
 Vs_Clip(79,51,639,399)
 BITBLT 79,51,561,349 TO 79,51,562,349,0
 Obj_Anzeigen(99)
 CLIP
 Vs_Clip
 Daten_Anzeigen
 BITBLT 0,0,640,400 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 0,0,640,400
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 IF Mausknopf=2 THEN REPEAT UNTIL MOUSEBUT =0
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=9 THEN
 IF Mausknopf=1 THEN
 Pointer=Pointer-3
 ELSE
 Pointer=Pointer-1
 ENDIF
 IF Pointer<1 THEN Pointer=1
 Obj_Zerlegen(Pointer,1)
 Posx=Xpos
 Posy=Ypos
 Posz=Zpos
 Winkelx=Xwinkel
 Winkely=Ywinkel
 Winkelz=Zwinkel
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 CLIP 79,51,639,399
 Vs_Clip(79,51,639,399)
 BITBLT 79,51,561,349 TO 79,51,562,349,0
 Obj_Anzeigen(Pointer)
 CLIP
 Vs_Clip
 Daten_Anzeigen
 BITBLT 0,0,640,400 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 0,0,640,400
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 ENDIF
 IF Xfeld=1 THEN
 IF Yfeld=0 THEN
 IF Anz_Anim=1 THEN PRINT CHR$(7);: REPEAT UNTIL MOUSEBUT =0: GOTO Mauswarten
 GOSUB Animationspeichern
 Animmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=1 THEN
 GOSUB Animationladen
 Animmenue_Aufbauen
 GOTO Mauswarten
 ENDIF
 IF Yfeld=2 THEN
 IF Mausknopf=1 THEN
 Movx=Movx-1
 ELSE
 Movx=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=3 THEN
 IF Mausknopf=1 THEN
 Movy=Movy-1
 ELSE
 Movy=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=4 THEN
 IF Mausknopf=1 THEN
 Movz=Movz-1
 ELSE
 Movz=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=5 THEN
 IF Mausknopf=1 THEN
 Drehz=Drehz-1
 ELSE
 Drehz=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=6 THEN
 IF Mausknopf=1 THEN
 Drehx=Drehx-1
 ELSE
 Drehx=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=7 THEN
 IF Mausknopf=1 THEN
 Drehy=Drehy-1
 ELSE
 Drehy=0
 ENDIF
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 Daten_Anzeigen
 BITBLT 79,0,562,53 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 79,0,562,53
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=8 THEN
 IF Anz_Anim=2999 THEN
 PRINT CHR$(7);
 REPEAT UNTIL MOUSEBUT =0
 GOTO Animmauswarten
 ENDIF
 IF Pointer<Anz_Anim THEN Anz_Anim=Pointer
 Anz_Anim=Anz_Anim+1
 Pointer=Anz_Anim
 Posx=Posx+Movx
 Posy=Posy+Movy
 Posz=Posz+Movz
 Winkelx=Winkelx+Drehx
 IF Winkelx<0 THEN Winkelx=360+Winkelx
 IF Winkelx>360 THEN Winkelx=Winkelx-360
 Winkely=Winkely+Drehy
 IF Winkely<0 THEN Winkely=360+Winkely
 IF Winkely>360 THEN Winkely=Winkely-360
 Winkelz=Winkelz+Drehz
 IF Winkelz<0 THEN Winkelz=360+Winkelz
 IF Winkelz>360 THEN Winkelz=Winkelz-360
 Objadr=Anispeicher+Pointer*600
 FOR T=1 TO Anz_Punkte
 Objadr=Objadr+20
 Obj_Zerlegen(0,T)
 Xdrehen=Xobj
 Ydrehen=Yobj
 Zdrehen=Zobj
 Wn=Winkelx
 IF Wn>0 THEN GOSUB Drehenx
 Wn=Winkely
 IF Wn>0 THEN GOSUB Dreheny
 Wn=Winkelz
 IF Wn>0 THEN GOSUB Drehenz
 Xobj=Xdrehen
 Yobj=Ydrehen
 Zobj=Zdrehen
 Xobj=Xobj+Posx
 Yobj=Yobj+Posy
 Zobj=Zobj+Posz
 WPOKE Objadr,Xobj
 WPOKE Objadr+2,Yobj
 WPOKE Objadr+4,Zobj
 WPOKE Objadr+6,Art
 IF T=1 THEN
 WPOKE Objadr+8,Posx
 WPOKE Objadr+10,Posy
 WPOKE Objadr+12,Posz
 WPOKE Objadr+14,Winkelx
 WPOKE Objadr+16,Winkely
 WPOKE Objadr+18,Winkelz
 ENDIF
 NEXT T
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 CLIP 79,51,639,399
 Vs_Clip(79,51,639,399)
 BITBLT 79,51,561,349 TO 79,51,562,349,0
 Obj_Anzeigen(Pointer)
 CLIP
 Vs_Clip
 Daten_Anzeigen
 BITBLT 0,0,640,400 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 0,0,640,400
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 IF Mausknopf=2 THEN REPEAT UNTIL MOUSEBUT =0
 GOTO Animmauswarten
 ENDIF
 IF Yfeld=9 THEN
 IF Mausknopf=1 THEN
 Pointer=Pointer+3
 ELSE
 Pointer=Pointer+1
 ENDIF
 IF Pointer>Anz_Anim THEN Pointer=Anz_Anim
 Obj_Zerlegen(Pointer,1)
 Posx=Xpos
 Posy=Ypos
 Posz=Zpos
 Winkelx=Xwinkel
 Winkely=Ywinkel
 Winkelz=Zwinkel
 WVBL
 XBIOS (,5,Hipic2,Lopic2,Hipic1,Lopic1,-1)
 CLIP 79,51,639,399
 Vs_Clip(79,51,639,399)
 BITBLT 79,51,561,349 TO 79,51,562,349,0
 Obj_Anzeigen(Pointer)
 CLIP
 Vs_Clip
 Daten_Anzeigen
 BITBLT 0,0,640,400 TO Pic3
 XBIOS (,5,Hipic1,Lopic1,Hipic2,Lopic2,-1)
 BITBLT Pic3 TO 0,0,640,400
 WVBL
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Animmauswarten
 ENDIF
 ENDIF
 GOTO Animmauswarten
-Animationzeigen
 CLS
 Hiscr1=Hipic1
 Loscr1=Lopic1
 Hiscr2=Hipic2
 Loscr2=Lopic2
-Animationzeigen2
 FOR T=1 TO Anz_Anim
 XBIOS (,5,Hiscr2,Loscr2,Hiscr1,Loscr1,-1)
 IF INKEY$ >"" THEN EXIT TO Animationzeigen3
 CLS
 CLIP 0,0 TO 639,399
 Vs_Clip(0,0,639,399)
 Obj_Anzeigen(T)
 SWAP Hiscr1,Hiscr2
 SWAP Loscr1,Loscr2
 NEXT T
 GOTO Animationzeigen2
-Animationzeigen3
 XBIOS (,5,Hipic1,Lopic1,Hipic1,Lopic1,-1)
 GOTO Hauptmenue
-Animationladen
 IF Objname$="" THEN RETURN
 CLS
 Path$="A:\CSCANIM\ANIMS\*.ANI"
 A$(1)="Animation laden"
 Zentriere(1)
 IF Animname$>"" THEN Animname$=Animname$+".ANI"
 MOUSEON
 FILESELECT (Path$,Animname$,Flag)
 MOUSEOFF
 IF Flag=0 THEN
 IF Animname$>"" THEN Animname$= LEFT$(Animname$, LEN(Animname$)-4)
 RETURN
 ENDIF
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))
 BLOAD Animname$,Anispeicher
 Anz_Punkte= PEEK(Anispeicher)
 Anz_Anim= PEEK(Anispeicher+1)
 Animname$= LEFT$(Animname$, LEN(Animname$)-4)
 RETURN
-Animationspeichern
 IF Objname$="" THEN RETURN
 IF Anz_Anim<1 THEN RETURN
 CLS
 Path$="A:\CSCANIM\ANIMS\*.ANI"
 A$(1)="Animation speichern"
 Zentriere(1)
 IF Animname$>"" THEN Animname$=Animname$+".ANI"
 MOUSEON
 FILESELECT (Path$,Animname$,Flag)
 MOUSEOFF
 IF Flag=0 THEN
 IF Animname$>"" THEN Animname$= LEFT$(Animname$, LEN(Animname$)-4)
 RETURN
 ENDIF
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\")+1)
 POKE Anispeicher,Anz_Punkte
 POKE Anispeicher+1,Anz_Anim
 BSAVE Animname$,Anispeicher,(Anz_Anim+1)*600
 Animname$= LEFT$(Animname$, LEN(Animname$)-4)
 RETURN
 END
-Anleitung
-Animationloeschen
 GOTO Hauptmenue
 LIBRARY CODE Gem
