from influxdb import InfluxDBClient
from dotenv import load_dotenv
from os import getenv
from datetime import datetime, timedelta
import pandas as pd

'''
Connect to influxDB and return temperature/humidity readings from set number of hours back in time.
Relies on a .env file which has database connection information
''' 

def get_temperature_data(hours_back):

    # Load environment variables for DB auth
    load_dotenv()

    # # establish connection
    client = InfluxDBClient(
        host = '167.71.158.245', 
        port = 8086, 
        username = getenv('INFLUX_NAME'),
        password = getenv('PASSWD'),
        database = getenv('DB'))

    # calculate how far back to pull data from
    time = datetime.utcnow().replace(microsecond = 0) - timedelta(hours = hours_back)

    res = client.query( f'''
    select temperature, humidity 
    from room_temperature_humidity 
    where time >= '{time}'
    order by time desc;
    ''').get_points() # get points makes the results more readable as a DF
    
    res = pd.DataFrame(res)

    # Adjust for timezone and round to nearest second
    res["time"] = pd.to_datetime(res["time"]).dt.tz_convert('America/Los_Angeles').dt.round('1s')

    # convert to fahrenheit
    res["temperature"] = (res["temperature"] * 9/5) + 32

    return res

# Test running the function
ret = get_temperature_data(1)
print(ret)

