class Tile extends Button{
  
  String ship = "";
  Boolean damaged = false;
  Boolean pressed = false;
  color lines = color(0);
  int thickness = 1;
  
  Tile(int x, int y){
    super(x, y, width/25, width/25, "");
  }
  
  void drawButton(){
    noFill();
    stroke(lines);
    strokeWeight(thickness);
    rect(x, y, w, h);
    if(mouseIsHovering() && mousePressed && !placing &&!shopOpen){
        highlightTile(x,y,75);
        press=true;
      }else if(mouseIsHovering() && !placing && !shopOpen){
        highlightTile(x,y,50);
      }
    if(!mouseIsHovering())pressed=false;
  }
  
  void highlightTile(int x, int y, int level){
    fill(255,255,255,level);
    noStroke();
    rect(x,y,w,h);
  }
  
  void highlightTile(int level){
    fill(255,255,255,level);
    noStroke();
    rect(x,y,w,h);
  }
  
  void highlightTile(int level, color Color){
    fill(Color,level);
    noStroke();
    rect(x,y,w,h);
  }
  
}
