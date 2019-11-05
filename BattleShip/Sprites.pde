void carrierSprite(){
  
}

void carrierSunkSprite(){
  
}

void battleSprite(){
  
}

void battleSunkSprite(){
  
}

void destroySprite(){
  
}

void destroySunkSprite(){
  
}

void subSprite(){
  fill(150);
  noStroke();
  ellipseMode(CORNER);
  ellipse(0,0,tileSize*3,tileSize);
}

void subUnderSprite(){
  fill(150,150,150,50);
  noStroke();
  ellipseMode(CORNER);
  ellipse(0,0,tileSize*3,tileSize);
}

void subSunkSprite(){
  
}

void patrolSprite(){
  fill(150);
  noStroke();
  ellipseMode(CORNER);
  ellipse(0,0,tileSize*2,tileSize);
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
  fill(80);
  ellipse(0, 0, 20, 50);
  fill(71, 134, 27);
  ellipse(0, -10, 50, 10);
}

void decoySprite(){
  
}
