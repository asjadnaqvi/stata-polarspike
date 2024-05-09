{smcl}
{* 09May2024}{...}
{hi:help polarspike}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-polarspike":polarspike v1.0 (GitHub)}}

{hline}

{title:polarspike}: A Stata package for polar spike graphs.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:polarspike} {it:var} {ifin}, {cmd:by}({it:var1}) [ {cmd:over}({it:var2}) ]
                 {cmd:[} {cmd:radmin}({it:num}) {cmd:radmax}({it:num}) {cmdab:ro:tate}({it:num}) {cmd:gap}({it:num}) {cmd:palette}({it:str}) {cmdab:lw:idth}({it:str}) {cmd:format}({it:str})
                   {cmdab:labc:olor}({it:str}) {cmdab:labg:ap}({it:num}) {cmdab:labs:ize}({it:str}) {cmdab:oc:olor}({it:str}) {cmdab:og:ap}({it:num}) {cmdab:os:ize}({it:str}) 
                   {cmdab:noleg:end} {cmdab:legs:ize}({it:str}) {cmdab:legpos:ition}({it:str}) {cmdab:legcol:umns}({it:num}) *
                {cmd:]}

{p 4 4 2}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt polarspike var, by(var1)} {opt over(var2)}}The minimum syntax requires defining a numerical {it:var} variable. The placement around the circle is determined by the {it:by(var1)} variable.
The spikes can be grouped by the {opt over(var2)} variable. If there is more data than is required, then the program will collapse the data using the sum value of the {opt var} by {opt var1()} and {opt var2()}.
If you want other ways of summarizing the variables, then it is highly recommended to prepare the data beforehand.{p_end}

{p2coldent : {opt radmin(num)} {opt radmax(num)}}The spikes are scaled between a minimum and a maximum radius defined by {opt radmin()} and {opt radmax()} respectively. 
{opt radmin()} can be set to 0 to start from the origin. Default values are {opt radmin(5)} and {opt radmax(10)}.{p_end}

{p2coldent : {opt ro:tate(num)}}Rotate the whole graph by {it:num} degrees. For example, {opt ro(30)} is a 30 degree anti-clockwise rotation. Default is {opt ro(0)}.{p_end}

{p2coldent : {opt gap(num)}}A gap in degrees between the spike groups defined by {opt over()}. For example, {opt gap(2)} will space the spikes by 2 degrees. Default is {opt gap(5)}.{p_end}

{p2coldent : {opt palette(str)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette tableau:{it:tableau}}.{p_end}

{p2coldent : {opt colorby(var)}}Color spikes by the {opt colorby(var)}. This option only works if {opt over()} is not specified. This will also automatically enable the legend.{p_end}

{p2coldent : {opt format(str)}}Format the values of the spike labels category. Default value is {opt format(%15.0f)}.{p_end}

{p2coldent : {opt lw:idth(str)}}Line width of the spikes. Default value is {opt lw(0.6)}. Depending on the number of spikes on the graph, this might need to be adjusted.{p_end}

{p2coldent : {opt offset(num)}}Offset the axes for a percentage of the maximum extent. Default is {opt offset(5)} for 5%.{p_end}

{p2coldent : {opt labg:ap(num)}}Gap of the spike labels. Default value is {opt labg(5)} for 5% of the radius of the largest slice.{p_end}

{p2coldent : {opt labs:ize(str)}}Size of the spike labels. Default value is {opt labs(1.1)}.{p_end}

{p2coldent : {opt labc:olor(str)}}Color of the spike labels. Default value is {opt labc(black)}.{p_end}

{p2coldent : {opt labcond:ition(num)}}Values less than {labcond()} are not shown. Default is a very large negative value.{p_end}

{p2coldent : {opt og:ap(num)}}Gap of the {opt over()} categories. Default value is {opt ogap(0.9)} or 90% of the {opt radmin()} value.{p_end}

{p2coldent : {opt os:ize(str)}}Size of the {opt over()} categories. Default value is {opt osize(1.1)}.{p_end}

{p2coldent : {opt oc:olor(str)}}Color of the {opt over()} labels. Default value is {opt ocolor(black)}.{p_end}

{p2coldent : {opt legcol:umns(num)}}Number of legend rows. Default is {opt legcol(3)}.{p_end}

{p2coldent : {opt legs:ize(str)}}Size of legend entries. Default is {opt legs(1.5)}.{p_end}

{p2coldent : {opt legpos:ition(str)}}Position of legend. Default is {opt legpos(6)} for 6 o' clock.{p_end}

{p2coldent : {opt noleg:end}}Turn off the legend.{p_end}

{p2coldent : {opt *}}All other standard twoway options unless overwritten by the program.{p_end}


{synoptline}
{p2colreset}{...}


{title:Dependencies}

The {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palette} package (Jann 2018, 2022) is required:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have these installed, it is highly recommended to update the dependencies:
{stata ado update, update}

{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-polarspike":GitHub}.


{hline}


{title:Package details}

Version      : {bf:polarspike} v1.0
This release : 09 May 2024
First release: 09 May 2024
Repository   : {browse "https://github.com/asjadnaqvi/stata-polarspike":GitHub}
Keywords     : Stata, polar spike graphs
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-polarspike/issues":GitHub} by opening a new issue.

{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: an update}. University of Bern Social Sciences Working Papers No. 43. 

{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb joyplot}, 
	{helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb streamplot}, {helpb sunburst}, {helpb treecluster}, {helpb treemap}, {helpb waffle}


