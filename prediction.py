import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import accuracy_score
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier


# Load data from CSV file
data = pd.read_csv('finaltable.csv000')
df = pd.DataFrame(data)

features = ['season', 'tds #', '# days']
target = 'charge range'

X = df[features]
y = df[target]

train_years = [2013, 2014, 2016, 2017,2018, 2019, 2020, 2022]
test_years = [2015, 2018, 2021, 2023]
#
# # Split the data into training and testing sets based on the year column
train_data = df[df['year'].isin(train_years)]
X_train = train_data[features]
y_train = train_data[target]

test_data = df[df['year'].isin(test_years)]
X_test = test_data[features]
y_test = test_data[target]


grad = GradientBoostingClassifier()
grad.fit(X, y)
y_pred = grad.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f"Gradient Boosting Accuracy: {accuracy}")

deci = DecisionTreeClassifier(random_state=42)
deci.fit(X_train, y_train)
y_pred = deci.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print("Decision Tree Accuracy:", accuracy)

knn = KNeighborsClassifier(n_neighbors=5)
knn.fit(X_train, y_train)
y_pred = knn.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print("KNN Accuracy:", accuracy)
