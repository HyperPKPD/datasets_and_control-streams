;; ============================================================================
;; Run         : truth
;; Purpose     : Simulation (truth) model: the true parameter values and covariate
;;               effects used to simulate data/analysis.csv. Not meant to be estimated.
;; Model       : 3-compartment oral (first-order absorption) with lag time, $DES (ADVAN13); combined proportional + additive residual error
;; Data        : data/analysis.csv - 90 subject(s) in 6 group(s), simulated by nlmx
;; Author      : Sofia Ndlovu
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM TRUTH (simulation only) - 3-compartment oral (first-order absorption) with lag time, $DES (ADVAN13)

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN13 TOL=6                  ; general nonlinear model (ODEs in $DES)

$MODEL COMP=(DEPOT,DEFDOSE) COMP=(CENTRAL,DEFOBS) COMP=(PERIPH) COMP=(PERIPH2)

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
; Continuous covariates enter as (COV/reference)**exponent (reference: WT 70 kg,
; AGE 45 years, EGFR/CRCL 95); SEX as factor**SEX (factor for SEX = 1).
MU_1 = LOG(THETA(1)*(AGE/45)**(-0.2)*(EGFR/95)**0.6*0.85**SEX*(WT/70)**0.75)  ; log typical CL; covariates: AGE (true effect -0.2), EGFR (true effect 0.6), SEX (true effect 0.85), WT (true effect 0.75)
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2)*(WT/70)**1)             ; log typical V; covariates: WT (true effect 1)
V = EXP(MU_2 + ETA(2))                      ; individual central volume of distribution (L)
Q = THETA(3)                                ; intercompartmental clearance (L/h), no IIV
VP = THETA(4)                               ; peripheral volume of distribution (L), no IIV
Q2 = THETA(5)                               ; second intercompartmental clearance (L/h), no IIV
VP2 = THETA(6)                              ; second peripheral volume of distribution (L), no IIV
MU_3 = LOG(THETA(7))                        ; log typical KA
KA = EXP(MU_3 + ETA(3))                     ; individual first-order absorption rate constant (1/h)
ALAG1 = THETA(8)                            ; absorption lag time (h), no IIV

$DES
; amounts: A(1) depot, A(2) central, A(3) peripheral, A(4) second peripheral
DADT(1) = -KA*A(1)                          ; absorption from the depot
DADT(2) = KA*A(1) - CL/V*A(2) - Q/V*A(2) + Q/VP*A(3) - Q2/V*A(2) + Q2/VP2*A(4)  ; central: input - elimination - distribution
DADT(3) = Q/V*A(2) - Q/VP*A(3)              ; peripheral
DADT(4) = Q2/V*A(2) - Q2/VP2*A(4)           ; second peripheral

$ERROR
; combined proportional + additive residual error
IPRED = A(2)/V                              ; individual prediction (mg/L)
W = SQRT(THETA(9)**2*IPRED**2 + THETA(10)**2)  ; SD of the residual error
IF (W.LE.0) W = 1E-6                        ; guard against a zero SD
IRES = DV - IPRED                           ; individual residual
IWRES = IRES/W                              ; individual weighted residual
Y = IPRED + W*EPS(1)                        ; observation

; --- Parameters --------------------------------------------------------------
; initial values (in a fitted run: the final estimates)
$THETA
(0, 3.2)                                    ; THETA(1) TVCL: typical clearance (L/h)
(0, 42)                                     ; THETA(2) TVV: typical central volume of distribution (L)
(0, 5)                                      ; THETA(3) TVQ: typical intercompartmental clearance (L/h)
(0, 80)                                     ; THETA(4) TVVP: typical peripheral volume of distribution (L)
(0, 1.5)                                    ; THETA(5) TVQ2: typical second intercompartmental clearance (L/h)
(0, 120)                                    ; THETA(6) TVVP2: typical second peripheral volume of distribution (L)
(0, 1.1)                                    ; THETA(7) TVKA: typical first-order absorption rate constant (1/h)
(0, 0.5)                                    ; THETA(8) TVALAG1: typical absorption lag time (h)
(0, 0.15, 1)                                ; THETA(9) proportional residual error (SD as a fraction of IPRED)
(0, 0.02)                                   ; THETA(10) additive residual error (SD, mg/L)
$OMEGA
0.086178                                    ; ETA(1) IIV CL (variance; CV ~ 29%)
0.060625                                    ; ETA(2) IIV V (variance; CV ~ 25%)
0.14842                                     ; ETA(3) IIV KA (variance; CV ~ 39%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=1 INTERACTION MAXEVAL=9999 PRINT=5  ; FOCE with interaction
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab_truth
; patab: individual parameters and random effects
$TABLE ID CL V Q VP Q2 VP2 KA ALAG1 ETA1 ETA2 ETA3
       NOPRINT ONEHEADER FIRSTONLY FILE=patab_truth
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab_truth
