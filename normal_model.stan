data {
  //same as before
    // Total number of observations
  int<lower=1> N;      
    // Observed thicknesses
  real x[N];           
  // Sample index (
  int<lower=1, upper=5> sample[N]; 
}

parameters {
  // Hyperparameters (rate parameters for gamma priors)
  real<lower=0> alpha_mu;
  real<lower=0> beta_mu;
  real<lower=0> alpha_theta;
  real<lower=0> beta_theta;

  // Sample specific parameters
  vector<lower=0>[5] mu;
  vector<lower=0>[5] theta;
}

model {
  // Hyperpriors
  alpha_mu ~ exponential(1); 
  beta_mu ~ exponential(1);
  alpha_theta ~ exponential(1); 
  beta_theta ~ exponential(1);

  // Sample priors
  mu ~ gamma(alpha_mu, beta_mu);
  theta ~ gamma(alpha_theta, beta_theta);

  // Likelihood
  for (n in 1:N) {
    x[n] ~ normal(mu[sample[n]], theta[sample[n]]);
  }
  
}


generated quantities {
  // x_rep is an array of replicated observations I will make one for each 
  // observed x
  vector[N] x_rep;
  for (n in 1:N) {
    // sample from normal using the sample parameters, the hyper parameters
    // are fixed
    x_rep[n] = normal_rng(mu[sample[n]], theta[sample[n]]);
  }
}




