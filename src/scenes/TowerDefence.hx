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
		world.setcanplacetower([6, 7, 8, 9, 10]);
		
		world.loadcsv("testmap");
		world.getheatmap(GameData.other.endpointx,GameData.other.endpointy);
		world.refreshmap();

		world.monsters = [];
		world.towers = [];
		world.bullets = [];
		world.particles = [];

		setupnextwaveindicators();
		inituielements();

		world.towers.push(Entity.create(GameData.other.goalx, GameData.other.goaly, EntityType.GOAL, world));

		timetillnextspawn = 0;
	}
	
	public static function update(){
		var mx:Int = world.gridx(Mouse.x);
		var my:Int = world.gridy(Mouse.y);

		//Show tower cursor
		updatecursor(mx, my);

		if(Waves.enemiesleft <=0){
			if(!Waves.finalwave()){
				shownextwaveindicators(Waves.waves[Waves.currentwave+1].entrance);
			}
		}else{
			shownextwaveindicators(-1);
		}

		animatenextwaveindicators();
		
		//Call the nextwave once it's ready
		if(!Waves.finalwave()){ 
			if(Waves.enemiesleft <=0){
				//Check if all enemies are dead
				var enemiesalive:Bool = false;
				for(monsters in world.monsters){
					if(!monsters.destroyed){
						enemiesalive = true;
						break;
					}
				}
				if(!enemiesalive) Waves.nextwave();
			}
		}
		if(Input.justpressed(Key.SPACE)){
			
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
			Game.changeselectedmode(ButtonType.LASER);
		}else if(Input.justpressed(Key.NUMBER_2)){
			Game.changeselectedmode(ButtonType.BEAM);
		}else if(Input.justpressed(Key.NUMBER_3)){
			Game.changeselectedmode(ButtonType.SHOOTY);
		}else if(Input.justpressed(Key.NUMBER_4)){
			Game.changeselectedmode(ButtonType.VORTEX);
		}else if(Input.justpressed(Key.NUMBER_5)){
			Game.changeselectedmode(ButtonType.UPGRADE);
		}else if(Input.justpressed(Key.NUMBER_6)){
			Game.changeselectedmode(ButtonType.SELL);
		}

		/*
		if(Input.justpressed(Key.P)){
			QuickSave.quicksave(world);
		}else if(Input.justpressed(Key.L)){
			QuickSave.quickload(world);
		}*/

		//UI stuff
		Game.uipanel.updatecashdisplay();
		Game.uipanel.updateallbuttons();

		Game.updatetimers();
		Game.playsounds_endframe();
	}
	
	public static function cleanup(){
		/*
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

		world.destroy();*/
	}
	
	public static var world:World;

	public static var spawnrate:Float;
	public static var timetillnextspawn:Float;

	public static function inituielements(){
		Game.cursormode = ButtonType.LASER;
		Game.uipanel.updateallbuttons();

		towercursor = new TowerCursor();
		Game.uilayer.addChild(towercursor);
	}

	public static function updatecursor(mx:Int, my:Int){
		var toweratcursor:Entity = null;

		Game.uipanel.mouseover = true;
		if(Mouse.x < Game.uipanel.x) Game.uipanel.mouseover = false;
		
		if(Game.uipanel.mouseover || !Geom.inbox(Mouse.x, Mouse.y, 0, 0, Gfx.screenwidth, Gfx.screenheight)){
			towercursor.hide();
		}else{
			for(t in world.towers){
				if(!t.destroyed){
					if(world.gridx(t.x) == mx && world.gridy(t.y) == my){
						toweratcursor = t;
						break;  
					}
				}
			}

			switch(Game.cursormode){
				case ButtonType.SHOOTY:
					towercursor.changeto("shooty", mx, my, world, toweratcursor);
				case ButtonType.BEAM:
					towercursor.changeto("beam", mx, my, world, toweratcursor);
				case ButtonType.VORTEX:
					towercursor.changeto("vortex", mx, my, world, toweratcursor);
				case ButtonType.LASER:
					towercursor.changeto("laser", mx, my, world, toweratcursor);
				case ButtonType.UPGRADE:
					towercursor.changeto("upgrade", mx, my, world, toweratcursor);
				case ButtonType.SELL:
					towercursor.changeto("sell", mx, my, world, toweratcursor);
			}

			if(Mouse.leftclick()){
				if(toweratcursor == null && towercursor.canplacetower(mx, my, world)){
					var currenttowercost:Int = 0;
					if(Game.cursormode == ButtonType.SHOOTY){
						currenttowercost = GameData.towers.shooty.cost;
					}else if(Game.cursormode == ButtonType.BEAM){
						currenttowercost = GameData.towers.beam.cost;
					}else if(Game.cursormode == ButtonType.VORTEX){
						currenttowercost = GameData.towers.vortex.cost;
					}else if(Game.cursormode == ButtonType.LASER){
						currenttowercost = GameData.towers.laser.cost;
					}
					if(currenttowercost > 0){
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
					}
				}else if(Game.cursormode == ButtonType.UPGRADE){
					if(toweratcursor == null){

					}else if(toweratcursor.level < 3){
						var upgradetowercost:Int = Game.getupgradecost(toweratcursor);

						if(upgradetowercost > 0){
							Game.cost(upgradetowercost, 
							function(){
								Game.upgradetower(toweratcursor);
							}, 
							function(){

							});
						}
					}
				}else if(Game.cursormode == ButtonType.SELL){
					if(toweratcursor != null){
						if(toweratcursor.type != EntityType.GOAL){
							Game.refundtower(toweratcursor);
						}
					}
				}
			}
		}
	}

	public static function shownextwaveindicators(num:Int){
		if(num <= -1){
			for(i in 0 ... 4) nextwaveindicators[i].visible = false;
		}else if(num < 4){
			for(i in 0 ... 4) nextwaveindicators[i].visible = false;
			nextwaveindicators[num].visible = true;
		}else{
			for(i in 0 ... 4) nextwaveindicators[i].visible = true;
			nextwaveindicators[2].visible = false;
		}
	}

	public static function animatenextwaveindicators(){
		for(i in 0 ... 4){
			if(nextwaveindicators[i].visible){
				nextwaveindicators[i].alpha = ((Game.twoframe == 0)?0.5:1.0);
			}
		} 
	}

	public static function setupnextwaveindicators(){
		nextwaveindicators = [];
		var tileset:hashagon.displayobject.Tileset = Gfx.gettileset("nextindicate");

		var nw:h2d.Anim = new h2d.Anim(tileset.tiles, 0, Game.backgroundlayer);
		nw.x = (GameData.other.enter0x * 10) - 5;
		nw.y = (GameData.other.enter0y - 2) * 10;
		nw.visible = false;
		nw.currentFrame = 0; nextwaveindicators.push(nw);

		nw = new h2d.Anim(tileset.tiles, 0, Game.backgroundlayer);
		nw.x = (GameData.other.enter1x + 1) * 10;
		nw.y = (GameData.other.enter1y * 10) - 10;
		nw.visible = false;
		nw.currentFrame = 3; nextwaveindicators.push(nw);

		nw = new h2d.Anim(tileset.tiles, 0, Game.backgroundlayer);
		nw.x = (GameData.other.enter2x - 2) * 10;
		nw.y = (GameData.other.enter2y * 10) - 10;
		nw.visible = false;
		nw.currentFrame = 2; nextwaveindicators.push(nw);

		nw = new h2d.Anim(tileset.tiles, 0, Game.backgroundlayer);
		nw.x = (GameData.other.enter3x * 10) - 5;
		nw.y = ((GameData.other.enter3y + 1) * 10) + 0;
		nw.visible = false;
		nw.currentFrame = 1; nextwaveindicators.push(nw);
	}

	public static var towercursor:TowerCursor;

	public static var nextwaveindicators:Array<h2d.Anim>;
}