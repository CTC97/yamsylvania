package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class Player extends FlxSprite
{
    //static inline var speed:Float = 200;
    var movedYet:Bool;
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
    var hurtCooldown:Int;
    var hurtCooldownSet:Int;
    var isHurt:Bool;
   // public var staminaCoolDown:Int = 200;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        movedYet = false;

        loadGraphic(AssetPaths.farmernewlarge__png, true, 42, 72);
         /* "assets/images/clouba.png" */
        drag.x = drag.y = 400;
        setSize(42, 72);
        offset.set(24, 28);

        ammo = 3;
        playerHealth = 3;
        hitCooldownSet = 90;
        hitCooldown = hitCooldownSet;
        hurtCooldown = 10;
        hurtCooldownSet = 10;
        invincible = false;
        isHurt = false;

        hurtSound = FlxG.sound.load(AssetPaths.playerHurt__wav);

        /* FOOTSTEP SOUNDS

        stepSound = FlxG.sound.load(AssetPaths.walking_grass__wav);
        stepSound.volume = 0.05;

        runSound = FlxG.sound.load(AssetPaths.running_grass__wav);
        runSound.volume = 0.1;*/
        // offset controls the position of the hitbox
        offset.set(4, 4);

        animation.add("right", [5,6], 8, false);
        animation.add("idle_right", [3,4], 4, false);
        animation.add("left", [7,8], 8, false);
        animation.add("idle_left", [10,9], 4, false);
        animation.add("start", [0], 3, false);
        animation.add("hurt", [1], 3, false);
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
        movedYet = true;
        animation.play(last_direction);
      } else {
        if (still) { 
          animation.play(("idle_"+last_direction));
          if (!movedYet) animation.play("start");
        }
      }

      if (isHurt && hurtCooldown > 0) {
        animation.play("hurt");
        hurtCooldown--;
        if (hurtCooldown <= 0) {
          hurtCooldown = hurtCooldownSet;
          isHurt = false;
        }
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
      isHurt = true;
      animation.play("hurt");
      if (playerHealth == 0) {
        trace("ENEMIES KILLED: ", PlayState.getEnemiesKilled());
        trace("YAMS DELIVERED: ", PlayState.getYamsDelivered());
        var deathScreen = new DeathScreen();
        deathScreen.setStats(PlayState.getEnemiesKilled(), PlayState.getYamsDelivered());
        FlxG.switchState(deathScreen);
      }
    }

    public function getInvincible() {
      return invincible;
    }

    public function toFullHealth() {
      playerHealth = 3;
    }

}
