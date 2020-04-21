import haxe.Json;
import hashagon.*;

class GameData{
	public static var towers:Dynamic;
	public static var waves:Dynamic;
	public static var other:Dynamic;

	public static function init(){
		var jfile:Dynamic = Json.parse(hxd.Res.text.variables.entry.getText());

		towers = jfile.towers;
		waves = jfile.waves;
		other = jfile.other;
	}
}