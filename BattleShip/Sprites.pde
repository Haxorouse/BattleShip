void carrierSprite(){
  pushMatrix();
    rotate(PI);
    translate(0,-5*tileSize);
    fill(150);
    noStroke();
    rect(15,15,39,290);
    rect(11,70,5,235);
    rect(2,100,10,30);
    triangle(15,55,15,70,11,70);
    rect(54,70,5,70);
    fill(180);
    ellipse(54,105,10,50);
    stroke(50);
    strokeWeight(2);
    line(46,100,62,100);
    noStroke();
    fill(220);
    ellipse(54,100,5,5);
    stroke(0,0,50);
    strokeWeight(1);
    noFill();
    arc(54,105,6,46,-2.551,-0.598);
    stroke(255);
    strokeWeight(2);
    strokeCap(SQUARE);
    line(15,140,15,304);
    line(49,140,49,304);
    line(32,140,32,155);
    line(32,170,32,185);
    line(32,200,32,215);
    line(32,230,32,245);
    line(32,260,32,275);
    line(32,290,32,304);
    strokeWeight(4);
    strokeCap(PROJECT);
    line(13,98,21,98);
    line(21,98,21,132);
    line(21,132,13,132);
    strokeWeight(2);
    strokeCap(SQUARE);
    line(27,105,27,125);
    line(40,105,40,125);
    line(27,115,40,115);
    stroke(50);
    line(20,19,20,70);
    line(48,19,48,70);
    line(17,19,23,19);
    line(45,19,51,19);
    fill(255);
    textSize(18);
    textAlign(CENTER,CENTER);
    text(DISPLAYNUM,34,26);
    noStroke();
    fill(100);
    beginShape();
      vertex(20,305);
      vertex(49,305);
      vertex(46,310);
      vertex(23,310);
      vertex(20,305);
    endShape();
    pushMatrix();
      translate(36,90);
      scale(.3);
      planeSprite();
      translate(-60,0);
      rotate(PI/4);
      planeSprite();
      translate(-40,-40);
      planeSprite();
      rotate(-PI/4);
      translate(-27,140);
      planeSprite();
    popMatrix();
  popMatrix();
}

void carrierSunkSprite(){
  
}

