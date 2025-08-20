library(tidyverse)
library(furrr)
plan(multisession)

one_roll <- \(n) {
  
  Alice <- 
    sample(
    x = 1:6,
    size = 1,
    replace = TRUE) %>%
    `/`(6) |>
    sqrt()
  
  Bob <-
    sample(
      x = 1:6,
      size = 2,
      replace = TRUE) |>
    max() %>%
    `/`(6)
  
  tibble(
    A = Alice,
    B = Bob
  )
}

run_rolls <- \(times) {
  future_map_dfr(.x = 1:times,
                 .f = roll_dice,
                 .options = furrr_options(seed = NULL)) |>
    mutate(win = case_when(A > B ~ "A", B > A ~ "B", .default = "T")) |>
    count(win)
  
}

df <- run_rolls(1e6)

df |> kable()

df |> 
  ggplot(aes(x = win, y = n, fill = win)) + 
  geom_col() + 
  scale_fill_viridis_d() + 
  theme_minimal()


pick_num <- \(n){
  
  Alice <- 
    runif(1) |>
    sqrt()
  
  Bob <-
    runif(2) |>
    max() 
  
  tibble(
    A = Alice,
    B = Bob
  )
  
}

run_nums <- \(times) {
  future_map_dfr(.x = 1:times,
                 .f = pick_num,
                 .options = furrr_options(seed = NULL)) |>
    mutate(win = case_when(A > B ~ "A", B > A ~ "B", .default = "T")) |>
    count(win)
}

df2 <- run_nums(1e6)

df2 |> kable()

df2 |> 
  ggplot(aes(x = win, y = n, fill = win)) + 
  geom_col() + 
  scale_fill_viridis_d() + 
  theme_minimal()


