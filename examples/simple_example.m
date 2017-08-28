%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simple example for variable projection
% code
%
% Here we fit data generated from 3 
% spatial modes, each with time dynamics 
% which are exponential in time
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% generate synthetic data

iseed = 8675309;
rng(iseed);

% set up modes in space

x0 = 0;
x1 = pi;
nx = 200;

% space

xspace = linspace(x0,x1,nx);

% modes

f1 = sin(xspace);
f2 = cos(xspace);
f3 = tanh(xspace);

% set up time dynamics

t0 = 0;
t1 = 1;
nt = 100;

ts = linspace(t0,t1,nt);

% eigenvalues

e1 = 1;
e2 = -2;
e3 = 1i;

evals = [e1;e2;e3];

% define matrix-valued function (see varpro2expfun.m, etc.)

phi = @(alpha,t) varpro2expfun(alpha,t);
dphi = @(alpha,t,i) varpro2dexpfun(alpha,t,i);

% create clean dynamics

xclean = phi(evals,ts)*[f1;f2;f3];

% add noise 

sigma = 1e-4;
xdata = xclean + sigma*randn(size(xclean)); % this is our "data"

% set a random initial guess (not generally a good idea)

alpha_init = randn(3,1);

% target rank

r = 3;

% number of elements in alpha

ia = r;

%% compute modes in various ways


% 1 --- compute with default optimization values

opts = varpro_opts();

[b,alpha,niter,err,imode,alphas] = varpro2(xdata,ts,phi,dphi, ...
        nt,r,nx,ia,alpha_init,opts);

% evaluate fit
res = xdata - phi(alpha,ts)*b;
relerr_r = norm(res,'fro')/norm(xdata,'fro');

% compare to actual eigenvalues
indices = match_vectors(alpha,evals);
relerr_e = norm(alpha(indices)-evals)/norm(evals);

fprintf('example 1 --- fitting data with default optimization values\n')
fprintf('relative error in reconstruction %e\n',relerr_r)
fprintf('relative error of eigenvalues %e\n',relerr_e)

% 2 --- set some optimization parameters

maxiter = 40; % maximum number of iterations
tol = 1e-3; % tolerance of fit
eps_stall = 1e-9; % tolerance for detecting a stalled optimization
opts = varpro_opts('maxiter',maxiter,'tol',tol,'eps_stall',eps_stall);

[b,alpha,niter,err,imode,alphas] = varpro2(xdata,ts,phi,dphi, ...
        nt,r,nx,ia,alpha_init,opts);

% evaluate fit
res = xdata - phi(alpha,ts)*b;
relerr_r = norm(res,'fro')/norm(xdata,'fro');

% compare to actual eigenvalues
indices = match_vectors(alpha,evals);
relerr_e = norm(alpha(indices)-evals)/norm(evals);

fprintf('example 2 --- fitting data with weaker tolerance\n')
fprintf('relative error in reconstruction %e\n',relerr_r)
fprintf('relative error of eigenvalues %e\n',relerr_e)
