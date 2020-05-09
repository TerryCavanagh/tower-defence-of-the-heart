package scenes;

import hashagon.*;
import engine.*;
import hxd.Key;
import h2d.Bitmap;

class TitleScreen{
	public static function init(){
		titlescreen = new h2d.Anim([Gfx.getimage("background")], 0);
		Gfx.core.s2d.addChild(titlescreen);

		heart = new h2d.Anim(Gfx.gettileset("heart").tiles, 1.5);
		Gfx.gettileset("heart").tiles[0].dx = -15;
		Gfx.gettileset("heart").tiles[0].dy = -15;
		Gfx.gettileset("heart").tiles[1].dx = -15;
		Gfx.gettileset("heart").tiles[1].dy = -15;
		heart.x = Gfx.screenwidthmid;
		heart.y = Gfx.screenheightmid;
		heart.scale(2.5);
		Gfx.core.s2d.addChild(heart);

		logo = new Bitmap(Gfx.getimage("logo"), Gfx.core.s2d);
		logo.x = Gfx.screenwidthmid - 77;
		logo.y = 45;

		clicktostart = new h2d.Text(Game.smallfont, Gfx.core.s2d);
		clicktostart.x = Gfx.screenwidthmid;
		clicktostart.y = 95;
		clicktostart.textAlign = Center;
		clicktostart.text = "CLICK TO START";
	}
	
	public static function update() {
    if(Mouse.leftclick()){
      titlescreen.remove();
      heart.remove();
      logo.remove();
      clicktostart.remove();

			Music.play("totaleclipse");
			Scene.change("TowerDefence");
		}
	}

	public static function cleanup(){
	}

	public static var titlescreen:h2d.Anim;
	public static var heart:h2d.Anim;
	public static var logo:h2d.Bitmap;

	public static var clicktostart:h2d.Text;
}