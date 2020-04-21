import haxe.Constraints.Function;
import hashagon.*;
import hashagon.displayobject.*;
import engine.*;
import motion.Actuate;
import motion.easing.*;

class Game{
	public static function loadfonts(){
		textfont = hxd.Res.pressstart.toFont();
		numberfont = hxd.Res.pressstart.toFont();
	}
	public static var textfont:h2d.Font;
	public static var numberfont:h2d.Font;

	public static function reset(){
		maxhp = GameData.other.player_health;
		hp = maxhp;

		gold = GameData.other.startinggold;
		
		leveltime = 0;
		twoframe = 0;
		twoframeslow = 0;
		speed = 1.0;
		soundsthisframe = [];
	}

	public static var hp:Int;
	public static var maxhp:Int;
	public static var gold:Int;

	public static function getrefundvalue(toweratcursor:Entity):Int{
		var refund:Int = 0;
		if(toweratcursor.type == EntityType.TOWER_SHOOTY){
			refund += GameData.towers.shooty.cost;
			if(toweratcursor.level >= 2){
				refund += GameData.towers.shooty.level1.upgradecost;
			}
			if(toweratcursor.level >= 3){
				refund += GameData.towers.shooty.level2.upgradecost;
			}
		}else if(toweratcursor.type == EntityType.TOWER_BEAM){
			refund += GameData.towers.beam.cost;
			if(toweratcursor.level >= 2){
				refund += GameData.towers.beam.level1.upgradecost;
			}
			if(toweratcursor.level >= 3){
				refund += GameData.towers.beam.level2.upgradecost;
			}
		}else if(toweratcursor.type == EntityType.TOWER_VORTEX){
			refund += GameData.towers.vortex.cost;
			if(toweratcursor.level >= 2){
				refund += GameData.towers.vortex.level1.upgradecost;
			}
			if(toweratcursor.level >= 3){
				refund += GameData.towers.vortex.level2.upgradecost;
			}
		}else if(toweratcursor.type == EntityType.TOWER_LASER){
			refund += GameData.towers.laser.cost;
			if(toweratcursor.level >= 2){
				refund += GameData.towers.laser.level1.upgradecost;
			}
			if(toweratcursor.level >= 3){
				refund += GameData.towers.laser.level2.upgradecost;
			}
		}

		refund = Std.int(refund * GameData.other.refundrate);
		if(refund < 1) refund = 1;
		return refund;
	}

	public static function getupgradecost(toweratcursor:Entity):Int{
		var upgradetowercost:Int = 0;
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
		return upgradetowercost;
	}

	public static function refundtower(toweratcursor:Entity){
		gold += getrefundvalue(toweratcursor);
		Game.playsound("sell");
		toweratcursor.destroy();
	}

