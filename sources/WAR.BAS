 GOTO Anfang
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
 REPEAT
 UNTIL MOUSEBUT =0
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
 RETURN
 DEF PROC Zeichne_Arena
 CLS
 A$(1)="Die ARENA"
 Zentriere(1)
 DRAW 0,20 TO 639,20
 FILL STYLE =2,4
 PBOX 0,0 TO 260,20
 PRINT
 A$(1)="Programm 0 :                        : Programm 1"
 Zentriere(1)
 PBOX 380,0 TO 639,20
 PBOX 390,30,20,20
 FILL STYLE =1,1
 PBOX 230,30,20,20
 Zeichne_Spielfeld
 RETURN
 DEF PROC Zeichne_Spielfeld
 BOX 40,59 TO 600,395
 FOR X=40 TO 600 STEP 7
 DRAW X,59 TO X,395
 NEXT X
 FOR Y=59 TO 395 STEP 7
 DRAW 40,Y TO 600,Y
 NEXT Y
 FOR X=0 TO 79
 FOR Y=0 TO 47
 Taste$= INKEY$
 IF Taste$<>"" THEN
 MODE =1
 GOTO Hauptmenue
 ENDIF
 FILL STYLE =1,1
 IF Arena(X,Y)=0 THEN GOTO Zeichnen_Weiter
 IF Arena(X,Y)=1 THEN FILL STYLE =1,1
 IF Arena(X,Y)=2 THEN FILL STYLE =2,4
 PBOX 41+X*7,60+Y*7,6,6
-Zeichnen_Weiter
 MODE =3
 BOX 41+X*7,60+Y*7,6,6
 BOX 41+X*7,60+Y*7,6,6
 MODE =1
 NEXT Y
 NEXT X
 RETURN
 DEF PROC Decodiere_Zeile(Zeile)
 Decodier$=""
 Anweisung(Programm(Prg,Zeile*5))
 Decodier$=Decodier$+Anweisung$
 Decodier$=Decodier$+"   "
 IF Anweisung$="REM" THEN
 Decodier$=Decodier$+Remark$(Programm(Prg,Zeile*5+2),Prg)
 GOTO Decodiere_Zeile2
 ENDIF
 IF Anweisung$="LBL" THEN
 Decodier$=Decodier$+Label$(Programm(Prg,Zeile*5+1)\10,Prg)
 GOTO Decodiere_Zeile2
 ENDIF
 Arg1=Programm(Prg,Zeile*5+1)
 Arg1= FRAC(Arg1/10)*10
 IF Arg1=0 THEN Decodier$=Decodier$+" "
 IF Arg1=1 THEN Decodier$=Decodier$+"#"
 IF Arg1=2 THEN Decodier$=Decodier$+"<"
 IF Arg1=3 THEN Decodier$=Decodier$+">"
 Arg1=Programm(Prg,Zeile*5+1)
 Arg1=Arg1\10
 IF Arg1>0 THEN
 Decodier$=Decodier$+Label$(Arg1,Prg)
 Decodier$=Decodier$+" "*(20- LEN(Label$(Arg1,Prg)))
 ELSE
 Decodier$=Decodier$+ STR$(Programm(Prg,Zeile*5+2))
 ENDIF
 Decodier$=Decodier$+"  "
 Arg2=Programm(Prg,Zeile*5+3)
 Arg2= FRAC(Arg2/10)*10
 IF Arg2=0 THEN Decodier$=Decodier$+" "
 IF Arg2=1 THEN Decodier$=Decodier$+"&"
 Arg2=Programm(Prg,Zeile*5+3)
 Arg2=Arg2\10
 IF Arg2>0 THEN
 Decodier$=Decodier$+Label$(Arg2,Prg)
 Decodier$=Decodier$+" "*(20- LEN(Label$(Arg2,Prg)))
 ELSE
 Decodier$=Decodier$+ STR$(Programm(Prg,Zeile*5+4))
 ENDIF
-Decodiere_Zeile2
 PRINT " "*(3- LEN( STR$(Zeile))); STR$(Zeile);" : ";Decodier$;
 IF Druck<>1 THEN PRINT "K" ELSE PRINT
 RETURN
 DEF PROC Decodiere(Zeile)
 FOR T=Zeile TO MIN(Zeile+18,Anz_Lin(Prg))
 Decodiere_Zeile(T)
 NEXT T
 Cursor= CSRLIN
 WHILE CSRLIN <25
 PRINT "K"
 WEND
 PRINT "H";
 WHILE CSRLIN <Cursor
 PRINT
 WEND
 RETURN
 DEF PROC Anweisung(Token)
 IF Token>11 OR Token<0 THEN
 Anweisung$="UNK"
 ELSE
 Anweisung$=Befehl$(Token)
 ENDIF
 RETURN
 DEF PROC Token(Anweisung$)
 FOR T=0 TO 11
 IF Befehl$(T)=Anweisung$ THEN
 Token=T
 EXIT TO Token2
 ENDIF
 NEXT T
 Token=12
-Token2
 RETURN
 DEF FN Adresse(X,Y)=48*X+Y
 DEF FN Xkoor(Adresse)= INT(Adresse/48)
 DEF FN Ykoor(Adresse)=Adresse-FN Xkoor(Adresse)*48
-Anfang
 CHDIR "a:\war\kampfprg.s"
 Bild= MEMORY(32256)
 DIM Arena(79,47)
 DIM Arenacodes(80*48*5)
 DIM Adrzeiger(1,4000)
 DIM Programm(1,49*5)
 DIM A$(10),Prgname$(10)
 ' Programm(X,Y+Z)
 ' X = Programmnummer
 ' Y = Befehlszeile
 ' Z = 0 : Token
 ' Z = 1 : Vorzeichen 1
 ' Z = 2 : Wert 1
 ' Z = 3 : Vorzeichen 2
 ' Z = 4 : Wert 2
 DIM Anz_Lin(1)
 DIM Anz_Adr(1)
 DIM Mom_Adr(1)
 DIM Befehl$(20)
 DIM Remark$(30,1)
 DIM Label$(50,1)
 DIM Max_Label(1)
 DIM Max_Remark(1)
 DIM Label(50)
 DIM Remark(50)
 Label(0)=1
 Label(1)=1
 Befehl$(0)="DAT"
 Befehl$(1)="MOV"
 Befehl$(2)="ADD"
 Befehl$(3)="SUB"
 Befehl$(4)="JMP"
 Befehl$(5)="JMZ"
 Befehl$(6)="JMN"
 Befehl$(7)="DJN"
 Befehl$(8)="CMP"
 Befehl$(9)="SPL"
 Befehl$(10)="REM"
 Befehl$(11)="LBL"
 PRINT "f";
-Hauptmenue
 CLS
 TEXT HEIGHT =26
 TEXT STYLE =16
 TEXT 200,40,"Krieg Der Kerne"
 PRINT "B"*10
 A$(1)="K„mpfen"
 A$(2)="Parameter"
 A$(3)="Editor"
 A$(4)="Monitor"
 A$(5)="Laden und Speichern"
 A$(6)="Ende"
 Anz=6
 GOSUB Auswahl
 IF Stelle=6 THEN END
 ON Stelle GOTO Kampf,Params,Edi,Monitor,Speichern
-Params
 CLS
 A$(1)="PARAMETER"
 Zentriere(1)
 PRINT "B"*3
 A$(1)="Einzelschritt : "
 IF Einzel=-1 THEN
 A$(1)=A$(1)+"Ja"
 ELSE
 A$(1)=A$(1)+"Nein"
 ENDIF
 A$(2)="Warten"
 A$(3)="Zurck"
 Anz=3
 GOSUB Auswahl
 IF Stelle=3 THEN GOTO Hauptmenue
 IF Stelle=1 THEN Einzel= NOT (Einzel)
 IF Stelle=2 THEN
 CLS
 PRINT "e";
 INPUT "Wieviel Sekunden ? ";Zeit!
 PRINT "f";
 ENDIF
 GOTO Params
