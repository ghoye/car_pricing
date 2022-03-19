library(tidyverse)
library(scales)
library(corrr)
library(tidyr)
library(ggplot2)
library(stringr)

### Original dataset, uploaded by Manish Kumar on Kaggle: 
### https://www.kaggle.com/hellbuoy/car-price-prediction?select=CarPrice_Assignment.csv

file <- c("/Users/ghoye/Documents/CarPrice_Assignment.csv")
cars <- read.csv(file, header = TRUE)
head(cars[,1:10]) # Columns 1-10 of 26 displayed


## Correlation

plot(cars$enginesize, cars$horsepower, col = alpha("firebrick2", 0.75), 
     ylim = c(0, 300), xlim = c(0, 400),
     xlab = "Engine Size", ylab = "Horsepower", main = "Car Engine Sizes and Horsepower")

cor(cars$enginesize, cars$horsepower)

pairs(cars[,c(10:14,17,19:26)]) # Using only quantitative/continuous variables

cars_long <- gather(cars[,c(10:13,17,19:22, 24:26)], key, value, -price)
# cars_long
ggplot(cars_long, aes(x = price, y = value)) + geom_point() + facet_grid(. ~ key)

cor_tib <- correlate(cars[,c(10:14,17,19:26)])
cor_tib_price <- data.frame(matrix(data = c(cor_tib$term, cor_tib$price), nrow = length(cor_tib$term), ncol = 2))
colnames(cor_tib_price) <- c("Variable", "r")
cor_tib_price <- cor_tib_price[-(nrow(cor_tib_price)),]
cor_tib_price$r <- round(as.numeric(cor_tib_price$r), 6)
cor_tib_price <- cor_tib_price %>% arrange(desc(r))
cor_tib_price

plot(cars$curbweight, cars$price, col = alpha("firebrick2", 0.75), 
     ylim = c(0, 60000), xlim = c(1000, 5000), cex.axis = 0.7,
     xlab = "Curb Weight", ylab = "Price", main = "Car Curb Weights and Price")

plot(cars$highwaympg, cars$price, col = alpha("firebrick2", 0.75), 
     ylim = c(0, 60000), xlim = c(10, 60), cex.axis = 0.7,
     xlab = "MPG (Highway)", ylab = "Price", main = "Car MPG (Highway) and Price")


## Simple Linear Regression
### Price and Width

smod1 <- lm(cars$price ~ cars$carwidth)
smod1

plot(cars$carwidth, cars$price, col = alpha("firebrick2", 0.75), 
     ylim = c(0, 60000), xlim = c(60, 75), cex.axis = 0.7,
     xlab = "Car Width", ylab = "Price", main = "Car Widths and Price")
abline(smod1,col="goldenrod2")

#### Hypothesis Testing

# ANOVA table
kable(anova(smod1))

# Calculate the F statistic
F <- anova(smod1)[1,3]/anova(smod1)[2,3]
F

# Sanity check
# anova(smod1)[1,4]
# summary(smod1)

# ANOVA table again for reference
kable(anova(smod1))

# Calculate regression sum of squares, residual sum of squares, and total sum of squares
reg_SS <- anova(smod1)[1,2]
res_SS <- anova(smod1)[2,2]
total_SS <- reg_SS + res_SS

# Calculate R^2
r2 <- reg_SS / total_SS
r2

confint(smod1, level = 0.9)

plot(cars$citympg, cars$price, col = alpha("firebrick2", 0.75), 
     ylim = c(0, 60000), xlim = c(10, 60), cex.axis = 0.7,
     xlab = "MPG (City)", ylab = "Price", main = "Car MPG (City) and Price")

### Price and City MPG

smod2 <- lm(cars$price ~ cars$citympg)

plot(x = smod2$fitted.values, y = smod2$residuals, main = "Residuals vs. Fitted Values", 
     xlab = "Fitted Values", ylab = "Residuals", col=alpha("firebrick2", 0.75),
     xlim = c(-10000, 25000), ylim = c(-15000, 25000))
abline(h = 0,col="goldenrod2")

plot(x = smod1$fitted.values, y = smod1$residuals, main = "Residuals vs. Fitted Values", 
     xlab = "Fitted Values", ylab = "Residuals", col=alpha("firebrick2", 0.75),
     xlim = c(-5000, 35000), ylim = c(-20000, 30000))
abline(h = 0,col="goldenrod2")

hist(x = smod1$residuals, main = "Residuals", xlab = "Residuals",
     col = "firebrick2", xlim = c(-20000, 40000), ylim = c(0, 150))

plot(smod1, which = 1)

# Original model
smod1

# Row 17 removed
cars2 <- cars[-(c(17)),]
smod1a <- lm(cars2$price ~ cars2$carwidth)
smod1a
#summary(smod1a)

# Row 127 removed
cars3 <- cars[-(c(127)),]
smod1b <- lm(cars3$price ~ cars3$carwidth)
smod1b
#summary(smod1b)

# Row 128 removed
cars4 <- cars[-(c(128)),]
smod1c <- lm(cars4$price ~ cars4$carwidth)
smod1c
#summary(smod1c)

# Row 129 removed
cars5 <- cars[-(c(129)),]
smod1d <- lm(cars5$price ~ cars5$carwidth)
smod1d
#summary(smod1d)

