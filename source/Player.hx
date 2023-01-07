package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class Player extends FlxSprite
{
    //static inline var speed:Float = 200;
    var speed:Float = 200;

    // left = false, right = true
    var idle_right:Bool = true;
    public var last_direction:String = "right";

    var still:Bool = true;

    var up:Bool = false;
    var down:Bool = false;
    var left:Bool = false;
    var right:Bool = false;

    var running:Bool = false;

    var movement:Float = 0;

    var stepSound:FlxSound;
    var runSound:FlxSound;

    var ammo:Int;

    var playerHealth:Int;
    var hitCooldown:Int;
    var hitCooldownSet:Int;

    public var stamina:Int = 1500;
    var invincible:Bool;

    var hurtSound:FlxSound;
   // public var staminaCoolDown:Int = 200;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        loadGraphic(AssetPaths.farmerlarge__png, true, 48, 56);
         /* "assets/images/clouba.png" */
        drag.x = drag.y = 640;
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

      /*  setFacingFlip(LEFT, false, false);
        setFacingFlip(RIGHT, true, false);*/

        animation.add("right", [2,3], 8, false);
        animation.add("idle_right", [0,0,1], 6, false);
        animation.add("left", [4,5], 6, false);
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

      running = FlxG.keys.anyPressed([SHIFT]);

      if (stamina < 0) {
        running = false;
        //if (stamina == 0) { stamina = staminaCoolDown; }
      }
      //if (stamina > 0)
      if (running) {
      /*  if (velocity.x != 0 || velocity.y != 0) {
          //stepSound.stop();
          runSound.play();
        }*/
       /* stamina = stamina - 3;
        if (stamina > 0) {
          speed = 200;
        } else { running = false; }*/
        //if (left || right) { animation.curAnim.frameRate = 60; }
        speed = 200;
      } else {
      //  runSound.stop();
        speed = 100;
        //stamina = stamina + 3;
        //if (stamina > 1100) {stamina = 1100; }
      }

      if (up && down)
          up = down = false;
      /*if (up && left)
          up = left = false;
      if (up && right)
          up = right = false;*/
      if (left && right)
          left = right = false;
     /* if (left && down)
          left = down = false;
      if (down && right)
          down = right = false;*/

    /*  if (up || down || left || right) {
        still = false;
        if (running)
          runSound.play();
        else
          stepSound.play();
      } else {
        still = true;
        runSound.stop();
        stepSound.stop();
      }*/

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
