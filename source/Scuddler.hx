package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;

class Scuddler extends FlxSprite
{
    static inline var speed:Float = 100;

    // left = false, right = true
    var idle_right:Bool = true;
    var still:Bool = true;

    var up:Bool = false;
    var down:Bool = false;
    var left:Bool = false;
    var right:Bool = false;

    var random:FlxRandom;

    var stability:Float = Math.round(Math.random() * 100) + 100;
    var movement:Float = 0;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        loadGraphic(AssetPaths.scuddlersprite__png, true, 72, 76);
         /* "assets/images/clouba.png" */
        drag.x = drag.y = 10;
        setSize(76, 64);
        offset.set(4, 4);

      /*  setFacingFlip(LEFT, false, false);
        setFacingFlip(RIGHT, true, false);*/

        animation.add("left", [7, 5, 6, 5], 6, false);
        animation.add("right", [2, 4, 3, 4], 6, false);
        animation.add("idle_left", [9, 5, 9, 5, 8, 5], 3, false);
        animation.add("idle_right", [0, 4, 0, 4, 1, 4], 3, false);
    }

    function updateMovement()
    {
      movement = movement + 1;
      if (movement % stability == 0) {
        logic();
      }

      //trace(up, down, left, right);
      if (up) {
        velocity.y = -1*speed;
      }
      else if (down) {
        velocity.y = speed;
      }
      else if (left) {

        velocity.x = -1*speed;
        idle_right = false;
      }

      else if (right) {

        velocity.x = speed;
        idle_right = true;

      } else {
        velocity.x = velocity.y = 0;
      }

      if ((velocity.x != 0 || velocity.y != 0))// && touching == NONE)
      {
        if (left) {
          animation.play("left");
        }
        if (right) {
          animation.play("right");
        }
      } else {
        if (still) {
          if (idle_right) {
            animation.play("idle_right");
          }
          else {
            animation.play("idle_left");
          }
        }
      }
    }

    public function logic() {
      stability = Math.round(Math.random() * 100) + 100;
      var dir:Float = Math.random();
      //trace("logic -> dir ", dir);
      if (dir <= 0.15){
        left = true;
        down = right = up = false;
      }
      else if (dir <= 0.3){
        right = true;
        left = down = up = false;
      }
      else if (dir <= 0.45){
        down = true;
        left = right = up = false;
      }
      else if (dir <= 0.6){
        up = true;
        down = left = right = false;
      }
      else
        up = down = left = right = false;
    }

    override function update(elapsed:Float)
    {
        updateMovement();
        super.update(elapsed);
    }
}