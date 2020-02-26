import java.lang.reflect.*;
import java.util.PriorityQueue;
import java.util.Comparator;
import java.util.*;

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
  
  PathFind pathFind;
  
  int wait=60;
  
  float subP, sinkP, foundP, crashP,checkP;
  Boolean stall = false;
  
  OutPut thisTurn;
  ArrayList<OutPut> nextTurns = new ArrayList<OutPut>();
  ArrayList<Instruction> path = new ArrayList<Instruction>();
  
  Method defend;
  Method buy;
  Method fix;
  Method sonar;
  Method surface;
  Method submerge;
  Method kamakazy;
  Method railgun;
  Method broadside;
  Method shoot;
  Method pTurn;
  Method pMove;
  Method decoy;
  Method pFuel;
  Method executeInstruction;
  Method que2;
  
  Enemy(){
    
  }
  
  void setupenemy() throws NoSuchMethodException{
    placeBattle();
    placeDestroy();
    placeCarrier();
    placeSub();
    placePatrol();
    pathFind=new PathFind();
    path=pathFind.findPath();
    defend=Enemy.class.getDeclaredMethod("planeDefend",null);
    buy=Enemy.class.getDeclaredMethod("buy", int.class);
    fix=Enemy.class.getDeclaredMethod("repair", Ship.class, int.class);
    sonar=Enemy.class.getDeclaredMethod("subPing", null);
    surface=Enemy.class.getDeclaredMethod("subSurface", null);
    submerge=Enemy.class.getDeclaredMethod("subSubmerge", null);
    kamakazy=Enemy.class.getDeclaredMethod("planeAttack", int.class, int.class);
    railgun=Enemy.class.getDeclaredMethod("rail", int.class);
    broadside=Enemy.class.getDeclaredMethod("broad", null);
    shoot=Enemy.class.getDeclaredMethod("standardAttack", int.class, int.class);
    pTurn=Enemy.class.getDeclaredMethod("patrolTurn", int.class);
    pMove=Enemy.class.getDeclaredMethod("patrolMove", int.class);
    decoy=Enemy.class.getDeclaredMethod("placeDecoy", int.class, int.class);
    pFuel=Enemy.class.getDeclaredMethod("fuelPatrol",null);
    executeInstruction=Enemy.class.getDeclaredMethod("runInstruction", null);
    que2=Enemy.class.getDeclaredMethod("que", OutPut.class, OutPut.class);
  }
  
  void runenemy() throws IllegalAccessException, InvocationTargetException{
    stall=false;
    thisTurn =null;
    if(!playerTurn && !enemyStall){
      if(wait>0){
        //println(wait);
        wait--;
        return;
      }
      if(nextTurns.size()>0){
        thisTurn=nextTurns.get(0);
        nextTurns.remove(0);
      }
      
      if(canWinRightNow()){//can win on this turn
        println("1");
        return;
      }else if(subOutOfPower()!=0){
        println("2");
        if(stall){
          enemyStall=true;
        }else playerTurn=true;
        return;
      }else if(!haveSpareComms()){//don't have spare comms
        println("3");
        playerTurn=true;
        return;
      }else if(checkDefender()){
        println("4");
        //playerTurn=true;
        return;
      }else{ 
        //major system down
        majorSystemDown();
        //sub submerged
        if(sub.submerged){
          if(sub.power>=2){
            setOutput(new OutPut(3, sonar, new Object[]{}));
          }else{
            setOutput(new OutPut(3, surface, new Object[]{}));
          }
        }
        //have found ship
        haveFoundShip();
        //can use railgun
        if(destroyer.cooldown<=0 && !destroyer.sunk && railGunShootLine()!=-1){
          setOutput(new OutPut(3, railgun, new Object[]{railGunShootLine()}));
        }
        //can use broadside
        if(battle.cooldown<=0 && !battle.sunk){
          setOutput(new OutPut(3, broadside, new Object[]{}));
        }
        rng();
      }
      if(nextTurns.size()>0 && (nextTurns.get(0).priority>thisTurn.priority || nextTurns.get(0).priority==-1)){
        println(nextTurns.size());
        thisTurn=nextTurns.get(0);
        nextTurns.remove(0);
      }
      thisTurn.go();
      if(stall){
        enemyStall=true;
      }else playerTurn=true;
    }
  }
  
  void setOutput(OutPut out){
    if(thisTurn!=null && out.priority>thisTurn.priority){
      thisTurn=out;
    }else if(thisTurn==null){
      thisTurn=out;
    }
  }
  
 void outputPriorities(){
   //purges all outputs from the list with a lower priority than the greatest
   int high=0;
   for(int o=0; o<nextTurns.size(); o++){
     if(nextTurns.get(o).priority==-1){
       high=-1;
     }else if(high!=-1){
       if(nextTurns.get(o).priority>high)high=nextTurns.get(o).priority;
     }
   }
   for(int o=nextTurns.size()-1; o>=0; o--){
     if(nextTurns.get(o).priority!=high)nextTurns.remove(o);
   }
 }
 
  void planeAttack(int Tx, int Ty){
    if(carrier.planes<=0){
      println("no plane");
      shootNormal();
      return;
    }
    enemy.squadron.add(new Plane(carrier.getTileCenterAbsX(4), carrier.getTileCenterAbsY(4), carrier.deg, 2, true, Tx, Ty, carrier.squad.get(carrier.choosePlane(true))));
    stall=true;
    enemyStall=true;
  }
  
  void planeDefend(){
    enemy.squadron.add(new Plane(carrier.getTileCenterAbsX(4), carrier.getTileCenterAbsY(4), carrier.deg, 1, gameBoard.enemyTiles[5][5].x, gameBoard.enemyTiles[5][5].y, true, carrier.squad.get(carrier.choosePlane(false))));
    carrier.planes--;
    stall=true;
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
      if(missOne>=10 && missTwo>=10 && missThree >=10)return -1;
      if(missOne<=missTwo && missOne<=missThree)return lineOne;
      if(missTwo<=missThree)return lineTwo;
      return lineThree;
    }
    return -1;
  }
  
  void buy(int item){
    println("run");
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
    println("cool");
    fix.repair(part);
    inv[0]--;
    if(fix==carrier){
      inv[1]--;
    }else if(fix==battle){
      if(part>1)inv[2]--;
    }else if(fix==destroyer){
      inv[3]--;
      if(part==1)inv[4]--;
    }else if(fix==sub){
      if(part==1)inv[5]--;
    }else if(fix==patrol){
      if(part==0)inv[6]--;
    }
  }
  
  void subPing(){sub.scan();}
  
  void subSubmerge(){sub.submerge();}
  
  void subSurface(){sub.surface();}
  
  void rail(int line){destroyer.fireRailGun(line);}
  
  void broad(){battle.broadside();}
  
  void patrolTurn(int to){patrol.turn(to);}
  
  void patrolMove(int dist){patrol.move(dist);}
  
  void placeDecoy(int X, int Y){
    patrol.dropDecoy(X,Y);
    path.clear();
    path=pathFind.findPath();
  }
  
  void fuelPatrol(){patrol.refuel();}
  
  void runInstruction(){
    try{
      if(path.size()==0){
        nextTurns.add(new OutPut(3, pFuel, new Object[] {}));
        pathFind.goal.clear();
        while(true){
          if(carrier.adjacent.contains(patrol.myTiles[0])){
            int x=(int)random(10);
            int y=(int)random(10);
            if(pathFind.nodeMap[x][y]!=null){
              pathFind.goal.add(pathFind.nodeMap[x][y]);
              path=pathFind.findPath();
              pathFind.goal.clear();
              pathFind.defineGoal();
              break;
            }
          }else{
            path=pathFind.findPath();
            break;
          }
        }
      }
      path.get(0).execute();
      path.remove(0);
    }catch(IllegalAccessException e) {
    }catch(InvocationTargetException i){      
    }
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
  
  Boolean canWinRightNow(){
    return false;
  }
  
  Boolean haveSpareComms(){//return true to continue trunk
    if(destroyer.hit[1])return true;
    if(inv[4]==0){
      if(enemyCredits>=30){
        inv[4]++;
        enemyCredits-=30;
        return false;
      }
    }else if(inv[3]==0){
      if(enemyCredits>=20){
        inv[3]++;
        enemyCredits-=20;
        return false;
      }
    }else if(inv[0]==0){
      if(enemyCredits>=10){
        inv[0]++;
        enemyCredits-=10;
        return false;
      }
    }
    return true;
  }
  
  Boolean canRepair(Ship fix, int part){
    if(inv[0]==0)return false;
    if(fix==carrier){
      if(inv[1]>0)return true;
    }else if(fix==battle){
      if(part>1){
        if(inv[2]>0)return true;
      }else return true;
    }else if(fix==destroyer){
      if(inv[3]>0){
        if(part==1){
          if(inv[4]>0)return true;
        }else return true;
      }
    }else if(fix==sub){
      if(part==1){
        if(inv[5]>0)return true;
      }else return true;
    }else if(fix==patrol){
      if(part==0){
        if(inv[6]>0)return true;
      }else return true;
    }
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
      Ship save=aboutToSink();
      if(sinkP>checkP)checkP=sinkP;
      if(playerHasFoundShip()>0)return 2;
      if(sinkP<checkP)return 0;
      //output
      for(int p=0; p<save.size; p++){
        if(save.hit[p] && canRepair(save, p)){
          repair(save, p);
          return 1;
        }
      }
      if(playerHasFoundShip()>0)return 2;
      return 0;
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
    if(yes && !carrier.sunk){
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
      enemyStall=true;
      return 1;
    }else{
      if(planeAboutToCrash()>0)return 2;
      return 0;
    }
  }
  
  int planeAboutToCrash(){
    Boolean yes = false;
    int plane = 0;
    //if(squadron.size()>0){
      for(int p=0; p<carrier.squad.size(); p++){
        if(yes)continue;
        if(carrier.squad.get(p).fuel==0 && carrier.squad.get(p).launched){
          yes=true;
          plane=p;
        }
      //}
    }
    if(yes && !carrier.sunk){
      if(crashP>checkP)checkP=crashP;
      if(crashP<foundP)return 0;
      carrier.squad.get(plane).I.returnToCarrier();
      enemyStall=true;
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
      if(!carrier.sunk){
        if(carrier.planes>0){//do I have more aircraft
          for(int p=0; p<carrier.squad.size(); p++){//do they have fuel
            if(carrier.squad.get(p).fuel>=2){
              planeDefend();
              return true;
            }
          }
          if(enemyCredits>=10 && !destroyer.hit[1]){//can I afford fuel
            enemyCredits-=10;
            carrier.fuel+=10;
            nextTurns.add(new OutPut(-1, defend, new Object[]{}));
            return true;
          }
          return false;
        }else if(enemyCredits>=30 && !carrier.sunk && !destroyer.hit[1]){//can I afford more aircraft
          enemyCredits-=30;
          carrier.squad.add(new LogicPlane(4, true));
          nextTurns.add(new OutPut(-1, defend, new Object[]{}));
        }
      }
      return false;
    }
  }
  
  //0 did not output, 1 output continue for higher priority, 2 output do not continue absolute priority
  
  int majorSystemDown(){
    int retu=0;
    if(destroyer.hit[1] && !destroyer.sunk){//comms down
      int need = 0;
      if(inv[0]==0)need+=10;
      if(inv[3]==0)need+=20;
      if(inv[4]==0)need+=30;
      if(need==0){
        nextTurns.add(new OutPut(-1, fix, new Object[]{destroyer, 1}));
        outputPriorities();
        return 2;
      }
      if(enemyCredits>=need && !destroyer.hit[1]){
        if(inv[0]==0)nextTurns.add(new OutPut(-1, buy, new Object[]{0}));
        if(inv[3]==0)nextTurns.add(new OutPut(-1, buy, new Object[]{3}));
        if(inv[4]==0)nextTurns.add(new OutPut(-1, buy, new Object[]{4}));
        nextTurns.add(new OutPut(-1, fix, new Object[]{destroyer, 1}));
        outputPriorities();
        retu=1;
      }
    }
    if(battle.hit[2] || battle.hit[3] && !battle.sunk){//broadside down
      int which;
      if(battle.hit[2]){which=2;}else which=3;
      int need = 0;
      if(inv[0]==0)need+=10;
      if(inv[2]==0)need+=20;
      if(need==0){
        nextTurns.add(new OutPut(-1, fix, new Object[]{battle, which}));
        outputPriorities();
        return 2;
      }
      if(enemyCredits>=need && !destroyer.hit[1]){
        if(inv[0]==0)nextTurns.add(new OutPut(2, buy, new Object[]{0}));
        if(inv[2]==0)nextTurns.add(new OutPut(2, buy, new Object[]{2}));
        nextTurns.add(new OutPut(2, fix, new Object[]{battle, which}));
        outputPriorities();
        retu=1;
      }
    }
    if(destroyer.hit[0] || destroyer.hit[2]){//railgun down
      int which;
      if(destroyer.hit[0]){which=0;}else which=2;
      int need = 0;
      if(inv[0]==0)need+=10;
      if(inv[3]==0)need+=20;
      if(need==0){
        nextTurns.add(new OutPut(-1, fix, new Object[]{destroyer, which}));
        outputPriorities();
        return 2;
      }
      if(enemyCredits>=need && !destroyer.hit[1]){
        if(inv[0]==0)nextTurns.add(new OutPut(2, buy, new Object[]{0}));
        if(inv[3]==0)nextTurns.add(new OutPut(2, buy, new Object[]{3}));
        nextTurns.add(new OutPut(2, fix, new Object[]{destroyer, which}));
        outputPriorities();
        retu=1;
      }
    }
    if(sub.hit[1]){//sonar down
      int need = 0;
      if(inv[0]==0)need+=10;
      if(inv[5]==0)need+=30;
      if(need==0){
        nextTurns.add(new OutPut(-1, fix, new Object[]{sub, 1}));
        outputPriorities();
        return 2;
      }
      if(enemyCredits>=need && !destroyer.hit[1]){
        if(inv[0]==0)nextTurns.add(new OutPut(2, buy,new Object[]{0}));
        if(inv[5]==0)nextTurns.add(new OutPut(2, buy,new Object[]{5}));
        nextTurns.add(new OutPut(2, fix,new Object[]{sub, 1}));
        outputPriorities();
        retu=1;
      }
    }
    if(patrol.hit[0]){//motor down
      int need = 0;
      if(inv[0]==0)need+=10;
      if(inv[6]==0)need+=30;
      if(need==0){
        nextTurns.add(new OutPut(-1, fix, new Object[]{patrol, 0}));
        outputPriorities();
        return 2;
      }
      if(enemyCredits>=need && !destroyer.hit[1]){
        if(inv[0]==0)nextTurns.add(new OutPut(2, buy, new Object[]{0}));
        if(inv[6]==0)nextTurns.add(new OutPut(2, buy, new Object[]{6}));
        nextTurns.add(new OutPut(2, fix, new Object[]{patrol, 0}));
        outputPriorities();
        retu=1;
      }
    }
    return retu;
  }
  
  Object[] foundShip(){
    for(int h=0; h<thinkHit.size(); h++){
      if(!thinkHit.get(h).shipSunk)return new Object[]{thinkHit.get(h).x,thinkHit.get(h).y};
    }
    return null;
  }
  
  Boolean haveFoundShip(){
    Object[] coords = foundShip();
    if(carrier.sunk)return false;
    if(coords==null)return false;
    if(player.squadron.size()>0)return false;
    if(squadron.size()>0 && carrier.planes>1 && !carrier.sunk){
      setOutput(new OutPut(4, kamakazy, coords));
      stall=true;
      return true;
    }else if(squadron.size()>0 && !carrier.sunk  && !destroyer.hit[1]){
      if(enemyCredits<20)return false;
      println("buying");
      setOutput(new OutPut(4, buy, new Object[]{7}));
      nextTurns.add(new OutPut(4, kamakazy, coords));
      outputPriorities();
      return true;
    }
    return false;
  }
  
  void rng(){
    int rand=(int)random(10);
    println("rng " + rand);
    if(rand!=0)rand=9;
    switch(rand){
      case 0:
        movePatrol();
        return;
      case 1:
        submergeSub();
        return;
      case 2:
        sonarPing();
        return;
      case 3:
        buyStuff();
        return;
      case 4:
        buyStuff();
        return;
      case 5:
        dropDecoy();
        return;
      case 6:
        shootNormal();
        return;
      case 7:
        shootNormal();
        return;
      case 8:
        shootNormal();
        return;
      case 9:
        fixSomething();
        return;
    }
  }
  
  void movePatrol(){
    if(patrol.fuel==0 ||(path.size()>0 && path.get(0).moveOrTurn && patrol.fuel<path.get(0).distance)){//feedback
      rng();
      return;
    }
    //out
      setOutput(new OutPut(2, executeInstruction, new Object[]{}));
      return;
  }
  
  void submergeSub(){
    if(sub.submerged || sub.power<=2 || sub.damaged){//feedback
      rng();
      return;
    }
    //out
    setOutput(new OutPut(1, submerge, new Object[]{}));
      return;
  }
  
  void sonarPing(){
    if(sub.power<2){//feedback
      rng();
      return;
    }
    //out
    setOutput(new OutPut(1, sonar, new Object[]{}));
      return;
  }
  
  void buyStuff(){
    if(enemyCredits<10){//feedback
      rng();
      return;
    }
    //out
    if(carrier.fuel<=10 && enemyCredits>=20)setOutput(new OutPut(1, buy, new Object[]{8})); 
    if(carrier.planes<=2 && enemyCredits>=20)setOutput(new OutPut(1, buy, new Object[]{7}));
    Boolean runDam=false;
    int which = -1;
    for(int r=0; r<5; r++){
      if(carrier.hit[r])runDam=true;
      which=r;
    }
    if(runDam && enemyCredits>=15 && inv[0]>0){
      setOutput(new OutPut(1, que2, new Object[]{new OutPut(1, buy, new Object[]{1}), new OutPut(3, fix, new Object[]{carrier, which})}));
    }
    if(patrol.decoys==0 && enemyCredits>=10) setOutput(new OutPut(1, buy, new Object[]{9}));
    setOutput(new OutPut(1, buy, new Object[]{0}));
      return;
  }
  
  void que(OutPut first, OutPut second){
    try{
      first.go();
    }catch(IllegalAccessException e){
    
    }catch(InvocationTargetException e){
    
    }
    nextTurns.add(second);
  }
  
  void dropDecoy(){
    if(patrol.sunk || patrol.decoys==0){//feedback
      rng();
      return;
    }
    //out
    int rand=(int)random(patrol.adjacent.size()-1);
    setOutput(new OutPut(1, decoy, new Object[]{patrol.adjacent.get(rand).x, patrol.adjacent.get(rand).y}));
    return;
  }
  
  void shootNormal(){
    Ship lookingAt = null;
    ArrayList<LogicTile> hitsOnShip = new ArrayList<LogicTile>();
    LogicTile tryShoot = null;
    if(scans.size()>0){
      tryShoot=scans.get(0);
      setOutput(new OutPut(0, shoot, new Object[]{tryShoot.x, tryShoot.y}));
      return;
    }
    //finding all hits on a ship
    for(int h=0; h<thinkHit.size(); h++){
      //println("run");
      if(lookingAt==null){
        if(!thinkHit.get(h).shipSunk){
          lookingAt=thinkHit.get(h).shipAt;
          hitsOnShip.clear();
          hitsOnShip.add(thinkHit.get(h));
        }else{
          if(thinkHit.get(h).shipAt==lookingAt){
            hitsOnShip.add(thinkHit.get(h));
          }
        }
      }
    }
    if(lookingAt!=null){//destroy
      if(hitsOnShip.size()>1){//multiple hits to work with
        if(hitsOnShip.get(0).x==hitsOnShip.get(1).x){//verticle
          for(int t=0; t<hitsOnShip.size(); t++){
            if(tryShoot==null){
              if(hitsOnShip.get(t).y-1>=0 && !gameBoard.playerLogic[hitsOnShip.get(t).x][hitsOnShip.get(t).y-1].miss && !gameBoard.playerLogic[hitsOnShip.get(t).x][hitsOnShip.get(t).y-1].hit){
                tryShoot=gameBoard.playerLogic[hitsOnShip.get(t).x][hitsOnShip.get(t).y-1];
              }else if(hitsOnShip.get(t).y+1<=9 && !gameBoard.playerLogic[hitsOnShip.get(t).x][hitsOnShip.get(t).y+1].miss && !gameBoard.playerLogic[hitsOnShip.get(t).x][hitsOnShip.get(t).y+1].hit){
                tryShoot=gameBoard.playerLogic[hitsOnShip.get(t).x][hitsOnShip.get(t).y+1];
              }
            }
          }
        }else{//hoprizontal
          for(int t=0; t<hitsOnShip.size(); t++){
            if(tryShoot==null){
              if(hitsOnShip.get(t).x-1>=0 && !gameBoard.playerLogic[hitsOnShip.get(t).x-1][hitsOnShip.get(t).y].miss && !gameBoard.playerLogic[hitsOnShip.get(t).x-1][hitsOnShip.get(t).y].hit){
                tryShoot=gameBoard.playerLogic[hitsOnShip.get(t).x-1][hitsOnShip.get(t).y];
              }else if(hitsOnShip.get(t).x+1<=9 && !gameBoard.playerLogic[hitsOnShip.get(t).x+1][hitsOnShip.get(t).y].miss && !gameBoard.playerLogic[hitsOnShip.get(t).x+1][hitsOnShip.get(t).y].hit){
                tryShoot=gameBoard.playerLogic[hitsOnShip.get(t).x+1][hitsOnShip.get(t).y];
              }
            }
          }
        }
      }else{//one hit to work with
        int reps = 0;
        Boolean good = false;
        while(!good){
          LogicTile check;
          switch(reps){
            case 0:
              if(hitsOnShip.get(0).y+1>9)break;
              check=gameBoard.playerLogic[hitsOnShip.get(0).x][hitsOnShip.get(0).y+1];
              for(int h=0; h<thinkHit.size(); h++){
                if(thinkHit.get(h)==check)break;
              }
              for(int m=0; m<thinkMiss.size(); m++){
                if(thinkMiss.get(m)==check)break;
              }
              tryShoot=check;
              good=true;
              break;
            case 1:
              if(hitsOnShip.get(0).y-1<0)break;
              check=gameBoard.playerLogic[hitsOnShip.get(0).x][hitsOnShip.get(0).y-1];
              for(int h=0; h<thinkHit.size(); h++){
                if(thinkHit.get(h)==check)break;
              }
              for(int m=0; m<thinkMiss.size(); m++){
                if(thinkMiss.get(m)==check)break;
              }
              tryShoot=check;
              good=true;
              break;
            case 2:
              if(hitsOnShip.get(0).x+1>9)break;
              check=gameBoard.playerLogic[hitsOnShip.get(0).x+1][hitsOnShip.get(0).y];
              for(int h=0; h<thinkHit.size(); h++){
                if(thinkHit.get(h)==check)break;
              }
              for(int m=0; m<thinkMiss.size(); m++){
                if(thinkMiss.get(m)==check)break;
              }
              tryShoot=check;
              good=true;
              break;
            case 3:
              if(hitsOnShip.get(0).x-1<0)break;
              check=gameBoard.playerLogic[hitsOnShip.get(0).x-1][hitsOnShip.get(0).y];
              for(int h=0; h<thinkHit.size(); h++){
                if(thinkHit.get(h)==check)break;
              }
              for(int m=0; m<thinkMiss.size(); m++){
                if(thinkMiss.get(m)==check)break;
              }
              tryShoot=check;
              good=true;
              break;
            case 4:
              if(hitsOnShip.get(0).y+1>9)break;
              check=gameBoard.playerLogic[hitsOnShip.get(0).x][hitsOnShip.get(0).y+1];
              for(int h=0; h<thinkHit.size(); h++){
                if(thinkHit.get(h)==check)break;
              }
              tryShoot=check;
              good=true;
              break;
            case 5:
              if(hitsOnShip.get(0).y-1<0)break;
              check=gameBoard.playerLogic[hitsOnShip.get(0).x][hitsOnShip.get(0).y-1];
              for(int h=0; h<thinkHit.size(); h++){
                if(thinkHit.get(h)==check)break;
              }
              tryShoot=check;
              good=true;
              break;
            case 6:
              if(hitsOnShip.get(0).x+1>9)break;
              check=gameBoard.playerLogic[hitsOnShip.get(0).x+1][hitsOnShip.get(0).y];
              for(int h=0; h<thinkHit.size(); h++){
                if(thinkHit.get(h)==check)break;
              }
              tryShoot=check;
              good=true;
              break;
            case 7:
              if(hitsOnShip.get(0).x-1<0)break;
              check=gameBoard.playerLogic[hitsOnShip.get(0).x-1][hitsOnShip.get(0).y];
              for(int h=0; h<thinkHit.size(); h++){
                if(thinkHit.get(h)==check)break;
              }
              tryShoot=check;
              good=true;
              break;
            default:
              tryShoot=gameBoard.playerLogic[(int)random(10)][(int)random(10)];
              good=true;
              break;
          }
          reps++;
        }
      }
      setOutput(new OutPut(0, shoot, new Object[]{tryShoot.x, tryShoot.y}));
    }else{//search
      int x = (int)random(10);
      int y = (int) random(5)*2;
      if(x%2==0){
        y++;
      }
      println("search");
      setOutput(new OutPut(1, shoot, new Object[]{x,y}));
    }
  }
  
  void fixSomething(){
    ArrayList<Object[]> parts = new ArrayList<Object[]>();
    for(int s=0; s<enemyShips.size(); s++){
      for(int t=0; t<enemyShips.get(s).size; t++){
        if(enemyShips.get(s).hit[t]){
          parts.add(new Object[]{enemyShips.get(s), t});
        }
      }
    }
    while(parts.size()>0){
      int rand=(int)random(parts.size()-1);
      if(canRepair(Ship.class.cast(parts.get(rand)[0]), Integer.class.cast(parts.get(rand)[1]))){
        setOutput(new OutPut(1, fix, parts.get(rand)));
        return;
      }else parts.remove(rand);
    }
    rng();
    return;
  }
  
}

