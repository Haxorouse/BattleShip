class Sub extends Ship{
  
  int power = 4;
  Boolean submerged = false;
  Boolean scaning = false;
  Boolean submerging = false;
  Boolean surfacing = false;
  Boolean damaged = false;
  Boolean sonarDestroyed = false;
  Boolean animate = false;
  Boolean previouslyFound = false;
  int animationCounter = 0;
  
  Button submerge;
  Button surface;
  Button scan;
  Button repair;
  
  Sub(int dir, Boolean enemy, int x, int y){
    super(3,dir,"Submarine",enemy, x, y);
    dropDownItems=4;
  }
  
  void submerge(){
    submerging=false;
    submerged=true;
    playerTurn=enemy;
    invulnerable=true;
    if(damaged)sink();
    playerFound=false;
  }
  
  void surface(){
    surfacing=false;
    submerged=false;
    playerTurn=enemy;
    invulnerable=false;
    if(previouslyFound)playerFound=true;
  }
  
  void scan(){
    scaning=false;
    if(submerged){
      power-=1;
    }else power-=3;
    if(enemy){
      int decoyCount = 0;
      for(int x=0; x<10; x++){
        for(int y=0; y<10; y++){
          if(submerged){
            int rand = (int)random(10);
            if(rand==1)theEnemy.scans.add(gameBoard.enemyLogic[x][y]);
            if(player.sub.submerged){
              if(gameBoard.playerLogic[x][y]==player.sub.myTiles[0])theEnemy.scans.add(player.sub.myTiles[0]);
              if(gameBoard.playerLogic[x][y]==player.sub.myTiles[1])theEnemy.scans.add(player.sub.myTiles[1]);
              if(gameBoard.playerLogic[x][y]==player.sub.myTiles[2])theEnemy.scans.add(player.sub.myTiles[2]);
            }
          }else{
            int rand = (int)random(30);
            if(rand==1)theEnemy.scans.add(gameBoard.playerLogic[x][y]);
          }
           if(gameBoard.playerLogic[x][y].hasShip && gameBoard.playerLogic[x][y].shipName=="Decoy"){
              theEnemy.scans.add(gameBoard.playerLogic[x][y]);
              decoyCount++;
            }
        }
      }
      if(decoyCount>=3){
        for(int t=0; t<myTiles.length; t++){
          player.scans.add(myTiles[t]);
        }
      }
      playerTurn=true;
    }else{
      int decoyCount = 0;
      for(int x=0; x<10; x++){
        for(int y=0; y<10; y++){
          if(submerged){
            int rand = (int)random(10);
            if(rand==1)player.scans.add(gameBoard.enemyLogic[x][y]);
            if(theEnemy.sub.submerged){
              if(gameBoard.enemyLogic[x][y]==theEnemy.sub.myTiles[0])player.scans.add(theEnemy.sub.myTiles[0]);
              if(gameBoard.enemyLogic[x][y]==theEnemy.sub.myTiles[1])player.scans.add(theEnemy.sub.myTiles[1]);
              if(gameBoard.enemyLogic[x][y]==theEnemy.sub.myTiles[2])player.scans.add(theEnemy.sub.myTiles[2]);
              theEnemy.sub.playerFound=true;
            }
          }else{
            int rand = (int)random(30);
            if(rand==1)player.scans.add(gameBoard.enemyLogic[x][y]);
          }
          if(gameBoard.enemyLogic[x][y].hasShip && gameBoard.enemyLogic[x][y].shipName=="Decoy"){
            player.scans.add(gameBoard.enemyLogic[x][y]);
            decoyCount++;
          }
          if(gameBoard.enemyLogic[x][y].hasShip && gameBoard.enemyLogic[x][y].shipName!="Decoy"){
            gameBoard.enemyLogic[x][y].shipAt.playerFound=true;
          }
        }
      }
      if(decoyCount>=3){
        for(int t=0; t<myTiles.length; t++){
          theEnemy.scans.add(myTiles[t]);
        }
      }
      playerTurn=false;
    }
  }
  
  void animate(){
    if(submerging){
      
      if(animationCounter<=0){
        submerge();
        animate=false;
        return;
      }
    }else if(surfacing){
      
      if(animationCounter<=0){
        surface();
        animate=false;
        return;
      }
    }else if(scaning){
      noFill();
      ellipseMode(CENTER);
      strokeWeight(10);
      stroke(0,255,0,50);
      if(!invis)ellipse(getTileCenterRelX(1), getTileCenterRelY(1), 3600-(30*animationCounter), 3600-(30*animationCounter));
      if(animationCounter<=0){
        scan();
        animate=false;
        return;
      }
    }
    animationCounter--;
  }
  
  void shipDraw(){
    if(!invis){
      if(!submerged){
        subSprite();
      }else subUnderSprite();
      for(int h=0; h<size; h++){
        if(hit[h]){
          fill(100);
          ellipse(tileSize*h,0,tileSize,tileSize); 
        }
      }
      ellipseMode(CENTER);
    }
    if(animate)animate();
    for(int t=0; t<3; t++){
      if(hit[t]){
        damaged=true;
        break;
      }
      damaged=false;
    }
    if(playerFound)previouslyFound=true;
  }
  
  void openDropDown(int part){
    if(playerTurn && !playerStall){
      int X = getTileCornerAbsX(part)+tileSize;
      int Y = getTileCornerAbsY(part);
      if(!hit[hoverPart]){
        submerge = new Button(X, Y, 150, 50, "dive Dive DIVE!");
        surface = new Button(X, Y+50, 150, 50, "Surface");
        scan = new Button(X, Y+100, 150, 50, "Sonar Ping");
        dropDownOpen=true;
        noStroke();
        fill(200);
        rect(X, Y, 150, 200);
        submerge.drawButton();
        surface.drawButton();
        scan.drawButton();
        energy(X, Y+150, 50);
        progressBar(X+50, Y+170, 100, 10, power, 4);
        if(submerge.press && !submerged){
          submerging=true;
          animationCounter=60;
          animate=true;
          playerStall=true;
          dropDownOpen=false;
        }
        if(surface.press && submerged){
          animationCounter=60;
          surfacing=true;
          animate=true;
          playerStall=true;
          dropDownOpen=false;
        }
        if(scan.press && power>=2 && !hit[1]){
          scaning=true;
          animationCounter=120;
          dropDownOpen=false;
          animate=true;
          playerStall=true;
        }
      }else if(!sunk){
        if(part==1){dropDownItems=3;} else dropDownItems=2;
        repair = new Button(X, Y, 150, 50, "Repair");
        dropDownOpen=true;
        noStroke();
        fill(200);
        rect(X, Y, 150, 50*dropDownItems);
        repair.drawButton();
        fill(0);
        textSize(50);
        textAlign(CORNER,TOP);
        if(part==1){
          text(player.inv[0], X+75, Y+50);
          text(player.inv[5], X+75, Y+100);
          generalSpareParts(X, Y+50, 50);
          sonar(X, Y+100, 50);
          if(repair.press && player.inv[0]>0 && player.inv[5]>0){
            repair(hoverPart);
            player.inv[0]--;
            player.inv[5]--;
            dropDownOpen=false;
          }
        }else{
         text(player.inv[0], X+75, Y+50);
         generalSpareParts(X, Y+50, 50);
         if(repair.press && player.inv[0]>0){
           repair(hoverPart);
           player.inv[0]--;
           dropDownOpen=false;
         }
        }
      }
      if(!mouseOnMe())dropDownOpen=false;
    }
  }
  
}
