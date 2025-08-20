# install.packages("ggquiver")
library(ggquiver)
library(tidyverse)
theme_set(theme_minimal())


# Quiver plots of mathematical functions
field <- expand.grid(x = seq(0, pi, pi / 12), y = seq(0, pi, pi / 12))

field |>
  mutate(
    u = cos(x),
    v = sin(y)
  ) |>
  ggplot(aes(x = x, y = y, u = u, v = v, color = factor(u * v))) +
  geom_quiver(show.legend = FALSE)

# Removing automatic scaling
ggplot(seals, aes(
  x = long,
  y = lat,
  u = delta_long,
  v = delta_lat
)) +
  geom_quiver(aes(color = delta_long + delta_lat),
    show.legend = FALSE,
    rescale = TRUE
  ) +
  borders("state") +
  theme_void()


field2 <- expand.grid(x = seq(-10, 10), y = seq(-10, 10))

field2 |>
  mutate(
    u = -y,
    v = x
  ) |>
  ggplot(aes(x = x, y = y, u = u, v = v, color = sqrt(u^2 + v^2))) +
  geom_quiver(show.legend = FALSE, rescale = TRUE)



################


func <- \(r){
  (r * sqrt(1 - (r / 2)^2)) + ((2 - r^2) * acos(r / 2)) - (pi / 2)
}

seq(0, 2, by = .001) |>
  tibble(x = _) |>
  mutate(
    y = func(x)
  ) |>
  ggplot() +
  geom_line(aes(x = x, y = y))

uniroot(func, c(0, 2))$root

conf <- .95
al <- 1 - conf

df <- tibble(
  order_stat_lower_bound = NA_real_,
  order_stat_upper_bound = NA_real_
)

for (i in 1:n) {
  qorderstat <- jth_order_stat_qf(cdf, i, n)
  df[i, 5:6] <- qorderstat(c(al / 2, 1 - al / 2)) |> t()
}

ggplot(df, aes(theoretical_quantiles, order_stats)) +
  geom_errorbar(
    aes(ymin = order_stat_lower_bound, ymax = order_stat_upper_bound),
    color = "gray40", alpha = .30
  ) +
  geom_function(fun = ~.x, color = "red", linetype = "dashed") +
  # geom_point(size = 1.5) +
  geom_point(aes(fill = ps_of_order_stats), size = 1.5, shape = 21) +
  scale_fill_gradientn(
    colors = rainbow(10), limits = 0:1, labels = scales::percent_format()
  ) +
  coord_equal() +
  labs(
    x = "Theoretical quantiles of N(0,1)",
    y = "Observed quantiles = order statistics",
    fill = "p"
  ) +
  theme(
    plot.caption = element_text(size = 6, color = "gray75")
    # panel.grid.major = element_blank()
  )



library(future)
library(purrr)
library(furrr)
library(progressr)

plan(multisession)

1:10 %>%
  future_map(rnorm, n = 10, .options = furrr_options(seed = 123)) %>%
  future_map_dbl(mean) |>
  with_progress()

xs <- 1:25

with_progress({
  p <- progressor(along = xs)
  y <- lapply(xs, function(x) {
    Sys.sleep(0.1)
    p(sprintf("x=%g", x))
    sqrt(x)
  })
})

plan(sequential)
