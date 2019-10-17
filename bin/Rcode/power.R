

library(ggplot2)
b <- 0.8 # power
a <- 0.05 # significance level
es <- seq(from = 0.1, to = 0.3, by = 0.001) # effect sizes
result <- data.frame(matrix(nrow = length(es), ncol = 2))
names(result) <- c("ES", "ni")
for (i in 1:length(es)){
  result[i, "ES"] <- es[i]
  result[i, "ni"] <- power.t.test(sig.level = a, d = es[i], sd = 1,
                                  alternative = 'two.sided', power = b)$n  
}
ggplot(data = result, aes(x = ES, y = ni)) + geom_line() + xlab("Effect Size") + ylab("N") #+
  #scale_x_continuous(labels = scales::comma)

geom_point(data = result[ceiling(result\\(n / 10) * 10 == 5000, ],
           aes(x = DD, y = ni), colour = "red", size = 5)