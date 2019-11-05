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
