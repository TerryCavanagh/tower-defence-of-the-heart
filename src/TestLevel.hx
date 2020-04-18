import hashagon.*;
import engine.*;
import hxd.Key;

class TestLevel{
  public static var firstcall:Bool = true;
  public static function init(){
		if(firstcall){
			firstcall = false;
		}
		
		world = new World();
    
		world.loadtiles("adam_jawbreaker", 8, 8);
		world.setcollidable([1, 3, 5]);
    world.randomcontents(60, 40);
    world.refreshmap();
	}
	
	public static function update(){
		world.render();
  }
  
	public static function cleanup(){

  }
  
	public static var world:World;
}