	public static function upgradetower(tower:Entity){
		if(tower.type == EntityType.TOWER_SHOOTY){
			if(tower.level == 1){
				tower.baseframe += 2;
				tower.bulletdamage = GameData.towers.shooty.level2.damage;
				tower.targetradius = GameData.towers.shooty.level2.radius;
				tower.level = 2;

				tower.updatetowerradius();
				Game.playsound("upgrade");
			}else if(tower.level == 2){
				tower.baseframe += 2;
				tower.bulletdamage = GameData.towers.shooty.level3.damage;
				tower.targetradius = GameData.towers.shooty.level3.radius;
				tower.level = 3;

				tower.updatetowerradius();
				Game.playsound("upgrade");
			}
		}else if(tower.type == EntityType.TOWER_BEAM){
			if(tower.level == 1){
				tower.baseframe+=2;
				tower.bulletdamage = GameData.towers.beam.level2.damage;
				tower.targetradius = GameData.towers.beam.level2.radius;
				tower.level = 2;

				tower.updatetowerradius();
				Game.playsound("upgrade");
			}else if(tower.level == 2){
				tower.baseframe += 2;
				tower.bulletdamage = GameData.towers.beam.level3.damage;
				tower.targetradius = GameData.towers.beam.level3.radius;
				tower.level = 3;

				tower.updatetowerradius();
				Game.playsound("upgrade");
			}
		}else if(tower.type == EntityType.TOWER_VORTEX){
			if(tower.level == 1){
				tower.baseframe += 2;
				tower.bulletdamage = GameData.towers.vortex.level2.damage;
				tower.targetradius = GameData.towers.vortex.level2.radius;
				tower.level = 2;

				tower.updatetowerradius();
				Game.playsound("upgrade");
			}else if(tower.level == 2){
				tower.baseframe += 2;
				tower.bulletdamage = GameData.towers.vortex.level3.damage;
				tower.targetradius = GameData.towers.vortex.level3.radius;
				tower.level = 3;

				tower.updatetowerradius();
				Game.playsound("upgrade");
			}
		}else if(tower.type == EntityType.TOWER_LASER){
			if(tower.level == 1){
				tower.baseframe += 2;
				tower.bulletdamage = GameData.towers.laser.level2.damage;
				tower.targetradius = GameData.towers.laser.level2.radius;
				tower.level = 2;

				tower.updatetowerradius();
				Game.playsound("upgrade");
			}else if(tower.level == 2){
				tower.baseframe += 2;
				tower.bulletdamage = GameData.towers.laser.level3.damage;
				tower.targetradius = GameData.towers.laser.level3.radius;
				tower.level = 3;

				tower.updatetowerradius();
				Game.playsound("upgrade");
			}
		}
	}

	public static function towerdirection(x:Int, y:Int, w:World):Direction{
		//Kludged in particular squares in the final map:
		if(x == 14 && y == 7) return Direction.LEFT; 
		if(x == 12 && y == 1) return Direction.DOWN;
		if(y == 11) return Direction.UP;
		if(y == 2) return Direction.RIGHT;
		if(x == 1 && y == 6) return Direction.RIGHT;
		if(x == 9 && y == 9) return Direction.RIGHT;

		//Otherwise:
		if(w.heatat(x - 1, y, false) < 10000){
			return Direction.LEFT;
		}else if(w.heatat(x + 1, y, false) < 10000){
			return Direction.RIGHT;
		}else if(w.heatat(x, y - 1, false) < 10000){
			return Direction.UP;
		}else if(w.heatat(x, y + 1, false) < 10000){
			return Direction.DOWN;
		}
		return Direction.LEFT;
	}

	public static function createtower(x:Int, y:Int, type:EntityType, w:World, lvl:Int = 1){
		var newtower:Entity = Entity.create(x, y, type, w);
		if(lvl == 2){
			upgradetower(newtower);
		}else if(lvl == 3){
			upgradetower(newtower);
			upgradetower(newtower);
		}
		Game.playsound("place");
		
		w.towers.push(newtower);
	}

	public static function createmonster(x:Int, y:Int, type:Int, hp:Int, speed:Float, w:World){
		var enemy:Entity = null;
		
		var enterx:Int = GameData.other.enter0x; 
		var entery:Int = GameData.other.enter0y;

		if(Waves.entrance == 0){
			enterx = GameData.other.enter0x;
			entery = GameData.other.enter0y;
		}else if(Waves.entrance == 1){
			enterx = GameData.other.enter1x;
			entery = GameData.other.enter1y;
		}else if(Waves.entrance == 2){
			enterx = GameData.other.enter2x;
			entery = GameData.other.enter2y;
		}else if(Waves.entrance == 3){
			enterx = GameData.other.enter3x;
			entery = GameData.other.enter3y;
		}else if(Waves.entrance == 4){
			if(Waves.enemiesleft % 3 == 0){
				enterx = GameData.other.enter0x;
				entery = GameData.other.enter0y;
			}else if(Waves.enemiesleft % 3 == 1){
				enterx = GameData.other.enter1x;
				entery = GameData.other.enter1y;
			}else if(Waves.enemiesleft % 3 == 2){
				enterx = GameData.other.enter3x;
				entery = GameData.other.enter3y;
			}
		}
		
		enemy = Entity.create(enterx, entery, EntityType.ENEMY, w);

		enemy.maxhp = hp;
		enemy.hp = enemy.maxhp;
		enemy.baseframe = type;
		enemy.speed = speed;

		w.monsters.push(enemy);
	}