class OutPut{
  
  int priority;
  Ship fix;
  Method out;
  Object[] obj;
  
  OutPut( int priority, Method output, Object[] obj){
    this.priority=priority;
    this.out=output;
    this.obj=obj;
  }
  
  void go() throws IllegalAccessException, InvocationTargetException{
    println(out);
    println(obj);
    out.invoke(enemy,obj);
  }

}

class Instruction{
  
  Boolean moveOrTurn;
  int distance;
  int dir;
  
  Instruction(Boolean move, int val){
    moveOrTurn=move;
    if(move){
      distance=val;
    }else dir=val;
  }
  
  void execute()throws IllegalAccessException, InvocationTargetException{
    if(moveOrTurn){
      enemy.pMove.invoke(enemy, distance);
    }else enemy.pTurn.invoke(enemy, dir);
  }
  
}

//https://www.redblobgames.com/pathfinding/grids/graphs.html
//https://www.redblobgames.com/pathfinding/a-star/implementation.html
//https://www.redblobgames.com/pathfinding/a-star/introduction.html

class PathFind{
  
  Ship patrol=enemy.patrol;
  Ship carrier=enemy.carrier;
  Graph grid = new Graph();
  Node[][] nodeMap = new Node[10][10];
  HashMap<Node,Node> cameFrom = new HashMap();
  HashMap<Node,Integer> costSoFar = new HashMap();
  HashMap<Node,Boolean> movingVerticle = new HashMap();
  PriorityQueue<Node> frontier = new PriorityQueue<Node>(100,new Order());
  ArrayList<Node> goal = new ArrayList<Node>();
  
