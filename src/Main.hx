import hashagon.*;
import hashagon.displayobject.*;
import hxd.Key;

@:keep
class Main{
	public static var firstcall:Bool = true;
	public static function init(){
		if(firstcall){
			firstcall = false;
		}
	}
	
	public static function update() {
		Text.display(0, 0, "Blank framework!");
	}

	public static function cleanup(){

	}
}