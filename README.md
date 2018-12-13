# Package : "hctn"
## Description
This package allows you to see from a Shiny application the distribuation of variables (nb of beds , nbr of doctors ,...) thanks to an interactive MAP of Tunisia.

## Installation 
1- First, you need to install the devtools package. You can do this from CRAN. Invoke R and then type
```
install.packages("devtools")
```
2- Load the devtools package
```
library(devtools)
```
3- Install **htcs** from github
```
install_github("AhmedSaad95/hctn")
```
## Dependencies
This list contains the packages that my package needs to work
```
library(shiny)
library(shinythemes)
library(DT)
library(leaflet)
library(RColorBrewer)
library(readr)
```
## map_tn Function
The Output of this Function is a Shiny Application that contains MAP that present the healthcare situation of Tunisia
```
map_tn()
```
## Capture
<p align="center">
<img src="Capture2.PNG" width="800">
</p>
