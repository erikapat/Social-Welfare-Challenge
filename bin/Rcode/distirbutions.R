
require(dplyr)
require(ggplot2)
require(
  tidyquant)
# densities 

df.1 = as.data.frame(rnorm(50, mean = 800000, sd = 100000))
df.1 = df.1  %>%  mutate(variable = 'Downtown Store')
names(df.1) <- c('value', 'variable')

df.2 = as.data.frame(rnorm(50, mean = 780000, sd = 30000))
df.2 = df.2  %>%  mutate(variable = 'Suburban store')
names(df.2) <- c('value', 'variable')

df <- rbind(df.1, df.2)

densi_gg <- ggplot(df, aes(x = value, fill = variable)) +
  geom_density(alpha = .7)  #+ #alpha used for filling the density
densi_gg <- densi_gg +  theme_tq()
densi_gg <- densi_gg + theme(axis.text.x = element_text(angle = 0, hjust = 1, size = 12), axis.title.x = element_text(color="black", size= 12, face="bold"))
densi_gg <- densi_gg + theme(axis.text.y = element_text(hjust = 1, size = 12), axis.title.y = element_text(color="black", size= 12, face="bold"))
densi_gg <- densi_gg + theme(legend.title = element_text(colour="blue", size=10,
                                                         face="bold"))
densi_gg <- densi_gg +   guides(col = guide_legend(ncol = 1))
densi_gg <- densi_gg + theme(legend.title=element_blank())
densi_gg <- densi_gg + scale_x_continuous(labels = scales::comma)
densi_gg

ggsave('density.png')


###
#gamma

mean = 800000
std = 100000

shape = (mean/std)^2
scale = (std^2)/mean

df.1 = as.data.frame(rgamma(50, shape, rate = 1/scale))
df.1 = df.1  %>%  mutate(variable = 'Downtown Store')
names(df.1) <- c('value', 'variable')


mean = 780000
std = 30000

shape = (mean/std)^2
scale = (std^2)/mean

df.2 = as.data.frame(rgamma(50, shape, rate = 1/scale))
df.2 = df.2  %>%  mutate(variable = 'Suburban store')
names(df.2) <- c('value', 'variable')

df <- rbind(df.1, df.2)

densi_gg <- ggplot(df, aes(x = value, fill = variable)) +
  geom_density(alpha = .7)  #+ #alpha used for filling the density
densi_gg <- densi_gg +  theme_tq()
densi_gg <- densi_gg + theme(axis.text.x = element_text(angle = 0, hjust = 1, size = 12), axis.title.x = element_text(color="black", size= 12, face="bold"))
densi_gg <- densi_gg + theme(axis.text.y = element_text(hjust = 1, size = 12), axis.title.y = element_text(color="black", size= 12, face="bold"))
densi_gg <- densi_gg + theme(legend.title = element_text(colour="blue", size=10,
                                                         face="bold"))
densi_gg <- densi_gg +   guides(col = guide_legend(ncol = 1))
densi_gg <- densi_gg + theme(legend.title=element_blank())
densi_gg <- densi_gg + scale_x_continuous(labels = scales::comma)
densi_gg <- densi_gg + theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
densi_gg


