class FenceSet {
  
  PVector fence1A;
  PVector fence1B;
  PVector fence1C;
  PVector fence1D;
  PVector gate1;
  
  PVector fence2A;
  PVector fence2B;
  PVector fence2C;
  PVector fence2D;
  PVector gate2;
  
  PVector fence3A;
  PVector fence3B;
  PVector fence3C;
  PVector fence3D;
  PVector gate3;
  
  PVector outside;
  
  Fence fence1top;
  Fence fence1bottom;
  Fence fence2top;
  Fence fence2bottom;
  Fence fence3top;
  Fence fence3bottom;
  
  FenceSet() {
    float gateSize = random(25,40);
    fence1A = new PVector (random(55,width/3), -10);
    fence1B = new PVector (fence1A.x,random(30,height-90));
    fence1C = new PVector (fence1A.x, fence1B.y+gateSize);
    fence1D = new PVector (fence1A.x, height+10);
    fence1top = new Fence(fence1A,fence1B);
    fence1bottom = new Fence(fence1C,fence1D);
    gate1 = PVector.lerp(fence1B,fence1C, 0.5);
    
    gateSize = random(20,35);
    fence2A = new PVector (random(width/3+30,width/2), -10);
    fence2B = new PVector (fence2A.x,random(30,height-90));
    fence2C = new PVector (fence2A.x, fence2B.y+gateSize);
    fence2D = new PVector (fence2A.x, height+10);
    fence2top = new Fence(fence2A,fence2B);
    fence2bottom = new Fence(fence2C,fence2D);
    gate2 = PVector.lerp(fence2B,fence2C, 0.5);
    
    gateSize = random(30,45);
    fence3A = new PVector (random(width/2+50,width-200), -10);
    fence3B = new PVector (fence3A.x,random(30,height-90));
    fence3C = new PVector (fence3A.x, fence3B.y+gateSize);
    fence3D = new PVector (fence3A.x, height+10);
    fence3top = new Fence(fence3A,fence3B);
    fence3bottom = new Fence(fence3C,fence3D);
    gate3 = PVector.lerp(fence3B,fence3C, 0.5);
    
    outside = new PVector(width+5, random(30,height-30));
  }
 
 void display(){
 fence1top.display();
 fence1bottom.display();
 fence2top.display();
 fence2bottom.display();
 fence3top.display();
 fence3bottom.display();
 }
  
  
}  
