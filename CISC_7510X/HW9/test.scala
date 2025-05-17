import org.apache.spark.sql.SparkSession

object Test {
    def main(args: Array[String]) {
    val logFile = "/home/alex/spark/README.md"
    2
    val spark = SparkSession.builder.appName("TestApp").getOrCreate()
    val logData = spark.read.textFile(logFile).cache()
    val numAs = logData.filter(line => line.contains("a")).count()
    val numBs = logData.filter(line => line.contains("b")).count()
    println(s"Lines with a: $numAs, Lines with b: $numBs")
    spark.stop()
    }
}