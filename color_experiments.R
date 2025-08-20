library(tidyverse)
hcl.pals()[sample(1:115, 1)]
hcl.colors(2, palette = hcl.pals()[sample(1:115, 1)]) |> show_col()
hcl.pals()
show_col(c("#ebd999", "#00592e"))

gmp::factorize(117)

par(mfrow = c(13, 9))

map(.x = hcl.pals(),
    .f = \(col) hcl.colors(3, palette = col)) |>
  map(.x = _,
      .f = \(x) show_col(x, labels = F))

par(mfrow = c(1,1))

hcl.pals()[111] |> hcl.colors(3, palette = _) |> show_col(labels = F)

par(mfrow = c(3,3))
map(1:9,
    viridis) |>
  map(\(x) show_col(x, labels = F))


swatch1 <- c("#730f1f", "#888d2a", "#b8b8ff")
swatch2 <- c("#003e83", "#f2ff26", "#7e3075")
swatch3 <- c(hcl.colors(3, palette = hcl.pals()[111]))
swatch4 <- viridis(4)