import java.lang.reflect.*;

class Enemy{
  
  //{"generalSpareParts $10", "runway $15", "artilery $20", "railGun $20", "commsArray $30", "sonar $30", "motor $30"}
  int[] inv = {0, 0, 0, 0, 0, 0, 0};
  
  ArrayList<Plane> squadron = new ArrayList<Plane>();
  ArrayList<LogicTile> scans = new ArrayList<LogicTile>();
  ArrayList<LogicTile> seenStatus = new ArrayList<LogicTile>();
  ArrayList<LogicTile> thinkHit = new ArrayList<LogicTile>();
  ArrayList<LogicTile> thinkMiss = new ArrayList<LogicTile>();
  
  Battle battle;
  Destroyer destroyer;
  Carrier carrier;
  Sub sub;
  Patrol patrol;
  
  float subP, sinkP, foundP, crashP,checkP;
  
  ArrayList<OutPut> nextTurns = new ArrayList<OutPut>();
  
  Method defend;
  Method buy;
  Method fix;
  
  Enemy(){
    
  }
  
  void setupenemy() throws NoSuchMethodException{
    placeBattle();
    placeDestroy();
    placeCarrier();
    placeSub();
    placePatrol();
    defend=Enemy.class.getDeclaredMethod("planeDefend",null);
    buy=Enemy.class.getDeclaredMethod("buy", int.class);
    fix=Enemy.class.getDeclaredMethod("repair", Ship.class, int.class);
  }
  
  void runenemy() throws IllegalAccessException, InvocationTargetException{
    //OutPut out = new OutPut(-1, defend);
    if(!playerTurn && !enemyStall){
      //out.go();
      if(nextTurns.size()>0){
        
      }
      if(canWinRightNow()){//can win on this turn
        println("1");
        return;
      }else if(!haveSpareComms() && enemyCredits>=30 && !destroyer.hit[1]){//don't have spare comms
        println("2");
        inv[4]++;
        enemyCredits-=30;
        playerTurn=true;
        return;
      }else if(subOutOfPower()!=0){
        println("3");
        return;
      }else if(checkDefender()){
        println("4");
        return;
      }
    }
  }
  
 void outputPriorities(){
   //checks priopritys and runs listed methods when called mid stack
 }
 
  void planeAttack(int Tx, int Ty){
    enemy.squadron.add(new Plane(carrier.getTileCenterAbsX(4), carrier.getTileCenterAbsY(4), carrier.deg, 2, true, Tx, Ty, carrier.squad.get(carrier.choosePlane(true))));
    carrier.planes--;
    enemyStall=true;
  }
  
  void planeDefend(){
    enemy.squadron.add(new Plane(carrier.getTileCenterAbsX(4), carrier.getTileCenterAbsY(4), carrier.deg, 1, gameBoard.enemyTiles[5][5].x, gameBoard.enemyTiles[5][5].y, true, carrier.squad.get(carrier.choosePlane(false))));
    carrier.planes--;
    enemyStall=true;
  }
  
  
  
  
  void landPlane(){
    
  }
  
  int planeNeedsToLand(){
    for(int s=0; s<squadron.size(); s++){
      if(squadron.get(s).fuel==0)return s;
    }
    return -1;
  }
  
  //broadSide handled for enemy from battle ship
  //rail gun hanndle for enemy from destroyer
  int railGunShootLine(){//rework to try and hit enemy if possible
    int lineOne=destroyer.myTiles[0].y;
    int lineTwo=destroyer.myTiles[1].y;
    int lineThree=destroyer.myTiles[2].y;
    int missOne=0;
    int missTwo=0;
    int missThree=0;
    for(int r=0; r<10; r++){
      for(int s=0; s<seenStatus.size(); s++){
        if(gameBoard.playerLogic[lineOne][r]==seenStatus.get(s))missOne++;
        if(gameBoard.playerLogic[lineTwo][r]==seenStatus.get(s))missTwo++;
        if(gameBoard.playerLogic[lineThree][r]==seenStatus.get(s))missThree++;
      }
    }
    if(missOne+missTwo+missThree<30){
      if(missOne<=missTwo && missOne<=missThree)return lineOne;
      if(missTwo<=missThree)return lineTwo;
      return lineThree;
    }
    return -1;
  }
  
  void buy(int item){
    int howMuchFuel;
    howMuchFuel=50-enemy.carrier.fuel;
    if(howMuchFuel>enemyCredits)howMuchFuel=enemyCredits;
    switch(item){
      case 0:
        inv[0]++;
        enemyCredits-=10;
        break;
      case 1:
        inv[1]++;
        enemyCredits-=15;
        break;
      case 2:
        inv[2]++;
        enemyCredits-=20;
        break;
      case 3:
        inv[3]++;
        enemyCredits-=20;
        break;
      case 4:
        inv[4]++;
        enemyCredits-=30;
        break;
      case 5:
        inv[5]++;
        enemyCredits-=30;
        break;
      case 6:
        inv[6]++;
        enemyCredits-=30;
        break;
      case 7:
        carrier.squad.add(new LogicPlane(4, true));
        enemyCredits-=20;
        break;
      case 8:
        carrier.fuel+=howMuchFuel;
        enemyCredits-=howMuchFuel;
        break;
      case 9:
        patrol.decoys++;
        enemyCredits-=10;
        break;
    }
  }
  
  void repair(Ship fix, int part){
    
    
  }
  
  //all sub actions handled for enemy from sub
  
  //all patrol boat actions handled for enemy by patrol boat
  
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
  
  Boolean canWinRightNow(){
    return false;
  }
  
  Boolean haveSpareComms(){
    if(inv[4]>0)return true;
    return false;
  }
  
