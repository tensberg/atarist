 CLS
 PRINT "f";
 Bild= MEMORY(32256)
 A$(1)="POSTER"
 Zentriere(1)
 Name$=""
 Path$="A:\*.PI3"
 MOUSEON
 FILESELECT (Path$,Name$,Flag)
 MOUSEOFF
 IF Name$="" OR Flag=0 THEN END
 CHDIR LEFT$(Path$, LEN(Path$)- INSTR( MIRROR$(Path$),"\"))
 BLOAD Name$
 BITBLT 0,0,640,400 TO Bild
 Taste$= INPUT$(1)
 CLS
 A$(1)="POSTER"
 Zentriere(1)
 PRINT "B"*4
 PRINT "e";
 PRINT "Ein Orginal-Pixel entspricht :      neuen Pixels in X-Richtung"
 INPUT @(7,31);"A ";Pixelx
 PRINT "Ein Orginal-Pixel entspricht :      neuen Pixels in Y-Richtung"
 INPUT @(8,31);"A ";Pixely
 PRINT "f";
 Adresse=Bild+6
 FILL COLOR =1
 FILL STYLE =1,1
 FOR X=0 TO Pixelx-1
 FOR Y=0 TO Pixely-1
 Padr=Adresse+X*(80\Pixelx)+Y*(32000\Pixely)
 CLS
 LINE COLOR =1
 IF Y=0 THEN DRAW 0,0 TO 639,0
 IF Y=Pixely-1 THEN DRAW 0,399 TO 639,399
 DRAW 0,0 TO 0,399
 DRAW 639,0 TO 639,399
 FOR Y2=0 TO 399 STEP Pixely
 FOR X2=0 TO 639 STEP Pixelx
 X3=X2\Pixelx
 IF X2 MOD 8=0 THEN Padr2=Padr+X3\8+(Y2\Pixely)*80:Byte= PEEK(Padr2)
 Farbe= BIT(7-(X3-(X3\8)*8),Byte)
 LINE COLOR = ABS(Farbe)
 FILL COLOR = ABS(Farbe)
 IF Farbe=-1 THEN PBOX X2,Y2,Pixelx,Pixely
 NEXT X2
 NEXT Y2
 HCOPY
 NEXT Y
 NEXT X
 END
 END
-Programmende
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
