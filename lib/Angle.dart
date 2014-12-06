part of Game;

class Angle
{
	double angle = 0.0;
	
	void set(double angle)
	{
		this.angle = angle;
	}

	double getRadian()
	{
		return (angle * math.PI) / 180.0;
	}
}
