class Enemy{
  
  String[] invRef = {"generalSpareParts", "runway", "artilery", "railGun", "commsArray", "sonar", "motor"};
  int[] inv = {0, 0, 0, 0, 0, 0, 0};
  
  ArrayList<Plane> squadron = new ArrayList<Plane>();
  ArrayList<LogicTile> scans = new ArrayList<LogicTile>();
  
  Battle battle;
  Destroyer destroyer;
  Carrier carrier;
  Sub sub;
  Patrol patrol;
  
  Enemy(){
    
  }
  
  void setupenemy(){
    placeBattle();
    placeDestroy();
    placeCarrier();
    placeSub();
    placePatrol();
  }
  
  void runenemy(){
    if(!playerTurn && !enemyStall){
      int randX=(int)random(10);
      int randY=(int)random(10);
      while(!gameBoard.validShot(gameBoard.playerLogic[randX][randY])){
        randX=(int)random(10);
        randY=(int)random(10);
      }
      /*if(squadron.size()==0 && carrier.planes>0 && !carrier.sunk){
        planeDefend();
      }else if(carrier.planes>0 && !carrier.sunk){
        planeAttack(randX, randY);
      }else {*/
        standardAttack(randX, randY);
      //}
    }
  }
  
  void planeAttack(int Tx, int Ty){
    enemy.squadron.add(new Plane(carrier.getTileCenterAbsX(4), carrier.getTileCenterAbsY(4), carrier.deg, 2, true, Tx, Ty));
    carrier.planes--;
    enemyStall=true;
  }
  
  void planeDefend(){
    enemy.squadron.add(new Plane(carrier.getTileCenterAbsX(4), carrier.getTileCenterAbsY(4), carrier.deg, 1, gameBoard.enemyTiles[5][5].x, gameBoard.enemyTiles[5][5].y, true));
    carrier.planes--;
    enemyStall=true;
  }
  
  void standardAttack(int Tx, int Ty){
    gameBoard.tryFire(Tx, Ty, false);
    playerTurn=true;
  }
  
  void placeBattle(){
    int randDir,randX,randY;
    if(random(1)>.5){
      randDir=0;
      randY=7;
    }else{
      randDir=2;
      randY=2;
    }
    randX=(int)random(10);
    battle = new Battle(randDir, true, randX, randY);
    enemyShips.add(battle);
  }
  
  void placeDestroy(){
    int randDir=0, randX=-1, randY=-1;
    while(!validSpot(3, randDir, randX, randY)){
    if(random(1)>.5){
      randDir=0;
      randY=(int)random(2,10);
    }else{
      randDir=2;
      randY=(int)random(0,8);
    }
    randX=(int)random(10);
    }
    destroyer = new Destroyer(randDir, true, randX, randY);
    enemyShips.add(destroyer);
  }
  
  void placeCarrier(){
    int randDir=0;
    int randX=-1;
    int randY=-1;
    while(!validSpot(5, randDir, randX, randY)){
      randDir=(int)random(0,4);
      randX=(int)random(10);
      randY=(int)random(10);
    }
    carrier = new Carrier(randDir, true, randX, randY);
    enemyShips.add(carrier);
  }
  
  void placeSub(){
    int randDir=0;
    int randX=-1;
    int randY=-1;
    while(!validSpot(3, randDir, randX, randY)){
      randDir=(int)random(0,4);
      randX=(int)random(10);
      randY=(int)random(10);
    }
    sub = new Sub(randDir, true, randX, randY);
    enemyShips.add(sub);
  }
  
  void placePatrol(){
    int randDir=0;
    int randX=-1;
    int randY=-1;
    while(!validSpot(2, randDir, randX, randY)){
      randDir=(int)random(0,4);
      randX=(int)random(10);
      randY=(int)random(10);
    }
    patrol = new Patrol(randDir, true, randX, randY);
    enemyShips.add(patrol);
  }
  
  Boolean inBounds(int placeDirection, int x, int y, int size){//check to see if the mouse is on a valid location for the selcted ship
      if(placeDirection==0){//north
        if(size<=y+1)return true;
      }else if(placeDirection==1){//east
        if(size<=10-(x))return true;
      }else if(placeDirection==2){//south
        if(size<=10-(y))return true;
      }else{//west
        if(size<=x+1)return true;
      }
    return false;
  }
  
  Boolean validSpot(int size, int dir, int x, int y){
    LogicTile tile = gameBoard.enemyLogic[0][0];
    if(inBounds(dir, x, y, size)){
      for(int a = 0; a<size; a++){
        if(dir==0){
          tile=gameBoard.enemyLogic[x][y-a];//putting logic tiles from the main grid into an array for the ship to track which tiles it has
        }else if(dir==1){
          tile=gameBoard.enemyLogic[x+a][y];
        }else if(dir==2){
          tile=gameBoard.enemyLogic[x][y+a];
        }else{
          tile=gameBoard.enemyLogic[x-a][y];
        }
        for(int b=0; b<enemyShips.size(); b++){
          for(int p=0; p<enemyShips.get(b).size; p++){
            if(tile==enemyShips.get(b).myTiles[p])return false;
          }
        }
      }
      return true;
    }
    return false;
  }
  
}
