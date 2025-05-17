file:///C:/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/main.scala
### java.lang.IndexOutOfBoundsException: 1

occurred in the presentation compiler.

presentation compiler configuration:


action parameters:
offset: 1696
uri: file:///C:/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/main.scala
text:
```scala
import org.apache.spark.sql.types._

val quotes = spark.read.textFile(
  "/mnt/c/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/quotes_UsConsolidated_UsListing_AU-Bz_2017-12-11_181000-182000.txt.gz"
)
val quotesDF = quotes.toDF("value")

val findvaludf = udf((x: String, arr: Array[String]) => {
  val o = arr.map(_.split("=")).filter(_.length == 2).filter(_(0) == x);
  if (o.length > 0) o(0)(1) else null
})

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

val q2 = Seq("bid", "ask").foldLeft(q1)((a, b) =>
  a.withColumn(b, col(b).cast(DoubleType))
)
val q3 = Seq("bidsiz", "asksiz").foldLeft(q2)((a, b) =>
  a.withColumn(b, col(b).cast(IntegerType))
)
val q4 = Seq("bidtim", "asktim").foldLeft(q3)((a, b) =>
  a.withColumn(b, concat($"tdate", lit(" "), col(b)).cast(TimestampType))
)

q4.show(10)

q4.write
  .format("parquet")
  .mode("overwrite")
  .save(
    "/mnt/c/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/output_parquet"
  )

// q4.write
//   .option("header", "true")
//   .mode("overwrite")
//   .csv("/mnt/c/Users/JohnS/OneDrive/Documents/Local-Repos/Brooklyn-College/CISC_7510X/HW9/output_csv")
// visualv

val parquet+_@@

q4.show()

System.exit(0)

```



#### Error stacktrace:

```
scala.collection.LinearSeqOps.apply(LinearSeq.scala:131)
	scala.collection.LinearSeqOps.apply$(LinearSeq.scala:128)
	scala.collection.immutable.List.apply(List.scala:79)
	dotty.tools.pc.InterCompletionType$.inferType(InferExpectedType.scala:98)
	dotty.tools.pc.InterCompletionType$.inferType(InferExpectedType.scala:66)
	dotty.tools.pc.completions.Completions.advancedCompletions(Completions.scala:523)
	dotty.tools.pc.completions.Completions.completions(Completions.scala:122)
	dotty.tools.pc.completions.CompletionProvider.completions(CompletionProvider.scala:139)
	dotty.tools.pc.ScalaPresentationCompiler.complete$$anonfun$1(ScalaPresentationCompiler.scala:150)
```
#### Short summary: 

java.lang.IndexOutOfBoundsException: 1