-Speichern
 CLS
 A$(1)="Laden und Speichern"
 Zentriere(1)
 PRINT "B"*5
 A$(1)="Programm 0 laden"
 A$(2)="Programm 1 laden"
 A$(3)="Arena laden"
 A$(4)="Programm 0 speichern"
 A$(5)="Programm 1 speichern"
 A$(6)="Arena speichern"
 A$(7)="Zurck"
 Anz=7
 GOSUB Auswahl
 ON Stelle GOTO Prg0load,Prg1load,Arenaload,Prg0save,Prg1save,Arenasave,Hauptmenue
-Prg0load
 Path$="A:\WAR\KAMPFPRG.S\*.PRO"
 Name$= LEFT$(Prgname$(0),8)
 IF Name$>"" THEN Name$=Name$+".PRO"
 MOUSEON
 FILESELECT (Path$,Name$,Button)
 MOUSEOFF
 IF Button=0 THEN GOTO Hauptmenue
 OPEN "i",1,Name$
 INPUT #1,Prgname$(0)
 INPUT #1,Anz_Lin
 FOR T=Anz_Lin(0)*5 TO Anz_Lin(0)*5+Anz_Lin*5+4
 INPUT #1,Programm(0,T)
 NEXT T
 Anz_Lin(0)=Anz_Lin(0)+Anz_Lin
 INPUT #1,Max_Remark(0)
 INPUT #1,Remark(0)
 FOR T=1 TO Max_Remark(0)
 LINE INPUT #1,Remark$(T,0)
 NEXT T
 INPUT #1,Max_Label(0)
 INPUT #1,Label(0)
 FOR T=1 TO Max_Label(0)
 LINE INPUT #1,Label$(T,0)
 NEXT T
 CLOSE 1
 GOTO Speichern
-Prg1load
 Path$="A:\WAR\KAMPFPRG.S\*.PRO"
 Name$= LEFT$(Prgname$(1),8)
 IF Name$>"" THEN Name$=Name$+".PRO"
 MOUSEON
 FILESELECT (Path$,Name$,Button)
 MOUSEOFF
 IF Button=0 THEN GOTO Hauptmenue
 OPEN "i",1,Name$
 INPUT #1,Prgname$(1)
 INPUT #1,Anz_Lin
 FOR T=Anz_Lin(1)*5 TO Anz_Lin(1)*5+Anz_Lin*5+4
 INPUT #1,Programm(1,T)
 NEXT T
 Anz_Lin(1)=Anz_Lin(1)+Anz_Lin
 INPUT #1,Max_Remark(1)
 INPUT #1,Remark(1)
 FOR T=1 TO Max_Remark(1)
 LINE INPUT #1,Remark$(T,1)
 NEXT T
 INPUT #1,Max_Label(1)
 INPUT #1,Label(1)
 FOR T=1 TO Max_Label(1)
 LINE INPUT #1,Label$(T,1)
 NEXT T
 CLOSE 1
 GOTO Speichern
-Arenaload
 Path$="A:\WAR\KAMPFPRG.S\*.ARE"
 Name$=""
 MOUSEON
 FILESELECT (Path$,Name$,Button)
 MOUSEOFF
 IF Button=0 THEN GOTO Hauptmenue
 OPEN "o",1,Name$
 INPUT #1,Mom_Adr(0)
 INPUT #1,Mom_Adr(1)
 INPUT #1,Anz_Adr(0)
 INPUT #1,Anz_Adr(1)
 INPUT #1,Prog
 FOR T=0 TO Anz_Adr(0)
 INPUT #1,Adrzeiger(0,T)
 NEXT T
 FOR T=0 TO Anz_Adr(1)
 INPUT #1,Adrzeiger(1,T)
 NEXT T
 FOR X=0 TO 79
 FOR Y=0 TO 47
 Taste$= INPUT$(1,1)
 Arena(X,Y)= ASC(Taste$)
 NEXT Y
 NEXT X
 FOR T=0 TO 80*48*5
 INPUT #1,Arenacodes(T)
 NEXT T
 CLOSE 1
 Spiel=1
 GOTO Speichern
-Prg0save
 Path$="A:\WAR\KAMPFPRG.S\*.PRO"
 Name$= LEFT$(Prgname$(0),8)
 IF Name$>"" THEN Name$=Name$+".PRO"
 MOUSEON
 FILESELECT (Path$,Name$,Button)
 MOUSEOFF
 IF Button=0 THEN GOTO Hauptmenue
 OPEN "o",1,Name$
 PRINT #1,Prgname$(0)
 PRINT #1,Anz_Lin(0)
 FOR T=0 TO Anz_Lin(0)*5+4
 PRINT #1,Programm(0,T)
 NEXT T
 PRINT #1,Max_Remark(0)
 PRINT #1,Remark(0)
 FOR T=1 TO Max_Remark(0)
 PRINT #1,Remark$(T,0)
 NEXT T
 PRINT #1,Max_Label(0)
 PRINT #1,Label(0)
 FOR T=1 TO Max_Label(0)
 PRINT #1,Label$(T,0)
 NEXT T
 CLOSE 1
 GOTO Speichern
-Prg1save
 Path$="A:\WAR\KAMPFPRG.S\*.PRO"
 Name$= LEFT$(Prgname$(1),8)
 IF Name$>"" THEN Name$=Name$+".PRO"
 MOUSEON
 FILESELECT (Path$,Name$,Button)
 MOUSEOFF
 IF Button=0 THEN GOTO Hauptmenue
 OPEN "o",1,Name$
 PRINT #1,Prgname$(1)
 PRINT #1,Anz_Lin(1)
 FOR T=0 TO Anz_Lin(1)*5+4
 PRINT #1,Programm(1,T)
 NEXT T
 PRINT #1,Max_Remark(1)
 PRINT #1,Remark(1)
 FOR T=1 TO Max_Remark(1)
 PRINT #1,Remark$(T,1)
 NEXT T
 PRINT #1,Max_Label(1)
 PRINT #1,Label(1)
 FOR T=1 TO Max_Label(1)
 PRINT #1,Label$(T,1)
 NEXT T
 CLOSE 1
 GOTO Speichern
-Arenasave
 Path$="A:\WAR\KAMPFPRG.S\*.ARE"
 Name$=""
 MOUSEON
 FILESELECT (Path$,Name$,Button)
 MOUSEOFF
 IF Button=0 THEN GOTO Hauptmenue
 OPEN "o",1,Name$
 PRINT #1,Mom_Adr(0)
 PRINT #1,Mom_Adr(1)
 PRINT #1,Anz_Adr(0)
 PRINT #1,Anz_Adr(1)
 PRINT #1,Prog
 FOR T=0 TO Anz_Adr(0)
 PRINT #1,Adrzeiger(0,T)
 NEXT T
 FOR T=0 TO Anz_Adr(1)
 PRINT #1,Adrzeiger(1,T)
 NEXT T
 FOR X=0 TO 79
 FOR Y=0 TO 47
 PRINT #1, CHR$(Arena(X,Y));
 NEXT Y
 NEXT X
 FOR T=0 TO 80*48*5
 PRINT #1,Arenacodes(T)
 NEXT T
 CLOSE 1
 GOTO Speichern
-Edi
 CLS
 IF Prgname$(Prg)="" THEN
 PRINT "            "; STR$(Prg)
 PRINT "A";
 INPUT "eProgrammname    : ";Prgname$(Prg) USING "a0+_>",Var,16
 PRINT "f";
 CLS
 ENDIF
 A$(1)="EDITOR"
 Zentriere(1)
 PRINT
 PRINT "Programm :"; STR$(Prg); SPC(3);Prgname$(Prg)
 DRAW 0,50 TO 639,50
 PRINT
 PRINT
 Decodiere(0)
 Stelle=0
 PRINT "H";"B"*5;" "*(3- LEN( STR$(Stelle))); STR$(Stelle);"e : ";
