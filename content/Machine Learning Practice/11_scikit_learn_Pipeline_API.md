# 11. scikit-learn Pipeline API


**Intuition:** A machine learning workflow consists of multiple sequential steps — missing value imputation, scaling, encoding, dimensionality reduction, and finally a model estimator. A **`Pipeline`** chains all these steps into a single composite estimator. It enforces strict separation between training and test sets, preventing data leakage automatically during cross-validation.

---

## 11.1 Why Pipelines Are Essential

Without a Pipeline, you have to manually call `fit_transform()` on training data and `transform()` on test/validation data for every single transformer. This leads to three major issues:

1. **Data Leakage:** Manually scaling or imputing before `cross_val_score` leaks test fold statistics into the training fold.
2. **Code Duplication & Bugs:** Forgetting to apply the exact same transformation sequence during test/inference leads to prediction errors.
3. **Complex Deployment:** You have to save and load 5 different pickle files (imputer.pkl, scaler.pkl, encoder.pkl, model.pkl). A Pipeline packs everything into **1 pickle file**.

---

## 11.2 `Pipeline` vs. `make_pipeline`

`Pipeline` requires explicit step names. `make_pipeline` automatically names steps based on their class names (lowercased).

```python
from sklearn.pipeline import Pipeline, make_pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

# 1. Standard Pipeline (explicit names — best for GridSearchCV)
pipe1 = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler',  StandardScaler()),
    ('model',   LogisticRegression())
])

# 2. make_pipeline (shorthand — best for quick code)
pipe2 = make_pipeline(
    SimpleImputer(strategy='median'),
    StandardScaler(),
    LogisticRegression()
)
# Automatically names steps: 'simpleimputer', 'standardscaler', 'logisticregression'
```

---

## 11.3 Mixed Data Types: `ColumnTransformer`

Real-world datasets contain a mixture of numeric, nominal categorical, and ordinal categorical columns. `ColumnTransformer` applies separate transformation pipelines to specific column subsets.

```python
from sklearn.compose import ColumnTransformer, make_column_selector
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler, OneHotEncoder, OrdinalEncoder
from sklearn.ensemble import RandomForestClassifier

# Define column groups
num_cols = ['age', 'fare', 'family_size']
cat_cols = ['embarked', 'sex']
ord_cols = ['pclass']  # 1, 2, 3

# 1. Numeric pipeline
num_pipe = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler',  StandardScaler())
])

# 2. Nominal categorical pipeline
cat_pipe = Pipeline([
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('ohe',     OneHotEncoder(handle_unknown='ignore', sparse_output=False))
])

# 3. Ordinal categorical pipeline
ord_pipe = Pipeline([
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('ordinal', OrdinalEncoder(categories=[[3, 2, 1]]))  # explicit ordering
])

# Combine into a ColumnTransformer
preprocessor = ColumnTransformer(
    transformers=[
        ('num', num_pipe, num_cols),
        ('cat', cat_pipe, cat_cols),
        ('ord', ord_pipe, ord_cols)
    ],
    remainder='drop'  # 'drop': drop remaining cols; 'passthrough': keep unmentioned cols as-is
)

# Full end-to-end Pipeline
full_pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('classifier',   RandomForestClassifier(n_estimators=100, random_state=42))
])

# Fit on training data, predict on test data
full_pipeline.fit(X_train, y_train)
y_pred = full_pipeline.predict(X_test)
```

### Dynamic Column Selection with `make_column_selector`
Instead of hardcoding column names, select columns dynamically by data type:

```python
preprocessor = ColumnTransformer(
    transformers=[
        ('num', num_pipe, make_column_selector(dtype_include=['int64', 'float64'])),
        ('cat', cat_pipe, make_column_selector(dtype_include=['object', 'category']))
    ]
)
```

---

## 11.4 Parallel Extraction: `FeatureUnion` vs. `ColumnTransformer`

- **`ColumnTransformer`:** Applies different transformers to **different disjoint subsets of columns** (non-overlapping).
- **`FeatureUnion`:** Applies multiple transformers to the **SAME columns in parallel**, and concatenates their outputs horizontally.

```python
from sklearn.pipeline import FeatureUnion
from sklearn.decomposition import PCA
from sklearn.feature_selection import SelectKBest, f_classif

# Extract both PCA components AND top univariate features from the SAME numeric data
parallel_features = FeatureUnion([
    ('pca',    PCA(n_components=5)),
    ('k_best', SelectKBest(score_func=f_classif, k=5))
])
# Output matrix will have 5 + 5 = 10 features
```

---

## 11.5 Custom Transformers (`BaseEstimator` & `TransformerMixin`)

You can write your own custom transformation step (e.g. outlier clipping, log-transform, custom feature engineering) that integrates seamlessly into a scikit-learn Pipeline.

