# Fashion Trend Forecasting

**Forecasting Fashion Search Trends using Google Trends Data and Time Series Analysis in R**

---

### 📌 **Overview**

This repository contains an R-based analytical project aimed at forecasting fashion-related search trends using data from Google Trends. The project leverages advanced time series forecasting techniques, specifically ETS (Exponential Smoothing) and ARIMA (AutoRegressive Integrated Moving Average) models, to predict future interest in fashion trends, such as "long sleeve," "culottes," "miniskirts," and other clothing styles, colors, and materials.

---

### 🛠️ **Technologies & Tools Used:**

- **R Programming Language**
- **Time Series Forecasting** (`forecast`, `xts`, `lubridate`, `tidyverse`, `zoo`)
- **ETS & ARIMA models**
- **Google Trends Data**

---

### 📁 **Repository Structure:**

```
fashion-trend-forecasting/
├── fashion-trend-forecasting.R                  # Main R script for data analysis
├── fashion-trend-forecasting-presentation.pdf   # Project presentation (PDF)
├── gtrends.xlsx                                 # Raw Google Trends dataset
└── README.md                                    # Project overview and instructions
```

---

### 🚀 **How to Run the Project:**

1. **Clone the repository**

```bash
git clone https://github.com/Arasala-Bhanu-Mohana/fashion-trend-forecasting.git
```

2. **Open the R script** (`fashion-trend-forecasting.R`) in RStudio.

3. **Install required libraries** (if not already installed):

```R
install.packages(c("tidyverse", "lubridate", "xts", "forecast", "zoo"))
```

4. **Set your working directory** to the cloned repository location.

5. **Run the R script** to perform the analysis, visualize trends, and generate forecasts.

---

### 📊 **Insights & Findings:**

- Clear **seasonal patterns** were identified for several fashion trends, particularly higher search interest during colder months for items such as "long sleeves."
- The **ETS model slightly outperformed ARIMA** based on statistical metrics (AIC and BIC).
- This analysis is useful for **inventory management, targeted marketing, and predicting consumer interest** in fashion products.

---

### 📌 **Project Presentation:**

The detailed project presentation, which summarizes the forecasting methodology, visualizations, and key insights, can be accessed here:

📎 [fashion-trend-forecasting-presentation.pdf](fashion-trend-forecasting-presentation.pdf)
