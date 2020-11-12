class Ship{
  
  //ship parent class
  //placed in by player when setting ship locations
  
  int size;//length of ship in tiles
  int dir;// 0=north, 1=east, 2=south, 3=west
  int x;//origin tile grid x location(tile letter)
  int y;//origin tile grid y location(tile number);
  int tileSize = width/25;//size of a game tile
  int dropDownItems = 0;
  String name;//name of the ship type
  Boolean sunk = false;//if the ship is fully sunk or not
  Boolean enemy;//if the ship is an enemy ship
  Boolean[] hit;//the tiles, 0=origin tile, that have been hit
  Boolean invis = false;
  Boolean dropDownOpen=false;
  Boolean invulnerable = false;
  Boolean playerFound = false;
  Boolean enemyFound = false;
  LogicTile[] myTiles;//array copying logic tiles from the main board array to manipulaate them from ship class
  Hit[] fires;
  
  Ship(int size,int dir,String name, Boolean enemy, int x, int y){
    this.size=size;
    this.dir=dir;
    this.name=name;
    this.enemy=enemy;
    this.x=x;
    this.y=y;
    if(enemy) invis = true;
    hit = new Boolean[size];//creating hit array as the tile length of the ship
    fires = new Hit[size];
    
    
    myTiles = new LogicTile[size];
    for(int s = 0; s<size; s++){
      if(dir==0){
        if(!enemy)myTiles[s]=gameBoard.playerLogic[x][y-s];//putting logic tiles from the main grid into an array for the ship to track which tiles it has
        if(enemy)myTiles[s]=gameBoard.enemyLogic[x][y-s];
      }else if(dir==1){
        if(!enemy)myTiles[s]=gameBoard.playerLogic[x+s][y];
        if(enemy)myTiles[s]=gameBoard.enemyLogic[x+s][y];
      }else if(dir==2){
        if(!enemy)myTiles[s]=gameBoard.playerLogic[x][y+s];
        if(enemy)myTiles[s]=gameBoard.enemyLogic[x][y+s];
      }else{
        if(!enemy)myTiles[s]=gameBoard.playerLogic[x-s][y];
        if(enemy)myTiles[s]=gameBoard.enemyLogic[x-s][y];
      }
      myTiles[s].hasShip=true;
      myTiles[s].shipName=name;
      myTiles[s].shipAt=this;
    }
    
    for(int s=0;s<size;s++){
      hit[s]=false;
      fires[s]=new Hit(getTileCornerAbsX(s),getTileCornerAbsY(s));
      animations.add(fires[s]);
    }
    
  }
  
  void drawShip(){//visual drawing of the ship
    pushMatrix();
    translate(getTileCornerAbsX(0),getTileCornerAbsY(0));
    if(dir == 0){//north
      pushMatrix();
      rotate(PI);
      translate(0,-tileSize);
      //ship drawing here
      shipDraw();
      popMatrix();
    }else if(dir == 1){//east
      pushMatrix();
      rotate(-PI/2);
      translate(0,0);
      //ship code here
      shipDraw();
      popMatrix();
    }else if(dir == 2){//south
      pushMatrix();
      //rotate(PI);
      translate(tileSize,0);
      //ship drawing here
      shipDraw();
      popMatrix();
    }else{//west
      pushMatrix();
      rotate(HALF_PI);
      translate(tileSize,-tileSize);
      //ship drawing here
      shipDraw();
      popMatrix();
      checkSunk();
    }
    popMatrix();
  }
  
  void shipDraw(){
    if(!invis){
      if(name=="Aircraft Carrier")carrierSprite();
      if(name=="Battle Ship")battleSprite();
      if(name=="Destroyer")destroySprite();
      if(name=="Submarine")subSprite();
      if(name=="Patrol Boat")patrolSprite();
      for(int h=0; h<size; h++){
        if(hit[h] && !sunk){
          fires[h].hide=false;
        }else{
          fires[h].hide=true;
        }
      }
      ellipseMode(CENTER);
    }
  }
  
  void checkSunk(){
    for(int p=0; p<size; p++){
      if(!hit[p]){
        sunk=false;
        return;
      }
    }
    sunk=true;
  }
  
  void sink(){
    for(int s=0; s<size; s++){
      hit(s);
      if(enemy){
        
      }else{
        LogicTile tile=gameBoard.playerLogic[myTiles[s].x][myTiles[s].y];
        gameBoard.enemyHits.add(tile);
        tile.miss=false;
        tile.hit=true;
      }
    }
    checkSunk();
  }
  
  void hit(int part){//method for ship getting hit
    hit[part]=true;
    if(isSunk())sunk = true;
    if(sunk)invis = false;
  }
  
  void hit(LogicTile tile){
    hit(getPartFromTile(tile));
    animations.add( new Boom(tile));
  }
  
  Boolean mouseOnMe(){
    if(mouseOnPlayerBoard){
      for(int t=0; t<size; t++){
        if(myTiles[t].x==mouseBoardX && myTiles[t].y==mouseBoardY){
          //println(myTiles[t].x + " " + myTiles[t].y + " " + t + " " + name);
          if(!dropDownOpen)hoverPart=t;
          return true;
        }
      }
    }
    if(dropDownOpen){
      if(mouseX>=getTileCornerAbsX(hoverPart)+tileSize && mouseX<getTileCornerAbsX(hoverPart)+tileSize+150 && mouseY>=getTileCornerAbsY(hoverPart) && mouseY<getTileCornerAbsY(hoverPart)+50*dropDownItems)return true;
    }
    return false;
  }
  
  void openDropDown(int part){
    println(name+" Clicked");
  }
  
  void repair(int part){ //needs to be reworked to allow enemy use and so the point still "looks" like a hit
    hit[part]=false;
    LogicTile spot = myTiles[part];
    if(!enemy){
      for(int h=0; h<gameBoard.enemyHits.size(); h++){
        if(gameBoard.enemyHits.get(h)==spot){
          gameBoard.enemyHits.remove(spot);
          break;
        }
      }
      gameBoard.enemyMisses.add(spot);
      spot.hit=false;
      spot.miss=true;
      playerTurn=false;
    }else{
      for(int h=0; h<gameBoard.playerHits.size(); h++){
        if(gameBoard.playerHits.get(h)==spot){
          gameBoard.playerHits.remove(spot);
          break;
        }
      }
      gameBoard.playerMisses.add(spot);
      spot.hit=false;
      spot.miss=true;
      playerTurn=true;
    }
  }
  
  Boolean isSunk(){
    for(int p=0; p<size; p++){
      if(!hit[p])return false;
    }
    return true;
  }
  
  int getPartFromTile(LogicTile tile){
    for(int p=0; p<size; p++){
      if(myTiles[p]==tile)return p;
    }
    return 0;
  }
  
  Boolean getPartHitFromTile(LogicTile tile){
    int part = getPartFromTile(tile);
    if(part<0)return false;
    if(hit[part]!=null)return hit[part];
    return false;
  }
  
  int getTileCornerAbsX(int tile){//function for the screen location of the top left corner of this ships tile itterated from origin=0
    int spot = myTiles[tile].x; //find column of the tile
    if(!enemy){
     return gameBoard.playerTiles[spot][0].x;//find screen x value for that column
    }else{
      return gameBoard.enemyTiles[spot][0].x;
    }
  }
  
  int getTileCornerAbsY(int tile){
    int spot = myTiles[tile].y;//find row of the tile
    if(!enemy){
     return gameBoard.playerTiles[0][spot].y;//find screen y value for that row
    }else{
      return gameBoard.enemyTiles[0][spot].y;
    }
  }
  
  int getTileCenterAbsX(int tile){//function for the screen location of the center of this ships tile itterated from origin=0
    int spot = myTiles[tile].x;
    if(!enemy){
     return gameBoard.playerTiles[spot][0].x+(tileSize/2);
    }else{
      return gameBoard.enemyTiles[spot][0].x+(tileSize/2);
    }
  }
  
  int getTileCenterRelX(int tile){
    int spot = myTiles[tile].x;
    if(!enemy){
     return gameBoard.playerTiles[spot][0].x+(tileSize/2)-getTileCornerAbsX(tile);
    }else{
      return gameBoard.enemyTiles[spot][0].x+(tileSize/2)-getTileCornerAbsX(tile);
    }
  }
  
  int getTileCenterAbsY(int tile){
    int spot = myTiles[tile].y;
    if(!enemy){
     return gameBoard.playerTiles[0][spot].y+(tileSize/2);
    }else{
      return gameBoard.enemyTiles[0][spot].y+(tileSize/2);
    }
  }
  
  int getTileCenterRelY(int tile){
    int spot = myTiles[tile].y;
    if(!enemy){
     return gameBoard.playerTiles[0][spot].y+(tileSize/2)-getTileCornerAbsY(tile);
    }else{
      return gameBoard.enemyTiles[0][spot].y+(tileSize/2)-getTileCornerAbsY(tile);
    }
  }
  
  //overide functions
  
  void preSelectLaunch(int a, int b){};
  
}
