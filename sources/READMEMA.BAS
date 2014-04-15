 GOTO Anfang
 DEF PROC Zentriere(A)
 FOR T=1 TO A
 PRINT SPC(40- LEN(A$(T))/2);A$(T)
 NEXT T
 RETURN
-Anfang
 Path$="A:\READMEMA.KER\*.TXT"
 IPL 3+(1 SHL 31)
 ON ERROR GOTO Fehler
 DIM Text$(30000)
 CLS
 PRINT "f"
 A$(1)="Readme-Maker"
 A$(2)="B"*3
 A$(3)="by Michael Koch"
 A$(4)="B"*5
 A$(5)="<ESCAPE> zum speichern"
 A$(6)="<L> zum laden"
 Zentriere(6)
 Taste$= INPUT$(1)
 IF LOWER$(Taste$)="l" THEN
 CLS
 MOUSEON
 PRINT "f"
 FILESELECT (Path$,Name$,Button)
 MOUSEOFF
 IF Button=0 THEN GOTO Texteingabe
 IF Name$="" THEN GOTO Texteingabe
 Path2$= LEFT$(Path$, INSTR( LEN(Path$)-7,Path$,"\")-1)
 CHDIR Path2$
 OPEN "i",1,Name$
 Anz_Zeilen=0
 LINE INPUT #1,Text$(0)
 IF LEFT$(Text$(0),1)="û" THEN
 Verschluesselt=1
 ELSE
 Verschluesselt=0
 Anz_Zeilen=Anz_Zeilen+1
 Text$(1)=Text$(0)
 ENDIF
 WHILE NOT EOF(1)
 Anz_Zeilen=Anz_Zeilen+1
 LINE INPUT #1,Text$(Anz_Zeilen)
 WEND
 CLOSE 1
 CLS
 Anz=Anz_Zeilen
 IF Anz<25 THEN Anz=25
 FOR T=Anz-24 TO Anz
 PRINT Text$(T)
 NEXT T
 PRINT "A";Text$(Anz_Zeilen);
 Zeile=Anz_Zeilen
 PRINT "e";
 GOTO Abfrage
 ENDIF
-Texteingabe
 Zeile=1
 Anz_Zeilen=1
 FOR T=0 TO 9
 Speicherzeile(T)=1
 Speicherpos(T)=1
 NEXT T
 CLS
 PRINT "e";
-Abfrage
 REPEAT
 Taste$= INKEY$
 UNTIL Taste$<>""
 Taste= CVIL(Taste$) SHR 16 AND $FF
 Shift= CVIL(Taste$) SHR 24
 Taste$= CHR$( CVIL(Taste$) AND $FF)
 IF Taste=116 THEN
 PRINT CHR$(13);Text$(Zeile);
 GOTO Abfrage
 ENDIF
 IF Taste=115 THEN
 PRINT CHR$(13);Text$(Zeile); CHR$(13);
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=32 THEN
 OPEN "v24",1
 FOR T=1 TO Anz_Zeilen
 FOR S=1 TO LEN(Text$(T))
 IF MID$(Text$(T),S,1)="é" THEN
 PRINT #1,"[";
 GOTO Druckweiter
 ENDIF
 IF MID$(Text$(T),S,1)="ô" THEN
 PRINT #1,"\";
 GOTO Druckweiter
 ENDIF
 IF MID$(Text$(T),S,1)="ö" THEN
 PRINT #1,"]";
 GOTO Druckweiter
 ENDIF
 IF MID$(Text$(T),S,1)="Ñ" THEN
 PRINT #1,"{";
 GOTO Druckweiter
 ENDIF
 IF MID$(Text$(T),S,1)="î" THEN
 PRINT #1,"|";
 GOTO Druckweiter
 ENDIF
 IF MID$(Text$(T),S,1)="Å" THEN
 PRINT #1,"}";
 GOTO Druckweiter
 ENDIF
 IF MID$(Text$(T),S,1)="û" THEN
 PRINT #1,"~";
 GOTO Druckweiter
 ENDIF
 PRINT #1, MID$(Text$(T),S,1);
-Druckweiter
 NEXT S
 PRINT #1
 NEXT T
 PRINT #1
 CLOSE 1
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=18 THEN
 Stelle= POS(0)
 CLS
 IF Verschluesselt<>1 THEN
 PRINT "f";
 PRINT "pText nicht verschlÅsseltq"
 Entschluessel$= INPUT$(1)
 GOTO Entschluessel2
 ENDIF
 INPUT "Codewort ? ";Inputcode$
 PRINT "f";
 Code$= RIGHT$(Text$(0), LEN(Text$(0))-1)
 FOR T=1 TO LEN(Code$)
 Zahl= ASC( MID$(Code$,T,1))
 Zahl=Zahl-2
 IF T>1 THEN
 Code2$= LEFT$(Code$,T-1)
 ELSE
 Code2$=""
 ENDIF
 IF T< LEN(Code$) THEN
 Code3$= RIGHT$(Code$, LEN(Code$)-T)
 ELSE
 Code3$=""
 ENDIF
 Code$=Code2$+ CHR$(Zahl)+Code3$
 NEXT T
 IF Code$<>Inputcode$ THEN
 Code$=""
 PRINT "pFalsches Codewortq"
 Entschluessel$= INPUT$(1)
 GOTO Entschluessel2
 ENDIF
 Verschluesselt=0
 Text$(0)=""
 FOR S=1 TO Anz_Zeilen
 FOR T=1 TO LEN(Text$(S))
 Zahl= ASC( MID$(Text$(S),T,1))
 Zahl=Zahl-2
 IF T>1 THEN
 Code2$= LEFT$(Text$(S),T-1)
 ELSE
 Code2$=""
 ENDIF
 IF T< LEN(Text$(S)) THEN
 Code3$= RIGHT$(Text$(S), LEN(Text$(S))-T)
 ELSE
 Code3$=""
 ENDIF
 Text$(S)=Code2$+ CHR$(Zahl)+Code3$
 NEXT T
 NEXT S
-Entschluessel2
 PRINT "e";
 CLS
 FOR T=Zeile TO Zeile+22
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile+23);"H"; SPC(Stelle);
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=47 THEN
 Stelle= POS(0)
 CLS
 INPUT "Codewort ? ";Code$
 PRINT "f";
 Verschluesselt=1
 FOR T=1 TO LEN(Code$)
 Zahl= ASC( MID$(Code$,T,1))
 Zahl=Zahl+2
 IF T>1 THEN
 Code2$= LEFT$(Code$,T-1)
 ELSE
 Code2$=""
 ENDIF
 IF T< LEN(Code$) THEN
 Code3$= RIGHT$(Code$, LEN(Code$)-T)
 ELSE
 Code3$=""
 ENDIF
 Code$=Code2$+ CHR$(Zahl)+Code3$
 NEXT T
 Text$(0)="û"+Code$
 FOR S=1 TO Anz_Zeilen
 FOR T=1 TO LEN(Text$(S))
 Zahl= ASC( MID$(Text$(S),T,1))
 Zahl=Zahl+2
 IF T>1 THEN
 Code2$= LEFT$(Text$(S),T-1)
 ELSE
 Code2$=""
 ENDIF
 IF T< LEN(Text$(S)) THEN
 Code3$= RIGHT$(Text$(S), LEN(Text$(S))-T)
 ELSE
 Code3$=""
 ENDIF
 Text$(S)=Code2$+ CHR$(Zahl)+Code3$
 NEXT T
 NEXT S
 PRINT "e";
 CLS
 FOR T=Zeile TO Zeile+22
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile+23);"H"; SPC(Stelle);
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=35 THEN
 Stelle= POS(0)
 CLS
 PRINT "f";
 A$(1)="Hilfe"
 Zentriere(1)
 PRINT "B"*2
 PRINT "<ESC>:Speichert den Text,der im Speicher steht"
 PRINT "<HOME>:Springt zur  linken oberen Bildschirmecke"
 PRINT "<CTRL>+<DEL>:Lîscht den Rest der Zeile"
 PRINT "<CTRL>+<CSR-RECHTS>:Bewegt den Cursor zum Ende der Zeile"
 PRINT "<CTRL>+<CSR-LINKS>:Bewegt den Cursor zum Anfang der Zeile"
 PRINT "<CTRL>+<CSR-HOCH>:Springt zum Anfang des Textes"
 PRINT "<CTRL>+<CSR-RUNTER>:Springt zum Ende des Textes"
 PRINT "<CTRL>+<L>:LÑd einen Text"
 PRINT "<CTRL>+<J>:Springt zu einer Textzeile"
 PRINT "<CTRL>+<F>:Sucht einen String"
 PRINT "<CTRL>+<F>+<+>:Sucht den selben String noch einmal"
 PRINT "<CTRL>+<K>:Kopiert Zeilen"
 PRINT "<CTRL>+<Z>:Zeigt die Zeilennummern"
 PRINT "<CTRL>+<J>:Springt zu einer Textzeile"
 PRINT "<CTRL>+<M>:Setzt eine Markierung"
 PRINT "<CTRL>+<G>:Springt zu einer Markierung"
 PRINT "<CTRL>+<X>:Lîscht den Textspeicher"
 PRINT "<CTRL>+<D>:Druckt den Text"
 PRINT "<CTRL>+<V>:VerschlÅsselt den Text"
 PRINT "<CTRL>+<E>:EntschlÅsselt den Text"
 A$= INPUT$(1)
 PRINT "e";
 CLS
 FOR T=Zeile TO Zeile+22
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile+23);"H"; SPC(Stelle);
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=36 THEN
-Zeilefrage
 PRINT "HK";
 INPUT "In welche Zeile soll gesprungen werden ? ";Jmpzeile
 IF Jmpzeile<1 OR Jmpzeile>Anz_Zeilen THEN GOTO Zeilefrage
 Zeile=Jmpzeile
 CLS
 FOR T=Zeile TO Zeile+23
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile+24);"H";
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=18 THEN
 IF Erase=1 THEN
 IF Erasezeile>Zeile THEN
 Erase=0
 GOTO Abfrage
 ENDIF
 FOR T=Erasezeile TO Anz_Zeilen-(Zeile-Erasezeile)
 Text$(T)=Text$(T+Zeile-Erasezeile)
 NEXT T
 FOR T=Anz_Zeilen-(Zeile-Erasezeile)+1 TO Anz_Zeilen
 Text$(T)=""
 NEXT T
 Anz_Zeilen=Anz_Zeilen-(Zeile-Erasezeile)
 Zeile=Erasezeile
 CLS
 FOR T=Erasezeile TO Erasezeile+23
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile+24);"H";
 Erase=0
 GOTO Abfrage
 ENDIF
 Erase=1
 Erasezeile=Zeile
 GOTO Abfrage
 ENDIF
 IF Shift=8 AND Taste=18 THEN
 Erase=0
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=37 THEN
 IF Kopy=0 THEN
 Kopyzeile1=Zeile
 Kopy=1
 GOTO Abfrage
 ENDIF
 IF Kopy=1 THEN
 Kopyzeile2=Zeile
 Kopy=2
 GOTO Abfrage
 ENDIF
 IF Kopyzeile1>Kopyzeile2 THEN
 Kopy=0
 GOTO Abfrage
 ENDIF
 FOR T=Anz_Zeilen TO Zeile STEP -1
 Text$(T+Kopyzeile2-Kopyzeile1)=Text$(T)
 NEXT T
 Anz_Zeilen=Anz_Zeilen+Kopyzeile2-Kopyzeile1
 FOR T=Kopyzeile1 TO Kopyzeile2
 Text$(Zeile+T-Kopyzeile1)=Text$(T)
 NEXT T
 Kopy=0
 CLS
 FOR T=Zeile TO Zeile+23
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile+24);"H";
 GOTO Abfrage
 ENDIF
 IF Shift=8 AND Taste=37 THEN
 Kopy=0
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=33 THEN
 Stelle= CSRLIN
 Stelle2= POS(0)
 PRINT "HK";
 INPUT "Wonach suchen ? ";Such$
 IF Such$="" THEN
 PRINT "A"; CHR$(13);"K";Text$(Zeile-Stelle); CHR$(13);
 PRINT "B"*(Stelle-1); TAB (Stelle2);
 GOTO Abfrage
 ENDIF
 IF Such$="+" THEN
 Such$=Suchspeicher$
 ELSE
 Suchspeicher$=Such$
 ENDIF
 CLS
 Zeile2=Zeile+1
