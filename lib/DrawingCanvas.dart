part of Game;

// used to draw on an to flip the canvases
class DrawingCanvas
{
	CanvasElement canvas;
	CanvasRenderingContext2D _ctx;

	DrawingCanvas()
	{
		canvas = new Element.tag("canvas");
		canvas.width = 1024;
		canvas.height = 640;
		_ctx = canvas.context2D;
	}

	void flip()
	{
		ScreenCanvas.setCanvas(canvas);	
	}

	void draw(ImageElement img, int x, int y)
	{
		_ctx.drawImage(img, x, y);
	}

	void drawScaled(CanvasElement img, int x, int y, int dwidth, int dheight, Angle angle)
	{
		_ctx.translate(x, y);
		_ctx.translate(img.width/2, img.height/2);
		_ctx.rotate(angle.getRadian());
		_ctx.drawImageScaled(img, -img.width/2, -img.height/2, dwidth, dheight);
		_ctx.rotate(-angle.getRadian());
		_ctx.translate(-img.width/2, -img.height/2);
		_ctx.translate(-x,-y);
	}

	void clear()
	{
		canvas.width = canvas.width;
	}
}
