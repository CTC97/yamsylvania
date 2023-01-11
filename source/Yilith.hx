package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;

class Yilith extends FlxSprite
{
    var speed:Float;
    var random:FlxRandom;

    var player:Player;

    public function new(x:Float = 0, y:Float = 0, _player:Player)
    {
        super(x, y);
        loadGraphic(AssetPaths.yilithspritesheet__png, true, 88, 128);
        drag.x = drag.y = 120;
        setSize(80, 80);
        offset.set(4, 30);

        speed = 150;
        
        animation.add("still", [0, 0, 0, 0, 0, 0, 4, 0, 0,0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0,0, 0, 0, 4], 4, true);
        animation.add("walk_passive", [0, 2, 0, 2, 4, 2], 12, true);
        animation.add("attack", [1, 1, 1, 5], 12, true);
        animation.add("hurt", [6], 1, false);

        animation.play("still");

        player = _player;
    }

    function updateMovement()
    {
      //FlxVelocity.moveTowardsPoint(this, FlxPoint.weak(player.x, player.y), speed);
    }

    override function update(elapsed:Float)
    {
        updateMovement();
        super.update(elapsed);
    }

    public function getLeftHandX()
    {
        return x+16;
    }

    public function getLeftHandY()
    {
        return y+80;
    }

    public function getRightHandX()
    {
        return x + 74;
    }

    public function getRightHandY()
    {
        return y + 80;
    }
}
