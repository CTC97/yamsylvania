package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;

class Outbin extends FlxSprite
{

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic(AssetPaths.outbin__png, true, 64, 32);
        setSize(64, 64);
        offset.set(4, 4);

        animation.add("0", [0], 12, true);
        animation.play("0");
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}
