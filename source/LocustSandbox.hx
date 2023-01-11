package;

import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.util.FlxSort;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets;

class LocustSandbox extends FlxState
{
	var player:Player;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var enemies:FlxTypedGroup<FlxSprite>;
	var projectiles:FlxTypedGroup<Projectile>;
	var sortGroup:FlxTypedGroup<FlxSprite>;
	var itemDrops:FlxTypedGroup<ItemDrop>;
    var flies:FlxTypedGroup<Fly>;

	var player_shoot:Bool;
	var playerProjectileCooldown = 0;

	private var throwYamSound:FlxSound;
	private var enemyDie:FlxSound;
	private var pickupItemSound:FlxSound;

    var flxRandom:FlxRandom;

    var createFlyCooldown:Int = 30;

    var yilith:Yilith;

	//var hud:HUD;

	override public function create()
	{
		FlxG.camera.bgColor = 0x9775a6;
        flxRandom = new FlxRandom();

		map = new FlxOgmo3Loader(AssetPaths.baseproj__ogmo, AssetPaths.yilithtest__json);
		walls = map.loadTilemap(AssetPaths.tilemap__png, "walls");
		walls.follow();

		walls.setTileProperties(0, NONE);
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, NONE);
		walls.setTileProperties(3, NONE);
		walls.setTileProperties(4, ANY);
		walls.setTileProperties(5, ANY);
		walls.setTileProperties(6, ANY);
		walls.setTileProperties(7, ANY);
		walls.setTileProperties(8, ANY);
		walls.setTileProperties(9, ANY);
		walls.setTileProperties(10, ANY);
		walls.setTileProperties(11, ANY);
		walls.setTileProperties(12, ANY);
		walls.setTileProperties(13, ANY);
		walls.setTileProperties(14, ANY);
		walls.setTileProperties(15, ANY);

		add(walls);

		sortGroup = new FlxTypedGroup<FlxSprite>();
		add(sortGroup);

		projectiles = new FlxTypedGroup<Projectile>();
		add(projectiles);

		itemDrops = new FlxTypedGroup<ItemDrop>();
		add(itemDrops);

        flies = new FlxTypedGroup<Fly>();
        add(flies);

		player = new Player();
		enemies = new FlxTypedGroup<FlxSprite>();

		map.loadEntities(placeEntities, "entities");

		FlxG.camera.follow(player, TOPDOWN, 1);

		/*plotSound = FlxG.sound.load(AssetPaths.harvest__wav);
		depositSound = FlxG.sound.load(AssetPaths.deposityam__wav);
	 	throwYamSound = FlxG.sound.load(AssetPaths.throwyam__wav);
		enemyDie = FlxG.sound.load(AssetPaths.enemydie__wav);
		pickupItemSound = FlxG.sound.load(AssetPaths.pickupitem__wav);*/

		//hud = new HUD();
		//add(hud);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		sortGroup.sort(FlxSort.byY, FlxSort.ASCENDING);

		FlxG.collide(player, walls);
		FlxG.collide(enemies, walls);
		FlxG.overlap(player, enemies, collideWithEnemy);
		FlxG.overlap(projectiles, enemies, projectileHitEnemy);
		FlxG.collide(projectiles, walls, projectileHitWall);
		FlxG.overlap(player, itemDrops, collectItemDrop);

		player_shoot = (FlxG.keys.anyPressed([E]) || FlxG.mouse.pressed);
		if (playerProjectileCooldown > 0) playerProjectileCooldown = playerProjectileCooldown - 1;
		if (playerProjectileCooldown <= 0 && player_shoot && player.getAmmo() > 0) {
			player.addAmmo(-1);
			projectiles.add(new Projectile(player.x, player.y, FlxG.mouse.x, FlxG.mouse.y));
			playerProjectileCooldown = 10;
			//throwYamSound.play();
		}

        if (createFlyCooldown <= 0) {
			//var createFly:Int = Math.round(Math.random() * 100);
			//if (createFly > 10) {
            var yilithHand:Bool = flxRandom.bool();
            var tempFly:Fly;
            if (yilithHand) {
                tempFly = new Fly(yilith.getRightHandX() + flxRandom.float(-1, 1), yilith.getRightHandY() + flxRandom.float(-1,1), player);
            } else {
                tempFly = new Fly(yilith.getLeftHandX() + flxRandom.float(-1, 1), yilith.getLeftHandY() + flxRandom.float(-1,1), player);
            }
            flies.add(tempFly);
            sortGroup.add(tempFly);
			//}
			createFlyCooldown = 2;
		} else {
			createFlyCooldown--;
		}

		//hud.updateHud(player.getPlayerHealth(), player.getAmmo(), enemiesKilled, yamsDelivered);

	}

	function placeEntities(entity:EntityData)
	{
			if (entity.name == "player")
			{
					player.setPosition(entity.x, entity.y);
					sortGroup.add(player);
			}
			if (entity.name == "enemy")
			{
				var tempEnemy:Vamp = new Vamp(entity.x + 4, entity.y + 4, player);
		 		enemies.add(tempEnemy);
				sortGroup.add(tempEnemy);
			}
            if (entity.name == "yilith")
            {
                yilith = new Yilith(entity.x + 4, entity.y + 4, player);
                sortGroup.add(yilith);
            }
	}

	function collideWithEnemy(player: Player, enemy: FlxSprite) {
		if (!player.getInvincible() && player.alive && player.exists && enemy.alive && enemy.exists) {
			player.getHit();
			trace("collide");
		}
	}

	function projectileHitEnemy(projectile: Projectile, enemy: FlxSprite) {
		var dropItem = flxRandom.int(0, 20);
		if (dropItem > 17) {
			var typeDrop = flxRandom.int(0, 5);
			var tempItem:ItemDrop;
			if (typeDrop <= 3) tempItem = new ItemDrop(enemy.x + flxRandom.int(0, 20), enemy.y + flxRandom.int(0, 20), "apple");
			else tempItem = new ItemDrop(enemy.x + flxRandom.int(0, 20), enemy.y + flxRandom.int(0, 20), "garlic");
			itemDrops.add(tempItem);
		}
		projectile.kill();
		enemy.kill();
		//enemiesKilled++;
		enemyDie.play();
	}

	function collectItemDrop(_player: Player, _item: ItemDrop) {
		if (_item.exists) pickupItemSound.play();
		if (_item.getItemName() == "apple") _player.toFullHealth();
		if (_item.getItemName() == "garlic") _player.getGarlic();
		_item.kill();
	}

	function projectileHitWall(projectile: Projectile, wall: FlxTilemap) {
		projectile.kill();
	}

}
