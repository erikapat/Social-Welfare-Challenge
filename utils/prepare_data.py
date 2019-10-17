

# change the categorical variables to dummies
def from_categorical_to_dummies(CV_data, var):
    import pandas as pd
    import numpy as np

    df = pd.get_dummies(CV_data[var])
    ## eliminate the variable with minimum variance
    l = df.std()
    #l.idxmin() #kjkrfgld_UhSVl
    df = df.drop(columns = l.idxmin()) 
    #columns and tranformation
    col = list(df.columns)
    names = np.repeat(var, len(col), axis=0)
    col = paste(names, col, sep = '_')
    df.columns = col

    # Join the dummy variables to the main dataframe
    df_new = pd.concat([CV_data, df], axis=1)
    df_new[col] = df_new[col].apply(pd.to_numeric, downcast='float')

    CV_data = df_new
    CV_data = CV_data.drop(columns = var)
    return(CV_data)


# paste function: used to concatenate any type of variables
import functools
def reduce_concat(x, sep=""):
    return functools.reduce(lambda x, y: str(x) + sep + str(y), x)

def paste(*lists, sep=" ", collapse=None):
    result = map(lambda x: reduce_concat(x, sep=sep), zip(*lists))
    if collapse is not None:
        return reduce_concat(result, sep=collapse)
    return list(result)

# group variables by target
def group_var_target(dataset, target, var):
    g = dataset.groupby(var)
    x = g[target].value_counts(normalize=True)
    x = x.reset_index(var)
    x.columns = [var, 'count']
    x = x.reset_index(target)
    return x

# fill numeric na's
def fill_numeric_nas(dataset, k):
    #conda install -c brittainhard fancyimpute
    import numpy as np
    import pandas as pd
    from fancyimpute import KNN, MICE
    dataset['poor'] = dataset['poor'].astype('str')
    df_numeric = dataset.select_dtypes(include=[np.float])
    df_int = dataset.select_dtypes(include=[np.uint8])
    df_str = dataset.select_dtypes(include=[np.object])
    col = df_numeric.columns
    df_filled = pd.DataFrame(KNN(k, verbose=False).complete(df_numeric))
    #df_filled = pd.DataFrame(MICE(n_imputations=200, impute_type='col', verbose=False).complete(df_numeric.as_matrix()))
    df_filled.columns = col
    df = pd.concat([df_filled, df_str], axis=1)
    df = pd.concat([df, df_int], axis=1)
    return df


# correlations

# result can be used w/ seaborn's heatmap
def compute_correlation_matrix(df, method='pearson'):
    import pandas as pd
    corr_mat = df.corr()
    return corr_mat

