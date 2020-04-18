import scenes.*;

class Scene {
	private static function init() {
		currentscene = 0;
		callinit();
	}
	
	private static function callinit() {
		if(currentscene == 0){
			Main.init();
		}else if(currentscene == 1){
			TowerDefence.init();
		}else if(currentscene == 2){
			GameOver.cleanup();
		}
	}

	private static function update() {
		if(currentscene == 0){
			Main.update();
		}else if(currentscene == 1){
			TowerDefence.update();
		}else if(currentscene == 2){
			GameOver.cleanup();
		}
	}

	private static function cleanup() {
		if(currentscene == 0){
			Main.cleanup();
		}else if(currentscene == 1){
			TowerDefence.cleanup();
		}else if(currentscene == 2){
			GameOver.cleanup();
		}
	}
	
	public static function change(newscene:String) {
		//Cleanup scene if possible
		hashagon.Core.cleanup();
		cleanup();

		newscene = hashagon.S.lowercase(newscene);

		if(newscene == "main"){
			currentscene = 0;
		}else if(newscene == "towerdefence"){
			currentscene = 1;
		}else if(newscene == "gameover"){
			currentscene = 2;
		}else{
			currentscene = 0;
		}

		callinit();
	}
	
	private static var currentscene:Int;
}
