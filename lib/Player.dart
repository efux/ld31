part of Game;

class Player
{
	double _altitude = 0.0;
	double _maxAltitude = 50.0;
	int _actSpeed = 0;
	int _maxSpeed = 10;
	double _x = 320.0;
	double _y = 505.0;
	double rotation_actSpeed = 5.0;
	bool isLanding = false;
	bool isStarting = false;
	bool gameOver = false;
	bool _looseWater = false;
	String why = "";
	double _waterFilling = 0.0;
	double lastUpdated;
	double _fuel = 0.0;
	AudioBufferSourceNode _source;
	AudioContext _audioCtx;
	Angle angle; 
	Sprite _playerSprite; 
	
	Player(AudioContext audioCtx)
	{
		_audioCtx = audioCtx;
		angle = new Angle();
		angle.set(39.0);
		_playerSprite = new Sprite(ResManager.get("resources/img/player.png"));
	}

	double getWaterFilling()
	{
		return _waterFilling;
	}

	double getFuel()
	{
		return _fuel;
	}

	void draw(DrawingCanvas c)
	{
		double zoom = -1 * (_maxAltitude - _altitude);
		_playerSprite.setZoom(zoom);
		_playerSprite.draw(c, _x.round(), _y.round(), angle);
	}

	Vector getHelicopterPos()
	{
		Vector heliPos = new Vector(110,-84);
		heliPos = heliPos - (new Vector(80, 80));
		heliPos.rotate(angle);
		heliPos = heliPos + (new Vector(80, 80));
		heliPos = heliPos + (new Vector(_x.round(),_y.round()));
		return heliPos;
	}

	void looseWater()
	{
		_looseWater = true;
	}

	void update(double delta)
	{
		if(lastUpdated == null) {
			lastUpdated = delta;
		} else {
			if(delta - lastUpdated > 20) {
				checkFuel();
				lastUpdated = delta;
				if(isStarting) {
					rise();
				}
				if(isLanding) {
					if(_source.buffer != ResManager.getSound("resources/sounds/heli_start.wav")) {
						_source.buffer = ResManager.getSound("resources/sounds/heli_start.wav");
					}
					sink();
				}
				if(isOverWater()) {
					_fillWater();
				}
				if(_looseWater) {
					_waterFilling = _waterFilling - 2.0;
					if(_waterFilling <= 0.0) {
						_waterFilling = 0.0;
						_looseWater = false;
					}
				}
				_playerSprite.step();
				if(_altitude == 0.0) {
					_actSpeed = 0;
					_playerSprite.runAnimation(false);
					if(isStarting) {
						rise();
					}
					if(!isOverBuilding()) {
						gameOver = true;
						if(_fuel == 0.0) {
							why = "You ran out of fuel! You crashed!";
						} else {
							why = "You crashed!";
						}
					} else {
						_fillFuel();
					}
				} else {
					_leakFuel();
					if(_actSpeed != 0) {
						if(_source.buffer != ResManager.getSound("resources/sounds/heli.wav")) {
							_source.buffer = ResManager.getSound("resources/sounds/heli.wav");
						}
						_move(_actSpeed);
					} else {
						if(_source.buffer != ResManager.getSound("resources/sounds/heli_start.wav")) {
							_source.buffer = ResManager.getSound("resources/sounds/heli_start.wav");
						}
					}
					if(_fuel <= 0.009) {
						_source.buffer = ResManager.getSound("resources/sounds/heli_start.wav");
						isStarting = false;
						isLanding = true;
					}

					_playerSprite.runAnimation(true);
				}
			}
		}
	}

	void checkFuel()
	{
		if(_fuel < 6.0) {
			AudioBufferSourceNode fuelSound = _audioCtx.createBufferSource();
			fuelSound.buffer = ResManager.getSound("resources/sounds/fuel.wav");
			BiquadFilterNode filter = _audioCtx.createBiquadFilter();
			filter.type = "lowpass";
			fuelSound.connectNode(filter, 0, 0);
			filter.connectNode(_audioCtx.destination,0,0);
			fuelSound.start(0);
		}
	}

	bool isOverWater() {
		if(_x < 200.0 && _y < 200.0) {
			return true;
		}
		return false;
	}

	bool isOverBuilding() {
		Vector heliPos = getHelicopterPos();
		if(heliPos.x < 480 && heliPos.x > 300 && heliPos.y > 480) {
			return true;
		}
		return false;
	}

	void startLand()
	{
		if(!isLanding && !isStarting) {
			isStarting = true;
			if(_altitude == 0.0) {
				_source = _audioCtx.createBufferSource();
				_source.buffer = ResManager.getSound("resources/sounds/heli_start.wav");
				BiquadFilterNode filter = _audioCtx.createBiquadFilter();
				filter.type = "lowpass";
				_source.connectNode(filter, 0, 0);
				filter.connectNode(_audioCtx.destination,0,0);
				_source.start(0);
				_source.loop = true;
			} else {
				isLanding = true;
			}
		}
	}

	void _rotate(double angle)
	{
		if(_altitude!=0.0) {
			this.angle.set((this.angle.getAngle() + angle) % 360);
		}
	}

	void rotateLeft()
	{
		_rotate(rotation_actSpeed * -1);
	}

	void rotateRight()
	{
		_rotate(rotation_actSpeed);
	}

	void _move(int _actSpeed)
	{
		Vector2f v = new Vector2f(_actSpeed, 0.0);
		v.rotate(angle);
		_x += v.x;
		_y += v.y;
	}

	void moveForward() 
	{
		if(_actSpeed <= _maxSpeed) {
			_actSpeed = _actSpeed + 2;
		}
	}

	void moveBackward()
	{
		if(_actSpeed >= -1 * _maxSpeed) {
			_actSpeed = _actSpeed -2;
		}
	}

	void sink()
	{
		_altitude = _altitude - 5;
		if(_altitude <= 0.0) {
			_altitude = 0.0;
			isLanding = false;
			_source.stop(4);
		}
	}

	void rise()
	{
		_altitude = _altitude + 5;
		if(_altitude >= _maxAltitude) {
			_altitude = _maxAltitude;
			isStarting = false;
		}
	}

	void _leakFuel()
	{
		if(_fuel >= 0.00) {
			_fuel -= 0.02;
		}
		if(_fuel < 0.00) {
			_fuel = 0.0;
		}
	}

	void _fillWater()
	{
		if(_waterFilling < 100.00) {
			_waterFilling = _waterFilling + 1;
		}
	}

	void _fillFuel()
	{
		if(_fuel < 100.00) {
			_fuel =  _fuel + 1;
		}
	}
}
