# Создаем ненормально распределенную метрику
# Установите количество наблюдений
n <- 1000

# Генерируем случайные ID
set.seed(123)
id <- sample(1:10000, n, replace = TRUE)

# Генерируем ненормально распределенные значения метрики
mu <- log(10)
sd <- 1
money <- rlnorm(n, meanlog = mu, sdlog = sd)
money <- money * (300/max(money))

df <- data.frame(id, money)

# Проверяем датафрейм
head(df)
shapiro.test(df$money)

par(mfrow=c(1, 2))
hist(df$money)
qqnorm(df$money)
qqline(df$money, col = "red")


#-------------------------------------------------------------------------------
# Преобразование Бокса-Кокса
library(MASS)

# Вычислить наилучшее значение λ для преобразования Бокса-Кокса
par(mfrow=c(1, 1))
boxcox_result <- boxcox(df$money ~ 1, lambda = seq(-3,3,0.1))

# Получить наилучшее значение λ
best_lambda <- boxcox_result$x[which.max(boxcox_result$y)]

library(car)
# Применить преобразование Бокса-Кокса с оптимальным значением λ
df$money_transformed <- car::bcPower(df$money, best_lambda)

# Проверяем датафрейм
head(df)
shapiro.test(df$money_transformed)

par(mfrow=c(1, 2))
hist(df$money_transformed)
qqnorm(df$money_transformed)
qqline(df$money_transformed, col = "red")


#-------------------------------------------------------------------------------
# Преобразование Бокса-Кокса требует положительных значениий
# Если в колонке есть отрицательные значения, иногда, помогает смещение на минимальную величину и +1 чтобы уйти от нуля
df$money <- df$money + abs(min(df$money)) + 1





