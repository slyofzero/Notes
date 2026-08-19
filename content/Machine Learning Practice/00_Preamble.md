>[!SUMMARY] Table of Contents
>- [[Fundamental ML Concepts#The ML Project Life Cycle|The ML Project Life Cycle]]
>- [[Fundamental ML Concepts#1. Exploratory Data Analysis (EDA)|1. EDA]]
>- [[Fundamental ML Concepts#2. Data Cleaning|2. Data Cleaning]]
>- [[Fundamental ML Concepts#3. Data Imputation|3. Data Imputation]]
>- [[Fundamental ML Concepts#4. Feature Engineering & Encoding|4. Feature Engineering & Encoding]]
>- [[Fundamental ML Concepts#5. Feature Scaling|5. Feature Scaling]]
>- [[Fundamental ML Concepts#6. Train-Test Split & Cross-Validation|6. Train-Test Split & Cross-Validation]]
>- [[Fundamental ML Concepts#7. Hyperparameter Tuning|7. Hyperparameter Tuning]]
>- [[Fundamental ML Concepts#8. Evaluation Metrics — Regression|8. Evaluation Metrics — Regression]]
>- [[Fundamental ML Concepts#9. Evaluation Metrics — Classification|9. Evaluation Metrics — Classification]]
>	- [[Fundamental ML Concepts#Confusion Matrix|Confusion Matrix]]
>	- [[Fundamental ML Concepts#ROC-AUC Curve|ROC-AUC Curve]]
>	- [[Fundamental ML Concepts#Precision-Recall Curve|Precision-Recall Curve]]
>- [[Fundamental ML Concepts#10. scikit-learn Models — Theory & Hyperparameters|10. scikit-learn Models]]
>	- [[Fundamental ML Concepts#Linear Regression|Linear Regression]]
>	- [[Fundamental ML Concepts#Ridge & Lasso Regression|Ridge & Lasso]]
>	- [[Fundamental ML Concepts#Logistic Regression|Logistic Regression]]
>	- [[Fundamental ML Concepts#Support Vector Machines (SVM)|SVM]]
>	- [[Fundamental ML Concepts#Decision Trees|Decision Trees]]
>	- [[Fundamental ML Concepts#Ensemble Methods|Ensemble Methods]]
>	- [[Fundamental ML Concepts#K-Nearest Neighbours (KNN)|KNN]]
>	- [[Fundamental ML Concepts#Naïve Bayes|Naïve Bayes]]
>	- [[Fundamental ML Concepts#Neural Networks (MLPClassifier / MLPRegressor)|Neural Networks]]
>	- [[Fundamental ML Concepts#K-Means Clustering|K-Means]]
>	- [[Fundamental ML Concepts#DBSCAN|DBSCAN]]
>	- [[Fundamental ML Concepts#Principal Component Analysis (PCA)|PCA]]
>- [[Fundamental ML Concepts#11. scikit-learn Pipeline API|11. scikit-learn Pipeline API]]
>- [[Fundamental ML Concepts#12. Inference & Deployment Checklist|12. Inference & Deployment Checklist]]
>- [[Fundamental ML Concepts#Appendix — Legacy Notes|Appendix — Legacy Notes]]

This file is a **comprehensive reference for the IITM BSCS2008 Machine Learning Practice** course, covering the full end-to-end project lifecycle in scikit-learn. Use it as your single-stop interview guide.

---

# The ML Project Life Cycle

Every ML project follows a repeatable sequence of steps. Think of it as a pipeline where a mistake early on propagates and amplifies at every downstream stage.

```
Raw Data
   ↓
EDA (understand the data)
   ↓
Train–Validation–Test Split
   ↓
Data Cleaning (remove noise and inconsistencies)
   ↓
Data Imputation (handle missing values)
   ↓
Feature Engineering & Encoding
   ↓
Feature Scaling / Normalization
   ↓
Model Selection & Training
   ↓
Hyperparameter Tuning (with Cross-Validation)
   ↓
Evaluation on held-out Test Set
   ↓
Inference / Deployment
```

---
