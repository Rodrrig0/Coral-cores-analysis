###########################################
#Plot link between El Niño event and SST function
#Romain Journaud
############################################

ggplot_impactENSO= function(data, x, y ,ymin, ymax){
  ggplot(data, aes(x=x, y=y))+
  geom_line()+
  geom_hline(aes(yintercept = 0), linetype = "dotdash", linewidth = 1, color = "red")+
  labs(title = "Global temperature anomalies ", x= "Year", y = "Temperature anomalie (in ?C)")+
  geom_ribbon(aes(ymin=ymin,
                  ymax= ymax),
              alpha = 0.2, fill = "blue")
}
