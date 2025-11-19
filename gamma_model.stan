data {
  //same as in exponential 
    // Total number of observations
  int<lower=1> N;      
    // Observed thicknesses
  real<lower=0> x[N];           
  // Sample index (
  int<lower=1, upper=5> sample[N]; 
}

parameters {
  // Hyperparameters for the gamma
  real<lower=0> mu_alpha;
  real<lower=0> mu_beta;
  real<lower=0> theta_alpha;
  real<lower=0> theta_beta;

  // Sample parameters
  vector<lower=0>[5] alpha;
  vector<lower=0>[5] beta;
}

model {
  // Hyperpriors
  mu_alpha ~ exponential(1); 
  mu_beta ~ exponential(1);
  theta_alpha ~ exponential(1); 
  theta_beta ~ exponential(1);

  // Sample priors
  alpha ~ gamma(mu_alpha, theta_alpha);
  beta ~ gamma(mu_beta, theta_beta);

  // Likelihood
  for (n in 1:N) {
    x[n] ~ gamma(alpha[sample[n]], beta[sample[n]]);
  }
  
}


generated quantities {
  // x_rep is an array of replicated observations I will make one for each 
  // observed x
  vector[N] x_rep;
  for (n in 1:N) {
    // sample from gamma using the sample parameters, the hyper parameters
    // are fixed
    x_rep[n] = gamma_rng(alpha[sample[n]], beta[sample[n]]);
  }
}




