package scenes;

import hashagon.*;
import engine.*;
import hxd.Key;

class LevelSelect{
	public static function init(){
		titlescreen = new h2d.Anim([Gfx.getimage("background")], 0);
    Gfx.core.s2d.addChild(titlescreen);
    
		selectastage = new h2d.Text(Game.smallfont, Gfx.core.s2d);
		selectastage.x = Gfx.screenwidthmid;
		selectastage.y = 30 - 3;
		selectastage.textAlign = Center;
    selectastage.text = "SELECT A STAGE";
    
    stage1button = new RealSimpleButton("FalliNg iN Love", 50 - 3, () -> {
      stage1button.remove();
      stage2button.remove();
      selectastage.remove();
      titlescreen.remove();

      Music.play("totaleclipse");
      GameData.loadlevel(1);
      Scene.change("towerdefence");
    }, Gfx.core.s2d);
    stage2button = new RealSimpleButton("FalliNg apart", 70 - 3,() -> {
      stage1button.remove();
      stage2button.remove();
      selectastage.remove();
      titlescreen.remove();

      Music.play("totaleclipse");
      GameData.loadlevel(2);
      Scene.change("towerdefence");
    }, Gfx.core.s2d);
	}
	
	public static function update() {
	}

	public static function cleanup(){
  }
  
  public static var titlescreen:h2d.Anim;
  public static var selectastage:h2d.Text;

  public static var stage1button:RealSimpleButton;
  public static var stage2button:RealSimpleButton;
}