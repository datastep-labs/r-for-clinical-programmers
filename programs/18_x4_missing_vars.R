# Answer 18-4: the variables in one data set only, both ways
library(dplyr)

spec <- tibble(name = names(pharmaverseadam::adsl))
ours <- tibble(name = names(readRDS("data/adsl.rds")))

only_spec <- anti_join(spec, ours, by = join_by(name))
only_ours <- anti_join(ours, spec, by = join_by(name))
nrow(only_spec)
head(only_spec$name, 5)
nrow(only_ours)
only_ours$name
