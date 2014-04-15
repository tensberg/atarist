 CLS
 RAD
 PRINT "f";
 A=320:B=320
 FOR X=0 TO -100 STEP -1
 C!=-60
 D=5* INT( SQR(10000-X!*X!)/5)
 FOR Y=D TO -D STEP -5
 E!=(25+FN A!( SQR(X*X+Y*Y))-.6*Y)*2
 IF E!>C! THEN C!=E!: DRAW A+X*2,B-E!: DRAW A-X*2,B-E!: DRAW A+X*2+1,B-E!: DRAW A-X*2+1,B-E!
 NEXT Y
 NEXT X
 END
 DEF FN A!(E!)=60* SIN(E!/30)+10
