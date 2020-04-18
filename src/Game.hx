import hashagon.*;
import hashagon.displayobject.*;
import engine.*;

class Game{
  public static function createtower(x:Int, y:Int, type:EntityType, w:World){
    w.towers.push(Entity.create(9, 3, EntityType.TOWER1, w));
  }

  public static function createmonster(x:Int, y:Int, type:EntityType, w:World){
    w.monsters.push(Entity.create(-1, 2, EntityType.ENEMY1, w));
  }

  public static function initlayers(){
    //Let's set up some layers to easily control draw order!
    backgroundlayer = new h2d.Object();
    monsterlayer = new h2d.Object();
    towerlayer = new h2d.Object();
    uilayer = new h2d.Object();
    
    Gfx.core.s2d.addChild(Game.backgroundlayer);
    Gfx.core.s2d.addChild(Game.monsterlayer);
    Gfx.core.s2d.addChild(Game.towerlayer);
    Gfx.core.s2d.addChild(Game.uilayer);
  }

  public static var backgroundlayer:h2d.Object;
  public static var monsterlayer:h2d.Object;
  public static var towerlayer:h2d.Object;
  public static var uilayer:h2d.Object;
}