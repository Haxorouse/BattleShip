class Battle extends Ship{
  
  int cooldown = 6;
  int frontY;
  int backY;
  Boolean frontCannonDown = false;
  Boolean backCannonDown = false;
  
  Button fireBroadside;
  Button repair;
  
  Battle(int dir, Boolean enemy, int x, int y){
    super(4, dir, "Battle Ship", enemy, x, y);
    dropDownItems=2;
  }
  
  void broadside(){
    if(dir%2==0){ //if facing north or south
      int topY = (dir==0) ? (myTiles[3].y)-4 : (myTiles[2].y)-4;
      for(int f=0; f<5; f++){
          if((dir==0 && !hit[3]) || (dir==2 && !hit[2]))gameBoard.tryFire(int(random(10)), topY+f, !enemy);
          if((dir==2 && !hit[3]) || (dir==0 && !hit[2]))gameBoard.tryFire(int(random(10)), topY+5+f, !enemy);
      }
    }else if(dir==1 && !hit[3]){
      int y = (myTiles[3].y)-2;
      for(int f=0; f<5; f++){
          gameBoard.tryFire(int(random(10)), y+f, !enemy);
      }
    }
    cooldown=6;
    if(enemy){
      playerTurn=true;
    }else playerTurn=false;
  }
  
  void openDropDown(int part){
    if(cooldown<0)cooldown=0;
    if(playerTurn && !playerStall){
      int X = getTileCornerAbsX(part)+tileSize;
      int Y = getTileCornerAbsY(part);
      if(!hit[hoverPart]){
        fireBroadside = new Button(X, Y, 150, 50, "Fire Broadside");
        dropDownOpen=true;
        noStroke();
        fill(200);
        rect(X, Y, 150, 100);
        fireBroadside.drawButton();
        artilery(X+25, Y+85, 50,false);
        progressBar(X+50, Y+70, 100, 10, 6-cooldown, 6);
        if(fireBroadside.press && cooldown<=0){
          broadside();
          dropDownOpen=false;
        }else if(fireBroadside.press)dropDownOpen=false;
      }else if(!sunk){
        if(hoverPart>=2){dropDownItems=3;}else dropDownItems=2;
        repair = new Button(X, Y, 150, 50, "Repair");
        dropDownOpen=true;
        noStroke();
        fill(200);
        rect(X, Y, 150, 50*dropDownItems);
        repair.drawButton();
        fill(0);
        textSize(50);
        textAlign(CORNER,TOP);
        if(hoverPart==2 || hoverPart==3){
          text(player.inv[0], X+75, Y+50);
          text(player.inv[2], X+75, Y+100);
          generalSpareParts(X, Y+50, 50);
          artilery(X+25, Y+135, 50,false);
          if(repair.press && player.inv[0]>0 && player.inv[2]>0){
            repair(hoverPart);
            player.inv[0]--;
            player.inv[2]--;
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
