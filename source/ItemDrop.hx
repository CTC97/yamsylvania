package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;

class ItemDrop extends FlxSprite
{
   public var name:String;

   public function new(x:Float, y:Float, name_:String)
   {
       super(x, y);
       name = name_;
       loadGraphic(AssetPaths.apple__png, false, 24, 28);
       FlxTween.tween(this, {alpha: 0, alive: false}, 5, {onComplete: finishKill});
   }

   override function update(elapsed:Float)
   {
       super.update(elapsed);
   }

   override function kill()
   {
       //FlxG.sound.play(AssetPaths.gem__wav, 0.5, false);
       alive = false;
       // this is saying do {alpha ...} to the sprite over 0.33 seconds and then finish kill
       FlxTween.tween(this, {alpha: 0, y: y - 16}, 0.33, {ease: FlxEase.circOut, onComplete: finishKill});
   }

   function finishKill(_)
   {
       exists = false;
   }
}