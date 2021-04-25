class CANclass : public CANListener 
{
private:
  volatile int rpm = 0;
  volatile int cTemp = 3625; // 362.5K
  volatile int oilPr = 3000; // 0.1 kpa
  volatile int wSpeed = 0; //0.1 kmph
  volatile int gear = 0;
  volatile int MAP = 95; //0.1 kpa
  volatile int lambda = 1000; //0.001
  volatile int tps = 0; // 0.0%
public:
   void printFrame(CAN_message_t &frame, int mailbox);
   bool frameHandler(CAN_message_t &frame, int mailbox, uint8_t controller); //overrides the parent version so we can actually do something
   int getRPM();
   int getcTemp();
   int getoilPr();
   int getwSpeed();
   int getgear();
   int getMAP();
   int getlambda();
   int gettps();
};

void CANclass::printFrame(CAN_message_t &frame, int mailbox)
{
   Serial.print("ID: ");
   Serial.print(frame.id, HEX);
   Serial.print(" Data: ");
   for (int c = 0; c < frame.len; c++) 
   {
      Serial.print(frame.buf[c], HEX);
      Serial.write(' ');
   }
   Serial.write('\r');
   Serial.write('\n');
}

bool CANclass::frameHandler(CAN_message_t &frame, int mailbox, uint8_t controller)
{
    printFrame(frame, mailbox);
    if (frame.id ==  864){ // 0x360
      rpm = frame.buf[1] + frame.buf[0]*256 ;
      MAP = frame.buf[3] + frame.buf[2]*256 ;
      tps = frame.buf[5] + frame.buf[4]*256 ;
      
    }else if (frame.id ==  992){ // 0x3E0
      cTemp = frame.buf[1] + frame.buf[0]*256 ;
      
    }else if (frame.id ==  865){ // 0x361
      oilPr = frame.buf[3] + frame.buf[2]*256 ;
      
    }else if (frame.id ==  877){ // 0x36D
      wSpeed = frame.buf[3] + frame.buf[2]*256 ;
      
    }
    

    return true;
}

int CANclass::getRPM()
{
  return rpm;
}

int CANclass::getgear()
{
  return gear;
}
int CANclass::getcTemp()
{
  return cTemp;
}
int CANclass::getoilPr()
{
  return oilPr;
}
int CANclass::getwSpeed()
{
  return wSpeed;
}
int CANclass::getMAP()
{
  return MAP;
}
int CANclass::getlambda()
{
  return lambda;
}
int CANclass::gettps()
{
  return tps;
}






CANclass CANobj;


void initializeCAN(void)
{

  pinMode(28, OUTPUT);

  digitalWrite(28,LOW);
  Can0.begin(1000000,defaultMask,1,1);  

  Can0.attachObj(&CANobj);
  CANobj.attachGeneralHandler();


  msg.ext = 0;
  msg.id = 0x360;
  msg.len = 8;
  msg.buf[0] = 0;
  msg.buf[1] = 255;
  msg.buf[2] = 0;
  msg.buf[3] = 100;
  msg.buf[4] = 128;
  msg.buf[5] = 64;
  msg.buf[6] = 32;
  msg.buf[7] = 16;
  
  delay(2000);
}
