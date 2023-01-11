package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;

class Fly extends FlxSprite
{
    var speed:Float;
    var random:FlxRandom;

    var player:Player;

    var flxRandom:FlxRandom;

    public function new(x:Float = 0, y:Float = 0, _player:Player)
    {
        super(x, y);
        flxRandom = new FlxRandom();

        loadGraphic(AssetPaths.fly__png, false, 4, 4);
        drag.x = drag.y = 20;
        setSize(4, 4);
        offset.set(0, 0);

        speed = Math.round(Math.random() * 80) + 10;

        player = _player;
    }

    function updateMovement()
    {
      FlxVelocity.moveTowardsPoint(this, FlxPoint.weak(player.x + flxRandom.float(-200, 200), player.y + flxRandom.float(-200, 200)), speed);
    }

    override function update(elapsed:Float)
    {
        updateMovement();
        super.update(elapsed);
    }
}
