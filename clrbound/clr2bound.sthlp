{smcl}
{* *! version 1.0.0 30jul2013}{...}
{cmd:help clr2bound}{right: ({browse "http://www.stata-journal.com/article.html?article=st0369":SJ15-1: st0369})}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:clr2bound} {hline 2}}Compute two-sided bound estimates using Bonferroni's inequality{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab:clr2:bound ((}{it:lowerdepvar1 indepvars1 range1}{cmd:)}
	[{cmd:(}{it:lowerdepvar2 indepvars2 range2}{cmd:)} ...
	{cmd:(}{it:lowerdepvarN indepvarsN rangeN}{cmd:)}]{cmd:)}
	{cmd:(}{cmd:(}{it:upperdepvarN+1 indepvarsN+1 rangeN+1}{cmd:)}
	[{cmd:(}{it:upperdepvarN+2 indepvarsN+2 rangeN+2}{cmd:)} ...
	{cmd:(}{it:upperdepvarN+M indepvarsN+M rangeN+M}{cmd:)}]{cmd:)}
	{ifin}
	[{cmd:,}
	{cmdab:met:hod(}{cmd:series}|{cmd:local}{cmd:)}
	{cmd:notest}
	{cmd:null(}{it:real}{cmd:)}
	{cmdab:lev:el(}{it:numlist}{cmd:)}
	{cmd:noais}
	{opt mins:mooth(#)}
	{opt maxs:mooth(#)}
	{cmdab:nounders:mooth}
	{cmdab:band:width(}{it:#}{cmd:)}
	{opt rnd(#)}
	{cmd:norseed}
	{opt se:ed(#)}]	


{title:Description}

{pstd}
The command {cmd:clr2bound} estimates the two-sided intersection bounds of a
parameter.  The variables {it:lowerdepvar1}, ..., {it:lowerdepvarN} are the
dependent variables for the lower-bounding functions, and {it:upperdepvarN+1},
..., {it:upperdepvarN+M} are the dependent variables for the upper-bounding
functions.  The variables {it:indepvars1}, ..., {it:lowerdepvarN+M} refer to
explanatory variables for the corresponding dependent variables.
{cmd:clr2bound} allows for multidimensional {it:indepvars} for parametric
estimation but for only a one-dimensional independent variable for series and
local linear estimation.

{pstd}
The variables {it:range1}, ..., {it:rangeN+M} are sets of grid points over
which the bounding function is estimated.  The number of observations for the
{it:range} is not necessarily the same as the number of observations for the
{it:depvar} and {it:indepvars}.  The latter is the sample size, whereas the
former is the number of grid points to evaluate the maximum or minimum values
of the bounding functions.

{pstd}
Note that the parentheses must be used properly.  Variables for lower bounds
and upper bounds must be put in additional parentheses separately.  For
example, if there are two variable sets, say, {cmd:(}{it:ldepvar1}
{it:indepvars1} {it:range1}{cmd:)} and {cmd:(}{it:ldepvar2 indepvars2}
{it:range2}{cmd:)} for the lower-bounds estimation and one variable set, say,
{cmd:(}{it:udepvar1} {it:indepvars3} {it:range3}{cmd:)} for the upper-bounds
estimation, the right syntax for two-sided intersection bounds estimation is
{cmd:((}{it:ldepvar1} {it:indepvars1} {it:range1}{cmd:)} {cmd:(}{it:ldepvar2}
{it:indepvars2} {it:range2}{cmd:))} {cmd:((}{it:udepvar1 indepvars3}
{it:range3}{cmd:))}.

{pstd}
{cmd:clr2bound} requires the package {cmd:moremata}.  A user can install this
package by typing {cmd:ssc install moremata, replace} in the Stata Command
window; see {helpb moremata}.

{title:Options}

{phang}
{cmd:method(}{cmd:series}|{cmd:local}{cmd:)} specifies the method of
estimation.  By default, {cmd:clr2bound} will conduct parametric estimation.
When {cmd:method(series)} is specified, {cmd:clr2bound} will conduct series
estimation with cubic B-splines.  When {cmd:method(local)} is specified,
{cmd:clr2bound} will conduct local linear estimation.

{phang}
{opt notest} determines whether {cmd:clr2bound} conducts a test.
{cmd:clr2bound} provides a test for the null hypothesis that the specified
value is in the intersection bounds at the confidence levels specified in the
{cmd:level()} option below.  By default, {cmd:clr2bound} conducts the test.
Specifying this option causes {cmd:clr2bound} to output only Bonferroni
bounds.

{phang}
{opt null(real)} specifies the value for the parameter under the null
hypothesis of the test we described above.  The default is {cmd:null(0)}.

{phang}
{opt level(numlist)} specifies confidence levels.  {it:numlist} must contain
only real numbers between 0 and 1.  If this option is specified as
{cmd:level(0.5)}, the result is the half-median-unbiased estimator of the
parameter of the interest.  The default is {cmd:level(0.5 0.9 0.95 0.99)}.

{phang}
{cmd:noais} determines whether the adaptive inequality selection (AIS) should
be applied.  AIS helps to get sharper bounds by using the problem-dependent
cutoff to drop irrelevant grid points of the {it:range}.  The default is to
use AIS.

{phang}
{opt minsmooth(#)} and {opt maxsmooth(#)} specify the minimum and maximum
possible numbers of approximating functions considered in the cross-validation
procedure for B-splines.  Specifically, the number of approximating functions
is set to the minimizer of the leave-one-out least-squares cross-validation
score within this range.  For example, if a user inputs {cmd:minsmooth(5)} and
{cmd:maxsmooth(9)}, the number of approximating functions is chosen from the
set (5, 6, 7, 8, 9).  The procedure calculates this number separately for each
inequality.  The default is {cmd:minsmooth(5)} and {cmd:maxsmooth(20)}.  If
undersmoothing is performed, the number of approximating functions ultimately
used will be given by the largest integer smaller than the number of
approximating functions multiplied by the undersmoothing factor; see option
{cmd:noundersmooth} below.  This option is available for only series
estimation.

{phang}
{cmd:noundersmooth} determines whether undersmoothing is carried out, with the
default being to undersmooth.  In series estimation, undersmoothing is
implemented by first computing the number of approximating functions as the
minimizer of the leave-one-out least-squares cross-validation score.  The
{cmd:noundersmooth} option uses this number.  Without this option, we set the
number of approximating functions to K, which is given by the largest integer
that is less than or equal to the number of approximating functions times
n^1/5 times n^-2/7.  For local linear estimation, undersmoothing is done by
using the bandwidth multiplied by n^1/5 times n^-2/7 from original bandwidth.
This option is available for only series and local linear estimation.

{phang}
{opt bandwidth(#)} specifies the value of the bandwidth used in the local
linear estimation.  By default, {cmd:clr2bound} calculates a bandwidth for
each inequality.  With undersmoothing, we use the "rule-of-thumb" bandwidth.
When the {opt bandwidth(#)} is specified, {cmd:clr2bound} uses the given
bandwidth as the global bandwidth for every inequality.  This option is
available for only local linear estimation.

{phang}
{opt rnd(#)} specifies the number of columns of the random matrix generated
from the standard normal distribution.  This matrix is used to compute
critical values.  For example, if the number is 10,000 and the level is 0.95,
we choose the 0.95 quantile from 10,000 randomly generated elements.  The
default is {cmd:rnd(10000)}.

{phang}
{cmd:norseed} determines whether to reset the seed number for the simulation
used in the calculation.  For example, if a user wants to use this command for
simulations carried out as part of a Monte Carlo study, this command can be
used to prevent resetting the seed number in each Monte Carlo iteration.  The
default is to reset the seed number.

{phang}
{opt seed(#)} specifies the seed number for the random number generation
described above.  To prevent the estimation result from changing one
particular value to another randomly, {cmd:clr2bound} always initially
conducts {cmd:set seed} {it:#}.  The default is {cmd:seed(0)}.


{title:Stored results}

{pstd}
{cmd:clr2bound} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of  observations{p_end}
{synopt:{cmd:e(null)}}the null hypothesis{p_end}
{synopt:{cmd:e(l_ineq)}}{it:#} of inequality's in lower-bound estimation{p_end}
{synopt:{cmd:e(u_ineq)} }{it:#} of inequality's in upper-bound
estimation{p_end}
{synopt:{cmd:e(l_grid(i))}}{it:#} of grid points in (i) of
lower-bound estimation{p_end}
{synopt:{cmd:e(u_grid(i))}}{it:#} of grid points in (i) of upper-bound
estimation{p_end}
{synopt:{cmd:e(l_nf_x(i))}}{it:#} of approximate functions for lower-bound estimation at x(i){p_end}
{synopt:{cmd:e(u_nf_x(i))}}{it:#} of approximate functions for upper-bound
estimation at x(i){p_end}
{synopt:{cmd:e(l_bdwh(i))}}bandwidth for (i) of lower-bound estimation{p_end}
{synopt:{cmd:e(u_bdwh(i))}}bandwidth for (i) of upper-bound estimation{p_end}
{synopt:{cmd:e(lbd(lev))}}estimation results of lower-bound estimation{p_end}
{synopt:{cmd:e(ubd(lev))}}estimation results of upper-bound estimation{p_end}
{synopt:{cmd:e(lcl(lev))}}critical value of lower-bound estimation{p_end}
{synopt:{cmd:e(ucl(lev))}}critical value of upper-bound estimation{p_end}
{synopt:{cmd:e(t_det(lev))}}{cmd:1}: in the bound, {cmd:0}: not{p_end}
{synopt:{cmd:e(t_cvl(lev))}}critical value of test{p_end}
{synopt:{cmd:e(t_bd(lev))}}estimation results of test{p_end}
{synopt:{cmd:e(t_nf_x(i))}}{it:#} of approximate functions in test{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)} }{cmd:clr2bound}{p_end}
{synopt:{cmd:e(ldepvar)}}dependent variable in lower-bound estimation{p_end}
{synopt:{cmd:e(udepvar)}}dependent variable in upper-bound estimation{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(level)}}confidence levels{p_end}
{synopt:{cmd:e(smoothing)}}{cmd:(not) Undersmoothed}{p_end}
{synopt:{cmd:e(l_indep(i))}}independent variable in (i) of lower-bound estimation{p_end}
{synopt:{cmd:e(u_indep(i))}}independent variable in (i) of upper-bound
estimation{p_end}
{synopt:{cmd:e(l_range(i))}}range in (i) of lower-bound estimation{p_end}
{synopt:{cmd:e(u_range(i))}}range in (i) of upper-bound estimation{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(l_omega)}}hat Omega_n for lower-bound estimation{p_end}
{synopt:{cmd:e(u_omega)}}hat Omega_n for upper-bound estimation{p_end}
{synopt:{cmd:e(l_theta(i))}}hat theta_n(v) for each v in lower-bound estimation{p_end}
{synopt:{cmd:e(u_theta(i))}}hat theta_n(v) for each v in upper-bound estimation{p_end}
{synopt:{cmd:e(l_se(i))}}s_n(v) for each v in lower-bound estimation{p_end}
{synopt:{cmd:e(u_se(i))}}s_n(v) for each v in upper-bound estimation{p_end}
{synopt:{cmd:e(l_ais(i))}}AIS result for each v in lower-bound
estimation{p_end}
{synopt:{cmd:e(u_ais(i))}}AIS result for each v in upper-bound
estimation{p_end}
{synopt:{cmd:e(t_omega)}}hat Omega_n for test{p_end}
{synopt:{cmd:e(t_theta(i))}}hat theta_n(v) for each v in test{p_end}
{synopt:{cmd:e(t_se(i))}}s_n(v) for each v in test{p_end}
{synopt:{cmd:e(t_ais(i))}}AIS result for each v in test{p_end}
{p2colreset}{...}


{title:Authors}

{pstd}Victor Chernozhukov{p_end}
{pstd}Massachusetts Institute of Technology{p_end}
{pstd}Cambridge, MA{p_end}
{pstd}vchern@mit.edu

{pstd}Wooyoung Kim{p_end}
{pstd}University of Wisconsin-Madison{p_end}
{pstd}Madison, WI{p_end}
{pstd}wkim68@wisc.edu

{pstd}Sokbae Lee{p_end}
{pstd}Institute for Fiscal Studies and{p_end}
{pstd}Seoul National University{p_end}
{pstd}Seoul, Korea{p_end}
{pstd}sokbae@snu.ac.kr
  
{pstd}Adam M. Rosen{p_end}
{pstd}University College London and{p_end}
{pstd}Centre for Microdata Methods and Practice{p_end}
{pstd}London, UK{p_end}
{pstd}adam.rosen@ucl.ac.uk


{title:Also see}

{p 4 14 2}Article:  {it:Stata Journal}, volume 15, number 1: {browse "http://www.stata-journal.com/article.html?article=st0369":st0369}{p_end}
