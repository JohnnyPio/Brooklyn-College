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
top_level_dir = "/mnt/c/Users/JohnS/Downloads/CS/7412/pgdvd042010_extracted2/1/0/0"

# Read all .txt files from the top-level directory line-by-line
df_lines = (spark.read
    .option("recursiveFileLookup", "true")
    .text(top_level_dir)
    .withColumn("filename", F.input_file_name())
    .filter(F.col("filename").endswith(".txt")))

# Group all lines from the same file and glue them together
df_grouped = (df_lines
              .groupBy("filename")
              .agg(F.concat_ws(" ", F.collect_list("value")).alias("text_raw")))

# Make lowercase and remove whitespace
df_lowered = (df_grouped
              .withColumn("text",
        F.trim(F.regexp_replace(F.lower(F.col("text_raw")), r"\s+", " "))
    )
              .drop("text_raw")
              )

# Apparently there's two possible headers for the files -_-
pattern = r"(?i)^.*?\*\*\*\s*start of (?:this|the) project gutenberg ebook .*?\s*\*\*\*\s*"

# Strip out everything before the header
df_stripped = df_lowered.withColumn(
    "text",
    F.regexp_replace("text", pattern, "")
)

# Normalize punctuation to be periods and strip everything else to be a space
df_punctuation = (df_stripped
                  .withColumn("text", F.regexp_replace("text", r"[.!?]+", "."))
                  .withColumn("text", F.regexp_replace("text", r"[^\w.\s]+", " "))
                  .withColumn("text", F.regexp_replace("text", r"\s+", " "))
                  .withColumn("text", F.trim("text"))
                  )

# Create a new row for every new sentence
df_sentences = (df_punctuation
                .withColumn("sentence", F.explode(F.split(F.col("text"), r"\.")))
                .where(F.length("sentence") > 0)
                )

# Create a token from every word
df_tokens = (df_sentences
             .withColumn("tokens", F.split(F.col("sentence"), r"\s+"))
             .select("filename", F.explode("tokens").alias("word"))
             .where(F.length("word") > 0)
             .withColumn("word", F.lower("word"))
             )

# Add a sentence id to avoid crossing sentence boundaries
df_sentence_ids = (df_punctuation
                   .select("filename",F.posexplode(F.split("text", r"\.")).alias("sent_id", "sentence"))
                   .filter(F.length("sentence") > 0)
                   .select("filename", "sent_id",F.posexplode(F.split("sentence", r"\s+")).alias("pos", "word"))
                   .filter(F.length("word") > 0)
                   .withColumn("word", F.lower("word"))
)

# Create two new tables, a and b. Shift b pos by -1 to pair with the previous word (AKA a's word)
w1 = df_sentence_ids.alias("a")
w2 = df_sentence_ids.withColumn("pos", F.col("pos") - 1).alias("b")

# Create bigrams via an inner join of a and b
bigrams = (w1.join(w2,
                   on=[F.col("a.filename")==F.col("b.filename"),
                       F.col("a.sent_id")==F.col("b.sent_id"),
                       F.col("a.pos")==F.col("b.pos")],
                   how="inner")
                        .select(F.col("a.word").alias("word1"),
                                F.col("b.word").alias("word2"))
          )

# Count bigrams and words
bigram_counts = bigrams.groupBy("word1", "word2").count()
word_counts = bigram_counts.groupBy("word1").agg(F.sum("count").alias("w1_count"))

# Calculate the probability of each bigram
word_prob = (bigram_counts
             .join(word_counts, "word1")
             .select("word1", "word2", (F.col("count")/F.col("w1_count")).alias("probability"), "count", "w1_count")
             .orderBy(F.desc("count")))

# Choose a random word in word_counts
random_word = (
    word_counts
    .orderBy(F.rand())     # shuffle the rows randomly
    .limit(1)              # pick one
    .collect()[0]["word1"]
)

def next_word_greedy(curr):
    row = (word_prob
           .where(F.col("word1") == curr)
           .orderBy(F.desc("probability"))
           .select("word2")
           .first())
    return row["word2"] if row else None

def generate_text_greedy(start, max_len=40):
    curr = start
    words = [curr]
    for _ in range(max_len - 1):
        nxt = next_word_greedy(curr)
        if not nxt: break
        words.append(nxt)
        curr = nxt
    return " ".join(words)

print(generate_text_greedy(random_word))

spark.stop()