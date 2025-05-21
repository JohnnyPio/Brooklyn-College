file:///C:/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/main.scala
empty definition using pc, found symbol in pc: 
semanticdb not found
empty definition using fallback
non-local guesses:

offset: 1359
uri: file:///C:/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/main.scala
text:
```scala
// John Piotrowski - 7510X - HW#10

import org.apache.spark.sql.types._

val quotes = spark.read.textFile(
  "/mnt/c/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/quotes_UsConsolidated_UsListing_AU-Bz_2017-12-11_181000-182000.txt.gz"
)

val quotesDF = quotes.toDF("value")

val findvaludf = udf { (x: String, arr: Array[String]) =>
  val o = arr.map(_.split("=")).filter(_.length == 2).filter(_(0) == x);
  if (o.length > 0)
    o(0)(1)
  else
    null
}

val q1 = quotes
  .select(split($"value", "\\|").as("arr"))
  .withColumn("symbol", $"arr" (8))
  .withColumn("tdate", findvaludf(lit("11"), $"arr").cast(DateType))
  .withColumn("bid", findvaludf(lit("0"), $"arr"))
  .withColumn("bidsiz", findvaludf(lit("1"), $"arr"))
  .withColumn("bidtim", findvaludf(lit("3"), $"arr"))
  .withColumn("ask", findvaludf(lit("5"), $"arr"))
  .withColumn("asksiz", findvaludf(lit("6"), $"arr"))
  .withColumn("asktim", findvaludf(lit("8"), $"arr"))
  .drop("arr")

val q2 = Seq("bid", "ask").foldLeft(q1)((a, b) => a.withColumn(b, col(b).cast(DoubleType)))
val q3 = Seq("bidsiz", "asksiz").foldLeft(q2)((a, b) => a.withColumn(b, col(b).cast(IntegerType)))
val q4 =
  Seq("bidtim", "asktim").foldLeft(q3)((a, b) =>
    a.withColumn(b, concat($"tdate", lit(" "), col(b)).cast(TimestampType))
  )

q4.show(@@10)

q4.write
  .format("parquet")
  .mode("overwrite")
  .save(
    "/mnt/c/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/output_parquet"
  )

// Task2
// q4.write.format("parquet").mode("overwrite").saveAsTable("table")

// val task2_results = spark.sql("""
// with trading_hours_only as (
//   select
//     symbol as ticker,
//     bid,
//     bidtim,
//     tdate,
//     date_trunc('minute', bidtim) as minute,
//     split_part(symbol, '.', 1) as ticker_only,
//     nullif(split_part(symbol, '.', 2), '') as venue_only
//   from table
//   where to_char(bidtim, 'hh24:mi') between '09:31' and '16:00'
//   group by tdate, ticker_only, bid, bidtim, ticker
// ),
// quotes_by_minute as (
//   select *,
//          row_number() over (partition by ticker, minute order by bidtim desc) as rn
//   from trading_hours_only
// ),
// latest_quotes_per_ticker as (
//   select *
//   from quotes_by_minute
//   where rn = 1
// ),
// matched_venue_counts as (
//   select
//     a.tdate,
//     a.ticker_only,
//     a.minute,
//     count(*) as venue_match_count
//   from latest_quotes_per_ticker a
//   join latest_quotes_per_ticker b
//     on a.ticker_only = b.ticker_only
//     and a.minute = b.minute
//     and a.bid = b.bid
//     and b.venue_only is null
//     and a.venue_only is not null
//   group by a.ticker_only, a.minute, a.tdate
// )
// select *
// from matched_venue_counts
// order by ticker_only, minute
// """)

// task2_results.show(100)

// System.exit(0)

// Testing write/reads
// q4.write
//   .option("header", "true")
//   .mode("overwrite")
//   .csv("/mnt/c/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/output_csv")
// val parquet_df = spark.read.parquet(
//   "/mnt/c/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/output_parquet"
// )
// parquet_df.show(100)

```


#### Short summary: 

empty definition using pc, found symbol in pc: 