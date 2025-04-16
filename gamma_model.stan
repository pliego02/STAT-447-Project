data {
  //same as before
    // Total number of observations
  int<lower=1> N;      
    // Observed thicknesses
  real<lower=0> x[N];           
  // Sample index (
  int<lower=1, upper=4> sample[N]; 
}

parameters {
  // Hyperparameters (rate parameters for gamma priors)
  real<lower=0> mu_alpha;
  real<lower=0> mu_beta;
  real<lower=0> theta_alpha;
  real<lower=0> theta_beta;

  // Sample specific parameters
  vector<lower=0>[4] alpha;
  vector<lower=0>[4] beta;
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







