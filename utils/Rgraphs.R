
#heat_maps_functions

HeatMaps.Nas <- function(dt.values, label){

  dt.values = as.data.table(cbind(row.names(dt.values), dt.values), row.names = NULL)
  names(dt.values) = c('Var1', 'value')
  dt.values = dt.values %>% mutate(Var2 = 1, values =as.numeric(value))
  
  
  d <- ggplot(data = dt.values, aes(y=reorder(Var1, abs(values)), x=Var2, fill=values)) 
  d <- d + geom_tile() 
  d <- d + xlab('') + ylab('') + ggtitle(label)
  d <- d + scale_fill_gradient2(low = "gray", high = "blue", mid = "gray", 
                                midpoint = 1.5, limit = c(0,5), space = "Lab" 
  ) 
  #d <- d + geom_tile(aes(fill = value), color='white') 
  d <- d + theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
  d <- d + theme(axis.title.y = element_text(size = rel(1.5)))
  d <- d + theme(axis.text.y = element_text(size = rel(1.8)))
  d <- d + theme(axis.text.x = element_text(size = rel(1.8)))
  d <- d + theme(axis.title.x = element_text(size = rel(1.5)))
  d <- d +  theme(axis.title.x=element_blank(),
                  axis.text.x=element_blank(),
                  axis.ticks.x=element_blank())
  d <- d + theme(legend.text = element_text(size = 15))
  d <- d + theme(legend.title = element_text(size = 15))
  d <- d + guides(fill=guide_legend(title="% of Missing values"))
 
  return(d)

}


Mutual_info <- function(dd){
  dt.values = as.data.table(cbind(row.names(dd), dd), row.names = NULL)
  names(dt.values) = c('Var1', 'value')
  dt.values = dt.values[order(value, decreasing = T),]
  dt.values <- dt.values[value > 0]
  
  d <- ggplot(dt.values, aes(y = value, x = reorder(Var1, value))) +  geom_bar(stat = "identity", color = 'blue') + coord_flip()
  d <- d + ylab('Mutual info') + xlab('Features') 
  #d <- d +  theme_tq() 
  d <- d + theme(axis.title.y = element_text(size = rel(1.5)))
  d <- d + theme(axis.text.y = element_text(size = rel(1.8)))
  d <- d + theme(axis.text.x = element_text(size = rel(1.8)))
  d <- d + theme(axis.title.x = element_text(size = rel(1.5)))
  d <- d + theme(legend.text = element_text(size = 15))
  d <- d + theme(legend.title = element_text(size = 15))
  d <- d +  theme(
    panel.background = element_rect(fill="white") ,
    panel.grid.minor.y = element_line(size=3),
    panel.grid.major = element_line(colour = "lightgray"),
    plot.background = element_rect(fill="white")
  )
  
  return(d)
}