-Befehleingabe
 REPEAT UNTIL INKEY$ =""
 Code$=""
 FOR T=1 TO 3
 REPEAT
 Taste$= INKEY$
 UNTIL Taste$>""
 Ascii= CVIL(Taste$) AND $FF
 Scan= CVIL(Taste$) SHR (16) AND $FF
 Taste$= CHR$(Ascii)
 IF Ascii<>0 THEN
 IF ASC(Taste$)=127 THEN EXIT TO Zeile_Loeschen' DEL
 IF ASC(Taste$)=27 THEN ' ESC
 PRINT "f";
 EXIT TO Hauptmenue
 ENDIF
 IF ASC(Taste$)=13 THEN EXIT TO Edi4' RETURN
 ELSE
 IF Scan=82 THEN EXIT TO Zeile_Einfuegen' INSERT
 IF Scan=98 THEN EXIT TO Hilfe' HELP
 IF Scan=72 THEN ' CURSOR UP
 PRINT
 PRINT "A";
 Decodiere_Zeile(Stelle)
 Stelle=Stelle-1
 Wert$=""
 IF Stelle<0 THEN Stelle=0: PRINT "A";" "*(3- LEN( STR$(Stelle))); STR$(Stelle);" : ";: GOTO Befehleingabe
 PRINT "A"*2;
 IF CSRLIN <=5 THEN
 PRINT "H";"B"*4
 Decodiere(Stelle)
 PRINT "H";"B"*4
 ENDIF
 PRINT " "*(3- LEN( STR$(Stelle))); STR$(Stelle);" : ";
 Wert$=""
 GOTO Befehleingabe
 ENDIF
 IF Scan=80 THEN EXIT TO Edi4' CURSOR DOWN
 ENDIF
 IF UPPER$(Taste$)<"A" OR UPPER$(Taste$)>"Z" AND Taste$<>" " THEN EXIT TO Eingabefehler
 PRINT UPPER$(Taste$);
 Code$=Code$+ UPPER$(Taste$)
 NEXT T
 PRINT "K";
 Token(Code$)
 IF Token<12 THEN
 IF Programm(Prg,Stelle*5)=10 THEN Remark(Prg)=Programm(Prg,Stelle*5+2):Remark$(Remark(Prg),Prg)=""
 IF Programm(Prg,Stelle*5)=11 THEN Label(Prg)=Programm(Prg,Stelle*5+1)\10:Label$(Label(Prg),Prg)=""
 Programm(Prg,Stelle*5)=T
 GOTO Edi2
 ENDIF
 IF Code$="REN" THEN
 Prgname$(Prg)=""
 INPUT "   ";Prgname$(Prg) USING "a0+_>",Var,16
 GOTO Edi
 ENDIF
 IF Code$="LST" THEN
 OPEN "p",1
 CMD 1
 IF Prgname$(Prg)>"" THEN
 Name$= LEFT$(Name$, LEN(Name$)- INSTR( MIRROR$(Name$),"."))
 PRINT "PROGRAMM : ";Prgname$(Prg)
 ENDIF
 Druck=1
 FOR T=0 TO Anz_Lin(Prg)
 Decodiere_Zeile(T)
 NEXT T
 Druck=0
 CLOSE 1
 GOTO Edi4
 ENDIF
 IF Code$="EXT" THEN
 PRINT "f";
 GOTO Hauptmenue
 ENDIF
 IF Code$="PRG" THEN
 PRINT "f";
 Prg=Prg+1+(Prg=1)*2
 GOTO Edi
 ENDIF
 IF Code$="GOL" THEN
 PRINT "  ";
 INPUT " ";Zeile
 IF Zeile>48 OR Zeile<0 THEN PRINT "A";: GOTO Eingabefehler
 Stelle2= CSRLIN -7
 Stelle=Zeile-Stelle2
 PRINT "H";"B"*4
 IF Stelle>=0 THEN Decodiere(Stelle) ELSE Decodiere(0)
 IF Stelle<0 THEN
 PRINT "H";"B"*(4+Stelle2)
 ELSE
 PRINT "H";"B"*(4-Stelle)
 ENDIF
 PRINT Stelle
 Stelle=Zeile
 PRINT " "*(3- LEN( STR$(Stelle))); STR$(Stelle);" : ";
 GOTO Befehleingabe
 ENDIF
 IF Code$="CLR" THEN
 FOR T=0 TO 49*4
 Programm(Prg,T)=0
 Anz_Lin(Prg)=0
 Prgname$(Prg)=""
 NEXT T
 GOTO Edi
 ENDIF
 IF Code$="HLP" THEN
-Hilfe
 PRINT "f";
 CLS
 A$(1)="BEFEHLSSATZ"
 Zentriere(1)
 PRINT "B"*3
 PRINT "BEFEHL  ARGUMENT  ERKLŽRUNG"
 PRINT
 PRINT "DAT          B    Schreibt Data-Wert B in die Zelle"
 PRINT "MOV       A  B    Schreibe A in Adresse B"
 PRINT "ADD       A  B    Addiere A zu Inhalt B,speichere in B"
 PRINT "SUB       A  B    Subtrahiere A von Inhalt B,speichere in B"
 PRINT "JMP       A       Springe nach A"
 PRINT "JMZ       A  B    Springe nach A wenn B=0"
 PRINT "JMN       A  B    Springe nach A wenn B<>0"
 PRINT "DJN       A  B    Ziehe von B eins ab und springe nach A wenn B<>0"
 PRINT "CMP       A  B    Verleiche A mit B,falls ungleich berspringe n„chsten Befehl"
 PRINT "SPL       A       Spalte das Programm auf in n„chste Adresse und Adresse A"
 PRINT "Editor-Befehlssatz"
 PRINT "GOL       A       Springt zur Linie A"
 PRINT "PRG               Schaltet aufs andere Programm"
 PRINT "EXT               Zurck zum Hauptmenue"
 PRINT "CLR               L”scht das Programm"
 PRINT "HLP               Ruft diese Seite auf"
 Taste$= INPUT$(1)
 CLS
 A$(1)="EDITOR"
 Zentriere(1)
 PRINT
 PRINT "Programm :"; STR$(Prg)
 DRAW 0,50 TO 639,50
 PRINT
 PRINT
 Decodiere(Stelle)
 PRINT "H";"B"*5;" "*(3- LEN( STR$(Stelle))); STR$(Stelle);"e : ";
 GOTO Befehleingabe
 ENDIF
-Eingabefehler
 PRINT
 PRINT CHR$(7);"A";" "*(3- LEN( STR$(Stelle))); STR$(Stelle);" : ";
 GOTO Befehleingabe
-Zeile_Loeschen
 Anz_Lin(Prg)=Anz_Lin(Prg)-1
 IF Programm(Prg,Stelle)=10 THEN
 Remark(Prg)=Programm(Prg,Stelle+2)
 Remark$(Remark(Prg),Prg)=""
 ENDIF
 IF Programm(Prg,Stelle)=11 THEN
 Label(Prg)=Programm(Prg,Stelle+1)-3\10
 Label$(Label(Prg),Prg)=""
 ENDIF
 FOR T=Stelle TO Anz_Lin(Prg)
 FOR S=0 TO 4
 Programm(Prg,T*5+S)=Programm(Prg,T*5+5+S)
 NEXT S
 NEXT T
 Cursor= CSRLIN
 FOR T=Stelle+1 TO MIN(Stelle+Cursor-4,Anz_Lin(Prg))
 Decodiere_Zeile(T)
 NEXT T
 FOR T= CSRLIN TO 23
 PRINT "K";
 NEXT T
 PRINT "H";
 PRINT "B"* CSRLIN ;
 PRINT CHR$(7);"A";" "*(3- LEN( STR$(Stelle))); STR$(Stelle);" : ";
 GOTO Befehleingabe
