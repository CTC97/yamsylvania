package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;

class Plot extends FlxSprite
{
    var random:FlxRandom;
    var state:Int;

    var growthTime:Int;
    
    private var growthTimeSet:Int;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        growthTimeSet = 90;
        growthTime = growthTimeSet;
        state = 0;

        loadGraphic(AssetPaths.plot__png, true, 64, 64);
        setSize(64, 64);
        offset.set(4, 4);

        animation.add("0", [0], 12, true);
        animation.add("1", [1], 12, true);
        animation.add("2", [2], 12, true);
        animation.add("4", [3,4], 3, true);

        animation.play("fly");
    }

    function updatePlot()
    {
        //trace("updating plot ", growthTime);
        if (growthTime <= 0) {
            if (state < 4) {
                state++;
                growthTime = growthTimeSet;
            }
        } else {
            growthTime--;
        }
        //trace("playing ", Std.string(state));

        animation.play(Std.string(state));
    }

    override function update(elapsed:Float)
    {
        updatePlot();
        super.update(elapsed);
    }

    public function getState() {
        return state;
    }

    public function setState(_state:Int) {
        state = _state;
        growthTime = growthTimeSet;
    }
}
