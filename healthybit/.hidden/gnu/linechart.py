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
plt.plot(xdata, ydata, color='green', marker='o', linestyle='solid')

# write x values in angle
plt.xticks(xdata, xdata, rotation=45)

# add a title
plt.title({TITLE})
# add a label to the x and y-axis
#plt.xlabel({xLabel})
#plt.ylabel({yLabel})

# save image
plt.savefig({TargetImage})

