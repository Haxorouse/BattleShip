class Destroyer extends Ship{
  
  int cooldown = 7;
  int supplyCount = 0;
  Boolean choosingLine = false;
  
  Button fireRailGun;
  Button openSupplyShop;
  Button repair;
  
  Destroyer(int dir, Boolean enemy, int x, int y){
    super(3, dir, "Destroyer", enemy, x, y);
    dropDownItems=4;
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
    if(choosingLine){
      popMatrix();
      popMatrix();
      chooseLine();
      pushMatrix();
      pushMatrix();
    }
  }
  
  void fireRailGun(int line){
    for(int p=0; p<10; p++){
      gameBoard.tryFire(p, line, !enemy);
    }
    if(enemy){
      playerTurn=true;
    }else playerTurn=false;
    cooldown=7;
  }
  
  void chooseLine(){
    destroyerAttack=true;
    if(((dir==0 && mouseBoardY<=y && mouseBoardY>=y-2) || (dir==2 && mouseBoardY>=y && mouseBoardY<=y+2)) && !getPartHitFromTile(gameBoard.playerLogic[x][mouseBoardY])){
      if(mouseOnenemyBoard){
        for(int t=0; t<10; t++){
          Tile tile = gameBoard.enemyTiles[t][mouseBoardY];
          tile.highlightTile(55);
        }
        if(gameBoard.enemyTiles[mouseBoardX][mouseBoardY].pressed){
          fireRailGun(mouseBoardY);
          choosingLine=false;
          destroyerAttack=false;
        }
      }
    }
  }
  
  void openDropDown(int part){
    if(cooldown<0)cooldown=0;
    int X = getTileCornerAbsX(part)+tileSize;
    int Y = getTileCornerAbsY(part);
    if(playerTurn && !playerStall){
      if(!hit[hoverPart]){
        fireRailGun = new Button(X, Y, 150, 50, "Fire Railgun");
        openSupplyShop = new Button(X, Y+50, 150, 50, "Resuply");
        dropDownOpen=true;
        noStroke();
        fill(200);
        rect(X, Y, 150, 200);
        fireRailGun.drawButton();
        openSupplyShop.drawButton();
        railGun(X, Y+100, 50);
        progressBar(X+50, Y+120, 100, 10, 7-cooldown, 7);
        credit(X, Y+150, 50);
        fill(0);
        textSize(50);
        textAlign(CORNER,CORNER);
        text(playerCredits, X+50, Y+200);
        textSize(12);
        if(fireRailGun.press&& dir%2==0 && cooldown<=0){
          playerStall=true;
          choosingLine=true;
          dropDownOpen=false;
        }else if(fireRailGun.press){
          dropDownOpen=false;
        }
        if(openSupplyShop.press){
          playerStall=true;
          shopOpen=true;
          dropDownOpen=false;
        }
      }else if(!sunk){
        if(part==1){dropDownItems=4;}else dropDownItems=3;
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
          text(player.inv[3], X+75, Y+100);
          text(player.inv[4], X+75, Y+150);
          generalSpareParts(X, Y+50, 50);
          railGun(X, Y+100, 50);
          commsArray(X, Y+150, 50);
          if(repair.press && player.inv[0]>0 && player.inv[3]>0 && player.inv[4]>0){
            player.inv[0]--;
            player.inv[3]--;
            player.inv[4]--;
            repair(hoverPart);
            dropDownOpen=false;
            playerTurn=false;
          }
        }else{
          text(player.inv[0], X+75, Y+50);
          text(player.inv[3], X+75, Y+100);
          generalSpareParts(X, Y+50, 50);
          railGun(X, Y+100, 50);
          if(repair.press && player.inv[0]>0 && player.inv[3]>0){
            player.inv[0]--;
            player.inv[3]--;
            repair(hoverPart);
            dropDownOpen=false;
            playerTurn=false;
          }
        }
      }
      if(!mouseOnMe())dropDownOpen=false;
    }else if(playerTurn && destroyerAttack){
      choosingLine=false;
      destroyerAttack=false;
      playerStall=false;
    }
  }
  
}
