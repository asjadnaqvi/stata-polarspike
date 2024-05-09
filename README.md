![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-polarspike) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-polarspike) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-polarspike) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-polarspike) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-polarspike)

[Installation](#Installation) | [Syntax](#Syntax) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

![polarspike_banner](https://github.com/asjadnaqvi/stata-polarspike/assets/38498046/78634d47-c365-49bf-a283-0226eb402bc7)


# polarspike v1.0
(09 May 2024)


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

The SSC version (****):
```
coming soon
```

Or it can be installed from GitHub (**v1.0**):

```
net install polarspike, from("https://raw.githubusercontent.com/asjadnaqvi/stata-polarspike/main/installation/") replace
```


The `palettes` package is required to run this command:

```
ssc install palettes, replace
ssc install colrspace, replace
```

Even if you have the package installed, make sure that it is updated `ado update, update`.

If you want to make a clean figure, then it is advisable to load a clean scheme. These are several available and I personally use the following:

```
ssc install schemepack, replace
set scheme white_tableau  
```

You can also push the scheme directly into the graph using the `scheme(schemename)` option. See the help file for details or the example below.

I also prefer narrow fonts in figures with long labels. You can change this as follows:

```
graph set window fontface "Arial Narrow"
```


## Syntax

The syntax for the latest version is as follows:

```stata
polarspike var [if] [in], by(var1) [ over(var2) ]
                 [ radmin(num) radmax(num) rotate(num) gap(num) palette(str) lwidth(str) format(str)
                   labcolor(str) labgap(num) labsize(str) ocolor(str) ogap(num) osize(str) 
                   nolegend legsize(str) legposition(str) legcolumns(num) *
                ]

```

See the help file `help polarspike` for details.

The basic use for wide form is:

```
polarspike variables
```

and for long form is:

```
polarspike variable, by()
```

where `variable(s)` are a set of numeric variables.

## Examples

Pull the data:

```stata
use "https://github.com/asjadnaqvi/stata-polarspike/blob/main/data/gdp_per_capita.dta?raw=true", clear
```

Let's test the basic command:


```
polarspike rgdp_pc_ppp, by(countryname)
```

<img src="/figures/polarspike1.png" width="100%">


```
polarspike rgdp_pc_ppp, by(countryname) labgap(12) labsize(1) offset(10)
```

<img src="/figures/polarspike2.png" width="100%">


Rotation is great for optimizing the space:

```
polarspike rgdp_pc_ppp, by(countryname) labgap(8) labsize(1) offset(10) rotate(45)
```

<img src="/figures/polarspike3.png" width="100%">


Add colors by highlight different grouping in the graph:

```
polarspike rgdp_pc_ppp, by(countryname) labgap(8) labsize(1) offset(10) rotate(45) colorby(regionname)
```

<img src="/figures/polarspike4.png" width="100%">


```
polarspike rgdp_pc_ppp, by(countryname) labgap(8) labsize(1) offset(10) rotate(45) colorby(regionname) gap(0)
```

<img src="/figures/polarspike5.png" width="100%">


```
polarspike rgdp_pc_ppp, by(countryname) labgap(6) labsize(0.9) offset(10) rotate(45) colorby(regionname) gap(0) radmin(4) radmax(6)	///
	title("Real GDP per capita in 2022 (constant 2017 USD)") note("Source: World Bank Open Data", size(1.2))
```

<img src="/figures/polarspike6.png" width="100%">


```
polarspike rgdp_pc_ppp, by(countryname) labgap(6) labsize(0.9) offset(10) rotate(45) colorby(regionname) gap(0) radmin(4) radmax(6) nolegend	///
	title("Real GDP per capita in 2022 (constant 2017 USD)") note("Source: World Bank Open Data", size(1.2))
```

<img src="/figures/polarspike7.png" width="100%">


Condition the labels

```
polarspike rgdp_pc_ppp, by(countryname) labgap(6) labsize(0.9) offset(10) rotate(45) colorby(regionname) gap(0) radmin(4) radmax(6) nolegend	///
	title("Real GDP per capita in 2022 (constant 2017 USD)") note("Source: World Bank Open Data", size(1.2))
```

<img src="/figures/polarspike7.png" width="100%">



## Plotting change

```
polarspike change, by(countryname) labgap(6) labsize(0.9) offset(10) rotate(45) colorby(regionname) gap(0) radmin(4) radmax(6)	///
	title("5-year change in real GDP per capita (PPP) (2017-2022)") note("Source: World Bank Open Data", size(1.2))	
```

<img src="/figures/polarspike8.png" width="100%">


## Plotting by groups

```
polarspike rgdp_pc_ppp, by(countryname) over(regionname) labgap(8) labsize(1) offset(10) palette(CET C6) 	///
	title("Real GDP per capita in 2022 (constant 2017 USD)") note("Source: World Bank Open Data", size(1.2))
```

<img src="/figures/polarspike9.png" width="100%">

```
polarspike rgdp_pc_ppp, by(countryname) over(regionname) labgap(8) labsize(1) offset(10) palette(CET C6) radmin(4) radmax(7) 	///
	title("Real GDP per capita in 2022 (constant 2017 USD)") note("Source: World Bank Open Data", size(1.2))	
```

<img src="/figures/polarspike10.png" width="100%">



```
polarspike change, by(countryname) over(regionname) labgap(6) labsize(0.9) offset(10) palette(CET C7) radmin(4) radmax(7) 	///
	title("Real GDP per capita in 2022 (constant 2017 USD)") note("Source: World Bank Open Data", size(1.2))
```

<img src="/figures/polarspike11.png" width="100%">




## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-polarspike/issues) to report errors, feature enhancements, and/or other requests. 


## Change log

**v1.0 (09 May 2024)**
- First release





