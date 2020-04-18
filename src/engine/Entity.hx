package engine;

import hashagon.*;
import hashagon.displayobject.*;
import motion.*;

class Entity{
  //Static functions
  public static function create(x:Int, y:Int, type:EntityType, w:World):Entity{
    var e:Entity = new Entity();
    e.x = x * w.tilewidth;
    e.y = y * w.tileheight;
    e.type = type;
    e.world = w;
    e.inittype();

    //Almost everything is a tile in size
    e.centerx = w.tilewidth / 2;
    e.centery = w.tileheight / 2;

    e.destroyed = false;

    return e;
  }

  //Class functions
  public function new(){
    sprite = null;
    primative = null;


    animpercent = 0;

    //Tower stuff
    targetradius = 0;
    firerate = 0;
    timetillnextshot = 0;
    bulletdamage = 0;
  }

  public function inittype(){
    switch(type){
      case ENEMY1:
        var tileset:Tileset = Gfx.gettileset("enemies");
        sprite = new h2d.Anim(tileset.tiles, 0);
        sprite.x = x;
        sprite.y = y;
        Game.monsterlayer.addChild(sprite);

        speed = 0.4;
        direction = Direction.RIGHT;
      case TOWER1:
        firerate = 0.8;
        timetillnextshot = 0;
        targetradius = 64;
        bulletdamage = 1;

        var tileset:Tileset = Gfx.gettileset("towers");
        sprite = new h2d.Anim(tileset.tiles, 0);
        sprite.x = x;
        sprite.y = y;
        Game.towerlayer.addChild(sprite);

        primative = new h2d.Graphics();
        primative.x = x;
        primative.y = y;
        primative.moveTo(0, 0);
        primative.lineStyle(3, Col.WHITE, 0.3);
        primative.drawCircle(world.tilewidth / 2, world.tileheight / 2, targetradius);

        Game.uilayer.addChild(primative);
      case BULLET1:
        x += centerx;
        y += centery;
        var tileset:Tileset = Gfx.gettileset("particles");
        sprite = new h2d.Anim(tileset.tiles, 0);
        sprite.x = x;
        sprite.y = y;
        Game.bulletlayer.addChild(sprite);
      default:
        throw("Error: cannot create an entity without a type.");
    }
  }

  public function picknewdirection(){
    var heat_up:Int = world.heatat(x + Std.int(world.tilewidth / 2), y - Std.int(world.tileheight / 2));
    var heat_down:Int = world.heatat(x + Std.int(world.tilewidth / 2), y + Std.int(world.tileheight * 3 / 2));
    var heat_left:Int = world.heatat(x - Std.int(world.tilewidth / 2), y + Std.int(world.tileheight / 2));
    var heat_right:Int = world.heatat(x + Std.int(world.tilewidth * 3 / 2), y + Std.int(world.tileheight / 2));

    if(heat_up < heat_down && heat_up < heat_left && heat_up < heat_right){
      direction = Direction.UP;
      return;
    }

    if(heat_down < heat_left && heat_down < heat_right){
      direction = Direction.DOWN;
      return;
    }

    if(heat_left < heat_right){
      direction = Direction.LEFT;
      return;
    }

    direction = Direction.RIGHT;
  }

  public function standardenemymove(){
    switch(direction){
      case Direction.UP:
        vx = 0;  
        vy = -speed;
      case Direction.DOWN:
        vx = 0;  
        vy = speed;
      case Direction.LEFT:
        vx = -speed;  
        vy = 0;
      case Direction.RIGHT:
        vx = speed;  
        vy = 0;
    }

    var testx:Float = x + vx;
    var testy:Float = y + vy;

    switch(direction){
      case Direction.DOWN:
        testy += world.tileheight;
      case Direction.RIGHT:
        testx += world.tilewidth;
      default:
    }

    //If testx, testy is a collision, stop moving and instead change direction
    if(world.heatat(testx, testy) >= 10000){
      var olddirection:Direction = direction;
      //Pick a new direction
      picknewdirection();

      //Recenter on grid (this is a bit messy)
      if(direction == Direction.UP || direction == Direction.DOWN){
        if(olddirection == Direction.LEFT){
          x = x - world.gridxoffset(x);
        }else{
          x = x + vx;
          x = x - world.gridxoffset(x);
        }
      }else{
        if(olddirection == Direction.UP){
          y = y - world.gridyoffset(y);
        }else{
          y = y + vy;
          y = y - world.gridyoffset(y);
        }
      }

      //Don't move until next update
      vx = 0; vy = 0;
    }

    //Ok, actually move
    x = x + vx;
    y = y + vy;
  }

  public function update(){
    if(destroyed) return;

    switch(type){
      case ENEMY1:
        standardenemymove();
      case TOWER1:
        timetillnextshot -= Core.deltatime;
        if(timetillnextshot <= 0){
          Game.picktarget(this);
          if(targetentity != null){
            Game.createbullet(this, targetentity);
          }
          timetillnextshot = firerate;
        }
      case BULLET1:
        //Do nothing
      default:
        throw("Error: cannot create an entity without a type.");
    }
  }

  public function render(){
    if(destroyed) return;

    switch(type){
      case ENEMY1:
        sprite.x = x;
        sprite.y = y;
      case TOWER1:
        sprite.x = x;
        sprite.y = y;
      case BULLET1:
        sprite.x = x;
        sprite.y = y;
      default:
        throw("Error: cannot create an entity without a type.");
    }
  }

  /* Mark entity for later removal */
  public function destroy(){
    if(sprite != null){
      sprite.remove();
    }

    if(primative != null){
      primative.remove();
    }

    sprite = null;
    primative = null;
    destroyed = true;
  }

  public function shrinkdestroy(){
    Actuate.tween(sprite, 0.1, {scaleX: 0, scaleY:0 })
     .onComplete(destroy);
  }

  public var x:Float;
  public var y:Float;
  public var centerx:Float;
  public var centery:Float;
  public var type:EntityType;
  public var world:World;
  public var destroyed:Bool;

  public var vx:Float;
  public var vy:Float;
  public var speed:Float;
  public var direction:Direction;

  public var sprite:h2d.Anim;
  public var primative:h2d.Graphics;

  public var targetradius:Float;
  public var targetentity:Entity;
  public var firerate:Float;
  public var bulletdamage:Float;
  public var timetillnextshot:Float;

  //For animation
  public var animpercent:Float;
}