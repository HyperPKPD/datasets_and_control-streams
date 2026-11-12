;; ============================================================================
;; Run         : run102
;; Purpose     : Covariate model: the base model plus the simulated covariate effects
;;               as estimated THETAs; input of the forest plot (nlmx forest).
;; Model       : 1-compartment IV bolus; combined proportional + additive residual error
;; Data        : ../data/analysis.csv - 100 subject(s) in 5 group(s), simulated by nlmx
;; Author      : Chiara Sato
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM run102 covariate model - 1-compartment IV bolus

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA ../data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN1 TRANS2                  ; one compartment, CL and V

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
; Continuous covariates enter as (COV/reference)**exponent (reference: WT 70 kg,
; AGE 45 years, EGFR/CRCL 95); SEX as (1 + THETA*SEX) (fractional change for SEX = 1).
MU_1 = LOG(THETA(1)*(EGFR/95)**THETA(5))    ; log typical CL; covariates: EGFR (estimated)
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2))                        ; log typical V
V = EXP(MU_2 + ETA(2))                      ; individual central volume of distribution (L)
S1 = V                                      ; scale: concentration (mg/L) = amount/volume

$ERROR
; combined proportional + additive residual error
IPRED = F                                   ; individual prediction (mg/L)
W = SQRT(THETA(3)**2*IPRED**2 + THETA(4)**2)  ; SD of the residual error
IF (W.LE.0) W = 1E-6                        ; guard against a zero SD
IRES = DV - IPRED                           ; individual residual
IWRES = IRES/W                              ; individual weighted residual
Y = IPRED + W*EPS(1)                        ; observation

; --- Parameters --------------------------------------------------------------
; initial values (in a fitted run: the final estimates)
$THETA
(0, 3.259519)                               ; THETA(1) TVCL: typical clearance (L/h)
(0, 43.469491)                              ; THETA(2) TVV: typical central volume of distribution (L)
(0, 0.157254, 1)                            ; THETA(3) proportional residual error (SD as a fraction of IPRED)
(0, 0.0175)                                 ; THETA(4) additive residual error (SD, mg/L)
(-10, 0.715713, 10)                         ; THETA(5) CL~EGFR: exponent of (EGFR/95)
$OMEGA
0.095269                                    ; ETA(1) IIV CL (variance; CV ~ 31%)
0.05608                                     ; ETA(2) IIV V (variance; CV ~ 24%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=1 INTERACTION MAXEVAL=9999 PRINT=5  ; FOCE with interaction
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab102
; patab: individual parameters and random effects
$TABLE ID CL V ETA1 ETA2
       NOPRINT ONEHEADER FIRSTONLY FILE=patab102
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab102
