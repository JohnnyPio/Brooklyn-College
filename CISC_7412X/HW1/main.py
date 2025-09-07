from pyspark.sql import SparkSession
from pyspark.sql.functions import input_file_name

spark = (SparkSession.builder
    .appName("hw1")
    .master("local[*]")
    .config("spark.driver.memory", "4g")
    .config("spark.sql.shuffle.partitions", "4")
    .getOrCreate())

spark.sparkContext.setLogLevel("WARN")

df = (spark.read
      .option("recursiveFileLookup", "true")   # read subfolders too
      .option("wholetext", "true")             # one row per file
      .text("/mnt/c/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7412X/HW1/pgdvd042010_extracted2/1/0/0/0"))

df = df.withColumn("filename", input_file_name())
df = df.filter(df.filename.endswith(".txt"))

print("Showing 5 sample files:")
df.limit(5).show(truncate=120)

spark.stop()