# Both rows 17 and 127 removed
cars6 <- cars[-(c(17, 127)),]
smod1e <- lm(cars6$price ~ cars6$carwidth)
smod1e
#summary(smod1e)

# Both rows 17 and 128 removed
cars7 <- cars[-(c(17, 128)),]
smod1f <- lm(cars7$price ~ cars7$carwidth)
smod1f
#summary(smod1f)

# Both rows 17 and 129 removed
cars8 <- cars[-(c(17, 129)),]
smod1g <- lm(cars8$price ~ cars8$carwidth)
smod1g
#summary(smod1g)

# Both rows 127 and 128 removed
cars9 <- cars[-(c(127, 128)),]
smod1h <- lm(cars9$price ~ cars9$carwidth)
smod1h
#summary(smod1h)

# Both rows 127 and 129 removed
cars10 <- cars[-(c(127, 129)),]
smod1i <- lm(cars10$price ~ cars10$carwidth)
smod1i
#summary(smod1i)

# Both rows 128 and 129 removed
cars11 <- cars[-(c(128, 129)),]
smod1j <- lm(cars11$price ~ cars11$carwidth)
smod1j
#summary(smod1j)

# Rows 17, 127, and 128 removed
cars12 <- cars[-(c(17, 127, 128)),]
smod1k <- lm(cars12$price ~ cars12$carwidth)
smod1k
#summary(smod1k)

# Rows 17, 127, and 129 removed
cars13 <- cars[-(c(17, 127, 129)),]
smod1l <- lm(cars13$price ~ cars13$carwidth)
smod1l
#summary(smod1l)

# Rows 17, 128, and 129 removed
cars14 <- cars[-(c(17, 128, 129)),]
smod1m <- lm(cars14$price ~ cars14$carwidth)
smod1m
#summary(smod1m)

# Rows 127, 128, and 129 removed
cars15 <- cars[-(c(127, 128, 129)),]
smod1n <- lm(cars15$price ~ cars15$carwidth)
smod1n
#summary(smod1n)

# All outliers removed
cars16 <- cars[-(c(17, 127, 128, 129)),]
smod1o <- lm(cars16$price ~ cars16$carwidth)
smod1o
#summary(smod1o)

plot(cars16$carwidth, cars16$price, col = alpha("firebrick2", 0.75), 
     ylim = c(0, 60000), xlim = c(60, 75), cex.axis = 0.7,
     xlab = "Car Width", ylab = "Price", main = "Car Widths and Price")
abline(smod1o,col="goldenrod2")

plot(x = smod1o$fitted.values, y = smod1o$residuals, main = "Residuals vs. Fitted Values", 
     xlab = "Fitted Values", ylab = "Residuals", col=alpha("firebrick2", 0.75),
     xlim = c(-5000, 35000), ylim = c(-20000, 30000))
abline(h = 0,col="goldenrod2")

hist(x = smod1o$residuals, main = "Residuals (Outliers Removed)", xlab = "Residuals",
     col = "firebrick2", xlim = c(-20000, 30000), ylim = c(0, 150))


## Multiple Linear Regression
### Price, Engine Size, Width, Peak RPM, Bore Ratio

mmod1 <- lm(cars$price ~ cars$enginesize + cars$carwidth + cars$peakrpm + cars$boreratio)
mmod1

summary(mmod1)

confint(mmod1)

plot(x = mmod1$fitted.values, y = mmod1$residuals, main = "Residuals vs. Fitted Values", 
     xlab = "Fitted Values", ylab = "Residuals", col=alpha("firebrick2", 0.75),
     xlim = c(-10000, 50000), ylim = c(-10000, 20000))
abline(h = 0,col="goldenrod2")

MLR_box <- boxplot(x = mmod1$residuals, main = "Residuals", ylab = "Residuals", col=c("red"),
                   horizontal=TRUE, ylim = c(-10000, 20000))
MLR_box

MLR_box$out

# Original model
mmod1 <- lm(cars$price ~ cars$enginesize + cars$carwidth + cars$peakrpm + cars$boreratio)
mmod1

# All outliers removed
cars17 <- cars[-(c(15, 17, 50, 102, 104, 127, 128, 129)),]
mmod1a <- lm(cars17$price ~ cars17$enginesize + cars17$carwidth + cars17$peakrpm + cars17$boreratio)
mmod1a

summary(mmod1)
summary(mmod1a)

plot(x = mmod1$fitted.values, y = mmod1$residuals, main = "Residuals vs. Fitted Values (Original)", 
     xlab = "Fitted Values", ylab = "Residuals", col=alpha("firebrick2", 0.75),
     xlim = c(-10000, 50000), ylim = c(-10000, 20000))
abline(h = 0,col="goldenrod2")

plot(x = mmod1a$fitted.values, y = mmod1a$residuals, main = "Residuals vs. Fitted Values (No Outliers)", 
     xlab = "Fitted Values", ylab = "Residuals", col=alpha("firebrick2", 0.75),
     xlim = c(-10000, 50000), ylim = c(-10000, 20000))
abline(h = 0,col="goldenrod2")

hist(x = mmod1$residuals, main = "Residuals", xlab = "Residuals",
     col = "firebrick2", xlim = c(-15000, 20000), ylim = c(0, 100))
hist(x = mmod1a$residuals, main = "Residuals (No Outliers)", xlab = "Residuals",
     col = "firebrick2", xlim = c(-15000, 20000), ylim = c(0, 100))