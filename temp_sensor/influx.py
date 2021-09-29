from influxdb import InfluxDBClient
from dotenv import load_dotenv
from os import getenv
from datetime import datetime, timedelta


'''
Connect to influxDB and return temperature readings from input time ranges

TODOs - figure out how length will get used and calculate a where clause
TODOs - possible use pandas for the DB query, return format might be better
''' 

def get_temperature_data(length):

    # Load environment variables for DB auth
    load_dotenv()

    # # establish connection
    client = InfluxDBClient(
        host = '167.71.158.245', 
        port = 8086, 
        username = getenv('INFLUX_NAME'),
        password = getenv('PASSWD'),
        database = getenv('DB'))

    
    # This will be how to determine the starting time value to pull from
    # Need to figure out how to interchange hours and days
    # Length will be hours and days will just be represented by many hours

    time = datetime.now() - timedelta(hours = 7)
    
    # Still need to determine how the length param will work in this
    # One idea is to return a pandas dataframe, but it might be easier to return an R dataframe
    # I have an issue with the time type being included in the where clause
    res = client.query( f"select temperature, humidity from room_temperature_humidity limit 5;")
    
    return list(res)

    # return client.query( f"select * from room_temperature_humidity where time >= {time};")

ret = get_temperature_data(7)
print(ret)

