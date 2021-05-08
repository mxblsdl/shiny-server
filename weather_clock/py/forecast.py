
from noaa_sdk import NOAA

def get_observations(zip):
    n = NOAA()
    d = n.get_forecasts(zip, "US")
    #d = {k:o[hour][k] for k in ["isDaytime", "startTime", "temperature", "temperatureTrend", "windSpeed", "windDirection", "shortForecast"]}
    return(d)