  PathFind(){
    //create all nodes
    for(int y=0; y<10; y++){
      for(int x=0; x<10; x++){
        nodeMap[x][y] = new Node(x,y);
        grid.addNode(nodeMap[x][y]);
      }
    }
    
    //remove nodes with ships "on" them
    for(int s=0; s<enemyShips.size(); s++){
      if(enemyShips.get(s)!=patrol){
        for(int t=0; t<enemyShips.get(s).myTiles.length; t++){
          nodeMap[enemyShips.get(s).myTiles[t].x][enemyShips.get(s).myTiles[t].y]=null;
        }
      }
    }
    
    //define goal
    defineGoal();
    
    //add edges connecting all nodes
    for(int x=0; x<10; x++){
      for(int y=0; y<10; y++){
        if(nodeMap[x][y]!=null){
          if(x<9){
            grid.addEdge(nodeMap[x][y], nodeMap[x+1][y], 1);
            grid.addEdge(nodeMap[x+1][y], nodeMap[x][y], 1);
          }
          if(x>0){
            grid.addEdge(nodeMap[x][y], nodeMap[x-1][y], 1);
            grid.addEdge(nodeMap[x-1][y], nodeMap[x][y], 1);
          }
          if(y<9){
            grid.addEdge(nodeMap[x][y], nodeMap[x][y+1], 1);
            grid.addEdge(nodeMap[x][y+1], nodeMap[x][y], 1);
          }
          if(y>0){
            grid.addEdge(nodeMap[x][y], nodeMap[x][y-1], 1);
            grid.addEdge(nodeMap[x][y-1], nodeMap[x][y], 1);
          }
        }
      }
    }
    
    //tell every node to find its neighbors
    for(int x=0; x<10; x++){
      for(int y=0; y<10; y++){
        if(nodeMap[x][y]!=null){
          nodeMap[x][y].getNeighbors();
        }
      }
    }
    cameFrom.put(nodeMap[patrol.x][patrol.y],null);
    costSoFar.put(nodeMap[patrol.x][patrol.y],0);
    movingVerticle.put(nodeMap[patrol.x][patrol.y], (patrol.dir%2==0));
    frontier.add(nodeMap[patrol.x][patrol.y]);
    
    //print grid
    for(int y=0; y<10; y++){
      for(int x=0; x<10; x++){
        if(nodeMap[x][y]!=null){
          print(x + " " + y + " ,");
        }else print("null,");
      }
      println("");
    }
  }
  
