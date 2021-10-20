I built the temp sensor using a Raspberry Pi 3 and [Adafruit DHT-22](https://www.adafruit.com/product/385) which records temperature and humidity to the Pi with a simple python script.

The data is pushed to an InfluxDB on a remote server from the Pi using [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/). This page pulls the data from the database with python and then visualizes through flexdashboard.

There is a separate repo which details the [setup of the pi temp sensor](https://github.com/mxblsdl/dht)