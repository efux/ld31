part of Game;

class Level
{
	String _name = "OnlyLevelYouGet";
	ImageElement _c;

	Level()
	{
		_c = ResManager.get("resources/img/map.png");
	}

	draw(DrawingCanvas drawingCanvas)
	{
		print("Drawing level!");
		drawingCanvas.draw(_c, 0,0);
	}
}
