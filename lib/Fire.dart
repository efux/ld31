part of Game;

class Fire implements Comparable
{
	Function _callback;
	Sprite _sprite;
	Vector _position;
	int _spawned = 0;
	double lastUpdated;

	Fire(Vector position, Function callback)
	{
		_sprite = new Sprite(ResManager.get("resources/img/fire.png"));
		_sprite.setTileSize(32);
		_sprite.runAnimation(true);
		_position = position;
		_callback = callback;
	}

	Vector getPosition()
	{
		return _position;
	}

	void update(double delta)
	{
		if(lastUpdated==null) {
			lastUpdated = delta;
		} else {
			if(delta-lastUpdated > 100) {
				lastUpdated = delta;
				_sprite.step();
				if(_spawned < 4) {
					if(new math.Random().nextInt(50)<=(BurnableZone.firesExtinguished/20+1)) {
						Vector newFirePos = new Vector(0,0);
						_spawned++;
						switch(new math.Random().nextInt(4)) {
							case 0:
								newFirePos.x += 32;
								break;
							case 1:
								newFirePos.x -= 32;
								break;
							case 2:
								newFirePos.y += 32;
								break;
							case 3:
								newFirePos.y -= 32;
								break;
						}
						_callback(_position + newFirePos);
					}
				}
			}
		}
	}

	void draw(DrawingCanvas c)
	{
		_sprite.draw(c, _position.x, _position.y, new Angle());
	}

	int compareTo(Fire other)
	{
		if(other._position.x == _position.x && other._position.y == _position.y) {
			return 1;
		}
		return 0;
	}
}
