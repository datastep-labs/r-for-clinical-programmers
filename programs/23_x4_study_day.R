# Answer 23-4: the study day rule of CDISC: day 1 is the day of the first dose, there is no day 0
study_day <- function(date, ref) {
  days <- as.numeric(date - ref)
  if (days >= 0) {
    days + 1
  } else {
    days
  }
}

study_day(as.Date("2014-01-02"), as.Date("2014-01-02"))
study_day(as.Date("2013-12-26"), as.Date("2014-01-02"))
