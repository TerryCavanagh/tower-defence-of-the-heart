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
			GameOver.init();
		}else if(currentscene == 3){
			TitleScreen.init();
		}else if(currentscene == 4){
			LevelSelect.init();
		}
	}

	private static function update() {
		if(currentscene == 0){
			Main.update();
		}else if(currentscene == 1){
			TowerDefence.update();
		}else if(currentscene == 2){
			GameOver.update();
		}else if(currentscene == 3){
			TitleScreen.update();
		}else if(currentscene == 4){
			LevelSelect.update();
		}
	}

	private static function cleanup() {
		if(currentscene == 0){
			Main.cleanup();
		}else if(currentscene == 1){
			TowerDefence.cleanup();
		}else if(currentscene == 2){
			GameOver.cleanup();
		}else if(currentscene == 3){
			TitleScreen.cleanup();
		}else if(currentscene == 4){
			LevelSelect.cleanup();
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
		}else if(newscene == "titlescreen"){
			currentscene = 3;
		}else if(newscene == "levelselect"){
			currentscene = 4;
		}else{
			currentscene = 0;
		}

		callinit();
	}
	
	private static var currentscene:Int;
}
