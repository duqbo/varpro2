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
t1 = 2*pi;
nt = 100;

ts = linspace(t0,t1,nt);

% eigenvalues

e1 = 1i;
e2 = -3*1i;
e3 = 0.5*1i;

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

% bounds 

% note that the first ia bounds apply to the real part of
% alpha and the second ia bounds apply to the imaginary part
% For unbounded, use the appropriate choice of +/- Inf

% the below has the effect of constraining the alphas to the
% left half plane

lbc = [-Inf*ones(size(alpha_init)); -Inf*ones(size(alpha_init))];
ubc = [zeros(size(alpha_init)); Inf*ones(size(alpha_init))];

copts = varpro_lsqlinopts('lbc',lbc,'ubc',ubc);

%% compute modes in various ways


% 1 --- compute with default optimization values, no constraints

opts = varpro_opts();

[b,alpha1,niter,err,imode,alphas] = varpro2(xdata,ts,phi,dphi, ...
        nt,r,nx,ia,alpha_init,opts);

% evaluate fit
res = xdata - phi(alpha1,ts)*b;
relerr_r = norm(res,'fro')/norm(xdata,'fro');

% compare to actual eigenvalues
indices = match_vectors(alpha1,evals);
relerr_e = norm(alpha1(indices)-evals)/norm(evals);

fprintf('example 1 --- fitting data with default optimization values\n')
fprintf('relative error in reconstruction %e\n',relerr_r)
fprintf('relative error of eigenvalues %e\n',relerr_e)

% 2 --- compute with extra iterations and constraints

opts = varpro_opts('maxiter',200,'ptf',10);

[b,alpha2,niter,err,imode,alphas] = varpro2(xdata,ts,phi,dphi, ...
        nt,r,nx,ia,alpha_init,opts,copts);

% evaluate fit
res = xdata - phi(alpha2,ts)*b;
relerr_r = norm(res,'fro')/norm(xdata,'fro');

% compare to actual eigenvalues
indices = match_vectors(alpha2,evals);
relerr_e = norm(alpha2(indices)-evals)/norm(evals);

fprintf('example 2 --- fitting data with constraints, more iterations\n')
fprintf('relative error in reconstruction %e\n',relerr_r)
fprintf('relative error of eigenvalues %e\n',relerr_e)

% plot resulting e-vals

figure(1)
hold off
scatter(real(alpha1),imag(alpha1),'bo')
hold on
scatter(real(alpha2),imag(alpha2),'rx')
