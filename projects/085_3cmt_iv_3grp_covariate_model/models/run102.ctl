;; ============================================================================
;; Run         : run102
;; Purpose     : Covariate model: the base model plus the simulated covariate effects
;;               as estimated THETAs; input of the forest plot (nlmx forest).
;; Model       : 3-compartment IV bolus; combined proportional + additive residual error
;; Data        : ../data/analysis.csv - 100 subject(s) in 3 group(s), simulated by nlmx
;; Author      : Henrik Schmidt
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM run102 covariate model - 3-compartment IV bolus

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA ../data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN11 TRANS4                 ; three compartments

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
; Continuous covariates enter as (COV/reference)**exponent (reference: WT 70 kg,
; AGE 45 years, EGFR/CRCL 95); SEX as (1 + THETA*SEX) (fractional change for SEX = 1).
MU_1 = LOG(THETA(1)*(EGFR/95)**THETA(9)*(WT/70)**THETA(10))  ; log typical CL; covariates: EGFR (estimated), WT (estimated)
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2)*(WT/70)**THETA(11))     ; log typical V1; covariates: WT (estimated)
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
(0, 3.490133)                               ; THETA(1) TVCL: typical clearance (L/h)
(0, 44.080101)                              ; THETA(2) TVV1: typical central volume of distribution (L)
(0, 3.816503)                               ; THETA(3) TVQ2: typical intercompartmental clearance (L/h)
(0, 52.988976)                              ; THETA(4) TVV2: typical peripheral volume of distribution (L)
(0, 2.370277)                               ; THETA(5) TVQ3: typical second intercompartmental clearance (L/h)
(0, 90.568932)                              ; THETA(6) TVV3: typical second peripheral volume of distribution (L)
(0, 0.147797, 1)                            ; THETA(7) proportional residual error (SD as a fraction of IPRED)
(0, 0.018108)                               ; THETA(8) additive residual error (SD, mg/L)
(-10, 0.448106, 10)                         ; THETA(9) CL~EGFR: exponent of (EGFR/95)
(-10, 0.694129, 10)                         ; THETA(10) CL~WT: exponent of (WT/70)
(-10, 0.854093, 10)                         ; THETA(11) V1~WT: exponent of (WT/70)
$OMEGA
0.070116                                    ; ETA(1) IIV CL (variance; CV ~ 26%)
0.070912                                    ; ETA(2) IIV V1 (variance; CV ~ 27%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=1 INTERACTION MAXEVAL=9999 PRINT=5  ; FOCE with interaction
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab102
; patab: individual parameters and random effects
$TABLE ID CL V1 Q2 V2 Q3 V3 ETA1 ETA2
       NOPRINT ONEHEADER FIRSTONLY FILE=patab102
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab102
