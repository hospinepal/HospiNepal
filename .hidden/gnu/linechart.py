#copy this file to .config/healthybit/gnu/
from matplotlib import pyplot as plt
import csv

xdata = []
ydata = []

# load data from csv
with open({DataList},'r') as csvfile: 
    plots = csv.reader(csvfile, delimiter = '\t') 
      
    for row in plots: 
        xdata.append(row[0]) 
        ydata.append(float(row[1])) 


# create a line chart, xdata on x-axis, ydata on y-axis
plt.plot(xdata, ydata, color='blue', marker='o', linestyle='solid')

#plt.figure(figsize=(12, 6))  # Adjust the size as needed

# write x values in angle
plt.xticks(xdata, xdata, rotation=75)

# add a title
plt.title({TITLE})
# add a label to the x and y-axis
plt.xlabel({xLabel})
plt.ylabel({yLabel})
plt.tight_layout()

# save image
plt.savefig({TargetImage})

