class Wavelet {
  
  float x;
  float y;
  int dir;
  float speed = random(.5,1);
  int caps = (int)random(1,4);
  int size = (int)random(5,10);
  
  Wavelet(){
    x=random(-(caps*2*size)-1,width+2);
    y=random(0,height-size);
    dir=(int)random(1,3);
  }
  
  void drawWave(){
    pushMatrix();
    translate(x,y);
    for(int w = 0; w<caps; w++){
      ellipseMode(CENTER);
      noFill();
      strokeWeight(size/5);
      stroke(10,36,198);
      arc(w*2*size,0,2*size,2*size,0,HALF_PI);
      arc((w+1)*2*size,0,2*size,2*size,HALF_PI,PI);
      fill(255);
      noStroke();
      ellipse(2*w*size+size+1,0,size/5,size/5);
    }
    popMatrix();
    move();
  }
  
  void move(){
    if(dir<2){
      x-=speed;
    }else{
      x+=speed;
    }
    if(x>width+5){
      x=-(caps*2*size)-1;
      y=random(0,height-size);
      speed=random(.5,1);
    }
    if(x<-(caps*2*size)-5){
      x=width+2;
      y=random(0,height-size);
      speed=random(.5,1);
    }
  }
  
}
