

n <- 4



func <- function(n){
  lis <- 1:(2*n)
  seat <- sample(lis, size = 2*n, replace = FALSE)
  seats <- c(seat, seat[1])
  seat
  seats

  x <- 0
  for(i in seq_along(1:(2*n))){
    if(seats[i] %% 2 == 0 && (seats[i] - seats[i+1] == 1)){
      x <- x + 1
    }
    if(seats[i] %% 2 == 1 && (seats[i] - seats[i+1] == -1 )){
      x <- x + 1
    }
  }
  x
}

n <- 1:50

z <- vector(length = length(n))
for(i in seq_along(1:length(n))){
  y <- replicate(20000,func(i))
  z[i] <- var(y)
}

df <- tibble(val = z, n = 1:length(n))
ggplot(df, aes(x = n, y = val))+
  geom_point() + 
  geom_smooth()

