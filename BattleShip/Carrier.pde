class Carrier extends Ship{
  
  int planes = 3;
  int distToDamage=5;
  int fuel = 50;
  int deg=0;
  int launchTime = 0;
  int launchTargetX = 0;
  int launchTargetY = 0;
  int squadronSend = -1;
  
  Boolean launching=false;
  Boolean selectingTile = false;
  Boolean choosingPlace = false;
  Boolean chosen = false;
  Boolean currentLaunchAttack = false;
  Boolean animate = false;
  Boolean managing = false;
  
  ArrayList<LogicPlane> squad = new ArrayList<LogicPlane>();
  
  Button launchDefend;
  Button launchKamakazy;
  Button managePlanes;
  Button repair;
  
  ArrayList<LogicTile> adjacent = new ArrayList<LogicTile>();
  
  Carrier(int dir, Boolean enemy, int x, int y){
    super(5, dir, "Aircraft Carrier", enemy, x, y);
    dropDownItems=5;
    deg=90*dir;
    if(enemy){
      for(int t=0; t<myTiles.length; t++){
        if(myTiles[t].x>0)adjacent.add(gameBoard.enemyLogic[myTiles[t].x-1][myTiles[t].y]);
        if(myTiles[t].x<9)adjacent.add(gameBoard.enemyLogic[myTiles[t].x+1][myTiles[t].y]);
        if(myTiles[t].y>0)adjacent.add(gameBoard.enemyLogic[myTiles[t].x][myTiles[t].y-1]);
        if(myTiles[t].y<9)adjacent.add(gameBoard.enemyLogic[myTiles[t].x][myTiles[t].y+1]);
        for(int c=adjacent.size()-1; c>=0; c--){
          if(adjacent.get(c)==myTiles[t]) adjacent.remove(c);
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
  
  void launchPlane(Boolean kamakazy){
    if(kamakazy){
      if(planes>0){
        planes--;
        player.squadron.add(new Plane(getTileCenterAbsX(4), getTileCenterAbsY(4), deg, 2, false, launchTargetX, launchTargetY));
      }
    }else{
      if(planes>0){
        planes--;
        player.squadron.add(new Plane(getTileCenterAbsX(4), getTileCenterAbsY(4), deg, 1, gameBoard.playerTiles[5][5].x, gameBoard.playerTiles[5][5].y, false));
      }
    }
  }
  
  void planeAnimation(){
    //animation
    playerStall=true;
    
    if(currentLaunchAttack){
      //tile selection
      launchPlane(true);
      animate=false;
      carrierAttack=false;
      return;
    }
    launchPlane(false);
    animate=false;
  }
  
  void shipDraw(){
    if(!invis){
      fill(150);
      noStroke();
      ellipseMode(CORNER);
      ellipse(0,0,tileSize*size,tileSize);
      for(int h=0; h<size; h++){
        if(hit[h]){
          fill(100);
          ellipse(tileSize*h,0,tileSize,tileSize); 
        }
      }
      ellipseMode(CENTER);
    }
    if(animate){
      planeAnimation();
    }
    if(choosingPlace){
      chooseTile(squadronSend);
    }
  }
  
  void chooseTile(int member){
    carrierAttack=true;
    if(mouseOnenemyBoard){
      if(gameBoard.enemyTiles[mouseBoardX][mouseBoardY].pressed){
        launchTargetX=mouseBoardX;
        launchTargetY=mouseBoardY;
        choosingPlace=false;
        if(member==-1){
          animate=true;
        }else{
          player.squadron.get(member).defendToAttack(launchTargetX, launchTargetY);
        }
        squadronSend=-1;
      }
    }
  }
  
  /*void preSelectLaunch(int Tx, int Ty){
    launchTargetX=Tx;
    launchTargetY=Ty;
    launchPlane(true);
  }*/
  
  void openDropDown(int part){
    if(playerTurn && !playerStall){
      int X = getTileCornerAbsX(part)+tileSize;
      int Y = getTileCornerAbsY(part);
      if(managing){
        dropDownItems=(player.squadron.size()*3);
        dropDownOpen=true;
        noStroke();
        fill(200);
        rect(X, Y, 150, 50*dropDownItems);
        for(int p=0; p<player.squadron.size(); p++){
          Plane plane = player.squadron.get(p);
          plane.returnHome = new Button(X, Y+(150*p), 150, 50, "Return To Carrier");
          plane.returnHome.drawButton();
          plane.goKamakazy = new Button(X, Y+50+(150*p), 150, 50, "KAMAKAZY");
          plane.goKamakazy.drawButton();
          fuel(X, Y+100+(150*p), 50);
          fill(0);
          textSize(50);
          textAlign(CORNER,CORNER);
          text(plane.fuel, X+50,Y+150+(150*p));
          textSize(12);
          if(plane.returnHome.press){
            playerStall=true;
            plane.returnToCarrier();
            dropDownOpen=false;
          }
          if(plane.goKamakazy.press){
            playerStall=true;
            choosingPlace=true;
            squadronSend=p;
            dropDownOpen=false;
          }
        }
      }else if(!hit[hoverPart]){
        dropDownItems=5;
        launchDefend = new Button(X, Y, 150, 50, "Launch Defender");
        launchKamakazy = new Button(X, Y+50, 150, 50, "Launch Attacker");
        managePlanes = new Button(X, Y+100, 150, 50, "Manage Squadron");
        dropDownOpen=true;
        noStroke();
        fill(200);
        rect(X, Y, 150, 250);
        launchDefend.drawButton();
        launchKamakazy.drawButton();
        managePlanes.drawButton();
        fuel(X, Y+200, 50);
        planes(X, Y+150, 50);
        fill(0);
        textSize(50);
        textAlign(CORNER,CORNER);
        text(fuel, X+50,Y+250);
        text(planes,X+50,Y+200);
        textSize(12);
        if(managePlanes.press){
          managing=true;
        }
        if(launchDefend.press && planes>0){
          playerStall=true;
          animate=true;
          currentLaunchAttack=false;
          dropDownOpen=false;
        }else if(launchDefend.press){
          dropDownOpen=false;
        }
        if(launchKamakazy.press && planes>0){
          playerStall=true;
          choosingPlace=true;
          currentLaunchAttack=true;
          dropDownOpen=false;
        }else if(launchKamakazy.press){
          dropDownOpen=false;
        }
      }else if(!sunk){
        dropDownItems=3;
        repair = new Button(X, Y, 150, 50, "Repair");
        dropDownOpen=true;
        noStroke();
        fill(200);
        rect(X, Y, 150, 150);
        repair.drawButton();
        generalSpareParts(X, Y+50, 50);
        runway(X, Y+100, 50);
        fill(0);
        textSize(50);
        textAlign(CORNER,TOP);
        text(player.inv[0], X+75, Y+50);
        text(player.inv[1], X+75, Y+100);
        if(repair.press && player.inv[0]>0 && player.inv[1]>0){
          player.inv[0]--;
          player.inv[1]--;
          repair(hoverPart);
          dropDownOpen=false;
          playerTurn=false;
        }
      }
      if(!mouseOnMe()){
        dropDownOpen=false;
        if(managing)managing=false;
      }
    }
  }

}
