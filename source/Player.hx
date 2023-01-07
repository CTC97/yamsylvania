package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class Player extends FlxSprite
{
    //static inline var speed:Float = 200;
    var speed:Float = 250;

    // left = false, right = true
    var idle_right:Bool = true;
    public var last_direction:String = "right";

    var still:Bool = true;

    var up:Bool = false;
    var down:Bool = false;
    var left:Bool = false;
    var right:Bool = false;

    var movement:Float = 0;

    var stepSound:FlxSound;
    var runSound:FlxSound;

    var ammo:Int;

    var playerHealth:Int;
    var hitCooldown:Int;
    var hitCooldownSet:Int;

    var invincible:Bool;

    var hurtSound:FlxSound;
   // public var staminaCoolDown:Int = 200;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        loadGraphic(AssetPaths.farmerlarge__png, true, 48, 56);
         /* "assets/images/clouba.png" */
        drag.x = drag.y = 400;
        setSize(48, 56);
        offset.set(24, 28);

        ammo = 3;
        playerHealth = 3;
        hitCooldownSet = 90;
        hitCooldown = hitCooldownSet;
        invincible = false;

        hurtSound = FlxG.sound.load(AssetPaths.playerHurt__wav);

        /* FOOTSTEP SOUNDS

        stepSound = FlxG.sound.load(AssetPaths.walking_grass__wav);
        stepSound.volume = 0.05;

        runSound = FlxG.sound.load(AssetPaths.running_grass__wav);
        runSound.volume = 0.1;*/
        // offset controls the position of the hitbox
        offset.set(4, 4);

        animation.add("right", [2,3], 12, false);
        animation.add("idle_right", [0,0,1], 6, false);
        animation.add("left", [4,5], 12, false);
        animation.add("idle_left", [6, 6, 7], 6, false);
    }

    function updateMovement()
    {
      if (invincible) {
        alpha = 0.5;
        if (hitCooldown <= 0) {
          invincible = false;
          hitCooldown = hitCooldownSet;
        } else {
          hitCooldown--;
        }
      } else {
        alpha = 1;
      }

      up = FlxG.keys.anyPressed([UP, W]);
      down = FlxG.keys.anyPressed([DOWN, S]);
      left = FlxG.keys.anyPressed([LEFT, A]);
      right = FlxG.keys.anyPressed([RIGHT, D]);

      if (up && down)
          up = down = false;
      if (left && right)
          left = right = false;

      if (up) {
        //last_direction = "up";
        velocity.y = -1*speed;
      }
      else if (down) {
        //last_direction = "down";
        velocity.y = speed;
      }
      else if (left) {
        last_direction = "left";
        velocity.x = -1*speed;
      }
      else if (right) {
        last_direction = "right";
        velocity.x = speed;
      } else {
        velocity.x = velocity.y = 0;
      }

      if ((velocity.x != 0 || velocity.y != 0))// && touching == NONE)
      {
        animation.play(last_direction);
      } else {
        if (still) { animation.play(("idle_"+last_direction)); }
      }
    }

    override function update(elapsed:Float)
    {
        updateMovement();

        super.update(elapsed);
    }

    public function stopMovement() {
      up = down = left = right = false;
    }

    public function getAmmo() {
      return ammo;
    }

    public function addAmmo(amount:Int){
      ammo += amount;
    }

    public function getPlayerHealth() {
      return playerHealth;
    }

    public function getHit() {
      invincible = true;
      playerHealth--;
      hurtSound.play();
      if (playerHealth == 0) {
        trace("ENEMIES KILLED: ", PlayState.getEnemiesKilled());
        trace("YAMS DELIVERED: ", PlayState.getYamsDelivered());
        FlxG.switchState(new MenuState());
      }
    }

    public function getInvincible() {
      return invincible;
    }

}
