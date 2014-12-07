library Game;

import "dart:html";
import "dart:math" as math;
import "dart:web_audio";

part 'ResManager.dart';
part 'Level.dart';
part 'DrawingCanvas.dart';
part 'ScreenCanvas.dart';
part 'Sprite.dart';
part 'Player.dart';
part 'Angle.dart';
part 'Vector.dart';
part 'Vector2f.dart';
part 'ui.dart';
part 'Rect.dart';
part 'BurnableZone.dart';
part 'Fire.dart';
part 'Water.dart';

class Game
{
	final int _screenWidth = 945;
	final int _screenHeight = 640;
	int _loadedImageCounter = 0;
	List<String> _imagesToLoad;
	List<String> _soundsToLoad;
	List<BurnableZone> _burnables;
	double lastUpdated;
	double _start;
	bool gameStarted = false;
	AudioContext audioCtx;
	bool gameFinished = false;
	DrawingCanvas c;
	Level lvl;
	Water _water;
	UI _ui;
	Player player;

	Game()
	{
		audioCtx = new AudioContext();
		c = new DrawingCanvas();
		lvl = new Level();
		_water = new Water();
		player = new Player(audioCtx);
		Rect uiPos = new Rect(0,0,0,0);
		uiPos
			..x = _screenWidth - 20
			..y = _screenHeight - 100
			..width = 20
			..height = 100;
		_ui = new UI(player, uiPos);

		_imagesToLoad = ["resources/img/map.png",
				"resources/img/helicopter.png",
				"resources/img/player.png",
				"resources/img/water.png",
				"resources/img/menu.png",
				"resources/img/fire.png"];
		_soundsToLoad = ["resources/sounds/heli_start.wav",
				"resources/sounds/heli.wav",
				"resources/sounds/fuel.wav"];
		load();

		// register events
		document.onKeyDown.listen(handleInput);
		document.onKeyUp.listen(handleInput);

		// create burnable Zones
		_burnables = [ new BurnableZone(new Rect(380,-32,550,230)),
				new BurnableZone(new Rect(678,255,232,382))];
	}
	
	void load()
	{
		for(String url in _imagesToLoad) {
			ResManager.load(url, loadedImageCallback);
		}
		for(String url in _soundsToLoad) {
			ResManager.loadSound(url, audioCtx);
		}
	}

	void loadedImageCallback() 
	{
		_loadedImageCounter++;
		if(_loadedImageCounter >= _imagesToLoad.length) {
			start();
		}
	}

	void start()
	{
		c.canvas.context2D.drawImage(ResManager.get("resources/img/menu.png"),0,0);
		c.flip();
	}

	void mainLoop(double delta)
	{
		if(lastUpdated == null) {
			lastUpdated = delta;
			if(_start == null) {
				_start = delta;
			}
		} 
		if(!player.gameOver) {
			for(BurnableZone burnable in _burnables) {
				burnable.update(delta);
			}
			_water.update(delta);
			player.update(delta);

			if(delta-lastUpdated > 15) {
				lastUpdated = delta;
				lvl.draw(c);
				_water.draw(c);
				for(BurnableZone burnable in _burnables) {
					burnable.draw(c);
				}
				player.draw(c);
				_ui.draw(c);
				drawTime(delta);
				c.flip();

			}
			if(delta-_start > 10000) {
				if(checkForEnd()) {
					player.gameOver = true;
				}
			}

			window.requestAnimationFrame(mainLoop);
		} else {
			if(!checkForEnd()) {
				showGameOver();
			} else {
				showWin(delta);
			}
		}
	}

	void drawTime(delta)
	{
		String sec = ((delta-_start)/1000).toStringAsFixed(2);
		c.canvas.context2D
			..fillStyle = "#F00"
			..strokeStyle = "#000"
			..font = "20pt Courier"
			..fillText(sec + "s" , 10, _screenHeight-5)
			..strokeText(sec + "s" , 10, _screenHeight-5)
			..fill()
			..stroke();
	}

	bool checkForEnd()
	{
		bool retVal = true;
		for(BurnableZone burnable in _burnables) {
			if(burnable.getBurningFires() > 0) {
				retVal = false;
			}
		}
		return retVal;
	}

	void showGameOver()
	{
		c.canvas.context2D
			..fillStyle = "#F00"
			..fillRect(0,0, _screenWidth, _screenHeight)
			..fillStyle = "#FFF"
			..font = 'italic 40pt Courier'
			..fillText("GAME OVER!", 100,100)
			..font = '20pt Courier'
			..fillText(player.why, 100,150)
			..fillText("Reload page to restart!", 100,180);
		c.flip();
	}
	
	void showWin(double delta)
	{
		String sec = ((delta-_start)/1000).toStringAsFixed(2);
		c.canvas.context2D
			..fillStyle = "#0F0"
			..fillRect(0,0, _screenWidth, _screenHeight)
			..fillStyle = "#000"
			..font = 'italic 40pt Courier'
			..fillText("GREAT!", 100,100)
			..font = '20pt Courier'
			..fillText("You extinguished all fires in " + sec + " seconds!", 100,150)
			..fillText("Reload page to restart!", 100,180);
		c.flip();
	}

	void handleInput(KeyboardEvent event)
	{
		int key = event.keyCode;

		if(!player.gameOver) {
			switch(key) {
				case KeyCode.A:
					player.rotateLeft();
					break;
				case KeyCode.D:
					player.rotateRight();
					break;
				case KeyCode.W:
					player.moveForward();
					break;
				case KeyCode.S:
					player.moveBackward();
					break;
				case KeyCode.ENTER:
					if(gameStarted) {
						if(player.getWaterFilling()>=90.0) {
							player.looseWater();
							for(BurnableZone zone in _burnables) {
								zone.extinguishFire(player.getHelicopterPos());
							}
						}
					} else {
						gameStarted = true;
						print("Start game!");
						window.requestAnimationFrame(mainLoop);
					}
					break;
				case KeyCode.E:
					player.startLand();
					break;
			}
		}
	}
}
