class Streak {
  PVector [] location;
  float streakWidth;
  color c;
  int colorDice=(int) random(4);
  
  
  Streak(float x, float y,float z) {
    location = new PVector [80];
    location[0]= new PVector (x, y);
    for (int i=1; i<location.length; i++) {
      location[i] = location[0].copy();
    }
    streakWidth = z;
    
    if (colorDice==0) c = #e1851c;
    else if (colorDice==1) c = #8e887c;
    else if (colorDice==2) c = #211c14;
    else c = #915318;
  }

  PVector getHead ()
  {
    return location [location.length-1].copy();
  }
  PVector getTail ()
  {
    return location [0].copy();
  }
  void setHead (PVector pos)
  {
    location [location.length-1]= pos.copy();

    updateBody ();
  }
  void updateBody (){
    for (int i = 0; i < location.length-1; i++)
    {
      location [i] = location [i+1];
    }
  }
  void resetBody(){
    for (int i = 0; i < location.length-1; i++)
    {
      location [i] = location [location.length-1].copy();
    }
  
  }
  void display ()
  {
  //  strokeWeight(streakWidth);
    noStroke();
   
    for (int i = 0; i < location.length; i++)
    {
      float s = map (i, 0, location.length, 1, streakWidth);
     // float s = streakWidth;
      
      fill (c, 60);
      ellipse (location[i].x,location[i].y, s, s);
    //  if (location[i].dist(location[i+1])<60){
     // noFill();
     // line (location[i].x, location [i].y,location[i+1].x,location[i+1].y);
    //  }
    }
    
  }
}
