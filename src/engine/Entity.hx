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

    baseframe = 0;
    offsetframe = 0;
    animpercent = 0;
    x = 0;
    y = 0;

    speedmultiplier = 1.0;
    speeddampen = 0;

    //Tower stuff
    targetradius = 0;
    firerate = 0;
    timetillnextshot = 0;
    bulletdamage = 0;
  }

  public function updatebeam(power:Float){
    sprite.alpha = 0.8 * power;
  }

  public function updatevortex(power:Float){
    primative.clear();
    
    primative.moveTo(0, 0);
    //Outer ring
    primative.beginFill(Col.MAGENTA, 0.1 * power);
    primative.drawCircle(world.tilewidth / 2, world.tileheight / 2, targetradius);
    primative.endFill();
    primative.lineStyle(2, Col.MAGENTA, 0.5 * power);
    primative.drawCircle(world.tilewidth / 2, world.tileheight / 2, targetradius);

    //Inner animations
    primative.lineStyle(2, Col.MAGENTA, 0.3 * power);
    primative.drawCircle(world.tilewidth / 2, world.tileheight / 2, targetradius * power);
    primative.lineStyle(2, Col.MAGENTA, 0.2 * power);
    primative.drawCircle(world.tilewidth / 2, world.tileheight / 2, targetradius * power * 3 / 4);
    primative.lineStyle(2, Col.MAGENTA, 0.1 * power);
    primative.drawCircle(world.tilewidth / 2, world.tileheight / 2, targetradius * power / 2);
    
    primative.visible = true;
  }

  public function updatelaser(power:Float){
    primative.clear();
    
    primative.moveTo(0, 0);
    primative.lineStyle(2, Col.RED, 0.75 * power);

    primative.lineTo(endx - primative.x + 5, endy - primative.y + 5 - 5);
    primative.lineTo(5, 5);
    primative.visible = true;
  }

  public function updatetowerradius(){
    primative.clear();
    primative.moveTo(0, 0);
    primative.lineStyle(3, Col.WHITE, 0.3);
    primative.drawCircle(world.tilewidth / 2, world.tileheight / 2, targetradius);
  }

  public function inittype(){
    switch(type){
      case GOAL:
        var tileset:Tileset = Gfx.gettileset("goal");
        sprite = new h2d.Anim(tileset.tiles, 0);
        sprite.x = x;
        sprite.y = y;
        Game.towerlayer.addChild(sprite);
      case ENEMY:
        if(x < 0){
          direction = Direction.RIGHT;
        }else if(y < 0){
          direction = Direction.DOWN;
        }else if(world.gridx(x) > 17){
          direction = Direction.LEFT;
        }else{
          direction = Direction.UP;
        }

        maxhp = 5;
        hp = maxhp;

        var tileset:Tileset = Gfx.gettileset("enemies");
        sprite = new h2d.Anim(tileset.tiles, 0);
        sprite.x = x;
        sprite.y = y;
        sprite.currentFrame = baseframe;
        Game.monsterlayer.addChild(sprite);

        primative = new h2d.Graphics();
        primative.x = x;
        primative.y = y - 10;
        primative.moveTo(0, 0);
        primative.beginFill(Col.LIGHTGREEN, 1.0);
        primative.drawRect(0, 0, world.tilewidth * 1.5, 3);
        primative.endFill();
        primative.visible = false;

        Game.monsterlayer.addChild(primative);
      case TOWER_SHOOTY:
        timetillnextshot = 0;
        firerate = GameData.towers.shooty.level1.firerate;
        timetillnextshot = 0;
        targetradius = GameData.towers.shooty.level1.radius;
        bulletdamage = GameData.towers.shooty.level1.damage;
        level = 1;
        baseframe = 0;

        var tileset:Tileset = Gfx.gettileset("towers");
        sprite = new h2d.Anim(tileset.tiles, 0);
        sprite.x = x;
        sprite.y = y;
        Game.towerlayer.addChild(sprite);

        primative = new h2d.Graphics();
        primative.x = x;
        primative.y = y;
        updatetowerradius();
        primative.visible = false;

        //Let's try a fancy new heaps thing!
        var interaction = new h2d.Interactive(world.tilewidth, world.tileheight, sprite);

        interaction.onOver = function(event : hxd.Event) {
          sprite.alpha = 0.7;
          primative.visible = true;
        }

        interaction.onOut = function(event : hxd.Event) {
          sprite.alpha = 1;
          primative.visible = false;
        }

        Game.uilayer.addChild(primative);
      case TOWER_BEAM:
        timetillnextshot = 0;
        firerate = GameData.towers.beam.level1.firerate;
        timetillnextshot = 0;
        targetradius = GameData.towers.beam.level1.radius;
        bulletdamage = GameData.towers.beam.level1.damage;
        level = 1;
        //Pick a direction based on nearby path
        direction = Game.towerdirection(world.gridx(x), world.gridy(y), world);
        switch(direction){
          case Direction.LEFT: baseframe = 18;
          case Direction.RIGHT: baseframe = 24;
          case Direction.UP: baseframe = 30;
          case Direction.DOWN: baseframe = 36;
        }

        var tileset:Tileset = Gfx.gettileset("towers");
        sprite = new h2d.Anim(tileset.tiles, 0);
        sprite.x = x;
        sprite.y = y;
        Game.towerlayer.addChild(sprite);

        primative = new h2d.Graphics();
        primative.x = x;
        primative.y = y;
        updatetowerradius();
        primative.visible = false;

        //Let's try a fancy new heaps thing!
        var interaction = new h2d.Interactive(world.tilewidth, world.tileheight, sprite);

        interaction.onOver = function(event : hxd.Event) {
          sprite.alpha = 0.7;
          //primative.visible = true;
        }

        interaction.onOut = function(event : hxd.Event) {
          sprite.alpha = 1;
          //primative.visible = false;
        }

        Game.uilayer.addChild(primative);
      case TOWER_VORTEX:
        firerate = GameData.towers.vortex.level1.firerate;
        timetillnextshot = 0;
        targetradius = GameData.towers.vortex.level1.radius;
        bulletdamage = GameData.towers.vortex.level1.damage;
        level = 1;
        baseframe = 6;

        var tileset:Tileset = Gfx.gettileset("towers");
        sprite = new h2d.Anim(tileset.tiles, 0);
        sprite.x = x;
        sprite.y = y;
        Game.towerlayer.addChild(sprite);

        primative = new h2d.Graphics();
        primative.x = x;
        primative.y = y;
        updatetowerradius();
        primative.visible = false;

        //Let's try a fancy new heaps thing!
        var interaction = new h2d.Interactive(world.tilewidth, world.tileheight, sprite);

        interaction.onOver = function(event : hxd.Event) {
          sprite.alpha = 0.7;
          primative.visible = true;
        }

        interaction.onOut = function(event : hxd.Event) {
          sprite.alpha = 1;
          primative.visible = false;
        }

        Game.uilayer.addChild(primative);
      case TOWER_LASER:
        firerate = GameData.towers.laser.level1.firerate;
        timetillnextshot = 0;
        targetradius = GameData.towers.laser.level1.radius;
        bulletdamage = GameData.towers.laser.level1.damage;
        level = 1;
        baseframe = 12;

        var tileset:Tileset = Gfx.gettileset("towers");
        sprite = new h2d.Anim(tileset.tiles, 0);
        sprite.x = x;
        sprite.y = y;
        Game.towerlayer.addChild(sprite);

        primative = new h2d.Graphics();
        primative.x = x;
        primative.y = y;
        updatetowerradius();
        primative.visible = false;

        //Let's try a fancy new heaps thing!
        var interaction = new h2d.Interactive(world.tilewidth, world.tileheight, sprite);

        interaction.onOver = function(event : hxd.Event) {
          sprite.alpha = 0.7;
          primative.visible = true;
        }

        interaction.onOut = function(event : hxd.Event) {
          sprite.alpha = 1;
          primative.visible = false;
        }

        Game.uilayer.addChild(primative);
      case BULLET:
        x += centerx;
        y += centery;
        var tileset:Tileset = Gfx.gettileset("particles");
        sprite = new h2d.Anim(tileset.tiles, 0);
        sprite.x = x;
        sprite.y = y;
        Game.bulletlayer.addChild(sprite);
      case BEAM:
        x += centerx;
        y += centery;
        //We attach the sprite elsewhere
      case VORTEX:
        x += centerx;
        y += centery;

        primative = new h2d.Graphics();
        primative.x = x;
        primative.y = y;
        primative.visible = false;
      case LASER:
        x += centerx;
        y += centery;

        primative = new h2d.Graphics();
        primative.x = x;
        primative.y = y;
        primative.visible = false;
      default:
        throw("Error: cannot create an entity without a type.");
    }
  }

  public function picknewdirection(){
    var heat_up:Int = world.heatat(x + Std.int(world.tilewidth / 2), y - Std.int(world.tileheight / 2));
    var heat_down:Int = world.heatat(x + Std.int(world.tilewidth / 2), y + Std.int(world.tileheight * 3 / 2));
    var heat_left:Int = world.heatat(x - Std.int(world.tilewidth / 2), y + Std.int(world.tileheight / 2));
    var heat_right:Int = world.heatat(x + Std.int(world.tilewidth * 3 / 2), y + Std.int(world.tileheight / 2));

    //If there's only one valid direction, then we're at the end!
    if(heat_up + heat_down + heat_left + heat_right >= 30000){
      Game.monsterreachestheend(this);
      return;
    }

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
        vy = -speed * Game.speed;
      case Direction.DOWN:
        vx = 0;  
        vy = speed * Game.speed;
      case Direction.LEFT:
        vx = -speed * Game.speed;  
        vy = 0;
      case Direction.RIGHT:
        vx = speed * Game.speed;  
        vy = 0;
    }

    if(speedmultiplier < 1.0){
      vx = vx * speedmultiplier;
      vy = vy * speedmultiplier;

      if(speeddampen > 0){
        speeddampen -= Core.deltatime * Game.speed;
      }else{
        speedmultiplier += 0.1;
        if(speedmultiplier > 1.0) speedmultiplier = 1.0;
      }
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
      case GOAL:
      case ENEMY:
        standardenemymove();
      case TOWER_SHOOTY:
        timetillframechange -= Core.deltatime * Game.speed;
        if(timetillframechange <= 0){
          offsetframe = 0;
        }

        timetillnextshot -= Core.deltatime * Game.speed;
        if(timetillnextshot <= 0){
          Game.picktarget(this);
          if(targetentity != null){
            Game.createbullet(this, targetentity);
            offsetframe = 1;
            timetillframechange = 0.25;
          }
          timetillnextshot = firerate;
        }
      case TOWER_BEAM:
          timetillframechange -= Core.deltatime * Game.speed;
          if(timetillframechange <= 0){
            offsetframe = 0;
          }
  
          timetillnextshot -= Core.deltatime * Game.speed;
          if(timetillnextshot <= 0){
            Game.picktarget(this);
            if(targetentity != null){
              Game.createbeam(this);
              offsetframe = 1;
              timetillframechange = 0.25;
            }
            timetillnextshot = firerate;
          }
      case TOWER_VORTEX:
        timetillframechange -= Core.deltatime * Game.speed;
        if(timetillframechange <= 0){
          offsetframe = 0;
        }

        timetillnextshot -= Core.deltatime * Game.speed;
        if(timetillnextshot <= 0){
          Game.picktarget(this);
          if(targetentity != null){
            Game.createvortex(this);
            offsetframe = 1;
            timetillframechange = 0.25;
          }
          timetillnextshot = firerate;
        }
      case TOWER_LASER:
        timetillframechange -= Core.deltatime * Game.speed;
        if(timetillframechange <= 0){
          offsetframe = 0;
        }

        timetillnextshot -= Core.deltatime * Game.speed;
        if(timetillnextshot <= 0){
          Game.picktarget(this);
          if(targetentity != null){
            Game.createlaser(this, targetentity);
            offsetframe = 1;
            timetillframechange = 0.25;
          }
          timetillnextshot = firerate;
        }
      case BULLET:
        //Do nothing
      case BEAM:
        //Do nothing
      case VORTEX:
        //Do nothing
      case LASER:
        //Do nothing
      default:
        throw("Error: cannot create an entity without a type.");
    }
  }

  public function render(){
    if(destroyed) return;

    switch(type){
      case GOAL:
        sprite.x = x;
        sprite.y = y;

        sprite.currentFrame = baseframe + Game.twoframe;
      case ENEMY:
        sprite.x = x;
        sprite.y = y - 5;
        sprite.currentFrame = baseframe + Game.twoframe;
    
        primative.x = x - (world.tilewidth * 0.25);
        primative.y = y - 10;
      case TOWER_SHOOTY:
        sprite.x = x;
        sprite.y = y;

        sprite.currentFrame = baseframe + offsetframe;
      case TOWER_BEAM:
        sprite.x = x;
        sprite.y = y;

        sprite.currentFrame = baseframe + offsetframe;
      case TOWER_VORTEX:
        sprite.x = x;
        sprite.y = y;

        sprite.currentFrame = baseframe + offsetframe;
      case TOWER_LASER:
        sprite.x = x;
        sprite.y = y;

        sprite.currentFrame = baseframe + offsetframe;
      case BULLET:
        sprite.x = x;
        sprite.y = y;
      case BEAM:
        //Don't mess with the beam position
      case VORTEX:
        //Don't mess with the vortex position
      case LASER:
        //Don't mess with the laser position
      default:
        throw("Error: cannot create an entity without a type.");
    }
  }

  public function slowenemy(_speedmult:Float, _speeddamp:Float){
    if(speedmultiplier > _speedmult){
      speedmultiplier = _speedmult;
    }

    speeddampen = _speeddamp;
  }

  public function damageenemy(dmg:Float){
    if(destroyed) return;
    
    hp -= dmg;

    if(hp <= 0){
      Game.gold += Waves.reward;
      destroy();
    }else{
      primative.clear();
      primative.moveTo(0, 0);
      primative.beginFill(Col.LIGHTGREEN, 1.0);
      primative.drawRect(0, 0, ((world.tilewidth * 1.5) * hp) / maxhp, 3);
      primative.endFill();
          
      primative.visible = true;
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
  public var endx:Float;
  public var endy:Float;
  public var speed:Float;
  public var direction:Direction;
  public var speedmultiplier:Float;
  public var speeddampen:Float;

  public var maxhp:Float;
  public var hp:Float;

  public var sprite:h2d.Anim;
  public var primative:h2d.Graphics;

  public var targetradius:Float;
  public var targetentity:Entity;
  public var firerate:Float;
  public var bulletdamage:Float;
  public var timetillnextshot:Float;
  public var level:Int;
  public var timetillframechange:Float;

  //For animation
  public var animpercent:Float;
  public var baseframe:Int;
  public var offsetframe:Int;
}