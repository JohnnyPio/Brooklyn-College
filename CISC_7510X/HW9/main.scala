import org.apache.spark.sql.functions._
import org.apache.spark.sql.types._

System.setProperty("hadoop.native.lib", "false")
spark.conf.set("mapreduce.fileoutputcommitter.algorithm.version", "1")

val quotes = spark.read.textFile("C:\\Users\\JohnS\\OneDrive\\Documents\\Local-Repos\\Brooklyn-College\\CISC_7510X\\HW9\\quotes_UsConsolidated_UsListing_AU-Bz_2017-12-11_181000-182000.txt.gz")
val quotesDF = quotes.toDF("value")

val findvaludf = udf( (x:String,arr:Array[String]) => { val o = arr.map(_.split("=")).
   filter(_.length==2).filter(_(0)==x); if(o.length>0) o(0)(1) else null } )

val q1 = quotes.select( split($"value","\\|").as("arr") ).
  withColumn("symbol", $"arr"(8)).
  withColumn("tdate", findvaludf(lit("11"), $"arr").cast(DateType) ).
  withColumn("bid", findvaludf(lit("0"), $"arr") ).
  withColumn("bidsiz", findvaludf(lit("1"), $"arr") ).
  withColumn("bidtim", findvaludf(lit("3"), $"arr") ).
  withColumn("ask", findvaludf(lit("5"), $"arr") ).
  withColumn("asksiz", findvaludf(lit("6"), $"arr") ).
  withColumn("asktim", findvaludf(lit("8"), $"arr") ).
  drop("arr")

val q2 = Seq("bid","ask").foldLeft( q1 ) ( (a,b) => a.withColumn(b,col(b).cast(DoubleType) ) )
val q3 = Seq("bidsiz","asksiz").foldLeft( q2 ) ( (a,b) => a.withColumn(b,col(b).cast(IntegerType) ) )
val q4 = Seq("bidtim","asktim").foldLeft( q3 ) ( (a,b) => a.withColumn(b,concat($"tdate",lit(" "), col(b)).cast(TimestampType ) ) )

q4.show(10)

//q4.write.format("parquet").mode("overwrite").save("C:\\Users\\JohnS\\OneDrive\\Documents\\Local-Repos\\Brooklyn-College\\CISC_7510X\\HW9\\temp")

q4.write
  .option("header", "true")
  .mode("overwrite")
  .csv("C:/Users/JohnS/OneDrive/Documents/output_csv")

System.exit(0)