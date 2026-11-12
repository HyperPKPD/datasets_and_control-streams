;; ============================================================================
;; Run         : run101
;; Purpose     : Base population PK model without covariate effects: the starting
;;               model of the covariate analysis (nlmx cov -c nlmx.covar).
;; Model       : 3-compartment IV bolus; combined proportional + additive residual error
;; Data        : ../data/analysis.csv - 100 subject(s) in 3 group(s), simulated by nlmx
;; Author      : Chiara Okafor
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM run101 base model - 3-compartment IV bolus

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA ../data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN11 TRANS4                 ; three compartments

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
MU_1 = LOG(THETA(1))                        ; log typical CL
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2))                        ; log typical V1
V1 = EXP(MU_2 + ETA(2))                     ; individual central volume of distribution (L)
Q2 = THETA(3)                               ; intercompartmental clearance (L/h), no IIV
V2 = THETA(4)                               ; peripheral volume of distribution (L), no IIV
Q3 = THETA(5)                               ; second intercompartmental clearance (L/h), no IIV
V3 = THETA(6)                               ; second peripheral volume of distribution (L), no IIV
S1 = V1                                     ; scale: concentration (mg/L) = amount/volume

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
(0, 2.94698)                                ; THETA(1) TVCL: typical clearance (L/h)
(0, 44.137084)                              ; THETA(2) TVV1: typical central volume of distribution (L)
(0, 4.938213)                               ; THETA(3) TVQ2: typical intercompartmental clearance (L/h)
(0, 86.182751)                              ; THETA(4) TVV2: typical peripheral volume of distribution (L)
(0, 1.728978)                               ; THETA(5) TVQ3: typical second intercompartmental clearance (L/h)
(0, 205.40721)                              ; THETA(6) TVV3: typical second peripheral volume of distribution (L)
(0, 0.146463, 1)                            ; THETA(7) proportional residual error (SD as a fraction of IPRED)
(0, 0.020724)                               ; THETA(8) additive residual error (SD, mg/L)
$OMEGA
0.23316                                     ; ETA(1) IIV CL (variance; CV ~ 48%)
0.128413                                    ; ETA(2) IIV V1 (variance; CV ~ 36%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=1 INTERACTION MAXEVAL=9999 PRINT=5  ; FOCE with interaction
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab101
; patab: individual parameters and random effects
$TABLE ID CL V1 Q2 V2 Q3 V3 ETA1 ETA2
       NOPRINT ONEHEADER FIRSTONLY FILE=patab101
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab101
