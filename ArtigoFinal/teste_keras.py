from __future__ import absolute_import, division, print_function, unicode_literals

import pathlib

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns

import tensorflow as tf

from tensorflow import keras
from tensorflow.keras import layers



file = 'C:/Bitnami/wampstack-7.1.28-0/apache2/htdocs/LogicaFuzzy2019-2/ArtigoFinal/tanques.csv'

dataset = pd.read_csv(file)

dataset.columns  # Check cols and names

del dataset['Unnamed: 0']  # Remove index col
del dataset['TP']  # Remove index col

dataset.isna().sum()  # Check if dataset is clean

train_dataset = dataset.sample(frac=0.8, random_state=0)
test_dataset = dataset.drop(train_dataset.index)

sns.pairplot(train_dataset[['TA', 'CN', 'PER', 'Slope']], diag_kind="kde")  # Basic Plots

train_stats = train_dataset.describe()
train_stats.pop("TA")
train_stats = train_stats.transpose()
train_stats

train_labels = train_dataset.pop('TA')
test_labels = test_dataset.pop('TA')


def norm(x):
    return (x - train_stats['mean']) / train_stats['std']


normed_train_data = norm(train_dataset)
normed_test_data = norm(test_dataset)


def build_model():
    model = keras.Sequential([
    layers.Dense(64, activation='relu', input_shape=[len(train_dataset.keys())]),
    layers.Dense(64, activation='relu'),
    layers.Dense(1)
    ])

    optimizer = tf.keras.optimizers.RMSprop(0.001)

    model.compile(loss='mse',
                optimizer=optimizer,
                metrics=['mae', 'mse'])
    return model


model = build_model()

model.summary()

example_batch = normed_train_data[:10]
example_result = model.predict(example_batch)
example_result
