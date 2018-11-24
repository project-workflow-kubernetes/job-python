import os

import pandas as pd
from sklearn.model_selection import train_test_split

import settings as s
import helpers as h


INPUTS_FILES = {'clean_train.csv': {}}
OUTPUTS_FILES = {'X_train.csv': {},
                 'X_val.csv': {},
                 'y_train.csv': {},
                 'y_val.csv': {}}
FILENAME = os.path.basename(os.path.abspath(__file__)).split('.')[0]


def split(df):
    X, y = df.values[:, 1:], df.values[:, 0].reshape(len(df), 1)

    splits = train_test_split(X, y, test_size=0.2, random_state=42)

    return [pd.DataFrame(s) for s in splits]


def task(clean_train):
    '''
    data dependencies: `clean_train`
    data outputs: `X_train`; `X_val`; `y_train`; `y_test`
    '''
    return split(clean_train)


if __name__ == '__main__':

    try:
        s.logging.info('Starting {file}'.format(file=FILENAME))

        inputs = h.read_inputs(s.INPUT_PREFIX, INPUTS_FILES)
        outputs = task(*inputs)
        h.save_outputs(s.OUTPUT_PREFIX, outputs, OUTPUTS_FILES, FILENAME)

    except Exception as e:
        s.logging.error(str(e))
        raise e
