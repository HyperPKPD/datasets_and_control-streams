;; ============================================================================
;; Run         : run101
;; Purpose     : Base population PK model without covariate effects: the starting
;;               model of the covariate analysis (nlmx cov -c nlmx.covar).
;; Model       : 2-compartment IV bolus; proportional residual error
;; Data        : ../data/analysis.csv - 100 subject(s) in 4 group(s), simulated by nlmx
;; Author      : Rosa Kobayashi
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM run101 base model - 2-compartment IV bolus

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA ../data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN3 TRANS4                  ; two compartments, CL V1 Q V2

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
MU_1 = LOG(THETA(1))                        ; log typical CL
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2))                        ; log typical V1
V1 = EXP(MU_2 + ETA(2))                     ; individual central volume of distribution (L)
Q = THETA(3)                                ; intercompartmental clearance (L/h), no IIV
V2 = THETA(4)                               ; peripheral volume of distribution (L), no IIV
S1 = V1                                     ; scale: concentration (mg/L) = amount/volume

$ERROR
; proportional residual error
IPRED = F                                   ; individual prediction (mg/L)
W = THETA(5)*IPRED                          ; SD of the residual error
IF (W.LE.0) W = 1E-6                        ; guard against a zero SD
IRES = DV - IPRED                           ; individual residual
IWRES = IRES/W                              ; individual weighted residual
Y = IPRED + W*EPS(1)                        ; observation

; --- Parameters --------------------------------------------------------------
; initial values (in a fitted run: the final estimates)
$THETA
(0, 3.267139)                               ; THETA(1) TVCL: typical clearance (L/h)
(0, 44.136322)                              ; THETA(2) TVV1: typical central volume of distribution (L)
(0, 4.84419)                                ; THETA(3) TVQ: typical intercompartmental clearance (L/h)
(0, 78.91107)                               ; THETA(4) TVV2: typical peripheral volume of distribution (L)
(0, 0.148256, 1)                            ; THETA(5) proportional residual error (SD as a fraction of IPRED)
$OMEGA
0.13575                                     ; ETA(1) IIV CL (variance; CV ~ 37%)
0.11409                                     ; ETA(2) IIV V1 (variance; CV ~ 34%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=1 INTERACTION MAXEVAL=9999 PRINT=5  ; FOCE with interaction
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab101
; patab: individual parameters and random effects
$TABLE ID CL V1 Q V2 ETA1 ETA2
       NOPRINT ONEHEADER FIRSTONLY FILE=patab101
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab101
