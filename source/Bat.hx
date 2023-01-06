package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;

class Bat extends FlxSprite
{
    var speed:Float;
    var random:FlxRandom;

    var player:Player;

    public function new(x:Float = 0, y:Float = 0, _player:Player)
    {
        super(x, y);
        loadGraphic(AssetPaths.batlarge__png, true, 48, 28);
        drag.x = drag.y = 640;
        setSize(48, 28);
        offset.set(4, 4);

        speed = Math.round(Math.random() * 100) + 10;

        animation.add("fly", [0, 1, 2, 1], 12, true);
        animation.play("fly");

        player = _player;
    }

    function updateMovement()
    {
      FlxVelocity.moveTowardsPoint(this, FlxPoint.weak(player.x, player.y), speed);
    }

    override function update(elapsed:Float)
    {
        updateMovement();
        super.update(elapsed);
    }
}
