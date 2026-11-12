#!/usr/bin/env bash
# Generate the 100 benchmark projects of projects.md. Run from the benchmarks folder:
#   bash run_all.sh
# A project whose folder already exists is skipped.
failed=()

if [ ! -e 'projects/001_1cmt_oral_2grp_minimal' ]; then
  nlmx generate --output projects/001_1cmt_oral_2grp_minimal --structure 1cmt-oral --groups 2 --doses "50,100" --gof-plots --author "Tariq Romano" --seed 20261001 || failed+=('001_1cmt_oral_2grp_minimal')
fi
if [ ! -e 'projects/002_1cmt_oral_3grp_large_n' ]; then
  nlmx generate --output projects/002_1cmt_oral_3grp_large_n --structure 1cmt-oral --groups 3 --group-names "Low,Mid,High" --doses "25,50,100" --subjects-per-group "200,300,400" --gof-plots --author "Lucia Larsen" --seed 20261002 || failed+=('002_1cmt_oral_3grp_large_n')
fi
if [ ! -e 'projects/003_1cmt_oral_2grp_proportional_error' ]; then
  nlmx generate --output projects/003_1cmt_oral_2grp_proportional_error --structure 1cmt-oral --groups 2 --doses "100,200" --error proportional --prop-error 20 --gof-plots --author "Andres Farouk" --seed 20261003 || failed+=('003_1cmt_oral_2grp_proportional_error')
fi
if [ ! -e 'projects/004_1cmt_oral_2grp_additive_error' ]; then
  nlmx generate --output projects/004_1cmt_oral_2grp_additive_error --structure 1cmt-oral --groups 2 --doses "100,200" --error additive --add-error 0.05 --gof-plots --author "Elif Qureshi" --seed 20261004 || failed+=('004_1cmt_oral_2grp_additive_error')
fi
if [ ! -e 'projects/005_1cmt_oral_4grp_unbalanced' ]; then
  nlmx generate --output projects/005_1cmt_oral_4grp_unbalanced --structure 1cmt-oral --groups 4 --doses "10,30,100,300" --subjects-per-group "12,12,24,36" --gof-plots --author "Hannah Kowalski" --seed 20261005 || failed+=('005_1cmt_oral_4grp_unbalanced')
fi
if [ ! -e 'projects/006_1cmt_oral_3grp_fast_absorption' ]; then
  nlmx generate --output projects/006_1cmt_oral_3grp_fast_absorption --structure 1cmt-oral --groups 3 --doses "40,80,160" --typical "CL=4,V=35,KA=4.5" --sample-times "0.25,0.5,0.75,1,1.5,2,4,8,12,24" --gof-plots --author "Clara Costa" --seed 20261006 || failed+=('006_1cmt_oral_3grp_fast_absorption')
fi
if [ ! -e 'projects/007_1cmt_oral_3grp_flip_flop' ]; then
  nlmx generate --output projects/007_1cmt_oral_3grp_flip_flop --structure 1cmt-oral --groups 3 --doses "100,200,400" --typical "CL=8,V=30,KA=0.15" --iiv "CL=30,V=25,KA=35" --sample-times "1,2,4,8,12,24,36,48,72" --gof-plots --author "Mateo Cruz" --seed 20261007 || failed+=('007_1cmt_oral_3grp_flip_flop')
fi
if [ ! -e 'projects/008_1cmt_oral_2grp_ka_variability' ]; then
  nlmx generate --output projects/008_1cmt_oral_2grp_ka_variability --structure 1cmt-oral --groups 2 --doses "100,200" --iiv "CL=30,V=25,KA=50" --gof-plots --author "Adaeze Hosseini" --seed 20261008 || failed+=('008_1cmt_oral_2grp_ka_variability')
fi
if [ ! -e 'projects/009_1cmt_oral_5grp_high_clearance' ]; then
  nlmx generate --output projects/009_1cmt_oral_5grp_high_clearance --structure 1cmt-oral --groups 5 --doses "100,200,300,400,500" --typical "CL=25,V=120,KA=2" --sample-times "0.25,0.5,1,1.5,2,3,4,6,8,12" --gof-plots --author "Yara Holm" --seed 20261009 || failed+=('009_1cmt_oral_5grp_high_clearance')
fi
if [ ! -e 'projects/010_1cmt_oral_3grp_long_half_life' ]; then
  nlmx generate --output projects/010_1cmt_oral_3grp_long_half_life --structure 1cmt-oral --groups 3 --doses "10,20,40" --typical "CL=0.6,V=70,KA=0.8" --sample-times "1,2,4,8,24,48,72,120,168,240" --gof-plots --author "Greta Fischer" --seed 20261010 || failed+=('010_1cmt_oral_3grp_long_half_life')
fi
if [ ! -e 'projects/011_1cmt_oral_2grp_no_covariates' ]; then
  nlmx generate --output projects/011_1cmt_oral_2grp_no_covariates --structure 1cmt-oral --groups 2 --doses "50,150" --no-covariate-effects --gof-plots --author "Gabriel Weber" --seed 20261011 || failed+=('011_1cmt_oral_2grp_no_covariates')
fi
if [ ! -e 'projects/012_1cmt_oral_6grp_wide_dose_range' ]; then
  nlmx generate --output projects/012_1cmt_oral_6grp_wide_dose_range --structure 1cmt-oral --groups 6 --doses "5,10,25,50,100,250" --subjects-per-group 15 --gof-plots --author "Chiara Goldberg" --seed 20261012 || failed+=('012_1cmt_oral_6grp_wide_dose_range')
fi
if [ ! -e 'projects/013_1cmt_oral_lag_3grp' ]; then
  nlmx generate --output projects/013_1cmt_oral_lag_3grp --structure 1cmt-oral-lag --groups 3 --doses "50,100,200" --typical "CL=3.5,V=40,KA=1.2,ALAG=0.75" --gof-plots --author "Samuel Costa" --seed 20261013 || failed+=('013_1cmt_oral_lag_3grp')
