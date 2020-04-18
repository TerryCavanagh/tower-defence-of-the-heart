import hashagon.*;
import engine.*;
import hxd.Key;

class TestLevel{
  public static var leveltime:Float;
  public static var firstcall:Bool = true;
  public static function init(){
		if(firstcall){
			firstcall = false;
		}
		
		world = new World();
    
    Gfx.loadtiles("enemy1", 8, 8);

    world.loadtiles("ld46tiles", 8, 8);
    world.setcollidable([0]);
    world.loadcsv("testmap");
    world.getheatmap(35,4);
    world.refreshmap();

    entities = [];

    leveltime = 0;
    spawnrate = 1;
    timetillnextspawn = 0;
	}
	
	public static function update(){
    timetillnextspawn -= Core.deltatime;
    if(timetillnextspawn <= 0){
      timetillnextspawn = spawnrate;
      //Create a new enemy at the entrance!
      entities.push(Entity.create(-1, 9, EntityType.ENEMY1, world));
    }

    world.render();
    
    for(e in entities){
      e.update();
      e.render();
    }

    leveltime += hxd.Timer.dt;
  }
  
	public static function cleanup(){

  }
  
  public static var world:World;
  public static var entities:Array<Entity>;

  public static var spawnrate:Float;
  public static var timetillnextspawn:Float;
}