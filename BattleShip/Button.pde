class Button{
  int x;
  int y;
  int w;
  int h;
  String title;
  
  Boolean press = false;
  
  Button(int x, int y, int w, int h, String title){
    this.x =x;
    this.y =y;
    this.w =w;
    this.h =h;
    this.title =title;
    
  }
    
    void drawButton(){
      color c = color(240);
      stroke(0);
      strokeWeight(1);
      if(mouseIsHovering() && mousePressed){
        c = color(180);
        stroke(0,0,155);
        strokeWeight(3);
        press=true;
      }else if(mouseIsHovering()){
        c = color(235);
        stroke(0,0,155);
        strokeWeight(2);
      }else{
        press=false;
      }
      /*
      TODO change button apperence when mouse hovers
      */
      pushMatrix();
      translate(x,y);
      fill(c);
      rect(0,0,w,h,w/13+h/13);
      fill(0);
      textSize(12);
      textAlign(CENTER,CENTER);
      text(title,w/2,h/2);
      popMatrix();
      stroke(0);
      strokeWeight(1);
    }
  
    boolean mouseIsHovering(){
      if(mouseX>=x && mouseX<x+w && mouseY>=y && mouseY<y+h){
       return true; 
      }else{
      return false;
      }
    }
  
}