fi
if [ ! -e 'projects/014_1cmt_oral_4grp_qd_7days' ]; then
  nlmx generate --output projects/014_1cmt_oral_4grp_qd_7days --structure 1cmt-oral --groups 4 --doses "25,50,100,200" --n-doses 7 --dose-interval 24 --gof-plots --author "Rosa Osei" --seed 20261014 || failed+=('014_1cmt_oral_4grp_qd_7days')
fi
if [ ! -e 'projects/015_1cmt_oral_3grp_bid_steady_state' ]; then
  nlmx generate --output projects/015_1cmt_oral_3grp_bid_steady_state --structure 1cmt-oral --groups 3 --doses "50,100,200" --n-doses 14 --dose-interval 12 --sample-times "0.5,1,2,3,4,6,8,12" --gof-plots --author "Ravi Zhang" --seed 20261015 || failed+=('015_1cmt_oral_3grp_bid_steady_state')
fi
if [ ! -e 'projects/016_1cmt_oral_3grp_sparse_3' ]; then
  nlmx generate --output projects/016_1cmt_oral_3grp_sparse_3 --structure 1cmt-oral --groups 3 --doses "50,100,200" --subjects-per-group 60 --sparse-samples 3 --gof-plots --author "Chloe Cruz" --seed 20261016 || failed+=('016_1cmt_oral_3grp_sparse_3')
fi
if [ ! -e 'projects/017_1cmt_oral_4grp_blq' ]; then
  nlmx generate --output projects/017_1cmt_oral_4grp_blq --structure 1cmt-oral --groups 4 --doses "10,25,50,100" --lloq 0.1 --gof-plots --author "Mira Navarro" --seed 20261017 || failed+=('017_1cmt_oral_4grp_blq')
fi
if [ ! -e 'projects/018_1cmt_oral_2grp_low_variability' ]; then
  nlmx generate --output projects/018_1cmt_oral_2grp_low_variability --structure 1cmt-oral --groups 2 --doses "100,200" --iiv "CL=10,V=10" --prop-error 5 --add-error 0.005 --gof-plots --author "Noor Haddad" --seed 20261018 || failed+=('018_1cmt_oral_2grp_low_variability')
fi
if [ ! -e 'projects/019_1cmt_iv_bolus_2grp_large_n' ]; then
  nlmx generate --output projects/019_1cmt_iv_bolus_2grp_large_n --structure 1cmt-iv --groups 2 --doses "50,100" --subjects-per-group "250,350" --gof-plots --author "Hannah Bauer" --seed 20261019 || failed+=('019_1cmt_iv_bolus_2grp_large_n')
fi
if [ ! -e 'projects/020_1cmt_iv_bolus_3grp_proportional' ]; then
  nlmx generate --output projects/020_1cmt_iv_bolus_3grp_proportional --structure 1cmt-iv --groups 3 --doses "25,50,100" --error proportional --prop-error 12 --gof-plots --author "Emeka Horvat" --seed 20261020 || failed+=('020_1cmt_iv_bolus_3grp_proportional')
fi
if [ ! -e 'projects/021_1cmt_iv_bolus_4grp_q8h' ]; then
  nlmx generate --output projects/021_1cmt_iv_bolus_4grp_q8h --structure 1cmt-iv --groups 4 --doses "20,40,80,160" --n-doses 9 --dose-interval 8 --sample-times "0.25,0.5,1,2,4,6,8" --gof-plots --author "Ayumi Hosseini" --seed 20261021 || failed+=('021_1cmt_iv_bolus_4grp_q8h')
fi
if [ ! -e 'projects/022_1cmt_infusion_2grp_1h' ]; then
  nlmx generate --output projects/022_1cmt_infusion_2grp_1h --structure 1cmt-infusion --groups 2 --doses "100,200" --infusion-duration 1 --gof-plots --author "Sana Hoffmann" --seed 20261022 || failed+=('022_1cmt_infusion_2grp_1h')
fi
if [ ! -e 'projects/023_1cmt_infusion_3grp_aminoglycoside' ]; then
  nlmx generate --output projects/023_1cmt_infusion_3grp_aminoglycoside --structure 1cmt-infusion --groups 3 --doses "240,360,480" --infusion-duration 0.5 --typical "CL=5,V=18" --effects "CL~CRCL=0.8,V~WT=1" --sample-times "0.5,1,2,4,6,8,12,24" --gof-plots --author "Pavel Park" --seed 20261023 || failed+=('023_1cmt_infusion_3grp_aminoglycoside')
fi
if [ ! -e 'projects/024_1cmt_infusion_4grp_4h' ]; then
  nlmx generate --output projects/024_1cmt_infusion_4grp_4h --structure 1cmt-infusion --groups 4 --doses "100,200,300,400" --infusion-duration 4 --sample-times "1,2,3,4,5,6,8,12,24" --gof-plots --author "Erik Park" --seed 20261024 || failed+=('024_1cmt_infusion_4grp_4h')
fi
if [ ! -e 'projects/025_1cmt_infusion_5grp_q12h' ]; then
  nlmx generate --output projects/025_1cmt_infusion_5grp_q12h --structure 1cmt-infusion --groups 5 --doses "50,100,150,200,250" --n-doses 6 --dose-interval 12 --infusion-duration 1 --sample-times "0.5,1,2,4,6,8,12" --gof-plots --author "Gabriel Bello" --seed 20261025 || failed+=('025_1cmt_infusion_5grp_q12h')
fi
if [ ! -e 'projects/026_1cmt_iv_bolus_6grp_sparse_blq' ]; then
  nlmx generate --output projects/026_1cmt_iv_bolus_6grp_sparse_blq --structure 1cmt-iv --groups 6 --doses "5,10,20,40,80,160" --subjects-per-group 20 --sparse-samples 4 --lloq 0.05 --gof-plots --author "Lina Johansson" --seed 20261026 || failed+=('026_1cmt_iv_bolus_6grp_sparse_blq')
