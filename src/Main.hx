import h2d.Bitmap;
import hashagon.*;
import hxd.Key;

@:keep
class Main{
	public static function init(){
		Game.loadfonts();
		Gfx.loadimage("background");
		Gfx.loadimage("logo");
		Gfx.loadimage("gameoverscreen");
		Gfx.loadimage("beam_horizontal_left");
		Gfx.loadimage("beam_horizontal_right");
		Gfx.loadimage("beam_vertical_up");
		Gfx.loadimage("beam_vertical_down");
		Gfx.loadtiles("enemies", 10, 10);
		Gfx.loadtiles("towers", 10, 10);
		Gfx.loadtiles("particles", 10, 10);
		Gfx.loadtiles("nextindicate", 20, 20);
		Gfx.loadtiles("heart", 30, 30);
		Gfx.gettileset("particles").pivot(Text.CENTER);
		Gfx.loadtiles("goal", 30, 30);

		GameData.init();
		
		Scene.change("titlescreen");
	}
	
	public static function update() {
	}

	public static function cleanup(){
	}
}