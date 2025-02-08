{smcl}
{* *! version 1.0.0 30jul2013}{...}
{cmd:help clr3bound}{right: ({browse "http://www.stata-journal.com/article.html?article=st0369":SJ15-1: st0369})}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:clr3bound} {hline 2}}Compute two-sided bound estimates by inverting clrtest{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab:clr3:bound ((}{it:lowerdepvar1 indepvars1 range1}{cmd:)}
	[{cmd:(}{it:lowerdepvar2 indepvars2 range2}{cmd:)} ...
	{cmd:(}{it:lowerdepvarN indepvarsN rangeN}{cmd:)}]{cmd:)}
	{cmd:(}{cmd:(}{it:upperdepvarN+1 indepvarsN+1 rangeN+1}{cmd:)}
	[{cmd:(}{it:upperdepvarN+2 indepvarsN+2 rangeN+2}{cmd:)} ...
	{cmd:(}{it:upperdepvarN+M indepvarsN+M rangeN+M}{cmd:)}]{cmd:)}
	{ifin}
	[{cmd:,}
	{opt step:size(#)}
	{cmdab:met:hod(}{cmd:series}|{cmd:local}{cmd:)}
	{cmdab:lev:el(}{it:#}{cmd:)}
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
{cmd:clr3bound} estimates the two-sided intersection bound of a parameter by
carrying out pointwise tests using the {cmd:clrtest} command.  Note that there
is no need to implement pointwise tests for one-sided intersection bounds.  In
this case, the command {cmd:clrbound} estimates tight bounds.

{pstd}
Because this command is relevant for only two-sided intersection bounds, a
user should input variables for both lower and upper bounds to calculate the
bound.  The variables are defined similarly as in {cmd:clr2bound}.  This
command generally provides tighter bounds than those provided by the
{cmd:clrtest} command over equispaced grids, which employ Bonferroni's
inequality.  Unlike the previous commands, {cmd:clr3bound} can deal with only
one confidence level.  {cmd:clr3bound} requires package {cmd:moremata}; see
{helpb moremata}.


{title:Options}

{phang}
{opt stepsize(#)} specifies the distance between two consecutive grid points.
The procedure divides Bonferroni's bound into equidistanced grids and
implements the {cmd:clrtest} command for each grid point to determine a
possible tighter bound.  The default is {cmd:stepsize(0.01)}.

{phang}
{cmd:method(series}|{cmd:local)} specifies the method of estimation.  By
default, {cmd:clr3bound} will conduct parametric estimation.  If
{cmd:method(series)} is specified, {cmd:clr3bound} will conduct series
estimation with cubic B-splines.  If {cmd:method(local)} is specified,
{cmd:clr3bound} will conduct local linear estimation.

{phang}
{opt level(#)} specifies the confidence level of the estimation.  Different
from previous commands, {cmd:clr3bound} can deal with only one confidence
level.  The default is {cmd:level(0.95)}.

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
linear estimation.  By default, {cmd:clr3bound} calculates a bandwidth for
each inequality.  With undersmoothing, we use the "rule-of-thumb" bandwidth.
When the {opt bandwidth(#)} is specified, {cmd:clr3bound} uses the given
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
particular value to another randomly, {cmd:clr3bound} always initially
conducts {cmd:set seed} {it:#}.  The default is {cmd:seed(0)}.


{title:Stored results}

{pstd}
{cmd:clr3bound} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}} number of  observations{p_end}
{synopt:{cmd:e(step)}} step size{p_end}
{synopt:{cmd:e(level)}} confidence level{p_end}
{synopt:{cmd:e(l_ineq)}} {it:#} of inequality's in lower-bound estimation{p_end}
{synopt:{cmd:e(u_ineq)} } {it:#} of inequality's in upper-bound estimation{p_end}
{synopt:{cmd:e(l_grid(i))}} {it:#} of grids points for lower-bound estimation at observation
(i){p_end}
{synopt:{cmd:e(u_grid(i))}} {it:#} of grids points for upper-bound estimation at observation
(i){p_end}
{synopt:{cmd:e(l_nf_x(i))}} {it:#} of approximate functions in (i) of
lower-bound estimation{p_end}
{synopt:{cmd:e(u_nf_x(i))}} {it:#} of approximate functions in (i) of upper-bound estimation{p_end}
{synopt:{cmd:e(l_bdwh(i))}} bandwidth for (i) of lower-bound estimation{p_end}
{synopt:{cmd:e(u_bdwh(i))}} bandwidth for (i) of upper-bound estimation{p_end}
{synopt:{cmd:e(lbd)}} estimation results of lower-bound estimation{p_end}
{synopt:{cmd:e(ubd)}} estimation results of upper-bound estimation{p_end}
{synopt:{cmd:e(lbd(lev))}} Bonferroni results of lower-bound estimation{p_end}
{synopt:{cmd:e(ubd(lev))}} Bonferroni results of upper-bound estimation{p_end}
{synopt:{cmd:e(lcl(lev))}} critical value of lower-bound estimation{p_end}
{synopt:{cmd:e(ucl(lev))}} critical value of upper-bound estimation{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)} } {cmd:clr3bound}{p_end}
{synopt:{cmd:e(title)}}      title in estimation output{p_end}
{synopt:{cmd:e(ldepvar)}} dependent variable in lower-bound estimation{p_end}
{synopt:{cmd:e(udepvar)}} dependent variable in upper-bound estimation{p_end}
{synopt:{cmd:e(method)}} estimation method{p_end}
{synopt:{cmd:e(smoothing)}} {cmd:(not) Undersmoothed}{p_end}
{synopt:{cmd:e(l_indep(i))}} independent variable in (i) of lower-bound estimation{p_end}
{synopt:{cmd:e(u_indep(i))}} independent variable in (i) of upper-bound estimation{p_end}
{synopt:{cmd:e(l_range(i))}} range in (i) of lower-bound estimation{p_end}
{synopt:{cmd:e(u_range(i))}} range in (i) of upper-bound estimation{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(l_omega)}} hat Omega_n for lower-bound estimation{p_end}
{synopt:{cmd:e(u_omega)}} hat Omega_n for upper-bound estimation{p_end}
{synopt:{cmd:e(l_theta(i))}} hat theta_n(v) for each v in lower-bound
estimation{p_end}
{synopt:{cmd:e(u_theta(i))}} hat theta_n(v) for each v in upper-bound estimation{p_end}
{synopt:{cmd:e(l_se(i))}} s_n(v) for each v in lower-bound estimation{p_end}
{synopt:{cmd:e(u_se(i))}} s_n(v) for each v in upper-bound estimation{p_end}
{synopt:{cmd:e(l_ais(i))}} AIS result for each v in lower-bound estimation{p_end}
{synopt:{cmd:e(u_ais(i))}} AIS result for each v in upper-bound estimation{p_end}
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
