;; ============================================================================
;; Run         : run101
;; Purpose     : Base population PK model without covariate effects: the starting
;;               model of the covariate analysis (nlmx cov -c nlmx.covar).
;; Model       : 3-compartment oral (first-order absorption); combined proportional + additive residual error
;; Data        : ../data/analysis.csv - 500 subject(s) in 2 group(s), simulated by nlmx
;; Author      : Ines MacLeod
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM run101 base model - 3-compartment oral (first-order absorption)

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA ../data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN12 TRANS4                 ; three compartments, first-order absorption

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
MU_1 = LOG(THETA(1))                        ; log typical CL
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2))                        ; log typical V2
V2 = EXP(MU_2 + ETA(2))                     ; individual central volume of distribution (L)
Q3 = THETA(3)                               ; intercompartmental clearance (L/h), no IIV
V3 = THETA(4)                               ; peripheral volume of distribution (L), no IIV
Q4 = THETA(5)                               ; second intercompartmental clearance (L/h), no IIV
V4 = THETA(6)                               ; second peripheral volume of distribution (L), no IIV
KA = THETA(7)                               ; first-order absorption rate constant (1/h), no IIV
S2 = V2                                     ; scale: concentration (mg/L) = amount/volume

$ERROR
; combined proportional + additive residual error
IPRED = F                                   ; individual prediction (mg/L)
W = SQRT(THETA(8)**2*IPRED**2 + THETA(9)**2)  ; SD of the residual error
IF (W.LE.0) W = 1E-6                        ; guard against a zero SD
IRES = DV - IPRED                           ; individual residual
IWRES = IRES/W                              ; individual weighted residual
Y = IPRED + W*EPS(1)                        ; observation

; --- Parameters --------------------------------------------------------------
; initial values (in a fitted run: the final estimates)
$THETA
(0, 3.32607)                                ; THETA(1) TVCL: typical clearance (L/h)
(0, 42.265414)                              ; THETA(2) TVV2: typical central volume of distribution (L)
(0, 5.373968)                               ; THETA(3) TVQ3: typical intercompartmental clearance (L/h)
(0, 92.503331)                              ; THETA(4) TVV3: typical peripheral volume of distribution (L)
(0, 1.209421)                               ; THETA(5) TVQ4: typical second intercompartmental clearance (L/h)
(0, 141.128367)                             ; THETA(6) TVV4: typical second peripheral volume of distribution (L)
(0, 1.079625)                               ; THETA(7) TVKA: typical first-order absorption rate constant (1/h)
(0, 0.154368, 1)                            ; THETA(8) proportional residual error (SD as a fraction of IPRED)
(0, 0.019623)                               ; THETA(9) additive residual error (SD, mg/L)
$OMEGA
0.161812                                    ; ETA(1) IIV CL (variance; CV ~ 40%)
0.139474                                    ; ETA(2) IIV V2 (variance; CV ~ 37%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=1 INTERACTION MAXEVAL=9999 PRINT=5  ; FOCE with interaction
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab101
; patab: individual parameters and random effects
$TABLE ID CL V2 Q3 V3 Q4 V4 KA ETA1 ETA2
       NOPRINT ONEHEADER FIRSTONLY FILE=patab101
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab101
