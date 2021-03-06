# varpro2

A reasonably fast MATLAB implementation of the variable
projection algorithm VARP2 for separable nonlinear 
least squares optimization problems.

## About

This software allows you to efficiently solve
least squares problems in which the dependence
on some parameters is nonlinear and the 
dependence on others is linear. In particular,
this software allows you to solve problems 
of the form

> min_{a,B} |X - F(a) B|_F^2 + | R*a |_2^2 

where X is a data matrix of size m by n, F(a)
is a matrix-valued function (matrices of dimension
m by l) with vector input a (the dependence on the 
entries of a may be nonlinear), R is a matrix,
and B is a l by n matrix. What the code requires 
is a function for evaluating F(a) and dF(a)/da_i for 
any i (see code documentation for more detail).
It is often the case that dF(a)/da_i is a sparse 
matrix. In that case, it is recommended to return 
a sparse matrix. The term with R is optional and 
may be specified with either a scalar (corresponding 
to Tikhonov regularization) or a matrix.


The VARP2 algorithm is based on the following 
conference proceedings report: 

> Extensions and 
> Uses of the Variable Projection Algorith for 
> Solving Nonlinear Least Squares Problems 
> by G. H. Golub and R. J. LeVeque ARO Report 79-3, 
> Proceedings of the 1979 Army Numerical Analsysis 
> and Computers Conference.

The algorithm is based on the Levenberg-Marquardt
algorithm and an explicit formula for the Jacobian.
Note that as the problem may be nonconvex, what the
algorithm finds is a local minimum.

## How to use

If you'd like to see how to use VARPRO2
the best place to start is to check out simple_example.m
(in "example" folder)

## Updates

Feel free to submit bug-fix/feature requests through
the issues tab on GitHub.

## Citing this software

We ask that you cite this software [![DOI](https://zenodo.org/badge/101695637.svg)](https://zenodo.org/badge/latestdoi/101695637) 
and the original Golub and LeVeque paper (see above) 
if you use this software as part of academic research.

## License 

The files in the "src" and "examples" directories are available under the MIT license unless noted otherwise (see license* files in src directory).

The MIT License (MIT)

Copyright (c) 2017 Travis Askham

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.