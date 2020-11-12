class Patrol extends Ship{
  
  int fuel = 30;
  int decoys = 5;
  
  Boolean moving = false;
  Boolean turning = false;
  Boolean dropping = false;
  Boolean selecting = false;
  
  Button turn;
  Button move;
  Button refuel;
  Button dropDecoy;
  Button repair;
  
  ArrayList<LogicTile> adjacent = new ArrayList<LogicTile>();
  
  Patrol(int dir, Boolean enemy, int x, int y){
    super(2,dir,"Patrol Boat", enemy, x, y);
    dropDownItems=6;
    if(enemy){
      for(int t=0; t<myTiles.length; t++){
        if(myTiles[t].x>0)adjacent.add(gameBoard.enemyLogic[myTiles[t].x-1][myTiles[t].y]);
        if(myTiles[t].x<9)adjacent.add(gameBoard.enemyLogic[myTiles[t].x+1][myTiles[t].y]);
        if(myTiles[t].y>0)adjacent.add(gameBoard.enemyLogic[myTiles[t].x][myTiles[t].y-1]);
        if(myTiles[t].y<9)adjacent.add(gameBoard.enemyLogic[myTiles[t].x][myTiles[t].y+1]);
        for(int c=adjacent.size()-1; c>=0; c--){
          if(adjacent.get(c)==myTiles[t])adjacent.remove(c);
        }
      }
    }else{
      for(int t=0; t<myTiles.length; t++){
        if(myTiles[t].x>0)adjacent.add(gameBoard.playerLogic[myTiles[t].x-1][myTiles[t].y]);
        if(myTiles[t].x<9)adjacent.add(gameBoard.playerLogic[myTiles[t].x+1][myTiles[t].y]);
        if(myTiles[t].y>0)adjacent.add(gameBoard.playerLogic[myTiles[t].x][myTiles[t].y-1]);
        if(myTiles[t].y<9)adjacent.add(gameBoard.playerLogic[myTiles[t].x][myTiles[t].y+1]);
        for(int c=adjacent.size()-1; c>=0; c--){
          if(adjacent.get(c)==myTiles[t])adjacent.remove(c);
        }
      }
    }
  }
  
  void turn(int to){
    fuel--;
    if(enemy){
      dir=to;
    }else{
      invis=false;
      dir=to;
    }
    updateTiles();
    playerTurn=enemy;
  }
  
  void move(Boolean vertical, int coord){
    if(enemy){
      if(vertical){
        fuel-=abs(y-coord);
        y=coord;
      }else{
        fuel-=abs(x-coord);
        x=coord;
      }
    }else{
      invis=false;
      if(vertical){
        fuel-=abs(y-coord);
        y=coord;
      }else{
        fuel-=abs(x-coord);
        x=coord;
      }
    }
    updateTiles();
    playerTurn=enemy;
  }
  
  void move(int dist){
    fuel-=abs(dist);
    switch(dir){
      case 0:
        y-=dist;
        break;
      case 1:
        x+=dist;
        break;
      case 2:
        y+=dist;
        break;
      case 3:
        x-=dist;
        break;
    }
    updateTiles();
    playerTurn=true;
  }
  
  void updateTiles(){
    for(int s = 0; s<2; s++){
      if(dir==0){
        if(!enemy)myTiles[s]=gameBoard.playerLogic[x][y-s];
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
    }
    if(enemy){
      for(int t=0; t<myTiles.length; t++){
        if(myTiles[t].x>0)adjacent.add(gameBoard.enemyLogic[myTiles[t].x-1][myTiles[t].y]);
        if(myTiles[t].x<9)adjacent.add(gameBoard.enemyLogic[myTiles[t].x+1][myTiles[t].y]);
        if(myTiles[t].y>0)adjacent.add(gameBoard.enemyLogic[myTiles[t].x][myTiles[t].y-1]);
        if(myTiles[t].y<9)adjacent.add(gameBoard.enemyLogic[myTiles[t].x][myTiles[t].y+1]);
        for(int c=adjacent.size()-1; c>=0; c--){
          if(adjacent.get(c)==myTiles[t])adjacent.remove(c);
        }
      }
    }else{
      for(int t=0; t<myTiles.length; t++){
        if(myTiles[t].x>0)adjacent.add(gameBoard.playerLogic[myTiles[t].x-1][myTiles[t].y]);
        if(myTiles[t].x<9)adjacent.add(gameBoard.playerLogic[myTiles[t].x+1][myTiles[t].y]);
        if(myTiles[t].y>0)adjacent.add(gameBoard.playerLogic[myTiles[t].x][myTiles[t].y-1]);
        if(myTiles[t].y<9)adjacent.add(gameBoard.playerLogic[myTiles[t].x][myTiles[t].y+1]);
        for(int c=adjacent.size()-1; c>=0; c--){
          if(adjacent.get(c)==myTiles[t])adjacent.remove(c);
        }
      }
    }
  }
  
  void dropDecoy(int dropX, int dropY){
    if(enemy){
      enemyShips.add(new Decoy(true, dropX, dropY));
      decoys--;
      playerTurn=enemy;
    }else{
      playerShips.add(new Decoy(false, dropX, dropY));
      decoys--;
      patrolAction=false;
      dropping=false;
      selecting=false;
      playerTurn=enemy;
    }
  }
  
  void refuel(){
    if(enemy){
      while(fuel<30 && theEnemy.carrier.fuel>0){
        fuel++;
        theEnemy.carrier.fuel--;
      }
    }else{
      while(fuel<30 && player.carrier.fuel>0){
        fuel++;
        player.carrier.fuel--;
      }
    }
    playerTurn=enemy;
  }
  
  void selectPlace(){
    patrolAction=true;
    if(moving){
      if(dir%2==0){
        //vertical
        if(mouseOnPlayerBoard && pathUnobstructed(true, y, mouseBoardY) && validSpot(x, mouseBoardY) && fuel>=abs(y-mouseBoardY)){
          patrolSprite(x, mouseBoardY, dir);
          gameBoard.playerTiles[x][mouseBoardY].highlightTile(50, color(0,255,0));
          if(gameBoard.playerTiles[mouseBoardX][mouseBoardY].pressed){
            selecting=false;
            moving=false;
            patrolAction=false;
            move(true, mouseBoardY);
          }
        }else if(mouseOnPlayerBoard){
          gameBoard.playerTiles[x][mouseBoardY].highlightTile(50, color(255,0,0));
        }
      }else{
        //horizontal
        if(mouseOnPlayerBoard && pathUnobstructed(false, x, mouseBoardX) && validSpot(mouseBoardX, y) && fuel>=abs(x-mouseBoardX)){
          patrolSprite(mouseBoardX, y, dir);
          gameBoard.playerTiles[mouseBoardX][y].highlightTile(50, color(0,255,0));
          if(gameBoard.playerTiles[mouseBoardX][mouseBoardY].pressed){
            selecting=false;
            moving=false;
            patrolAction=false;
            move(false, mouseBoardX);
          }
        }else if(mouseOnPlayerBoard){
          gameBoard.playerTiles[mouseBoardX][y].highlightTile(50, color(255,0,0));
        }
      }
    }
    if(turning){
      if(validSpot(x,y,placeDirection) && mouseOnPlayerBoard){
        patrolSprite(x, y, placeDirection);
        gameBoard.playerTiles[x][y].highlightTile(50, color(0,255,0));
        if(gameBoard.playerTiles[mouseBoardX][mouseBoardY].pressed){
          selecting=false;
          turning=false;
          patrolAction=false;
          turn(placeDirection);
        }
      }else{
        gameBoard.playerTiles[x][y].highlightTile(50, color(255,0,0));
      }
    }
    if(dropping){
      for(int d=0; d<adjacent.size(); d++){
        if(mouseOnPlayerBoard && gameBoard.playerLogic[mouseBoardX][mouseBoardY]==adjacent.get(d) && gameBoard.playerTiles[mouseBoardX][mouseBoardY].pressed && !gameBoard.playerLogic[mouseBoardX][mouseBoardY].hasShip){
          dropDecoy(mouseBoardX, mouseBoardY);
          return;
        }
      }
    }
  }
  
  void shipDraw(){
    if(!invis){
      patrolSprite();
      for(int h=0; h<size; h++){
        if(hit[h] && !sunk){
          fires[h].hide=false;
        }else{
          fires[h].hide=true;
        }
      }
      ellipseMode(CENTER);
    }
    if(selecting){
      popMatrix();
      popMatrix();
      selectPlace();
      pushMatrix();
      pushMatrix();
    }
  }
  
  void openDropDown(int part){
    if(playerTurn && !playerStall){
      if(!hit[hoverPart]){
        int X = getTileCornerAbsX(part)+tileSize;
        int Y = getTileCornerAbsY(part);
        turn = new Button(X, Y, 150, 50, "Rotate");
        move = new Button(X, Y+50, 150, 50, "Move");
        refuel = new Button(X, Y+100, 150, 50, "Refuel From Carrier");
        dropDecoy = new Button(X, Y+150, 150, 50, "Drop Decoy");
        dropDownOpen=true;
        noStroke();
        fill(200);
        rect(X, Y, 150, 300);
        turn.drawButton();
        move.drawButton();
        refuel.drawButton();
        dropDecoy.drawButton();
        fuel(X, Y+200, 50);
        decoy(X, Y+250, 50);
        fill(0);
        textSize(50);
        textAlign(CORNER,CORNER);
        text(fuel, X+50, Y+250);
        text(decoys, X+50, Y+300);
        textSize(12);
        if(turn.press && !motorDamaged() && fuel>0){
          invis=true;
          playerStall=true;
          selecting=true;
          turning=true;
          myTiles[0].hasShip=false;
          myTiles[1].hasShip=false;
          dropDownOpen=false;
          placeDirection=dir;
        }else if(turn.press) dropDownOpen=false;
        if(move.press && !motorDamaged() && fuel>0){
          invis=true;
          playerStall=true;
          selecting=true;
          moving=true;
          myTiles[0].hasShip=false;
          myTiles[1].hasShip=false;
          dropDownOpen=false;
        }else if(move.press) dropDownOpen=false;
        if(refuel.press && isNextToCarrier()){
          refuel();
          dropDownOpen=false;
        }else if(refuel.press) dropDownOpen=false;
        if(dropDecoy.press && decoys>0){
          playerStall=true;
          selecting=true;
          dropping=true;
          dropDownOpen=false;
        }else if(dropDecoy.press) dropDownOpen=false;
      }else if(!sunk){
        if(part==0){dropDownItems=3;}else dropDownItems=2;
        repair = new Button(X, Y, 150, 50, "Repair");
        dropDownOpen=true;
        noStroke();
        fill(200);
        rect(X, Y, 150, 50*dropDownItems);
        repair.drawButton();
        fill(0);
        textSize(50);
        textAlign(CORNER,TOP);
        if(part==0){
          text(player.inv[0], X+75, Y+50);
          text(player.inv[6], X+75, Y+100);
          generalSpareParts(X, Y+50, 50);
          motor(X, Y+100, 50);
          if(repair.press && player.inv[0]>0 && player.inv[6]>0){
            player.inv[0]--;
            player.inv[6]--;
            repair(hoverPart);
            dropDownOpen=false;
            playerTurn=false;
          }
        }else{
          text(player.inv[0], X+75, Y+50);
          generalSpareParts(X, Y+50, 50);
          if(repair.press && player.inv[0]>0){
            player.inv[0]--;
            repair(hoverPart);
            dropDownOpen=false;
            playerTurn=false;
          }
        }
      }
      if(!mouseOnMe())dropDownOpen=false;
    }
  }
  
  Boolean isNextToCarrier(){
    if(enemy){
      for(int m=0; m<adjacent.size(); m++){
        for(int a=0; a<theEnemy.carrier.myTiles.length; a++){
          if(adjacent.get(m)==theEnemy.carrier.myTiles[a])return true;
        }
      }
    }else{
      for(int m=0; m<adjacent.size(); m++){
        for(int a=0; a<player.carrier.myTiles.length; a++){
          if(adjacent.get(m)==player.carrier.myTiles[a])return true;
        }
      }
    }
    return false;
  }
  
  Boolean motorDamaged(){
    if(hit[0])return true;
    return false;
  }
  
  Boolean pathUnobstructed(Boolean vertical, float startPos, float endPos){
    int diff = abs(int(endPos-startPos));
    if(vertical){
      for(int c=0; c<diff; c++){
        println();
        if(!enemy && gameBoard.playerLogic[x][y+int(c*((endPos-startPos)/abs(endPos-startPos)))].hasShip)return false;
        if(enemy && gameBoard.enemyLogic[x][y+int(c*((endPos-startPos)/abs(endPos-startPos)))].hasShip)return false;
      }
    }else{
      for(int c=0; c<abs(endPos-startPos); c++){
        if(!enemy && gameBoard.playerLogic[x+int(c*((endPos-startPos)/abs(endPos-startPos)))][y].hasShip)return false;
        if(enemy && gameBoard.enemyLogic[x+int(c*((endPos-startPos)/abs(endPos-startPos)))][y].hasShip)return false;
      }
    }
    return true;
  }
  
  Boolean inBounds(int checkX, int checkY){
    if(dir==0){//north
      if(2<=checkY+1)return true;
    }else if(dir==1){//east
      if(2<=10-(checkX))return true;
    }else if(dir==2){//south
      if(2<=10-(checkY))return true;
    }else{//west
      if(2<=checkX+1)return true;
    }
    return false;
  }
  
  Boolean validSpot(int checkX, int checkY){
    return validSpot(checkX , checkY, dir);
  }
  
  Boolean validSpot(int checkX, int checkY, int dir){
    if(inBounds(checkX, checkY)){
      LogicTile[] tiles = new LogicTile[size];
      for(int s = 0; s<2; s++){
        if(dir==0){
          if(!enemy)tiles[s]=gameBoard.playerLogic[checkX][checkY-s];
          if(enemy)tiles[s]=gameBoard.enemyLogic[checkX][checkY-s];
        }else if(dir==1){
          if(!enemy)tiles[s]=gameBoard.playerLogic[checkX+s][checkY];
          if(enemy)tiles[s]=gameBoard.enemyLogic[checkX+s][checkY];
        }else if(dir==2){
          if(!enemy)tiles[s]=gameBoard.playerLogic[checkX][checkY+s];
          if(enemy)tiles[s]=gameBoard.enemyLogic[checkX][checkY+s];
        }else{
          if(!enemy)tiles[s]=gameBoard.playerLogic[checkX-s][checkY];
          if(enemy)tiles[s]=gameBoard.enemyLogic[checkX-s][checkY];
        }
      }
      for(int s=0; s<2; s++){
        if(tiles[s].hasShip)return false;
      }
      return true;
    }
    return false;
  }
  
}
