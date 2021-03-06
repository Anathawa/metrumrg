$PROB 7 phase1 2 CMT like 1004 but diff. initial on V3
$INPUT C ID TIME SEQ=DROP EVID AMT DV SUBJ HOUR HEIGHT WT SEX AGE DOSE FED
$DATA ../../data/derived/phase1.csv IGNORE=C
$SUBROUTINE ADVAN4 TRANS4
$PK
 CL=THETA(1)*EXP(ETA(1)) * THETA(6)**SEX * (WT/70)**THETA(7)
 V2 =THETA(2)*EXP(ETA(2))
 KA=THETA(3)*EXP(ETA(3))
 Q  =THETA(4)
 V3=THETA(5)
 S2=V2
 
$ERROR
 Y=F*(1+ERR(1)) + ERR(2)
 IPRE=F
;
$THETA 8.495
23.5
0.07476
4.147
78.29
1.061
1.906
$OMEGA 0.2221
0.1444
0.09957
$SIGMA 0.0616
$SIMULATION ( 8002 NEW) ( 9003 UNIFORM) ONLYSIMULATION
$TABLE ID TIME DV WT SEX LDOS NOPRINT NOAPPEND FILE=sim.tab
