# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
from noaa_sdk import NOAA


# %%
# n = NOAA()
# observations = n.get_forecasts('97218', "US")


# %%
def get_observations(zip):
    n = NOAA()
    d = n.get_forecasts(zip, "US")
    #d = {k:o[hour][k] for k in ["isDaytime", "startTime", "temperature", "temperatureTrend", "windSpeed", "windDirection", "shortForecast"]}
    return(d)

# get_observations(n, '97218', 0)


