void fuel(int x, int y, int size){
  fill(0);
  noStroke();
  beginShape();
    vertex(x+size,y);
    bezierVertex(x+size*.88,y+size*.08,x+size*.78,y+size*.26,x+size*.84,y+size*.54);
    bezierVertex(x+size*1.04,y+size*1.12,x+size*.2,y+size*1.08,x+size*.2,y+size*.64);
    bezierVertex(x+size*.2,y+size*.42,x+size*.44,y+size*.1,x+size,y);
  endShape();
  noFill();
  strokeWeight(size*.1);
  stroke(255);
  arc(x+size*.51,y+size*.626,size*.4,size*.4,-4.12,-3.59);
}

void generalSpareParts(int x, int y, int size){
  fill(100);
  stroke(100,50,0);
  strokeWeight(4);
  rect(x+4,y+4,size-8,size-8);
}

void planes(int x, int y, int size){
  noStroke();
  fill(80);
  ellipse(x+size/2, y+size/2, size*.4, size);
  fill(71, 134, 27);
  ellipse(x+size/2, y+size*.3, size, size/5);
}

void energy(int x, int y, int size){
  fill(255,255,0);
  stroke(255,200,0);
  strokeWeight(size*.04);
  beginShape();
    vertex(x+size*.73,y+size*.1);
    vertex(x+size*.55,y+size*.54);
    vertex(x+size*.45,y+size*.5);
    vertex(x+size*.2,y+size*.9);
    vertex(x+size*.35,y+size*.23);
    vertex(x+size*.45,y+size*.27);
    vertex(x+size*.55,y+size*.04);
    vertex(x+size*.73,y+size*.1);
  endShape();
}

void runway(int x, int y, int size){
  fill(125);
  noStroke();
  rect(x,y,size,size);
  stroke(255);
  strokeWeight(size/25);
  line(x+(size/10),y,x+(size/10),y+size);
  line(x+(.9*size),y,x+(.9*size),y+size);
  line(x+(size/2),y+size,x+(size/2),y+(size*.8));
  line(x+(size/2),y+(size*.6),x+(size/2),y+(size*.4));
  line(x+(size/2),y+(size*.2),x+(size/2),y);
}

void artilery(int x, int y, int size){
  fill(150);
  stroke(255,0,0);
  strokeWeight(1);
  rect(x+(size/4),y+(size/2),size/2,size/2);
  noStroke();
  rect(x+(size*.3),y,size/10,size*.6);
  rect(x+(size*.45),y,size/10,size*.6);
  rect(x+(size*.6),y,size/10,size*.6);
  fill(0);
  ellipseMode(CORNER);
  ellipse(x+(size*.3),y-size/20,size/10,size/20);
  ellipse(x+(size*.45),y-size/20,size/10,size/20);
  ellipse(x+(size*.6),y-size/20,size/10,size/20);
  ellipseMode(CENTER);
}

void railGun(int x, int y, int size){
  fill(0);
  noStroke();
  rect(x+(size*.45),y,size*.1,size);
  fill(211,195,137);
  rect(x+(size*.35),y+1,size*.3,size*.2,size*.05);
  fill(150);
  rect(x+(size*.3),y+(size*.6),size*.4,size*.4);
}

void commsArray(int x, int y, int size){
  fill(0,0,100);
  stroke(0,0,100);
  strokeWeight(size*.1);
  ellipse(x+size/2,y+size*.9,size*.05,size*.05);
  noFill();
  arc(x+size/2,y+size*.9, size*.6,size*.6,(5*PI)/4,(7*PI)/4);
  arc(x+size/2,y+size*.9, size*1.2,size*1.2,(5*PI)/4,(7*PI)/4);
  arc(x+size/2,y+size*.9, size*1.8,size*1.8,(5*PI)/4,(7*PI)/4);
}

void sonar(int x, int y, int size){
  final float SIN = sqrt(2)/2;
  final float HS = size/2;
  stroke(0,255,0);
  strokeWeight(1);
  fill(0,30,150);
  ellipse(x+size/2,y+size/2,size,size);
  noFill();
  ellipse(x+size/2,y+size/2,size*.8,size*.8);
  ellipse(x+size/2,y+size/2,size*.6,size*.6);
  ellipse(x+size/2,y+size/2,size*.4,size*.4);
  ellipse(x+size/2,y+size/2,size*.2,size*.2);
  fill(0,255,0);
  ellipse(x+size/2,y+size/2,size*.05,size*.05);
  line(x+size/2,y,x+size/2,y+size);
  line(x,y+size/2,x+size,y+size/2);
  line(x+(HS*SIN)+HS,y+(HS*SIN)+HS,x-(HS*SIN)+HS,y-(HS*SIN)+HS);
  line(x+(HS*SIN)+HS,y-(HS*SIN)+HS,x-(HS*SIN)+HS,y+(HS*SIN)+HS);
}

void motor(int x, int y, int size){
  noFill();
  strokeWeight(size/6);
  stroke(130);
  line(x+size/2,y+size/8,x+size/2,y+size*.625);
  stroke(100);
  strokeWeight(size/25);
  line(x+size/2,y+size/8,x+size/2,y+size*.675);
  strokeWeight(size/8);
  stroke(130);
  arc(x+size*0.50,y+size*0.84,size*0.40,size*0.40,3.59,5.81);
  fill(150);
  noStroke();
  rect(x+size*.25,y,size/2,size/4);
  strokeWeight(size/5);
  stroke(150);
  noFill();
  arc(x+size/2,y+size/2,size*0.73,size*0.59,4.29,5.16);
  stroke(100);
  strokeWeight(size/25);
  line(x+size*.27,y+size/16,x+size*.73,y+size/16);
  line(x+size*.27,y+size*.1875,x+size*.73,y+size*.1875);
}

void decoy(int x, int y, int size){
  noStroke();
  fill(150);
  ellipse(x+size/2,y+size/2,size,size);
}

void progressBar(int x, int y, float w, int h, float amount, float outOf){
  float percent = (amount/outOf)*w;
  noStroke();
  fill(255,0,0);
  rect(x,y,w,h);
  fill(0,255,0);
  rect(x,y,percent,h);
}

void credit(int x, int y, int size){
  ellipseMode(CORNER);
  fill(255,255,0);
  stroke(255,200,0);
  strokeWeight(4);
  ellipse(x+3,y+3,size-6,size-6);
  ellipseMode(CENTER);
  fill(255,200,0);
  textSize(size*.8);
  text("$",x+(size*.52),y+(size*.4));
}