void battleSprite(){
  pushMatrix();
  rotate(PI);
  translate(0,-4*tileSize);
    fill(134,95,18);
    noStroke();
    beginShape();
      vertex(26.7,15.3);
      vertex(13,242);
      vertex(51,242);
      vertex(37.3,15.3);
    endShape();
    strokeWeight(1);
    stroke(150);
    arc(610,170,1200,1300,PI-0.11,PI+0.24, OPEN);
    arc(-546,170,1200,1300,-0.24,0.11,OPEN);
    arc(32,47,26,68.1,-5*PI/8,-3*PI/8);
    
    noStroke();
    beginShape();
      vertex(13.5,241.5);
      vertex(19,248.5);
      vertex(45,248.5);
      vertex(50.5,241.5);
    endShape();
    stroke(150);
    arc(32,245,35,10,PI/4,3*PI/4);
    line(13.5,241.5,19,248.5);
    line(50.5,241.5,45,248.5);
    noStroke();
    
    AA(32,21,0);
    AA(26,40,0);
    AA(38,40,0);
    AA(21,71,0);
    AA(43,71,0);
    AA(16,108,0);
    AA(48,108,0);
    AA(15,140,0);
    AA(49,140,0);
    AA(15,175,1);
    AA(49,175,1);
    AA(19,208,1);
    AA(45,208,1);
    AA(23,225,1);
    AA(41,225,1);
    AA(32,233,1);
    artilery(32,55,batRot);
    
    noStroke();
    fill(140);
    ellipse(14,187,4,10);
    ellipse(19,187,4,10);
    ellipse(50,187,4,10);
    ellipse(45,187,4,10);
    fill(130);
    rect(12,187,4,15);
    rect(17,187,4,15);
    rect(48,187,4,15);
    rect(43,187,4,15);
    
    fill(160);
    ellipse(23,187,3,3);
    ellipse(41,187,3,3);
    ellipse(24,246,3,3);
    ellipse(40,246,3,3);
    strokeWeight(1);
    stroke(160);
    line(23,187,23,204);
    line(41,187,41,204);
    line(24,246,24,231);
    line(40,246,40,231);
    
    noStroke();
    beginShape();
      vertex(20,146);
      vertex(17,149);
      vertex(17,165);
      vertex(20,168);
      vertex(44,168);
      vertex(47,165);
      vertex(47,149);
      vertex(44,146);
      vertex(20,146);
    endShape();
    
    beginShape();
      vertex(20,114);
      vertex(17,117);
      vertex(17,135);
      vertex(20,138);
      vertex(44,138);
      vertex(47,135);
      vertex(47,117);
      vertex(44,114);
      vertex(20,114);
    endShape();
    
    //start level 2
    
    fill(155,107,12);
    strokeWeight(1);
    stroke(150);
    beginShape();
      vertex(25,80);
      vertex(39,80);
      vertex(44,90);
      vertex(44,180);
      vertex(39,185);
      vertex(39,210);
      vertex(34,215);
      vertex(30,215);
      vertex(25,210);
      vertex(25,185);
      vertex(20,180);
      vertex(20,90);
      vertex(25,80);
    endShape();
    
    
    artilery(32,96,batRot);
    
    
    pushMatrix();
      translate(32,206);
      scale(.5);
      artilery(1,0,3);
    popMatrix();
    
    //start level 3
    
    fill(178,121,10);
    strokeWeight(1);
    stroke(160);
    rect(26,111,12,83);
    
    pushMatrix();
      scale(.5);
      artilery(65,245,1);
      artilery(65,377,3);
    popMatrix();
    
    stroke(0);
    strokeWeight(1);
    line(32.5,177,32.5,189);
    noStroke();
    fill(160);
    ellipse(32.5,177,3,3);
    
    //start level 4
    
    fill(188,133,14);
    stroke(170);
    strokeWeight(1);
    
    rect(22,131,20,43);
    
    AA(25,145,0);
    AA(39,145,0);
    AA(25,170,1);
    AA(39,170,1);
    pushMatrix();
    rotate(PI/2);
      AA(158,-40,0);
      AA(158,-24,1);
    popMatrix();
    
    noStroke();
    fill(113,88,24);
    rect(29,137,6,34);
    
    strokeCap(SQUARE);
    strokeWeight(1);
    stroke(170);
    fill(95,72,20);
    beginShape();
      vertex(29,171);
      vertex(29,165);
      vertex(34.5,165);
      vertex(34.5,171);
    endShape();
    
    beginShape();
      vertex(29,159);
      vertex(29,153);
      vertex(34.5,153);
      vertex(34.5,159);
    endShape();
    
    noStroke();
    fill(150);
    beginShape();
      vertex(28,137);
      vertex(36,137);
      vertex(40,146);
      vertex(35,155);
      vertex(29,155);
      vertex(24,146);
      vertex(28,137);
    endShape();
    
    fill(130);
    ellipse(32,146,8,8);
    
    strokeWeight(3);
    strokeCap(SQUARE);
    stroke(170);
    line(28,154,36,146);
  popMatrix();
}

void AA(int x, int y, int dir){
  pushMatrix();
    translate(x,y);
    rotate(PI*dir);
    translate(-3,0);
    noStroke();
    fill(150);
    beginShape();
      vertex(0,0);
      vertex(6,0);
      vertex(5,5);
      vertex(1,5);
      vertex(0,0);
    endShape();
    strokeWeight(1);
    stroke(0);
    strokeCap(SQUARE);
    line(2,1,2,-4);
    line(4,1,4,-4);
  popMatrix();
}

void battleSunkSprite(){
  
}