fi
if [ ! -e 'projects/027_1cmt_infusion_3grp_additive' ]; then
  nlmx generate --output projects/027_1cmt_infusion_3grp_additive --structure 1cmt-infusion --groups 3 --doses "100,200,400" --error additive --add-error 0.1 --gof-plots --author "Kaito Osei" --seed 20261027 || failed+=('027_1cmt_infusion_3grp_additive')
fi
if [ ! -e 'projects/028_1cmt_iv_bolus_3grp_sex_effect' ]; then
  nlmx generate --output projects/028_1cmt_iv_bolus_3grp_sex_effect --structure 1cmt-iv --groups 3 --doses "50,100,200" --effects "CL~WT=0.75,V~WT=1,CL~SEX=0.75" --gof-plots --author "Jonah Whitfield" --seed 20261028 || failed+=('028_1cmt_iv_bolus_3grp_sex_effect')
fi
if [ ! -e 'projects/029_1cmt_infusion_2grp_renal' ]; then
  nlmx generate --output projects/029_1cmt_infusion_2grp_renal --structure 1cmt-infusion --groups 2 --doses "100,200" --effects "CL~EGFR=0.9,V~WT=0.8" --covariate-model --gof-plots --author "Valentina Menon" --seed 20261029 || failed+=('029_1cmt_infusion_2grp_renal')
fi
if [ ! -e 'projects/030_1cmt_iv_bolus_4grp_age_effect' ]; then
  nlmx generate --output projects/030_1cmt_iv_bolus_4grp_age_effect --structure 1cmt-iv --groups 4 --doses "25,50,100,200" --effects "CL~WT=0.75,CL~AGE=-0.4,V~WT=1" --gof-plots --author "Tomasz Cruz" --seed 20261030 || failed+=('030_1cmt_iv_bolus_4grp_age_effect')
fi
if [ ! -e 'projects/031_2cmt_oral_2grp_large_n' ]; then
  nlmx generate --output projects/031_2cmt_oral_2grp_large_n --structure 2cmt-oral --groups 2 --doses "50,100" --subjects-per-group "200,400" --gof-plots --author "Pavel Rahman" --seed 20261031 || failed+=('031_2cmt_oral_2grp_large_n')
fi
if [ ! -e 'projects/032_2cmt_oral_3grp_dose_escalation' ]; then
  nlmx generate --output projects/032_2cmt_oral_3grp_dose_escalation --structure 2cmt-oral --groups 3 --group-names "Low,Mid,High" --doses "50,100,200" --gof-plots --author "Kaito Kapoor" --seed 20261032 || failed+=('032_2cmt_oral_3grp_dose_escalation')
fi
if [ ! -e 'projects/033_2cmt_oral_lag_3grp' ]; then
  nlmx generate --output projects/033_2cmt_oral_lag_3grp --structure 2cmt-oral-lag --groups 3 --doses "50,100,200" --gof-plots --author "Chidi Holm" --seed 20261033 || failed+=('033_2cmt_oral_lag_3grp')
fi
if [ ! -e 'projects/034_2cmt_oral_4grp_qd_multiple' ]; then
  nlmx generate --output projects/034_2cmt_oral_4grp_qd_multiple --structure 2cmt-oral --groups 4 --doses "25,50,100,200" --n-doses 10 --dose-interval 24 --gof-plots --author "Priya Novak" --seed 20261034 || failed+=('034_2cmt_oral_4grp_qd_multiple')
fi
if [ ! -e 'projects/035_2cmt_oral_3grp_peripheral_iiv' ]; then
  nlmx generate --output projects/035_2cmt_oral_3grp_peripheral_iiv --structure 2cmt-oral --groups 3 --doses "50,100,200" --iiv "CL=30,V=25,Q=30,VP=30" --gof-plots --author "Ingrid Romano" --seed 20261035 || failed+=('035_2cmt_oral_3grp_peripheral_iiv')
fi
if [ ! -e 'projects/036_2cmt_oral_5grp_sparse_4' ]; then
  nlmx generate --output projects/036_2cmt_oral_5grp_sparse_4 --structure 2cmt-oral --groups 5 --doses "20,40,80,160,320" --subjects-per-group 30 --sparse-samples 4 --gof-plots --author "Linnea MacLeod" --seed 20261036 || failed+=('036_2cmt_oral_5grp_sparse_4')
fi
if [ ! -e 'projects/037_2cmt_oral_3grp_slow_distribution' ]; then
  nlmx generate --output projects/037_2cmt_oral_3grp_slow_distribution --structure 2cmt-oral --groups 3 --doses "50,100,200" --typical "CL=3,V=30,Q=1,VP=150,KA=1" --sample-times "0.5,1,2,4,8,12,24,48,96,168" --gof-plots --author "Yara Alvarez" --seed 20261037 || failed+=('037_2cmt_oral_3grp_slow_distribution')
fi
if [ ! -e 'projects/038_2cmt_iv_bolus_2grp_large_n' ]; then
  nlmx generate --output projects/038_2cmt_iv_bolus_2grp_large_n --structure 2cmt-iv --groups 2 --doses "50,100" --subjects-per-group "300,300" --gof-plots --author "Chiara Tanaka" --seed 20261038 || failed+=('038_2cmt_iv_bolus_2grp_large_n')
fi
if [ ! -e 'projects/039_2cmt_iv_bolus_3grp_rich' ]; then
  nlmx generate --output projects/039_2cmt_iv_bolus_3grp_rich --structure 2cmt-iv --groups 3 --doses "25,50,100" --sample-times "0.083,0.25,0.5,1,2,4,6,8,12,24,36,48" --gof-plots --author "Kofi Nakamura" --seed 20261039 || failed+=('039_2cmt_iv_bolus_3grp_rich')
