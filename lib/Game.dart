library Game;

import "dart:html";
import "dart:math" as math;

part 'ResManager.dart';
part 'Level.dart';
part 'DrawingCanvas.dart';
part 'ScreenCanvas.dart';
part 'Sprite.dart';
part 'Player.dart';
part 'Angle.dart';

class Game
{
	final int _screenWidth = 1024;
	final int _screenHeight = 640;
	int _loadedImageCounter = 0;
	List<String> _imagesToLoad;
	bool gameFinished = false;
	DrawingCanvas c;
	Level lvl;
	Player player;

	Game()
	{
		c = new DrawingCanvas();
		lvl = new Level();
		player = new Player();

		_imagesToLoad = ["resources/img/map.png",
				"resources/img/helicopter.png",
				"resources/img/player.png"];
		load();
	}
	
	void load()
	{
		for(String url in _imagesToLoad) {
			ResManager.load(url, loadedImageCallback);
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
		if(!gameFinished) {
			c.clear();
			lvl.draw(c);
			player.draw(c);
			c.draw(ResManager.get("resources/img/player.png"),100,100);
			c.flip();

			window.requestAnimationFrame(mainLoop);
		}
	}
	
}
