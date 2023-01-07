package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;
import flixel.system.FlxSound;

class Projectile extends FlxSprite
{
    var speed:Float;

    // left = false, right = true
    var idle_right:Bool = true;
    var still:Bool = true;

    var up:Bool = false;
    var down:Bool = false;
    var left:Bool = false;
    var right:Bool = false;

    var xDest:Float;
    var yDest:Float;

    var velX:Float;
    var velY:Float;

    var random:FlxRandom;

    var moving:Bool = false;

    public function new(x:Float = 0, y:Float = 0, _xDest:Float, _yDest:Float)
    {
        super(x, y);
        loadGraphic(AssetPaths.yamlarge__png, true, 30, 30);
         /* "assets/images/clouba.png" */
        drag.x = drag.y = 640;
        setSize(30, 30);
        offset.set(4, 4);

        xDest = _xDest;
        yDest = _yDest;

        speed = 350;

        var projectileSound:FlxSound = FlxG.sound.load(AssetPaths.projectile__wav);
        //projectileSound.volume = 0.1;
        projectileSound.play();

      /*  setFacingFlip(LEFT, false, false);
        setFacingFlip(RIGHT, true, false);*/

        animation.add("one", [0], 6, false);

        animation.play("one");
    }


    override function update(elapsed:Float)
    {
        if(!moving) {
          moving = true;
          FlxVelocity.moveTowardsPoint(this, FlxPoint.weak(xDest, yDest), speed);
          //trace(velocity.x, velocity.y);
          velX = velocity.x;
          velY = velocity.y;
        }

        velocity.x = velX;
        velocity.y = velY;

        super.update(elapsed);
    }

    /*public function depuff(){
      puffy = false;
    }*/
}