	public static function createvortex(tower:Entity){
		var w:World = tower.world;

		var newvortex:Entity = Entity.create(w.gridx(tower.x), w.gridy(tower.y), EntityType.VORTEX, w);
		newvortex.x = tower.x;
		newvortex.y = tower.y;
		newvortex.targetradius = tower.targetradius;

		Game.playsound("vortex");
		newvortex.updatevortex(1.0);
		bulletlayer.addChild(newvortex.primative);

		//Apply slowdown effect to all enemies in the vortex
		for(monster in w.monsters){
			if(Geom.distance(monster.x, monster.y, newvortex.x, newvortex.y) <= newvortex.targetradius){
				monster.slowenemy(tower.bulletdamage, GameData.other.vortex_duration); 
			}
		}

		Actuate.tween(newvortex, GameData.other.vortex_animation_time, {animpercent: 1.0})
			.ease(Sine.easeIn)
			.onUpdate(function(){
				newvortex.updatevortex(1 - newvortex.animpercent);
			})
			.onComplete(function(){
				//Destory the vortex
				newvortex.destroy();
			});

		w.bullets.push(newvortex);
	}

	public static function createbeam(tower:Entity){
		var w:World = tower.world;

		var newbeam:Entity = Entity.create(w.gridx(tower.x), w.gridy(tower.y), EntityType.BEAM, w);
		//Super weid thing here: newbeam.x/y returns NaN in javascript. Reassigning
		//the values here fixes it, somehow
		newbeam.x = tower.x;
		newbeam.y = tower.y;
		newbeam.direction = tower.direction;

		switch(newbeam.direction){
			case Direction.LEFT:
				newbeam.sprite = new h2d.Anim([Gfx.getimage("beam_horizontal_left")], 0);
				newbeam.sprite.x = newbeam.x - Gfx.screenwidth;
				newbeam.sprite.y = newbeam.y + 2;
			case Direction.RIGHT:
				newbeam.sprite = new h2d.Anim([Gfx.getimage("beam_horizontal_right")], 0);
				newbeam.sprite.x = newbeam.x + 10;
				newbeam.sprite.y = newbeam.y + 2;
			case Direction.UP:
				newbeam.sprite = new h2d.Anim([Gfx.getimage("beam_vertical_up")], 0);
				newbeam.sprite.x = newbeam.x + 3;
				newbeam.sprite.y = newbeam.y - Gfx.screenheight;
			case Direction.DOWN:
				newbeam.sprite = new h2d.Anim([Gfx.getimage("beam_vertical_down")], 0);
				newbeam.sprite.x = newbeam.x + 3;
				newbeam.sprite.y = newbeam.y + 10;
		}
		
		bulletlayer.addChild(newbeam.sprite);
		newbeam.updatebeam(1.0);

		//Beams damage all enemies in path instantously when created:
		var beamposition:Int;
		
		switch(newbeam.direction){
			case Direction.LEFT, Direction.RIGHT:
				//Horizontal Beams
				beamposition = w.gridy(tower.y);
				for(monster in w.monsters){
					if(w.gridy(monster.y) == beamposition){
						//Damage the enemy
						monster.damageenemy(tower.bulletdamage);
					}
				}
			case Direction.UP, Direction.DOWN:
				//Vertical Beams
				beamposition = w.gridy(tower.x);
				for(monster in w.monsters){
					if(w.gridy(monster.x) == beamposition){
						//Damage the enemy
						monster.damageenemy(tower.bulletdamage);
					}
				}
		}

		Game.playsound("beam");

		Actuate.tween(newbeam, GameData.other.beam_animation_time, {animpercent: 1.0})
			.ease(Sine.easeIn)
			.onUpdate(function(){
				newbeam.updatebeam(1 - newbeam.animpercent);
			})
			.onComplete(function(){
				//Destory the beam
				newbeam.destroy();
			});

		w.bullets.push(newbeam);
	}