fi
if [ ! -e 'projects/040_2cmt_iv_bolus_4grp_proportional' ]; then
  nlmx generate --output projects/040_2cmt_iv_bolus_4grp_proportional --structure 2cmt-iv --groups 4 --doses "10,30,100,300" --error proportional --prop-error 15 --gof-plots --author "Rosa Kobayashi" --seed 20261040 || failed+=('040_2cmt_iv_bolus_4grp_proportional')
fi
if [ ! -e 'projects/041_2cmt_infusion_3grp_vancomycin_like' ]; then
  nlmx generate --output projects/041_2cmt_infusion_3grp_vancomycin_like --structure 2cmt-infusion --groups 3 --doses "750,1000,1500" --n-doses 8 --dose-interval 12 --infusion-duration 1 --typical "CL=4,V=30,Q=6,VP=40" --effects "CL~CRCL=0.75,V~WT=1" --sample-times "0.5,1,2,4,6,8,12" --gof-plots --author "Erik Nilsen" --seed 20261041 || failed+=('041_2cmt_infusion_3grp_vancomycin_like')
fi
if [ ! -e 'projects/042_2cmt_infusion_2grp_mab_single' ]; then
  nlmx generate --output projects/042_2cmt_infusion_2grp_mab_single --structure 2cmt-infusion --groups 2 --doses "200,400" --infusion-duration 2 --typical "CL=0.01,V=3,Q=0.02,VP=2.5" --iiv "CL=35,V=20" --sample-times "1,2,6,24,72,168,336,504,672,1008,1344" --gof-plots --author "Ngozi Reddy" --seed 20261042 || failed+=('042_2cmt_infusion_2grp_mab_single')
fi
if [ ! -e 'projects/043_2cmt_infusion_4grp_mab_q3w' ]; then
  nlmx generate --output projects/043_2cmt_infusion_4grp_mab_q3w --structure 2cmt-infusion --groups 4 --doses "100,200,400,800" --n-doses 4 --dose-interval 504 --infusion-duration 1.5 --typical "CL=0.012,V=3.2,Q=0.02,VP=2.8" --iiv "CL=30,V=20" --sample-times "1,24,72,168,336,504" --gof-plots --author "Wanjiru Yilmaz" --seed 20261043 || failed+=('043_2cmt_infusion_4grp_mab_q3w')
fi
if [ ! -e 'projects/044_2cmt_oral_6grp_blq' ]; then
  nlmx generate --output projects/044_2cmt_oral_6grp_blq --structure 2cmt-oral --groups 6 --doses "5,10,20,50,100,200" --subjects-per-group 15 --lloq 0.05 --gof-plots --author "Henrik Cohen" --seed 20261044 || failed+=('044_2cmt_oral_6grp_blq')
fi
if [ ! -e 'projects/045_2cmt_oral_3grp_effect_on_ka' ]; then
  nlmx generate --output projects/045_2cmt_oral_3grp_effect_on_ka --structure 2cmt-oral --groups 3 --doses "50,100,200" --iiv "CL=30,V=25,KA=40" --effects "CL~WT=0.75,V~WT=1,KA~AGE=-0.3" --gof-plots --author "Nadia Ek" --seed 20261045 || failed+=('045_2cmt_oral_3grp_effect_on_ka')
fi
if [ ! -e 'projects/046_2cmt_oral_4grp_full_allometry' ]; then
  nlmx generate --output projects/046_2cmt_oral_4grp_full_allometry --structure 2cmt-oral --groups 4 --doses "25,50,100,200" --effects "CL~WT=0.75,V~WT=1,Q~WT=0.75,VP~WT=1" --gof-plots --author "Lucia Cohen" --seed 20261046 || failed+=('046_2cmt_oral_4grp_full_allometry')
fi
if [ ! -e 'projects/047_2cmt_iv_bolus_3grp_additive' ]; then
  nlmx generate --output projects/047_2cmt_iv_bolus_3grp_additive --structure 2cmt-iv --groups 3 --doses "50,100,200" --error additive --add-error 0.05 --gof-plots --author "Rohan Dahl" --seed 20261047 || failed+=('047_2cmt_iv_bolus_3grp_additive')
fi
if [ ! -e 'projects/048_2cmt_infusion_5grp_unbalanced' ]; then
  nlmx generate --output projects/048_2cmt_infusion_5grp_unbalanced --structure 2cmt-infusion --groups 5 --doses "50,100,200,400,800" --subjects-per-group "10,10,20,30,40" --infusion-duration 1 --gof-plots --author "Astrid Patel" --seed 20261048 || failed+=('048_2cmt_infusion_5grp_unbalanced')
fi
if [ ! -e 'projects/049_2cmt_oral_lag_4grp_bid' ]; then
  nlmx generate --output projects/049_2cmt_oral_lag_4grp_bid --structure 2cmt-oral-lag --groups 4 --doses "25,50,100,200" --n-doses 12 --dose-interval 12 --sample-times "0.5,1,1.5,2,3,4,6,8,12" --gof-plots --author "Zara Moreau" --seed 20261049 || failed+=('049_2cmt_oral_lag_4grp_bid')
fi
if [ ! -e 'projects/050_2cmt_oral_2grp_high_iiv' ]; then
  nlmx generate --output projects/050_2cmt_oral_2grp_high_iiv --structure 2cmt-oral --groups 2 --doses "100,200" --iiv "CL=50,V=40" --no-covariate-effects --gof-plots --author "Felix Ferreira" --seed 20261050 || failed+=('050_2cmt_oral_2grp_high_iiv')
fi
if [ ! -e 'projects/051_3cmt_iv_bolus_2grp_large_n' ]; then
  nlmx generate --output projects/051_3cmt_iv_bolus_2grp_large_n --structure 3cmt-iv --groups 2 --doses "50,100" --subjects-per-group "200,300" --gof-plots --author "Wanjiru Chukwu" --seed 20261051 || failed+=('051_3cmt_iv_bolus_2grp_large_n')