-Zeile_Einfuegen
 IF Anz_Lin(Prg)=47 THEN GOTO Eingabefehler
 Anz_Lin(Prg)=Anz_Lin(Prg)+1
 FOR T=Anz_Lin(Prg)-1 TO Stelle+1 STEP -1
 FOR S=0 TO 4
 Programm(Prg,T*5+5+S)=Programm(Prg,T*5+S)
 NEXT S
 NEXT T
 FOR S=0 TO 4
 Programm(Prg,Stelle*5+S+5)=0
 NEXT S
 PRINT "H";"B"*5;
 Decodiere(Stelle)
 PRINT "H";"B"*5;" "*(3- LEN( STR$(Stelle))); STR$(Stelle);" : ";
 GOTO Befehleingabe
-Edi2
 PRINT "   ";
 IF Programm(Prg,Stelle*5)=0 THEN GOTO Argument_B
 IF Programm(Prg,Stelle*5)=10 THEN
 IF Remark(Prg)=30 THEN GOTO Eingabefehler
 Remark(Prg)=Remark(Prg)+1
 INPUT " ";Remark$(Remark(Prg),Prg) USING "a0%>",Var,50
 Programm(Prg,Stelle*5+2)=Remark(Prg)
 IF Max_Remark(Prg)<Remark(Prg) THEN Max_Remark(Prg)=Remark(Prg)
 WHILE Remark(Prg)<30 AND Remark$(Remark(Prg),Prg)>""
 Remark(Prg)=Remark(Prg)+1
 WEND
 GOTO Edi4
 ENDIF
 IF Programm(Prg,Stelle*5)=11 THEN
 IF Label(Prg)=50 THEN GOTO Eingabefehler
 Label$(Label(Prg),Prg)=""
 INPUT " ";Label$(Label(Prg),Prg) USING "a0+_>",Var,20
 IF Label$(Label(Prg),Prg)="" THEN Label(Prg)=Label(Prg)-1: GOTO Eingabefehler
 FOR T=0 TO Anz_Lin(Prg)
 IF T<>Stelle AND Programm(Prg,T*5)=11 AND (Label$(Programm(Prg,T*5+1)\10,Prg)=Label$(Label(Prg),Prg) OR Label$(Programm(Prg,T*5+3)\10,Prg)=Label$(Label(Prg),Prg)) THEN
 Label$(Label(Prg),Prg)=""
 Label(Prg)=Label(Prg)-1
 Programm(Prg,Stelle*5)=0
 EXIT TO Eingabefehler
 ENDIF
 NEXT T
 IF VAL(Label$(Label(Prg),Prg))>0 THEN Label$(Label(Prg),Prg)="":Label(Prg)=Label(Prg)-1: GOTO Eingabefehler
 Programm(Prg,Stelle*5+1)=Label(Prg)*10
 IF Max_Label(Prg)<Label(Prg) THEN Max_Label(Prg)=Label(Prg)
 WHILE Label(Prg)<50 AND Label$(Label(Prg),Prg)>""
 Label(Prg)=Label(Prg)+1
 WEND
 GOTO Edi4
 ENDIF
-Flageingabe
 Taste$= INPUT$(1)
 IF Taste$="#" THEN
 PRINT "#";
 IF Programm(Prg,Stelle*5+1)>10 THEN
 Programm(Prg,Stelle*5+1)=Programm(Prg,Stelle*5+1)+1
 ELSE
 Programm(Prg,Stelle*5+1)=1
 ENDIF
 GOTO Argument_A
 ENDIF
 IF Taste$="<" THEN
 PRINT "<";
 IF Programm(Prg,Stelle*5+1)>10 THEN
 Programm(Prg,Stelle*5+1)=Programm(Prg,Stelle*5+1)+2
 ELSE
 Programm(Prg,Stelle*5+1)=2
 ENDIF
 GOTO Argument_A
 ENDIF
 IF Taste$=">" THEN
 PRINT ">";
 IF Programm(Prg,Stelle*5+1)>10 THEN
 Programm(Prg,Stelle*5+1)=Programm(Prg,Stelle*5+1)+3
 ELSE
 Programm(Prg,Stelle*5+1)=3
 ENDIF
 GOTO Argument_A
 ENDIF
 Wert$=""
 IF Programm(Prg,Stelle*5+1)<11 THEN Programm(Prg,Stelle*5+1)=0
 GOTO Argument_A2
-Argument_A
 Taste$= INPUT$(1)
 IF ASC(Taste$)=13 OR Taste$=" " THEN GOTO Argument_B
-Argument_A2
 IF (Taste$<"0" OR Taste$>"9") AND Taste$<>"-" THEN
 Var2=2
 INPUT " ";Taste$ USING "a0+_>x ",Var,20, ASC("_"),Var2
 IF Taste$="" OR LEFT$(Taste$,1)=" " THEN GOTO Eingabefehler
 Var2=0
 WHILE Label$(Var2,Prg)<>Taste$ AND Max_Label(Prg)>=Var2
 Var2=Var2+1
 WEND
 IF Var2<=Max_Label(Prg) THEN
 Programm(Prg,Stelle*5+1)=Programm(Prg,Stelle*5+1)+Var2*10
 ELSE
 IF Label(Prg)=50 THEN GOTO Eingabefehler
 Label$(Label(Prg),Prg)=Taste$
 IF Max_Label(Prg)<Label(Prg) THEN Max_Label(Prg)=Label(Prg)
 Programm(Prg,Stelle*5+1)=Programm(Prg,Stelle*5+1)+Label(Prg)*10
 WHILE Label(Prg)<50 AND Label$(Label(Prg),Prg)>""
 Label(Prg)=Label(Prg)+1
 WEND
 ENDIF
 GOTO Argument_B
 ENDIF
 Wert$=Wert$+Taste$
 PRINT Taste$;
 IF LEN(Wert$)<7 THEN GOTO Argument_A
-Argument_B
 Programm(Prg,Stelle*5+2)= VAL(Wert$)
 IF Programm(Prg,Stelle*5)=4 OR Programm(Prg,Stelle*5)=9 THEN
 Wert$=""
 GOTO Edi3
 ENDIF
 Wert$=""
 PRINT "  ";
 Taste$= INPUT$(1)
 IF Taste$="&" THEN
 Programm(Prg,Stelle*5+3)=1
 PRINT "&";
 GOTO Argument_B2
 ELSE
 PRINT " ";
 Programm(Prg,Stelle*5+3)=0
 Wert$=""
 GOTO Argument_B3
 ENDIF
-Argument_B2
 Taste$= INPUT$(1)
 IF ASC(Taste$)=13 OR Taste$=" " THEN GOTO Edi3
-Argument_B3
 IF (Taste$<"0" OR Taste$>"9") AND Taste$<>"-" THEN
 Var2=2
 INPUT " ";Taste$ USING "a0+_>x ",Var,20, ASC("_"),Var2
 IF Taste$="" OR LEFT$(Taste$,1)=" " THEN GOTO Eingabefehler
 Var2=0
 WHILE Label$(Var2,Prg)<>Taste$ AND Max_Label(Prg)>=Var2
 Var2=Var2+1
 WEND
 IF Var2<=Max_Label(Prg) THEN
 Programm(Prg,Stelle*5+3)=Programm(Prg,Stelle*5+3)+Var2*10
 ELSE
 IF Label(Prg)=50 THEN GOTO Eingabefehler
 Label$(Label(Prg),Prg)=Taste$
 IF Max_Label(Prg)<Label(Prg) THEN Max_Label(Prg)=Label(Prg)
 Programm(Prg,Stelle*5+3)=Programm(Prg,Stelle*5+3)+Label(Prg)*10
 WHILE Label(Prg)<50 AND Label$(Label(Prg),Prg)>""
 Label(Prg)=Label(Prg)+1
 WEND
 ENDIF
 GOTO Edi3
 ENDIF
 Wert$=Wert$+Taste$
 PRINT Taste$;
 IF LEN(Wert$)<7 THEN GOTO Argument_B2
-Edi3
 Programm(Prg,Stelle*5+4)= VAL(Wert$)
