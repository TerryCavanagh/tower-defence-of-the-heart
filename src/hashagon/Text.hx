package hashagon;

import hashagon.displayobject.*;

class Text{
	public static function init(_c:Core){
		core = _c;
		
		textfieldmap = new Map<String, TextField>();
		Text.align = Text.LEFT;
		Text.size = 1;
	}
 
	public static function display(x:Float, y:Float, text:Dynamic, color:Int = 0xFFFFFF, alpha:Float = 1.0, id:String = "", ?pos:haxe.PosInfos) {
		if(id == "") id = pos.fileName + "_" + pos.lineNumber;

		var tf:TextField;
		if (textfieldmap.exists(id)){
			tf = textfieldmap.get(id);
			tf.update(x, y, text, color, alpha);
			//core.s2d.removeChild(tf.tf);
		}else{
			tf = new TextField();
			textfieldmap.set(id, tf);
			tf.update(x, y, text, color, alpha);
		}

		tf.display();
	}

	public static function cleanup(){
		if(textfieldmap != null){
			for (k in textfieldmap.keys()){
				textfieldmap.get(k).dispose();
				textfieldmap.remove(k);
			}
		}
	}

	public static var size:Float;

	public static var core:Core;
	private static var textfieldmap:Map<String, TextField>;
	
	public static var LEFT:Int = 0;
	public static var TOP:Int = 0;
	public static var CENTER:Int = -200000;
	public static var RIGHT:Int = -300000;
	public static var BOTTOM:Int = -300000;
	
	public static var align:Int = 0;
}