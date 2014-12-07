part of Game;

class BurnableZone
{
	List<Fire> _fires;
	int _extRadius = 32 * 2;
	int _maxFires = 0;
	Rect _position;
	static int firesExtinguished = 0;
	double lastUpdated;
	int firesSpawned = 0;

	BurnableZone(Rect position)
	{
		_position = position;
		_maxFires = (_position.width/32).round() * (_position.height/32).round();
		_fires = new List<Fire>();
	}

	void update(double delta)
	{
		if(lastUpdated == null) {
			lastUpdated = delta;
		} else {
			if(delta - lastUpdated > 200) {
				lastUpdated = delta;
				if(firesSpawned <= 3) {
					if(new math.Random().nextInt(10)<=1) {
						Vector newFirePos = new Vector(_position.x + new math.Random().nextInt(_position.width),
							_position.y + new math.Random().nextInt(_position.height));
						newFirePos.x = (newFirePos.x / 32).round()*32;
						newFirePos.y = (newFirePos.y / 32).round()*32;
						spread(newFirePos);
						firesSpawned++;
					}
				}
				for(int i = 0; i < _fires.length; i++) {
					_fires[i].update(delta);
				}
			}
		}
	}

	void draw(DrawingCanvas c)
	{
		for(Fire fire in _fires) {
			fire.draw(c);
		}
	}

	int getBurningFires()
	{
		return _fires.length;
	}

	void spread(Vector spreadPosition)
	{
		if(_fires.length < _maxFires) {
			if(spreadPosition.x < (_position.x+_position.width) && spreadPosition.x > _position.x &&
					spreadPosition.y < (_position.y+_position.height) && spreadPosition.y > _position.y) {
				Fire newFire = new Fire(spreadPosition, spread);
				bool placeFire = true;
				for(Fire fire in _fires) {
					if(fire.compareTo(newFire)==1) {
						placeFire = false;
					}
				}
				if(placeFire) {
					_fires.add(new Fire(spreadPosition, spread));
				}
			}
		}
	}

	int extinguishFire(Vector heliPos)
	{
		for(int i = _fires.length-1; i >= 0; i--) {
			Vector firePos = _fires[i].getPosition();
			if((firePos.x+16 - heliPos.x).abs() < _extRadius) {
				if((firePos.y+16 - heliPos.y).abs() < _extRadius) {
					firesExtinguished++;
					_fires.removeAt(i);
				}
			}
		}
	}
}
