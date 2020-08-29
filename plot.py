import sys
from visit import *

if len(sys.argv) == 1:
	plotvar = 'RHO'
else:
	plotvar = sys.argv[1]

OpenDatabase("sol-*.plt database")
AddPlot("Pseudocolor", plotvar)

# Save a POSTSCRIPT file at 1200x1000 resolutions
s = SaveWindowAttributes()
s.format = s.POSTSCRIPT
s.fileName = "sol_"+plotvar+"_"
s.width, s.height = 1200,1000
s.screenCapture = 0
SetSaveWindowAttributes(s)

p = PseudocolorAttributes()
p.colorTableName = "hot"
#p.minFlag, p.maxFlag = 1, 1
#p.min, p.max = -1.0, 1.0
SetPlotOptions(p)

a = AnnotationAttributes()
a.axes2D.xAxis.title.title = "X"
a.axes2D.yAxis.title.title = "Y"
a.axes2D.visible = 1
a.axes2D.xAxis.title.visible = 1  
a.axes2D.yAxis.title.visible = 1
a.axes2D.xAxis.title.userTitle = 1
a.axes2D.yAxis.title.userTitle = 1
a.axes2D.xAxis.title.font.font = a.axes2D.xAxis.title.font.Times  # Arial, Courier, Times
a.axes2D.yAxis.title.font.font = a.axes2D.yAxis.title.font.Times  # Arial, Courier, Times
a.axes2D.xAxis.label.font.font = a.axes2D.xAxis.label.font.Times  # Arial, Courier, Times
a.axes2D.yAxis.label.font.font = a.axes2D.yAxis.label.font.Times  # Arial, Courier, Times
a.userInfoFlag = 0
a.databaseInfoFlag = 0
#a.timeInfoFlag = 0
SetAnnotationAttributes(a)

DrawPlots()

# Set legend
plotName = GetPlotList().GetPlots(0).plotName
legend = GetAnnotationObject(plotName)
legend.numberFormat = "%1.2f"
legend.managePosition = 0
legend.position = (0.01,0.85)
legend.orientation = 1
legend.drawMinMax = 0
legend.drawTitle = 0
legend.fontBold = 1
legend.fontItalic = 1
legend.xScale = 1.0
legend.yScale = 2.5
legend.fontFamily = legend.Times

for states in range(TimeSliderGetNStates()):
	SetTimeSliderState(states)
#	SaveWindow()
	
#quit()
