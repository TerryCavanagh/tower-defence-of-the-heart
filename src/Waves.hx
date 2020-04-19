import engine.*;

class Wave{
  public function new(type:EntityType, num:Int, hp:Int, rate:Float, gold:Int){
    enemytype = type;
    numenemies = num;
    spawnrate = rate;
    enemyhealth = hp;
    reward = gold;
  }
  
  public var enemytype:EntityType;
  public var numenemies:Int;
  public var spawnrate:Float;
  public var enemyhealth:Int;
  public var reward:Int;
}

class Waves{
  public static function init(){
    waves = [];
    currentwave = -1; //First wave
    enemiesleft = 0;

    waves.push(new Wave(EntityType.ENEMY1, 10, 1, 1.6, 1));
    waves.push(new Wave(EntityType.ENEMY1, 10, 5, 1.6, 2));
    waves.push(new Wave(EntityType.ENEMY1, 10, 10, 1.6, 3));
  }

  public static function nextwave(){
    currentwave++;
    enemiesleft = waves[currentwave].numenemies;
    currenttype = waves[currentwave].enemytype;
    spawnrate = waves[currentwave].spawnrate;
    enemyhealth = waves[currentwave].enemyhealth;
    reward = waves[currentwave].reward;
  }

  public static function finalwave():Bool{
    return currentwave >= waves.length - 1;
  }

  public static var waves:Array<Wave>;

  public static var currentwave:Int;
  public static var enemiesleft:Int;
  public static var enemyhealth:Int;
  public static var spawnrate:Float;
  public static var reward:Int;
  public static var currenttype:EntityType;
}