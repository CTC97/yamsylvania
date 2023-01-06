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
		//FlxG.mouse.load(AssetPaths.mouse__png);
	}
}
