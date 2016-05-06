import processing.video.*;
import processing.serial.*;

int cr = 13;    // CR in ASCII
String Init1 = "$Q182";
String Init2 = "$q0000061";
String odpoved="$q1000300000000E5";

String ComPortString = null;
Serial myPort;  // The serial port
String cesta;
String soubor;
String datum;
Capture cam;

void setup() {
  
  size(1280, 960);
  Initserial();

//nastaveni ukladani
selectFolder("Zadej adresář pro ukládání:", "folderSelected");

//nastaveni kamery
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      print(i);
      print(": ");
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[83]);
    cam.start();     
  }      

}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  set(0, 0, cam);

while (myPort.available() > 0) {
    String inBuffer = myPort.readString();   
    if (inBuffer != null) {
      println(inBuffer);
      datum=ziskej_datum();
      soubor = cesta+"\\"+ datum+".jpg";
      println(soubor);
      delay(5000);
      saveFrame(soubor);
      }
    }
  }


void folderSelected(File selection) {
  if (selection == null) {
 
  } else {
    println("User selected " + selection.getAbsolutePath());
    cesta = selection.getAbsolutePath();
  }
}

String ziskej_datum(){
  String d = nf(day(),2);    // Values from 01 - 31
  String m = nf(month(),2);  // Values from 01 - 12
  String y = nf(year(),4);   // 2003, 2004, 2005, etc.
  String h = nf(hour(),2);
  String min = nf(minute(),2);
  String sec = nf(second(),2);
  String s = y+m+d+"_"+h+min+sec;
  //println(s);
  return s;
}


void mouseClicked() {
 saveFrame(cesta+"camera-####.jpg");

}

void Initserial(){
 // List all the available serial ports
  println(Serial.list());
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  ComPortString = myPort.readStringUntil(cr);
  ComPortString = null;
  String Odpoved = null;
  println("Navazuji spojení"); 
  myPort.write(Init1);
  myPort.write(cr);
  while(Odpoved == null){
  
    ComPortString = myPort.readStringUntil(cr);
    Odpoved=ComPortString;
      
    /*
      print("CPS=");
      print(ComPortString);
      println(".");
      
      print("ODP=");
      print(Odpoved);
      println(".");
    
    
      print("INT=");
      print(Init2);
      println(".");
    */
};

      
    if (Odpoved.substring(0,9).equals(Init2)){
      println("Spojení OK");
      }
    
    println("---------");
 };