  void defineGoal(){
    for(int a=0; a<enemy.carrier.adjacent.size(); a++){
      if(nodeMap[enemy.carrier.adjacent.get(a).x][enemy.carrier.adjacent.get(a).y]!=null){
        goal.add(nodeMap[enemy.carrier.adjacent.get(a).x][enemy.carrier.adjacent.get(a).y]);
        println(goal.get(goal.size()-1).name);
      }
    }
  }
  
  int newCost(Node next, Node from){
    int total = costSoFar.get(from);
    if(movingVerticle.get(from)){
      if(from.x==next.x){
        total+=1;
      }else total+=2;
    }else{
      if(from.y==next.y){
        total+=1;
      }else total+=2;
    }
    return total;
  }
  
  //pathfinding algorithm, returns int of which element of the goal list if applicable
  int find(){
    while(frontier.size()!=0){
      Node current=frontier.poll();
      println("checking " + current.name); if(cameFrom.get(current)!=null) println("Came From " + cameFrom.get(current).name + " Cost " + costSoFar.get(current) + " Verticle " + movingVerticle.get(current));
      for(int g=0; g<goal.size(); g++){
        println(current.name + " " + goal.get(g).name);
        if(current==goal.get(g))return g;
      }
      ArrayList<Node> arr = new ArrayList<Node>(current.neighbors);
      for(int n=0; n<arr.size(); n++){
        Node next=arr.get(n);
        if(!cameFrom.containsKey(next)){
          println("adding " + next.name);
          cameFrom.put(next,current);
          costSoFar.put(next,newCost(next, current));
          movingVerticle.put(next, current.x==next.x);
          frontier.add(next);
        }else if(costSoFar.get(next)>newCost(next, current)){
          println("old cost " + costSoFar.get(next) + " new cost " + newCost(next, current));
          println("adding " + next.name);
          cameFrom.put(next,current);
          costSoFar.put(next,newCost(next, current));
          movingVerticle.put(next, current.x==next.x);
          frontier.add(next);
        }
      }
    }
    return -1;
  }
  
