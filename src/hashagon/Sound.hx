package hashagon;

//Very lightweight for Ludum Dare
class Sound{
  public static function init(){
    loadedsounds = new Map<String, hxd.res.Sound>();
  }

  public static function load(soundfile:String){
    if(!loadedsounds.exists(soundfile)){
      loadedsounds.set(soundfile, hxd.Res.load("sounds/" + soundfile + ".mp3").toSound());
    }
  }

  public static function play(soundfile:String){
    var soundresource:hxd.res.Sound;

    if(loadedsounds.exists(soundfile)){
      soundresource = loadedsounds.get(soundfile);
		}else{
      soundresource = hxd.Res.load("sounds/" + soundfile + ".mp3").toSound();
      loadedsounds.set(soundfile, soundresource);
    }

		soundresource.play();
  }

  public static var loadedsounds:Map<String, hxd.res.Sound>;
}