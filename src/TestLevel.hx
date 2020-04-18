import hashagon.*;
import engine.*;
import hxd.Key;

class TestLevel{
  public static var leveltime:Float;
  public static var firstcall:Bool = true;
  public static function init(){
		if(firstcall){
      firstcall = false;
      Game.initlayers();
		}
		
		world = new World();
    
    Gfx.loadtiles("enemies", 10, 10);
    Gfx.loadtiles("towers", 10, 10);
    Gfx.loadtiles("particles", 10, 10);
    Gfx.gettileset("particles").pivot(Text.CENTER);

    world.loadtiles("ld46tiles", 10, 10);
    world.setcollidable([0]);
    world.loadcsv("testmap");
    world.getheatmap(20,8);
    world.refreshmap();

    world.monsters = [];
    world.towers = [];
    world.bullets = [];
    world.particles = [];

    Game.createtower(10, 6, EntityType.TOWER1, world);
    Game.createtower(13, 14, EntityType.TOWER1, world);

    leveltime = 0;
    spawnrate = 1.6;
    timetillnextspawn = 0;
	}
	
	public static function update(){
    timetillnextspawn -= Core.deltatime;
    if(timetillnextspawn <= 0){
      timetillnextspawn = spawnrate;
      //Create a new enemy at the entrance!
      Game.createmonster(-1, 2, EntityType.ENEMY1, world);
    }

    world.render();
    
    for(monster in world.monsters){
      monster.update();
      monster.render();
    }

    for(tower in world.towers){
      tower.update();
      tower.render();
    }

    for(bullet in world.bullets){
      bullet.update();
      bullet.render();
    }
    
    for(particle in world.particles){
      particle.update();
      particle.render();
    }

    //TO DO: clean up destroyed entities somewhere

    leveltime += hxd.Timer.dt;
  }
  
	public static function cleanup(){

  }
  
  public static var world:World;

  public static var spawnrate:Float;
  public static var timetillnextspawn:Float;
}