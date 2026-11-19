# Answer 14-2: mean change in systolic blood pressure (lying), per visit
library(dplyr)
library(ggplot2)

means <- pharmaverseadam::advs |>
  filter(
    SAFFL == "Y", PARAMCD == "SYSBP", ANL01FL == "Y", AVISITN %in% 2:26,
    ATPT == "AFTER LYING DOWN FOR 5 MINUTES"
  ) |>
  group_by(TRTA, AVISITN) |>
  summarise(
    n = n(), mean = mean(CHG), se = sd(CHG) / sqrt(n()),
    .groups = "drop"
  ) |>
  mutate(TRTA = factor(
    TRTA, c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")
  )) |>
  arrange(TRTA, AVISITN)

means |>
  filter(AVISITN == 24) |>
  mutate(across(c(mean, se), \(x) round(x, 2)))

ggplot(means, aes(x = AVISITN, y = mean, colour = TRTA)) +
  geom_hline(yintercept = 0, colour = "grey60") +
  geom_line(position = position_dodge(width = 0.6)) +
  geom_point(position = position_dodge(width = 0.6)) +
  geom_errorbar(
    aes(ymin = mean - se, ymax = mean + se),
    width = 0.8, position = position_dodge(width = 0.6)
  ) +
  scale_x_continuous(breaks = c(2, 4, 6, 8, 12, 16, 20, 24, 26)) +
  labs(
    title = "Mean change from baseline in systolic BP, lying (mmHg)",
    x = "Week", y = "Change from baseline (mmHg)", colour = NULL
  ) +
  theme_bw() +
  theme(legend.position = "bottom")