  //finds path to gaol and returns it as an arraylist of encoded instructions
  ArrayList<Instruction> findPath(){
    
    ArrayList<Instruction> pathReverse = new ArrayList<Instruction>();//temp list
    ArrayList<Instruction> path = new ArrayList<Instruction>();//output list
    Instruction current;//instruction being made
    int adjTile = find();//runs pathfinding and returns the carrier tile we are heading to
    if(adjTile==-1)return path;
    //LogicTile goalTile=enemy.carrier.adjacent.get(adjTile);//tile we are heading to
    Node goal=this.goal.get(adjTile);//goal node
    Node checking=goal;//node of current point in the path, statrs at goal and works backward to start
    Node previous=null;//node moved to from checking, preceding it in itteration
    Node start = nodeMap[patrol.x][patrol.y];
    Boolean vert = movingVerticle.get(checking);//derection being moved by the previous tile
    int dist=0;//distance of current instruction
    
    //iterates backwards through the path and encodes instructions
    while(checking!=null){
      dist++;
      vert = movingVerticle.get(checking);
      println("path node" + checking.x + " " + checking.y + " verticle " + movingVerticle.get(checking));
      if(checking==start){
        if(previous==null)return path;
        pathReverse.add(new Instruction(true, 1-dist));
        if(checking.x==previous.x){//
          if(checking.y>previous.y){//south, dir=2
            pathReverse.add(new Instruction(false, 2));
          }else{//north, dir=0
            pathReverse.add(new Instruction(false, 0));
          }
        }else{
          if(checking.x>previous.x){//east, dir=1
            pathReverse.add(new Instruction(false, 1));
          }else{//west, dir=3
            pathReverse.add(new Instruction(false, 3));
          }
        }
        break;//don't break, must set first movement
      }
      previous = checking;//set previous node to current before getting next current
      println(previous.x + " " + previous.y);
      checking=cameFrom.get(checking);//set current to next node
      if(vert!=movingVerticle.get(checking)){//determine if the path turns
      println("turn");
        if(!vert){//check if the path was(will be) moving verticle
          if(previous.x>checking.x){//moving east, dir = 1
            if(checking.x>1 && nodeMap[checking.x-1][checking.y]!=null){//patrol can move backward, dir=3 ||||| tries to turn off of screen
              pathReverse.add(new Instruction(true, -dist));
              pathReverse.add(new Instruction(false, 3));
            }else{//patrol has to move forward, dir=1
              if(previous.x+dist<9 && nodeMap[previous.x+dist][checking.y]!=null){//patrol boat dosen't need to turn around in the middle
                pathReverse.add(new Instruction(true, dist));
                pathReverse.add(new Instruction(false, 1));
              }else if(nodeMap[checking.x+dist][checking.y]==goal){//don't need to turn around, just head up to the goal
                pathReverse.add(new Instruction(true, dist-1));
                pathReverse.add(new Instruction(false, 1));
              }else{//patrol has to turn around
                pathReverse.add(new Instruction(true, 1-dist));
                pathReverse.add(new Instruction(false, 3));
                pathReverse.add(new Instruction(true, 1));
                pathReverse.add(new Instruction(false, 1));
              }
            }
          }else{//moving west, dir=3
            if(checking.x<9 && nodeMap[checking.x+1][checking.y]!=null){//patrol can move backward, dir=1
              pathReverse.add(new Instruction(true, -dist));
              pathReverse.add(new Instruction(false, 1));
            }else{//patrol has to move forward, dir=3
              if(previous.x-dist>1 && nodeMap[previous.x-dist][checking.y]!=null){//patrol boat dosen't need to turn around in the middle
                pathReverse.add(new Instruction(true, dist));
                pathReverse.add(new Instruction(false, 3));
              }else if(nodeMap[checking.x-dist][checking.y]==goal){//don't need to turn around, just head up to the goal
                pathReverse.add(new Instruction(true, dist-1));
                pathReverse.add(new Instruction(false, 3));
              }else{//patrol has to turn around
                pathReverse.add(new Instruction(true, 1-dist));
                pathReverse.add(new Instruction(false, 1));
                pathReverse.add(new Instruction(true, 1));
                pathReverse.add(new Instruction(false,3));
              }
            }
          }
        }else{
          if(previous.y<checking.y){//moving north, dir = 0
            if(checking.y<9 && nodeMap[checking.x][checking.y+1]!=null){//patrol can move backward, dir=2
              pathReverse.add(new Instruction(true, -dist));
              pathReverse.add(new Instruction(false, 2));
            }else{//patrol has to move forward, dir=0
              if(previous.y-dist>1 && nodeMap[checking.x][previous.y-dist]!=null){//patrol boat dosen't need to turn around in the middle
                pathReverse.add(new Instruction(true, dist));
                pathReverse.add(new Instruction(false, 0));
              }else if(nodeMap[checking.x][checking.y-dist]==goal){//don't need to turn around, just head up to the goal
                pathReverse.add(new Instruction(true, dist-1));
                pathReverse.add(new Instruction(false, 0));
              }else{//patrol has to turn around
                pathReverse.add(new Instruction(true, 1-dist));
                pathReverse.add(new Instruction(false, 2));
                pathReverse.add(new Instruction(true, 1));
                pathReverse.add(new Instruction(false, 0));
              }
            }
          }else{//moving south, dir=2
            if(checking.y>1 && nodeMap[checking.x][checking.y-1]!=null){//patrol can move backward, dir=0
              pathReverse.add(new Instruction(true, -dist));
              pathReverse.add(new Instruction(false, 0));
            }else{//patrol has to move forward, dir=2
              if(previous.y+dist<9 && nodeMap[checking.x][previous.y+dist]!=null){//patrol boat dosen't need to turn around in the middle
                pathReverse.add(new Instruction(true, dist));
                pathReverse.add(new Instruction(false, 2));
              }else if(nodeMap[checking.x][checking.y+dist]==goal){//don't need to turn around, just head up to the goal
                pathReverse.add(new Instruction(true, dist-1));
                pathReverse.add(new Instruction(false, 2));
              }else{//patrol has to turn around
                pathReverse.add(new Instruction(true, 1-dist));
                pathReverse.add(new Instruction(false, 0));
                pathReverse.add(new Instruction(true,1));
                pathReverse.add(new Instruction(false, 2));
              }
            }
          }
        }
        dist=0;
      }
    }
    
    println(pathReverse.size());
    
    for(int e=pathReverse.size()-1; e>=0; e--){
      path.add(pathReverse.get(e));
    }
    
    if(!path.get(0).moveOrTurn){
      if(path.get(0).dir==patrol.dir)path.remove(0);
      outer: while(true){
        int currentDir=patrol.dir;
        for(int p=0; p<path.size(); p++){//remove move distance 0
          if(path.get(p).moveOrTurn && path.get(p).distance==0){
            path.remove(p);
            continue outer;
          }
          if(!path.get(p).moveOrTurn){//look for turns
            if(path.get(p).dir==currentDir){
              path.remove(p);
              continue outer;
            }
            currentDir=path.get(p).dir;
            continue;
          }
        }
        break;
      }
    }
    
    for(int a=0; a<path.size(); a++){
      println(path.get(a).moveOrTurn + " dist " + path.get(a).distance + " dir " + path.get(a).dir);
    }
    
    return path;  
  }
  
}