-Edi4
 PRINT
 PRINT "A";
 Decodiere_Zeile(Stelle)
 Wert$=""
 IF Stelle=48 THEN GOTO Edi
 Stelle=Stelle+1
 IF Stelle>Anz_Lin(Prg) THEN Anz_Lin(Prg)=Stelle
 IF CSRLIN >=24 THEN
 PRINT "H";"B"*4
 Decodiere(Stelle-18)
 PRINT "A";
 ENDIF
 PRINT " "*(3- LEN( STR$(Stelle))); STR$(Stelle);" : ";
 Wert$=""
 GOTO Befehleingabe
-Monitor
 CLS
 A$(1)="MONITOR"
 Zentriere(1)
 PRINT " Xkoordinate   Ykoordinate   Adresse   Label   Argument A   Argument B   Eigner"
 Zeichne_Spielfeld
 MODE =3
-Monitor2
 REPEAT
 X= MOUSEX
 Y= MOUSEY
 X2=X
 Y2=Y
 IF X2<40 THEN X2=40
 IF X2>595 THEN X2=595
 IF Y2<59 THEN Y2=59
 IF Y2>390 THEN Y2=390
 X2=40+ INT((X2-40)/7)*7+1
 Y2=59+ INT((Y2-59)/7)*7+1
 X3=(X2-41)/7
 Y3=(Y2-59)/7
 PRINT SPC(8- LEN( STR$(X3))); STR$(X3); SPC(14- LEN( STR$(Y3))); STR$(Y3);
 PRINT SPC(13- LEN( STR$(FN Adresse(X3,Y3)))); STR$(FN Adresse(X3,Y3));
 Anweisung(Arenacodes(FN Adresse(X3,Y3)*5))
 PRINT SPC(5);Anweisung$;
 Argument$=""
 IF Arenacodes(FN Adresse(X3,Y3)*5+1)=1 THEN Argument$=Argument$+"#"
 Argument$=Argument$+ STR$(Arenacodes(FN Adresse(X3,Y3)*5+2))
 PRINT SPC(12- LEN(Argument$));Argument$;
 Argument$=""
 IF Arenacodes(FN Adresse(X3,Y3)*5+3)=1 THEN Argument$=Argument$+"&"
 Argument$=Argument$+ STR$(Arenacodes(FN Adresse(X3,Y3)*5+4))
 PRINT SPC(13- LEN(Argument$));Argument$; SPC(6);
 IF Arena(X3,Y3)=0 THEN
 PRINT " -"
 ELSE
 PRINT STR$(Arena(X3,Y3)-1)
 ENDIF
 PRINT "A";
 BOX X2,Y2,6,6
 REPEAT
 UNTIL MOUSEX <>X OR MOUSEY <>Y OR MOUSEBUT >0
 BOX X2,Y2,6,6
 UNTIL MOUSEBUT >0
 IF MOUSEBUT =2 THEN
 MODE =1
 GOTO Hauptmenue
 ENDIF
 BOX X2,Y2,6,6
 PRINT "e"; TAB (40);
-Monitor3
 Code$=""
 FOR T=0 TO 2
 Taste$= INPUT$(1)
 IF ASC(Taste$)=13 OR Taste$=" " THEN EXIT TO Monitor5
 IF UPPER$(Taste$)<"A" OR UPPER$(Taste$)>"Z" THEN EXIT TO Monitor4
 Code$=Code$+ UPPER$(Taste$)
 PRINT UPPER$(Taste$);
 NEXT T
 Token(Code$)
 IF Token<10 THEN
 Arenacodes(FN Adresse(X3,Y3)*5)=Token
 GOTO Monitor5
 ENDIF
-Monitor4
 PRINT CHR$(7);"D"* LEN(Code$);
 GOTO Monitor3
-Monitor5
 PRINT TAB (48);
 Taste$= INPUT$(1)
 IF ASC(Taste$)=13 THEN
 PRINT "    ";
 Argument$=""
 GOTO Monitor9
 ENDIF
 IF (Taste$>="0" AND Taste$<="9") OR Taste$="-" THEN
 PRINT " ";
 Argument$=""
 Arenacodes(FN Adresse(X3,Y3)*5+1)=0
 GOTO Monitor7
 ENDIF
 IF Taste$="#" THEN
 PRINT "#";
 Arenacodes(FN Adresse(X3,Y3)*5+1)=1
 ELSE
 PRINT " ";
 Arenacodes(FN Adresse(X3,Y3)*5+1)=0
 ENDIF
 Argument$=""
-Monitor6
 Taste$= INPUT$(1)
 IF Taste$=" " OR ASC(Taste$)=13 THEN GOTO Monitor8
 IF (Taste$<"0" OR Taste$>"9") AND Taste$<>"-" THEN
 PRINT CHR$(7);
 GOTO Monitor6
 ENDIF
-Monitor7
 Argument$=Argument$+Taste$
 PRINT Taste$;
 IF LEN(Argument$)<7 THEN GOTO Monitor6
-Monitor8
 Arenacodes(FN Adresse(X3,Y3)*5+2)= VAL(Argument$)
-Monitor9
 PRINT SPC(12- LEN(Argument$));
 Argument$=""
 Taste$= INPUT$(1)
 IF ASC(Taste$)=13 THEN GOTO Monitor13
 IF (Taste$>="0" AND Taste$<="9") OR Taste$="-" THEN
 PRINT " ";
 Argument$=""
 Arenacodes(FN Adresse(X3,Y3)*5+3)=0
 GOTO Monitor11
 ENDIF
 IF Taste$="&" THEN
 PRINT "&";
 Arenacodes(FN Adresse(X3,Y3)*5+3)=1
 ELSE
 PRINT " ";
 Arenacodes(FN Adresse(X3,Y3)*5+3)=0
 ENDIF
 Argument$=""
-Monitor10
 Taste$= INPUT$(1)
 IF Taste$=" " OR ASC(Taste$)=13 THEN GOTO Monitor12
 IF (Taste$<"0" OR Taste$>"9") AND Taste$<>"-" THEN
 PRINT CHR$(7);
 GOTO Monitor10
 ENDIF
-Monitor11
 Argument$=Argument$+Taste$
 PRINT Taste$;
 IF LEN(Argument$)<7 THEN GOTO Monitor10
-Monitor12
 Arenacodes(FN Adresse(X3,Y3)*5+4)= VAL(Argument$)
-Monitor13
 Argument$=""
 PRINT "f"
 PRINT "A";
 BOX X2,Y2,6,6
 GOTO Monitor2
-Kampf
 CLS
 A$(1)="Der KAMPF"
 Zentriere(1)
 PRINT "B"*5
 IF Anz_Lin(0)=0 AND Anz_Lin(1)=0 THEN
 A$(1)="Kein Kampfprogramm im Speicher"
 Zentriere(1)
 Taste$= INPUT$(1)
 GOTO Hauptmenue
 ENDIF
 IF Anz_Lin(0)=0 THEN
 A$(1)="Kein 1.Kampfprogramm im Speicher"
 Zentriere(1)
 Taste$= INPUT$(1)
 GOTO Hauptmenue
 ENDIF
 IF Anz_Lin(1)=0 THEN
 A$(1)="Kein 2.Kampfprogramm im Speicher"
 Zentriere(1)
 Taste$= INPUT$(1)
 GOTO Hauptmenue
 ENDIF
 A$(1)="Neue Runde"
 A$(2)="Alte Runde weiterspielen"
 A$(3)="Zurck"
 Anz=3
 GOSUB Auswahl
 IF Stelle=3 THEN GOTO Hauptmenue
 IF Stelle=1 THEN
 Spiel=0
 MAT CLEAR Arena(79,47)
 MAT CLEAR Arenacodes(80*48*5)
 MAT CLEAR Adrzeiger(1,1000)
 Mom_Adr(0)=0
 Mom_Adr(1)=0
 Anz_Adr(0)=1
 Anz_Adr(1)=1
 ENDIF
 IF Spiel=0 THEN
 Spiel=1
 Prog=0
 FILL STYLE =1,1
 Adrzeiger(0,0)= INT( RND(3840))
 Prgende=Adrzeiger(0,0)+Anz_Lin(0)-1
 Ptr=0
 FOR T=Adrzeiger(0,0) TO Prgende
 Adr=T
 IF Adr>3839 THEN Adr=Adr-3840
 Arena(FN Xkoor(Adr-Ptr),FN Ykoor(Adr-Ptr))=1
 IF Programm(0,(T-Adrzeiger(0,0))*5)=10 THEN Ptr=Ptr+1:Arena(FN Xkoor(Adr),FN Ykoor(Adr))=0: GOTO Kampf1_5
 IF Programm(0,(T-Adrzeiger(0,0))*5)=11 THEN Ptr=Ptr+1:Arena(FN Xkoor(Adr),FN Ykoor(Adr))=0: GOTO Kampf1_5
 Arenacodes((Adr-Ptr)*5)=Programm(0,(T-Adrzeiger(0,0))*5)
 IF Programm(0,(T-Adrzeiger(0,0))*5+1)\10=0 THEN ' Label oder nicht ?
 Arenacodes((Adr-Ptr)*5+1)=Programm(0,(T-Adrzeiger(0,0))*5+1)
 Arenacodes((Adr-Ptr)*5+2)=Programm(0,(T-Adrzeiger(0,0))*5+2)
 GOTO Kampf1_2
 ELSE
 Arenacodes((Adr-Ptr)*5+1)= FRAC(Programm(0,(T-Adrzeiger(0,0))*5+1)/10)*10
 Zeile=0' Zeiger auf erste Programmzeile
