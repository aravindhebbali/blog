# Generate a simple Open Graph card for the rbin post.
# Usage: Rscript R/make_og_card.R rbin

library(ggplot2)

pkg <- if (length(commandArgs(trailingOnly = TRUE)) > 0) {
  commandArgs(trailingOnly = TRUE)[1]
} else {
  "rbin"
}

subtitle <- "Binning data in R"

p <- ggplot() +
  annotate(
    "rect",
    xmin = 0, xmax = 1, ymin = 0, ymax = 1,
    fill = "#0f4c81"
  ) +
  annotate(
    "rect",
    xmin = 0, xmax = 1, ymin = 0, ymax = 0.06,
    fill = "#f4a259"
  ) +
  annotate("text", x = 0.5, y = 0.62, label = pkg, size = 34,
           colour = "white", fontface = "bold") +
  annotate("text", x = 0.5, y = 0.44, label = subtitle, size = 15,
           colour = "#cfd8e3") +
  annotate("text", x = 0.5, y = 0.22, label = "rsquaredacademy", size = 11,
           colour = "#f4a259") +
  scale_x_continuous(limits = c(0, 1), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 1), expand = c(0, 0)) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "#0f4c81", colour = NA),
    panel.background = element_rect(fill = "#0f4c81", colour = NA)
  )

ggsave(
  file.path("img", paste0("og_", pkg, ".png")),
  plot = p,
  width = 12,
  height = 6.3,
  dpi = 100
)
