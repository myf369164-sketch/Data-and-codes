// Declare panel data structure
xtset stkcd year

/*-------------------------
   Descriptive Statistics
-------------------------*/
// Basic descriptive statistics
sum gws gap sr iio cge size lev top1 board age growth cash dual audit mhold 

/*-------------------------
   Correlation Analysis and VIF
-------------------------*/
// Calculate correlation matrix
pwcorr gws gap sr iio cge size lev top1 board age growth cash dual audit mhold 

// Variance Inflation Factor (VIF) test
reg gws gap sr iio cge size lev top1 board age growth cash dual audit mhold 
estat vif

/*-------------------------
   Main Effect Model (Two-way Fixed Effects)
-------------------------*/
reghdfe gws gap size lev top1 board age growth cash dual audit mhold, absorb(stkcd year) vce(cluster stkcd)

/*-------------------------
   Moderation Effect Analysis
-------------------------*/
// Moderation by Slack Resources (SR)
reghdfe gws c.gap##c.sr size lev top1 board age growth cash dual audit mhold, absorb(stkcd year) vce(cluster stkcd)

// Moderation by Institutional Investor Ownership (IIO)
reghdfe gws c.gap##c.iio size lev top1 board age growth cash dual audit mhold, absorb(stkcd year) vce(cluster stkcd)

// Moderation by CEO Green Experience (CGE)
reghdfe gws c.gap##c.cge size lev top1 board age growth cash dual audit mhold, absorb(stkcd year) vce(cluster stkcd)

/*-------------------------
   Robustness Checks
-------------------------*/
// Alternative Dependent Variable (GWA)
reghdfe gwa gap size lev top1 board age growth cash dual audit mhold, absorb(stkcd year) vce(cluster stkcd)

// Alternative Independent Variable (GAP_S)
reghdfe gws gap_s size lev top1 board age growth cash dual audit mhold, absorb(stkcd year) vce(cluster stkcd)

/*-------------------------
   Endogeneity Tests
-------------------------*/
// Propensity Score Matching (PSM)
sum gap, meanonly
gen treat = (gap > r(mean)) if !missing(gap)

local match_vars "size lev top1 board age growth cash dual audit mhold"

// Perform Kernel Matching
psmatch2 treat `match_vars', logit kernel kerneltype(epan) bwidth(0.06) common

// Check balance (common support)
pstest `match_vars', treated(treat) both

// Regression on the matched sample (using kernel weights)
reghdfe gws gap `match_vars' [pweight=_weight] if _weight != ., absorb(stkcd year) vce(cluster stkcd)

// Double Machine Learning (DML)
// Note: The core DML estimation was primarily implemented in Python.

/*-------------------------
   Heterogeneity Analysis
-------------------------*/
// By Industry Environmental Sensitivity: Non-Polluting vs. Polluting
reghdfe gws gap size lev top1 board age growth cash dual audit mhold if pollute==0, absorb(stkcd year) vce(cluster stkcd)
reghdfe gws gap size lev top1 board age growth cash dual audit mhold if pollute==1, absorb(stkcd year) vce(cluster stkcd)

// By Industry Technology Intensity: Non-High-Tech vs. High-Tech
reghdfe gws gap size lev top1 board age growth cash dual audit mhold if hightech==0, absorb(stkcd year) vce(cluster stkcd)
reghdfe gws gap size lev top1 board age growth cash dual audit mhold if hightech==1, absorb(stkcd year) vce(cluster stkcd)