```python
import numpy as np
import pandas as pd
from sklearn.base import BaseEstimator, TransformerMixin

class OutlierCapper(BaseEstimator, TransformerMixin):
    """Caps numerical features at specified upper and lower quantiles."""
    
    def __init__(self, lower_quantile=0.01, upper_quantile=0.99):
        self.lower_quantile = lower_quantile
        self.upper_quantile = upper_quantile
        
    def fit(self, X, y=None):
        # Compute capping thresholds on training data ONLY
        X_df = pd.DataFrame(X)
        self.lower_bounds_ = X_df.quantile(self.lower_quantile).values
        self.upper_bounds_ = X_df.quantile(self.upper_quantile).values
        return self
        
    def transform(self, X):
        # Clip data using learned thresholds
        X_array = np.asarray(X)
        return np.clip(X_array, self.lower_bounds_, self.upper_bounds_)

# Use inside a Pipeline
custom_pipe = Pipeline([
    ('capper', OutlierCapper(lower_quantile=0.05, upper_quantile=0.95)),
    ('scaler', StandardScaler()),
    ('model',  LogisticRegression())
])
```

> [!NOTE]
> Inheriting from `TransformerMixin` gives you `fit_transform()` for free. Inheriting from `BaseEstimator` gives you `get_params()` and `set_params()` for free, enabling `GridSearchCV` hyperparameter tuning on your custom transformer parameters!

---

## 11.6 Hyperparameter Tuning Inside Pipelines

Use double underscores `__` to traverse nested pipeline steps in `GridSearchCV` or `RandomizedSearchCV`.

```python
from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression

# Define hyperparameter grid
param_grid = {
    # Tune preprocessing parameters
    'preprocessor__num__imputer__strategy': ['mean', 'median'],
    'preprocessor__num__scaler__with_std':  [True, False],
    
    # Tune model parameters
    'classifier__n_estimators': [100, 200],
    'classifier__max_depth':    [5, 10, None]
}

grid_search = GridSearchCV(full_pipeline, param_grid, cv=5, scoring='f1_weighted', n_jobs=-1)
grid_search.fit(X_train, y_train)

print("Best Parameters:", grid_search.best_params_)
print("Best CV Score:", grid_search.best_score_)
```

### Swapping Model Algorithms Dynamically
You can even pass different classifier instances into `GridSearchCV` to test multiple algorithms inside the same pipeline:

```python
param_grid = [
    {
        'classifier': [RandomForestClassifier(random_state=42)],
        'classifier__n_estimators': [100, 200],
        'classifier__max_depth': [5, 10]
    },
    {
        'classifier': [LogisticRegression(random_state=42)],
        'classifier__C': [0.1, 1.0, 10.0],
        'classifier__solver': ['lbfgs', 'saga']
    }
]

grid_search = GridSearchCV(full_pipeline, param_grid, cv=5, scoring='f1_weighted')
grid_search.fit(X_train, y_train)
```

---

## 11.7 Inspecting Pipeline Steps & Extracting Feature Names

### Accessing Internal Steps
```python
# Access fitted preprocessor step
fitted_preprocessor = full_pipeline.named_steps['preprocessor']

# Access fitted classifier step
fitted_model = full_pipeline.named_steps['classifier']
print("Tree feature importances:", fitted_model.feature_importances_)
```

### Getting Transformed Feature Names (`get_feature_names_out`)
After one-hot encoding, column names change. Extract the exact feature names output by the preprocessor:

```python
# Get transformed feature names
feature_names = full_pipeline.named_steps['preprocessor'].get_feature_names_out()
print(feature_names)
# Output: ['num__age', 'num__fare', 'cat__embarked_C', 'cat__embarked_S', 'cat__sex_female', ...]

# Create a DataFrame of transformed training data for inspection
X_train_transformed = pd.DataFrame(
    full_pipeline.named_steps['preprocessor'].transform(X_train),
    columns=feature_names
)
```

---

## 11.8 Target Transformation: `TransformedTargetRegressor`

A `Pipeline` only transforms features $X$. It **does not transform the target $y$**. If your target $y$ is right-skewed and needs a log-transform ($y \to \log(1+y)$), wrap your pipeline inside `TransformedTargetRegressor`:

```python
import numpy as np
from sklearn.compose import TransformedTargetRegressor
from sklearn.linear_model import Ridge

# Automatically applies log1p to y during fit(), and expm1 to predictions during predict()
tt_model = TransformedTargetRegressor(
    regressor=full_pipeline,
    func=np.log1p,
    inverse_func=np.expm1
)

tt_model.fit(X_train, y_train)
y_pred_original_scale = tt_model.predict(X_test)  # predictions are automatically back on the original scale!
```

---

## 11.9 Common Pipeline Pitfalls & Summary Checklist

| Rule | Explanation |
|:---|:---|
| ❌ **Don't transform target $y$ inside `Pipeline`** | Use `TransformedTargetRegressor` instead. |
| ❌ **Don't drop rows inside a custom Transformer** | Scikit-learn transformers must preserve the row count ($N$). Dropping rows breaks downstream $y$ alignment. |
| ✅ **Always return a 2D array or DataFrame from `transform()`** | Scikit-learn expects 2D outputs `(n_samples, n_features)`. |
| ✅ **Pass `sparse_output=False` to `OneHotEncoder`** | If combining with `StandardScaler` in `ColumnTransformer`, dense arrays avoid sparsity type conflicts. |
| ✅ **Fit on `X_train`, transform on `X_test`** | Never call `.fit()` or `.fit_transform()` on test data. `pipe.predict(X_test)` calls `.transform(X_test)` internally. |

---