	public static function createbullet(tower:Entity, monster:Entity){
		var w:World = tower.world;

		var newbullet:Entity = Entity.create(w.gridx(tower.x), w.gridy(tower.y), EntityType.BULLET, w);

		Game.playsound("mine_launch");
		Actuate.tween(newbullet, GameData.other.shooty_animation_time, {animpercent: 1.0})
		 .onUpdate(function(){
			 //start point tower, end point monster
			 //x: monster.x, y: monster.y
			 newbullet.x = Geom.lerp(tower.x, monster.x, newbullet.animpercent);
			 newbullet.y = Geom.lerp(tower.y, monster.y, newbullet.animpercent);
		 })
		 .ease(Back.easeIn)
		 .onComplete(function(){
			 Game.playsound("mine_land");
			 //Destory the bullet
			 newbullet.destroy();
			 //Damage the enemy
			 monster.damageenemy(tower.bulletdamage);
		 });

		w.bullets.push(newbullet);
	}

	public static function createlaser(tower:Entity, monster:Entity){
		var w:World = tower.world;

		var newlaser:Entity = Entity.create(w.gridx(tower.x), w.gridy(tower.y), EntityType.LASER, w);
		newlaser.x = tower.x;
		newlaser.y = tower.y;
		newlaser.endx = newlaser.x;
		newlaser.endy = newlaser.y;
		bulletlayer.addChild(newlaser.primative);
		
		//Damage the enemy immediately
		monster.damageenemy(tower.bulletdamage);
		playsound("laser");

		Actuate.tween(newlaser, GameData.other.laser_animation_time, {animpercent: 1.0})
		 .onUpdate(function(){
			 newlaser.endx = monster.x;
			 newlaser.endy = monster.y;
			 newlaser.updatelaser(1 - newlaser.animpercent);
		 })
		 .onComplete(function(){
			 //Destory the laser
			 newlaser.destroy();
		 });

		w.bullets.push(newlaser);
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
		waveprogress = new WaveProgress();
		uipanel = new UIPanel();
		
		Gfx.core.s2d.addChild(Game.backgroundlayer);
		Gfx.core.s2d.addChild(Game.towerlayer);
		Gfx.core.s2d.addChild(Game.monsterlayer);
		Gfx.core.s2d.addChild(Game.bulletlayer);
		Gfx.core.s2d.addChild(waveprogress);
		Gfx.core.s2d.addChild(uipanel);
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

	public static function updatetimers(){
		leveltime += hxd.Timer.dt;

		twoframe = (((leveltime * 1000) % 400 > 200)?1:0);
		twoframeslow = (((leveltime * 1000) % 800 > 400)?1:0);
	}

	public static function changeselectedmode(type:ButtonType){
		cursormode = type;
		Game.playsound("button");
	}

	public static function playsound(sfx:String){
		if(soundsthisframe.indexOf(sfx) == -1) soundsthisframe.push(sfx);
	}

	public static function playsounds_endframe(){
		for(sounds in soundsthisframe){
			Sound.play(sounds);
		}
		soundsthisframe = [];
	}

	public static var soundsthisframe:Array<String>;

	public static var twoframe:Int;
	public static var twoframeslow:Int;

	public static var backgroundlayer:h2d.Object;
	public static var monsterlayer:h2d.Object;
	public static var bulletlayer:h2d.Object;
	public static var towerlayer:h2d.Object;
	public static var uilayer:h2d.Object;
	public static var uipanel:UIPanel;
	public static var waveprogress:WaveProgress;

	public static var leveltime:Float;

	public static var cursormode:ButtonType;

	public static var speed:Float;
}