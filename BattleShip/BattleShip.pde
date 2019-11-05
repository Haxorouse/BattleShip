
Board gameBoard;

ShipButton carrier;
ShipButton battle;
ShipButton destroy;
ShipButton sub;
ShipButton patrol;

//shop buttons
Button btnExitShop;
Button btnBuyGeneral;
Button btnBuyRunway;
Button btnBuyArtillery;
Button btnBuyRailgun;
Button btnBuyComms;
Button btnBuySonar;
Button btnBuyMotor;
Button btnBuyPlane;
Button btnBuyFuel;
Button btnBuyDecoy;

GhostShip placeHold;

Enemy enemy = new Enemy();
Enemy theEnemy = enemy;
Player player = new Player();

ArrayList<Ship> playerShips = new ArrayList<Ship>();
ArrayList<Ship> enemyShips = new ArrayList<Ship>();

ArrayList<Animation> animations = new ArrayList<Animation>();

Boolean placing = false;
Boolean place = false;
Boolean placedCarrier = false;
Boolean placedBattle = false;
Boolean placedDestory = false;
Boolean placedSub = false;
Boolean placedPatrol = false;
Boolean shipsPlaced = false;
Boolean mouseOnPlayerBoard = false;
Boolean mouseOnenemyBoard = false;
Boolean playerTurn = false;
Boolean playerStall = false;
Boolean enemyStall = false;
Boolean gameOn = false;
Boolean playerWon = false;
Boolean enemyWon = false;
Boolean carrierAttack = false;
Boolean destroyerAttack = false;
Boolean patrolAction = false;
Boolean shopOpen = false;

String placerName = "";

int placerSize = 0;
int placeDirection = 0;
int mouseBoardX = -1;
int mouseBoardY = -1;
int tileSize;
int hoverPart = 0;
int playerCredits=0;
int enemyCredits=0;

int frame = 0;

int getShipPosFromName(String name){
  for(int s=0; s<playerShips.size(); s++){
    if(playerShips.get(s).name==name)return s;
  }
  return -1;
}

void setup(){
  size(1600, 900);
  tileSize = width/25;
  gameBoard=new Board();
  carrier = new ShipButton(tileSize, 12*tileSize, "Aircraft Carrier");
  battle = new ShipButton(tileSize, 13*tileSize, "Battle Ship");
  destroy = new ShipButton(tileSize*6, 12*tileSize, "Destroyer");
  sub = new ShipButton(tileSize*5, 13*tileSize, "Submarine");
  patrol = new ShipButton(tileSize*8, 13*tileSize, "Patrol Boat");
  enemy.setupenemy();
  btnExitShop = new Button(1430,750,50,30,"Exit");
  btnBuyGeneral = new Button(300,200,200,50,"Buy Spare Parts");
  btnBuyRunway =new Button(300,260,200,50,"Buy Runway Segment");
  btnBuyArtillery = new Button(300,320,200,50,"Buy Artillery Piece");
  btnBuyRailgun = new Button(300,380,200,50,"Buy Railgun");
  btnBuyComms = new Button(300,440,200,50,"Buy Comms Array");
  btnBuySonar = new Button(300,500,200,50,"Buy Sonar System");
  btnBuyMotor = new Button(300,560,200,50,"Buy Outboard Motor");
  btnBuyPlane = new Button(300,620,200,50,"Buy Fighter Plane");
  btnBuyFuel = new Button(300,680,200,50,"Refuel Carrier");
  btnBuyDecoy = new Button(300,740,200,50,"Buy Decoy Bouy");
}

void draw(){
  gameBoard.drawBoard();
  if(gameOn)enemy.runenemy();
}
