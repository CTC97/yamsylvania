package;

import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class DeathScreen extends FlxState
{
  var playButton:FlxButton;
  var bg:FlxSprite;
  var replay:FlxSprite;
  var mainMenu:FlxSprite;
  var enter:FlxSprite;

  var fadeCooldown:Int;
  var fading:Bool;
  private var numKills:Int;
  private var numDels:Int;

	override public function create()
	{
		super.create();

        fadeCooldown = 60;
        fading = false;

        bg = new FlxSprite(0, 0);
        bg.loadGraphic(AssetPaths.yamsylvaniadeath__png, false, 768, 576);
        add(bg);

        /*playButton = new FlxButton(0, 0, "Play", clickPlay);
        playButton.screenCenter();
        add(playButton);*/
        var deliveries = new flixel.text.FlxText(8, 8, 0, "Deliveries: " + Std.string(numDels), 26);
        deliveries.screenCenter();
        deliveries.y = deliveries.y - 40 + 20;
        deliveries.color = 0x9775a6;
	    add(deliveries);

        var kills = new flixel.text.FlxText(8, 8, 0, "Kills: " + Std.string(numKills), 26);
        kills.screenCenter();
        kills.y = kills.y + 20;
        kills.color = 0x9775a6;
	    add(kills);

        replay = new FlxSprite(156.5, 389);
        replay.loadGraphic(AssetPaths.replaybutton__png, true, 135, 27);
        replay.animation.add("blink", [0, 1], 3, false);
        replay.animation.play("blink");
        add(replay);

        mainMenu = new FlxSprite(450, 389);
        mainMenu.loadGraphic(AssetPaths.mainmenu__png, true, 201, 27);
        mainMenu.animation.add("blink", [0, 1], 3, false);
        mainMenu.animation.play("blink");
        add(mainMenu);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
        replay.animation.play("blink");
        mainMenu.animation.play("blink");

        if(FlxG.keys.anyJustReleased([R])) {
        var enterGameSound:FlxSound = FlxG.sound.load(AssetPaths.entergame__wav);
        enterGameSound.pitch = 0.8;
        enterGameSound.play();
        FlxG.camera.fade(0x2d162c, 1, false);
        fading = true;
        }
        if(FlxG.keys.anyJustReleased([M])) {
            FlxG.switchState(new MenuState());
        }
        if (fading) {
        if (fadeCooldown <= 0) FlxG.switchState(new PlayState());
        else fadeCooldown--;
        }
	}

    public function setStats(kills: Int, deliveries: Int) {
        numKills = kills;
        numDels = deliveries;

        Stats.writeStats(deliveries, kills);
    }

}