-Suchen
 Stelle= INSTR(Text$(Zeile2),Such$)
 IF Stelle=0 THEN
 Zeile2=Zeile2+1
 IF Zeile2>Anz_Zeilen THEN
 PRINT CHR$(7);
 FOR T=Zeile TO Zeile+23
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile+24);"H"; TAB (Stelle2);
 GOTO Abfrage
 ENDIF
 GOTO Suchen
 ENDIF
 Zeile=Zeile2
 FOR T=Zeile TO Zeile+23
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile+24);"H"; TAB (Stelle-1);
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=45 THEN
 CLS
 PRINT "f";
 MOUSEON
 FORM_ALERT (1,"[2][Wirklich den|Textspeicher|Lîschen ?][JA|ZURöCK]",Button)
 MOUSEOFF
 PRINT "e";
 IF Button=2 THEN
 CLS
 Anz=Anz_Zeilen
 IF Anz<25 THEN Anz=25
 FOR T=Anz-24 TO Anz
 PRINT Text$(T)
 NEXT T
 PRINT "A";Text$(Anz_Zeilen);
 Zeile=Anz_Zeilen
 PRINT "e";
 GOTO Abfrage
 ENDIF
 CLEAR
 DIM Text$(30000)
 GOTO Texteingabe
 ENDIF
 IF Shift=4 AND Taste=72 THEN
 Zeile=1
 CLS
 FOR T=1 TO 24
 PRINT Text$(T)
 NEXT T
 PRINT Text$(25);"H";
 ENDIF
 IF Shift=4 AND Taste=80 THEN
 Zeile=Anz_Zeilen
 CLS
 IF Zeile<=25 THEN
 FOR T=1 TO Anz_Zeilen-1
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile);
 GOTO Abfrage
 ENDIF
 FOR T=Zeile-24 TO Zeile-1
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile);
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=46 THEN
 CLS
 PRINT "f"
 MOUSEON
 FORM_ALERT (1,"[2][|Ende ?][Ja|Nein]",Button)
 MOUSEOFF
 CLS
 PRINT "e";
 IF Button=2 THEN
 GOSUB Laden_Ende
 GOTO Abfrage
 ENDIF
 IPL 3
 ON ERROR GOTO 0
 END
 ENDIF
 IF Shift=4 AND Taste=38 THEN
 GOSUB Laden
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=21 THEN
 Stelle= POS(0)
 Stelle2= CSRLIN
 CLS
 FOR T=Zeile-Stelle2+1 TO Zeile+(23-Stelle2)+1
 IF LEN(Text$(T))>78- LEN( STR$(T)) THEN
 PRINT T;" "; LEFT$(Text$(T), LEN(Text$(T))- LEN( STR$(T))-1)
 ELSE
 PRINT T;" ";Text$(T)
 ENDIF
 NEXT T
 IF LEN(Text$(Zeile+(24-Stelle2)))>78- LEN( STR$(T)) THEN
 PRINT T;" "; LEFT$(Text$(Zeile+(24-Stelle2)), LEN(Text$(Zeile+(24-Stelle2)))- LEN( STR$(T))-1);
 ELSE
 PRINT T;" ";Text$(Zeile+(25-Stelle2));
 ENDIF
 PRINT "f";
 Taste$= INPUT$(1)
 PRINT "e"
 CLS
 FOR T=Zeile-Stelle2+1 TO Zeile+(23-Stelle2)+1
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Zeile+(25+Stelle2));"H";
 PRINT "B"*(Stelle2-2)
 PRINT TAB (Stelle);
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=50 THEN
 Stelle= POS(0)
 Stelle2= CSRLIN
