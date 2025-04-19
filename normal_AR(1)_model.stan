data {
  // total observations
  int<lower=1> N;   
    // number of samples
  int<lower=1> G;        
  // observed thicknesses
  real<lower=0> y[N];           
  // sample index per obs
  int<lower=1,upper=G> group[N]; 
   // first index in y[] for each group
  int<lower=1> first_obs[G];    
   // last  index in y[] for each group
  int<lower=1> last_obs[G];     
  //ChatGpT was used to figure out how to correctly handle the indexes
}

parameters {
  // hyperparameters
  real<lower=0> alpha_mu;
  real<lower=0> beta_mu;
  real<lower=0> alpha_theta;
  real<lower=0> beta_theta;
  
  // parameters for groups
  vector<lower=0>[G] mu;
  vector<lower=0>[G] theta;
  
  // AR(1) coefficient, not bounded on (-1,1) as if the data is 
  // is not appropiate to model as an AR model this would inform us of that
   real<lower=0> phi;
}

model {
  // Hyper priors
  alpha_mu ~ exponential(1);
  beta_mu ~ exponential(1);
  alpha_theta ~ exponential(1);
  beta_theta ~ exponential(1);

  // Priors on group means and theta's
  mu ~ gamma(alpha_mu,    beta_mu);
  theta ~ gamma(alpha_theta, beta_theta);

  // prior on phi
  phi ~ normal(0, 0.5);

  // AR(1) likelihood for each group
  for (j in 1:G) {
    int f = first_obs[j];
    int l = last_obs[j];
    
    // first observation in each series
    y[f] ~ normal(mu[j], theta[j]);
    
    // AR(1) model, I am using the mean centered form. 
    // I think using the version provided by the stan documentation does
    // not affect the posterior of the AR(1) coefficient.
    for (n in (f+1):l) {
      y[n] ~ normal(mu[j] + phi * (y[n-1] - mu[j]), theta[j]);
    }
  }
}

generated quantities {
  vector[N] y_rep;
  for (j in 1:G) {
    int f = first_obs[j];
    int l = last_obs[j];
    
    // simulate first observation
    y_rep[f] = normal_rng(mu[j], theta[j]);
    
    // simulate rest via AR(1)
    for (n in (f+1):l) {
      y_rep[n] = normal_rng( mu[j] + phi * (y_rep[n-1] - mu[j]), theta[j]);
    }
  }
}