void destroySprite(){
  pushMatrix();
  rotate(PI);
  translate(0,-3*tileSize);
    fill(120);
    noStroke();
    rect(15,55,34,82);
    arc(49,55,68,92.4,PI,(4*PI)/3);
    arc(15,55,68,92.4,(5*PI)/3,2*PI);
    fill(110);
    beginShape();
      vertex(15,137);
      vertex(20,177);
      vertex(44,177);
      vertex(49,137);
      vertex(15,137);
    endShape();
    fill(70);
    strokeWeight(1);
    stroke(200);
    beginShape();
      vertex(20,147);
      vertex(23,172);
      vertex(40,172);
      vertex(43,147);
      vertex(20,147);
    endShape();
    strokeWeight(2);
    stroke(255);
    line(28,159,35,159);
    line(28,164,28,154);
    line(35,164,35,154);
    strokeWeight(1);
    stroke(255,0,0);
    noFill();
    pushMatrix();
    translate(0,-10);
      ellipse(32,47,20,20);
      noStroke();
      fill(150);
      beginShape();
        vertex(25,43);
        vertex(29,52);
        vertex(35,52);
        vertex(39,43);
        vertex(25,43);
      endShape();
      fill(180);
      beginShape();
        vertex(27,45);
        vertex(29,52);
        vertex(35,52);
        vertex(37,45);
        vertex(27,45);
      endShape();
      fill(100);
      beginShape();
        vertex(25,43);
        vertex(27,45);
        vertex(37,45);
        vertex(39,43);
        vertex(25,43);
      endShape();
      stroke(0);
      line(32,44,32,35);
      fill(200);
      noStroke();
      rect(24,60,16,10);
    popMatrix();
    rect(27,125,10,12);
    strokeWeight(1);
    stroke(100);
    fill(140);
    rect(25,103,14,18);
    beginShape();
      vertex(16,72);
      vertex(16,90);
      vertex(23,97);
      vertex(41,97);
      vertex(48,90);
      vertex(48,72);
      vertex(43,68);
      vertex(21,68);
      vertex(16,72);
    endShape();
    noStroke();
    fill(0);
    ellipse(32,105,4,4);
    ellipse(32,110,4,4);
    ellipse(32,95,4,4);
    ellipse(32,89,4,4);
    strokeWeight(1);
    stroke(80);
    fill(160);
    beginShape();
      vertex(16,77);
      vertex(16,86);
      vertex(48,86);
      vertex(48,77);
      vertex(44,74);
      vertex(20,74);
      vertex(16,77);
    endShape();
    noStroke();
    fill(200);
    triangle(32,74,30,86,34,86);
    strokeWeight(2);
    stroke(100);
    line(28,77,36,77);
    line(26,84,38,84);
    strokeWeight(1);
    stroke(180);
    fill(100);
    ellipse(45.5,105,3,4);
    ellipse(45.5,123,3,4);
    ellipse(18.5,105,3,4);
    ellipse(18.5,123,3,4);
    noStroke();
    rect(44,105,3,7);
    rect(44,116,3,7);
    rect(17,105,3,7);
    rect(17,116,3,7);
    stroke(180);
    line(44,105,44,112);
    line(47,105,47,112);
    line(44,115.5,44,123);
    line(47,115.5,47,123);
    line(17,105,17,112);
    line(20,105,20,112);
    line(17,115.5,17,123);
    line(20,115.5,20,123);
  popMatrix();
}

void destroySunkSprite(){
  
}

void subSprite(){
  pushMatrix();
  rotate(PI);
  translate(0,-3*tileSize);
    noStroke();
    fill(30);
    beginShape();
      vertex(15,180);
      vertex(49,180);
      vertex(54,170);
      vertex(32,160);
      vertex(10,170);
      vertex(15,180);
    endShape();
    beginShape();
      vertex(5,32);
      vertex(59,32);
      vertex(59,37);
      vertex(32,40);
      vertex(5,37);
      vertex(5,32);
    endShape();
    fill(40);
    rect(15,25,34,120);
    ellipse(32,25,34,48);
    arc(-19,145,136,136,0,PI*.23,OPEN);
    arc(83,145,136,136,PI*.77,PI,OPEN);
    triangle(15,145,49,145,32,190.48);
    fill(35);
    ellipse(26,190,12,4);
    ellipse(38,190,12,4);
    fill(50);
    ellipse(32,50,10,30);
  popMatrix();
}

