data {
   // number of observations
  int<lower=1> N;         
  // observed thicknesses
  real<lower=0> x[N];     
}

parameters {
   // rate of exponential distribution
    // lambda is uniform in 0,1
  real<lower=0, upper=1> lambda;
}

model {

  // Likelihood
  x ~ exponential(lambda);
}

