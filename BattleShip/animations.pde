class Animation {
  float X;
  float Y;
  
  Animation(){
    
  }
  
  void run(){
    
  }
  
}

class Boom extends Animation{

  int timer=0;
  
  Boom(float x, float y){
    X = x;
    Y = y;
  }

  Boom(Tile tile){
    X=tile.x+(tileSize/2);
    Y=tile.y+(tileSize/2);
  }

  Boom(LogicTile tile){
    if(tile.enemy){
      X=gameBoard.enemyTiles[tile.x][tile.y].x+(tileSize/2);
      Y=gameBoard.enemyTiles[tile.x][tile.y].y+(tileSize/2);
    }else{
      X=gameBoard.playerTiles[tile.x][tile.y].x+(tileSize/2);
      Y=gameBoard.playerTiles[tile.x][tile.y].y+(tileSize/2);
    }
  }
  
  void run(){
    fill(255,125,0, 1000-((1000/(2*tileSize))*timer));
    noStroke();
    ellipse(X, Y, timer, timer);
    timer++;
    if(timer>=2*tileSize)animations.remove(this);
  }
  
}

class Splash extends Boom{
  
  Splash(float x, float y){
    super(x, y);
  }
  
  Splash(Tile tile){
    super(tile);
  }
  
  Splash(LogicTile tile){
    super(tile);
  }
  
  void run(){
    noFill();
    strokeWeight(timer/(tileSize/10));
    if(timer<tileSize/2){
      stroke(0+timer*(400/tileSize),0+timer*(400/tileSize),255);
      ellipse(X, Y, timer, timer);
    }else{
      stroke(400-timer*(400/tileSize), 400-timer*(400/tileSize), 255);
      ellipse(X, Y, timer, timer);
    }
    timer++;
    if(timer>=tileSize)animations.remove(this);
  }
  
}

class Hit extends Animation{
  
  ArrayList<Fire> flames = new ArrayList<Fire>();
  Boolean hide = true;
  
  Hit(int x, int y){
    X=x;
    Y=y;
  }
  
  void run(){
    for(int f=flames.size()-1; f>=0; f--){
      flames.get(f).drawFire();
      if(flames.get(f).size<=0)flames.remove(f);
    }
    if(random(3)<1 && !hide){
      flames.add(new Fire((int)(X+random(5,tileSize-5)),(int)(Y+random(5,tileSize-5)),(int)random(1,21)));
    }
  }
  
}

class Fire{
  
  int x;
  int y;
  float size;
  Smoke smoke;
  
  Fire(int x, int y, int size){
    this.x=x;
    this.y=y;
    this.size=size;
    smoke=new Smoke(x,y,size);
  }
  
  void drawFire(){
    fill(255,50,0);
    strokeWeight(1);
    stroke(255,150,50);
    ellipse(x,y,size,size);
    size-=.1;
    smoke.drawSmoke();
  }
  
}

class Smoke{
  
  int x;
  int y;
  int size;
  float opac;
  
  Smoke(int x, int y, float size){
    this.x=x;
    this.y=y;
    this.size=(int)size;
    opac=size*15;
  }
  
  void drawSmoke(){
    fill(120,opac);
    stroke(70,opac);
    ellipse(x,y,size,size);
    size++;
    opac-=2;
    x++;
    y-=2;
  }
  
}
