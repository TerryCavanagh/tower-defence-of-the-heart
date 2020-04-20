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
    
    world.loadtiles("ld46tiles", 10, 10);
    
    for (i in 0 ... Gfx.numberoftiles(world.tileset)){
			if(i > 5){
				world.collidable[i] = true;
			}
    }
    
    world.loadcsv("testmap");
    world.getheatmap(GameData.other.endpointx,GameData.other.endpointy);
    world.refreshmap();

    world.monsters = [];
    world.towers = [];
    world.bullets = [];
    world.particles = [];

    inituielements();

    world.towers.push(Entity.create(GameData.other.goalx, GameData.other.goaly, EntityType.GOAL, world));

    timetillnextspawn = 0;
	}
	
	public static function update(){
    var mx:Int = world.gridx(Mouse.x);
    var my:Int = world.gridy(Mouse.y);

    //Show tower cursor
    updatecursor(mx, my);
    
    if(!Game.uipanel.mouseover){
      if(Mouse.leftclick()){
        var toweratcursor:Entity = null;
        for(t in world.towers){
          if(world.gridx(t.x) == mx && world.gridy(t.y) == my){
            toweratcursor = t;
            break;
          }
        }

        if(toweratcursor == null){
          var currenttowercost:Int = 1;
          if(Game.cursormode == ButtonType.SHOOTY){
            currenttowercost = GameData.towers.shooty.cost;
          }else if(Game.cursormode == ButtonType.BEAM){
            currenttowercost = GameData.towers.beam.cost;
          }else if(Game.cursormode == ButtonType.VORTEX){
            currenttowercost = GameData.towers.vortex.cost;
          }else if(Game.cursormode == ButtonType.LASER){
            currenttowercost = GameData.towers.laser.cost;
          }
          Game.cost(currenttowercost, 
          function(){
            if(Game.cursormode == ButtonType.SHOOTY){
              Game.createtower(mx, my, EntityType.TOWER_SHOOTY, world);
            }else if(Game.cursormode == ButtonType.BEAM){
              Game.createtower(mx, my, EntityType.TOWER_BEAM, world);
            }else if(Game.cursormode == ButtonType.VORTEX){
              Game.createtower(mx, my, EntityType.TOWER_VORTEX, world);
            }else if(Game.cursormode == ButtonType.LASER){
              Game.createtower(mx, my, EntityType.TOWER_LASER, world);
            }
          }, function(){
            
          });
        }else{
          var upgradetowercost:Int = 1;
          if(toweratcursor.type == EntityType.TOWER_SHOOTY){
            if(toweratcursor.level == 1) upgradetowercost = GameData.towers.shooty.level1.upgradecost;
            if(toweratcursor.level == 2) upgradetowercost = GameData.towers.shooty.level2.upgradecost;
          }else if(toweratcursor.type == EntityType.TOWER_BEAM){
            if(toweratcursor.level == 1) upgradetowercost = GameData.towers.beam.level1.upgradecost;
            if(toweratcursor.level == 2) upgradetowercost = GameData.towers.beam.level2.upgradecost;
          }else if(toweratcursor.type == EntityType.TOWER_VORTEX){
            if(toweratcursor.level == 1) upgradetowercost = GameData.towers.vortex.level1.upgradecost;
            if(toweratcursor.level == 2) upgradetowercost = GameData.towers.vortex.level2.upgradecost;
          }else if(toweratcursor.type == EntityType.TOWER_LASER){
            if(toweratcursor.level == 1) upgradetowercost = GameData.towers.laser.level1.upgradecost;
            if(toweratcursor.level == 2) upgradetowercost = GameData.towers.laser.level2.upgradecost;
          }
          Game.cost(upgradetowercost, 
          function(){
            Game.upgradetower(toweratcursor);
          }, 
          function(){

          });
        }
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
        Game.createmonster(-1, 2, Waves.currenttype, Waves.enemyhealth, Waves.enemyspeed, world);
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

    if(Input.justpressed(Key.NUMBER_1)){
      Game.cursormode = ButtonType.LASER;
      Game.uipanel.updateallbuttons();
    }else if(Input.justpressed(Key.NUMBER_2)){
      Game.cursormode = ButtonType.BEAM;
      Game.uipanel.updateallbuttons();
    }else if(Input.justpressed(Key.NUMBER_3)){
      Game.cursormode = ButtonType.SHOOTY;
      Game.uipanel.updateallbuttons();
    }else if(Input.justpressed(Key.NUMBER_4)){
      Game.cursormode = ButtonType.VORTEX;
      Game.uipanel.updateallbuttons();
    }
    //UI stuff
    Text.display(0, 0, "Health: " + Game.hp + "/" + Game.maxhp + ", Gold: " + Game.gold);
    Text.display(0, 20, "Wave: " + (Waves.currentwave + 1) + "/" + Waves.waves.length + " (enemies left: " + Waves.enemiesleft + ")");

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

    Game.cursormode = ButtonType.LASER;
    Game.uipanel.updateallbuttons();
  }

  public static function updatecursor(mx:Int, my:Int){
    if(Game.uipanel.mouseover){
      towercursor.visible = false;
    }else{
      switch(Game.cursormode){
        case ButtonType.SHOOTY:
          towercursor.currentFrame = 0;
          towercursor.x = (mx * world.tilewidth);
          towercursor.y = (my * world.tileheight);
          towercursor.visible = true;
        case ButtonType.BEAM:
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
        case ButtonType.VORTEX:
            towercursor.currentFrame = 6;
            towercursor.x = (mx * world.tilewidth);
            towercursor.y = (my * world.tileheight);
            towercursor.visible = true;
        case ButtonType.LASER:
            towercursor.currentFrame = 12;
            towercursor.x = (mx * world.tilewidth);
            towercursor.y = (my * world.tileheight);
            towercursor.visible = true;
        case ButtonType.UPGRADE:
        case ButtonType.SELL:
      }
    }
  }

  public static var towercursor:h2d.Anim;
}