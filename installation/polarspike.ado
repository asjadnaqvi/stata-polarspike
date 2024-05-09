*! polarspike v1.0 (05 May 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.0 (05 May 2024): First release

**********************************


cap program drop polarspike


program polarspike, sortpreserve

version 15
 
	syntax varlist(min=1 max=1 numeric) [if] [in], by(varname) 						  ///
		[ over(varname) radmin(real 5) radmax(real 10) gap(real 2) ROtate(real 0)  	] ///
		[ LWidth(string) palette(string) offset(real 5) format(string)	 			] ///
		[ LABGap(real 5) LABSize(string) LABColor(string) labcond(real -1e15) 		] ///
		[ colorby(varname) LEGPOSition(real 6) LEGCOLumns(real 3) LEGSize(string) NOLEGend	] ///
		[ OGap(real 0.9) OSize(string) OColor(string) 					 			] ///
		[ aspect(real 1) xsize(real 1) ysize(real 1) scheme(passthru) note(passthru) subtitle(passthru)	*	]  

		
	// check dependencies
	capture findfile colorpalette.ado
	if _rc != 0 {
		display as error "The {bf:palettes} package is missing. Install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}
	
	
	if "`over'"!="" & "`colorby'"!="" {
		display as error "Only one of {bf:over()} or {bf:colorby()} can be specified."
		exit
	}
	
	if `radmin' >= `radmax' {
		di as error  "{bf:radmin()} >= {bf:radmax()}. "	
		exit 
	}

	if "`radmin'" == "0" local radmin 0.001 // to avoid irregular outputs.


	
	marksample touse, strok
	
quietly {	
preserve


	keep if `touse'
	
	local ovtrack = 1
	
	if "`over'"=="" {
		gen _over = 1
		local over _over
		local ovtrack = 0
	}
	
	
	
	keep `varlist' `by' `over' `colorby'
	
	cap confirm numeric var `over'	
		if !_rc {        // if numeric
			if "`: value label `by''" != "" {   // with val labels
				
				decode `over', gen(_ov2)		
				drop `over'
				local over _ov2
			}
			else {				// without val labels
				gen _ov2 = string(`over')
				drop `over'
				local over _ov2
			}
		}
		
	
	
	if "`colorby'"=="" {
		gen _colorby = 1
		local colorby _colorby
		local clrbytrack = 0
	}
	else {
		local clrbytrack = 1
		cap confirm numeric var `over'	
		
		if !_rc {        // if numeric
			gen _clrby = `colorby'
			local colorby _clrby
			}
		else {				// without val labels
			encode `colorby', gen(_clrby)
			drop `colorby'
			local colorby _clrby
		}
		
	}	
	

	
	collapse (sum) `varlist' (mean) `colorby', by(`by' `over')
	
	sort `over' `varlist' `by'
	
	
	gen double _angle = _n  / _N   
	
	egen _grps = group(`over')
	replace _angle = _angle + (_grps) * `gap' / 100 
	
	summ _angle, meanonly
	replace _angle = (_angle / `r(max)') * (2 * _pi) + (`rotate' * _pi / 180)
	
	
	**** add over names

	egen tag = tag(`over')
	recode tag (0=.)

	gen double _xcont     = .
	gen double _ycont     = .
	gen double _anglecont = .

	levelsof `over' if tag==1, local(lvls)

	foreach x of local lvls {

		summ _angle if `over' == "`x'", meanonly

		replace _anglecont = (`r(max)' + `r(min)') / 2 				if tag==1 & `over'== "`x'"
		replace _xcont 	   = (`radmin' * `ogap' * cos(_anglecont)) 	if tag==1 & `over'== "`x'"
		replace _ycont 	   = (`radmin' * `ogap' * sin(_anglecont)) 	if tag==1 & `over'== "`x'"

	}
	
	

		
	// mod the angles
	replace _angle 	   = mod(    _angle, 2 * _pi)
	replace _anglecont = mod(_anglecont, 2 * _pi)
	
	
	// generate the spikes
	summ `varlist', meanonly
	local height = `r(max)'
	
	gen double _radius = `varlist' / `height'
	
	
	*** rescale radius to (a,b) = ((b - a)(x - xmin)/(xmax - xmin)) + a	
	replace _radius = ((`radmax' - `radmin') * (_radius - 0) / (1 - 0)) + `radmin'	
	

	gen double _xcir = `radmin' * cos(_angle)
	gen double _ycir = `radmin' * sin(_angle)

	gen double _xval =  _radius  * cos(_angle)
	gen double _yval =  _radius  * sin(_angle)	

	
	// add the labels
	if "`format'"  == "" local format %15.0fc
		
	gen _mylab = `by' + " (" + string(`varlist', "`format'") + ")" 
	gen double _length = length(_mylab)
	summ _length, meanonly	
	replace _length = _length / r(max)
		
	gen double _xlab = ((_radius + _length) * (1 + `labgap'/100)) * cos(_angle)
	gen double _ylab = ((_radius + _length) * (1 + `labgap'/100)) * sin(_angle)
	
	replace _xlab = ((`radmin' + _length) * (1 + `labgap'/100)) * cos(_angle) if `varlist' < 0
	replace _ylab = ((`radmin' + _length) * (1 + `labgap'/100)) * sin(_angle) if `varlist' < 0 
	
	
	// rotate angles by quadrants
	gen double 	_angle2 = (_angle  * (180 / _pi)) - 180
	replace 	_angle2 =  _angle2 + 180 				if _xlab > 0
	

	
	**************************
	** 		Final graph 	**
	**************************		
		
	if "`lwidth'" =="" local lwidth 0.6
	if "`palette'" == "" {
		local palette tableau
	}
	else {
		tokenize "`palette'", p(",")
		local palette  `1'
		local poptions `3'
	}
	
	if "`labcolor'" == "" local labcolor 	black
	if "`labsize'" 	== "" local labsize 	1.1
	if "`ocolor'" 	== "" local ocolor 		black
	if "`osize'" 	== "" local osize 		1.1	

	if "`legsize'" 	== "" local legsize 	1.5
	
	// spikes	

	local cont

	
	if "`clrbytrack'" == "0" {
		levelsof `over', local(lvls)		
		local items = `r(r)'
	}
	else {
		levelsof `colorby', local(lvls)		
		local items = `r(r)'	
	}
	
	
	local i = 1

	foreach x of local lvls {
		
		colorpalette `palette', n("`items'") nograph `options'
		
		if "`clrbytrack'" == "0" {
			local cont `cont' (pcspike _yval _xval _ycir _xcir if `over' =="`x'", lc("`r(p`i')'") lw(`lwidth'))  
		}
		else {
			local cont `cont' (pcspike _yval _xval _ycir _xcir if `colorby' ==`x', lc("`r(p`i')'") lw(`lwidth'))  
		}
		
		local ++i
	}
			
	

	
	// by labels		

	forval i = 1/`=_N' {
		summ _angle2 in `i' , meanonly
		local labs2 `labs2' (scatter _ylab _xlab if _n==`i' & _xlab >= 0 & `varlist' > `labcond', mc(none) mlabel(_mylab) mlabangle(`r(mean)') mlabpos(0) mlabgap(zero) mlabcolor("`labcolor'") mlabsize(`labsize'))  
		local labs2 `labs2' (scatter _ylab _xlab if _n==`i' & _xlab <  0 & `varlist' > `labcond', mc(none) mlabel(_mylab) mlabangle(`r(mean)') mlabpos(0) mlabgap(zero) mlabcolor("`labcolor'") mlabsize(`labsize')) 
	}			
			
	// over labels		

	if `ovtrack' != 0 {
		levelsof `over' if tag==1, local(lvls)

		foreach x of local lvls {
			summ _anglecont if `over'== "`x'" & tag==1, meanonly // fix these angles
			local myangle = (`r(mean)'  * (180 / _pi)) - 90
			
			local labcont `labcont' (scatter _ycont _xcont if `over'== "`x'" & tag==1, mc(none) mlabel(`over') mlabangle(`myangle') mlabpos(0)  mlabcolor("`ocolor'") mlabsize(`osize')) 
			
		}			
	}
	
	
	// fix the legend
	
	if "`clrbytrack'" == "0" | "`nolegend'"!="" {
		local mylegend legend(off)
	}
	else {
		gen _id = _n
		levelsof `colorby', local(lvls)
		
		foreach x of local lvls {
			local varn : label `colorby' `x'
			local entries `" `entries' `x'  "`varn'"  "'	
		}
		local mylegend legend(order("`entries'") pos(`legposition') size(`legsize') col(`legcolumns')) 
	}
	
	
	
	// extend the axes
	
	summ _xval, meanonly
	local xlimits = max(r(max), abs(r(min))) 
	
	summ _yval, meanonly
	local ylimits = max(r(max), abs(r(min))) 
	
	
	local edge = max(`xlimits', `ylimits') * (1 + (`offset' / 100))
	
	
	
	// final	

	twoway ///
		`cont' ///
		`labs2' ///
		`labcont' ///
			, ///
			yscale(noline range(-`edge' `edge')) ///
			xscale(noline range(-`edge' `edge')) ///
			xlabel(-`edge' `edge', nogrid) ///
			ylabel(-`edge' `edge', nogrid) /// 
			yscale(off) xscale(off)	///
			`mylegend'	///
			xsize(`xsize') ysize(`ysize') aspect(`aspect') ///
			`options'  `scheme' `note'
							
		
*/
restore			
}

end



*********************************
******** END OF PROGRAM *********
*********************************


