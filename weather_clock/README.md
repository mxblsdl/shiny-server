# Weather API

## Where this project ended

This is a web app that shows the weather and a small forecast
It was made with R Shiny and is displayed in a browser.  

I ended up accessing it through a raspberry pi connected to a 7" monitor. The pi displays the app automatically with chromium browser set to full screen through a bash script.
> Still need to get the .sh script working correctly
> It would also be nice to explain the service set up

The app performs an api call to NOAA and retrieves weather information. The cool thing about this app is the API call is written in Python, while the rest of the code is written in R. This is achieved through the `reticulate` package which combines R and Python into the same working environment.

## Where this project started

Its worth going back to how this project started to get a sense of the use case for `reticulate` and how Python and R can most effectively be used together.

I originally wanted to code this dashboard entirely in Python. As a way to become more competent in Python. I started with the API call to get the actual data that I would need to display. This led me to the very intuitive [`noaa-sdk`](https://pypi.org/project/noaa-sdk/) package.

Next I needed an interface to the data. I looked into [`tkinter`](https://docs.python.org/3/library/tkinter.html) and [`PyQt 5`](https://pypi.org/project/PyQt5/), but mostly became overwhelmed at their structure. `PyQt 5` has its own GUI to make GUI's and I just wasn't interested in a no-code solution. The value in learning one of these frameworks didn't seem like it was worth the time needed to invest.

I decided to pivot to Shiny because I know it fairly well and genuinely enjoy making things with it. Switching to Shiny made the project fun for me rather than tedious and tedious projects rarely get finished. With this change I could move all of the development off the pi since the app now only needs to display a webpage.
> *I did think about running R Shiny on the pi and just having the app run locally, but I have access to Shiny Server which made this step a little unnecessary*

Once I switched to Shiny I thought I would do everything in R so I tried to recreate the API call. This proved harder than I thought as the R packages were not as intuitive as Python. I then tried to make my own API call outside of a package and read through tons of NOAA documentation. It was either confusing or I had a short attention span because I had already accomplished in Python what I was trying to recreate. 

I then decided to look into reticulate
## looked into reticulate and was suprised with how easy it was to use

## this solidified my approach to this project

## took the best elements of my skillset while still learning something new
## created essentially what I set out to originally create

Code in support of creating a weather clock for the raspberry pi

## Steps
1) Establish API with NOAA (or other weather service)
2) Pull data into a usable format
3) Create GUI display of weather results
   1) Probably with ktinker