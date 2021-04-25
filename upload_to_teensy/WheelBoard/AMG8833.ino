float temp[64];

float avgTemp=0;

void ReadAMG(float* data, float threshold){
  avgTemp=0;
  uint8_t count = 0;
  uint8_t element_count = 0;
  for (uint8_t x=0; x<8; x++){
    for (uint8_t y=0; y<8; y++){
      Serial.print(data[x*8+y]);Serial.print(",");
      tyreTemp[x][y] = data[x*8+y];
      avgTemp=avgTemp+data[x*8+y];
      count++;
    }
    Serial.print('\n');
    count++; 
  }
  avgTemp= avgTemp/64;
  Serial.println("N");
}