  //0 false, 1 true, 2 false tell above
  
  int subOutOfPower(){
    if(sub.power==0){
      checkP=subP;
      if(shipAboutToSink()>0)return 2;
      
      sub.surface();//output
      playerTurn=true;
      return 1;
    }else{
      if(shipAboutToSink()>0)return 2;
      return 0;
    }
  }
  
  int shipAboutToSink(){
    if(aboutToSink()!=null){
      if(sinkP>checkP)checkP=sinkP;
      if(playerHasFoundShip()>0)return 2;
      if(sinkP<checkP)return 0;
      //output
      return 1;
    }else{
      if(playerHasFoundShip()>0)return 2;
      return 0;
    }
  }
  
  int playerHasFoundShip(){
    Boolean yes=false;
    for(int s=0; s<enemyShips.size(); s++){
      if(enemyShips.get(s).playerFound && !enemyShips.get(s).sunk)yes=true;
    }
    if(yes){
      if(foundP>checkP)checkP=foundP;
      if(planeAboutToCrash()>0)return 2;
      if(foundP<checkP)return 0;
      //output
      for(int p=0; p<squadron.size(); p++){
        if(squadron.get(p).fuel>=1)return 0;
      }
      if(carrier.planes==0)return 0;
      Boolean gotFuel = false;
      for(int s=0; s<carrier.squad.size(); s++){
        if(!carrier.squad.get(s).launched && carrier.squad.get(s).fuel>0)gotFuel=true;
      }
      if(!gotFuel)return 0;
      planeDefend();
      playerTurn=true;
      return 1;
    }else{
      if(planeAboutToCrash()>0)return 2;
      return 0;
    }
  }
  
  int planeAboutToCrash(){
    Boolean yes = false;
    int plane = 0;
    for(int p=0; p<carrier.squad.size(); p++){
      if(yes)continue;
      if(squadron.get(p).fuel==0 && carrier.squad.get(p).launched){
        yes=true;
        plane=p;
      }
    }
    if(yes){
      if(crashP>checkP)checkP=crashP;
      if(crashP<foundP)return 0;
      squadron.get(plane).returnToCarrier();
      //output
      return 1;
    }else{
      return 0;
    }
  }
  
  Ship aboutToSink(){
    Ship out = null;
    for(int s=0; s<enemyShips.size(); s++){
      int stillGood=0;
      if(enemyShips.get(s).name=="Decoy" || out!=null || enemyShips.get(s).sunk)continue;

      for(int t=0; t<enemyShips.get(s).size; t++){
        if(!enemyShips.get(s).hit[t])stillGood++;
      }
      if(stillGood==1)out=enemyShips.get(s);
    }
    return out;
  }
  
  Boolean checkDefender(){
    if(squadron.size()>0){//have defend aircraft
      return false;
    }else{
      if(carrier.planes>0){//do I have more aircraft
        for(int p=0; p<carrier.squad.size(); p++){//do they have fuel
          if(carrier.squad.get(p).fuel>=2){
            planeDefend();
            return true;
          }
        }
        if(enemyCredits>=10){//can I afford fuel
          enemyCredits-=10;
          carrier.fuel+=10;
          nextTurns.add(new OutPut(-1, defend));
          return true;
        }
        return false;
      }else if(enemyCredits>=30){//can I afford more aircraft
        enemyCredits-=30;
        carrier.squad.add(new LogicPlane(4, true));
        nextTurns.add(new OutPut(-1, defend));
      }
      return false;
    }
  }
  
  Boolean majorSystemDown(){
    if(destroyer.hit[1]){//comms down
      int need = 0;
      if(inv[0]==0)need+=10;
      if(inv[3]==0)need+=20;
      if(inv[4]==0)need+=30;
      if(enemyCredits>=need){
        if(inv[0]==0)nextTurns.add(new OutPut(-1, buy, 0));
        if(inv[3]==0)nextTurns.add(new OutPut(-1, buy, 3));
        if(inv[4]==0)nextTurns.add(new OutPut(-1, buy, 4));
        nextTurns.add(new OutPut(100, fix, destroyer, 1));
        outputPriorities();
      }
    }
    if(battle.hit[2] || battle.hit[3]){//broadside down
      //if(inv[0]>0 && inv[2]>0){//can I fix it
      int need = 0;
      if(inv[0]==0)need+=10;
      if(inv[2]==0)need+=20;
      if(enemyCredits>=need){
        
      }
    }
    if(destroyer.hit[0] || destroyer.hit[2]){//railgun down
      //if(inv[0]>0 && inv[3]>0){//can I fix it
      
    }
    if(sub.hit[1]){//sonar down
      //if(){//can I fix it
      
    }
    if(patrol.hit[0]){//motor down
      //if(inv[0]>0 && inv[6]>0){//can I fix it
      
    }  
  }
  
}

class OutPut{
  
  int priority;
  Ship fix;
  Method out;
  int intArg1 = -1;
  int intArg2 = -1;
  
  OutPut( int priority, Method output){
    this.priority=priority;
    this.out=output;
  }
  
  OutPut(int priority, Method output, int intArg1){
    this.priority=priority;
    this.out=output;
    this.intArg1=intArg1;
  }
  
  OutPut(int priority, Method output, Ship fix, int intArg1){
    this.priority=priority;
    this.out=output;
    this.fix=fix;
    this.intArg1=intArg1;
  }
  
  void go() throws IllegalAccessException, InvocationTargetException{
    if(fix!=null){out.invoke(enemy, fix, intArg1);return;}
    if(intArg1>-1){out.invoke(enemy, intArg1);return;}
    out.invoke(enemy);
  }
  
}
