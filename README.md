This project analyzes a comprehensive NYCHA dataset from 2013 to February 2023, comprising 50,316 records with 25 attributes and 111 unique development identifiers (TDS#), to identify seasonal trends in water consumption and costs, aiming to improve water resource management and cost optimization by predicting water charges based on seasonal timestamps and unique TDS numbers.

**AWS Services used:**

* Amazon S3
* AWS Glue
* Amazon Redshift
* Amazon Athena
* Amazon Quickshift
* Cloud9

Data Pipeline Steps are used for the prediction:

**Ingestion:**

The data is ingested into the Amazon S3 bucket using the ELT (Extract, Load, and Transform) method as data needs to be loaded prior to  applying transformations to prepare it for further steps in the pipeline.

**Storage:**

For storage and querying, Amazon Redshift is preferred over AWS Glue because of its high performance on complex queries, which was crucial for analysis. However, issues were encountered during the data loading process. The primary issues was with the date format and the presence of '#' in column values. To resolve these, the data is configured during loading process to accept any date format and specified string(‘#N/A’), present in the column values as null.

**Processing:**

_Feature Selection:_

The first step in data wrangling steps is feature selection. The relevant features for prediction included:

* “TDS #” – Unique development identifier.
  
* “Revenue Month” – Month and year of water consumption bill.
  
* “days #” – Number of Days on bill.
  
* “Water& Sewer Charges” – Total Water & Sewer Charges
  
The ‘charges’ attribute is chosen upon ‘consumption’ attribute because of multiple lines of inaccurate consumption data values.

_Cleaning:_

The data is cleaned by removing records with null or improper values. For example, the dataset included 60 records with null values in 'TDS #' and 21 records where the '#days' attribute was either null or less than or equal to zero. 'Water & Sewer Charges' attribute values are also corrected to make it suitable for analysis. 
Unnecessary data that might affect the effectiveness of machine learning algorithms is cleaned. This involved:

* Removing rows where '#days' were less than 25 or greater than 35, as the number of days might affect the season determination.
  
* Removing records of particular 'TDS #' that had fewer records than the median, as fewer records wouldn’t provide accurate results during prediction.
  
* Removing records with 'Water & Sewer charges' equal to zero.


_Normalization:_

The data is normalized by converting the month values into corresponding seasons. For example, months 3, 4, and 5 are classified as Spring, while months 12, 1, and 2 are classified as Winter."
'Water & Sewer Charges', continuous attribute and target is converted into categorical and renamed to ‘Charge Range’, such as '0-1000', '1001-2000', etc. This step was crucial to ensure that the data was ready for analysis and machine learning.
At the end of processing, our dataset contains 45805 records and five columns naming, “TDS #”, “Season”, “days#”, “Year” and “Charge Range”.

The SQL queries used for Processing are below
```
CREATE TABLE finaltable 
AS
SELECT "TDS #", "# days", "year", "season", "charge range" FROM 
(SELECT *,
    -- Extracting Month
    CAST(SUBSTRING("Revenue Month", CHARINDEX('-', "Revenue Month") + 1, LEN("Revenue Month") - CHARINDEX('-', "Revenue Month")) AS INT) AS "Month",
    -- Extracting Year
    CAST(SUBSTRING("Revenue Month", 1, CHARINDEX('-', "Revenue Month") - 1) AS INT) AS "Year",
    -- Determining Season based on Month
    CASE
        WHEN CAST(SUBSTRING("Revenue Month", CHARINDEX('-', "Revenue Month") + 1, LEN("Revenue Month") - CHARINDEX('-', "Revenue Month")) AS INT) IN (3, 4, 5) THEN 1
        WHEN CAST(SUBSTRING("Revenue Month", CHARINDEX('-', "Revenue Month") + 1, LEN("Revenue Month") - CHARINDEX('-', "Revenue Month")) AS INT) IN (6, 7, 8) THEN 2
        WHEN CAST(SUBSTRING("Revenue Month", CHARINDEX('-', "Revenue Month") + 1, LEN("Revenue Month") - CHARINDEX('-', "Revenue Month")) AS INT) IN (9, 10, 11) THEN 3
        WHEN CAST(SUBSTRING("Revenue Month", CHARINDEX('-', "Revenue Month") + 1, LEN("Revenue Month") - CHARINDEX('-', "Revenue Month")) AS INT) IN (12, 1, 2) THEN 4
    END AS "Season",
    -- Determining Charge Range
    CASE
        WHEN "Water&Sewer Charges" > 0 AND "Water&Sewer Charges" <= 1000 THEN '0-1000'
        WHEN "Water&Sewer Charges" > 1000 AND "Water&Sewer Charges" <= 2000 THEN '1001-2000'
        WHEN "Water&Sewer Charges" > 2000 AND "Water&Sewer Charges" <= 3000 THEN '2001-3000'
        WHEN "Water&Sewer Charges" > 3000 AND "Water&Sewer Charges" <= 4000 THEN '3001-4000'
        WHEN "Water&Sewer Charges" > 4000 AND "Water&Sewer Charges" <= 5000 THEN '4001-5000'
        WHEN "Water&Sewer Charges" > 5000 AND "Water&Sewer Charges" <= 6000 THEN '5001-6000'
        WHEN "Water&Sewer Charges" > 6000 AND "Water&Sewer Charges" <= 7000 THEN '6001-7000'
        WHEN "Water&Sewer Charges" > 7000 AND "Water&Sewer Charges" <= 8000 THEN '7001-8000'
        WHEN "Water&Sewer Charges" > 8000 AND "Water&Sewer Charges" <= 9000 THEN '8001-9000'
        WHEN "Water&Sewer Charges" > 9000 AND "Water&Sewer Charges" <= 10000 THEN '9001-10000'
        WHEN "Water&Sewer Charges" > 10000 AND "Water&Sewer Charges" <= 11000 THEN '10000-11000'
        WHEN "Water&Sewer Charges" > 11000 AND "Water&Sewer Charges" <= 12000 THEN '11001-12000'
        WHEN "Water&Sewer Charges" > 12000 AND "Water&Sewer Charges" <= 13000 THEN '12001-13000'
        WHEN "Water&Sewer Charges" > 13000 AND "Water&Sewer Charges" <= 14000 THEN '13001-14000'
        WHEN "Water&Sewer Charges" > 14000 AND "Water&Sewer Charges" <= 15000 THEN '14001-15000'
        WHEN "Water&Sewer Charges" > 15000 AND "Water&Sewer Charges" <= 16000 THEN '15001-16000'
        WHEN "Water&Sewer Charges" > 16000 AND "Water&Sewer Charges" <= 17000 THEN '16001-17000'
        WHEN "Water&Sewer Charges" > 17000 AND "Water&Sewer Charges" <= 18000 THEN '17001-18000'
        WHEN "Water&Sewer Charges" > 18000 AND "Water&Sewer Charges" <= 19000 THEN '18001-19000'
        WHEN "Water&Sewer Charges" > 19000 AND "Water&Sewer Charges" <= 20000 THEN '19001-20000'
        WHEN "Water&Sewer Charges" > 20000 AND "Water&Sewer Charges" <= 30000 THEN '20001-30000'
        WHEN "Water&Sewer Charges" > 30000 AND "Water&Sewer Charges" <= 40000 THEN '30001-40000'
        WHEN "Water&Sewer Charges" > 40000 AND "Water&Sewer Charges" < 50000 THEN '40001-50000'
        ELSE 'Out of range'
    END AS "Charge range"
FROM "dev"."public"."redwatertable"
WHERE
CAST("# days" AS INT) BETWEEN 25 and 35 
AND "tds #" is NOT NULL 
AND CAST(REPLACE("Water&Sewer Charges",',','') AS FLOAT) > 0)
```
SQL Query to Unload Data from Redshift to S3 Bucket
```
UNLOAD ('SELECT * from "dev"."public"."finaltable"')
TO 's3://waterdataprojectfinal/finaltable.csv'
IAM_ROLE 'arn:aws:iam::130387669856:role/LabRole'
FORMAT AS CSV
DELIMITER AS ','
PARALLEL OFF
HEADER;
```

**Analysis and Visualization:**

Once the data was cleaned and normalized, analysis and visualization is done. The final data was stored in Amazon Athena using AWS Glue Crawler. However, no records were found in Athena upon loading. This issue was resolved by unloading the processed data into a new S3 bucket and re-running the Glue Crawler. The tables are created in Glue and Athena data is used for QuickSight(for visualization) as loading from S3 bucket to Quicksight requires manifest json file.

The visualizations helped to identify patterns and trends in water consumption and charges across different seasons. These also enabled to ensure that the data was categorized and distributed appropriately for better prediction.

Few graphs from the QuickSight about the featured attributes are shown below. The first pie chart displays the distribution of records across different seasons, revealing an approximately equal number of records for each season. The second pie chart illustrates the count of records by year, providing a year-by-year breakdown.

 ![image](https://github.com/user-attachments/assets/cc2a4227-a843-4f43-9c9a-a6d457b66701)


![image](https://github.com/user-attachments/assets/f5396659-a377-40ae-9b2d-1a6b3ecf253e)

The bar graph details the count of records based on the number of days, offering insights into the distribution of records across different durations.

![image](https://github.com/user-attachments/assets/244933ca-9097-468d-85c4-12174bd01c45)


**Decision Making**

To decide whether the seasons are affecting the water consumption, the data is analyzed and predictions are made. To implement this, various machine learning algorithms are applied using Cloud9 for Python coding. Python SDK is used to implement and evaluate the performance of different models, including Gradient Boosting, Decision Tree, and KNN.

Three features - 'season', 'tds #', '# days' are used to predict the target - 'charge range'. Data from specified years are selected for training and testing, such that the testing and training years have less time difference. The train data is taken from years -2013, 2014, 2016, 2017,2018, 2019, 2020, 2022 and the test data is taken from 2015, 2018, 2021, 2023. The data is divided such that 75% of the data is allocated for training and 25% of the allocated to testing, to predict the ‘Charge Range’.

Commands to install modules in Cloud9 
```
pip install boto3
pip install pandas
pip install sklearn
```
Python code to load data from SDK to Cloud9
```
import boto3
import os

# Specify the AWS region and S3 bucket name
region_name = 'us-east-1'
bucket_name = 'waterdataproject'
file_key = 'finaltable.csv000'  # Specify the key (path) of the file you want to download

# Create an S3 client
s3_client = boto3.client('s3', region_name=region_name)

# List objects in the specified S3 bucket
response = s3_client.list_objects_v2(Bucket=bucket_name)

if 'Contents' in response:
    print("Objects in the S3 bucket:")
    for obj in response['Contents']:
        print(f" - {obj['Key']}")

# Download a specific file from S3 to the Cloud9 environment
download_path = '/home/ec2-user/environment/'  # Specify the local download path
os.makedirs(download_path, exist_ok=True)  # Create the download directory if it doesn't exist

local_file_path = os.path.join(download_path, os.path.basename(file_key))
print(f"Downloading file: {file_key} to {local_file_path}")

s3_client.download_file(bucket_name, file_key, local_file_path)

print(f"File downloaded successfully!")
```
Python Code to apply ML Algorithms
```
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
```


**Results & Discussion**

 
The accuracy results for each Machine Learning model used for the prediction of Water & Sewer Charges using seasonal timestamps are given below:

* Gradient Boosting: 72.75%
* Decision Tree: 71.12%
* KNN: 69.90%
  
The Gradient Boosting model achieved the highest accuracy at approximately 72.75%, indicating its effectiveness in predicting water charges based on the selected features. Decision Tree also showcased a similar accuracy in predicting water charges based on season, days count and unique TDS identifier.
