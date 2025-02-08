{smcl}
{* *! version 1.0.0 30jul2013}{...}
{cmd:help clrtest}{right: ({browse "http://www.stata-journal.com/article.html?article=st0369":SJ15-1: st0369})}
{hline}

{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{cmd:clrtest} {hline 2}}Test the hypothesis that the maximum of lower intersection bounds is nonpositive{p_end}
{p2colreset}{...}

{title:Syntax}
{p 8 17 2}
{cmd:clrtest (}{it:depvar1 indepvars1 range1}{cmd:)}
	[{cmd:(}{it:depvar2 indepvars2 range2}{cmd:)} ...
	{cmd:(}{it:depvarN indepvarsN rangeN}{cmd:)}]
	{ifin}
	[{cmd:,}
	{{cmdab:low:er}|{cmdab:upp:er}}
	{cmdab:met:hod(}{cmd:series}|{cmd:local}{cmd:)}
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
{cmd:clrtest} offers a more comprehensive testing procedure than
{cmd:clr2bound} does.  It returns the output and includes information on
whether the result of the lower-intersection bound estimation deducted from
the given {it:depvar}'s and confidence levels is smaller than 0.  For
example, suppose that one wants to test the null hypothesis that 0.59 is in
the 95% confidence interval for {cmd:yl} and {cmd:yu}.  To test this, one can
make two inequalities, {cmd:yl_test} = {cmd:yl} - 0.59 and {cmd:yu_test} =
0.59 - {cmd:yu}.  If the resulting estimator is larger than 0, the procedure
rejects the null hypothesis.  The variables are defined similarly as in
{cmd:clr2bound}; see {helpb clr2bound}.  {cmd:clrtest} requires the
package {cmd:moremata}.


{title:Options}

{phang}
{cmd:lower} and {cmd:upper} specify whether the estimation is for the lower
bound or the upper bound.  By default, it will return the upper-intersection
bound.  If {cmd:lower} is specified, {cmd:clrtest} will return the
lower-intersection bound.

{phang}
{cmd:method(}{cmd:series}|{cmd:local}{cmd:)} specifies the method of
estimation.  By default, {cmd:clrtest} will conduct parametric estimation.  If
{cmd:method(series)} is specified, {cmd:clrtest} will conduct series
estimation with cubic B-splines.  If {cmd:method(local)} is specified,
{cmd:clrtest} will conduct local linear estimation.

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
linear estimation.  By default, {cmd:clrtest} calculates a bandwidth for each
inequality.  With undersmoothing, we use the "rule-of-thumb" bandwidth.  When
the {opt bandwidth(#)} is specified, {cmd:clrtest} uses the given bandwidth as
the global bandwidth for every inequality.  This option is available for only
local linear estimation.

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
particular value to another randomly, {cmd:clrtest} always initially conducts
{cmd:set seed} {it:#}.  The default is {cmd:seed(0)}.


{title:Stored results}

{pstd}
{cmd:clrtest} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of  observations{p_end}
{synopt:{cmd:e(n_ineq)}}{it:#} of inequality{p_end}
{synopt:{cmd:e(grid(i))}}{it:#} of grids points (i){p_end}
{synopt:{cmd:e(nf_x(i))}}{it:#} of approximate functions in (i){p_end}
{synopt:{cmd:e(bd(lev))}}results of estimation{p_end}
{synopt:{cmd:e(cl(lev))}}critical value{p_end}
{synopt:{cmd:e(bdwh(i))}}bandwidth for (i){p_end}
{synopt:{cmd:e(det(lev))}}rejected: {cmd:0}, not rejected: {cmd:1}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)} }{cmd:clrtest}{p_end}
{synopt:{cmd:e(depvar)}}dependent variables{p_end}
{synopt:{cmd:e(indep(i))}}independent variables in (i){p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(level)}}confidence levels{p_end}
{synopt:{cmd:e(smoothing)}}{cmd:(not) Undersmoothed}{p_end}
{synopt:{cmd:e(range(i))}}range in (i){p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(omega)}}hat Omega_n{p_end}
{synopt:{cmd:e(theta(i))}}hat theta_n(v) for each v{p_end}
{synopt:{cmd:e(se(i))}}s_n(v) for each v{p_end}
{synopt:{cmd:e(ais(i))}}AIS result for each v{p_end}
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
