class Player{
  
  String[] invRef = {"generalSpareParts", "runway", "artilery", "railGun", "commsArray", "sonar", "motor"};
  int[] inv = {0, 0, 0, 0, 0, 0, 0};
  
  ArrayList<LogicTile> scans = new ArrayList<LogicTile>();
  ArrayList<LogicTile> thinkHit = new ArrayList<LogicTile>();
  ArrayList<LogicTile> thinkMiss = new ArrayList<LogicTile>();
  
  Battle battle;
  Destroyer destroyer;
  Carrier carrier;
  Sub sub;
  Patrol patrol;
  
  ArrayList<Plane> squadron = new ArrayList<Plane>();
  
  Player(){
    
  }
  
  
}
