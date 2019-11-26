void mousePressed(){
  //----------------------------------------------
  if(carrier.mouseIsHovering() && !carrier.placed){
    if(carrier.placingThis){
      carrier.placingThis = false;
      placing = false;
      placerSize=0;
      placerName="";
    }else if(!placing){
      carrier.placingThis=true;
      placing = true;
      placerSize=5;
      placerName="Aircraft Carrier";
    }
  }
  //----------------------------------------------
  if(battle.mouseIsHovering() && !battle.placed){
    if(battle.placingThis){
      battle.placingThis = false;
      placing = false;
      placerSize=0;
      placerName="";
    }else if(!placing){
      battle.placingThis=true;
      placing = true;
      placerSize=4;
      placerName="Battle Ship";
    }
  }
  //----------------------------------------------
  if(destroy.mouseIsHovering() && !destroy.placed){
    if(destroy.placingThis){
      destroy.placingThis = false;
      placing = false;
      placerSize=0;
      placerName="";
    }else if(!placing){
      destroy.placingThis=true;
      placing = true;
      placerSize=3;
      placerName="Destroyer";
    }
  }
  //----------------------------------------------
  if(sub.mouseIsHovering() && !sub.placed){
    if(sub.placingThis){
      sub.placingThis = false;
      placing = false;
      placerSize=0;
      placerName="";
    }else if(!placing){
      sub.placingThis=true;
      placing = true;
      placerSize=3;
      placerName="Submarine";
    }
  }
  //----------------------------------------------
  if(patrol.mouseIsHovering() && !patrol.placed){
    if(patrol.placingThis){
      patrol.placingThis = false;
      placing = false;
      placerSize=0;
      placerName="";
    }else if(!placing){
      patrol.placingThis=true;
      placing = true;
      placerSize=2;
      placerName="Patrol Boat";
    }
  }
  //----------------------------------------------
  if(place){
    //playerShips.add(new Ship(placerSize, placeDirection, placerName, false, mouseBoardX, mouseBoardY));
    place=false;
    placing=false;
    if(placerName=="Aircraft Carrier"){
      carrier.place();
      player.carrier = new Carrier(placeDirection, false, mouseBoardX, mouseBoardY);
      playerShips.add(player.carrier);
    }
    if(placerName=="Battle Ship"){
      battle.place();
      player.battle = new Battle(placeDirection, false, mouseBoardX, mouseBoardY);
      playerShips.add(player.battle);
    }
    if(placerName=="Destroyer"){
      destroy.place();
      player.destroyer = new Destroyer(placeDirection, false, mouseBoardX, mouseBoardY);
      playerShips.add(player.destroyer);
    }
    if(placerName=="Submarine"){
      sub.place();
      player.sub = new Sub(placeDirection, false, mouseBoardX, mouseBoardY);
      playerShips.add(player.sub);
    }
    if(placerName=="Patrol Boat"){
      patrol.place();
      player.patrol = new Patrol(placeDirection, false, mouseBoardX, mouseBoardY);
      playerShips.add(player.patrol);
    }
    if(playerShips.size()>=5){
      shipsPlaced = true;
      float rand = random(1);
      if(rand>.5)playerTurn=true;
      gameOn=true;
    }
  }
  //---------------------------------------------------
  //shop buttons
  /*
  Button btnExitShop;
  Button btnBuyGeneral;10
  Button btnBuyRunway;15
  Button btnBuyArtillery;20
  Button btnBuyRailgun;20
  Button btnBuyComms;30
  Button btnBuySonar;30
  Button btnBuyMotor;30
  Button btnBuyPlane;20
  Button btnBuyFuel;
  Button btnBuyDecoy;10
  */
  if(shopOpen){
    int howMuchFuel;
    howMuchFuel=50-player.carrier.fuel;
    if(howMuchFuel>playerCredits)howMuchFuel=playerCredits;
    if(btnExitShop.mouseIsHovering()){
      shopOpen=false;
      playerStall=false;
    }
    if(btnBuyGeneral.mouseIsHovering() && playerCredits>=10){
      playerCredits-=10;
      player.inv[0]++;
      shopOpen=false;
      playerTurn=false;
    }
    if(btnBuyRunway.mouseIsHovering() && playerCredits>=15){
      playerCredits-=15;
      player.inv[1]++;
      shopOpen=false;
      playerTurn=false;
    }
    if(btnBuyArtillery.mouseIsHovering() && playerCredits>=20){
      playerCredits-=20;
      player.inv[2]++;
      shopOpen=false;
      playerTurn=false;
    }
    if(btnBuyRailgun.mouseIsHovering() && playerCredits>=20){
      playerCredits-=20;
      player.inv[3]++;
      shopOpen=false;
      playerTurn=false;
    }
    if(btnBuyComms.mouseIsHovering() && playerCredits>=30){
      playerCredits-=30;
      player.inv[4]++;
      shopOpen=false;
      playerTurn=false;
    }
    if(btnBuySonar.mouseIsHovering() && playerCredits>=30){
      playerCredits-=30;
      player.inv[5]++;
      shopOpen=false;
      playerTurn=false;
    }
    if(btnBuyMotor.mouseIsHovering() && playerCredits>=30){
      playerCredits-=30;
      player.inv[6]++;
      shopOpen=false;
      playerTurn=false;
    }
    if(btnBuyPlane.mouseIsHovering() && playerCredits>=20){
      playerCredits-=20;
      player.carrier.squad.add(new LogicPlane(4, false));
      shopOpen=false;
      playerTurn=false;
    }
    if(btnBuyFuel.mouseIsHovering() && howMuchFuel>=0){
      playerCredits-=howMuchFuel;
      player.carrier.fuel+=howMuchFuel;
      shopOpen=false;
      playerTurn=false;
    }
    if(btnBuyDecoy.mouseIsHovering() && playerCredits>=10){
      playerCredits-=10;
      player.patrol.decoys++;
      shopOpen=false;
      playerTurn=false;
    }
  }
  //----------------------------------------------
  if(gameOn && playerTurn && mouseOnenemyBoard && (!playerStall || carrierAttack || destroyerAttack)){
    if(!carrierAttack && !destroyerAttack)gameBoard.tryFire(mouseBoardX, mouseBoardY, true);
    if(carrierAttack || destroyerAttack)gameBoard.enemyTiles[mouseBoardX][mouseBoardY].pressed=true;
  }
  if(gameOn && playerTurn && mouseOnPlayerBoard && patrolAction){
    if(patrolAction)gameBoard.playerTiles[mouseBoardX][mouseBoardY].pressed=true;
  }
  //----------------------------------------------
  if(mouseOnPlayerBoard && playerTurn){
    if(mouseButton==39){
      for(int s=0; s<playerShips.size(); s++){
        if(playerShips.get(s).mouseOnMe())playerShips.get(s).openDropDown(hoverPart);
      }
    }
  }
}

void mouseReleased(){
  if(mouseOnPlayerBoard){
    Tile tile=gameBoard.playerTiles[mouseBoardX][mouseBoardY];
    if(tile.pressed)tile.pressed=false;
  }
}

void mouseWheel(MouseEvent e){
  float turn=e.getCount();
  if(turn>0){
    placeDirection++;
  }else if(turn<0){
    placeDirection--;
  }
  if(placeDirection<0)placeDirection=3;
  if(placeDirection>3)placeDirection=0;
}
