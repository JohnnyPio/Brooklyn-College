from pyspark.sql import SparkSession
from pyspark.sql.functions import udf, split, col, lit, concat
from pyspark.sql.types import StringType, DoubleType, IntegerType, DateType, TimestampType




spark = SparkSession.builder \
    .appName("Quotes ETL") \
    .getOrCreate()

quotes = spark.read.text("C:\\Users\\JohnS\\OneDrive\\Documents\\Local-Repos\\Brooklyn-College\\CISC_7510X\\HW9\\quotes_UsConsolidated_UsListing_AU-Bz_2017-12-11_181000-182000.txt.gz")
quotes = quotes.toDF("value")

# Define the UDF to extract key=value from array
def findval(x, arr):
    kv_pairs = [s.split("=") for s in arr if "=" in s]
    matches = [v for k, v in kv_pairs if k == x]
    return matches[0] if matches else None

findval_udf = udf(findval, StringType())

# Step q1: split the line and extract fields
q1 = quotes.select(split(col("value"), "\\|").alias("arr")) \
    .withColumn("symbol", col("arr")[8]) \
    .withColumn("tdate", findval_udf(lit("11"), col("arr")).cast(DateType())) \
    .withColumn("bid", findval_udf(lit("0"), col("arr"))) \
    .withColumn("bidsiz", findval_udf(lit("1"), col("arr"))) \
    .withColumn("bidtim", findval_udf(lit("3"), col("arr"))) \
    .withColumn("ask", findval_udf(lit("5"), col("arr"))) \
    .withColumn("asksiz", findval_udf(lit("6"), col("arr"))) \
    .withColumn("asktim", findval_udf(lit("8"), col("arr"))) \
    .drop("arr")

q1.show(10)