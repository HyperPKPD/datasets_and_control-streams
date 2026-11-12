;; ============================================================================
;; Run         : run102
;; Purpose     : Covariate model: the base model plus the simulated covariate effects
;;               as estimated THETAs; input of the forest plot (nlmx forest).
;; Model       : 3-compartment IV infusion, $DES (ADVAN13); combined proportional + additive residual error
;; Data        : ../data/analysis.csv - 100 subject(s) in 4 group(s), simulated by nlmx
;; Author      : Tobias Cohen
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM run102 covariate model - 3-compartment IV infusion, $DES (ADVAN13)

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA ../data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN13 TOL=6                  ; general nonlinear model (ODEs in $DES)

$MODEL COMP=(CENTRAL,DEFDOSE,DEFOBS) COMP=(PERIPH) COMP=(PERIPH2)

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
; Continuous covariates enter as (COV/reference)**exponent (reference: WT 70 kg,
; AGE 45 years, EGFR/CRCL 95); SEX as (1 + THETA*SEX) (fractional change for SEX = 1).
MU_1 = LOG(THETA(1)*(AGE/45)**THETA(9)*(WT/70)**THETA(10))  ; log typical CL; covariates: AGE (estimated), WT (estimated)
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2)*(WT/70)**THETA(11))     ; log typical V; covariates: WT (estimated)
V = EXP(MU_2 + ETA(2))                      ; individual central volume of distribution (L)
Q = THETA(3)                                ; intercompartmental clearance (L/h), no IIV
VP = THETA(4)                               ; peripheral volume of distribution (L), no IIV
Q2 = THETA(5)                               ; second intercompartmental clearance (L/h), no IIV
VP2 = THETA(6)                              ; second peripheral volume of distribution (L), no IIV

$DES
; amounts: A(1) central, A(2) peripheral, A(3) second peripheral
DADT(1) = - CL/V*A(1) - Q/V*A(1) + Q/VP*A(2) - Q2/V*A(1) + Q2/VP2*A(3)  ; central: input - elimination - distribution
DADT(2) = Q/V*A(1) - Q/VP*A(2)              ; peripheral
DADT(3) = Q2/V*A(1) - Q2/VP2*A(3)           ; second peripheral

$ERROR
; combined proportional + additive residual error
IPRED = A(1)/V                              ; individual prediction (mg/L)
W = SQRT(THETA(7)**2*IPRED**2 + THETA(8)**2)  ; SD of the residual error
IF (W.LE.0) W = 1E-6                        ; guard against a zero SD
IRES = DV - IPRED                           ; individual residual
IWRES = IRES/W                              ; individual weighted residual
Y = IPRED + W*EPS(1)                        ; observation

; --- Parameters --------------------------------------------------------------
; initial values (in a fitted run: the final estimates)
$THETA
(0, 3.162116)                               ; THETA(1) TVCL: typical clearance (L/h)
(0, 42.67735)                               ; THETA(2) TVV: typical central volume of distribution (L)
(0, 5.194067)                               ; THETA(3) TVQ: typical intercompartmental clearance (L/h)
(0, 87.274186)                              ; THETA(4) TVVP: typical peripheral volume of distribution (L)
(0, 1.302283)                               ; THETA(5) TVQ2: typical second intercompartmental clearance (L/h)
(0, 115.732866)                             ; THETA(6) TVVP2: typical second peripheral volume of distribution (L)
(0, 0.14189, 1)                             ; THETA(7) proportional residual error (SD as a fraction of IPRED)
(0, 0.020193)                               ; THETA(8) additive residual error (SD, mg/L)
(-10, -0.231082, 10)                        ; THETA(9) CL~AGE: exponent of (AGE/45)
(-10, 0.727983, 10)                         ; THETA(10) CL~WT: exponent of (WT/70)
(-10, 1.062631, 10)                         ; THETA(11) V~WT: exponent of (WT/70)
$OMEGA
0.082427                                    ; ETA(1) IIV CL (variance; CV ~ 29%)
0.0685                                      ; ETA(2) IIV V (variance; CV ~ 26%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=1 INTERACTION MAXEVAL=9999 PRINT=5  ; FOCE with interaction
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab102
; patab: individual parameters and random effects
$TABLE ID CL V Q VP Q2 VP2 ETA1 ETA2
       NOPRINT ONEHEADER FIRSTONLY FILE=patab102
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab102
