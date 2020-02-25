ArrayList<Animal> flock1;
ArrayList<Animal> flock2;
ArrayList<Animal> flock3;
Attractor att;

color bg;

int imageNum = (int) random (30, 1000);


void setup() {
  size(800,600, P2D);
  background(255);
  frameRate(30);
  bg = #021523;
  
  att= new Attractor(width/2,height/2, 5);
  
  flock1 = new ArrayList<Animal>();
  flock2 = new ArrayList<Animal>();
  flock3 = new ArrayList<Animal>();
  
    for (int i = 0; i < 350; i++) {
    Animal b = new Animal(70,70, random(4,5), att);
    flock1.add(b);
  }
  
    for (int i = 0; i < 180; i++) {
    Animal c = new Animal(width-70,height-70, random(4,5.5), att);
    flock2.add(c);
  }
  
  for (int i = 0; i < 100; i++) {
    Animal d = new Animal(width/2,height/2, random(3,5), att);
    flock3.add(d);
  }
}

  void draw() {
  noStroke();
  fill(bg);
  rect(0,0,width,height);
  for (Animal b:flock1){
  b.run(flock1);
  }
  for (Animal c:flock2){
  c.run(flock2);
  }
  for (Animal d:flock3){
    blendMode(ADD);
  d.run(flock3);
    blendMode(BLEND);
  }
  att.step();
  att.checkEdges();
}

void mousePressed() {
  save("state"+imageNum);
  imageNum++;
}
