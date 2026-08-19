# 12. Inference & Deployment Checklist


Once the final model is trained and evaluated:

1. **Retrain on full data** (train + validation) before deployment if you used a hold-out val set.
2. **Save the fitted pipeline** (not just the model — you need the scaler/imputer too).
   ```python
   import joblib
   joblib.dump(pipe, 'model_pipeline.pkl')
   loaded_pipe = joblib.load('model_pipeline.pkl')
   ```
3. **Prediction on new data:**
   ```python
   y_pred = loaded_pipe.predict(X_new)
   y_proba = loaded_pipe.predict_proba(X_new)  # for probability scores
   ```
4. **Check for distribution shift** — monitor whether real-world input features start drifting from the training distribution.
5. **Calibration** — if probabilities matter (not just class labels), check if `predict_proba` is well-calibrated using a calibration curve. Use `CalibratedClassifierCV` if needed.

---
