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
   var healthBar:FlxSprite;
   var healthText:FlxText;
   var yamText:FlxText;
   var enemiesSlain:FlxText;
   var yamsDelivered:FlxText;

   public function new()
   {
       super();
       //healthBar = new FlxSprite(4, 4);
       //healthBar.loadGraphic(AssetPaths.uibg__png, false, 128, 132);
    // healthBar.loadGraphic(AssetPaths.healthbar__png, true, 128, 132);
       //healthBar.animation.add("0", [0], 1, false);
    //    healthBar.animation.add("2", [1], 3, true);
    //    healthBar.animation.add("1", [2], 3, true);
       add(healthBar);
      // healthBar.animation.play("3");

       healthText = new flixel.text.FlxText(8, 8, 0, "Health: 3", 16);
	    add(healthText);

       yamText = new flixel.text.FlxText(8, 28, 0, "Yams: 0", 16);
	    add(yamText);

       yamsDelivered = new flixel.text.FlxText(8, 48, 0, "Delivered: 0", 16);
	    add(yamsDelivered);

       enemiesSlain = new flixel.text.FlxText(8, 68, 0, "Slain: 0", 16);
	    add(enemiesSlain);
       
       forEach(function(sprite) sprite.scrollFactor.set(0, 0));
   }

   public function updateHud(playerHealth: Int, yams: Int, kills: Int, deliveries: Int) {
      trace("healthBar playing ", Std.string(playerHealth));
 //   healthBar.animation.play(Std.string(playerHealth));
      //healthBar.animation.play("0");
      healthText.text = "Health: " + Std.string(playerHealth);
      yamText.text = "Yams: " + Std.string(yams);
      enemiesSlain.text = "Slain: " + Std.string(kills);
      yamsDelivered.text = "Delivered: " + Std.string(deliveries);
   }
}