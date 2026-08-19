# 9. Evaluation Metrics — Classification


**Intuition:** Accuracy is not enough. On a dataset with 99% negative samples, a model that always predicts "negative" achieves 99% accuracy and is completely useless. You need metrics that separately measure different types of correctness.

---

## 9.1 The Confusion Matrix

The confusion matrix is the foundation of all classification metrics. It breaks down predictions into four categories based on the actual and predicted classes.

|  | **Predicted: Positive** | **Predicted: Negative** |
|:---|:---:|:---:|
| **Actual: Positive** | **TP** (True Positive) | **FN** (False Negative) |
| **Actual: Negative** | **FP** (False Positive) | **TN** (True Negative) |

- **TP** — Correctly predicted Positive. The model said yes, it was yes.
- **TN** — Correctly predicted Negative. The model said no, it was no.
- **FP** — **Type I Error** (False Alarm). The model said yes, it was actually no. (e.g., flagging a healthy patient as sick)
- **FN** — **Type II Error** (Miss). The model said no, it was actually yes. (e.g., missing a cancerous tumour)

```python
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
import matplotlib.pyplot as plt

cm = confusion_matrix(y_test, y_pred)
print(cm)

# Visualise
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['Negative', 'Positive'])
disp.plot(cmap='Blues')
plt.title('Confusion Matrix')
plt.show()

# Normalised version (show proportions instead of counts)
cm_normalised = confusion_matrix(y_test, y_pred, normalize='true')
# normalize='true': normalise by row (actual class)
# normalize='pred': normalise by column (predicted class)
# normalize='all':  normalise by total samples
```

---

## 9.2 Accuracy

$$\boxed{\text{Accuracy} = \frac{TP + TN}{TP + FP + FN + TN}}$$

The proportion of all predictions that are correct.

**The imbalance problem:** On a dataset with 950 negatives and 50 positives (95% negative), a model that blindly predicts "Negative" for everything achieves:

$$\text{Accuracy} = \frac{0 + 950}{0 + 0 + 50 + 950} = 95\%$$

This model is completely useless — it never predicts the positive class. Accuracy gave you a 95% score and told you nothing.

```python
from sklearn.metrics import accuracy_score
print(f"Accuracy: {accuracy_score(y_test, y_pred):.4f}")
```

**When to use:** Only when classes are balanced and misclassification costs are equal. Almost never the right primary metric for real-world problems.

---

## 9.3 Precision

$$\boxed{\text{Precision} = \frac{TP}{TP + FP}}$$

**"Of all the samples I predicted as Positive, what fraction were actually Positive?"**

Precision measures the cost of **false positives**. A high-precision model rarely sounds a false alarm.

**Mnemonic:** Precision = how *precise* your positive calls are. When you predict positive, you're usually right.

```python
from sklearn.metrics import precision_score
print(f"Precision: {precision_score(y_test, y_pred):.4f}")
```

**Use when FP is costly:**
- Email spam filter — a FP (legitimate email flagged as spam) is very bad; user misses important mail.
- Legal system — wrongly convicting an innocent person (FP).
- Search engine — showing irrelevant results (FP) frustrates users.

---

## 9.4 Recall (Sensitivity, True Positive Rate)

$$\boxed{\text{Recall} = \frac{TP}{TP + FN}}$$

**"Of all the samples that actually are Positive, what fraction did I catch?"**

Recall measures the cost of **false negatives**. A high-recall model misses few positive cases.

**Mnemonic:** Recall = how many positives you *recall* (retrieve). Of all the positives out there, how many did you find?

```python
from sklearn.metrics import recall_score
print(f"Recall: {recall_score(y_test, y_pred):.4f}")
```

**Use when FN is costly:**
- Cancer screening — a FN (missed tumour) means the patient goes untreated.
- Fraud detection — a FN (missed fraud) means financial loss.
- Earthquake early warning — a FN (missed earthquake) is catastrophic.

---

## 9.5 Specificity (True Negative Rate)

$$\boxed{\text{Specificity} = \frac{TN}{TN + FP} = 1 - FPR}$$

**"Of all the actual Negatives, what fraction did I correctly identify as Negative?"**

Specificity is the complement of the False Positive Rate (FPR). It's analogous to Recall but for the negative class.

