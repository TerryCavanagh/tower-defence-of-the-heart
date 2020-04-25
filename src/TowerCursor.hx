import hxd.snd.WavData;
import hashagon.*;
import engine.*;

class TowerCursor extends h2d.Object{
	public function new(){
		super();
		//Three layered cursor that depends on context: the block below,
		//the tower below, and an icon. 
		block = new h2d.Anim(Gfx.gettileset("ld46tiles").tiles, 0, this);
		icon = new h2d.Anim(Gfx.gettileset("towers").tiles, 0, this);
		tower = new h2d.Anim(Gfx.gettileset("towers").tiles, 0, this);

		rangedisplay = new h2d.Graphics(this);
		updaterangedisplay(-1);

		dropshadow = new h2d.Graphics(this);
		dropshadow.x = -12;
		dropshadow.y = -12;
		dropshadow.beginFill(Col.multiplylightness(Col.GREEN, 0.75));
		dropshadow.drawRect(0, 0, 32, 12);
		dropshadow.endFill();

		info = new h2d.Text(Game.numberfont, this);
		info.x = 5;
		info.y = -10;
		info.textAlign = Center;
		info.text = "";

		block.visible = false;
		tower.visible = false;
		icon.visible = false;
		info.visible = false;
		dropshadow.visible = false;
	}

	public function canplacetower(mx:Int, my:Int, w:World):Bool{
		if(w.canplacetower[w.contents[mx][my]]){
			return true;
		}
		return false;
	}