-Markfrage
 PRINT "H";"K";
 INPUT "Welche Markierung soll gesetzt werden ? ";Mark
 IF Mark<0 OR Mark>10 THEN GOTO Markfrage
 PRINT "H";"K";"H";Text$(Zeile-Stelle2+1)
 PRINT "B"*(Stelle2-2);Text$(Zeile); CHR$(13); TAB (Stelle);
 Speicherzeile(Mark)=Zeile
 Speicherpos(Mark)= POS(0)
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=34 THEN
-Markfrage2
 PRINT "H";"K";
 INPUT "Zu welcher Markierung soll gesprungen werden ? ";Mark
 IF Mark<1 OR Mark>10 THEN GOTO Markfrage2
 CLS
 FOR T=Speicherzeile(Mark) TO Speicherzeile(Mark)+23
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Speicherzeile(Mark)+24);"H";
 PRINT TAB (Speicherpos(Mark));
 Zeile=Speicherzeile(Mark)
 GOTO Abfrage
 ENDIF
 IF Taste=71 THEN
 Zeile=Zeile- CSRLIN +1
 PRINT "H";
 GOTO Abfrage
 ENDIF
 IF Shift=4 AND Taste=83 THEN
 PRINT "K";
 Text$(Zeile)= LEFT$(Text$(Zeile), POS(0))
 GOTO Abfrage
 ENDIF
 IF Taste=15 THEN
 Stelle= POS(0)
 IF Stelle>71 THEN GOTO Abfrage
 IF Stelle+9> LEN(Text$(Zeile)) THEN
 PRINT CHR$(13);Text$(Zeile);
 GOTO Abfrage
 ENDIF
 PRINT CHR$(9);
 GOTO Abfrage
 ENDIF
 IF Taste=14 THEN
 Stelle= POS(0)
 IF Stelle=0 THEN
 Zeile=Zeile-1
 PRINT "A";Text$(Zeile);
 GOTO Abfrage
 ENDIF
 IF Stelle= LEN(Text$(Zeile)) THEN
 Text$(Zeile)= LEFT$(Text$(Zeile), LEN(Text$(Zeile))-1)
 PRINT CHR$(13);Text$(Zeile);" ";"D";
 GOTO Abfrage
 ENDIF
 IF Stelle=1 THEN
 Text$(Zeile)= RIGHT$(Text$(Zeile), LEN(Text$(Zeile))-1)
 PRINT CHR$(13);Text$(Zeile);" "; CHR$(13);
 GOTO Abfrage
 ENDIF
 Text$(Zeile)= LEFT$(Text$(Zeile),Stelle-1)+ RIGHT$(Text$(Zeile), LEN(Text$(Zeile))-Stelle)
 PRINT CHR$(13);Text$(Zeile);" "; CHR$(13); TAB (Stelle-1);
 GOTO Abfrage
 ENDIF
 IF Taste=1 THEN
 GOSUB Speichern
 GOTO Abfrage
