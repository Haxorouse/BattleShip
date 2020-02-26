class LogicTile{
  
  Boolean enemy;
  Boolean hasShip = false;
  Boolean hit = false;
  Boolean miss = false;
  String shipName = "";
  Ship shipAt = null;
  Boolean shipSunk = false;
  final int x;
  final int y;
  
  LogicTile(int x, int y, Boolean enemy){
    this.x=x;
    this.y=y;
    this.enemy=enemy;
  }
  
  Boolean nextTo(int X, int Y){
    if(Y==y && (X==x+1 || X==x-1))return true;
    if(X==x && (Y==y+1 || Y==y-1))return true;
    return false;
  }
  
  void dumpData(){
    println(playerShips.size());
    if(shipAt!=null)println(shipAt.myTiles);
    println(enemy);
    println(hasShip);
    println(hit);
    println(miss);
    if(shipAt!=null)println(shipAt.name);
    println(shipSunk);
    println(x);
    println(y);
  }
  
  void checkIfHasShip(){
    //println("checking");
    if(enemy){
      for(int s=0; s<enemyShips.size(); s++){
        for(int t=0; t<enemyShips.get(s).size; t++){
          if(/*enemyShips.get(s).myTiles[t].x==x && enemyShips.get(s).myTiles[t].y==y*/enemyShips.get(s).myTiles[t]==this){
            hasShip=true;
            shipAt=enemyShips.get(s);
            if(shipAt.sunk)shipSunk=true;
            return;
          }else{
            hasShip=false;
            shipAt=null;
          }
        }
      }
    }else{
      for(int s=0; s<playerShips.size(); s++){
        for(int t=0; t<playerShips.get(s).size; t++){
          if(/*playerShips.get(s).myTiles[t].x==x && playerShips.get(s).myTiles[t].y==y*/playerShips.get(s).myTiles[t]==this){
            hasShip=true;
            shipAt=playerShips.get(s);
            if(shipAt.sunk)shipSunk=true;
            return;
          }else{
            hasShip=false;
            shipAt=null;
          }
        }
      }
    }
  }
  
}