fi
if [ ! -e 'projects/052_3cmt_iv_bolus_3grp_rich' ]; then
  nlmx generate --output projects/052_3cmt_iv_bolus_3grp_rich --structure 3cmt-iv --groups 3 --doses "25,50,100" --sample-times "0.083,0.25,0.5,1,2,3,4,6,8,12,24,48,72,96" --gof-plots --author "Chiara Okafor" --seed 20261052 || failed+=('052_3cmt_iv_bolus_3grp_rich')
fi
if [ ! -e 'projects/053_3cmt_infusion_3grp_deep_tissue' ]; then
  nlmx generate --output projects/053_3cmt_infusion_3grp_deep_tissue --structure 3cmt-infusion --groups 3 --doses "100,200,400" --infusion-duration 0.5 --typical "CL=5,V=10,Q=15,VP=30,Q2=1,VP2=200" --sample-times "0.25,0.5,1,2,4,8,12,24,48,72" --gof-plots --author "Chidi Nwosu" --seed 20261053 || failed+=('053_3cmt_infusion_3grp_deep_tissue')
fi
if [ ! -e 'projects/054_3cmt_infusion_4grp_4h' ]; then
  nlmx generate --output projects/054_3cmt_infusion_4grp_4h --structure 3cmt-infusion --groups 4 --doses "100,200,300,400" --infusion-duration 4 --sample-times "1,2,4,5,6,8,12,24,48" --gof-plots --author "Bilal Larsen" --seed 20261054 || failed+=('054_3cmt_infusion_4grp_4h')
fi
if [ ! -e 'projects/055_3cmt_oral_2grp_large_n' ]; then
  nlmx generate --output projects/055_3cmt_oral_2grp_large_n --structure 3cmt-oral --groups 2 --doses "100,200" --subjects-per-group "250,250" --gof-plots --author "Ines MacLeod" --seed 20261055 || failed+=('055_3cmt_oral_2grp_large_n')
fi
if [ ! -e 'projects/056_3cmt_oral_lag_3grp' ]; then
  nlmx generate --output projects/056_3cmt_oral_lag_3grp --structure 3cmt-oral-lag --groups 3 --doses "50,100,200" --gof-plots --author "Leila Meyer" --seed 20261056 || failed+=('056_3cmt_oral_lag_3grp')
fi
if [ ! -e 'projects/057_3cmt_iv_bolus_5grp_multiple' ]; then
  nlmx generate --output projects/057_3cmt_iv_bolus_5grp_multiple --structure 3cmt-iv --groups 5 --doses "20,40,80,160,320" --n-doses 5 --dose-interval 24 --gof-plots --author "Viktor Ansah" --seed 20261057 || failed+=('057_3cmt_iv_bolus_5grp_multiple')
fi
if [ ! -e 'projects/058_3cmt_oral_4grp_sparse_blq' ]; then
  nlmx generate --output projects/058_3cmt_oral_4grp_sparse_blq --structure 3cmt-oral --groups 4 --doses "25,50,100,200" --subjects-per-group 30 --sparse-samples 5 --lloq 0.05 --gof-plots --author "Nora Johansson" --seed 20261058 || failed+=('058_3cmt_oral_4grp_sparse_blq')
fi
if [ ! -e 'projects/059_3cmt_infusion_6grp_covariates' ]; then
  nlmx generate --output projects/059_3cmt_infusion_6grp_covariates --structure 3cmt-infusion --groups 6 --doses "25,50,100,200,300,400" --subjects-per-group 15 --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.5,VP~WT=1" --gof-plots --author "Pedro Fischer" --seed 20261059 || failed+=('059_3cmt_infusion_6grp_covariates')
fi
if [ ! -e 'projects/060_3cmt_iv_bolus_3grp_low_iiv' ]; then
  nlmx generate --output projects/060_3cmt_iv_bolus_3grp_low_iiv --structure 3cmt-iv --groups 3 --doses "50,100,200" --error proportional --prop-error 8 --iiv "CL=10,V=10" --gof-plots --author "Yuki Andersson" --seed 20261060 || failed+=('060_3cmt_iv_bolus_3grp_low_iiv')
fi
if [ ! -e 'projects/061_1cmt_oral_ode_2grp' ]; then
  nlmx generate --output projects/061_1cmt_oral_ode_2grp --structure 1cmt-oral --ode --groups 2 --doses "50,100" --gof-plots --author "Maryam Holm" --seed 20261061 || failed+=('061_1cmt_oral_ode_2grp')
fi
if [ ! -e 'projects/062_1cmt_iv_ode_3grp' ]; then
  nlmx generate --output projects/062_1cmt_iv_ode_3grp --structure 1cmt-iv --ode --groups 3 --doses "25,50,100" --gof-plots --author "Ruth Obi" --seed 20261062 || failed+=('062_1cmt_iv_ode_3grp')
fi
if [ ! -e 'projects/063_1cmt_infusion_ode_3grp' ]; then
  nlmx generate --output projects/063_1cmt_infusion_ode_3grp --structure 1cmt-infusion --ode --groups 3 --doses "100,200,400" --infusion-duration 2 --gof-plots --author "Tunde Costa" --seed 20261063 || failed+=('063_1cmt_infusion_ode_3grp')
fi
if [ ! -e 'projects/064_1cmt_oral_lag_ode_4grp' ]; then
  nlmx generate --output projects/064_1cmt_oral_lag_ode_4grp --structure 1cmt-oral-lag --ode --groups 4 --doses "25,50,100,200" --gof-plots --author "Viktor Petrova" --seed 20261064 || failed+=('064_1cmt_oral_lag_ode_4grp')
fi
if [ ! -e 'projects/065_2cmt_oral_ode_3grp' ]; then
  nlmx generate --output projects/065_2cmt_oral_ode_3grp --structure 2cmt-oral --ode --groups 3 --doses "50,100,200" --gof-plots --author "Lucia Horvat" --seed 20261065 || failed+=('065_2cmt_oral_ode_3grp')
