from pyspark.sql import SparkSession
from pyspark.sql import functions as F

spark = (SparkSession.builder
    .appName("hw1")
    .master("local[*]")
    .config("spark.driver.memory", "4g")
    .config("spark.sql.shuffle.partitions", "4")
    .config("spark.sql.files.maxPartitionBytes", 256 * 1024 * 1024)
    .config("spark.sql.files.openCostInBytes", 8 * 1024 * 1024)
    .getOrCreate())

spark.sparkContext.setLogLevel("WARN")
top_level_dir = "/mnt/c/Users/JohnS/Downloads/CS/7412/pgdvd042010_extracted2/1/0/0/0"

# Read all .txt files from the top-level directory line-by-line
df_lines = (spark.read
    .option("recursiveFileLookup", "true")
    .text(top_level_dir)
    .withColumn("filename", F.input_file_name())
    .filter(F.col("filename").endswith(".txt")))

# Group all lines from the same file and glue them together
df_whole = (df_lines
    .groupBy("filename")
    .agg(F.concat_ws(" ", F.collect_list("value")).alias("text"))
    .withColumn("text", F.trim(F.regexp_replace(F.lower(F.col("text")), r"\s+", " "))))

# Remove header text
header_pattern = r"\*\*\*\s+start of this project gutenberg.*?\*\*\*"
df_clean = df_whole.withColumn(
    "text",
    F.split(F.col("text"), header_pattern).getItem(-1)
)

print("Rows after grouping (should ≈ number of .txt files):", df_clean.count())
df_clean.limit(5).show(truncate=120)

spark.stop()