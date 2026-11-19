# Chapter 14: a line plot of mean change from baseline, with error bars
library(dplyr)
library(ggplot2)

means <- readRDS("output/vs_means.rds") |> # made by 14_2
  mutate(TRTA = factor(
    TRTA, c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")
  ))

fig <- ggplot(means, aes(x = AVISITN, y = mean, colour = TRTA)) +
  geom_hline(yintercept = 0, colour = "grey60") +
  geom_line(position = position_dodge(width = 0.6)) +
  geom_point(position = position_dodge(width = 0.6)) +
  geom_errorbar(
    aes(ymin = mean - se, ymax = mean + se),
    width = 0.8, position = position_dodge(width = 0.6)
  ) +
  scale_x_continuous(breaks = c(2, 4, 6, 8, 12, 16, 20, 24, 26)) +
  labs(
    title = "Mean change from baseline in weight (kg), mean and standard error",
    x = "Week", y = "Change from baseline (kg)", colour = NULL
  ) +
  theme_bw() +
  theme(legend.position = "bottom")
fig

# the file for the report: 8 by 5 inches, 300 dots per inch
ggsave("output/f_14_2_1_weight.png", fig, width = 8, height = 5, dpi = 300)
file.exists("output/f_14_2_1_weight.png")
