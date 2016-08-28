
# DROUGHT-AWAP-GRIDS    

- Creator: Ivan Hanigan
- Contact Email:        ivan.hanigan@gmail.com

Abstract: 
===

- Aim: To update the Australian drought dataset. Background: The old project DROUGHT BOM-GRIDS 
- Methods: Using the Hutchinson Drought Index (Hanigan, I., Porfirio, L. and Hutchinson, M. (2012). The Hutchinson Drought Index Algorithm. https://github.com/ivanhanigan/HutchinsonDroughtIndex) compute the Drought Indices. Use the same 25km grids as the old BOM-GRIDS dataset, but use the new AWAP-GRIDS data.
- License: CC-By Attribution 4.0 International

Requires:
===

1. `DROUGHT-BOM-GRIDS`, https://github.com/swish-climate-impact-assessment/DROUGHT-BOM-GRIDS, for the grid shapefiles
1. `AWAPTOOLS`, https://github.com/swish-climate-impact-assessment/awaptools, to download and format the grids
1. `AWAP_GRIDS`, https://github.com/swish-climate-impact-assessment/AWAP_GRIDS, to run `awaptools`, for the monthly total rainfall grids
1. `HutchinsonDroughtIndex`, https://osf.io/pyts3/, for computing the indices
