package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public function new()
	{
		super();

		FlxG.autoPause=false;

		addChild(new FlxGame(768, 576, MenuState, 60, 60, true));

		//FlxG.mouse.visible = false;
		FlxG.mouse.load(AssetPaths.yammouse__png);
		if (FlxG.sound.music == null) // don't restart the music if it's already playing
		{
			FlxG.sound.playMusic(AssetPaths.yamsylvaniatheme__ogg, 1, true);
		}
	}
}
