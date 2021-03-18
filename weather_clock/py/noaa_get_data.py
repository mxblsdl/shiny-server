# retrieve weather data from noaa api

from noaa_sdk import NOAA

n = NOAA()
observations = n.get_forecasts('97218', "US")

print(observations[1])
# for observation in observations:
#     print(observation)


