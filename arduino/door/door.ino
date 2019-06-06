#include <EEPROM.h> // to save state even powered off arduino

char state = EEPROM.read(0); // 0 is address of state (static)
String door(int s);

void setup() {
  Serial.begin(9600); //  same as matlab function (arduinoFunc)
  //becareful about Clockwise and counter clockwise 
  pinMode(8, OUTPUT); //  to L293
  pinMode(9, OUTPUT); //  to L293
}

void loop() {
  if (Serial.available()) {
    String data = Serial.readString();
    data.trim(); // important :|
    if (data == "start") { // to check establish connection
      Serial.println("ok");
    }

    if (data == "open") {
      Serial.println(door(1));
      EEPROM.write(0,state); // save state
    }

    if (data == "close") {
      Serial.println(door(2));
      EEPROM.write(0,state); // save state
    }

  }
}

/*
 * order to the L293 and as a result open/close the lock
 */
String door(int s) {
  if (state == 0) { // This is for prevent from conflict two command at same time
    return "fail!";
  }

  if (s == 1) {
    if (state == 1) { // door is open and open command received!
      return "is open";
    }
    state = 0;
    digitalWrite(8, 1);
    delay(300);
    digitalWrite(8, 0);
    state = 1;
    return "opened";
  } else if (s == 2) {
    if (state == 2) { // door is close and close command received!
      return "is close";
    }
    state = 0;
    digitalWrite(9, 1);
    delay(300);
    digitalWrite(9, 0);
    state = 2;
    return "closed";
  }
}