-Kampf1_1
 IF Programm(0,Zeile*5)=11 THEN ' LBL gefunden
   IF Label$(Programm(0,Zeile*5+1)\10,0)=Label$(Programm(0,(T-Adrzeiger(0,0))*5+1)\10,0) THEN ' definiertes Label = gesuchtes Label
     Counter=0
     FOR S= MIN(Zeile+1,T-Adrzeiger(0,0)+1) TO MAX(Zeile-1,T-Adrzeiger(0,0)-1)' Befehle zwischen Label und Befehl
       IF Programm(0,S*5)=10 OR Programm(0,S*5)=11 THEN Counter=Counter+1' REMs und LBLs werden nicht mitgez„hlt
     NEXT S
     Abst=Zeile-T+Adrzeiger(0,0)+1- SGN(Zeile-T+Adrzeiger(0,0))*Counter' Anzahl der Befehle zwischen Label und Befehl (ohne REMs und LBLs)
     IF Zeile-T+Adrzeiger(0,0)>0 THEN Abst=Abst-1
     Arenacodes((Adr-Ptr)*5+2)=Abst
     GOTO Kampf1_2
   ENDIF
 ENDIF
 Zeile=Zeile+1
 IF Zeile>Anz_Lin(0) THEN
 CLS
 PRINT "pLabel nicht definiert in Zeile "+ STR$(T-Adrzeiger(0,0));" Programm ";Prgname$(0)
 PRINT "Label : "+Label$(Programm(0,(T-Adrzeiger(0,0))*5+1)\10,0)+"q"
 Taste$= INPUT$(1)
 GOTO Hauptmenue
 ENDIF
 ENDIF
 GOTO Kampf1_1
-Kampf1_2
 IF Programm(0,(T-Adrzeiger(0,0))*5+3)\10=0 THEN ' Label oder nicht ?
 Arenacodes((Adr-Ptr)*5+3)=Programm(0,(T-Adrzeiger(0,0))*5+3)
 Arenacodes((Adr-Ptr)*5+4)=Programm(0,(T-Adrzeiger(0,0))*5+4)
 GOTO Kampf1_5
 ELSE
 Arenacodes((Adr-Ptr)*5+3)= FRAC(Programm(0,(T-Adrzeiger(0,0))*5+3)/10)*10
 Zeile=0' Zeiger auf erste Programmzeile
-Kampf1_3
 IF Programm(0,Zeile*5)=11 THEN ' LBL gefunden
   IF Label$(Programm(0,Zeile*5+1)\10,0)=Label$(Programm(0,(T-Adrzeiger(0,0))*5+3)\10,0) THEN ' definiertes Label = gesuchtes Label
     Counter=0
     FOR S= MIN(Zeile+1,T-Adrzeiger(0,0)+3) TO MAX(Zeile-1,T-Adrzeiger(0,0)-1)' Befehle zwischen Label und Befehl
       IF Programm(0,S*5)=10 OR Programm(0,S*5)=11 THEN Counter=Counter+1' REMs und LBLs werden nicht mitgez„hlt
     NEXT S
     Abst=Zeile-T+Adrzeiger(0,0)+1- SGN(Zeile-T+Adrzeiger(0,0))*Counter' Anzahl der Befehle zwischen Label und Befehl (ohne REMs und LBLs)
     IF Zeile-T+Adrzeiger(0,0)>0 THEN Abst=Abst-1
     Arenacodes((Adr-Ptr)*5+4)=Abst
     GOTO Kampf1_5
   ENDIF
 ENDIF
 Zeile=Zeile+1
 IF Zeile>Anz_Lin(0) THEN
 CLS
 PRINT "pLabel nicht definiert in Zeile "; STR$(T-Adrzeiger(0,0));" Programm ";Prgname$(0)
 PRINT "Label : "+Label$(Programm(0,(T-Adrzeiger(0,0))*5+3)\10,0)+"q"
 Taste$= INPUT$(1)
 GOTO Hauptmenue
 ENDIF
 ENDIF
 GOTO Kampf1_3
-Kampf1_5
 NEXT T
-Kampf2
 Ptr=0
 Adrzeiger(1,0)= INT( RND(3840))
 Prgende2=Adrzeiger(1,0)+Anz_Lin(1)-1
 IF Adrzeiger(1,0)>=Adrzeiger(0,0) AND Adrzeiger(1,0)<=Prgende THEN GOTO Kampf2
 IF Prgende2>=Adrzeiger(0,0) AND Prgende2<=Prgende THEN GOTO Kampf2
 IF Adrzeiger(1,0)<Adrzeiger(0,0) AND Prgende2>Prgende THEN GOTO Kampf2
 FOR T=Adrzeiger(1,0) TO Prgende2
 Adr=T
 IF Adr>3839 THEN Adr=Adr-3840
 Arena(FN Xkoor(Adr-Ptr),FN Ykoor(Adr-Ptr))=2
 IF Programm(1,(T-Adrzeiger(1,0))*5)=10 THEN Ptr=Ptr+1:Arena(FN Xkoor(Adr),FN Ykoor(Adr))=0: GOTO Kampf2_5
 IF Programm(1,(T-Adrzeiger(1,0))*5)=11 THEN Ptr=Ptr+1:Arena(FN Xkoor(Adr),FN Ykoor(Adr))=0: GOTO Kampf2_5
 Arenacodes((Adr-Ptr)*5)=Programm(1,(T-Adrzeiger(1,0))*5)
 IF Programm(1,(T-Adrzeiger(1,0))*5+1)\10=0 THEN ' Label oder nicht ?
 Arenacodes((Adr-Ptr)*5+1)=Programm(1,(T-Adrzeiger(1,0))*5+1)
 Arenacodes((Adr-Ptr)*5+2)=Programm(1,(T-Adrzeiger(1,0))*5+2)
 GOTO Kampf2_2
 ELSE
 Arenacodes((Adr-Ptr)*5+1)= FRAC(Programm(1,(T-Adrzeiger(1,0))*5+1)/10)*10
 Zeile=0' Zeiger auf erste Programmzeile
