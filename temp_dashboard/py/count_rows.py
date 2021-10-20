from influxdb import InfluxDBClient
from dotenv import load_dotenv
from os import getenv

'''
Check the size of the database. Used to determine how fast data was being added to the DB
'''

def main():
    load_dotenv()

    # # establish connection
    client = InfluxDBClient(
        host = '167.71.158.245', 
        port = 8086, 
        username = getenv('INFLUX_NAME'),
        password = getenv('PASSWD'),
        database = getenv('DB'))

    res = client.query("select count(*) from room_temperature_humidity")
    return res

print(main())