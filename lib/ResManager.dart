part of Game;

class ResManager
{
	static Map<String, ImageElement> _images;
	static int _loadedImages = 0;

	static void load(String url, [Function callback])
	{
		print("Loading image: " + url);
		if(_images == null) {
			_images = new Map<String, ImageElement>();
		}

		ImageElement image = new Element.tag("img");
		image.src = url;
		_images[url] = image;

		if(callback != null) {
			image.onLoad.listen((e) {
				callback();
			});
		}
	}

	static int size()
	{
		return _images.length;
	}

	static ImageElement get(String url)
	{
		if(_images==null) {
			_images = new Map<String, ImageElement>();
		}
		if(!_images.containsKey(url)) {
			load(url);	
		}
		return _images[url];
	}
}
