part of Game;

class UI
{
	Player _player;
	Rect _position;
	CanvasElement _canvas;
	CanvasRenderingContext2D _ctx;
	
	UI(Player player, Rect position)
	{
		_player = player;
		_position = position;

		_canvas = new CanvasElement(width: position.width, height: position.height);
		_ctx = _canvas.context2D;
	}	

	void draw(DrawingCanvas c)
	{
		Rect waterPos = new Rect(0,0,0,0);
		waterPos
			..x = 0
			..y = 16
			..width = (_position.width/2).round()
			..height = _position.height - 16;
		waterPos.y = 17 + waterPos.height - ((_player.getWaterFilling() * waterPos.height) / 100).round();

		Rect fuelPos = new Rect(0,0,0,0);
		fuelPos
			..x = (_position.width/2).round()
			..y = 16
			..width = waterPos.width
			..height = _position.height - 16;
		fuelPos.y = 17 + fuelPos.height - ((_player.getFuel() * fuelPos.height) / 100).round();

		_ctx
			..fillStyle = "#000"
			..fillRect(0,0,_position.width, _position.height)
			..fillStyle = "#0FF"
			..fillText("W", waterPos.x+1, 10)
			..fillRect(waterPos.x, waterPos.y, waterPos.width, waterPos.height)
			..fillStyle = "#FF0"
			..fillText("F", fuelPos.x+1, 10)
			..fillRect(fuelPos.x, fuelPos.y, fuelPos.width, fuelPos.height);

		c.canvas.context2D.drawImage(_canvas, _position.x, _position.y);
	}
}
