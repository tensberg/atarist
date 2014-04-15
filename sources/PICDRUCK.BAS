 CLS
 PRINT "f";
 MOUSEON
 Path$="A:*.*"
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 IF Name$="" OR Flag=0 THEN END
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))
 BLOAD Name$
 Bildadresse= LPEEK($44E)
 OPEN "P",1
 PRINT #1, CHR$(27)+"3"+ CHR$(24);
 FOR Y1=0 TO 399 STEP 24
 PRINT #1, CHR$(27)+"*"+ CHR$(39)+ CHR$(128)+ CHR$(2);
 FOR X=0 TO 639
 FOR Y3=0 TO 16 STEP 8
 Adresse2=Bildadresse+Y1*80+Y3*80+ INT(X/8)
 Bit$=""
 FOR Y2=0 TO 7
 Bitnr$= STR$( BIT(7-(X- INT(X/8)*8), PEEK(Adresse2+Y2*80)))
 Bit$=Bit$+ RIGHT$(Bitnr$,1)
 NEXT Y2
 Bit$="%"+Bit$
 PRINT #1, CHR$( VAL(Bit$));
 NEXT Y3
 NEXT X
 PRINT #1, CHR$(10)+ CHR$(13);
 NEXT Y1
 PRINT #1, CHR$(10)+ CHR$(13);
 CLOSE 1
 RUN