-Kampf2_1
 IF Programm(1,Zeile*5)=11 THEN ' LBL gefunden
   IF Label$(Programm(1,Zeile*5+1)\10,1)=Label$(Programm(1,(T-Adrzeiger(1,0))*5+1)\10,1) THEN ' definiertes Label = gesuchtes Label
     Counter=0
     FOR S= MIN(Zeile+1,T-Adrzeiger(1,0)+1) TO MAX(Zeile-1,T-Adrzeiger(1,0)-1)' Befehle zwischen Label und Befehl
       IF Programm(1,S*5)=10 OR Programm(1,S*5)=11 THEN Counter=Counter+1' REMs und LBLs werden nicht mitgez„hlt
     NEXT S
     Abst=Zeile-T+Adrzeiger(1,0)+1- SGN(Zeile-T+Adrzeiger(1,0))*Counter' Anzahl der Befehle zwischen Label und Befehl (ohne REMs und LBLs)
     IF Zeile-T+Adrzeiger(1,0)>0 THEN Abst=Abst-1
     Arenacodes((Adr-Ptr)*5+2)=Abst
     GOTO Kampf2_2
   ENDIF
 ENDIF
 Zeile=Zeile+1
 IF Zeile>Anz_Lin(1) THEN
 CLS
 PRINT "pLabel nicht definiert in Zeile "; STR$(T-Adrzeiger(1,0));" Programm ";Prgname$(1)
 PRINT "Label : "+Label$(Programm(1,(T-Adrzeiger(1,0))*5+1)\10,1)+"q"
 Taste$= INPUT$(1)
 GOTO Hauptmenue
 ENDIF
 ENDIF
 GOTO Kampf2_1
-Kampf2_2
 IF Programm(1,(T-Adrzeiger(1,0))*5+3)\10=0 THEN ' Label oder nicht ?
 Arenacodes((Adr-Ptr)*5+3)=Programm(1,(T-Adrzeiger(1,0))*5+3)
 Arenacodes((Adr-Ptr)*5+4)=Programm(1,(T-Adrzeiger(1,0))*5+4)
 GOTO Kampf2_5
 ELSE
 Arenacodes((Adr-Ptr)*5+3)= FRAC(Programm(1,(T-Adrzeiger(1,0))*5+3)/10)*10
 Zeile=0' Zeiger auf erste Programmzeile
-Kampf2_3
 IF Programm(1,Zeile*5)=11 THEN ' LBL gefunden
   IF Label$(Programm(1,Zeile*5+1)\10,1)=Label$(Programm(1,(T-Adrzeiger(1,0))*5+3)\10,1) THEN ' definiertes Label = gesuchtes Label
     Counter=0
     FOR S= MIN(Zeile+1,T-Adrzeiger(1,0)+3) TO MAX(Zeile-1,T-Adrzeiger(1,0)-1)' Befehle zwischen Label und Befehl
       IF Programm(1,S*5)=10 OR Programm(1,S*5)=11 THEN Counter=Counter+1' REMs und LBLs werden nicht mitgez„hlt
     NEXT S
     Abst=Zeile-T+Adrzeiger(1,0)+1- SGN(Zeile-T+Adrzeiger(1,0))*Counter' Anzahl der Befehle zwischen Label und Befehl (ohne REMs und LBLs)
     IF Zeile-T+Adrzeiger(1,0)>0 THEN Abst=Abst-1
     Arenacodes((Adr-Ptr)*5+4)=Abst
     GOTO Kampf2_5
   ENDIF
 ENDIF
 Zeile=Zeile+1
 IF Zeile>Anz_Lin(1) THEN
 CLS
 PRINT "pLabel nicht definiert in Zeile "; STR$(T-Adrzeiger(1,0));" Programm ";Prgname$(1)
 PRINT "Label : "+Label$(Programm(1,(T-Adrzeiger(1,0))*5+3)\10,1)+"q"
 Taste$= INPUT$(1)
 GOTO Hauptmenue
 ENDIF
 ENDIF
 GOTO Kampf2_3
-Kampf2_5
 NEXT T
 ENDIF
 Zeichne_Arena
-Start
 Adresse=Adrzeiger(Prog,Mom_Adr(Prog))*5
 Code=Arenacodes(Adresse)
 Zeichen1=Arenacodes(Adresse+1)
 Argumenta=Arenacodes(Adresse+2)
 Zeichen2=Arenacodes(Adresse+3)
 Argumentb=Arenacodes(Adresse+4)
 IF Einzel=-1 THEN
 BITBLT 0,0,640,400 TO Bild
 CLS
 PRINT "Programm : ";Prog
 PRINT "X-Koordinate : ";FN Xkoor(Adresse)
 PRINT "Y-Koordinate : ";FN Ykoor(Adresse)
 PRINT "Adresse : ";Adresse/5
 Anweisung(Code)
 PRINT "Befehl : ";Anweisung$
 PRINT "Argument A : ";
 IF Zeichen1=1 THEN PRINT "#";
 IF Zeichen1=2 THEN PRINT "<";
 IF Zeichen1=3 THEN PRINT ">";
 PRINT Argumenta
 PRINT "Argument B : ";
 IF Zeichen2=1 THEN PRINT "&";
 PRINT Argumentb
 PRINT "Unterprogramm Nummer : ";Mom_Adr(Prog)
 PRINT "Von : ";Anz_Adr(Prog)-1
 Taste$= INPUT$(1)
 BITBLT Bild TO 0,0,640,400
 ENDIF
 IF Code<1 OR Code>9 OR Arena(FN Xkoor(Adresse/5),FN Ykoor(Adresse/5))<>Prog+1 THEN
 Anz_Adr(Prog)=Anz_Adr(Prog)-1
 IF Anz_Adr(Prog)=0 THEN
 Winner= ABS(Prog-1)
 GOTO Ende
 ENDIF
 FOR T=Mom_Adr(Prog) TO Anz_Adr(Prog)
 Adrzeiger(Prog,T)=Adrzeiger(Prog,T+1)
 NEXT T
 Mom_Adr(Prog)=Mom_Adr(Prog)-1
 IF Mom_Adr(Prog)<0 THEN Mom_Adr(Prog)=0
 GOTO Start
 ENDIF
 ON Code GOTO C1,C2,C3,C4,C5,C6,C7,C8,C9
-C1
 IF Zeichen2=1 THEN
 Codes=Adresse+Argumentb*5+4
 IF Codes>3839*5 THEN Codes=Codes-3840*5
 IF Codes<0 THEN Codes=Codes+3840*5
 Ang_Adr2=Adresse+Arenacodes(Codes)*5
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN Ang_Adr2=Ang_Adr2+3840*5
 ELSE
 Ang_Adr2=Adresse+Argumentb*5
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN
 Ang_Adr2=Ang_Adr2+3840*5
 ENDIF
 ENDIF
 IF Zeichen1=1 THEN
 Wert=Argumenta
 ELSE
 Ang_Adr=Adresse+Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 ENDIF
 FOR T=0 TO 4
 IF Zeichen1=1 THEN
 Arenacodes(Ang_Adr2+T)=Wert
 ELSE
 Arenacodes(Ang_Adr2+T)=Arenacodes(Ang_Adr+T)
 ENDIF
 NEXT T
 PBOX 40+FN Xkoor(Ang_Adr2/5)*7+1,59+FN Ykoor(Ang_Adr2/5)*7+1,6,6
 Arena(FN Xkoor(Ang_Adr2/5),FN Ykoor(Ang_Adr2/5))=Prog+1
 GOTO Battleend
-C2
 IF Zeichen2=1 THEN
 Codes=Adresse+Argumentb*5+4
 IF Codes>3839*5 THEN Codes=Codes-3840*5
 IF Codes<0 THEN Codes=Codes+3840*5
 Ang_Adr2=Adresse+Arenacodes(Codes)*5
 ELSE
 Ang_Adr2=Adresse+Argumentb*5
 ENDIF
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN Ang_Adr2=Ang_Adr2+3840*5
 IF Zeichen1=1 THEN
 Wert=Argumenta
 ELSE
 Ang_Adr=Adresse+Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 Wert=Arenacodes(Ang_Adr+4)
 ENDIF
 Arenacodes(Ang_Adr2+4)=Arenacodes(Ang_Adr2+4)+Wert
 IF Arenacodes(Ang_Adr2+4)>3839 THEN Arenacodes(Ang_Adr2+4)=Arenacodes(Ang_Adr2+4)-2*3839
 GOTO Battleend
