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
part 'ui.dart';
part 'Rect.dart';

class Game
{
	final int _screenWidth = 1024;
	final int _screenHeight = 640;
	int _loadedImageCounter = 0;
	List<String> _imagesToLoad;
	List<String> _soundsToLoad;
	AudioContext audioCtx;
	bool gameFinished = false;
	DrawingCanvas c;
	Level lvl;
	UI _ui;
	Player player;

	Game()
	{
		audioCtx = new AudioContext();
		c = new DrawingCanvas();
		lvl = new Level();
		player = new Player(audioCtx);
		Rect uiPos = new Rect();
		uiPos
			..x = _screenWidth - 20
			..y = _screenHeight - 100
			..width = 20
			..height = 100;
		_ui = new UI(player, uiPos);

		_imagesToLoad = ["resources/img/map.png",
				"resources/img/helicopter.png",
				"resources/img/player.png"];
		_soundsToLoad = ["resources/sounds/heli_start.wav",
				"resources/sounds/heli.wav"];
		load();

		// register events
		document.onKeyDown.listen(handleInput);
		document.onKeyUp.listen(handleInput);
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
			window.requestAnimationFrame(mainLoop);
		}
	}

	void mainLoop(double delta)
	{
		if(!player.gameOver) {
			lvl.draw(c);
			player.update(delta);
			player.draw(c);
			_ui.draw(c);
			c.flip();

			window.requestAnimationFrame(mainLoop);
		} else {
			showGameOver();
		}
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
			..fillText(player.why, 100,150);
		c.flip();
	}

	void handleInput(KeyboardEvent event)
	{
		int key = event.keyCode;

		switch(key) {
			case KeyCode.Q:
				player.rotateLeft();
				break;
			case KeyCode.E:
				player.rotateRight();
				break;
			case KeyCode.W:
				player.moveForward();
				break;
			case KeyCode.S:
				player.moveBackward();
				break;
			case KeyCode.SPACE:
				player.startLand();
				break;
		}
	}
}
