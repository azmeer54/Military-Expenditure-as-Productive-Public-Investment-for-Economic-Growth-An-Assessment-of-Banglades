set more off
clear all 

use "https://github.com/azmeer54/Military-Expenditure-as-Productive-Public-Investment-for-Economic-Growth-An-Assessment-of-Banglades/blob/main/Military_Expenditure_as_Productive_Public_Investment_for_Economic_Growth_An_Assessment_of_Bangladesh_Economy.dta?raw=true"

//declaring time series data
tsset Year, yearly

sort Year 

//generating p, TFP
generate lnGDPLCU= ln(GDPLCU)
generate lnkstock= ln(kstock)
generate p1= (D.lnGDPLCU)  
generate p2= 4.148210
generate p3= 0.583042*(D.lnkstock)
generate p=p1-p2-p3
drop p1 p2 p3 

//Calculating Z 
generate Z1= n + d + p 
generate Z = Z1 + 4
drop Z1

//Formatting OGEX
generate OGEX = GFCE - MILEX

//Initial Regression
generate lnY= ln(RGDPPC)
generate lnHUMCAP=ln(HUMCAP)
generate lnZ=ln(Z)
generate lnMEX=ln(MILEX)
generate lnOGEX=ln(OGEX)
generate lnINV=ln(INV)


//Starting Texdoc 
texdoc init "MilExPaper.tex", force cmdstrip nooutput replace
texdoc stlog "OLS"
reg lnY lnMEX lnOGEX lnINV lnHUMCAP lnZ
estat dwatson
texdoc stlog close 

texdoc stlog "VIF"
vif
texdoc stlog close 

//Make the Model first Differenced
drop lnY lnMEX lnOGEX lnINV lnHUMCAP lnZ

//constructing the first difference transformations
generate DlnY= ln(RGDPPC)-ln(L.RGDPPC)
generate DlnHUMCAP=ln(HUMCAP)-ln(L.HUMCAP)
generate DlnZ=ln(Z)-ln(L.Z)
generate DlnMEX=ln(MILEX)-ln(L.MILEX)
generate DlnOGEX=ln(OGEX)-ln(L.OGEX)
generate DlnINV=ln(INV)-ln(L.INV)


//Lag Selection: BIC
varsoc DlnY , maxlag(4) //lag 3
varsoc DlnMEX, maxlag(4)  //lag 3
varsoc DlnOGEX , maxlag(4) //lag 4
varsoc DlnINV , maxlag(4)  //lag 4
varsoc DlnHUMCAP, maxlag(4)  //lag 1
varsoc DlnZ, maxlag(4)  //lag 3 


//UNIT ROOT TESTING-AUGMENTED DICKY FULLER
dfuller DlnY, lags(3) //non-stationary
dfuller DlnY, lags(3) trend //non-stationary**************************
dfuller DlnY, lags(3) drift //non-stationary**************************
dfuller D.DlnY, lags(3) //stationary
dfuller D.DlnY, lags(3) trend //stationary
dfuller D.DlnY, lags(3) drift //stationary

dfuller DlnMEX, lags(3) //stationary
dfuller DlnMEX, lags(3) trend //stationary
dfuller DlnMEX, lags(3) drift //stationary
dfuller D.DlnMEX, lags(3) //stationary
dfuller D.DlnMEX, lags(3) trend //stationary
dfuller D.DlnMEX, lags(3) drift //stationary

dfuller DlnOGEX, lags(4) //stationary 
dfuller DlnOGEX, lags(4) trend //stationary
dfuller DlnOGEX, lags(4) drift //stationary 
dfuller D.DlnOGEX, lags(4) //stationary 
dfuller D.DlnOGEX, lags(4) trend //stationary 
dfuller D.DlnOGEX, lags(4) drift //stationary 

dfuller DlnINV, lags(4) // non-stationarity
dfuller DlnINV, lags(4) trend // non-stationarity******************
dfuller DlnINV, lags(4) drift // stationarity
dfuller D.DlnINV, lags(4) // non-stationarity
dfuller D.DlnINV, lags(4) trend // non-stationarity*****************
dfuller D.DlnINV, lags(4) drift // stationarity

dfuller DlnHUMCAP, lags(1) //stationary
dfuller DlnHUMCAP, lags(1) trend //stationary
dfuller DlnHUMCAP, lags(1) drift //stationary
dfuller D.DlnHUMCAP, lags(1) //stationary
dfuller D.DlnHUMCAP, lags(1) trend //stationary
dfuller D.DlnHUMCAP, lags(1) drift //stationary

dfuller DlnZ, lags(3) //stationary
dfuller DlnZ, lags(3) trend //stationary
dfuller DlnZ, lags(3) drift //stationary
dfuller D.DlnZ, lags(3) //non-stationary
dfuller D.DlnZ, lags(3) trend //stationary
dfuller D.DlnZ, lags(3) drift //stationary


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pperron DlnY, lags(3) //stationary
pperron DlnY, lags(3) trend //stationary
pperron D.DlnY, lags(3) //stationary
pperron D.DlnY, lags(3) trend //stationary

