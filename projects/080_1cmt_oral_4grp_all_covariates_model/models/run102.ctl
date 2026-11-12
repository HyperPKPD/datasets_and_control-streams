;; ============================================================================
;; Run         : run102
;; Purpose     : Covariate model: the base model plus the simulated covariate effects
;;               as estimated THETAs; input of the forest plot (nlmx forest).
;; Model       : 1-compartment oral (first-order absorption); combined proportional + additive residual error
;; Data        : ../data/analysis.csv - 100 subject(s) in 4 group(s), simulated by nlmx
;; Author      : Kofi Kowalski
;; Date        : 2026-11-12
;; Version     : 1.0 - written by nlmx 4.16.2 (`nlmx generate`)
;; ============================================================================
$PROBLEM run102 covariate model - 1-compartment oral (first-order absorption)

; --- Data --------------------------------------------------------------------
; dose (AMT) in mg, concentrations (DV) in mg/L, time in hours
$INPUT ID TIME AMT RATE ADDL II EVID MDV DV CMT GROUP DOSE WT AGE SEX EGFR CRCL BLQ
$DATA ../data/analysis.csv IGNORE=@

; --- Structural model --------------------------------------------------------
$SUBROUTINES ADVAN2 TRANS2                  ; one compartment, first-order absorption

$PK
; Individual parameter = typical value * covariate effects * exp(ETA).
; MU-referenced: MU_k = log(typical value), parameter = exp(MU_k + ETA(k)).
; Continuous covariates enter as (COV/reference)**exponent (reference: WT 70 kg,
; AGE 45 years, EGFR/CRCL 95); SEX as (1 + THETA*SEX) (fractional change for SEX = 1).
MU_1 = LOG(THETA(1)*(AGE/45)**THETA(6)*(EGFR/95)**THETA(7)*(1+THETA(8)*SEX)*(WT/70)**THETA(9))  ; log typical CL; covariates: AGE (estimated), EGFR (estimated), SEX (estimated), WT (estimated)
CL = EXP(MU_1 + ETA(1))                     ; individual clearance (L/h)
MU_2 = LOG(THETA(2)*(WT/70)**THETA(10))     ; log typical V; covariates: WT (estimated)
V = EXP(MU_2 + ETA(2))                      ; individual central volume of distribution (L)
KA = THETA(3)                               ; first-order absorption rate constant (1/h), no IIV
S2 = V                                      ; scale: concentration (mg/L) = amount/volume

$ERROR
; combined proportional + additive residual error
IPRED = F                                   ; individual prediction (mg/L)
W = SQRT(THETA(4)**2*IPRED**2 + THETA(5)**2)  ; SD of the residual error
IF (W.LE.0) W = 1E-6                        ; guard against a zero SD
IRES = DV - IPRED                           ; individual residual
IWRES = IRES/W                              ; individual weighted residual
Y = IPRED + W*EPS(1)                        ; observation

; --- Parameters --------------------------------------------------------------
; initial values (in a fitted run: the final estimates)
$THETA
(0, 3.626494)                               ; THETA(1) TVCL: typical clearance (L/h)
(0, 42.50145)                               ; THETA(2) TVV: typical central volume of distribution (L)
(0, 1.113911)                               ; THETA(3) TVKA: typical first-order absorption rate constant (1/h)
(0, 0.15443, 1)                             ; THETA(4) proportional residual error (SD as a fraction of IPRED)
(0, 0.019459)                               ; THETA(5) additive residual error (SD, mg/L)
(-10, -0.383025, 10)                        ; THETA(6) CL~AGE: exponent of (AGE/45)
(-10, 0.503128, 10)                         ; THETA(7) CL~EGFR: exponent of (EGFR/95)
(-1, -0.337111, 5)                          ; THETA(8) CL~SEX: fractional change for SEX = 1
(-10, 0.761049, 10)                         ; THETA(9) CL~WT: exponent of (WT/70)
(-10, 0.752397, 10)                         ; THETA(10) V~WT: exponent of (WT/70)
$OMEGA
0.081864                                    ; ETA(1) IIV CL (variance; CV ~ 29%)
0.064278                                    ; ETA(2) IIV V (variance; CV ~ 25%)
$SIGMA 1 FIX                                ; EPS(1): unit variance, scaled by W in $ERROR

; --- Estimation --------------------------------------------------------------
$ESTIMATION METHOD=1 INTERACTION MAXEVAL=9999 PRINT=5  ; FOCE with interaction
$COVARIANCE PRINT=E                         ; standard errors; eigenvalues

; --- Output tables (Xpose naming) --------------------------------------------
; sdtab: observations, predictions and residuals
$TABLE ID TIME EVID MDV DV IPRED PRED RES WRES CWRES IWRES CMT GROUP DOSE BLQ
       NOPRINT ONEHEADER FILE=sdtab102
; patab: individual parameters and random effects
$TABLE ID CL V KA ETA1 ETA2
       NOPRINT ONEHEADER FIRSTONLY FILE=patab102
; cotab: covariates
$TABLE ID WT AGE SEX EGFR CRCL NOPRINT ONEHEADER FIRSTONLY FILE=cotab102
