class Animal {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float mass;
  float t;
  Attractor atr;
  color c1;
  color c2;
  color cl;
  
    Animal(float x, float y, float s, Attractor z) {
    acceleration = new PVector(0, 0);

    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    location = new PVector(x, y);
    r = 2.0;
    maxspeed = s;
    maxforce = 0.03;
    //mass=m;
    t=1;
    atr=z;
    
    c1=#110e0e;
    c2=#1e120f;
    
  }

  void run(ArrayList<Animal> animals) {
    flock(animals);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    //force.div(mass);
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Animal> animals) {
    PVector sep = separate(animals);   // Separation
    PVector ali = align(animals);      // Alignment
    PVector coh = cohesion(animals);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(random(4,8));
    ali.mult(random(0.5, 2));
    coh.mult(random(0.5, 2));
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
    
    r=map(noise(t),0,1,1,3);
    t+=0.03;
    
 
    PVector convergence = atr.location;
    PVector dir = PVector.sub(convergence, location);  
    dir.normalize();   //process that changes the range of pixel intensity values                     
    dir.mult(0.1);                         
    acceleration = dir;                              
 
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
  
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    cl= lerpColor (c1,c2, map(location.dist(att.location),0,200,0,1));
    
    fill(cl);
    stroke(c1);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, .5);
    vertex(-r, random(r*.2, r*1));
    vertex(r, random(r*.5, r*1));
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }

  // Separation
  // Method checks for nearby animals and steers away
  PVector separate (ArrayList<Animal> animals) {
    float desiredseparation = 15.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every animal in the system, check if it's too close
    for (Animal other : animals) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby animal in the system, calculate the average velocity
  PVector align (ArrayList<Animal> animals) {
    float neighbordist = 30;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Animal other : animals) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
    
      sum.setMag(maxspeed);
      
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby animals, calculate steering vector towards that location
  PVector cohesion (ArrayList<Animal> animals) {
    float neighbordist = 20;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Animal other : animals) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
}
