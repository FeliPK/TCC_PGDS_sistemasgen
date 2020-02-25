ArrayList<Animal> flock1;
ArrayList<Animal> flock2;
ArrayList<Animal> flock3;
Attractor att;

int imageNum = (int) random (30, 1000);

color bg;

void setup() {
  size(800,600, P2D);
  //frameRate(60);
  background(255);
  bg = #cdad98;
  att= new Attractor(width/2,height/2, 5);
  
  flock1 = new ArrayList<Animal>();
  flock2 = new ArrayList<Animal>();
  flock3 = new ArrayList<Animal>();
  
  for (int i = 0; i < 510; i++) {
    Animal b = new Animal(width/2,height/2, random(3,5), att);
    flock1.add(b);
  }
  
  for (int i = 0; i < 360; i++) {
    Animal c = new Animal(width-50,height-50, random(4,6), att);
    flock2.add(c);
  }
  
  for (int i = 0; i < 230; i++) {
    Animal d = new Animal(50,50, random(1.5,4), att);
    flock1.add(d);
  }
}

  void draw() {
  noStroke();
  fill(bg,235);
  rect(0,0,width,height);
  for (Animal b:flock1){
  b.run(flock1);
  }
  for (Animal c:flock2){
  c.run(flock2);
  }
  att.step();
  att.checkEdges();
  
  
  }
  
  void mousePressed() {
  save("state"+imageNum);
  imageNum++;
}
