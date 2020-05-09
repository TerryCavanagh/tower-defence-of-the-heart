import haxe.Json;
import hashagon.*;

class GameData{
	public static var towers:Dynamic;
	public static var waves:Dynamic;
	public static var other:Dynamic;
	public static var jfile:Dynamic;

	public static function init(){
		jfile = Json.parse(hxd.Res.text.variables.entry.getText());

		towers = jfile.towers;
	}

	public static function loadlevel(lvl:Int){
		if(lvl == 1){
			waves = jfile.waves_stage1;
			other = jfile.other_stage1;
		}else if(lvl == 2){
			waves = jfile.waves_stage2;
			other = jfile.other_stage2;
		}
	}
}