void subSprite(int alpha){
  pushMatrix();
  rotate(PI);
  translate(0,-3*tileSize);
    noStroke();
    fill(30,alpha);
    beginShape();
      vertex(15,180);
      vertex(49,180);
      vertex(54,170);
      vertex(32,160);
      vertex(10,170);
      vertex(15,180);
    endShape();
    beginShape();
      vertex(5,32);
      vertex(59,32);
      vertex(59,37);
      vertex(32,40);
      vertex(5,37);
      vertex(5,32);
    endShape();
    fill(33,40,85);
    rect(15,25,34,120);
    ellipse(32,25,34,48);
    arc(-19,145,136,136,0,PI*.23,OPEN);
    arc(83,145,136,136,PI*.77,PI,OPEN);
    triangle(15,145,49,145,32,190.48);
    fill(40,alpha);
    rect(15,25,34,120);
    arc(32,25,34,48,PI,2*PI);
    arc(-19,145,136,136,0,PI*.23,OPEN);
    arc(83,145,136,136,PI*.77,PI,OPEN);
    triangle(15,145,49,145,32,190.48);
    fill(35,alpha);
    ellipse(26,190,12,4);
    ellipse(38,190,12,4);
    fill(50);
    ellipse(32,50,10,30);
  popMatrix();
}

void subUnderSprite(){
  pushMatrix();
  rotate(PI);
  translate(0,-3*tileSize);
    noStroke();
    fill(30,100);
    beginShape();
      vertex(15,180);
      vertex(49,180);
      vertex(54,170);
      vertex(32,160);
      vertex(10,170);
      vertex(15,180);
    endShape();
    beginShape();
      vertex(5,32);
      vertex(59,32);
      vertex(59,37);
      vertex(32,40);
      vertex(5,37);
      vertex(5,32);
    endShape();
    fill(33,40,85);
    rect(15,25,34,120);
    ellipse(32,25,34,48);
    arc(-19,145,136,136,0,PI*.23,OPEN);
    arc(83,145,136,136,PI*.77,PI,OPEN);
    triangle(15,145,49,145,32,190.48);
    fill(40,100);
    rect(15,25,34,120);
    arc(32,25,34,48,PI,2*PI);
    arc(-19,145,136,136,0,PI*.23,OPEN);
    arc(83,145,136,136,PI*.77,PI,OPEN);
    triangle(15,145,49,145,32,190.48);
    fill(35,100);
    ellipse(26,190,12,4);
    ellipse(38,190,12,4);
    fill(50);
    ellipse(32,50,10,30);
  popMatrix();
}

void subSunkSprite(){
  
}

void patrolSprite(){
  pushMatrix();
    rotate(PI);
    translate(0,-2*tileSize);
    fill(150);
    strokeWeight(2);
    stroke(150);
    line(32,18.2,53.5,49.8);
    strokeWeight(1);
    stroke(70);
    rect(10,50,44,63);
    strokeCap(SQUARE);
    arc(54,51,88,80,PI,(4*PI)/3);
    arc(10,51,88,80,(5*PI)/3,2*PI,OPEN);
    strokeCap(ROUND);
    noStroke();
    fill(80);
    ellipse(32.5,33,10,10);
    fill(120);
    rect(29,31,7,4);
    strokeWeight(1);
    stroke(0);
    line(32.5,32,32.5,26);
    noStroke();
    fill(120);
    beginShape();
    vertex(17,40);
    vertex(47,40);
    vertex(49,60);
    vertex(15,60);
    vertex(17,40);
    endShape();
    rect(15,60,34,30);
    fill(0,0,50);
    rect(19,44,26,4);
    rect(18,52,2,4);
    rect(17,60,2,4);
    rect(17,68,2,4);
    rect(44,52,2,4);
    rect(45,60,2,4);
    rect(45,68,2,4);
    noStroke();
    fill(150);
    triangle(30.5,60,34.5,60,32.5,85);
    fill(180);
    ellipse(32.5,68,6,6);
    stroke(180);
    strokeCap(ROUND);
    strokeWeight(2);
    line(29.5,82,35.5,82);
    noStroke();
    fill(90);
    rect(18,93,8,20);
    rect(38,93,8,20);
    fill(120);
    ellipse(22,111,8,11);
    ellipse(42,111,8,11);
  popMatrix();
}