-Speichern
 CLS
 MOUSEON
 PRINT "f"
 FILESELECT (Path$,Name$,Button)
 Path2$= LEFT$(Path$, INSTR( LEN(Path$)-7,Path$,"\")-1)
 CHDIR Path2$
 MOUSEOFF
 IF Button=0 THEN
 CLS
 Anz=Anz_Zeilen
 IF Anz<25 THEN Anz=25
 FOR T=Anz-24 TO Anz
 PRINT Text$(T)
 NEXT T
 PRINT "A";Text$(Anz_Zeilen);
 Zeile=Anz_Zeilen
 PRINT "e";
 RETURN
 ENDIF
 IF Name$="" THEN
 CLS
 Anz=Anz_Zeilen
 IF Anz<25 THEN
 FOR T=1 TO Anz-1
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Anz);
 Zeile=Anz
 RETURN
 ENDIF
 Anz=Anz_Zeilen-1
 FOR T=Anz-24 TO Anz
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Anz_Zeilen);
 Zeile=Anz_Zeilen
 PRINT "e";
 RETURN
 ENDIF
 OPEN "o",1,Name$
 IF Verschluesselt=1 THEN PRINT #1,Text$(0)
 FOR T=1 TO Anz_Zeilen
 PRINT #1,Text$(T)
 NEXT T
 CLOSE 1
 CLS
 IF Anz_Zeilen>23 THEN
 Anz=Anz_Zeilen-23
 ELSE
 Anz=1
 ENDIF
 FOR T=Anz TO Anz_Zeilen-1
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Anz_Zeilen);
 Zeile=Anz_Zeilen
 PRINT "e";
 RETURN
 ENDIF
 IF Taste=28 THEN
 PRINT
 PRINT "L";
 Zeile=Zeile+1
 Anz_Zeilen=Anz_Zeilen+1
 FOR T=Anz_Zeilen TO Zeile+1 STEP -1
 Text$(T)=Text$(T-1)
 NEXT T
 Text$(Zeile)=""
 GOTO Abfrage
 ENDIF
 IF Taste=75 THEN
 Stelle= POS(0)
 IF Stelle=0 THEN GOTO Abfrage
 PRINT "D";
 GOTO Abfrage
 ENDIF
 IF Taste=77 THEN
 Stelle= POS(0)
 IF Stelle=79 THEN GOTO Abfrage
 PRINT "C";
 IF Stelle= LEN(Text$(Zeile)) THEN
 Text$(Zeile)=Text$(Zeile)+" "
 ENDIF
 GOTO Abfrage
 ENDIF
 IF Taste=83 THEN
 Stelle= POS(0)
 Stelle2= CSRLIN
 IF Text$(Zeile)="" THEN
 FOR T=Zeile+1 TO Anz_Zeilen
 Text$(T-1)=Text$(T)
 NEXT T
 Text$(Anz_Zeilen)=""
 IF Zeile<Anz_Zeilen THEN
 Anz_Zeilen=Anz_Zeilen-1
 ENDIF
 PRINT "M";"j";"B"*(25-Stelle2);
 PRINT Text$(Zeile+25-Stelle2);"k";
 GOTO Abfrage
 ENDIF
 IF Stelle=0 THEN
 Text$(Zeile)= RIGHT$(Text$(Zeile), LEN(Text$(Zeile))-1)
 PRINT CHR$(13);Text$(Zeile);" "; CHR$(13);
 GOTO Abfrage
 ENDIF
 IF Stelle= LEN(Text$(Zeile)) THEN GOTO Abfrage
 IF Stelle+1= LEN(Text$(Zeile)) THEN
 Text$(Zeile)= LEFT$(Text$(Zeile),Stelle)
 PRINT CHR$(13);Text$(Zeile);" ";"D";
 GOTO Abfrage
 ENDIF
 Text$(Zeile)= LEFT$(Text$(Zeile),Stelle)+ RIGHT$(Text$(Zeile), LEN(Text$(Zeile))-Stelle-1)
 PRINT CHR$(13);Text$(Zeile);" "; CHR$(13); TAB (Stelle);
 GOTO Abfrage
 ENDIF
 IF Taste=80 THEN
 IF Zeile=Anz_Zeilen THEN GOTO Abfrage
 Stelle= POS(0)
 PRINT
 Zeile=Zeile+1
 PRINT Text$(Zeile); CHR$(13); TAB (Stelle);
 IF Stelle> LEN(Text$(Zeile)) THEN
 Text$(Zeile)=Text$(Zeile)+" "*(Stelle- LEN(Text$(Zeile)))
 PRINT CHR$(13);Text$(Zeile);
 ENDIF
 GOTO Abfrage
 ENDIF
 IF Taste=72 THEN
 IF Zeile=1 THEN GOTO Abfrage
 Stelle= POS(0)
 Zeile=Zeile-1
 PRINT "I"; CHR$(13);Text$(Zeile); CHR$(13); TAB (Stelle);
 IF Stelle> LEN(Text$(Zeile)) THEN
 Text$(Zeile)=Text$(Zeile)+" "*(Stelle- LEN(Text$(Zeile)))
 PRINT CHR$(13);Text$(Zeile);
 ENDIF
 GOTO Abfrage
 ENDIF
 IF LEN(Text$(Zeile))=79 THEN
 Stelle= POS(0)
 FOR T=79 TO 1 STEP -1
 IF MID$(Text$(Zeile),T,1)=" " THEN
 IF LEN(Text$(Zeile+1))+ LEN( RIGHT$(Text$(Zeile-1),79-T))+1<80 THEN
 Text$(Zeile+1)= RIGHT$(Text$(Zeile),79-T)+" "+Text$(Zeile+1)
 Laenge= LEN( RIGHT$(Text$(Zeile),79-T))
 Text$(Zeile)= LEFT$(Text$(Zeile),T-1)
 PRINT CHR$(13);Text$(Zeile);"K"
 Zeile=Zeile+1
 IF Zeile>Anz_Zeilen THEN Anz_Zeilen=Anz_Zeilen+1
 PRINT Text$(Zeile); CHR$(13); TAB (Laenge);
 IF Stelle<79 THEN
 PRINT "A"; CHR$(13); TAB (Stelle);
 ENDIF
 GOTO Einfuegen
 ENDIF
 Zeile=Zeile+1
 Anz_Zeilen=Anz_Zeilen+1
 FOR X=Anz_Zeilen TO Zeile+1 STEP -1
 Text$(X)=Text$(X-1)
 NEXT X
 Text$(Zeile)= RIGHT$(Text$(Zeile-1),79-T)
 Text$(Zeile-1)= LEFT$(Text$(Zeile-1),T-1)
 PRINT CHR$(13);Text$(Zeile-1);"K"; CHR$(10);"L";Text$(Zeile);
 IF Stelle<79 THEN
 PRINT "A"; CHR$(13); TAB (Stelle);
 Zeile=Zeile-1
 ENDIF
 EXIT TO Einfuegen
 ENDIF
 NEXT T
 GOTO Abfrage
 ENDIF
