This study analyzes a comprehensive NYCHA dataset from 2013 to February 2023, comprising 50,316 records with 25 attributes and 111 unique development identifiers (TDS#), to identify seasonal trends in water consumption and costs, aiming to improve water resource management and cost optimization by predicting water charges based on seasonal timestamps and unique TDS numbers.

**Ingestion:**

The data is ingested into the Amazon S3 bucket using the ELT (Extract, Load, and Transform) method as we need to do transformations on the data to prepare it for further steps in the pipeline.

**Storage:**

For storage and querying, we used Amazon Redshift. We chose Redshift over AWS Glue because of its high performance on complex queries, which was crucial for our analysis. However, we encountered issues during the data loading process. The primary issues were with the date format and the presence of '#' in column values. To resolve these, we configured the data loading process to accept any date format and specified string(‘#N/A’), present in the column values as null.

**Processing:**

In the data wrangling steps, we focused first on _feature selection_. The relevant features for our prediction included:

    •	“TDS #” – Unique development identifier.
  
    •	“Revenue Month” – Month and year of water consumption bill.
  
    •	“days #” – Number of Days on bill.
  
    •	“Water& Sewer Charges” – Total Water & Sewer Charges
  
We chose charges attribute upon consumption attribute because of multiple lines of inaccurate consumption data values.

_Cleaning:_

We cleaned the data by removing records with null or improper values. For example, the dataset included 60 records with null values in 'TDS #' and 21 records where the '#days' attribute was either null or less than or equal to zero. We also corrected 'Water & Sewer Charges' attribute values to make it suitable for analysis. 
We further cleaned the data by removing unnecessary data that might affect our machine learning algorithms. This involved:

    •	Removing rows where '#days' were less than 25 or greater than 35, as the number of days might affect the season determination.
  
    •	Removing records of particular 'TDS #' that had fewer records than the median, as fewer records wouldn’t provide accurate results during prediction.
  
    •	Removing records with 'Water & Sewer charges' equal to zero.


_Normalization:_
The data is normalized by converting the month values into corresponding seasons. For example, months 3, 4, and 5 are classified as Spring, while months 12, 1, and 2 are classified as Winter."
 We also converting the continuous target 'Water & Sewer Charges' into categorical targets, such as '0-1000', '1001-2000', etc. This step was crucial to ensure that the data was ready for analysis and machine learning.
At the end of processing, our dataset contains 45805 records and five columns naming, “TDS #”, “Season”, “days#”, “Year” and “Charge Range”.

**Analysis and Visualization:**

Once the data was cleaned and normalized, we proceeded with the analysis and visualization. The final data was stored in Amazon Athena using AWS Glue Crawler. However, we faced an issue where no records were found in Athena. We resolved this by unloading the processed data into a new S3 bucket and re-running the Glue Crawler. We chose creating tables in Glue and using Athena data for QuickSight as the loading from S3 bucket needed manifest json file.

We visualized the data using Amazon QuickSight, which allowed us to create insightful visualizations to understand the data better. These visualizations helped us to identify patterns and trends in water consumption and charges across different seasons. These also enabled to ensure that the data was categorized and distributed appropriately for better prediction.

**Decision Making**
To decide whether the seasons are affecting the water consumption, we analyzed the data and made predictions. To implement this, we applied various machine learning algorithms using Cloud9 for Python coding. We used the Python SDK to implement and evaluate the performance of different models, including Gradient Boosting, Decision Tree, and KNN.
We used 3 features - 'season', 'tds #', '# days' to predict the target - 'charge range'. We chose data from specified years for training and testing, such that the testing and training years have less time difference. The train data is taken from years -2013, 2014, 2016, 2017,2018, 2019, 2020, 2022 and the test data is taken from 2015, 2018, 2021, 2023. We divided the data such that 75% of the data is allocated for training and 25% of the allocated to testing, to predict the ‘Charge Range’.

**Results & Discussion**
Few graphs from the QuickSight about the featured attributes are shown below. The first pie chart displays the distribution of records across different seasons, revealing an approximately equal number of records for each season. The second pie chart illustrates the count of records by year, providing a year-by-year breakdown.
 

 
The bar graph details the count of records based on the number of days, offering insights into the distribution of records across different durations.
 
The accuracy results for each Machine Learning model used for the prediction of Water & Sewer Charges using seasonal timestamps are given below:
	•	Gradient Boosting: 72.75%
	•	Decision Tree: 71.12%
	•	KNN: 69.90%
The Gradient Boosting model achieved the highest accuracy at approximately 72.75%, indicating its effectiveness in predicting water charges based on the selected features. Decision Tree also showcased a similar accuracy in predicting water charges based on season, days count and unique TDS identifier.
