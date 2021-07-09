from glob import glob
from PIL import Image
import re

# pull first file that will act as template
img = Image.open("line_map_prev.png")

# pull metrics
maxWidth = img.width
maxHeight = img.height

files = (glob("*.png"))
for file in files:
    # Get file name 
    fileName = re.sub(".png", "", file)

    # open and resize each file
    img = Image.open(file)
    newHeight = (maxHeight/ img.height) * img.height
    img = img.resize(size=[int(maxWidth), int(newHeight)])
    img.save(f"{fileName}_resize.png")