pperron DlnMEX, lags(3) //stationary
pperron DlnMEX, lags(3) trend //stationary
pperron D.DlnMEX, lags(3) //stationary
pperron D.DlnMEX, lags(3) trend //stationary

pperron DlnOGEX, lags(4) //stationary 
pperron DlnOGEX, lags(4) trend //stationary
pperron D.DlnOGEX, lags(4) //stationary 
pperron D.DlnOGEX, lags(4) trend //stationary 

pperron DlnINV, lags(4) //stationarity
pperron DlnINV, lags(4) trend // stationarity
pperron D.DlnINV, lags(4) // stationarity
pperron D.DlnINV, lags(4) trend // stationarity

pperron DlnHUMCAP, lags(1) //stationary
pperron DlnHUMCAP, lags(1) trend //stationary
pperron D.DlnHUMCAP, lags(1) //stationary
pperron D.DlnHUMCAP, lags(1) trend //stationary

pperron DlnZ, lags(3) //non-stationary
pperron DlnZ, lags(3) trend //non-stationary**************************
pperron D.DlnZ, lags(3) //stationary
pperron D.DlnZ, lags(3) trend //stationary


texdoc stlog "ModelLagOrder"
varsoc DlnY DlnMEX DlnOGEX DlnINV DlnHUMCAP DlnZ, maxlag(4) lutstats  //lag 1
texdoc stlog close 

texdoc stlog "Cointegration"
vecrank DlnY DlnMEX DlnOGEX DlnINV DlnHUMCAP DlnZ, lags(1) trend(none) //Decision rank 5
texdoc stlog close 

texdoc stlog "VEClongrun"
vec DlnY DlnMEX DlnOGEX DlnINV DlnHUMCAP DlnZ, rank(5) lag(2) trend(none) noetable //we have got it 
texdoc stlog close 
estimates store v1, title(VECM Estimation)

texdoc stlog "VECNORMmilex"
vecnorm
texdoc stlog close 

texdoc stlog "VECstablemilex"
vecstable
texdoc stlog close 

texdoc stlog "VECLMARmilex"
veclmar 
texdoc stlog close

esttab v1 using "VECshortrun.tex", unstack longtable nonumber  nomtitles title(VECM Short Run Coefficients) replace 

//Revise these statements
texdoc stlog "causality"
test ([D_DlnY]: LD.DlnMEX) //MILEX has short run effect on Economic Growth
test ([D_DlnMEX]: LD.DlnY) //Econ Growth has hort run effect on MILEX growth
//Bi-directional Causality 
test ([D_DlnOGEX]: LD.DlnMEX) //MILEX has short run effect on OGEX
test ([D_DlnMEX]: LD.DlnOGEX) //OGEX has short run effect on MILEX growth
//unidirectional causality 
test ([D_DlnINV]: LD.DlnMEX) //MILEX do not cause INV
test ([D_DlnMEX]: LD.DlnINV) //Investment Do not cause increase in Military Expenditure
// No causality 
test ([D_DlnHUMCAP]: LD.DlnMEX) //MILEX dont cause HUMCAP
test ([D_DlnMEX]: LD.DlnHUMCAP) //HUMCAP do not cause Military Expenditure
// No causality 
test ([D_DlnZ]: LD.DlnMEX) //OGE has short run effect on MEX
test ([D_DlnMEX]: LD.DlnZ) //Econ Growth has hort run effect on MILEX growth 
// No causality 
test ([D_DlnY]: LD.DlnOGEX) //OGEX has short run effect on Economic Growth
test ([D_DlnOGEX]: LD.DlnY) //Econ Growth has hort run effect on OGEX growth
texdoc stlog close 


texdoc close 
clear all

///////////////////////////////////////////////////////////////
//IRF 
irf create MEX1, step(20) set(vecMEXirf) replace 
irf graph oirf irf, impulse(DlnMEX) response(DlnMEX) 
graph export ImpulseResponseMEX.pdf, replace
irf graph oirf irf, impulse(DlnMEX) response(DlnY) 
graph export ImpulseResponseY.pdf, replace
irf graph oirf irf , impulse(DlnMEX) response(DlnOGEX) 
graph export ImpulseResponseOGEX.pdf, replace
irf graph oirf irf, impulse(DlnMEX) response(DlnINV) 
graph export ImpulseResponseINV.pdf, replace
irf graph oirf irf, impulse(DlnMEX) response(DlnHUMCAP) 
graph export ImpulseResponseHUMCAP.pdf, replace
irf graph oirf irf, impulse(DlnMEX) response(DlnZ) 
graph export ImpulseResponseZ.pdf, replace

irf table oirf irf, impulse(DlnMEX) response(DlnY DlnMEX DlnOGEX DlnINV DlnHUMCAP DlnZ) title(~)

texdoc stlog "OIRFtable"
irf table oirf, impulse(DlnMEX) response(DlnY DlnMEX DlnOGEX DlnINV DlnHUMCAP DlnZ)
texdoc stlog close 

texdoc stlog "IRFtable"
irf table irf, impulse(DlnMEX) response(DlnY DlnMEX DlnOGEX DlnINV DlnHUMCAP DlnZ) title(~)
texdoc stlog close 


