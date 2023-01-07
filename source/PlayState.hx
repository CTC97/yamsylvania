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
	var plots:FlxTypedGroup<Plot>;
	var sortGroup:FlxTypedGroup<FlxSprite>;

	var player_shoot:Bool;
	var playerProjectileCooldown = 0;

	var createEnemyCooldown:Int = 30;

	var flxRandom:FlxRandom;

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

		plots = new FlxTypedGroup<Plot>();
		add(plots);
		
		sortGroup = new FlxTypedGroup<FlxSprite>();
		add(sortGroup);

		projectiles = new FlxTypedGroup<Projectile>();
		add(projectiles);


		player = new Player();
		enemies = new FlxTypedGroup<FlxSprite>();

		map.loadEntities(placeEntities, "entities");


		FlxG.camera.follow(player, TOPDOWN, 1);

		flxRandom = new FlxRandom();

		super.create();
	    /*var text = new flixel.text.FlxText(0, 0, 0, "Hello World", 64);
	    text.screenCenter();
	    add(text);*/
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		// boundaries of 256 on all sides for x, y
		if (createEnemyCooldown <= 0) {
			var createEnemy:Int = Math.round(Math.random() * 100)+enemiesKilled;
			if (createEnemy > 50) {
				var enemyType:Bool = flxRandom.bool();
				var x:Float = flxRandom.float(64*4, 64*16);
				var y:Float = flxRandom.float(64*4, 64*16);
				if (enemyType) {
					var tempEnemy:Vamp = new Vamp(x, y, player);
					enemies.add(tempEnemy);
					sortGroup.add(tempEnemy);
				} else {
					var tempEnemy:Bat = new Bat(x, y, player);
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
		FlxG.overlap(player, plots, playerOverlapPlot);
		FlxG.collide(projectiles, walls, projectileHitWall);

		player_shoot = FlxG.keys.anyPressed([E]);
		if (playerProjectileCooldown > 0) playerProjectileCooldown = playerProjectileCooldown - 1;
		if (playerProjectileCooldown <= 0 && player_shoot && player.getAmmo() > 0) {
			player.addAmmo(-1);
			projectiles.add(new Projectile(player.x, player.y, FlxG.mouse.x, FlxG.mouse.y));
			playerProjectileCooldown = 10;
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
			if (entity.name == "plot") {
				var tempPlot:Plot = new Plot(entity.x, entity.y);
				plots.add(tempPlot);
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

	function playerOverlapPlot(player: Player, plot: Plot) {
		if (plot.getState() == 4) {
			player.addAmmo(flxRandom.int(2, 10));
			plot.setState(0);
		}
	}
}