	public function changeto(t:String, mx:Int, my:Int, w:World, toweratcursor:Entity){
		hide();

		x = (mx * w.tilewidth);
		y = (my * w.tileheight);
		block.x = 0;
		icon.x = 0;
		tower.x = 0;

		var towerisnull:Bool = false;
		var canplacetower:Bool = canplacetower(mx, my, w);
		if(toweratcursor == null){
			towerisnull = true;
		}else{
			if(toweratcursor.destroyed) towerisnull = true;
		}

		if(t == "sell"){
			updaterangedisplay(-1);
			if(towerisnull){
				//Don't show the block or the tower, just the icon
				icon.currentFrame = 47; icon.visible = true;
				icon.alpha = 0.4;
			}else if(toweratcursor.type == EntityType.GOAL){
				icon.currentFrame = 47; icon.visible = true;
				icon.alpha = 0.4;
			}else{
				//Don't show the block or the tower, just the icon
				icon.currentFrame = 47; icon.visible = true;
				icon.alpha = 0.8;

				info.text = "$" + Game.getrefundvalue(toweratcursor);
				info.textColor = Col.YELLOW;
				info.visible = true;
				dropshadow.visible = true;
			}
		}else{
			if(towerisnull && canplacetower){
				if(t == "laser"){
					if(Game.gold < GameData.towers.laser.cost){
						updaterangedisplay(-1);
						block.currentFrame = w.contents[mx][my]; block.visible = true;
						icon.currentFrame = 45; icon.visible = true;
						icon.alpha = 0.4;
						
						info.text = "$" + GameData.towers.laser.cost;
						info.textColor = Col.multiplylightness(Col.GREEN, 0.5);
						info.visible = true;
						dropshadow.visible = true;
					}else{
						updaterangedisplay(GameData.towers.laser.level1.radius);
						block.currentFrame = w.contents[mx][my]; block.visible = true;
						icon.currentFrame = 44; icon.visible = true;
						icon.alpha = 0.4;
					}
					
					tower.currentFrame = 12; tower.visible = true;
					tower.alpha = 0.8;
				}else if(t == "beam"){
					if(Game.gold < GameData.towers.beam.cost){
						updaterangedisplay(-1);
						block.currentFrame = w.contents[mx][my]; block.visible = true;
						icon.currentFrame = 45; icon.visible = true;
						icon.alpha = 0.4;
						
						info.text = "$" + GameData.towers.beam.cost;
						info.textColor = Col.multiplylightness(Col.GREEN, 0.5);
						info.visible = true;
						dropshadow.visible = true;
					}else{
						updaterangedisplay(-1);
						block.currentFrame = w.contents[mx][my]; block.visible = true;
						icon.currentFrame = 44; icon.visible = true;
						icon.alpha = 0.4;
					}

					var dir:Direction = Game.towerdirection(mx, my, w);
					switch(dir){
						case Direction.LEFT: tower.currentFrame = 18;
						case Direction.RIGHT: tower.currentFrame = 24;
						case Direction.UP: tower.currentFrame = 30;
						case Direction.DOWN: tower.currentFrame = 36;
					}
					
					tower.visible = true;
					tower.alpha = 0.8;
				}else if(t == "shooty"){
					if(Game.gold < GameData.towers.shooty.cost){
						updaterangedisplay(-1);
						block.currentFrame = w.contents[mx][my]; block.visible = true;
						icon.currentFrame = 45; icon.visible = true;
						icon.alpha = 0.4;
						
						info.text = "$" + GameData.towers.shooty.cost;
						info.textColor = Col.multiplylightness(Col.GREEN, 0.5);
						info.visible = true;
						dropshadow.visible = true;
					}else{
						updaterangedisplay(GameData.towers.shooty.level1.radius);
						block.currentFrame = w.contents[mx][my]; block.visible = true;
						icon.currentFrame = 44; icon.visible = true;
						icon.alpha = 0.4;
					}
		
					tower.currentFrame = 0; tower.visible = true;
					tower.alpha = 0.8;
				}else if(t == "vortex"){
					if(Game.gold < GameData.towers.vortex.cost){
						updaterangedisplay(-1);
						block.currentFrame = w.contents[mx][my]; block.visible = true;
						icon.currentFrame = 45; icon.visible = true;
						icon.alpha = 0.4;
						
						info.text = "$" + GameData.towers.vortex.cost;
						info.textColor = Col.multiplylightness(Col.GREEN, 0.5);
						info.visible = true;
						dropshadow.visible = true;
					}else{
						updaterangedisplay(GameData.towers.vortex.level1.radius);
						block.currentFrame = w.contents[mx][my]; block.visible = true;
						icon.currentFrame = 44; icon.visible = true;
						icon.alpha = 0.4;
					}
		
					tower.currentFrame = 6; tower.visible = true;
					tower.alpha = 0.8;
				}else if(t == "upgrade"){
					//Don't show the block or the tower, just the icon
					updaterangedisplay(-1);
					icon.currentFrame = 46; icon.visible = true;
					icon.alpha = 0.4;
				}else{
					throw(t + " not found in TowerCursor");
				}
			}else{
				if(t == "laser"){
					updaterangedisplay(-1);
					icon.currentFrame = 45; icon.visible = true;
					icon.alpha = 0.8;
				}else if(t == "beam"){
					updaterangedisplay(-1);
					icon.currentFrame = 45; icon.visible = true;
					icon.alpha = 0.8;
				}else if(t == "shooty"){
					updaterangedisplay(-1);
					icon.currentFrame = 45; icon.visible = true;
					icon.alpha = 0.8;
				}else if(t == "vortex"){
					updaterangedisplay(-1);
					icon.currentFrame = 45; icon.visible = true;
					icon.alpha = 0.8;
				}else if(t == "upgrade"){
					//Don't show the block or the tower, just the icon
					icon.currentFrame = 46; icon.visible = true;
					if(canplacetower){
						if(toweratcursor.level >= 3){
							updaterangedisplay(-1);
							icon.alpha = 0.4;

							info.text = "MAX";
							info.textColor = Col.WHITE;
							info.visible = true;
							dropshadow.visible = true;
						}else{
							/* Tried previewing upgrade radius changes, it just looked weird
							var upgradedrange:Float = -1;
							switch(toweratcursor.type){
								case EntityType.TOWER_SHOOTY:
									if(toweratcursor.level == 1) upgradedrange = GameData.towers.shooty.level2.radius;
									if(toweratcursor.level == 2) upgradedrange = GameData.towers.shooty.level3.radius;
								case EntityType.TOWER_VORTEX:
									if(toweratcursor.level == 1) upgradedrange = GameData.towers.vortex.level2.radius;
									if(toweratcursor.level == 2) upgradedrange = GameData.towers.vortex.level3.radius;
								case EntityType.TOWER_LASER:
									if(toweratcursor.level == 1) upgradedrange = GameData.towers.laser.level2.radius;
									if(toweratcursor.level == 2) upgradedrange = GameData.towers.laser.level3.radius;
								default:
							}
							updaterangedisplay(upgradedrange, 0.5); */
							updaterangedisplay(-1);
							icon.alpha = 0.8;
							
							info.text = "$" + Game.getupgradecost(toweratcursor);
							info.textColor = Col.WHITE;
							info.visible = true;
							dropshadow.visible = true;
						}
					}else{
						updaterangedisplay(-1);
						icon.alpha = 0.4;
					}
				}else{
					throw(t + " not found in TowerCursor");
				}
			}
		}
	}

	public function hide(){
		block.visible = false;
		tower.visible = false;
		icon.visible = false;
		info.visible = false;
		dropshadow.visible = false;
		updaterangedisplay(-1);
	}

	public function updaterangedisplay(radius:Float, alphamult:Float = 1.0){
		if(radius <= 0){
			rangedisplay.visible = false;
		}else{
			rangedisplay.visible = true;
			rangedisplay.clear();
			rangedisplay.moveTo(0, 0);
			rangedisplay.lineStyle(3, Col.WHITE, 0.3 * alphamult);
			rangedisplay.drawCircle(5, 5, radius);
		}
	}
	
	public var block:h2d.Anim;
	public var icon:h2d.Anim;
	public var tower:h2d.Anim;
	public var info:h2d.Text;
	public var rangedisplay:h2d.Graphics;
	public var dropshadow:h2d.Graphics;
}