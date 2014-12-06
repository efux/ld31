part of Game;

class Player
{
	double _altitude = 0.0;
	double _maxAltitude = 100.0;
	int _x = 100;
	int _y = 100;
	Angle angle;
	Sprite _playerSprite;

	Player()
	{
		angle = new Angle();
		angle.set(45.0);
		_playerSprite = new Sprite(ResManager.get("resources/img/player.png"));
	}

	void draw(DrawingCanvas c)
	{
		print("Drawing Player!");
		ImageElement e = ResManager.get("resources/img/helicopter.png");
		c.drawScaled(e, _x, _y, (e.width + (_altitude/10)).round(), (e.height + (_altitude/10)).round(), angle);
	}

	void turn(double angle)
	{
		angle.set((this.angle + angle) % 360);
	}
}
