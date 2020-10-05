"""
This code normalises the intensity data for fig3 using the Robust Scaler.
Originally used in pycharm scientific mode.
"""
# %% Load data
import pandas as pd
import numpy as np

project_folder = 'D:/Code/repos/synapse-redistribution/'
data = pd.read_csv(f'{project_folder}spine_labeling/intensity.csv')
# %% split into separate df, because of different number of rows there are nan otherwise
main = data[['fish1_x', 'fish1_y']].dropna()
main.head()
exta = data[['fish2_x', 'fish2_y']].dropna()
exta.head()
extb = data[['fish3_x', 'fish3_y']].dropna()
extb.head()
# %% 1. Robust Scaler
from sklearn.preprocessing import RobustScaler

scaler = RobustScaler()
main_scaled = scaler.fit_transform(main)
exta_scaled = scaler.fit_transform(exta)
extb_scaled = scaler.fit_transform(extb)

print('main_scaled means (Spine Int, PSD95 Int): ', main_scaled.mean(axis=0))
print('exta_scaled means (Spine Int, PSD95 Int): ', exta_scaled.mean(axis=0))
print('extb_scaled means (Spine Int, PSD95 Int): ', extb_scaled.mean(axis=0))

print('main_scaled std (Spine Int, PSD95 Int): ', main_scaled.std(axis=0))
print('exta_scaled std (Spine Int, PSD95 Int): ', exta_scaled.std(axis=0))
print('extb_scaled std (Spine Int, PSD95 Int): ', extb_scaled.std(axis=0))

print('main_scaled Min (Spine Int, PSD95 Int): ', main_scaled.min(axis=0))
print('exta_scaled Min (Spine Int, PSD95 Int): ', exta_scaled.min(axis=0))
print('extb_scaled Min (Spine Int, PSD95 Int): ', extb_scaled.min(axis=0))

print('main_scaled Max (Spine Int, PSD95 Int): ', main_scaled.max(axis=0))
print('exta_scaled Max (Spine Int, PSD95 Int): ', exta_scaled.max(axis=0))
print('extb_scaled Max (Spine Int, PSD95 Int): ', extb_scaled.max(axis=0))
# %% Put all 3 Fish together and save as a csv
data_scaled = pd.concat([pd.DataFrame(main_scaled, columns=['fish1_x', 'fish1_y']),
                         pd.DataFrame(exta_scaled, columns=['fish2_x', 'fish2_y']),
                         pd.DataFrame(extb_scaled, columns=['fish3_x', 'fish3_y'])],
                        axis=1)

data_scaled.to_csv(f'{project_folder}spine_labeling/fig3_main_extended_scale25to75.csv')
