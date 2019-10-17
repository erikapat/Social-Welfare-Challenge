


#https://stats.stackexchange.com/questions/130389/bayesian-equivalent-of-two-sample-t-test
set.seed(7)

#create samples
sample.1 <- rnorm(8, 100, 3)
sample.2 <- rnorm(10, 103, 7)

#we need a pooled data set for estimating parameters in the prior.
pooled <- c(sample.1, sample.2)
par(mfrow=c(1, 2))

hist(sample.1)
hist(sample.2)

likelihood <- function(parameters){
  mu1=parameters[1]; sig1=parameters[2]; mu2=parameters[3]; sig2=parameters[4]
  prod(dnorm(sample.1, mu1, sig1)) * prod(dnorm(sample.2, mu2, sig2))
}

prior <- function(parameters){
  mu1=parameters[1]; sig1=parameters[2]; mu2=parameters[3]; sig2=parameters[4]
  dnorm(mu1, mean(pooled), 1000*sd(pooled)) * dnorm(mu2, mean(pooled), 1000*sd(pooled)) * dexp(sig1, rate=0.1) * dexp(sig2, 0.1)
}

posterior <- function(parameters) {likelihood(parameters) * prior(parameters)}

#starting values
mu1 = 100; sig1 = 10; mu2 = 100; sig2 = 10
parameters <- c(mu1, sig1, mu2, sig2)

#this is the MCMC /w Metropolis method
n.iter <- 10000
results <- matrix(0, nrow=n.iter, ncol=4)
results[1, ] <- parameters
for (iteration in 2:n.iter){
  candidate <- parameters + rnorm(4, sd=0.5)
  ratio <- posterior(candidate)/posterior(parameters)
  if (runif(1) < ratio) parameters <- candidate #Metropolis modification
  results[iteration, ] <- parameters
}

#burn-in
results <- results[500:n.iter,]

mu1 <- results[,1]
mu2 <- results[,3]

hist(mu1 - mu2)


mean(mu1 - mu2 < 0)
[1] 0.9953689

####--------------------------------------------------------------------------------------------------------
require(rjags)


model.str <- 'model {
    for (i in 1:Ntotal) {
        y[i] ~ dt(mu[x[i]], tau[x[i]], nu)
    }
    for (j in 1:2) {
        mu[j] ~ dnorm(mu_pooled, tau_pooled)
        tau[j] <- 1 / pow(sigma[j], 2)
        sigma[j] ~ dunif(sigma_low, sigma_high)
    }
    nu <- nu_minus_one + 1
    nu_minus_one ~ dexp(1 / 29)
}'

# Indicator variable
x <- c(rep(1, length(sample.1)), rep(2, length(sample.2)))

cpd.model <- jags.model(textConnection(model.str),
                        data=list(y=pooled,
                                  x=x,
                                  mu_pooled=mean(pooled),
                                  tau_pooled=1/(1000 * sd(pooled))^2,
                                  sigma_low=sd(pooled) / 1000,
                                  sigma_high=sd(pooled) * 1000,
                                  Ntotal=length(pooled)))
update(cpd.model, 1000)
chain <- coda.samples(model = cpd.model, n.iter = 100000,
                      variable.names = c('mu', 'sigma'))
rchain <- as.matrix(chain)
hist(rchain[, 'mu[1]'] - rchain[, 'mu[2]'])
mean(rchain[, 'mu[1]'] - rchain[, 'mu[2]'] < 0)
mean(rchain[, 'mu[2]'] - rchain[, 'mu[1]'] > 5)
