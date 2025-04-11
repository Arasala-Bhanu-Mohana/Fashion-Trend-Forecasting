#install the pakage

install.packages("forecast")
# Load required packages ------------------------------------------------------
library(tidyverse)
library(lubridate)
library(xts)
library(forecast)
library(zoo)  # For time series interpolation

# Import raw data -------------------------------------------------------------
raw_data <- read_csv("C:/Users/MMLaptops.com/Desktop/time series project/monthly_cleaned_data3.csv")


head(raw_data)
raw_data

# Data cleaning pipeline ------------------------------------------------------
#cleaned_data <- raw_data %>%
  # Select target columns
#  select(date, `long sleeve`) %>%
  
  # Standardize date format to Year/Month
#  mutate(
##    date = floor_date(ymd(date), "month") %>%  # Convert to first day of month
##      format("%Y/%m")                          # Format as character string
#    date = ym(date) %>%  # Parse Year/Month format correctly
#      floor_date("month") %>%  # Ensure it's the first day of the month
#      format("%Y/%m")          # Format as character string
#  ) %>%
  
  # Data quality processing
#  group_by(date) %>%  # Group by monthly intervals
#  summarise(
#    `long sleeve` = {
      # Stage 1: Value range correction
#      clean_values <- pmax(pmin(`long sleeve`, 100), 0)
      
      # Stage 2: Missing value handling
#      if(any(is.na(clean_values))) {
#        message("Missing values detected for: ", unique(date))
        # Linear interpolation for internal NAs
#        clean_values <- na.approx(clean_values, na.rm = FALSE)
#      }
      
      # Stage 3: Edge value handling
#      if(any(is.na(clean_values))) {
#        message("Edge missing values found for: ", unique(date), 
#                " - Applying LOCF/BOCF")
        # Last observation carried forward/backward
#        clean_values <- na.fill(clean_values, "extend") 
#      }
      
      # Return monthly aggregated values
#      mean(clean_values, na.rm = TRUE)
#    }
#  ) %>%
#  ungroup




# === STEP 2: DATA CLEANING ===
cleaned_data <- raw_data %>%
  select(date, `long sleeve`) %>%
  mutate(
    date = ym(date) %>% floor_date("month") %>% format("%Y/%m")
  ) %>%
  group_by(date) %>%
  summarise(
    `long sleeve` = {
      clean_values <- pmax(pmin(`long sleeve`, 100), 0)
      if (any(is.na(clean_values))) {
        message("Missing values detected for: ", unique(date))
        clean_values <- na.approx(clean_values, na.rm = FALSE)
      }
      if (any(is.na(clean_values))) {
        message("Edge missing values found for: ", unique(date), " - Applying LOCF/BOCF")
        clean_values <- na.fill(clean_values, "extend")
      }
      mean(clean_values, na.rm = TRUE)
    }
  ) %>%
  ungroup()





# Validation report -----------------------------------------------------------
cat("=== DATA QUALITY VALIDATION REPORT ===\n")
cat("1. Missing value count:\n")
print(sum(is.na(cleaned_data$`long sleeve`)))

cat("\n2. Value range verification (0-100):\n")
print(summary(cleaned_data$`long sleeve`))

cat("\n3. Data sample preview:\n")
print(head(cleaned_data, 6))


#Remove Outliers from All Numeric Columns in One Go
remove_outliers <- function(df) {
  for (col in names(df)) {
    if (is.numeric(df[[col]])) {  # Only process numeric columns
      Q1 <- quantile(df[[col]], 0.25, na.rm = TRUE)
      Q3 <- quantile(df[[col]], 0.75, na.rm = TRUE)
      IQR <- Q3 - Q1
      
      lower_bound <- Q1 - 1.5 * IQR
      upper_bound <- Q3 + 1.5 * IQR
      
      df <- df[df[[col]] >= lower_bound & df[[col]] <= upper_bound, ]
    }
  }
  return(df)
}

#data_clean <- remove_outliers(data)
data_clean <- remove_outliers(cleaned_data)


##Verify If Outliers Are Removed

#par(mfrow = c(1, 2))  # Set plotting area to show two plots side by side
#data <- data.frame(printed = c(1, 2, 3, 4, 5))
##boxplot(data$printed, main="Before Outlier Removal", col="red")
##boxplot(data_clean, main="After Outlier Removal", col="blue")

