import engine.*;
import hashagon.*;

class QuickSave{
  public static function quicksave(world:World){
    var savestring:String = "";
    savestring += Waves.currentwave + ",";
    savestring += Game.gold + ",";
    savestring += (world.towers.length - 1) + ",";
    for(tower in world.towers){
      if(tower.type != EntityType.GOAL){
        savestring += world.gridx(tower.x) + ",";
        savestring += world.gridy(tower.y) + ",";
        savestring += tower.type + ",";
        savestring += tower.level + ",";
      }
    }
    trace(savestring);
  }

  public static function quickload(world:World){
    var loadstring:String = 
    "18,2000,0";
    
    for(monster in world.monsters){
      monster.destroy();
    }

    for(tower in world.towers){
      tower.destroy();
    }

    var v:Array<String> = loadstring.split(",");
    v.reverse();
    Waves.currentwave = Std.parseInt(v.pop());
    Waves.enemiesleft = 1;
    Game.gold = Std.parseInt(v.pop());

    var numtowers:Int = Std.parseInt(v.pop());
    world.towers.push(Entity.create(GameData.other.goalx, GameData.other.goaly, EntityType.GOAL, world));
    for(i in 0 ... numtowers){
      var towerx:Int = Std.parseInt(v.pop());
      var towery:Int = Std.parseInt(v.pop());
      var towertype:String = v.pop();
      var towertype_enum:EntityType = null;
      switch(towertype){
        case "TOWER_SHOOTY": towertype_enum = EntityType.TOWER_SHOOTY;
        case "TOWER_BEAM": towertype_enum = EntityType.TOWER_BEAM;
        case "TOWER_LASER": towertype_enum = EntityType.TOWER_LASER;
        case "TOWER_VORTEX": towertype_enum = EntityType.TOWER_VORTEX;
      }
      var towerlevel:Int = Std.parseInt(v.pop());
      Game.createtower(towerx, towery, towertype_enum, world, towerlevel);
    }
  }
}