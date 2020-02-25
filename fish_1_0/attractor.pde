class Attractor {
  PVector location;
  float radius;
  float tx,ty;
  
  Attractor(float x,float y, float r) {
    radius = r;
    location = new PVector(x,y);
    tx=0;
    ty=1000;
  }
  void step(){
  location.x = map(noise(tx),0,1,100,width-100);
  location.y = map(noise(ty),0,1,100,height-100);
  
  tx+= 0.0005;
  ty+= 0.0005;
  }
  
  void checkEdges() {
    if (location.x < -radius) location.x = width+radius;
    if (location.y < -radius) location.y = height+radius;
    if (location.x > width+radius) location.x = -radius;
    if (location.y > height+radius) location.y = -radius;
  }
}
