package;

import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.util.FlxSort;
import flixel.math.FlxRandom;

class PlayState extends FlxState
{
	var player:Player;

	var enemiesKilled:Int = 0;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var enemies:FlxTypedGroup<FlxSprite>;
	var projectiles:FlxTypedGroup<Projectile>;

	var sortGroup:FlxTypedGroup<FlxSprite>;

	var player_shoot:Bool;
	var playerProjectileCooldown = 0;

	var createEnemyCooldown:Int = 30;

	override public function create()
	{
		map = new FlxOgmo3Loader(AssetPaths.baseproj__ogmo, AssetPaths.baselevel__json);
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

		add(walls);

		projectiles = new FlxTypedGroup<Projectile>();
		add(projectiles);

		sortGroup = new FlxTypedGroup<FlxSprite>();
		add(sortGroup);

		player = new Player();
		enemies = new FlxTypedGroup<FlxSprite>();

		map.loadEntities(placeEntities, "entities");


		FlxG.camera.follow(player, TOPDOWN, 1);

		super.create();
	    /*var text = new flixel.text.FlxText(0, 0, 0, "Hello World", 64);
	    text.screenCenter();
	    add(text);*/
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (createEnemyCooldown <= 0) {
			var createEnemy:Int = Math.round(Math.random() * 100)+enemiesKilled;
			trace("createEnemy", createEnemy);
			if (createEnemy > 50) {
				trace("creating enemy");
				var enemyType:Int = Math.round(Math.random() * 10);
				if (enemyType < 5) {
					trace("creating vamp");
					var tempEnemy:Vamp = new Vamp(200 + 4, 200, player);
					enemies.add(tempEnemy);
					sortGroup.add(tempEnemy);
				} else {
					trace("creating bat");
					var tempEnemy:Bat = new Bat(500, 500, player);
					enemies.add(tempEnemy);
					sortGroup.add(tempEnemy);
				}
			}
			createEnemyCooldown = 30;
		} else {
			createEnemyCooldown--;
		}


		sortGroup.sort(FlxSort.byY, FlxSort.ASCENDING);

		FlxG.collide(player, walls);
		FlxG.collide(enemies, walls);
		FlxG.overlap(player, enemies, collideWithEnemy);
		FlxG.overlap(projectiles, enemies, projectileHitEnemy);
		FlxG.collide(projectiles, walls, projectileHitWall);

		player_shoot = FlxG.keys.anyPressed([E]);
		if (playerProjectileCooldown > 0) playerProjectileCooldown = playerProjectileCooldown - 1;
		if (playerProjectileCooldown <= 0 && player_shoot) {
			projectiles.add(new Projectile(player.x, player.y, FlxG.mouse.x, FlxG.mouse.y));
			playerProjectileCooldown = 100;
		}

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
	}

	function collideWithEnemy(player: Player, enemy: FlxSprite) {
		if (player.alive && player.exists && enemy.alive && enemy.exists) {
			trace("collide");
		}
	}

	function projectileHitEnemy(projectile: Projectile, enemy: FlxSprite) {
		projectile.kill();
		enemy.kill();
		enemiesKilled++;
	}

	function projectileHitWall(projectile: Projectile, wall: FlxTilemap) {
		projectile.kill();
	}
}