class Order implements Comparator<Node>{
  
  int compare(Node p1, Node p2){
    if(enemy.pathFind.costSoFar.get(p1)>enemy.pathFind.costSoFar.get(p2)){
      return 1;
    }else if(enemy.pathFind.costSoFar.get(p1)<enemy.pathFind.costSoFar.get(p2)){
      return -1;
    }else return 0;
  }
  
}

class Node{
  
  Boolean origin=false;
  Boolean destination=false;
  Set<Edge> edges;
  Set<Node> neighbors;
  String name;
  int x,y;

  public Node(int x, int y){
    this.x=x;
    this.y=y;
    name=""+x+", "+y;
    edges = new HashSet<Edge>();    
  }

  void addEdge(Edge edge){
    edges.add(edge);
  }
  
  Set<Node> getNeighbors(){
    Set<Node> neighbor = new HashSet<Node>();
    for(Edge edge : edges){
      neighbor.add(edge.getDestination());
    }
    neighbors=neighbor;
    return neighbor;
  }

  Set<Edge> getEdges(){
    return new HashSet(this.edges);
  }
}

class Edge{

  Node source, destination;
  float distance;

  public Edge(Node source, Node destination, float distance) {
    this.source = source;
    this.destination= destination;
    this.distance= distance;
  }