fi
if [ ! -e 'projects/066_2cmt_iv_ode_2grp' ]; then
  nlmx generate --output projects/066_2cmt_iv_ode_2grp --structure 2cmt-iv --ode --groups 2 --doses "50,100" --gof-plots --author "Fatima Moreau" --seed 20261066 || failed+=('066_2cmt_iv_ode_2grp')
fi
if [ ! -e 'projects/067_2cmt_infusion_ode_4grp_multiple' ]; then
  nlmx generate --output projects/067_2cmt_infusion_ode_4grp_multiple --structure 2cmt-infusion --ode --groups 4 --doses "50,100,200,400" --n-doses 4 --dose-interval 24 --infusion-duration 1 --gof-plots --author "Diego Brooks" --seed 20261067 || failed+=('067_2cmt_infusion_ode_4grp_multiple')
fi
if [ ! -e 'projects/068_2cmt_oral_lag_ode_5grp_sparse' ]; then
  nlmx generate --output projects/068_2cmt_oral_lag_ode_5grp_sparse --structure 2cmt-oral-lag --ode --groups 5 --doses "20,40,80,160,320" --subjects-per-group 25 --sparse-samples 5 --gof-plots --author "Erik Adebayo" --seed 20261068 || failed+=('068_2cmt_oral_lag_ode_5grp_sparse')
fi
if [ ! -e 'projects/069_3cmt_iv_ode_3grp' ]; then
  nlmx generate --output projects/069_3cmt_iv_ode_3grp --structure 3cmt-iv --ode --groups 3 --doses "25,50,100" --gof-plots --author "Kwame Kowalski" --seed 20261069 || failed+=('069_3cmt_iv_ode_3grp')
fi
if [ ! -e 'projects/070_3cmt_oral_ode_3grp' ]; then
  nlmx generate --output projects/070_3cmt_oral_ode_3grp --structure 3cmt-oral --ode --groups 3 --doses "50,100,200" --gof-plots --author "Hye-jin Whitfield" --seed 20261070 || failed+=('070_3cmt_oral_ode_3grp')
fi
if [ ! -e 'projects/071_3cmt_infusion_ode_6grp' ]; then
  nlmx generate --output projects/071_3cmt_infusion_ode_6grp --structure 3cmt-infusion --ode --groups 6 --doses "25,50,100,150,200,300" --subjects-per-group 15 --infusion-duration 1 --gof-plots --author "Dmitri Hosseini" --seed 20261071 || failed+=('071_3cmt_infusion_ode_6grp')
fi
if [ ! -e 'projects/072_2cmt_oral_ode_4grp_blq_bid' ]; then
  nlmx generate --output projects/072_2cmt_oral_ode_4grp_blq_bid --structure 2cmt-oral --ode --groups 4 --doses "10,25,50,100" --n-doses 10 --dose-interval 12 --lloq 0.05 --sample-times "0.5,1,2,3,4,6,8,12" --gof-plots --author "Ingrid Navarro" --seed 20261072 || failed+=('072_2cmt_oral_ode_4grp_blq_bid')
fi
if [ ! -e 'projects/073_1cmt_oral_3grp_fo' ]; then
  nlmx generate --output projects/073_1cmt_oral_3grp_fo --structure 1cmt-oral --groups 3 --doses "50,100,200" --approximation fo --gof-plots --author "Linnea Okeke" --seed 20261073 || failed+=('073_1cmt_oral_3grp_fo')
fi
if [ ! -e 'projects/074_1cmt_oral_3grp_foce' ]; then
  nlmx generate --output projects/074_1cmt_oral_3grp_foce --structure 1cmt-oral --groups 3 --doses "50,100,200" --error proportional --approximation foce --gof-plots --author "Tomasz Rossi" --seed 20261074 || failed+=('074_1cmt_oral_3grp_foce')
fi
if [ ! -e 'projects/075_1cmt_oral_3grp_laplace' ]; then
  nlmx generate --output projects/075_1cmt_oral_3grp_laplace --structure 1cmt-oral --groups 3 --doses "50,100,200" --approximation laplace --gof-plots --author "Wanjiru Bakari" --seed 20261075 || failed+=('075_1cmt_oral_3grp_laplace')
fi
if [ ! -e 'projects/076_1cmt_oral_3grp_saem' ]; then
  nlmx generate --output projects/076_1cmt_oral_3grp_saem --structure 1cmt-oral --groups 3 --doses "50,100,200" --subjects-per-group 30 --approximation saem --gof-plots --author "Babajide Holm" --seed 20261076 || failed+=('076_1cmt_oral_3grp_saem')
fi
if [ ! -e 'projects/077_2cmt_oral_3grp_fo' ]; then
  nlmx generate --output projects/077_2cmt_oral_3grp_fo --structure 2cmt-oral --groups 3 --doses "50,100,200" --approximation fo --gof-plots --author "Chiara Mensah" --seed 20261077 || failed+=('077_2cmt_oral_3grp_fo')
fi
if [ ! -e 'projects/078_2cmt_iv_3grp_laplace' ]; then
  nlmx generate --output projects/078_2cmt_iv_3grp_laplace --structure 2cmt-iv --groups 3 --doses "50,100,200" --approximation laplace --gof-plots --author "Saoirse Kealoha" --seed 20261078 || failed+=('078_2cmt_iv_3grp_laplace')
fi
if [ ! -e 'projects/079_2cmt_oral_3grp_saem' ]; then
  nlmx generate --output projects/079_2cmt_oral_3grp_saem --structure 2cmt-oral --groups 3 --doses "50,100,200" --subjects-per-group 30 --approximation saem --gof-plots --author "Camila Hansen" --seed 20261079 || failed+=('079_2cmt_oral_3grp_saem')
