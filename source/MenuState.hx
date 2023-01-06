package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState
{
  var playButton:FlxButton;

	override public function create()
	{
		super.create();

    playButton = new FlxButton(0, 0, "Play", clickPlay);
    playButton.screenCenter();
    add(playButton);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

  function clickPlay()
  {
    FlxG.switchState(new PlayState());
  }
}
