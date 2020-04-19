import haxe.Constraints.Function;
import hashagon.*;
import hashagon.displayobject.*;
import engine.*;
import motion.Actuate;
import motion.easing.*;

class Game{
  public static function reset(){
    maxhp = 5;
    hp = maxhp;

    gold = 10;
  }

  public static var hp:Int;
  public static var maxhp:Int;
  public static var gold:Int;

  public static function upgradetower(tower:Entity){
    if(tower.type == EntityType.TOWER1){
      if(tower.level == 1){
        tower.sprite.currentFrame++;
        tower.bulletdamage = 2;
        tower.targetradius += 8;
        tower.level = 2;

        tower.updatetowerradius();
      }else if(tower.level == 2){
        tower.sprite.currentFrame++;
        tower.bulletdamage = 4;
        tower.targetradius += 8;
        tower.level = 3;

        tower.updatetowerradius();
      }
    }
  }

  public static function createtower(x:Int, y:Int, type:EntityType, w:World){
    w.towers.push(Entity.create(x, y, EntityType.TOWER1, w));
  }

  public static function createmonster(x:Int, y:Int, type:EntityType, hp:Int, w:World){
    var enemy:Entity = Entity.create(-1, 4, EntityType.ENEMY1, w);
    enemy.maxhp = hp;
    enemy.hp = enemy.maxhp;

    w.monsters.push(enemy);
  }

  public static function createbullet(tower:Entity, monster:Entity){
    var w:World = tower.world;

    var newbullet:Entity = Entity.create(w.gridx(tower.x), w.gridy(tower.y), EntityType.BULLET1, w);

    Actuate.tween(newbullet, 0.4, {animpercent: 1.0})
     .onUpdate(function(){
       //start point tower, end point monster
       //x: monster.x, y: monster.y
       newbullet.x = Geom.lerp(tower.x, monster.x, newbullet.animpercent);
       newbullet.y = Geom.lerp(tower.y, monster.y, newbullet.animpercent);
     })
     .ease(Back.easeIn)
     .onComplete(function(){
       //Destory the bullet
       newbullet.shrinkdestroy();
       //Damage the enemy
       monster.damageenemy(tower.bulletdamage);
     });

    w.bullets.push(newbullet);
  }

  /* Pick a target for tower based on range etc */
  public static function picktarget(tower:Entity) {
    var possibletargets:Array<Entity> = [];

    for(monster in tower.world.monsters){
      if(!monster.destroyed){
        if(Geom.distance(
            monster.x + monster.centerx, monster.y + monster.centery, 
            tower.x + tower.centerx, tower.y + tower.centery) <= tower.targetradius){
          possibletargets.push(monster);
          break; //Let's literally just take the first one and see how well that works out
        }
      }
    }

    if(possibletargets.length > 0){
      tower.targetentity = Random.pick(possibletargets);
    }else{
      tower.targetentity = null;
    }
  }

  public static function initlayers(){
    //Let's set up some layers to easily control draw order!
    backgroundlayer = new h2d.Object();
    monsterlayer = new h2d.Object();
    towerlayer = new h2d.Object();
    bulletlayer = new h2d.Object();
    uilayer = new h2d.Object();
    
    Gfx.core.s2d.addChild(Game.backgroundlayer);
    Gfx.core.s2d.addChild(Game.towerlayer);
    Gfx.core.s2d.addChild(Game.monsterlayer);
    Gfx.core.s2d.addChild(Game.bulletlayer);
    Gfx.core.s2d.addChild(Game.uilayer);
  }

  public static function monsterreachestheend(monster:Entity){
    hp--;
    monster.destroy();

    if(hp <= 0){
      Scene.change("gameover");
    }
  }

  public static function cost(g:Int, success:Function, fail:Function){
    if(gold >= g){
      gold -= g;
      success();
    }else{
      fail();
    }
  }

  public static var backgroundlayer:h2d.Object;
  public static var monsterlayer:h2d.Object;
  public static var bulletlayer:h2d.Object;
  public static var towerlayer:h2d.Object;
  public static var uilayer:h2d.Object;
}