
/*
CODE REVIEW
- Sasanka Kuruppuarachchi

Project - "https://github.com/SasaKuruppuarachchi/Wheel_Sensor_Hub"

TSR_2018_WHEELBOARD
Designed for Teensy 3.5
By Sasanka Kuruppuarachchi
Cheif electrical Engineer
Team SHARK racing
UOM
*/

/*
Lets devide the code into 5 parts
1. Initialize
2. AMG88
3. TMP 006
4. CAM
5. Setup and Loop
*/


//************************************************CAN*******************************************************************

#include <FlexCAN.h>
CAN_filter_t defaultMask;

static CAN_message_t msg;
static uint8_t hex[17] = "0123456789abcdef";


//*********************************************** AMG8833 ****************************************************************

#include "AMG8833.h"
AMG8833 amg;
void ReadAMG(float* data, float threshold);

volatile float tyreTemp[8][8];

//************************************************ TMP007 *************************************************************

#include <Wire.h>
#include "Adafruit_TMP007.h"


Adafruit_TMP007 tmp007;
double breakTemp;
//Adafruit_TMP007 tmp007(0x41);
//tmp007.begin(TMP007_CFG_1SAMPLE);

void initTMP();
void readTMP();

//********************************************** SuspensionPOT **********************************************************

float susDisp[] = {{0,0},{0,0}}; //Suspension displacement in mm 
/*                                    
                                 [0,0]-/\-[0,1]  
                                      |  |
                                      |  |
                                 [1,0]----[1,1]
 */

 //*********************************************** WheelSpeed ***********************************************************

#include <FreqMeasure.h>

void setup_WheelSpeed();
double ws_sum;
int ws_count;

void setup_WheelSpeed() {
  Serial.begin(57600);
  FreqMeasure.begin();
  ws_sum = 0.0;
  ws_count = 0;
}



bool read_WheelSpeed() {
  if (FreqMeasure.available()) {
    // average several reading together
    ws_sum = ws_sum + FreqMeasure.read();
    ws_count = ws_count + 1;
    if (count > 30) {
      float frequency = FreqMeasure.countToFrequency(sum / count);
      Serial.println(frequency);
      sum = 0;
      count = 0;
    }
    return true;
  }
  else 
    return false;
}