void patrolSprite(int xTile, int yTile, int dir){
   pushMatrix();
    translate(gameBoard.playerTiles[xTile][yTile].x, gameBoard.playerTiles[xTile][yTile].y);
    if(dir == 0){//north
      pushMatrix();
      rotate(-HALF_PI);
      translate(-tileSize,0);
      //ship drawing here
      patrolSprite();
      popMatrix();
    }else if(dir == 1){//east
      pushMatrix();
      //ship code here
      patrolSprite();
      popMatrix();
    }else if(dir == 2){//south
      pushMatrix();
      rotate(HALF_PI);
      translate(0,-tileSize);
      //ship drawing here
      patrolSprite();
      popMatrix();
    }else{//west
      pushMatrix();
      rotate(PI);
      translate(-tileSize,-tileSize);
      //ship drawing here
      patrolSprite();
      popMatrix();
    }
    popMatrix();
}

void patrolSunkSprite(){
  
}

void planeSprite(){
  noStroke();
  fill(80,108,64);
  arc(25,18,50,6,PI,2*PI);
  arc(25,18,50,16,0,PI);
  beginShape();
    vertex(18,25);
    vertex(21,27);
    vertex(23,30);
    vertex(27,30);
    vertex(29,27);
    vertex(32,25);
    vertex(18,25);
  endShape();
  arc(25,46,16,8,PI,2*PI);
  arc(25,46,16,4,0,PI*.42);
  arc(25,46,16,4,PI*.58,PI);
  fill(111,76,1);
  rect(22,6,6,2);
  rect(21.5,9,7,2);
  rect(21,12,8,2);
  fill(96,131,77);
  beginShape();
    vertex(25,50);
    vertex(26,45);
    vertex(27,38);
    vertex(28,25);
    vertex(28,16);
    vertex(27,5);
    vertex(23,5);
    vertex(22,16);
    vertex(22,25);
    vertex(23,38);
    vertex(24,45);
    vertex(25,50);
  endShape();
  fill(40);
  arc(27,5,8,11.5,PI,(4*PI)/3);
  arc(23,5,8,11.5,(5*PI)/3,2*PI);
  ellipse(25,3,12,1);
  fill(183,206,206);
  ellipse(25,23,4,6);
  fill(0,0,255);
  ellipse(8,19,5,5);
  ellipse(42,19,5,5);
  fill(255,0,0);
  ellipse(8,19,2,2);
  ellipse(42,19,2,2);
}

void planeSprite(int alpha){//enemy plane
  noStroke();
  fill(80, alpha);
  ellipse(0, 0, 20, 50);
  fill(164, 45, 27, alpha);
  ellipse(0, -10, 50, 10);
}

void decoySprite(){
  pushMatrix();
    rotate(PI);
    translate(0,-tileSize);
    strokeCap(SQUARE);
    fill(255,125,0);
    stroke(255);
    strokeWeight(6);
    arc(32,32,61,61,0,PI/2);
    arc(32,32,61,61,PI,(3*PI)/2);
    fill(255);
    stroke(255,125,0);
    arc(32,32,61,61,PI/2,PI);
    arc(32,32,61,61,(3*PI)/2,2*PI);
    strokeCap(ROUND);
    strokeWeight(4);
    fill(255,255,0);
    stroke(225,225,0);
    ellipse(32,32,20,20);
    stroke(230,0,0);
    line(16,16,48,16);
    line(48,16,48,48);
    line(48,48,16,48);
    line(16,48,16,16);
    line(16,16,48,48);
    line(16,48,48,16);
   popMatrix();
}