-Einfuegen
 Stelle= POS(0)
 IF Stelle=0 THEN
 Text$(Zeile)=Taste$+Text$(Zeile)
 ENDIF
 IF Stelle= LEN(Text$(Zeile)) THEN
 Text$(Zeile)=Text$(Zeile)+Taste$
 Stelle=Stelle+1
 ENDIF
 IF Stelle>0 AND Stelle< LEN(Text$(Zeile)) THEN
 Text$(Zeile)= LEFT$(Text$(Zeile),Stelle)+Taste$+ RIGHT$(Text$(Zeile), LEN(Text$(Zeile))-Stelle)
 ENDIF
 IF Stelle= LEN(Text$(Zeile)) OR Stelle=79 THEN Stelle=Stelle-1
 PRINT CHR$(13);Text$(Zeile); CHR$(13); TAB (Stelle+1);
 GOTO Abfrage
-Laden
 CLS
 MOUSEON
 PRINT "f"
 FILESELECT (Path$,Name$,Button)
 Path2$= LEFT$(Path$, INSTR( LEN(Path$)-7,Path$,"\")-1)
 CHDIR Path2$
 MOUSEOFF
 IF Button=0 THEN GOTO Laden_Ende
 IF Name$="" THEN GOTO Laden_Ende
 Path2$= LEFT$(Path$, INSTR( LEN(Path$)-7,Path$,"\")-1)
 CHDIR Path2$
 OPEN "i",1,Name$
 Anz_Zeilen=0
 LINE INPUT #1,Text$(0)
 IF LEFT$(Text$(0),1)="û" THEN
 Verschluesselt=1
 ELSE
 Verschluesselt=0
 Anz_Zeilen=Anz_Zeilen+1
 Text$(1)=Text$(0)
 ENDIF
 WHILE NOT EOF(1)
 Anz_Zeilen=Anz_Zeilen+1
 LINE INPUT #1,Text$(Anz_Zeilen)
 WEND
 CLOSE 1
-Laden_Ende
 CLS
 Anz=Anz_Zeilen
 IF Anz<25 THEN
 FOR T=1 TO Anz-1
 PRINT Text$(T)
 NEXT T
 PRINT Text$(Anz);
 Zeile=Anz
 RETURN
 ENDIF
 FOR T=Anz-24 TO Anz
 PRINT Text$(T)
 NEXT T
 PRINT "A";Text$(Anz_Zeilen);
 Zeile=Anz_Zeilen
 PRINT "e";
 RETURN
-Fehler
 CLS
 PRINT ERR$ ;" in "; ERL
 MOUSEON
 FORM_ALERT (1,"[0][Retten was zu|retten ist ?][Ja|Nein]",Button)
 IF Button=2 THEN RUN
 GOSUB Speichern
 RUN
