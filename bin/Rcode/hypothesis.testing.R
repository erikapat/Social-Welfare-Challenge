mean_1 = 800000
std_1 = 100000

mean_2 = 780000
std_2 = 30000
n = 50

SE.1 <-  std_1 / sqrt(50)               
SE.2 <-  std_2 / sqrt(50)  
SE      <- sqrt( std_2^2 + SE.2^2)                        
z       <- (mean_1 - mean_2) / SE
P.z     <- pnorm(z, lower.tail = TRUE) 
P.z 
z
P.z
