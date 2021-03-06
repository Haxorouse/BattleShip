class Plane{
  
  int goalX;
  int goalY;
  int Tx;
  int Ty;
  int turnAroundCount = 0;
  int shootTime = 0;
  float x;
  float y;
  float deg;
  float turnAngle;
  Boolean isEnemy;
  Boolean defend = false;
  Boolean attack = false;
  Boolean returning = false;
  Boolean madeItToGoal = false;
  Boolean signaled = false;
  int fuel=4;
  int invisTime=-100;
  
  LogicPlane me;
  
  Button returnHome;
  Button goKamakazy;
  
  Plane(int x, int y, int deg, int mission, int goalX, int goalY, Boolean isEnemy, LogicPlane me){
    this.x=x;
    this.y=y;
    this.deg=deg;
    this.isEnemy=isEnemy;
    this.goalX=goalX;
    this.goalY=goalY;
    this.me=me;
    me.launched=true;
    fuel=me.fuel;
    if(mission==1){
      defend = true;
    }else if(mission==2){
      attack = true;
    }
    turnAngle=angleToGoalFixed()/90;
    me.I=this;
  }
  
   Plane(int x, int y, int deg, int mission, Boolean isEnemy, int Tx, int Ty, LogicPlane me){
    this.x=x;
    this.y=y;
    this.deg=deg;
    this.isEnemy=isEnemy;
    this.me=me;
    me.launched=true;
    fuel=me.fuel;
    if(isEnemy){
      goalX=gameBoard.playerTiles[Tx][0].x+tileSize/2;
      goalY=gameBoard.playerTiles[0][Ty].y+tileSize/2;
    }else{
      goalX=gameBoard.enemyTiles[Tx][0].x+tileSize/2;
      goalY=gameBoard.enemyTiles[0][Ty].y+tileSize/2;
    }
    this.Tx=Tx;
    this.Ty=Ty;
    if(mission==1){
      defend = true;
    }else if(mission==2){
      attack = true;
    }
    turnAngle=angleToGoalFixed()/90;
    me.I=this;
  }
  
  void drawPlane(){
    pushMatrix();
    translate(x, y);
    rotate(radians(deg));
    if(isEnemy){
      planeSprite(invisTime);
      if(returning){
        invisTime-=5;
      }else{
        invisTime++;
        if(attack)invisTime+=4;
      }
      if(invisTime>255)invisTime=255;
    }else planeSprite();
    popMatrix();
    me.fuel=fuel;
  }
  
  void update(){
    if(!madeItToGoal && !attack){
      if(abs(angleToGoalFixed())>abs(turnAngle) && distToGoal()>abs((angleToGoalFixed()/turnAngle)*2)){
        turn(turnAngle);
        move(2);
      }else if(abs(angleToGoalFixed())>abs(turnAngle) && distToGoal()<abs((angleToGoal()/turnAngle)) && distToGoal()<100){
        turn((2.0*angleToGoalFixed())/distToGoal());
        move(2);
      }else {
        if(angleToGoal()>.1)turn(angleToGoal());
        move(2);
      }
      if(x>=goalX-1 && x<=goalX+1 && y>=goalY-1 && y<=goalY+1)madeItToGoal=true;
    }else{
      if(attack){
        kamakazy();
      }else if(defend){
        if(fuel<0){
          animations.add(new Splash(x,y));
          if(!isEnemy)player.squadron.remove(this);
          if(isEnemy)enemy.squadron.remove(this);
        }
        defend();
      }else if(returning){
        if(!isEnemy){
          //player.carrier.planes++;
          //player.carrier.fuel-=(4-fuel);
          me.launched=false;
          playerTurn=false;
          player.squadron.remove(this);
        }
        if(isEnemy){
          //enemy.carrier.planes++;
          //enemy.carrier.fuel-=(4-fuel);
          me.launched=false;
          playerTurn=true;
          enemy.squadron.remove(this);
        }
      }
    }
  }
  
  void defend(){
    if(turnAroundCount<180){
      turnAroundCount++;
      move(2);
      turn(1);
    }else{
      if(!signaled){
        signaled=true;
        if(isEnemy){
          playerTurn=true;
        }else playerTurn=false;
      }
      move(4);
      turn(1);
    }
    if(isEnemy && enemy.squadron.get(0)==this && playerTurn){
      for(int p=0; p<player.squadron.size(); p++){
        if(player.squadron.get(p).attack){
          shoot(p);
          break;
        }else shootTime=0;
      }
    }else if(player.squadron.size()>0 && !isEnemy && player.squadron.get(0)==this && !playerTurn){
      for(int e=0; e<enemy.squadron.size(); e++){
        if(enemy.squadron.get(e).attack){
          shoot(e);
          break;
        }else shootTime=0;
      }
    }
  }
  
  void shoot(int plane){
    shootTime++;
    if(isEnemy){
      //gun annimation
      
      if(shootTime>=60){
        Plane target = player.squadron.get(plane);
        animations.add(new Boom(target.x, target.y));
        player.carrier.squad.remove(target.me);
        player.squadron.get(plane).me.I=null;
        player.squadron.remove(target);
        animations.add(new Boom(x, y));
        enemy.carrier.squad.remove(me);
        me.I=null;
        enemy.squadron.remove(this);
        playerTurn=false;
      }
    }else{
      //gun animation
      
      if(shootTime>=60){
        Plane target = enemy.squadron.get(plane);
        animations.add(new Boom(target.x, target.y));
        enemy.carrier.squad.remove(target.me.I);
        enemy.squadron.get(plane).me.I=null;
        enemy.squadron.remove(target);
        animations.add(new Boom(x, y));
        player.carrier.squad.remove(me);
        playerTurn=true;
        player.squadron.remove(this);
      }
    }
  }
  
  void kamakazy(){
    move(4);
    if(abs(angleToGoalFixed())>abs(turnAngle)){
        turn(turnAngle);
      }else {
        if(angleToGoal()>.1)turn(angleToGoal());
      }
    if(x>=goalX-5 && x<=goalX+5 && y>=goalY-5 && y<=goalY+5){
      animations.add(new Boom(x, y));
      if(isEnemy){
        if(gameBoard.playerLogic[Tx][Ty].hasShip){
          Ship ship = gameBoard.playerLogic[Tx][Ty].shipAt;
          println(ship.name);
          for(int s=0; s<playerShips.size(); s++){
            if(playerShips.get(s)==ship){
              for(int t=0; t<playerShips.get(s).size; t++){
                gameBoard.tryFire(playerShips.get(s).myTiles[t].x, playerShips.get(s).myTiles[t].y, false);
              }
              break;
            }
          }
        }else{
          gameBoard.tryFire(Tx, Ty, false);
          gameBoard.tryFire(Tx-1, Ty, false);
          gameBoard.tryFire(Tx, Ty-1, false);
          gameBoard.tryFire(Tx+1, Ty, false);
          gameBoard.tryFire(Tx, Ty+1, false);
        }
      }else{
        if(gameBoard.enemyLogic[Tx][Ty].hasShip){
          Ship ship = gameBoard.enemyLogic[Tx][Ty].shipAt;
          for(int s=0; s<enemyShips.size(); s++){
            if(enemyShips.get(s)==ship){
              for(int t=0; t<enemyShips.get(s).size; t++){
                gameBoard.tryFire(enemyShips.get(s).myTiles[t].x, enemyShips.get(s).myTiles[t].y, true);
              }
            }
          }
        }else{
          gameBoard.tryFire(Tx, Ty, true);
          gameBoard.tryFire(Tx-1, Ty, true);
          gameBoard.tryFire(Tx, Ty-1, true);
          gameBoard.tryFire(Tx+1, Ty, true);
          gameBoard.tryFire(Tx, Ty+1, true);
        }
      }
      if(isEnemy){
        theEnemy.carrier.squad.remove(me);
        playerTurn=true;
        enemy.squadron.remove(this);
      }else{
        player.carrier.squad.remove(me);
        playerTurn=false;
        player.squadron.remove(this);
      }
    }
  }
  
  void returnToCarrier(){
    madeItToGoal=false;
    returning=true;
    defend=false;
    if(isEnemy){
      goalX=enemy.carrier.getTileCenterAbsX(0);
      goalY=enemy.carrier.getTileCenterAbsY(0);
    }else{
      goalX=player.carrier.getTileCenterAbsX(0);
      goalY=player.carrier.getTileCenterAbsY(0);
    }
    turnAngle=angleToGoalFixed()/90;
  }
  
  //defending aircraft move to attack
  
  void defendToAttack(int Tx, int Ty){
    madeItToGoal=false;
    attack=true;
    defend=false;
    if(isEnemy){
      goalX=gameBoard.playerTiles[Tx][0].x+tileSize/2;
      goalY=gameBoard.playerTiles[0][Ty].y+tileSize/2;
      this.Tx=Tx;
      this.Ty=Ty;
    }else{
      goalX=gameBoard.enemyTiles[Tx][0].x+tileSize/2;
      goalY=gameBoard.enemyTiles[0][Ty].y+tileSize/2;
      this.Tx=Tx;
      this.Ty=Ty;
    }
    turnAngle=angleToGoalFixed()/90;
  }
  
  void move(float dist){
    y-=dist*(cos(radians(deg)));
    x+=dist*(sin(radians(deg)));
  }
  
  void turn(float deg){
    this.deg+=deg;
    if(deg>360)deg-=360;
    if(deg<0)deg+=360;
  }
  
  float angleToGoal(){
    float opp = goalY-y;
    float adj = goalX-x;
    float unfixed = (degrees(atan2(opp,adj))+90)-deg;
    while(unfixed>=360){
      unfixed-=360;
    }
    while(unfixed<0){
      unfixed+=360;
    }
    return unfixed;
  }
  
    float angleToGoalFixed(){
    float opp = goalY-y;
    float adj = goalX-x;
    float unfixed = (degrees(atan2(opp,adj))+90)-deg;
    while(unfixed>=360){
      unfixed-=360;
    }
    while(unfixed<0){
      unfixed+=360;
    }
    if(unfixed>=180)unfixed=unfixed-360;
    return unfixed;
  }
  
  float distToGoal(){
    float Y = abs(goalY-y);
    float X = abs(goalX-x);
    return sqrt(pow(X,2)+pow(Y,2));
  }
  
}
