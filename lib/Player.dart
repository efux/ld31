part of Game;

class Player
{
	double _altitude = 0.0;
	double _maxAltitude = 50.0;
	int _actSpeed = 0;
	int _maxSpeed = 15;
	int _x = 320;
	int _y = 505;
	double rotation_actSpeed = 5.0;
	bool isLanding = false;
	bool isStarting = false;
	bool gameOver = false;
	String why = "";
	double _waterFilling = 0.0;
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
		_playerSprite.draw(c, _x, _y, angle);
	}

	void update(double delta)
	{
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
					why = "You ran out of fuel\r\n";
				}
				why += "You crashed!";
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

	bool isOverWater() {
		if(_x < 200 && _y < 200) {
			return true;
		}
		return false;
	}

	bool isOverBuilding() {
		if(_x < 360 && _x > 290 && _y > 440) {
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
		Vector v = new Vector(_actSpeed, 0);
		v.rotate(angle);
		_x += v.x;
		_y += v.y;
	}

	void moveForward() 
	{
		if(_actSpeed.abs() <= _maxSpeed) {
			_actSpeed++;
		}
	}

	void moveBackward()
	{
		if(_actSpeed.abs() <= _maxSpeed) {
			_actSpeed--;
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
			_fuel -= 0.01;
		}
	}

	void _fillWater()
	{
		if(_waterFilling <= 100.00) {
			_waterFilling = _waterFilling + 1;
		}
	}

	void _fillFuel()
	{
		if(_fuel <= 100.00) {
			_fuel =  _fuel + 1;
		}
	}
}
