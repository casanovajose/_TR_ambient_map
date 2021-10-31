int tam = 500;
float[][] hm = new float[tam][tam];

import controlP5.*;
ControlP5 cp5;
//cp5.setFont(ff);  
// change the original colors

// result
PImage img = createImage(500, 500, GRAY);
PImage imgMap = createImage(500, 500, RGB);
boolean invert = false; // 1 normal - -1 invert color 

// function selector
int CIRCLE = 0;
int LINEAL = 1;
int NOISE = 2;
int RANDOM = 3;

// center
Slider2D ctr;
RadioButton  fun;


float step = 0.8;
int offset = 50;
int x = 0;
int y = 0;
byte tone = 64;
float mem = 0;

// controls
int row = 40;
float rx = 0.1;
float ry = 0.1;
float m = 1;
float mft = 0;
float bright = 1;
String scene = "";
String name = "";

// bg
PImage bg;

void setup() {
  size(800, 600);
  //clear(); 
  try {
    imgMap = loadImage("map.png");
  } catch(Exception e) {
    println("no map image found");
  }
  // center slider
  cp5 = new ControlP5(this);
  cp5.setColorForeground(0x0050E320);
  cp5.setColorBackground(0xff224422);
  cp5.setColorCaptionLabel(0xff00e300);
  
  cp5.setColorActive(0xff00e300);
  ctr = cp5.addSlider2D("CENTER")
         .setPosition(480, row)
         .setSize(100,100)
         .setMinMax(0,0,tam, tam)
         .setValue(50,50)
         .setLabel("Center")
         //.setColorCaptionLabel(0)
         // .disableCrosshair()
         ;
  
  cp5.addSlider("rx")
    .setPosition(480, row*4)
    .setRange(-5, 5)
    .setLabel("wide")
    //.setColorCaptionLabel(0)
    .setSize(200, 20)
    ;
    
  cp5.addSlider("ry")
    .setPosition(480,row*5)
    .setRange(-5, 5)
    .setLabel("Height")
    //.setColorCaptionLabel(0)
    .setSize(200, 20)
    ; 
  
  cp5.addSlider("m")
    .setPosition(480,row*6)
    .setRange(0.001, 500)
    .setLabel("Mult")
    //.setColorCaptionLabel(0)
    .setSize(200, 20)
    ;  
    
  cp5.addSlider("mft")
  .setPosition(480,row*7)
  .setRange(-10, 10)
  .setLabel("Mult Fine Tune")
  //.setColorCaptionLabel(0)
  .setSize(200, 20)
  ;
  
  cp5.addSlider("bright")
  .setPosition(480,row*8)
  .setRange(0.01, 1)
  .setLabel("Brightness")
  //.setColorCaptionLabel(0)
  .setSize(200, 20)
  ; 
    
  cp5.addTextfield("scene").setPosition(480, row*9).setSize(200, 20).setAutoClear(false)
    .setLabel("AMBIENT/SPACE")
    //.setColorCaptionLabel(0);
    ;
  cp5.addTextfield("name").setPosition(480, row*10).setSize(200, 20).setAutoClear(false)
    .setLabel("SPEAKER/REVERB SPACE")
    //.setColorCaptionLabel(0)
    ;

  cp5.addButton("invertColor")
   .setCaptionLabel("INVERT COLOURS")
   .setPosition(480, row*11)
   .setSize(200,19)
   .setValue(0)
   ;

  cp5.addButton("saveMap",1)
   .setCaptionLabel("SAVE")
   .setPosition(480, row*12)
   .setSize(200, 20)
   ;
    

  fun = cp5.addRadioButton (name)
  .setPosition(480 ,row*13)
  .setSize(10,10)
  .setItemHeight(10)
  .setNoneSelectedAllowed(false)
  .toUpperCase(true)
  ;
  fun.addItem("elliptic", 0);
  fun.addItem("lineal", 1);
  fun.addItem("noise", 2);
  fun.addItem("random", 3);
  fun.activate("elliptic");

  colorMode(HSB, 100, 100, 100, 100);
  for (int i = 0; i < tam; i++) {
    for (int j = 0; j < tam; j++) {      
      //hm[j][i] = circle(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry);
      hm[j][i] = lineal(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry);
     // hm[i][j] = map(( i +sin(i)*PI/180), 0 , tam*tam, 0, 100);
    }
  }
   
  background(100, 0, 100);
  bg = loadImage("bg-tile.png");
}

