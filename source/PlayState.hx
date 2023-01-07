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

class PlayState extends FlxState
{
	var player:Player;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var enemies:FlxTypedGroup<FlxSprite>;
	var projectiles:FlxTypedGroup<Projectile>;
	var plots:FlxTypedGroup<Plot>;
	var outbins:FlxTypedGroup<Outbin>;
	var sortGroup:FlxTypedGroup<FlxSprite>;

	var player_shoot:Bool;
	var playerProjectileCooldown = 0;

	var createEnemyCooldown:Int = 30;

	var flxRandom:FlxRandom;

	private var plotSound:FlxSound;
	private var depositSound:FlxSound;
	private var throwYamSound:FlxSound;
	private var enemyDie:FlxSound;

	static var yamsDelivered:Int;
	static var enemiesKilled:Int;

	private var depositCooldown:Int;
	private var depositCooldownSet:Int;

	var healthText:FlxText;

	var hud:HUD;

	override public function create()
	{
		enemiesKilled = 0;
		yamsDelivered = 0;

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

		outbins = new FlxTypedGroup<Outbin>();
		add(outbins);
		
		sortGroup = new FlxTypedGroup<FlxSprite>();
		add(sortGroup);

		projectiles = new FlxTypedGroup<Projectile>();
		add(projectiles);


		player = new Player();
		enemies = new FlxTypedGroup<FlxSprite>();

		map.loadEntities(placeEntities, "entities");


		FlxG.camera.follow(player, TOPDOWN, 1);

		flxRandom = new FlxRandom();

		plotSound = FlxG.sound.load(AssetPaths.harvest__wav);
		depositSound = FlxG.sound.load(AssetPaths.deposityam__wav);
	 	throwYamSound = FlxG.sound.load(AssetPaths.throwyam__wav);
		enemyDie = FlxG.sound.load(AssetPaths.enemydie__wav);


		//FlxAssets.FONT_DEFAULT = "assets/fonts/pixelicons.ttf";

		// healthText = new FlxText(4, 4, 0, "Health: " + Std.string(player.getPlayerHealth()), 16);
		// healthText.scrollFactor.set(0, 0);
		// //healthText.systemFont = "assets/fonts/pixelicons.ttf";
		// healthText.setFormat("assets/fonts/alagard.ttf", 64);
	    // add(healthText);

		hud = new HUD();
		add(hud);

		depositCooldown = 5;
		depositCooldownSet = 5;

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	
		// boundaries of 256 on all sides for x, y
		if (createEnemyCooldown <= 0) {
			var createEnemy:Int = Math.round(Math.random() * 100)+enemiesKilled;
			if (createEnemy > 50) {
				var enemyType:Bool = flxRandom.bool();
				var validSpawn:Bool = false;
				var x:Float = 0;
				var y:Float = 0;
				while(!validSpawn) {
					x = flxRandom.float(64*4, 64*16);
					y = flxRandom.float(64*4, 64*16);
					validSpawn = true;
					if (Math.abs(player.x-x) < 96 || Math.abs(player.y-y) < 96) {
						validSpawn = false; 
						trace("invalid spawn prevented");
					}
				}
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

		depositCooldown--;


		sortGroup.sort(FlxSort.byY, FlxSort.ASCENDING);

		FlxG.collide(player, walls);
		FlxG.collide(enemies, walls);
		FlxG.overlap(player, enemies, collideWithEnemy);
		FlxG.overlap(projectiles, enemies, projectileHitEnemy);
		FlxG.overlap(player, plots, playerOverlapPlot);
		FlxG.collide(projectiles, walls, projectileHitWall);
		FlxG.overlap(player, outbins, playerCollideOutbin);
		FlxG.collide(outbins, walls);

		player_shoot = FlxG.keys.anyPressed([E]);
		if (playerProjectileCooldown > 0) playerProjectileCooldown = playerProjectileCooldown - 1;
		if (playerProjectileCooldown <= 0 && player_shoot && player.getAmmo() > 0) {
			player.addAmmo(-1);
			projectiles.add(new Projectile(player.x, player.y, FlxG.mouse.x, FlxG.mouse.y));
			playerProjectileCooldown = 10;
			throwYamSound.play();
		}

		hud.updateHud(player.getPlayerHealth(), player.getAmmo(), enemiesKilled, yamsDelivered);

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
			if (entity.name == "outbin") {
				var tempOutbin:Outbin = new Outbin(entity.x, entity.y);
				outbins.add(tempOutbin);
			}
	}

	function collideWithEnemy(player: Player, enemy: FlxSprite) {
		if (!player.getInvincible() && player.alive && player.exists && enemy.alive && enemy.exists) {
			player.getHit();
			trace("collide");
		}
	}

	function projectileHitEnemy(projectile: Projectile, enemy: FlxSprite) {
		projectile.kill();
		enemy.kill();
		enemiesKilled++;
		enemyDie.play();
	}

	function projectileHitWall(projectile: Projectile, wall: FlxTilemap) {
		projectile.kill();
	}

	function playerOverlapPlot(player: Player, plot: Plot) {
		if (plot.getState() == 4) {
			plotSound.play();
			player.addAmmo(flxRandom.int(2, 10));
			plot.setState(0);
		}
	}

	function playerCollideOutbin(player: Player, outbin: Outbin) {
		if (depositCooldown <= 0 && player.getAmmo() > 0 && FlxG.keys.anyJustReleased([Q])) {
			player.addAmmo(-1);
			yamsDelivered++;
			displayYam(outbin);
			depositCooldown = depositCooldownSet;
		}
	}

	public static function getEnemiesKilled() {
		return enemiesKilled;
	}

	public static function getYamsDelivered() {
		return yamsDelivered;
	}

	public function displayYam(outbin: Outbin) {
		trace("displaying yam");
		var tempYamVisual:FlxSprite = new FlxSprite(outbin.x + flxRandom.int(0, 32), outbin.y);
		tempYamVisual.loadGraphic(AssetPaths.yamlarge__png, true, 30, 30);
		tempYamVisual.animation.add("one", [0], 6, false);
		tempYamVisual.animation.play("one");
		add(tempYamVisual);
		depositSound.play();
		FlxTween.tween(tempYamVisual, {y: 0, alpha: 0, exists: false, alive:false}, 2);
	}
}
