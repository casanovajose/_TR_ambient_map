int tam = 500;
float[][] hm = new float[tam][tam];

import controlP5.*;
ControlP5 cp5;

// result
PImage img = createImage(500, 500, GRAY);

// function selector
int CIRCLE = 0;
int LINEAL = 1;
int NOISE = 2;
int RANDOM = 3;

// center
Slider2D ctr;


float step = 0.8;
int offset = 50;
int x = 0;
int y = 0;
byte tone = 64;
float mem = 0;

// controls

float rx = 0.1;
float ry = 0.1;
float m = 1;
String scene = "";
String name = "";

// bg
PImage bg;

void setup() {
  size(800, 600);
  //clear(); 
  
  // center slider
  cp5 = new ControlP5(this);
  ctr = cp5.addSlider2D("CENTER")
         .setPosition(480, 50)
         .setSize(100,100)
         .setMinMax(0,0,tam, tam)
         .setValue(50,50)
         .setLabel("Center")
         .setColorCaptionLabel(0)
         // .disableCrosshair()
         ;
  
  cp5.addSlider("rx")
    .setPosition(480,180)
    .setRange(-5, 5)
    .setLabel("wide")
    .setColorCaptionLabel(0)
    .setSize(200, 20)
    ;
    
  cp5.addSlider("ry")
    .setPosition(480,210)
    .setRange(-5, 5)
    .setLabel("Height")
    .setColorCaptionLabel(0)
    .setSize(200, 20)
    ; 
  
  cp5.addSlider("m")
    .setPosition(480,240)
    .setRange(0.001, 50)
    .setLabel("Mult")
    .setColorCaptionLabel(0)
    .setSize(200, 20)
    ;  
  
  
  cp5.addTextfield("scene").setPosition(480, 280).setSize(200, 20).setAutoClear(false)
    .setLabel("AMBIENT/SPACE")
    .setColorCaptionLabel(0);
  cp5.addTextfield("name").setPosition(480, 320).setSize(200, 20).setAutoClear(false)
    .setLabel("SPEAKER/REVERB SPACE")
    .setColorCaptionLabel(0)
    ;

    cp5.addButton("saveMap",1)
    .setCaptionLabel("SAVE")
    .setPosition(480,370)
    .setSize(200, 20)
    ;
   //cp5.addButton("save_scene")
   //  .setPosition(480, 370)
   //  .setSize(200,19)
   //  .setValue(0)
   //  ;
  
  colorMode(HSB, 100, 100, 100, 100);
  for (int i = 0; i < tam; i++) {
    for (int j = 0; j < tam; j++) {      
      hm[j][i] = circle(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry);
     // hm[i][j] = map(( i +sin(i)*PI/180), 0 , tam*tam, 0, 100);
    }
  }
   
  background(100, 0, 100);
  bg = loadImage("bg-tile.png");
  //tint(255, 10);
  //image(bg, 0, 0);
}

void draw() {
  tint(255, 30);
  image(bg, 0, 0);
  noTint();
  // println(scene);
  noStroke();
  fill(0, 0, 255, 20);
  rect(0, 0, width, height);
  
  //for (int i = 0; i < tam; i++) {
  //  for (int j = 0; j < tam; j++) {
  //    img.set(j, i, color( hm[i][j])); 
  //  }
  //}
  image(img, offset, offset, 400, 400);
  //stroke(0,0,0, 50);
  //strokeWeight(1);
  //x = (mouseX-offset)/step;
  //y = (mouseY-offset)/step;
  
  //if(tone > 100) {tone = 100;}
  //if(tone < 0) {tone = 0;}
  //for (int i = 0; i < tam; i++) {
  //  for (int j = 0; j < tam; j++) {
  //    //if(x == j && y == i && mousePressed) {
  //    //  hm[i][j] = tone;
  //    //}
  //    fill(hm[i][j]);
  //    rect(offset + j * step, offset + i * step, step, step);
  //  }  
  //}
  
  noFill();
  stroke(0,100,0);
  strokeWeight(1);
  rect(offset, offset, tam*step, tam*step);
  //fill(map(tone, 0, 100, 0, 255), tone/2, 100- tone/2);
  //rect(20, 20, 20, 20);
  //image(img, 500, 500);
  
  //mem = (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / 1024.0 * 1024.0 * 1024.0;
  //text(nfs(mem, 0, 3), width - 90, 20);
}

void setMap() {
  for (int i = 0; i < tam; i++) {
    for (int j = 0; j < tam; j++) {
      hm[i][j] = 100;
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

void controlEvent(ControlEvent e) {
  
  //if (e.isFrom(cp5.getController("save"))) {
  //  println("SAVE");
  //}
  //Controller c = cp5.getController("ctr");
  //Controller rx = cp5.getController("CENTER");
  //Controller ry = cp5.getController("CENTER");
  for (int i = 0; i < tam; i++) {
    for (int j = 0; j < tam; j++) {
      hm[i][j] = circle(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry);
      //hm[i][j] = lineal(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry);
      //hm[i][j] = randomMap(j, i, ctr.getArrayValue()[0], ctr.getArrayValue()[1], rx, ry);
      img.set(j, i, color( hm[i][j]));
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
  return 100 - ((cx*cx*mx + cy*cy*my)/ m);
}

float lineal(int x, int y, float ox, float oy, float mx, float my) {
  // centering
  int cx = x - int(ox);
  int cy = y - int(oy);
  return 100 - (cx*mx+cy*my )* m;
}

float noiseMap(int x, int y, float ox, float oy, float mx, float my) {
  // centering
  int cx = x - int(ox);
  int cy = y - int(oy);
  float r = noise(cx*mx, cy*my, m) * 100 * m;
  return r;
}


float randomMap(int x, int y, float ox, float oy, float mx, float my) {
  // centering
  int cx = x - int(ox);
  int cy = y - int(oy);
  float r =  (random(sin(cx*mx), cos(cy*my)) + mx + my)  * 100 * m;;
  return r;
}
