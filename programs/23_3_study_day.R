# Chapter 23: a study day function, and the day of the first dose comes out wrong
study_day <- function(date, ref) {
  days <- as.numeric(date - ref)
  if (days > 0) {
    days + 1
  } else {
    days
  }
}

study_day(as.Date("2014-01-03"), as.Date("2014-01-02"))
study_day(as.Date("2014-01-02"), as.Date("2014-01-02"))