```python
from sklearn.metrics import confusion_matrix
tn, fp, fn, tp = confusion_matrix(y_test, y_pred).ravel()
specificity = tn / (tn + fp)
print(f"Specificity: {specificity:.4f}")
```

**Sensitivity (Recall) vs. Specificity:**
- Sensitivity = catching the sick patients (TP rate for Positives).
- Specificity = correctly clearing the healthy patients (TN rate for Negatives).
- In medical testing, you often want both high sensitivity AND high specificity, but there's a tradeoff.

---

## 9.6 F-β Score

The F-score is the **harmonic mean** of Precision and Recall, with $\beta$ controlling the relative importance.

$$\boxed{F_\beta = (1 + \beta^2) \cdot \frac{\text{Precision} \cdot \text{Recall}}{\beta^2 \cdot \text{Precision} + \text{Recall}}}$$

**Why harmonic mean?** Unlike the arithmetic mean, the harmonic mean is low when *either* component is low. A model with Precision = 1.0 and Recall = 0.01 should not score 0.505 — its harmonic mean is just 0.02. The harmonic mean correctly penalises imbalance between P and R.

### F1 Score ($\beta = 1$) — Equal weight
$$F_1 = 2 \cdot \frac{\text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}}$$

```python
from sklearn.metrics import f1_score
print(f"F1: {f1_score(y_test, y_pred):.4f}")
```

### F2 Score ($\beta = 2$) — Recall matters twice as much
Use when missing a positive is worse than a false alarm (medical, fraud, safety).

$$F_2 = 5 \cdot \frac{\text{Precision} \cdot \text{Recall}}{4 \cdot \text{Precision} + \text{Recall}}$$

### F0.5 Score ($\beta = 0.5$) — Precision matters twice as much
Use when false alarms are worse than misses (spam filter, recommendation system).

```python
from sklearn.metrics import fbeta_score
f2  = fbeta_score(y_test, y_pred, beta=2)
f05 = fbeta_score(y_test, y_pred, beta=0.5)
```

---

## 9.7 Multiclass Averaging

For problems with $> 2$ classes, metrics like Precision, Recall, and F1 are computed per class and then aggregated:

| Averaging | How | When to use |
|:---|:---|:---|
| **Macro** | Unweighted mean across all classes: $\frac{1}{K}\sum_k \text{metric}_k$ | All classes are equally important, even rare ones |
| **Micro** | Pool all TP, FP, FN globally, then compute: $\frac{\sum TP}{\sum TP + \sum FP}$ | Class imbalance exists; overall correctness matters |
| **Weighted** | Weighted mean by class support (number of true instances): $\frac{\sum n_k \cdot \text{metric}_k}{n}$ | Class imbalance; want to account for class frequency |

```python
from sklearn.metrics import precision_score, recall_score, f1_score

print(f"Macro  F1: {f1_score(y_test, y_pred, average='macro'):.4f}")
print(f"Micro  F1: {f1_score(y_test, y_pred, average='micro'):.4f}")
print(f"Weighted F1: {f1_score(y_test, y_pred, average='weighted'):.4f}")

# Full report — the best way to see all metrics at once
from sklearn.metrics import classification_report
print(classification_report(y_test, y_pred, target_names=['Class 0', 'Class 1', 'Class 2']))
```

---

## 9.8 Matthews Correlation Coefficient (MCC)

A single metric that captures all four cells of the confusion matrix, symmetric with respect to both classes. Particularly useful for **binary classification with imbalanced classes**.

$$\boxed{MCC = \frac{TP \cdot TN - FP \cdot FN}{\sqrt{(TP+FP)(TP+FN)(TN+FP)(TN+FN)}}}$$

- $MCC = +1$: Perfect prediction.
- $MCC = 0$: No better than random.
- $MCC = -1$: Perfect inverse prediction.

```python
from sklearn.metrics import matthews_corrcoef
print(f"MCC: {matthews_corrcoef(y_test, y_pred):.4f}")
```

**Why MCC > Accuracy/F1 for imbalanced data:** MCC uses all four cells of the confusion matrix. It will be high only if the model performs well on *both* classes — you can't fool it by always predicting the majority class.

---

## 9.9 Cohen's Kappa

