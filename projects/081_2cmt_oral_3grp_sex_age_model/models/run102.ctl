;; ============================================================================
;; Run         : run102
;; Purpose     : Covariate model: the base model plus the simulated covariate effects
;;               as estimated THETAs; input of the forest plot (nlmx forest).
;; Model       : 2-compartment oral (first-order absorption); combined proportional + additive residual error
;; Data        : ../data/analysis.csv - 100 subject(s) in 3 group(s), simulated by nlmx
;; Author      : Chiara Eze
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM run102 covariate model - 2-compartment oral (first-order absorption)

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA ../data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN4 TRANS4                  ; two compartments, first-order absorption

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
; Continuous covariates enter as (COV/reference)**exponent (reference: WT 70 kg,
; AGE 45 years, EGFR/CRCL 95); SEX as (1 + THETA*SEX) (fractional change for SEX = 1).
MU_1 = LOG(THETA(1)*(AGE/45)**THETA(8)*(WT/70)**THETA(9))  ; log typical CL; covariates: AGE (estimated), WT (estimated)
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2)*(1+THETA(10)*SEX)*(WT/70)**THETA(11))  ; log typical V2; covariates: SEX (estimated), WT (estimated)
V2 = EXP(MU_2 + ETA(2))                     ; individual central volume of distribution (L)
Q = THETA(3)                                ; intercompartmental clearance (L/h), no IIV
V3 = THETA(4)                               ; peripheral volume of distribution (L), no IIV
KA = THETA(5)                               ; first-order absorption rate constant (1/h), no IIV
S2 = V2                                     ; scale: concentration (mg/L) = amount/volume

$ERROR
; combined proportional + additive residual error
IPRED = F                                   ; individual prediction (mg/L)
W = SQRT(THETA(6)**2*IPRED**2 + THETA(7)**2)  ; SD of the residual error
IF (W.LE.0) W = 1E-6                        ; guard against a zero SD
IRES = DV - IPRED                           ; individual residual
IWRES = IRES/W                              ; individual weighted residual
Y = IPRED + W*EPS(1)                        ; observation

; --- Parameters --------------------------------------------------------------
; initial values (in a fitted run: the final estimates)
$THETA
(0, 3.201715)                               ; THETA(1) TVCL: typical clearance (L/h)
(0, 42.468192)                              ; THETA(2) TVV2: typical central volume of distribution (L)
(0, 5.216913)                               ; THETA(3) TVQ: typical intercompartmental clearance (L/h)
(0, 79.163058)                              ; THETA(4) TVV3: typical peripheral volume of distribution (L)
(0, 1.075112)                               ; THETA(5) TVKA: typical first-order absorption rate constant (1/h)
(0, 0.153517, 1)                            ; THETA(6) proportional residual error (SD as a fraction of IPRED)
(0, 0.015843)                               ; THETA(7) additive residual error (SD, mg/L)
(-10, -0.402744, 10)                        ; THETA(8) CL~AGE: exponent of (AGE/45)
(-10, 0.603802, 10)                         ; THETA(9) CL~WT: exponent of (WT/70)
(-1, -0.146228, 5)                          ; THETA(10) V2~SEX: fractional change for SEX = 1
(-10, 0.973243, 10)                         ; THETA(11) V2~WT: exponent of (WT/70)
$OMEGA
0.06962                                     ; ETA(1) IIV CL (variance; CV ~ 26%)
0.058206                                    ; ETA(2) IIV V2 (variance; CV ~ 24%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=1 INTERACTION MAXEVAL=9999 PRINT=5  ; FOCE with interaction
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab102
; patab: individual parameters and random effects
$TABLE ID CL V2 Q V3 KA ETA1 ETA2
       NOPRINT ONEHEADER FIRSTONLY FILE=patab102
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab102
