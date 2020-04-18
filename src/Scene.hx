class Scene {
	private static function init() {
		currentscene = 0;
		callinit();
	}
	
	private static function callinit() {
		if(currentscene == 0){
			Main.init();
		}else if(currentscene == 1){
			TestLevel.init();
		}
	}

	private static function update() {
		if(currentscene == 0){
			Main.update();
		}else if(currentscene == 1){
			TestLevel.update();
		}
	}

	private static function cleanup() {
		if(currentscene == 0){
			Main.cleanup();
		}else if(currentscene == 1){
			TestLevel.cleanup();
		}
	}
	
	public static function change(newscene:String) {
		//Cleanup scene if possible
		hashagon.Core.cleanup();
		cleanup();

		newscene = hashagon.S.lowercase(newscene);

		if(newscene == "main"){
			currentscene = 0;
		}else if(newscene == "testlevel"){
			currentscene = 1;
		}else{
			currentscene = 0;
		}

		callinit();
	}
	
	private static var currentscene:Int;
}