-C3
 IF Zeichen2=1 THEN
 Codes=Adresse+Argumentb*5+4
 IF Codes>3839*5 THEN Codes=Codes-3840*5
 IF Codes<0 THEN Codes=Codes+3840*5
 Ang_Adr2=Adresse+Arenacodes(Codes)*5
 ELSE
 Ang_Adr2=Adresse+Argumentb*5
 ENDIF
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN Ang_Adr2=Ang_Adr2+3840*5
 IF Zeichen1=1 THEN
 Wert=Argumenta
 ELSE
 Ang_Adr=Adresse+Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 Wert=Arenacodes(Ang_Adr+4)
 ENDIF
 Arenacodes(Ang_Adr2+4)=Arenacodes(Ang_Adr2+4)-Wert
 IF Arenacodes(Ang_Adr2+4)<-3839 THEN Arenacodes(Ang_Adr2+4)=Arenacodes(Ang_Adr2+4)+2*3839
 GOTO Battleend
-C4
 IF Zeichen1=1 THEN
 Ang_Adr=Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 ELSE
 Ang_Adr=Adresse+Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 ENDIF
 Adrzeiger(Prog,Mom_Adr(Prog))=Ang_Adr/5-1
 GOTO Battleend
-C5
 IF Zeichen1=1 THEN
 Ang_Adr=Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 ELSE
 Ang_Adr=Adresse+Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 ENDIF
 IF Zeichen2=1 THEN
 Codes=Adresse+Argumentb*5
 IF Codes>3839*5 THEN Codes=Codes-3840*5
 IF Codes<0 THEN Codes=Codes+3840*5
 Ang_Adr2= ABS(Adresse+Arenacodes(Codes)*5)
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN Ang_Adr2=Ang_Adr2+3840*5
 ELSE
 Ang_Adr2=Adresse+Argumentb*5
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN Ang_Adr2=Ang_Adr2+3840*5
 ENDIF
 IF Arenacodes(Ang_Adr2)=0 THEN Adrzeiger(Prog,Mom_Adr(Prog))=Ang_Adr/5-1
 GOTO Battleend
-C6
 IF Zeichen1=1 THEN
 Ang_Adr=Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 ELSE
 Ang_Adr=Adresse+Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 ENDIF
 IF Zeichen2=1 THEN
 Codes=Adresse+Argumentb*5
 IF Codes>3839*5 THEN Codes=Codes-3840*5
 IF Codes<0 THEN Codes=Codes+3840*5
 Ang_Adr2=Adresse+Arenacodes(Codes)*5
 ELSE
 Ang_Adr2=Adresse+Argumentb*5
 ENDIF
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN Ang_Adr2=Ang_Adr2+3840*5
 IF Arenacodes(Ang_Adr2)<>0 THEN Adrzeiger(Prog,Mom_Adr(Prog))=Ang_Adr/5-1
 GOTO Battleend
-C7
 IF Zeichen1=1 THEN
 Ang_Adr=Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 ELSE
 Ang_Adr=Adresse+Argumenta*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 ENDIF
 IF Zeichen2=1 THEN
 Codes=Adresse+Argumentb*5
 IF Codes>3839*5 THEN Codes=Codes-3840*5
 IF Codes<0 THEN Codes=Codes+3840*5
 Ang_Adr2=Adresse+Arenacodes(Codes+4)*5
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN Ang_Adr2=Ang_Adr2+3840*5
 ELSE
 Ang_Adr2=Adresse+Argumentb*5
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN Ang_Adr2=Ang_Adr2+3840*5
 ENDIF
 Arenacodes(Ang_Adr2+4)=Arenacodes(Ang_Adr2+4)-1
 IF Arenacodes(Ang_Adr2+4)<>0 THEN Adrzeiger(Prog,Mom_Adr(Prog))=Ang_Adr/5-1
 GOTO Battleend
-C8
 IF Zeichen1=1 THEN
 Wert=Argumenta
 ELSE
 Codes=Adresse+Argumenta*5
 IF Codes>3839*5 THEN Codes=Codes-3840*5
 IF Codes<0 THEN Codes=Codes+3840*5
 Ang_Adr=Adresse+Arenacodes(Codes)*5
 IF Ang_Adr>3839*5 THEN Ang_Adr=Ang_Adr-3840*5
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840*5
 Wert=Arenacodes(Ang_Adr+4)
 ENDIF
 IF Zeichen2=1 THEN
 Codes=Adresse+Argumentb*5
 IF Codes>3839*5 THEN Codes=Codes-3840*5
 IF Codes<0 THEN Codes=Codes+3840*5
 Ang_Adr2=Adresse+Arenacodes(Codes+4)*5
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN Ang_Adr2=Ang_Adr2+3840*5
 ELSE
 Ang_Adr2=Adresse+Argumentb*5
 IF Ang_Adr2>3839*5 THEN Ang_Adr2=Ang_Adr2-3840*5
 IF Ang_Adr2<0 THEN Ang_Adr2=Ang_Adr2+3840*5
 ENDIF
 Wert2=Arenacodes(Ang_Adr2+4)
 IF Wert<>Wert2 THEN Adrzeiger(Prog,Mom_Adr(Prog))=Adrzeiger(Prog,Mom_Adr(Prog))+1
 GOTO Battleend
-C9
 IF Zeichen1>0 THEN
 Codes=Adresse+Argumenta*5+4
 IF Codes>3839*5 THEN Codes=Codes-3840*5
 IF Codes<0 THEN Codes=Codes+3840*5
 Ang_Adr=Adresse/5+Arenacodes(Codes)-1
 IF Ang_Adr>3839 THEN Ang_Adr=Ang_Adr-3840
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840
 ELSE
 Ang_Adr=Adresse/5+Argumenta
 IF Ang_Adr>3839 THEN Ang_Adr=Ang_Adr-3840
 IF Ang_Adr<0 THEN Ang_Adr=Ang_Adr+3840
 ENDIF
 Anz_Adr(Prog)=Anz_Adr(Prog)+1
 Adrzeiger(Prog,Anz_Adr(Prog)-1)=Ang_Adr
 IF Zeichen1=2 THEN Arenacodes(Codes)=Arenacodes(Codes)-1
 IF Zeichen1=3 THEN Arenacodes(Codes)=Arenacodes(Codes)+1
 IF Arenacodes(Codes)<-3839 THEN Arenacodes(Codes)=Arenacodes(Codes)+2*3839
 IF Arenacodes(Codes)>3839 THEN Arenacodes(Codes)=Arenacodes(Codes)-2*3839
-Battleend
 IF Einzel=-1 THEN Taste$= INPUT$(1)
 Adrzeiger(Prog,Mom_Adr(Prog))=Adrzeiger(Prog,Mom_Adr(Prog))+1
 IF Adrzeiger(Prog,Mom_Adr(Prog))>3839 THEN
 Adrzeiger(Prog,Mom_Adr(Prog))=Adrzeiger(Prog,Mom_Adr(Prog))-3840
 ENDIF
 Mom_Adr(Prog)=Mom_Adr(Prog)+1
 IF Mom_Adr(Prog)+1>Anz_Adr(Prog) THEN Mom_Adr(Prog)=0
 Prog= ABS(Prog-1)
 IF Prog=0 THEN FILL STYLE =1,1
 IF Prog=1 THEN FILL STYLE =2,4
 WAIT Zeit!
 Taste$= INKEY$
 IF Taste$<>"" THEN GOTO Hauptmenue
 GOTO Start
-Ende
 PALETTE 0,$777
 WAIT 1/2
 PALETTE $777,0
 Taste$= INPUT$(1)
 CLS
 A$(1)="Ende des Kampfes"
 Zentriere(1)
 PRINT "B"*5
 A$(1)="Gewinner des Kampfes :"
 A$(2)="Programm"+ STR$(Winner)
 Zentriere(2)
 Spiel=0
 Taste$= INPUT$(1)
 GOTO Hauptmenue