Measures agreement between predictions and ground truth, **corrected for chance agreement**:

$$\boxed{\kappa = \frac{p_o - p_e}{1 - p_e}}$$

where $p_o$ = observed accuracy, $p_e$ = expected accuracy a random classifier would achieve.

| $\kappa$ | Interpretation |
|:---:|:---|
| $< 0$ | Less agreement than chance |
| $0.0–0.2$ | Slight |
| $0.2–0.4$ | Fair |
| $0.4–0.6$ | Moderate |
| $0.6–0.8$ | Substantial |
| $0.8–1.0$ | Almost perfect |

```python
from sklearn.metrics import cohen_kappa_score
print(f"Cohen's κ: {cohen_kappa_score(y_test, y_pred):.4f}")
```

---

## 9.10 ROC-AUC Curve

### What it is
The **Receiver Operating Characteristic (ROC)** curve plots the **True Positive Rate (Recall/Sensitivity)** against the **False Positive Rate (1 - Specificity)** at every possible classification threshold $t \in [0, 1]$.

$$TPR(t) = \frac{TP(t)}{TP(t) + FN(t)} \qquad FPR(t) = \frac{FP(t)}{FP(t) + TN(t)}$$

At $t = 0$: every sample predicted Positive → TPR = 1, FPR = 1 (top-right corner).  
At $t = 1$: no sample predicted Positive → TPR = 0, FPR = 0 (bottom-left corner).  
As $t$ decreases from 1 to 0, the operating point traces a curve from bottom-left to top-right.

### AUC — Area Under the Curve
AUC is the area under the ROC curve.

| AUC | Interpretation |
|:---:|:---|
| 1.0 | Perfect model — can perfectly rank all positives above all negatives |
| 0.5 | Random classifier — the diagonal line |
| < 0.5 | Model is inversely predicting (flip all predictions to get a model with AUC > 0.5) |

**Probabilistic interpretation:** AUC = the probability that a randomly selected positive sample gets a **higher model score** than a randomly selected negative sample. An AUC of 0.85 means: if you pick a random positive and a random negative, there's an 85% chance the model ranks the positive higher.

**Key property: threshold-independent.** AUC evaluates the model's *ranking* ability across all thresholds, not at any specific threshold. This makes it useful for comparing models independent of the operating point.

```python
from sklearn.metrics import roc_auc_score, roc_curve
import matplotlib.pyplot as plt

# Requires probability scores, not hard predictions
y_proba = model.predict_proba(X_test)[:, 1]   # probability of positive class

fpr, tpr, thresholds = roc_curve(y_test, y_proba)
auc = roc_auc_score(y_test, y_proba)

plt.figure(figsize=(7, 6))
plt.plot(fpr, tpr, lw=2, label=f'ROC curve (AUC = {auc:.3f})')
plt.plot([0, 1], [0, 1], 'k--', lw=1, label='Random (AUC = 0.5)')
plt.fill_between(fpr, tpr, alpha=0.1)
plt.xlabel('False Positive Rate (1 - Specificity)')
plt.ylabel('True Positive Rate (Recall)')
plt.title('ROC Curve')
plt.legend(loc='lower right')
plt.grid(True, alpha=0.3)
plt.show()
```

### Multiclass ROC-AUC
```python
# OVR (One-vs-Rest): compute AUC for each class vs. all others, then average
auc_ovr = roc_auc_score(y_test, y_proba_all_classes, multi_class='ovr', average='macro')

# OVO (One-vs-One): compute AUC for each pair of classes, then average
auc_ovo = roc_auc_score(y_test, y_proba_all_classes, multi_class='ovo', average='macro')
```

---

## 9.11 Precision-Recall Curve & Average Precision

### When to prefer PR curve over ROC
On **highly imbalanced datasets**, the ROC curve can be **misleadingly optimistic**. Why? The FPR term $\frac{FP}{FP + TN}$ has TN in the denominator — when the majority class is Negative, TN is huge, so FPR stays small even with many FPs. The ROC curve doesn't "see" those false positives clearly.

The **PR curve** focuses entirely on the positive class — it uses TP, FP, and FN, completely ignoring TN. It is more discriminating on imbalanced data.

