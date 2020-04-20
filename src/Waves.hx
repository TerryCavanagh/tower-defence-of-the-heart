import engine.*;

class Wave{
  public function new(type:Int, num:Int, hp:Int, rate:Float, gold:Int, speed:Float, _entrance:Int){
    enemytype = type;
    numenemies = num;
    spawnrate = rate;
    enemyhealth = hp;
    reward = gold;
    enemyspeed = speed;
    entrance = _entrance;
  }
  
  public var enemytype:Int;
  public var numenemies:Int;
  public var spawnrate:Float;
  public var enemyhealth:Int;
  public var enemyspeed:Float;
  public var reward:Int;
  public var entrance:Int;
}

class Waves{
  public static function init(){
    waves = [];
    currentwave = -1; //First wave
    enemiesleft = 0;

    var totalwaves = GameData.waves.totalwaves;

    for(i in 0 ... totalwaves){
      var nextwave:Dynamic = Reflect.getProperty(GameData.waves, "wave" + (i + 1));
      waves.push(new Wave(
        convertimgtoframe(nextwave.img),
        nextwave.num,
        nextwave.hp,
        nextwave.spawnrate,
        nextwave.reward,
        nextwave.speed,
        nextwave.enter
      ));  
    }
  }

  public static function convertimgtoframe(img:String):Int{
    switch(img){
      case "skelly":  return 0;
      case "knight":   return 2;
      case "demon":   return 4;
      case "slime":   return 6;
      case "wisp":   return 8;
      case "tree":   return 10;
      case "rat":   return 12;
      case "cultist": return 14;
    }
    return 0;
  }

  public static function nextwave(){
    currentwave++;
    enemiesleft = waves[currentwave].numenemies;
    currenttype = waves[currentwave].enemytype;
    spawnrate = waves[currentwave].spawnrate;
    enemyhealth = waves[currentwave].enemyhealth;
    enemyspeed = waves[currentwave].enemyspeed;
    reward = waves[currentwave].reward;
    entrance = waves[currentwave].entrance;

    Game.playsound("nextwave");
  }

  public static function finalwave():Bool{
    return currentwave >= waves.length - 1;
  }

  public static var waves:Array<Wave>;

  public static var currentwave:Int;
  public static var enemiesleft:Int;
  public static var enemyhealth:Int;
  public static var enemyspeed:Float;
  public static var spawnrate:Float;
  public static var reward:Int;
  public static var currenttype:Int;
  public static var entrance:Int;
}