fi
if [ ! -e 'projects/080_1cmt_oral_4grp_all_covariates_model' ]; then
  nlmx generate --output projects/080_1cmt_oral_4grp_all_covariates_model --structure 1cmt-oral --groups 4 --doses "25,50,100,200" --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.6,CL~AGE=-0.3,CL~SEX=0.8" --covariate-model --gof-plots --author "Kofi Kowalski" --seed 20261080 || failed+=('080_1cmt_oral_4grp_all_covariates_model')
fi
if [ ! -e 'projects/081_2cmt_oral_3grp_sex_age_model' ]; then
  nlmx generate --output projects/081_2cmt_oral_3grp_sex_age_model --structure 2cmt-oral --groups 3 --doses "50,100,200" --effects "CL~WT=0.75,V~WT=1,CL~AGE=-0.35,V~SEX=0.85" --covariate-model --gof-plots --author "Chiara Eze" --seed 20261081 || failed+=('081_2cmt_oral_3grp_sex_age_model')
fi
if [ ! -e 'projects/082_1cmt_iv_5grp_correlated_covariates' ]; then
  nlmx generate --output projects/082_1cmt_iv_5grp_correlated_covariates --structure 1cmt-iv --groups 5 --doses "20,40,80,160,320" --effects "CL~EGFR=0.7" --covariate-model --gof-plots --author "Chiara Sato" --seed 20261082 || failed+=('082_1cmt_iv_5grp_correlated_covariates')
fi
if [ ! -e 'projects/083_2cmt_infusion_4grp_covariate_model_laplace' ]; then
  nlmx generate --output projects/083_2cmt_infusion_4grp_covariate_model_laplace --structure 2cmt-infusion --groups 4 --doses "50,100,200,400" --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.5" --covariate-model --approximation laplace --gof-plots --author "Ravi Diallo" --seed 20261083 || failed+=('083_2cmt_infusion_4grp_covariate_model_laplace')
fi
if [ ! -e 'projects/084_1cmt_oral_3grp_covariate_model_saem' ]; then
  nlmx generate --output projects/084_1cmt_oral_3grp_covariate_model_saem --structure 1cmt-oral --groups 3 --doses "50,100,200" --subjects-per-group 30 --effects "CL~WT=0.75,V~WT=1,CL~SEX=0.8" --covariate-model --approximation saem --gof-plots --author "Nora Wagner" --seed 20261084 || failed+=('084_1cmt_oral_3grp_covariate_model_saem')
fi
if [ ! -e 'projects/085_3cmt_iv_3grp_covariate_model' ]; then
  nlmx generate --output projects/085_3cmt_iv_3grp_covariate_model --structure 3cmt-iv --groups 3 --doses "50,100,200" --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.6" --covariate-model --gof-plots --author "Henrik Schmidt" --seed 20261085 || failed+=('085_3cmt_iv_3grp_covariate_model')
fi
if [ ! -e 'projects/086_2cmt_oral_4grp_weak_effects' ]; then
  nlmx generate --output projects/086_2cmt_oral_4grp_weak_effects --structure 2cmt-oral --groups 4 --doses "25,50,100,200" --effects "CL~WT=0.3,V~WT=0.3,CL~EGFR=0.2" --covariate-model --gof-plots --author "Priya Bauer" --seed 20261086 || failed+=('086_2cmt_oral_4grp_weak_effects')
fi
if [ ! -e 'projects/087_1cmt_oral_6grp_vector_plots' ]; then
  nlmx generate --output projects/087_1cmt_oral_6grp_vector_plots --structure 1cmt-oral --groups 6 --doses "10,20,40,80,160,320" --subjects-per-group 12 --plot-format both --gof-plots --author "Wanjiru Herrera" --seed 20261087 || failed+=('087_1cmt_oral_6grp_vector_plots')
fi
if [ ! -e 'projects/088_2cmt_iv_2grp_foce_proportional' ]; then
  nlmx generate --output projects/088_2cmt_iv_2grp_foce_proportional --structure 2cmt-iv --groups 2 --doses "100,200" --error proportional --approximation foce --gof-plots --author "Tomasz Joshi" --seed 20261088 || failed+=('088_2cmt_iv_2grp_foce_proportional')
fi
if [ ! -e 'projects/089_phase1_sad_2cmt_oral_6grp' ]; then
  nlmx generate --output projects/089_phase1_sad_2cmt_oral_6grp --structure 2cmt-oral --groups 6 --group-names "C1,C2,C3,C4,C5,C6" --doses "1,3,10,30,100,300" --subjects-per-group 8 --sample-times "0.25,0.5,1,1.5,2,3,4,6,8,12,24,48,72" --gof-plots --author "Zara Fontaine" --seed 20261089 || failed+=('089_phase1_sad_2cmt_oral_6grp')
fi
if [ ! -e 'projects/090_phase1_mad_2cmt_oral_5grp' ]; then
  nlmx generate --output projects/090_phase1_mad_2cmt_oral_5grp --structure 2cmt-oral --groups 5 --group-names "MAD1,MAD2,MAD3,MAD4,MAD5" --doses "10,25,50,100,200" --subjects-per-group 10 --n-doses 14 --dose-interval 24 --gof-plots --author "Rohan Sokolov" --seed 20261090 || failed+=('090_phase1_mad_2cmt_oral_5grp')
fi
if [ ! -e 'projects/091_phase2_1cmt_oral_4grp_sparse_blq' ]; then
  nlmx generate --output projects/091_phase2_1cmt_oral_4grp_sparse_blq --structure 1cmt-oral --groups 4 --group-names "D25,D50,D100,D200" --doses "25,50,100,200" --subjects-per-group 50 --sparse-samples 3 --lloq 0.05 --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.5" --gof-plots --author "Sebastian Bakari" --seed 20261091 || failed+=('091_phase2_1cmt_oral_4grp_sparse_blq')
