class Fence {

  // A Path is line between two points (PVector objects)
  PVector start;
  PVector end;
  // the fence has a radius, i.e how far is it ok for the animal to approach it
  float radius;

  Fence(PVector a, PVector b) {
    // Arbitrary radius of 20
    radius = 7;
    start = a;
    end = b;
  }

  // Draw the path
  void display() {
    pushMatrix();
    strokeWeight(radius);
    stroke(#26231a);
    strokeCap(SQUARE);
    line(start.x,start.y,end.x,end.y);
    strokeCap(ROUND);
    popMatrix();
  }
}
