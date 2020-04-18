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
		
		presetchoice = 1;
	}
	
	public static function update() {		
		Text.display(0, 0, "Choose a test scene:");
	  Text.display(0, 20, "(1) Basic RPG");
	
  	if (Input.justpressed(Key.NUMBER_1) || presetchoice == 1){
	  	Scene.change("TestLevel");
  	}
	}

	public static function cleanup(){

	}
	
	public static var presetchoice:Int;
}