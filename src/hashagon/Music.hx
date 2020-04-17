package hashagon;

//Very lightweight for Ludum Dare
class Music{
  public static function init(){
    loadedsounds = new Map<String, hxd.res.Sound>();
    currentlyplaying = "";
  }

  public static function load(soundfile:String){
    if(!loadedsounds.exists(soundfile)){
      loadedsounds.set(soundfile, hxd.Res.load("sounds/" + soundfile + ".mp3").toSound());
    }
  }

  public static function play(soundfile:String){
    var soundresource:hxd.res.Sound;
    currentlyplaying = soundfile;

    if(loadedsounds.exists(soundfile)){
      soundresource = loadedsounds.get(soundfile);
		}else{
      soundresource = hxd.Res.load("sounds/" + soundfile + ".mp3").toSound();
      loadedsounds.set(soundfile, soundresource);
    }

		soundresource.play(true);
  }

  public static function stop(){
    if(currentlyplaying == "") return;

    var soundresource:hxd.res.Sound = loadedsounds.get(currentlyplaying);
    soundresource.stop();
    currentlyplaying = "";
  }

  public static var loadedsounds:Map<String, hxd.res.Sound>;
  public static var currentlyplaying:String;
}