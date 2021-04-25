//0.25 Hz is default at high precission

void initTMP(){
  if (! tmp007.begin()) {
    Serial.println("No sensor found");
    while (1);
  }
}

void readTMP(){
   float objt = tmp007.readObjTempC();
   Serial.print("Object Temperature: "); Serial.print(objt); Serial.println("*C");
   float diet = tmp007.readDieTempC();
   Serial.print("Die Temperature: "); Serial.print(diet); Serial.println("*C");
}

