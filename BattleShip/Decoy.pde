class Decoy extends Ship{
  
  Decoy(Boolean enemy, int x, int y){
    super(1, 0, "Decoy", enemy, x, y);
  }
  
  void shipDraw(){
    if(!invis){
      decoySprite();
    }
  }
  
}
