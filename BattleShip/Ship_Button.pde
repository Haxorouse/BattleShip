class ShipButton extends Button {
  
  String name = "";
  int length;
  Boolean placingThis = false;
  Boolean placed = false;
  
  ShipButton(int x, int y, String name){
    super(x,y,tileSize,tileSize,"");
    this.name=name;
    w=tileSize*findLength(name);
  }
  
  int findLength(String name){
    if(name=="Aircraft Carrier") return 5;
    if(name=="Battle Ship") return 4;
    if(name=="Destroyer" || name=="Submarine") return 3;
    if(name=="Patrol Boat") return 2;
    return 0;
  }
  
  void place(){
    placingThis=false;
    placed=true;
  }
  
  void drawButton(){
    pushMatrix();
    translate(x,y);
    if(((mouseIsHovering() && !placing) || placingThis) && !placed){
      scale(1.2,1.2);
      translate(-w*.1,-h*.1);
    }
    if(name=="Aircraft Carrier"){
      pushMatrix();
        rotate(-PI/2);
        carrierSprite();
      popMatrix();
    }else if(name=="Battle Ship"){
      pushMatrix();
        rotate(-PI/2);
        battleSprite();
      popMatrix();
    }else if(name=="Destroyer"){
      pushMatrix();
        rotate(-PI/2);
        destroySprite();
      popMatrix();
    }else if(name=="Submarine"){
      pushMatrix();
        rotate(-PI/2);
        subSprite();
      popMatrix();
    }else if(name=="Patrol Boat"){
      pushMatrix();
        rotate(-PI/2);
        patrolSprite();
      popMatrix();
    }
    popMatrix();
  }
  
}
