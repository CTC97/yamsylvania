package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxAssets;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{

   public function new()
   {
       super();
       var uiBg:FlxSprite = new FlxSprite(4, 4);
       uiBg.loadGraphic(AssetPaths.uibg__png, false, 128, 132);
       add(uiBg);
       
       forEach(function(sprite) sprite.scrollFactor.set(0, 0));
   }

   public function updateHUD(aether:Int, stamina:Int)
   {

   }
}