def prepare_data(dataset, coll):
   import numpy as np
   # MANAGE OUTLIERS
   dataset = fix_extreme_values(dataset)
   # ELIMINATE VARIABLES To avoid multicolineality
   #
   # insert values in categorical variables 
   dataset.kjkrfgld.fillna('MISSING',inplace = True)
   dataset.bpowgknt.fillna('MISSING',inplace = True)
   dataset.raksnhjf.fillna('MISSING',inplace = True)
   dataset.vwpsxrgk.fillna('MISSING',inplace = True)
   #fill numeric na's
   dataset = fill_numeric_nas(dataset, 3)
   # include interactions
   dataset['inter_1'] = dataset['yfmzwkru'] * dataset['omtioxzz']
   dataset['inter_2'] = dataset['yfmzwkru'] * dataset['tiwrsloh']
   dataset['inter_3'] = dataset['yfmzwkru'] * dataset['weioazcf']
   dataset['inter_4'] = dataset['omtioxzz'] * dataset['tiwrsloh']
   dataset['inter_5'] = dataset['omtioxzz'] * dataset['weioazcf']
   dataset['inter_6'] = dataset['tiwrsloh'] * dataset['weioazcf']
   # one-hot-encodign
   dataset_complete = from_categorical_to_dummies(dataset, 'kjkrfgld')
   dataset_complete = from_categorical_to_dummies(dataset_complete, 'bpowgknt')
   dataset_complete = from_categorical_to_dummies(dataset_complete, 'raksnhjf')
   dataset_complete = from_categorical_to_dummies(dataset_complete, 'vwpsxrgk')
   
   cols = ['omtioxzz', 'tiwrsloh', 'weioazcf', 'yfmzwkru',  'inter_3', 
'inter_4', 'inter_6','kjkrfgld_GVYCk', 'kjkrfgld_MISSING', 'kjkrfgld_qzGkS', 'kjkrfgld_tnDpM', 'bpowgknt_MISSING', 'raksnhjf_qTmDg', 'raksnhjf_rXCdD', 'vwpsxrgk_ARuYG', 'vwpsxrgk_MISSING', 'vwpsxrgk_QRKWz',  'vwpsxrgk_bUhyU', 'vwpsxrgk_puHHm', 'vwpsxrgk_qcizG', 'vwpsxrgk_yKWYC'] #'omtioxzz', 'tiwrsloh', 'weioazcf',

  # filter variables 
   if len(coll) <= 1:
      dataset_complete = dataset_complete.drop(cols, axis=1)
   else:
      dataset_complete = dataset_complete.loc[:, coll]
      dataset_complete = dataset_complete.fillna(0) 
  
   d = {'False' : '0', 'True' : '1'} 
   dataset_complete['poor'] = dataset_complete['poor'].map(d) 
   dataset_complete['poor'] = dataset_complete['poor'].astype('int')
   return dataset_complete

def fix_extreme_values(df_numeric):
   # Fix the extreme values 
   x = df_numeric['yfmzwkru'].nlargest(2) 
   x = pd.DataFrame(x)
   out_max = x.max()
   next_value = x.min()
   df_numeric.loc[df_numeric['yfmzwkru'] >= out_max[0], 'yfmzwkru'] = next_value[0]

   x = df_numeric['omtioxzz'].nsmallest(2) 
   x = pd.DataFrame(x)
   out_min = x.min()
   next_value = x.max()
   df_numeric.loc[df_numeric['omtioxzz'] == out_min[0], 'omtioxzz'] = next_value[0]
   return df_numeric

import matplotlib.pyplot as plt
def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix'):

    import matplotlib.pyplot as plt
    import numpy as np
    import itertools
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    print(cm)

    plt.imshow(cm, interpolation='nearest', cmap= plt.cm.Blues ) #, cmap=cmap
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, format(cm[i, j], fmt),
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')


######################## -------------------   CHI-SQUARE --------------------------------------------------------------


import pandas as pd
import numpy as np
import scipy.stats as stats
from scipy.stats import chi2_contingency

class ChiSquare:
    def __init__(self, dataframe):
        self.df = dataframe
        self.p = None #P-Value
        self.chi2 = None #Chi Test Statistic
        self.dof = None
        
        self.dfObserved = None
        self.dfExpected = None
        
    def _print_chisquare_result(self, colX, alpha):
        result = ""
        if self.p<alpha:
            result="{0} is IMPORTANT for Prediction".format(colX)
        else:
            result="{0} is NOT an important predictor. (Discard {0} from model)".format(colX)

        print(result)
        
    def TestIndependence(self,colX,colY, alpha=0.05):
        X = self.df[colX].astype(str)
        Y = self.df[colY].astype(str)
        
        self.dfObserved = pd.crosstab(Y,X) 
        chi2, p, dof, expected = stats.chi2_contingency(self.dfObserved.values)
        self.p = p
        self.chi2 = chi2
        self.dof = dof 
        
        self.dfExpected = pd.DataFrame(expected, columns=self.dfObserved.columns, index = self.dfObserved.index)
        
        self._print_chisquare_result(colX,alpha)







