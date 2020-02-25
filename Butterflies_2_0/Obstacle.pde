class Obstacle {
  PVector location;
  float radius;
  float tx,ty;
  
  Obstacle(float x,float y, float r) {
    radius = r;
    location = new PVector(x,y);
    tx=0;
    ty=1000;
  }
  void step(){
  location.x = map(noise(tx),0,1,0,width);
  location.y = map(noise(ty),0,1,0,height);
  
  tx+= 0.01;
  ty+= 0.03;
  }
  
  void checkEdges() {
    if (location.x < -radius) location.x = width+radius;
    if (location.y < -radius) location.y = height+radius;
    if (location.x > width+radius) location.x = -radius;
    if (location.y > height+radius) location.y = -radius;
  }
}
