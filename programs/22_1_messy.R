# Chapter 22: a program that works, in a layout nobody wants to read
library(dplyr)
adsl<-pharmaverseadam::adsl|>filter(SAFFL=="Y")
adsl|>group_by(TRT01A)|>summarise(n=n(),mean_age=round(mean(AGE),1),
  over_80=sum(AGE>80))
