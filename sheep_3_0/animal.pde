class Animal {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float mass;
  float t;
  
  FenceSet fence;
  PVector convergence;
  
  color c1;
  color c2;
  color cl;
  
  PVector goRight;
  
    Animal(float x, float y, float s, FenceSet f) {
    acceleration = new PVector(0, 0);

    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    location = new PVector(x, y);
    r = 3.0;
    t=1;
    maxspeed = s;
    maxforce = 0.035;
    //mass=m;
    
    fence=f;
    convergence = fences.gate1;
    c1 = #E3DAD7;
    c2 = #95877B;
    goRight = new PVector(3,0);
    
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
    sep.mult(random(8,12));
    ali.mult(random(1,2));
    coh.mult(0.7);
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
    
    r=map(noise(t),0,1,1,4);
    
    t+=0.03;
    
    
    if(location.x<fences.gate1.x) convergence = fences.gate1;
    else if (location.x>=fences.gate1.x && location.x<fences.gate2.x) convergence = fences.gate2;
    else if (location.x>=fences.gate2.x && location.x<fences.gate3.x) convergence = fences.gate3;
    else if (location.x>=fences.gate3.x && location.x<fences.outside.x) convergence = location;
 
    if (convergence != location) {
    PVector dir = PVector.sub(convergence, location);  
    dir.normalize();   //process that changes the range of pixel intensity values                     
    dir.mult(0.4);                         
    acceleration = dir;                              
 
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    }
  }
  
  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from current location to the target
    // Scale to maximum speed
    desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }


//Function to turn away from fence
void repel(Fence obs){
    float maxRepelforce = 2;
    
    PVector predict = velocity.copy();
    predict.setMag(15); //Here 25 is arbitrary
    PVector futurePosition = PVector.add(location,predict);
    
    PVector a = obs.start;
    PVector b = obs.end;
    PVector normalPoint = getNormalPoint(futurePosition, a, b);
    
    float d = PVector.dist(normalPoint,futurePosition);
    if (normalPoint.y<obs.end.y && normalPoint.y>obs.start.y){
    if (d<=obs.radius) {
      PVector repelVector = PVector.sub(futurePosition, normalPoint);
      repelVector.normalize();
      if (d!=0) {
        
        repelVector.setMag(maxRepelforce);
        if (repelVector.mag()<0) {
         repelVector.setMag(0); //forces the creature not to pivot around
        }
      }
      
      applyForce(repelVector);
    }
    }
  }
  
  //function to calculate normal point along the fence
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p, a);
    // Vector from a to b
    PVector ab = PVector.sub(b, a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }

//Draws the animal
  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(90);
    
    
    fill(c1,200);
    stroke(c2,100);
    strokeWeight(1);
    pushMatrix();
    //blendMode(ADD);
    translate(location.x, location.y);
    rotate(theta);
    
    ellipse(0,0,5,8);
   // blendMode(BLEND);
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
    float desiredseparation = 12;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
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
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Animal> animals) {
    float neighbordist = 25;
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
