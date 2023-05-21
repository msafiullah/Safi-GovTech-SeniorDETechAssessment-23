#!/usr/bin/env python3

import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OrdinalEncoder

from sklearn.metrics import confusion_matrix, classification_report

import matplotlib.pyplot as plt
from sklearn import tree


# Read data from CSV file
columns = ['buying_price', 'maintenance', 'doors', 'persons', 'lug_boot', 'safety', 'class_value']
df = pd.read_csv("cars.csv", names=columns)

# Model parameter columns
X = df.drop(['buying_price', 'persons'], axis = 1)

# Prediction result column
y = df['buying_price']

# Categorical values of model parameters
# buying_price_category = ['low', 'med', 'high', 'vhigh']
maintenance_category = ['low', 'med', 'high', 'vhigh']
doors_category = ['2', '3', '4', '5more']
# persons_category = ['2', '4', 'more']
lug_boot_category = ['small', 'med', 'big']
safety_category = ['low', 'med', 'high']
class_value_category = ['unacc', 'acc', 'good', 'vgood']

all_categories = [maintenance_category, doors_category, lug_boot_category, safety_category, class_value_category]

# Encode categorical features as an integer array
oe = OrdinalEncoder(categories=all_categories)

# Fit OE transformer to X parameters
# Obtain a transformed version of X
X = oe.fit_transform( df[['maintenance', 'doors', 'lug_boot', 'safety', 'class_value']] )
# X value is an array of encoded integers

# Split arrays into random train and test subsets.
test_size = 4/1728.0  # Choose 4 out of 1728 obervations to be part of test records.
random_state=21
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = test_size, random_state=random_state)
# X_train  - X input parameters for training
# X_test   - X input parameters for testing
# y_train  - y output prediction value for training
# y_test   - y ouput prediction value for testing

# Create a decision tree classfier
# Using the 'gini' function to measure the quality of split
# Max depth of decition tree is 2
# Minimum number of samples required to split the internal node is 10
max_depth_value = 2
min_samples_split_value = 10
DT_classifier = DecisionTreeClassifier( criterion= 'gini', max_depth= max_depth_value, min_samples_split= min_samples_split_value )
DT_classifier.fit(X_train, y_train)

# Use the above trained decision tree classifier model to predict car buying price for input test parameters
y_pred = DT_classifier.predict(X_test)

# Display text report showing the main classification metrics.
report1 = classification_report(y_test, y_pred, zero_division=1, output_dict=True)
report2 = classification_report(y_test, y_pred, zero_division=1, output_dict=False)
print ( "Model Accuracy = {:.0%}".format(report1['accuracy']) )
print()
print("Model Accuracy Report:\n", report2)

# Predict the buying price given the following parameters:
# Maintenance = High
# Number of doors = 4
# Lug Boot Size = Big
# Safety = High
# Class Value = Good
print( """
Predict the buying price given the following parameters:
    - Maintenance = High
    - Number of doors = 4
    - Lug Boot Size = Big
    - Safety = High
    - Class Value = Good
""")

maintenance, doors, lug_boot, safety, class_value = 'high', '4', 'big', 'high', 'good'
X_input = oe.fit_transform( [[maintenance, doors, lug_boot, safety, class_value]] )
y_output = DT_classifier.predict(X_input)
print("Predicted buying price:", y_output)

fig = plt.figure(figsize=(15,8))
_ = tree.plot_tree(DT_classifier, feature_names=df.columns[1:], class_names= DT_classifier.classes_, filled=True)
plt.show()
