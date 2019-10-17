
def xgb_evaluate(max_depth, gamma, colsample_bytree, dtrain):
    import xgboost as xgb
    params = {'eval_metric': 'rmse',
              'max_depth': int(max_depth),
              'subsample': 0.8,
              'eta': 0.1,
              'gamma': gamma,
              'colsample_bytree': colsample_bytree}
    # Used around 1000 boosting rounds in the full model
    cv_result = xgb.cv(params, dtrain, num_boost_round=100, nfold=3)    
    
    # Bayesian optimization only knows how to maximize, not minimize, so return the negative RMSE
    return -1.0 * cv_result['test-rmse-mean'].iloc[-1]


def def_metrics(test_y, test_y_pred_dt):
    from sklearn.metrics import recall_score
    from sklearn.metrics import accuracy_score
    from sklearn.metrics import precision_score
    from sklearn.metrics import f1_score
    recall = recall_score(test_y, test_y_pred_dt)
    Accuracy = accuracy_score(test_y, test_y_pred_dt)
    precision = precision_score(test_y, test_y_pred_dt)
    F1_score = f1_score(test_y, test_y_pred_dt)
    print('Recall: ' + str(recall))
    print('Accuracy: ' + str(Accuracy))
    print('Precision: ' + str(precision))
    print('F1_score: ' + str(F1_score))