void draw() {
  background(0, 0, 5);
  //tint(255, 30);
  //image(bg, 0, 0);
  noTint();
  noStroke();
  
  image(img, offset, offset, 400, 400);
  image(imgMap, offset, offset, 400, 400);
  
  noFill();
  stroke(0,100,0);
  strokeWeight(1);
  rect(offset, offset, tam*step, tam*step);
  
  //mem = (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / 1024.0 * 1024.0 * 1024.0;
  //text(nfs(mem, 0, 3), width - 90, 20);
}

void setMap() {
  for (int i = 0; i < tam; i++) {
    for (int j = 0; j < tam; j++) {
      hm[i][j] = 0;
    }
  }
}

void saveImg() {
  scene = cp5.get(Textfield.class,"scene").getText();
  name = cp5.get(Textfield.class,"name").getText();
  if (scene == "") {scene = "default";}
  if (name == "") {name = "sketch_amb";}
  img.save("data/"+scene+"/"+name+".png");
}

void saveMap() {
  println("SAVE");
  saveImg();
}

void invertColor() {
  invert = !invert;
  println("Invert color ", invert);
}

void controlEvent(ControlEvent e) {
  
  //if (e.isFrom(cp5.getController("save"))) {
  //  println("SAVE");
  //}
  //Controller c = cp5.getController("ctr");
  //Controller rx = cp5.getController("CENTER");
  //Controller ry = cp5.getController("CENTER");
  for (int i = 0; i < tam; i++) {
    for (int j = 0; j < tam; j++) {
      switch(int(fun.getValue())) {
        case 0:
         hm[i][j] = constrain(circle(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry), 0, 100);
         break;
        case 1:
          hm[i][j] = constrain(lineal(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry), 0, 100);
          break;
        case 2:
          hm[i][j] = constrain(noiseMap(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry), 0, 100);
          break;
        case 3:
          hm[i][j] = constrain(randomMap(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry), 0, 100);
          break;
      }
      //hm[i][j] = constrain(circle(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry), 0, 100);
      //hm[i][j] = constrain(lineal(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry), 0, 100);
      //hm[i][j] = randomMap(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry);
      if(invert) {
        img.set(j, i, color(100-hm[i][j]*bright));
      } else {
        img.set(j, i, color(hm[i][j]*bright));
      }
      
    
    }
  }

}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  tone += e;
}


void keyPressed() {
  if(key == '+') {
    tone++;
    println("tone"); 
  }
  
  if(key == '-') {
    tone--;
    println("tone"); 
  }
  
  if (key == 'q') {
    clear();
  }
  
  if (key == 's') {
    println("saving frame");
    saveFrame("cap##.png");
    //saveImg();
  }
}


/// TRANSFORMERS

float circle(int x, int y, float ox, float oy, float mx, float my) {
  // centering
  int cx = x - int(ox);
  int cy = y - int(oy);
  return 100 - ((cx*cx*mx + cy*cy*my)/ (m+mft));
}

float lineal(int x, int y, float ox, float oy, float mx, float my) {
  // centering
  int cx = x - int(ox);
  int cy = y - int(oy);
  return 100 - (cx*mx+cy*my )* (m+mft);
}

float noiseMap(int x, int y, float ox, float oy, float mx, float my) {
  // centering
  int cx = x - int(ox);
  int cy = y - int(oy);
  float r = noise(cx*mx, cy*my, m) * 100 * (m+mft);
  return r;
}


float randomMap(int x, int y, float ox, float oy, float mx, float my) {
  // centering
  int cx = x - int(ox);
  int cy = y - int(oy);
  float r =  (random(sin(cx*mx), cos(cy*my)) + mx + my)  * 100 * (m+mft);;
  return r;
}
