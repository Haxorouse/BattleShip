class Board{
  
  Tile[][] playerTiles = new Tile[10][10];
  Tile[][] enemyTiles = new Tile[10][10];
  LogicTile[][] playerLogic = new LogicTile[10][10];
  LogicTile[][] enemyLogic = new LogicTile[10][10];
  Wavelet[] waves = new Wavelet[60];
  int size = width/25;
  String[] alpha = {"A","B","C","D","E","F","G","H","I","J"};
  ArrayList<LogicTile> playerHits = new ArrayList<LogicTile>();
  ArrayList<LogicTile> enemyHits = new ArrayList<LogicTile>();
  ArrayList<LogicTile> playerMisses = new ArrayList<LogicTile>();
  ArrayList<LogicTile> enemyMisses = new ArrayList<LogicTile>();
  
  int lastHit = 0;
  
  Boolean updatedPlayer = false;
  Boolean updatedEnemy = false;
  
  Board(){
    for(int r = 0; r<10; r++){
      for(int c = 0;c<10; c++){
        playerTiles[r][c]=new Tile(size*(r+1),size*(c+1));
        enemyTiles[r][c]=new Tile((width-11*size)+size*(r),size*(c+1));
        playerLogic[r][c] = new LogicTile(r,c,false);
        enemyLogic[r][c] = new LogicTile(r,c,true);
      }
    }
    for(int w = 0; w<60; w++){
      waves[w]=new Wavelet();
    }
  }
  
  void drawBoard(){
    locateMouse();
    background(33,40,85);
    for(int w = 0; w<60; w++){
      waves[w].drawWave();
    }
    carrier.drawButton();
    battle.drawButton();
    destroy.drawButton();
    sub.drawButton();
    patrol.drawButton();
    for(int r = 0; r<10; r++){
      textAlign(CENTER,CENTER);
      textSize(12);
      fill(255);
      text(r+1,size*(r+1)+size/2,size/2);
      text(alpha[r],size/2,size*(r+1)+size/2);
      text(r+1,(width-11*size)+size*(r)+size/2,size/2);
      text(alpha[r],(width-12*size)+size/2,size*(r+1)+size/2);
      for(int c = 0;c<10; c++){
        playerTiles[r][c].drawButton();
        if(playerLogic[r][c].hit)playerTiles[r][c].highlightTile(255,color(255,0,0));
        if(playerLogic[r][c].miss)playerTiles[r][c].highlightTile(150,color(255));
        enemyTiles[r][c].drawButton();
        if(enemyLogic[r][c].hit)enemyTiles[r][c].highlightTile(255,color(255,0,0));
        if(enemyLogic[r][c].miss)enemyTiles[r][c].highlightTile(150,color(255));
        if(!gameOn){
          enemyLogic[r][c].checkIfHasShip();
          playerLogic[r][c].checkIfHasShip();
        }
      }
    }
    if(placing)placeShip();
    for(int s=0; s<playerShips.size();s++){
      playerShips.get(s).drawShip();
    }
    for(int t=0; t<playerShips.size();t++){
      if(playerShips.get(t).dropDownOpen){
        playerShips.get(t).openDropDown(hoverPart);
      }
    }
    for(int e=0; e<enemyShips.size();e++){
      enemyShips.get(e).drawShip();
    }
    for(int a=0; a<animations.size(); a++){
      animations.get(a).run();
    }
    for(int p=0; p<player.squadron.size(); p++){
      player.squadron.get(p).drawPlane();
      player.squadron.get(p).update();
    }
    for(int i=0; i<enemy.squadron.size(); i++){
      enemy.squadron.get(i).drawPlane();
      enemy.squadron.get(i).update();
    }
    checkWin();
    if(playerWon || enemyWon){
      gameOn=false;
      fill(255);
      textSize(200);
      textAlign(CENTER, CENTER);
      if(playerWon){
        text("YOU WIN", width/2, height/2);
      }else text("YOU LOSE", width/2, height/2);
    }
    if(gameOn)onTurn();
    for(int s=player.scans.size()-1; s>-1; s--){
      if(!player.scans.get(s).hasShip){
        playerMisses.add(player.scans.get(s));
        player.scans.get(s).miss=true;
        player.scans.remove(player.scans.get(s));
        break;
      }
      if(player.scans.get(s).hit){
        player.scans.remove(player.scans.get(s));
        break;
      }
      Tile tile = enemyTiles[player.scans.get(s).x][player.scans.get(s).y];
      tile.highlightTile(50,color(0,255,0));
    }
    for(int s=enemy.scans.size()-1; s>-1; s--){
      if(!enemy.scans.get(s).hasShip){
        enemyMisses.add(enemy.scans.get(s));
        enemy.scans.get(s).miss=true;
        enemy.scans.remove(enemy.scans.get(s));
        break;
      }
      if(enemy.scans.get(s).hit){
        enemy.scans.remove(enemy.scans.get(s));
        break;
      }
      Tile tile = playerTiles[enemy.scans.get(s).x][enemy.scans.get(s).y];
      tile.highlightTile(50,color(0,255,0));
    }
    if(shopOpen)drawShop();
  }
  
  void drawShop(){
    int howMuchFuel;
    howMuchFuel=50-player.carrier.fuel;
    if(howMuchFuel>playerCredits)howMuchFuel=playerCredits;
    noStroke();
    fill(200);
    rect(100,100,1400,700);
    credit(300,125,50);
    fill(0);
    textAlign(CORNER,CENTER);
    text(playerCredits,375,150);
    btnExitShop.drawButton();
    btnBuyGeneral.drawButton();
    credit(150,200,50);
    fill(0);
    text(10,225,225);
    generalSpareParts(510,200,50);
    btnBuyRunway.drawButton();
    credit(150,260,50);
    fill(0);
    text(15,225,285);
    runway(510,260,50);
    btnBuyArtillery.drawButton();
    credit(150,320,50);
    fill(0);
    text(20,225,345);
    artilery(510,320,50);
    btnBuyRailgun.drawButton();
    credit(150,380,50);
    fill(0);
    text(20,225,405);
    railGun(510,380,50);
    btnBuyComms.drawButton();
    credit(150,440,50);
    fill(0);
    text(30,225,465);
    commsArray(510,440,50);
    btnBuySonar.drawButton();
    credit(150,500,50);
    fill(0);
    text(30,225,525);
    sonar(510,500,50);
    btnBuyMotor.drawButton();
    credit(150,560,50);
    fill(0);
    text(30,225,585);
    motor(510,560,50);
    btnBuyPlane.drawButton();
    credit(150,620,50);
    fill(0);
    text(20,225,645);
    planes(510,620,50);
    btnBuyFuel.drawButton();
    credit(150,680,50);
    fill(0);
    text(howMuchFuel,225,705);
    text("x"+howMuchFuel,600,705);
    fuel(510,680,50);
    btnBuyDecoy.drawButton();
    credit(150,740,50);
    fill(0);
    text(10,225,765);
    decoy(510,740,50);
  }
  
  void placeShip(){//displays ghost ship on selected location if location is valid and allows ship to be placed on click
    placeHold=null;
    if(mouseOnPlayerBoard && validSpot()){
      placeHold.drawShip();
      playerTiles[mouseBoardX][mouseBoardY].highlightTile(50, color(0,255,0));
      place=true;
      return;
    }else if(mouseOnPlayerBoard){
      playerTiles[mouseBoardX][mouseBoardY].highlightTile(50, color(255,0,0));
      place=false;
      return;
    }
    place = false;
  }
  
  Boolean inBounds(){//check to see if the mouse is on a valid location for the selcted ship
    if(mouseOnPlayerBoard){
      if(placeDirection==0){//north
        if(placerSize<=mouseBoardY+1)return true;
      }else if(placeDirection==1){//east
        if(placerSize<=10-(mouseBoardX))return true;
      }else if(placeDirection==2){//south
        if(placerSize<=10-(mouseBoardY))return true;
      }else{//west
        if(placerSize<=mouseBoardX+1)return true;
      }
    }
    return false;
  }
  
  Boolean validSpot(){
    if(inBounds()){
      placeHold=new GhostShip(placerSize, placeDirection, placerName);
      for(int s=0; s<placerSize; s++){
        LogicTile tile = placeHold.myTiles[s];
        for(int x=0; x<playerShips.size(); x++){
          for(int y=0; y<playerShips.get(x).size;y++){
            if(tile==playerShips.get(x).myTiles[y])return false;
          }
        }
      }
      return true;
    }
    return false;
  }
  
  void tryFire(int x, int y, Boolean player){
    if(x<10 && y<10 && x>=0 && y>=0){ 
      if(player){
        LogicTile shot = enemyLogic[x][y];
        if(!validShot(shot)){
          println("not there");//replace later with visual equivalent
          return;
        }
        playerTurn=false;
        if(hit(shot, true) && (shot.hasShip && !shot.shipAt.invulnerable)){
          for(int t=0; t<playerMisses.size();t++){
            if(playerMisses.get(t)==shot)playerMisses.remove(shot);
          }
          enemyShips.get(lastHit).hit(shot);
          playerHits.add(shot);
          thePlayer.thinkHit.add(shot);
          enemyShips.get(lastHit).playerFound=true;
          shot.miss=false;
          shot.hit=true;
          return;
        }else{
          animations.add(new Splash(shot));
          playerMisses.add(shot);
          shot.miss=true;
        }
      }else{
        LogicTile shot = playerLogic[x][y];
        if(!validShot(shot)){
          return;
        }
        if(hit(shot, false)){
          for(int t=0; t<enemyMisses.size();t++){
            if(enemyMisses.get(t)==shot)enemyMisses.remove(shot);
          }
          for(int m=0; m<enemy.thinkMiss.size(); m++){
            if(enemy.thinkMiss.get(m)==shot)enemy.thinkMiss.remove(shot);
          }
          Boolean found = false;
          for(int s=0; s<enemy.seenStatus.size(); s++){
            if(enemy.seenStatus.get(s)==shot)found=true;
          }
          if(!found)enemy.seenStatus.add(shot);
          playerShips.get(lastHit).hit(shot);
          enemyHits.add(shot);
          enemy.thinkHit.add(shot);
          playerShips.get(lastHit).enemyFound=true;
          //println("hit");
          shot.miss=false;
          shot.hit=true;
          return;
        }else{
          Boolean found = false;
          for(int s=0; s<enemy.seenStatus.size(); s++){
            if(enemy.seenStatus.get(s)==shot)found=true;
          }
          for(int m=0; m<enemy.thinkHit.size(); m++){
            if(enemy.thinkHit.get(m)==shot)enemy.thinkHit.remove(shot);
          }
          if(!found)enemy.seenStatus.add(shot);
          animations.add(new Splash(shot));
          //println("miss");
          enemyMisses.add(shot);
          enemy.thinkMiss.add(shot);
          shot.miss=true;
        }
      }
    }
  }
  
  void onTurn(){
    if(playerTurn && !updatedPlayer){
      println("----------------------");
      updatedPlayer=true;
      updatedEnemy=false;
      enemyStall=false;
      enemy.wait=60;
      for(int p=0; p<player.squadron.size(); p++){
        player.squadron.get(p).fuel--;
      }
      playerCredits+=5;
      player.battle.cooldown--;
      player.destroyer.cooldown--;
      if(!player.sub.submerged && player.sub.power<4) player.sub.power++;
      if(player.sub.submerged) player.sub.power--;
      if(player.sub.power<0) player.sub.sink();
      for(int r=0; r<10; r++){
        for(int c=0; c<10; c++){
          enemyLogic[r][c].checkIfHasShip();
          playerLogic[r][c].checkIfHasShip();
          playerTiles[r][c].lines = color(0,150,0);
          playerTiles[r][c].thickness=2;
          enemyTiles[r][c].lines = color(0);
          enemyTiles[r][c].thickness=1;
        }
      }
    }else if(!playerTurn && !updatedEnemy){
      updatedEnemy=true;
      updatedPlayer=false;
      playerStall=false;
      for(int p=0; p<enemy.squadron.size(); p++){
        enemy.squadron.get(p).fuel--;
      }
      enemyCredits+=5;
      enemy.battle.cooldown--;
      enemy.destroyer.cooldown--;
      if(!enemy.sub.submerged && enemy.sub.power<4) enemy.sub.power++;
      if(enemy.sub.submerged) enemy.sub.power--;
      if(enemy.sub.power<0) enemy.sub.sink();
      for(int r=0; r<10; r++){
        for(int c=0; c<10; c++){
          enemyLogic[r][c].checkIfHasShip();
          playerLogic[r][c].checkIfHasShip();
          playerTiles[r][c].lines = color(0);
          playerTiles[r][c].thickness=1;
          enemyTiles[r][c].lines = color(0,150,0);
          enemyTiles[r][c].thickness=2;
        }
      }
    }
  }
  
  Boolean hit(LogicTile shot, Boolean player){
    for(int s=0; s<5; s++){
      if(!player){
        for(int p=0; p<playerShips.get(s).size; p++){
          if(playerShips.get(s).myTiles[p]==shot && !playerShips.get(s).invulnerable){
            lastHit=s;
            return true;
          }
        }
      }else{
        for(int p=0; p<enemyShips.get(s).size ;p++){
          if(enemyShips.get(s).myTiles[p]==shot && !enemyShips.get(s).invulnerable){
            lastHit=s;
            return true;
          }
        }
      }
    }
    return false;
  }
  
  Boolean validShot(LogicTile shot){
    if(shot.hit)return false;
    return true;
  }
  
  void locateMouse(){//find the mouse grid location
    for(int r = 0; r<10; r++){
      for(int c = 0; c<10; c++){
        //player board check
        if(playerTiles[r][c].mouseIsHovering() && !shopOpen){
          mouseOnPlayerBoard=true;
          mouseOnenemyBoard=false;
          mouseBoardX=r;
          mouseBoardY=c;
          return;
        }
        //enemy board check
        if(enemyTiles[r][c].mouseIsHovering() && !shopOpen){
          mouseOnPlayerBoard=false;
          mouseOnenemyBoard=true;
          mouseBoardX=r;
          mouseBoardY=c;
          return;
        }
      }
    }
    mouseOnPlayerBoard=false;
    mouseOnenemyBoard=false;
    mouseBoardX=-1;
    mouseBoardY=-1;
  }
  
  void checkWin(){
    if(gameOn){
      if(player.carrier.sunk && player.battle.sunk && player.destroyer.sunk && player.sub.sunk && player.patrol.sunk)enemyWon=true;
      if(enemy.carrier.sunk && enemy.battle.sunk && enemy.destroyer.sunk && enemy.sub.sunk && enemy.patrol.sunk)playerWon=true;
    }
  }
  
}