$$\text{PR curve: } \text{Precision}(t) \text{ vs. } \text{Recall}(t) \text{ as threshold } t \text{ varies}$$

- **High recall, low precision:** Model casts a wide net — catches most positives, but many false alarms.
- **High precision, low recall:** Model is conservative — only predicts positive when very confident, but misses many.

### Average Precision (AP)
The area under the PR curve, approximated as a weighted mean of Precisions at each recall level where recall increases:

$$AP = \sum_k (R_k - R_{k-1}) \cdot P_k$$

```python
from sklearn.metrics import precision_recall_curve, average_precision_score
import matplotlib.pyplot as plt

y_proba = model.predict_proba(X_test)[:, 1]

precision, recall, thresholds = precision_recall_curve(y_test, y_proba)
ap = average_precision_score(y_test, y_proba)

plt.figure(figsize=(7, 6))
plt.plot(recall, precision, lw=2, label=f'PR curve (AP = {ap:.3f})')
plt.axhline(y=y_test.mean(), color='k', linestyle='--', label=f'Baseline (prevalence = {y_test.mean():.3f})')
plt.xlabel('Recall')
plt.ylabel('Precision')
plt.title('Precision-Recall Curve')
plt.legend()
plt.grid(True, alpha=0.3)
```

> [!NOTE]
> The random classifier baseline for a PR curve is the **prevalence** (positive rate), not 0.5. If positives make up 5% of the data, a random classifier has AP ≈ 0.05, not 0.5. A good model's AP should be significantly above the prevalence line.

---

## 9.12 Choosing & Tuning the Decision Threshold

Most classifiers output a **probability score** (via `predict_proba`), not a hard label. The default threshold is 0.5 — predict Positive if score > 0.5. This is often *not* the best threshold.

### Tuning the threshold for a specific goal

```python
import numpy as np
from sklearn.metrics import precision_score, recall_score, f1_score

y_proba = model.predict_proba(X_test)[:, 1]
thresholds = np.linspace(0, 1, 101)

results = []
for t in thresholds:
    y_pred_t = (y_proba >= t).astype(int)
    if y_pred_t.sum() == 0:   # no positive predictions
        continue
    results.append({
        'threshold': t,
        'precision': precision_score(y_test, y_pred_t, zero_division=0),
        'recall':    recall_score(y_test, y_pred_t, zero_division=0),
        'f1':        f1_score(y_test, y_pred_t, zero_division=0)
    })

df_thresh = pd.DataFrame(results)
best_f1_thresh = df_thresh.loc[df_thresh['f1'].idxmax(), 'threshold']
print(f"Threshold maximising F1: {best_f1_thresh:.2f}")

# Apply the chosen threshold
y_pred_final = (y_proba >= best_f1_thresh).astype(int)
```

### Finding the optimal threshold from the ROC curve

The point on the ROC curve closest to the top-left corner $(0, 1)$ — perfect TPR with no FPR — often gives a good operating threshold:

```python
fpr, tpr, thresholds = roc_curve(y_test, y_proba)
optimal_idx = np.argmax(tpr - fpr)   # Youden's J statistic
optimal_threshold = thresholds[optimal_idx]
print(f"Optimal ROC threshold (Youden's J): {optimal_threshold:.3f}")
```

---

## 9.13 Metrics Quick-Reference

| Metric | Formula | Best for |
|:---|:---|:---|
| Accuracy | $(TP+TN)/N$ | Balanced classes, equal misclassification costs |
| Precision | $TP/(TP+FP)$ | FP is costly (spam, false alarms) |
| Recall | $TP/(TP+FN)$ | FN is costly (cancer, fraud, safety) |
| Specificity | $TN/(TN+FP)$ | Medical testing (true negative rate) |
| F1 | $2PR/(P+R)$ | Imbalanced classes; balanced P/R tradeoff |
| F2 | $\beta=2$ F-score | Recall matters more than Precision |
| F0.5 | $\beta=0.5$ F-score | Precision matters more than Recall |
| MCC | All 4 cells | Binary, highly imbalanced data |
| Cohen's κ | Chance-corrected accuracy | Agreement tasks, multiclass |
| ROC-AUC | Area under ROC | Ranking ability, threshold-independent |
| Average Precision | Area under PR | Imbalanced binary classification |

---
