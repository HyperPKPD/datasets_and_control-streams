;; ============================================================================
;; Run         : run101
;; Purpose     : Base population PK model without covariate effects: the starting
;;               model of the covariate analysis (nlmx cov -c nlmx.covar).
;; Model       : 2-compartment oral (first-order absorption) with lag time, $DES (ADVAN13); combined proportional + additive residual error
;; Data        : ../data/analysis.csv - 72 subject(s) in 6 group(s), simulated by nlmx
;; Author      : Tobias Diallo
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM run101 base model - 2-compartment oral (first-order absorption) with lag time, $DES (ADVAN13)

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA ../data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN13 TOL=6                  ; general nonlinear model (ODEs in $DES)

$MODEL COMP=(DEPOT,DEFDOSE) COMP=(CENTRAL,DEFOBS) COMP=(PERIPH)

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
MU_1 = LOG(THETA(1))                        ; log typical CL
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2))                        ; log typical V
V = EXP(MU_2 + ETA(2))                      ; individual central volume of distribution (L)
Q = THETA(3)                                ; intercompartmental clearance (L/h), no IIV
VP = THETA(4)                               ; peripheral volume of distribution (L), no IIV
KA = THETA(5)                               ; first-order absorption rate constant (1/h), no IIV
ALAG1 = THETA(6)                            ; absorption lag time (h), no IIV

$DES
; amounts: A(1) depot, A(2) central, A(3) peripheral
DADT(1) = -KA*A(1)                          ; absorption from the depot
DADT(2) = KA*A(1) - CL/V*A(2) - Q/V*A(2) + Q/VP*A(3)  ; central: input - elimination - distribution
DADT(3) = Q/V*A(2) - Q/VP*A(3)              ; peripheral

$ERROR
; combined proportional + additive residual error
IPRED = A(2)/V                              ; individual prediction (mg/L)
W = SQRT(THETA(7)**2*IPRED**2 + THETA(8)**2)  ; SD of the residual error
IF (W.LE.0) W = 1E-6                        ; guard against a zero SD
IRES = DV - IPRED                           ; individual residual
IWRES = IRES/W                              ; individual weighted residual
Y = IPRED + W*EPS(1)                        ; observation

; --- Parameters --------------------------------------------------------------
; initial values (in a fitted run: the final estimates)
$THETA
(0, 3.228538)                               ; THETA(1) TVCL: typical clearance (L/h)
(0, 43.485247)                              ; THETA(2) TVV: typical central volume of distribution (L)
(0, 4.579178)                               ; THETA(3) TVQ: typical intercompartmental clearance (L/h)
(0, 87.682569)                              ; THETA(4) TVVP: typical peripheral volume of distribution (L)
(0, 1.271318)                               ; THETA(5) TVKA: typical first-order absorption rate constant (1/h)
(0, 0.534285)                               ; THETA(6) TVALAG1: typical absorption lag time (h)
(0, 0.145056, 1)                            ; THETA(7) proportional residual error (SD as a fraction of IPRED)
(0, 0.022939)                               ; THETA(8) additive residual error (SD, mg/L)
$OMEGA
0.14592                                     ; ETA(1) IIV CL (variance; CV ~ 38%)
0.081957                                    ; ETA(2) IIV V (variance; CV ~ 29%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=SAEM INTERACTION MAXEVAL=9999 PRINT=5  ; SAEM
$ESTIMATION METHOD=IMP INTERACTION EONLY=1 ISAMPLE=300 NITER=5  ; objective function value by importance sampling
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab101
; patab: individual parameters and random effects
$TABLE ID CL V Q VP KA ALAG1 ETA1 ETA2
       NOPRINT ONEHEADER FIRSTONLY FILE=patab101
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab101
