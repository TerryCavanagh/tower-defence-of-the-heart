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
    
    world.loadtiles("ld46tiles", 8, 8);
    world.setcollidable([0]);
    world.loadcsv("testmap");
    world.getheatmap(35,4);
    world.refreshmap();
	}
	
	public static function update(){
		world.render();
  }
  
	public static function cleanup(){

  }
  
	public static var world:World;
}