package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;

class Vamp extends FlxSprite
{
    var speed:Float;
    var random:FlxRandom;

    var player:Player;

    public function new(x:Float = 0, y:Float = 0, _player:Player)
    {
        super(x, y);
        loadGraphic(AssetPaths.vamplarge__png, true, 32, 56);
        drag.x = drag.y = 640;
        setSize(32, 56);
        offset.set(4, 4);

        speed = Math.round(Math.random() * 100) + 10;

        animation.add("left", [2,3], 6, false);
        animation.add("right", [0,1], 6, false);

        player = _player;
    }

    function updateMovement()
    {
      if (velocity.x > 0) animation.play("right");
      if (velocity.x < 0) animation.play("left");
      FlxVelocity.moveTowardsPoint(this, FlxPoint.weak(player.x, player.y), speed);
    }

    override function update(elapsed:Float)
    {
        updateMovement();
        super.update(elapsed);
    }
}
