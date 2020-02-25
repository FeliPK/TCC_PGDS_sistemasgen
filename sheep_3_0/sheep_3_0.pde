ArrayList<Animal> flock1;
FenceSet fences;
float tGlobal;
color bg;
int dice;

int imageNum = (int) random (30, 1000);

void setup() {
  size(800,600, P2D);
  background(255);
  frameRate(30);
  bg = #7E7E40;
  dice=(int) random(3);
  
  fences= new FenceSet();
  flock1 = new ArrayList<Animal>();
  
    for (int i = 0; i < 500; i++) {
    tGlobal=100;
    Animal b = new Animal(random(3,50),random(40,height -50),random(0.75,1.4),fences);
    flock1.add(b);
    tGlobal +=0.1;
  }
}

  void draw() {
  noStroke();
  fill(bg,200);
  rect(0,0,width,height);
  
  for (Animal b:flock1){
  b.run(flock1);
  b.repel(fences.fence1top);
  b.repel(fences.fence1bottom);
  b.repel(fences.fence2top);
  b.repel(fences.fence2bottom);
  b.repel(fences.fence3top);
  b.repel(fences.fence3bottom);
  }
  fences.display();
}
 
 void mousePressed() {
  save("state"+imageNum);
  imageNum++;
}
