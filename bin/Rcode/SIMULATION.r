
# SMILATION 1
# simulation for the z-test
N = 5000
mx = NULL
for (i in 1:N){
  x1 <- rnorm(50, mean = 800000, sd = 100000)
  x2 <- rnorm(50, mean = 780000, sd = 30000)
  
  xx1 = x1 #(x1 -mean(x1))/sd(x1)
  xx2 = x2 #(x2 -mean(x2))/sd(x2)
  mx = c(mx, mean(xx1) - mean(xx2))
}

hist(mx)
length(mx[mx <40000])/length(mx)
max(mx)
60000/800000
mx = as.data.frame(mx)
ggplot(mx, aes(mx)) +
  geom_histogram() + xlab('Differences: mean')
ggsave('means.png')

##
N = 5000
mx = NULL
for (i in 1:N){
  mean = 800000
  std = 100000
  shape = (mean/std)^2
  scale = (std^2)/mean
  
  df.1 = rgamma(50, shape, rate = 1/scale)
  
  mean = 780000
  std = 30000
  shape = (mean/std)^2
  scale = (std^2)/mean
  df.2 = rgamma(50, shape, rate = 1/scale)

  xx1 = df.1 #(x1 -mean(x1))/sd(x1)
  xx2 = df.2 #(x2 -mean(x2))/sd(x2)
  mx = c(mx, mean(xx1) - mean(xx2))
}

hist(mx)
length(mx[mx <40000])/length(mx)
max(mx)

# SIMULATION 2: MONTECARLO 

# SMILATION 1
# simulation for the z-test
N = 5000
mx = NULL
for (i in 1:N){
  x1 <- rnorm(50, mean = 800000, sd = 100000)
  x2 <- rnorm(50, mean = 780000, sd = 30000)
  
  mx = c(mx, sum(x1) - sum(x2))
}

hist(mx)
max(mx)

mx = as.data.frame(mx)
ggplot(mx, aes(mx)) +
  geom_histogram() + xlab('Differences: total sum')
ggsave('total_sum.png') 
