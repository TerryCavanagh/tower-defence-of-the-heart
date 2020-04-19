import hashagon.*;
import hashagon.displayobject.*;
import hxd.Key;

@:keep
class Main{
	public static function init(){
		Gfx.loadimage("beam_horizontal");
		Gfx.loadimage("beam_vertical");
		GameData.init();

		Scene.change("TowerDefence");
	}
	
	public static function update() {		
	}

	public static function cleanup(){
	}
}