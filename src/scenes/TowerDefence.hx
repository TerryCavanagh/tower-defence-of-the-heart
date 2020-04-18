package scenes;

import hashagon.*;
import engine.*;
import hxd.Key;

class TowerDefence{
  public static var leveltime:Float;
  public static var firstcall:Bool = true;
  public static function init(){
		if(firstcall){
      firstcall = false;
      Game.initlayers();
		}
		
    world = new World();
    Game.reset();
    
    Gfx.loadtiles("enemies", 10, 10);
    Gfx.loadtiles("towers", 10, 10);
    Gfx.loadtiles("particles", 10, 10);
    Gfx.gettileset("particles").pivot(Text.CENTER);
    Gfx.loadtiles("goal", 30, 30);

    world.loadtiles("ld46tiles", 10, 10);
    world.setcollidable([0]);
    world.loadcsv("testmap");
    world.getheatmap(20,8);
    world.refreshmap();

    world.monsters = [];
    world.towers = [];
    world.bullets = [];
    world.particles = [];

    inituielements();

    world.towers.push(Entity.create(21, 7, EntityType.GOAL, world));

    leveltime = 0;
    spawnrate = 1.6;
    timetillnextspawn = 0;
	}
	
	public static function update(){
    var mx:Int = world.gridx(Mouse.x);
    var my:Int = world.gridy(Mouse.y);

    //Show tower cursor
    towercursor.x = mx * world.tilewidth;
    towercursor.y = my * world.tileheight;
    towercursor.visible = true;

    if(Mouse.leftclick()){
      Game.createtower(mx, my, EntityType.TOWER1, world);
    }

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

    //UI stuff
    Text.display(0, 0, "Health: " + Game.hp + "/" + Game.maxhp);

    leveltime += hxd.Timer.dt;
  }
  
	public static function cleanup(){
    for(monster in world.monsters){
      monster.destroy();
    }

    for(tower in world.towers){
      tower.destroy();
    }

    for(bullet in world.bullets){
      bullet.destroy();
    }
    
    for(particle in world.particles){
      particle.destroy();
    }

    world.destroy();
  }
  
  public static var world:World;

  public static var spawnrate:Float;
  public static var timetillnextspawn:Float;

  public static function inituielements(){
    towercursor = new h2d.Anim(Gfx.gettileset("towers").tiles, 0);
    towercursor.alpha = 0.4;
    towercursor.visible = false;
    Game.uilayer.addChild(towercursor);
  }

  public static var towercursor:h2d.Anim;
}