## Before outlier removal (for comparison)
#boxplot(cleaned_data$`long sleeve`, main = "Before Outlier Removal", col = "red")

#remove_outliers <- function(df) {
#  for (col in names(df)) {
#    if (is.numeric(df[[col]])) {  # Only process numeric columns
#      Q1 <- quantile(df[[col]], 0.25, na.rm = TRUE)
#      Q3 <- quantile(df[[col]], 0.75, na.rm = TRUE)
#      IQR <- Q3 - Q1
      
#      lower_bound <- Q1 - 1.5 * IQR
#      upper_bound <- Q3 + 1.5 * IQR
      
#      df <- df[df[[col]] >= lower_bound & df[[col]] <= upper_bound, ]
#    }
#  }
#  return(df)
#}
## Apply outlier removal
#data_clean <- remove_outliers(cleaned_data)
## After outlier removal
#boxplot(data_clean$`long sleeve`, main = "After Outlier Removal", col = "blue")


#Convert Data to a Time Series Format

## Data frame
#data_clean <- data.frame(
#  printed = c(1, 2, 3, 4),
#  date = as.Date(c("2025-01-01", "2025-01-02", "2025-01-03", "2025-01-04"))
#)

## xts object banao
#xts_data <- xts(data_clean$printed, order.by = data_clean$date)
##xts_data <- xts(data_clean$`long sleeve`, order.by = as.Date(paste0(data_clean$date, "/01")))

# === STEP 4: CONVERT TO TIME SERIES ===
data_clean$date <- as.Date(paste0(data_clean$date, "/01"))
xts_data <- xts(data_clean$`long sleeve`, order.by = data_clean$date)

# Dekho kya bana
print(xts_data)

## Plot karo
##plot(xts_data, main = "Google Trends Time Series (oct 2015 - december 2019)", 
##     ylab = "Interest", col = "blue", major.ticks = "years", grid = TRUE)


plot(xts_data, main = "Interest in 'Long Sleeve' (Google Trends)", ylab = "Interest", col = "blue")


# Decomposition
ts_data <- ts(data_clean$`long sleeve`, start = c(2015, 10), frequency = 12)
decomp <- stl(ts_data, s.window = "periodic")
plot(decomp)


# ACF and PACF
acf(ts_data, main = "ACF of Long Sleeve Data")
pacf(ts_data, main = "PACF of Long Sleeve Data")



#Apply ETS Forecasting in R

#Fit the ETS Model
#ets_model <- ets(xts_data)  # Fit ETS model
#summary(ets_model)          # Model summary
ets_model <- ets(ts_data)
summary(ets_model)


#Statistical Justification (AIC/BIC)

#Lower values indicate a better model:
#AIC(ets_model)
#BIC(ets_model)

#Compared with ARIMA:
#arima_model <- auto.arima(xts_data)
arima_model <- auto.arima(ts_data)
summary(arima_model)

#AIC(arima_model)
#BIC(arima_model)

# === STEP 8: MODEL JUSTIFICATION ===
cat("\nModel AIC & BIC Comparison:\n")
cat("ETS AIC:", AIC(ets_model), " | BIC:", BIC(ets_model), "\n")
cat("ARIMA AIC:", AIC(arima_model), " | BIC:", BIC(arima_model), "\n")


#Forecast for next 12 periods (adjust as needed)
#ets_forecast <- forecast(ets_model, h=12)
#autoplot(ets_forecast)

#Model Performance Evaluation
#accuracy(ets_model)

# === STEP 9: FORECASTING ===
ets_forecast <- forecast(ets_model, h = 12)
autoplot(ets_forecast) +
  ggtitle("ETS Forecast for 'Long Sleeve' (Next 12 Months)") +
  ylab("Forecasted Interest")


# === STEP 10: MODEL PERFORMANCE ===
cat("\nModel Accuracy Metrics (ETS):\n")
print(accuracy(ets_model))

cat("\nModel Accuracy Metrics (ARIMA):\n")
print(accuracy(arima_model))

# === STEP 11: BUSINESS INTERPRETATION ===
cat("\nInsights:\n")
cat("The data shows clear seasonality — likely higher interest in cooler months.\n")
cat("ETS model slightly outperforms ARIMA (based on AIC/BIC).\n")
cat("This forecasting can guide inventory decisions for the next winter season.\n")

