package;

import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class Lore extends FlxState
{
    var bg:FlxSprite;
    var mainMenu:FlxSprite;

	override public function create()
	{
		super.create();

        bg = new FlxSprite(0, 0);
        bg.loadGraphic(AssetPaths.lore__png, false, 768, 576);
        add(bg);

        mainMenu = new FlxSprite(284, 537);
        mainMenu.loadGraphic(AssetPaths.mainmenu__png, true, 201, 27);
        mainMenu.animation.add("blink", [0, 1], 3, false);
        mainMenu.animation.play("blink");
        add(mainMenu);

        
        // replay = new FlxSprite(156.5, 389);
        // replay.loadGraphic(AssetPaths.replaybutton__png, true, 135, 27);
        // replay.animation.add("blink", [0, 1], 3, false);
        // replay.animation.play("blink");
        // add(replay);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
        mainMenu.animation.play("blink");

        if(FlxG.keys.anyJustReleased([M])) {
            var enterGameSound:FlxSound = FlxG.sound.load(AssetPaths.entergame__wav);
            enterGameSound.pitch = 0.8;
            enterGameSound.play();
            FlxG.switchState(new MenuState());
        }
	}

}
