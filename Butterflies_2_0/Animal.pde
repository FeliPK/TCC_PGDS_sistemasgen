class Animal {
  
  //Set of class variables
  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxVel; //Max speed
  float maxForce; //Max steering force
  float mass; //Animal mass
  float radius;
  float r;
  //these are for the animation
  float t =random(0,10);
  float figureSize;
  float animalSize;
  int colorDice=(int) random(4);
  color c;
  Streak streak;
  
  //Constructor argument
  Animal(float x, float y) {
    location = new PVector (x,y);
    velocity = new PVector (1,1);
    acceleration = new PVector (0,0);
    maxVel = map(noise(t),0,1,1,6);
    maxForce = 0.05;
    mass = 1;
    r=3;
    figureSize = 1;
    animalSize = map(noise(7),0,1,2,7);
    if (colorDice==0) c = #f8b135;
    else if (colorDice==1) c = #dac499;
    else if (colorDice==2) c = #382f21;
    else c = #cb8039;
    streak = new Streak(location.x,location.y,animalSize);
    
  }
  
  //Run the behaviors for each animal
  void run(ArrayList<Animal> animals) {
    update();
    render();
    checkEdges();
    flock (animals);
    
    //lookupField();
    //followPath();
  }
  
  void flock(ArrayList<Animal>animals) {
    PVector sep = separate(animals); //separation
    PVector ali = align(animals); //alignment
    PVector coh = cohesion(animals); //cohesion
    
    //Arbitrarily weight these forces
    sep.mult(1);
    ali.mult(0.5);
    coh.mult(0.7);
    
    //aplies these forces to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  //Updates the data frame by frame
  void update() {
    streak.setHead(location);
   // streak.updateBody();
    velocity.add(acceleration);
    velocity.limit(maxVel*figureSize);
    location.add(velocity);
    acceleration.mult(0);
    t += 0.05;
    
    
  }
  
  //Draws the animal on screen based on data
  void render() {
    PVector[] closed = new PVector [6];
    PVector[] open= new PVector [6];
    PVector[] lerp= new PVector [6];
    float theta = velocity.heading() + radians(90);
    float flap = noise(t);
    
  //set the vector points for the drawing, what is counter-indented is made for the butterfly animation
  closed[0]=new PVector(0, -6);
  closed[1]=new PVector(0, -6);
  closed[2]=new PVector(1, -1);
  closed[3]=new PVector(0, 4);
  closed[4]=new PVector(-1, -1);
  closed[5]=new PVector(0, -6);

  open[0]=new PVector(0, -4);
  open[1]=new PVector(6, -6);
  open[2]=new PVector(8, -2);
  open[3]=new PVector(0, 4);
  open[4]=new PVector(-8, -2);
  open[5]=new PVector(-6, -6);

  lerp[0]=PVector.lerp(open[0],closed[0], flap);
  lerp[1]=PVector.lerp(open[1],closed[1], flap);
  lerp[2]=PVector.lerp(open[2],closed[2], flap);
  lerp[3]=PVector.lerp(open[3],closed[3], flap);
  lerp[4]=PVector.lerp(open[4],closed[4], flap);
  lerp[5]=PVector.lerp(open[5],closed[5], flap);
    
    strokeWeight(0);
    fill(c);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    pushMatrix();
    scale(figureSize);
    beginShape();
  vertex(lerp[0].x, lerp[0].y);
  vertex(lerp[1].x, lerp[1].y);
  vertex(lerp[2].x, lerp[2].y);
  vertex(lerp[3].x, lerp[3].y);
  vertex(lerp[4].x, lerp[4].y);
  vertex(lerp[5].x, lerp[5].y);
    endShape(CLOSE);
    popMatrix();
    popMatrix();
  
  }
  
  void drawStreak() {
    streak.display();
  }
  
  //Receives an external force and applies it to the animal
  void applyForce(PVector force){
   force.div(mass);
   acceleration.add(force);
  }
  
  //Seek behavior
  PVector seek (PVector target){
    
    //Finds Desired velocity and limits to maxVel
    PVector desired = PVector.sub(target,location);
    desired.setMag(maxVel);
    
    //ARRIVE BEHAVIOR HERE
    //float d = desired.mag();
    //if (d < 100) { //here 100 sets the slowing distance
    //  float m = map(d,0,100,0,maxVel);
    //  desired.setMag(m);
    //} else {
    //  desired.setMag(maxVel);
    //}
    //END OF ARRIVE BEHAVIOR
    
    //Finds Steering vector and limits to maxForce
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxForce);
    
    return steer;
  }
  
  //Cohesion behavior
  PVector cohesion (ArrayList<Animal> animals){
    float neighborDist = 50;
    PVector sum = new PVector(0,0); //starts empty to accumulate all locations
    int count = 0;
    for (Animal other:animals) {
      float d = PVector.dist(location,other.location);
      if((d>0) && (d<neighborDist)) {
        sum.add(other.location);
        count++;
      }
    }
    if (count>0) {
      sum.div(count);
      return seek(sum);
    } else {
      return new PVector(0,0);    
    }
  }
  
  //Separate behavior
  PVector separate (ArrayList<Animal> a) {
    float desiredSeparation = 50 * figureSize;
    PVector steer = new PVector(0,0);
    int count = 0;
    
    //For every other animal check if is too close
    for(Animal other : a) {
      float d = PVector.dist(location, other.location);
      //if the distance is greater than 0 and less than an arbirary amount (0 because then you are yourself)
      if ((d>0) && (d<desiredSeparation)) {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);     //weight by distance
        steer.add(diff);
        count++;         //keep track of how many
      }
    }
    //averages
    if (count>0) {
      steer.div(float(count));
    }
    //as long as the vector is bigger than 0 implements Reynolds' Steering=desired-velocity
    if (steer.mag()>0) {
      steer.setMag(maxVel);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }
  
  //Align behavior
  PVector align(ArrayList<Animal> a){
    float neighborDist = 70 * figureSize;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (Animal other:a) {
      float d = PVector.dist(location,other.location);
      if ((d>0) && (d<neighborDist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count>0) {
      sum.div(float(count));
      sum.setMag(maxVel);
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector(0,0);
    }
  }
  
  //Repel from obstacle
  void repel(Obstacle obs){
    float maxRepelforce = 4;
    
    PVector predict = velocity.copy();
    predict.setMag(25); //Here 25 is arbitrary
    PVector futurePosition = PVector.add(location,predict);
    float d = PVector.dist(obs.location,futurePosition);
    
    if (d<=obs.radius) {
      PVector repelVector = PVector.sub(futurePosition, obs.location);
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
  
    //avoid obstacle
  void avoid(Obstacle obs){
    PVector predict = velocity.copy();
    predict.setMag(25); //Here 25 is arbitrary
    PVector futurePosition = PVector.add(location,predict);
    float d = PVector.dist(obs.location,futurePosition);
    PVector lead=futurePosition;
    lead.add(location);
    if (d<=obs.radius) {
      PVector avoidVector = PVector.sub(lead, obs.location);
      avoidVector.normalize();
      avoidVector.mult(maxVel);
      avoidVector.sub(velocity);
      float setForce = map(d, obs.radius, (obs.radius+30), maxForce, 0);
      avoidVector.limit(setForce);
      applyForce(avoidVector);
    }
  }
  
  //calculates distance between point and segment
  float distanceToSegment(PVector p1, PVector p2, PVector p3) {
    float xDelta = p2.x - p1.x;
    float yDelta = p2.y - p1.y;
    float u = ((p3.x - p1.x) * xDelta + (p3.y - p1.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta);
    PVector point;
    if (u < 0) {
      point = p1;
    } else if (u > 1) {
      point = p2;
    } else {
      point = new PVector(p1.x + u * xDelta, p1.y + u * yDelta);
    }
    return PVector.dist(point, p3);
  }
  
  //Flow field follow behavior
  void followField(FlowField flow){
    //gets the Flow field vector in the current location
    PVector desired = flow.lookup(location);
    desired.mult(maxVel);
    //turns to direction in flowfield
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    
    applyForce(steer);
  }
  
  //Path following behavior
  void followPath(){}
  
  //Wraparound for the particles
  void checkEdges() {
    if (location.x < -radius) location.x = width+radius; //streak.resetBody();
    if (location.y < -radius) location.y = height+radius; //streak.resetBody();
    if (location.x > width+radius) location.x = -radius; //streak.resetBody();
    if (location.y > height+radius) location.y = -radius; //streak.resetBody();
  }
  
  
}