fi
if [ ! -e 'projects/092_phase3_2cmt_oral_3grp_sparse' ]; then
  nlmx generate --output projects/092_phase3_2cmt_oral_3grp_sparse --structure 2cmt-oral --groups 3 --doses "50,100,150" --subjects-per-group 100 --n-doses 14 --dose-interval 24 --sparse-samples 3 --effects "CL~WT=0.75,V~WT=1,CL~AGE=-0.25" --gof-plots --author "Kenji Kobayashi" --seed 20261092 || failed+=('092_phase3_2cmt_oral_3grp_sparse')
fi
if [ ! -e 'projects/093_icu_antibiotic_2cmt_infusion_5grp' ]; then
  nlmx generate --output projects/093_icu_antibiotic_2cmt_infusion_5grp --structure 2cmt-infusion --groups 5 --doses "500,750,1000,1500,2000" --n-doses 9 --dose-interval 8 --infusion-duration 0.5 --sparse-samples 4 --lloq 0.5 --typical "CL=6,V=20,Q=8,VP=25" --effects "CL~CRCL=0.85,V~WT=1" --sample-times "0.5,1,2,4,6,8" --covariate-model --gof-plots --author "Astrid Whitfield" --seed 20261093 || failed+=('093_icu_antibiotic_2cmt_infusion_5grp')
fi
if [ ! -e 'projects/094_mab_q2w_2cmt_infusion_ode_3grp' ]; then
  nlmx generate --output projects/094_mab_q2w_2cmt_infusion_ode_3grp --structure 2cmt-infusion --ode --groups 3 --doses "150,300,600" --n-doses 6 --dose-interval 336 --infusion-duration 1 --typical "CL=0.01,V=3,Q=0.02,VP=2.5" --iiv "CL=30,V=20" --effects "CL~WT=0.75,V~WT=0.6" --sample-times "1,24,72,168,336" --gof-plots --author "Haruto Brooks" --seed 20261094 || failed+=('094_mab_q2w_2cmt_infusion_ode_3grp')
fi
if [ ! -e 'projects/095_oncology_3cmt_infusion_ode_4grp_cov' ]; then
  nlmx generate --output projects/095_oncology_3cmt_infusion_ode_4grp_cov --structure 3cmt-infusion --ode --groups 4 --doses "100,150,200,250" --n-doses 3 --dose-interval 504 --infusion-duration 1 --effects "CL~WT=0.75,V~WT=1,CL~AGE=-0.2" --covariate-model --sample-times "0.5,1,2,4,8,24,72,168,504" --gof-plots --author "Tobias Cohen" --seed 20261095 || failed+=('095_oncology_3cmt_infusion_ode_4grp_cov')
fi
if [ ! -e 'projects/096_ir_er_2cmt_oral_lag_ode_6grp_saem' ]; then
  nlmx generate --output projects/096_ir_er_2cmt_oral_lag_ode_6grp_saem --structure 2cmt-oral-lag --ode --groups 6 --doses "10,20,40,80,160,320" --subjects-per-group 12 --sparse-samples 6 --approximation saem --gof-plots --author "Tobias Diallo" --seed 20261096 || failed+=('096_ir_er_2cmt_oral_lag_ode_6grp_saem')
fi
if [ ! -e 'projects/097_1cmt_oral_lag_ode_5grp_laplace_blq' ]; then
  nlmx generate --output projects/097_1cmt_oral_lag_ode_5grp_laplace_blq --structure 1cmt-oral-lag --ode --groups 5 --doses "10,20,40,80,160" --lloq 0.05 --approximation laplace --gof-plots --author "Ingrid Rossi" --seed 20261097 || failed+=('097_1cmt_oral_lag_ode_5grp_laplace_blq')
fi
if [ ! -e 'projects/098_3cmt_oral_lag_ode_4grp_multiple_blq' ]; then
  nlmx generate --output projects/098_3cmt_oral_lag_ode_4grp_multiple_blq --structure 3cmt-oral-lag --ode --groups 4 --doses "25,50,100,200" --n-doses 7 --dose-interval 24 --lloq 0.02 --gof-plots --author "Pedro Okeke" --seed 20261098 || failed+=('098_3cmt_oral_lag_ode_4grp_multiple_blq')
fi
if [ ! -e 'projects/099_2cmt_oral_lag_6grp_everything' ]; then
  nlmx generate --output projects/099_2cmt_oral_lag_6grp_everything --structure 2cmt-oral-lag --groups 6 --group-names "A,B,C,D,E,F" --doses "10,20,40,80,160,320" --subjects-per-group "15,15,20,20,25,25" --n-doses 10 --dose-interval 12 --sparse-samples 5 --lloq 0.05 --typical "CL=4,V=40,Q=4,VP=60,KA=1.3,ALAG=0.4" --iiv "CL=35,V=25,KA=45,Q=25,VP=30" --prop-error 18 --add-error 0.01 --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.5,KA~AGE=-0.2" --covariate-model --sample-times "0.5,1,1.5,2,3,4,6,8,12" --plot-format both --gof-plots --author "Maryam Wagner" --seed 20261099 || failed+=('099_2cmt_oral_lag_6grp_everything')
fi
if [ ! -e 'projects/100_3cmt_oral_lag_ode_6grp_everything' ]; then
  nlmx generate --output projects/100_3cmt_oral_lag_ode_6grp_everything --structure 3cmt-oral-lag --ode --groups 6 --group-names "A,B,C,D,E,F" --doses "10,20,40,80,160,320" --subjects-per-group 15 --n-doses 7 --dose-interval 24 --sparse-samples 6 --lloq 0.02 --iiv "CL=30,V=25,KA=40" --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.6,CL~AGE=-0.2,CL~SEX=0.85" --covariate-model --gof-plots --author "Sofia Ndlovu" --seed 20261100 || failed+=('100_3cmt_oral_lag_ode_6grp_everything')
fi

if [ ${#failed[@]} -gt 0 ]; then echo "Failed: ${failed[*]}"; exit 1; else echo "All 100 projects generated."; fi
