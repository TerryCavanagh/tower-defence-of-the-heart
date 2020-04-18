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
    camera = new Camera();
    
		world.loadtiles("adam_jawbreaker", 8, 8);
		world.setcollidable([1, 3, 5]);
		world.randomcontents(40, 24);
		camera.setbounds(world);
	}
	
	public static function update(){
    Text.display(0, 0, "camera " + camera.x + ", " + camera.y);
		
		if (Input.pressed(Key.LEFT)){
			camera.x--;
		}else if (Input.pressed(Key.RIGHT)){
			camera.x++;
		}
		
		if (Input.pressed(Key.UP)){
			camera.y--;
		}else if (Input.pressed(Key.DOWN)){
			camera.y++;
		}
		
		world.render(camera);
  }
  
	public static function cleanup(){

  }
  
	public static var world:World;
	public static var camera:Camera;
}