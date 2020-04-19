package scenes;

import hashagon.*;
import engine.*;
import hxd.Key;

class TowerDefence{
  public static var firstcall:Bool = true;
  public static function init(){
		if(firstcall){
      firstcall = false;
      Game.initlayers();
		}
		
    world = new World();
    Game.reset();
    Waves.init();
    Waves.nextwave();
    
    Gfx.loadtiles("enemies", 10, 10);
    Gfx.loadtiles("towers", 10, 10);
    Gfx.loadtiles("particles", 10, 10);
    Gfx.gettileset("particles").pivot(Text.CENTER);
    Gfx.loadtiles("goal", 30, 30);

    world.loadtiles("ld46tiles", 10, 10);
    
    for (i in 0 ... Gfx.numberoftiles(world.tileset)){
			if(i > 5){
				world.collidable[i] = true;
			}
    }
    
    world.loadcsv("testmap");
    world.getheatmap(20,8);
    world.refreshmap();

    world.monsters = [];
    world.towers = [];
    world.bullets = [];
    world.particles = [];

    inituielements();

    world.towers.push(Entity.create(19, 3, EntityType.GOAL, world));

    timetillnextspawn = 0;
	}
	
	public static function update(){
    var mx:Int = world.gridx(Mouse.x);
    var my:Int = world.gridy(Mouse.y);

    //Show tower cursor
    updatecursor(mx, my);
    
    if(Mouse.leftclick()){
      var toweratcursor:Entity = null;
      for(t in world.towers){
        if(world.gridx(t.x) == mx && world.gridy(t.y) == my){
          toweratcursor = t;
          break;
        }
      }

      if(toweratcursor == null){
        Game.cost(3, 
        function(){
          if(cursormode == CursorMode.PLACETOWER_SHOOTY){
            Game.createtower(mx, my, EntityType.TOWER_SHOOTY, world);
          }else if(cursormode == CursorMode.PLACETOWER_BEAM){
            Game.createtower(mx, my, EntityType.TOWER_BEAM, world);
          }
        }, function(){
          
        });
      }else{
        Game.cost(5, 
        function(){
          Game.upgradetower(toweratcursor);
        }, 
        function(){

        });
      }
    }

    if(Input.justpressed(Key.SPACE)){
      if(!Waves.finalwave()){
        Waves.nextwave();
      }
    }

    timetillnextspawn -= Core.deltatime;
    if(timetillnextspawn <= 0){
      timetillnextspawn = Waves.spawnrate;
      if(Waves.enemiesleft > 0){
        //Create a new enemy at the entrance!
        Game.createmonster(-1, 2, Waves.currenttype, Waves.enemyhealth, world);
        Waves.enemiesleft--;
      }
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
    //Text.display(0, 0, "Health: " + Game.hp + "/" + Game.maxhp + ", Gold: " + Game.gold);
    //Text.display(0, 20, "Wave: " + (Waves.currentwave + 1) + "/" + Waves.waves.length + " (enemies left: " + Waves.enemiesleft + ")");

    Game.updatetimers();
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
    towercursor.currentFrame = 18;
    towercursor.alpha = 0.4;
    towercursor.visible = false;
    Game.uilayer.addChild(towercursor);

    cursormode = CursorMode.PLACETOWER_BEAM;
  }

  public static function updatecursor(mx:Int, my:Int){
    switch(cursormode){
      case CursorMode.PLACETOWER_SHOOTY:
        towercursor.currentFrame = 0;
        towercursor.x = (mx * world.tilewidth);
        towercursor.y = (my * world.tileheight);
        towercursor.visible = true;
      case CursorMode.PLACETOWER_BEAM:
        var dir:Direction = Game.towerdirection(mx, my, world);
        switch(dir){
          case Direction.LEFT: towercursor.currentFrame = 18;
          case Direction.RIGHT: towercursor.currentFrame = 24;
          case Direction.UP: towercursor.currentFrame = 30;
          case Direction.DOWN: towercursor.currentFrame = 36;
        }
        
        towercursor.x = (mx * world.tilewidth);
        towercursor.y = (my * world.tileheight);
        towercursor.visible = true;
    }
  }

  public static var towercursor:h2d.Anim;
  public static var cursormode:CursorMode;
}