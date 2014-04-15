 GOTO Anfang
 DEF FN Iteration%F(Cx!,Cy!)
   X!=0:Y!=0:Xq!=0:Yq!=0:T=0
   FOR Iter=0 TO Su
     Y!=2*X!*Y!-Cy!
     X!=Xq!-Yq!-Cx!
     Xq!=X!*X!:Yq!=Y!*Y!
     IF Xq!+Yq!>4 THEN
       T=Iter+1
       EXIT
     ENDIF
   NEXT Iter
   IF T=0 THEN
     RETURN Wahr=Wahr
   ELSE
     RETURN Wahr<>Wahr
   ENDIF
 DEF FN Punkt_Vorn%F
   IF FN Iteration%F(Cx!+Stx*Sx!,Cy!+Sty*Sy!) THEN
     Wert=1
   ELSE
     Wert=0
   ENDIF
 RETURN (Wert=1)
 DEF FN Punkt_Links%F
   Drehe_Links
   Schritt_Vor
   IF FN Iteration%F(Cx!,Cy!) THEN
     Wert=1
   ELSE
     Wert=0
   ENDIF
   Drehe_Um
   Schritt_Vor
   Drehe_Links
 RETURN (Wert=1)
 DEF FN Punkt_Rechts%F
   Drehe_Rechts
   Schritt_Vor
   IF FN Iteration%F(Cx!,Cy!) THEN
     Wert=1
   ELSE
     Wert=0
   ENDIF
   Drehe_Um
   Schritt_Vor
   Drehe_Rechts
 RETURN (Wert=1)
 DEF PROC Suche_Anfang
   WHILE NOT FN Iteration%F(Cx!,Cy!)
     Cy!=Cy!+Sy!
     Ypos=Ypos+1
   WEND
 RETURN
 DEF PROC Zeichne_Rand
   WHILE NOT (Ypos=400 OR Xpos=640)
   Testbit=FN Punkt_Vorn%F
     IF Testbit THEN
       DRAW Xpos,Ypos
       Schritt_Vor
     ENDIF
     IF FN Punkt_Links%F THEN
       Drehe_Links
     ELSE
       Testbit2=FN Punkt_Rechts%F
       IF Testbit2 AND NOT Testbit THEN
         Drehe_Rechts
       ELSE
         IF NOT Testbit2 AND NOT Testbit THEN
           Drehe_Um
         ENDIF
       ENDIF
     ENDIF
   WEND
 RETURN
 DEF PROC Schritt_Vor
   Xpos=Xpos+Stx
   Ypos=Ypos+Sty
   Cx!=Cx!+Sx!*Stx
   Cy!=Cy!+Sy!*Sty
 RETURN
 DEF PROC Drehe_Links
   Richtung=Richtung+1
   IF Richtung=5 THEN Richtung=1
   IF Richtung=1 THEN Stx=1:Sty=0
   IF Richtung=2 THEN Stx=0:Sty=-1
   IF Richtung=3 THEN Stx=-1:Sty=0
   IF Richtung=4 THEN Stx=0:Sty=1
 RETURN
 DEF PROC Drehe_Rechts
   Richtung=Richtung-1
   IF Richtung=0 THEN Richtung=4
   IF Richtung=1 THEN Stx=1:Sty=0
   IF Richtung=2 THEN Stx=0:Sty=-1
   IF Richtung=3 THEN Stx=-1:Sty=0
   IF Richtung=4 THEN Stx=0:Sty=1
 RETURN
 DEF PROC Drehe_Um
   Drehe_Links
   Drehe_Links
 RETURN
-Anfang
 Xl!=.1228125
 Xr!=.354375
 Yo!=-1.116
 Yu!=-.66
 Sx!=(Xr!-Xl!)/640
 Sy!=(Yu!-Yo!)/400
 Xpos=0
 Ypos=0
 Richtung=1
 Stx=1
 Sty=0
 CLS
 INPUT "Suchtiefe : ";Su
 PRINT "f";
 CLS
 Cx!=Xl!
 Cy!=Yo!
 Xpos=0
 Ypos=0
 Richtung=1
 Stx=1
 Sty=0
 Suche_Anfang
 Zeichne_Rand
 Taste$= INPUT$(1)
 END
