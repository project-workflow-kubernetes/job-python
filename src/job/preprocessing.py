import os
import logging

import pandas as pd

import settings as s
import helpers as h


INPUTS_FILES = {'train.csv': {}}
OUTPUTS_FILES = {'clean_train.csv': {}}

FILENAME = os.path.basename(os.path.abspath(__file__)).split('.')[0]


def clean(df):
    out_df = df.dropna()

    return out_df


def task(train):
    '''
    data dependencies: `train` and `test`
    data outputs: `clean_train` and `clean_test`
    '''
    clean_train = clean(train)

    return [clean_train]


if __name__ == '__main__':
    try:
        s.logging.info('Starting {file}'.format(file=FILENAME))

        inputs = h.read_inputs(s.INPUT_PREFIX, INPUTS_FILES)
        outputs = task(*inputs)
        h.save_outputs(s.OUTPUT_PREFIX, outputs, OUTPUTS_FILES, FILENAME)

        s.logging.info('Finished {file}'.format(file=FILENAME))

    except Exception as e:
        s.logging.error(str(e))
        raise e
