import hashagon.*;
import hashagon.displayobject.*;
import hxd.Key;

@:keep
class Main{
	public static function init(){
		Gfx.loadimage("beam_horizontal");
		Gfx.loadimage("beam_vertical");
		Gfx.loadtiles("enemies", 10, 10);
    Gfx.loadtiles("towers", 10, 10);
    Gfx.loadtiles("particles", 10, 10);
    Gfx.gettileset("particles").pivot(Text.CENTER);
		Gfx.loadtiles("goal", 30, 30);
		
		GameData.init();

		Scene.change("TowerDefence");
	}
	
	public static function update() {		
	}

	public static function cleanup(){
	}
}