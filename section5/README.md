# Decision Tree Classifier Model

- Using decision tree classifier model to predict Car's buying price based on 5 of it's other attributes like maintenance cost, number of doors, luggage boot size, safety and class.
- The model has an accuracy of 100%.
- There were 1728 observations. A random collection of 4 observations are being used for test. 1724 observations are being used for training the model.
- The decision tree model is configured to go up to a max_depth of 2, with min_samples_split_value of 10.

# Execute Model
Obtain the predictions, accuracy and decision tree diaram yourself by executing below commands.

```
pip3 install --user -r requirements.txt
python3 model_dt.py
```

# Answer to task question

Predict the buying price given the following parameters:
- Maintenance = High
- Number of doors = 4
- Lug Boot Size = Big
- Safety = High
- Class Value = Good

Model predicted that buying price for these parameters will be: _**low**_ .