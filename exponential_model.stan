data {
  // Total number of observations
  int<lower=1> N;
  // Observed thicknesses
  real<lower=0> x[N];
  // An integer index corresponding to each observation's sample.
  int<lower=1,upper=5> sample[N];
}

parameters {
  // Rate parameters for each sample.
  // lambda is uniform in 0,1
  vector<lower=0, upper=1>[5] lambda;
}

model {
  // Likelihood: 
  // assign each observation an exponential likelihood with its own lambda
  for (n in 1:N) {
    x[n] ~ exponential(lambda[sample[n]]);
  }
}


generated quantities {
   // one posterior‑replicated data point per obs
 real x_rep[N];       
   // CoV for each sample
  vector[5] cov_rep;    

  // temporary accumulators
  real sum_rep[5];
  real sum_sq_rep[5];
  int  cnt[5];

  // initialize
  for (s in 1:5) {
    sum_rep[s]   = 0;
    sum_sq_rep[s]= 0;
    cnt[s]       = 0;
  }

  // simulate x_rep and accumulate sums by sample
  for (n in 1:N) {
    int s = sample[n];
    x_rep[n] = exponential_rng(lambda[s]);

    sum_rep[s]    += x_rep[n];
    sum_sq_rep[s] += square(x_rep[n]);
    cnt[s]        += 1;
  }

  // compute posterior predictive CoV for each sample
  for (s in 1:5) {
    real mu = sum_rep[s] / cnt[s];
    real variance = (sum_sq_rep[s] - cnt[s] * square(mu)) / (cnt[s] - 1);
    cov_rep[s] = sqrt(variance) / mu;
  }
}