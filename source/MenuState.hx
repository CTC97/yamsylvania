package;

import flixel.system.debug.console.ConsoleHistory;
import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState
{
  var playButton:FlxButton;
  var bg:FlxSprite;
  var enter:FlxSprite;
  var controls:FlxSprite;
  var lore:FlxSprite;

  var fadeCooldown:Int;
  var fading:Bool;

	override public function create()
	{
		super.create();

    fadeCooldown = 60;
    fading = false;

    bg = new FlxSprite(0, 0);
    bg.loadGraphic(AssetPaths.yamsylvaniatitle__png, false, 768, 576);
    add(bg);

    /*playButton = new FlxButton(0, 0, "Play", clickPlay);
    playButton.screenCenter();
    add(playButton);*/
    enter = new FlxSprite(318.5, 265);
    enter.loadGraphic(AssetPaths.enterbutton__png, true, 125, 27);
    enter.animation.add("blink", [0, 1], 3, false);
    enter.animation.play("blink");
    add(enter);

    controls = new FlxSprite(145, 364);
    controls.loadGraphic(AssetPaths.controlsblink__png, true, 176, 27);
    controls.animation.add("blink", [0, 1], 3, false);
    add(controls);

    lore = new FlxSprite(504, 364);
    lore.loadGraphic(AssetPaths.loreblink__png, true, 96, 27);
    lore.animation.add("blink", [0, 1], 3, false);
    add(lore);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
    enter.animation.play("blink");
    controls.animation.play("blink");
    lore.animation.play("blink");

    if (FlxG.keys.anyJustReleased([C])) {
      var controlSound:FlxSound = FlxG.sound.load(AssetPaths.harvest__wav);
      controlSound.pitch = 0.8;
      controlSound.play();
      FlxG.switchState(new Controls());
    }
    if (FlxG.keys.anyJustReleased([L])) {
      var controlSound:FlxSound = FlxG.sound.load(AssetPaths.harvest__wav);
      controlSound.pitch = 0.8;
      controlSound.play();
      FlxG.switchState(new Lore());
    }
    if(FlxG.keys.anyJustReleased([ENTER])) {
      var enterGameSound:FlxSound = FlxG.sound.load(AssetPaths.entergame__wav);
      enterGameSound.pitch = 0.8;
      enterGameSound.play();
      FlxG.camera.fade(0x2d162c, 1, false);
      fading = true;
    }
    if (fading) {
      if (fadeCooldown <= 0) FlxG.switchState(new PlayState());
      else fadeCooldown--;
    }
	}

}
