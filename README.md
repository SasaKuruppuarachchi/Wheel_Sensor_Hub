# Wheel_Sensor_Hub
Suspension and tyre data acquisition sub station of a Formula student class 1 car 

One sensor board will be mounted into each upright and will be connected into the CAN 2 network. This board has following capabilities,
- Wheel speed – To detect slippage
- Suspension position – to detect roll and dive and to set suspension settings
-	Tire temperature – For tuning suspension for better lap times
-	Break disk temperature – To detect break fade and adjust break bias<br>

Components are selected. Then the schematic was designed and PCB was then designed with packaging in mind.

<img alt="Schematic" width=950 src="https://github.com/SasaKuruppuarachchi/Wheel_Sensor_Hub/blob/main/Misc/Schematic.jpg" /></a>

<img alt="PCB" width=400 src="https://github.com/SasaKuruppuarachchi/Wheel_Sensor_Hub/blob/main/Misc/PCB.jpg" /><a>
<img alt="PCB" width=350 src="https://github.com/SasaKuruppuarachchi/Wheel_Sensor_Hub/blob/main/Misc/1.jpg" /></br>

Then a waterproof enclosure designed to securely mount the wheel board onto the upright. This will be 3d printed.

<img alt="CAD" width=550 src="https://github.com/SasaKuruppuarachchi/Wheel_Sensor_Hub/blob/main/Misc/CAD.png" /></br>

Understating how the tires are behaving on the vehicle is critical to understanding how the vehicle is behaving, which can be used to improve lap times. This is because the tire is the only interface to the road and it is the main limiting factor on lap times. To measure the temperature across the tire, an infrared camera is used. The sensor is an AMG88 Grid-EYE 8X8 infrared sensor array seen in Figure 2.21 that samples at a rate of 10Hz. The output of the sensor can be seen in Figure 2.21, which is showing the temperature variation on my hand. This temperature data is used to show the hot spots on the tires, which corresponds to the wear on the tire allowing for accurate tuning of the suspension.

<img alt="AMG" width=950 src="https://github.com/SasaKuruppuarachchi/Wheel_Sensor_Hub/blob/main/Misc/AMG88.png" /></br>

But the output of 64 pixel data is not enough to visualize a tire temperature profile. So I implemented Bi-cubic Interpolation to increase detailing in the output in processing ENV.

<img alt="AMG" width=950 src="https://github.com/SasaKuruppuarachchi/Wheel_Sensor_Hub/blob/main/Misc/bcci.png" /></br>
<img alt="AMG" width=950 src="https://github.com/SasaKuruppuarachchi/Wheel_Sensor_Hub/blob/main/Misc/MS.png" /></br>
