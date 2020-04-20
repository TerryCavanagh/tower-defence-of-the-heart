import hxd.snd.WavData;
import hashagon.*;
import engine.*;

class TowerCursor extends h2d.Object{
  public function new(){
    super();
    //Three layered cursor that depends on context: the block below,
    //the tower below, and an icon. 
    block = new h2d.Anim(Gfx.gettileset("ld46tiles").tiles, 0, this);
    icon = new h2d.Anim(Gfx.gettileset("towers").tiles, 0, this);
    tower = new h2d.Anim(Gfx.gettileset("towers").tiles, 0, this);

    dropshadow = new h2d.Graphics(this);
    dropshadow.x = -12;
    dropshadow.y = -12;
    dropshadow.beginFill(Col.multiplylightness(Col.GREEN, 0.75));
    dropshadow.drawRect(0, 0, 32, 12);
    dropshadow.endFill();

    info = new h2d.Text(Game.numberfont, this);
    info.x = 5;
    info.y = -10;
    info.textAlign = Center;
    info.text = "";

    block.visible = false;
    tower.visible = false;
    icon.visible = false;
    info.visible = false;
    dropshadow.visible = false;
  }

  public function canplacetower(mx:Int, my:Int, w:World):Bool{
    if(w.canplacetower[w.contents[mx][my]]){
      return true;
    }
    return false;
  }

  public function changeto(t:String, mx:Int, my:Int, w:World, toweratcursor:Entity){
    hide();

    x = (mx * w.tilewidth);
    y = (my * w.tileheight);
    block.x = 0;
    icon.x = 0;
    tower.x = 0;

    var towerisnull:Bool = false;
    var canplacetower:Bool = canplacetower(mx, my, w);
    if(toweratcursor == null){
      towerisnull = true;
    }else{
      if(toweratcursor.destroyed) towerisnull = true;
    }

    if(t == "sell"){
      if(towerisnull){
        //Don't show the block or the tower, just the icon
        icon.currentFrame = 47; icon.visible = true;
        icon.alpha = 0.4;
      }else{
        //Don't show the block or the tower, just the icon
        icon.currentFrame = 47; icon.visible = true;
        icon.alpha = 0.8;

        info.text = "$" + Game.getrefundvalue(toweratcursor);
        info.textColor = Col.YELLOW;
        info.visible = true;
        dropshadow.visible = true;
      }
    }else{
      if(towerisnull && canplacetower){
        if(t == "laser"){
          if(Game.gold < GameData.towers.laser.cost){
            block.currentFrame = w.contents[mx][my]; block.visible = true;
            icon.currentFrame = 45; icon.visible = true;
            icon.alpha = 0.4;
            
            info.text = "$" + GameData.towers.laser.cost;
            info.textColor = Col.multiplylightness(Col.GREEN, 0.5);
            info.visible = true;
            dropshadow.visible = true;
          }else{
            block.currentFrame = w.contents[mx][my]; block.visible = true;
            icon.currentFrame = 44; icon.visible = true;
            icon.alpha = 0.4;
          }
          
          tower.currentFrame = 12; tower.visible = true;
          tower.alpha = 0.8;
        }else if(t == "beam"){
          if(Game.gold < GameData.towers.beam.cost){
            block.currentFrame = w.contents[mx][my]; block.visible = true;
            icon.currentFrame = 45; icon.visible = true;
            icon.alpha = 0.4;
            
            info.text = "$" + GameData.towers.beam.cost;
            info.textColor = Col.multiplylightness(Col.GREEN, 0.5);
            info.visible = true;
            dropshadow.visible = true;
          }else{
            block.currentFrame = w.contents[mx][my]; block.visible = true;
            icon.currentFrame = 44; icon.visible = true;
            icon.alpha = 0.4;
          }

          var dir:Direction = Game.towerdirection(mx, my, w);
          switch(dir){
            case Direction.LEFT: tower.currentFrame = 18;
            case Direction.RIGHT: tower.currentFrame = 24;
            case Direction.UP: tower.currentFrame = 30;
            case Direction.DOWN: tower.currentFrame = 36;
          }
          
          tower.visible = true;
          tower.alpha = 0.8;
        }else if(t == "shooty"){
          if(Game.gold < GameData.towers.shooty.cost){
            block.currentFrame = w.contents[mx][my]; block.visible = true;
            icon.currentFrame = 45; icon.visible = true;
            icon.alpha = 0.4;
            
            info.text = "$" + GameData.towers.shooty.cost;
            info.textColor = Col.multiplylightness(Col.GREEN, 0.5);
            info.visible = true;
            dropshadow.visible = true;
          }else{
            block.currentFrame = w.contents[mx][my]; block.visible = true;
            icon.currentFrame = 44; icon.visible = true;
            icon.alpha = 0.4;
          }
    
          tower.currentFrame = 0; tower.visible = true;
          tower.alpha = 0.8;
        }else if(t == "vortex"){
          if(Game.gold < GameData.towers.vortex.cost){
            block.currentFrame = w.contents[mx][my]; block.visible = true;
            icon.currentFrame = 45; icon.visible = true;
            icon.alpha = 0.4;
            
            info.text = "$" + GameData.towers.vortex.cost;
            info.textColor = Col.multiplylightness(Col.GREEN, 0.5);
            info.visible = true;
            dropshadow.visible = true;
          }else{
            block.currentFrame = w.contents[mx][my]; block.visible = true;
            icon.currentFrame = 44; icon.visible = true;
            icon.alpha = 0.4;
          }
    
          tower.currentFrame = 6; tower.visible = true;
          tower.alpha = 0.8;
        }else if(t == "upgrade"){
          //Don't show the block or the tower, just the icon
          icon.currentFrame = 46; icon.visible = true;
          icon.alpha = 0.4;
        }else{
          throw(t + " not found in TowerCursor");
        }
      }else{
        if(t == "laser"){
          icon.currentFrame = 45; icon.visible = true;
          icon.alpha = 0.8;
        }else if(t == "beam"){
          icon.currentFrame = 45; icon.visible = true;
          icon.alpha = 0.8;
        }else if(t == "shooty"){
          icon.currentFrame = 45; icon.visible = true;
          icon.alpha = 0.8;
        }else if(t == "vortex"){
          icon.currentFrame = 45; icon.visible = true;
          icon.alpha = 0.8;
        }else if(t == "upgrade"){
          //Don't show the block or the tower, just the icon
          icon.currentFrame = 46; icon.visible = true;
          if(canplacetower){
            if(toweratcursor.level >= 3){
              icon.alpha = 0.4;

              info.text = "MAX";
              info.textColor = Col.WHITE;
              info.visible = true;
              dropshadow.visible = true;
            }else{
              icon.alpha = 0.8;
              
              info.text = "$" + Game.getupgradecost(toweratcursor);
              info.textColor = Col.WHITE;
              info.visible = true;
              dropshadow.visible = true;
            }
          }else{
            icon.alpha = 0.4;
          }
        }else{
          throw(t + " not found in TowerCursor");
        }
      }
    }
  }

  public function hide(){
    block.visible = false;
    tower.visible = false;
    icon.visible = false;
    info.visible = false;
    dropshadow.visible = false;
  }
  
  public var block:h2d.Anim;
  public var icon:h2d.Anim;
  public var tower:h2d.Anim;
  public var info:h2d.Text;
  public var dropshadow:h2d.Graphics;
}