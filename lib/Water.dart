part of Game;

class Water
{
	Sprite _sprite;
	double _lastUpdate;

	Water()
	{
		_sprite = new Sprite(ResManager.get("resources/img/water.png"));
		_sprite.setTileSize(460);
		_sprite.runAnimation(true);
	}

	void update(double delta)
	{
		if(_lastUpdate == null) {
			_lastUpdate = delta;
		} else {
			if(delta-_lastUpdate > 1000) {
				_lastUpdate = delta;
				_sprite.step();
			}
		}
	}

	void draw(DrawingCanvas c)
	{
		_sprite.draw(c, 0, 0, new Angle());
	}
}