  Node getSource(){
    return this.source;
  }
  
  Node getDestination(){
    return this.destination;
  }
  
  float getDistance(){
    return this.distance;
  }
}

class Graph {

  int numNodes;
  Map<Node, Set<Edge>> nodes;

  Graph(){
    numNodes = 0;
    nodes = new HashMap<Node, Set<Edge>>();
  }

  void addEdge(Node source, Node destination, float distance){
    if(nodes.containsKey(source) && nodes.containsKey(destination)){
      Edge edge = new Edge(source, destination, distance);
      nodes.get(source).add(edge);
      source.addEdge(edge);
    }else{
      System.out.println("Source node not found..");
    }
  }
  
  void addNode(Node V){
    if(!nodes.containsKey(V)){
      nodes.put(V, new HashSet<Edge>());
      //nodes.put(V.name, V);
      System.out.println("node Added");
      ++numNodes;
    }else System.out.println("node already added");
  }

  ArrayList<Node> getNeighbor(Node node){
    return new ArrayList<Node>(node.getNeighbors());
  }

  // to get distance between verices directly connected to each other
  float getDistance(Node source, Node destination){
    float distance = 0.0;
    for(Edge edge : nodes.get(source)){
      if(edge.getDestination() == destination){
        distance = edge.getDistance();
        break;
      }
    }
    return distance;
  }

  // No of nodes in graph
  int numNodes(){
    return numNodes;
  }

  void bfs(Node source){
    Queue<Node> queue = new LinkedList<Node>();
    HashSet<Node> visited = new HashSet<Node>();
    ArrayList<String> path = new ArrayList();
    queue.add(source);
    while(!queue.isEmpty()){
      Node node = queue.poll();
      visited.add(node);
      Set<Node> neighbor = node.getNeighbors();
      for(Node V : neighbor){
        if(!visited.contains(V)){
          queue.add(V);
          visited.add(V);
          path.add(V.name);
        }
      }
    }
  }
  
}
