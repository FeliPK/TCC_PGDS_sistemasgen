ArrayList<Animal> animals;
ArrayList<Animal> animals2;
Obstacle obstacle1;
Obstacle obstacle2;
Obstacle obstacle3;
PVector target;
PVector target2;

int imageNum = (int) random (30, 1000);

void setup(){
size (800, 600, P2D);
colorMode(HSB);
background(255);


animals = new ArrayList<Animal>();
animals2 = new ArrayList<Animal>();
obstacle1 = new Obstacle(random(0,width),random(0,height),random(30,70));
obstacle2 = new Obstacle(random(0,width),random(0,height),random(30,70));
obstacle3 = new Obstacle(random(0,width),random(0,height),random(30,70));

for (int i = 0; i < 60; i++) {
    Animal a = new Animal(random(0,height),random(0,width));
    animals.add(a);
  }
  
for (int i = 0; i < 100; i++) {
    Animal b = new Animal(random(0,height),random(0,width));
    animals2.add(b);
  }
}

void draw() {
pushMatrix();
//noStroke();
fill(#90adc6);
rect(0,0,width,height);
popMatrix();

for (Animal a : animals) {
  a.applyForce(a.seek(target = new PVector (width+50,random(0,height))));
  a.avoid(obstacle1);
//  a.avoid(obstacle2);
  a.avoid(obstacle3);
  a.checkEdges();
  a.run(animals);
  a.drawStreak();
  a.render();
}

for (Animal b : animals2) {
  b.applyForce(b.seek(target = new PVector (width+50,random(0,height))));
//  b.avoid(obstacle1);
  b.avoid(obstacle2);
//  b.avoid(obstacle3);
  b.checkEdges();
  b.run(animals2);
  b.figureSize = 1.5;
  
}

obstacle1.step();
obstacle2.step();
obstacle3.step();
obstacle1.checkEdges();
obstacle2.checkEdges();
obstacle3.checkEdges();

}

void mousePressed() {
  save("state"+imageNum);
  imageNum++;
}
