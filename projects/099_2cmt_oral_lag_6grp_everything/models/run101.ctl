;; ============================================================================
;; Run         : run101
;; Purpose     : Base population PK model without covariate effects: the starting
;;               model of the covariate analysis (nlmx cov -c nlmx.covar).
;; Model       : 2-compartment oral (first-order absorption) with lag time; combined proportional + additive residual error
;; Data        : ../data/analysis.csv - 120 subject(s) in 6 group(s), simulated by nlmx
;; Author      : Maryam Wagner
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM run101 base model - 2-compartment oral (first-order absorption) with lag time

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA ../data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN4 TRANS4                  ; two compartments, first-order absorption

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
MU_1 = LOG(THETA(1))                        ; log typical CL
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2))                        ; log typical V2
V2 = EXP(MU_2 + ETA(2))                     ; individual central volume of distribution (L)
MU_3 = LOG(THETA(3))                        ; log typical Q
Q = EXP(MU_3 + ETA(3))                      ; individual intercompartmental clearance (L/h)
MU_4 = LOG(THETA(4))                        ; log typical V3
V3 = EXP(MU_4 + ETA(4))                     ; individual peripheral volume of distribution (L)
MU_5 = LOG(THETA(5))                        ; log typical KA
KA = EXP(MU_5 + ETA(5))                     ; individual first-order absorption rate constant (1/h)
ALAG1 = THETA(6)                            ; absorption lag time (h), no IIV
S2 = V2                                     ; scale: concentration (mg/L) = amount/volume

$ERROR
; combined proportional + additive residual error
IPRED = F                                   ; individual prediction (mg/L)
W = SQRT(THETA(7)**2*IPRED**2 + THETA(8)**2)  ; SD of the residual error
IF (W.LE.0) W = 1E-6                        ; guard against a zero SD
IRES = DV - IPRED                           ; individual residual
IWRES = IRES/W                              ; individual weighted residual
Y = IPRED + W*EPS(1)                        ; observation

; --- Parameters --------------------------------------------------------------
; initial values (in a fitted run: the final estimates)
$THETA
(0, 3.556477)                               ; THETA(1) TVCL: typical clearance (L/h)
(0, 41.547643)                              ; THETA(2) TVV2: typical central volume of distribution (L)
(0, 4.222771)                               ; THETA(3) TVQ: typical intercompartmental clearance (L/h)
(0, 153.48317)                              ; THETA(4) TVV3: typical peripheral volume of distribution (L)
(0, 1.185449)                               ; THETA(5) TVKA: typical first-order absorption rate constant (1/h)
(0, 0.389135)                               ; THETA(6) TVALAG1: typical absorption lag time (h)
(0, 0.164673, 1)                            ; THETA(7) proportional residual error (SD as a fraction of IPRED)
(0, 0.019493)                               ; THETA(8) additive residual error (SD, mg/L)
$OMEGA
0.190001                                    ; ETA(1) IIV CL (variance; CV ~ 44%)
0.132801                                    ; ETA(2) IIV V2 (variance; CV ~ 36%)
0                                           ; ETA(3) IIV Q (variance; CV ~ 0%)
0.421287                                    ; ETA(4) IIV V3 (variance; CV ~ 65%)
0.120834                                    ; ETA(5) IIV KA (variance; CV ~ 35%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=1 INTERACTION MAXEVAL=9999 PRINT=5  ; FOCE with interaction
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab101
; patab: individual parameters and random effects
$TABLE ID CL V2 Q V3 KA ALAG1 ETA1 ETA2 ETA3 ETA4 ETA5
       NOPRINT ONEHEADER FIRSTONLY FILE=patab101
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab101
