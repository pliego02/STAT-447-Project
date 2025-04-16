data {
  // Total number of observations
  int<lower=1> N;
  // Observed thicknesses
  real<lower=0> x[N];
  // An integer index corresponding to each observation's sample.
  int<lower=1,upper=4> sample[N];
}

parameters {
  // Rate parameters for each sample.
  // lambda is uniform in 0,1
  vector<lower=0, upper=1>[4] lambda;
}

model {
  // Likelihood: 
  // assign each observation an exponential likelihood with its own lambda
  for (n in 1:N) {
    x[n] ~ exponential(lambda[sample[n]]);
  }
  
}