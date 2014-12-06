part of Game;

class ResManager
{
	static Map<String, ImageElement> _images;
	static Map<String, AudioBuffer> _sounds;
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

	static void loadSound(String url, AudioContext audioCtx, [Function callback])
	{
		if(_sounds == null) {
			_sounds = new Map<String, AudioBuffer>();
		}

		var request = new HttpRequest();
		request.open("GET", url, async: true);
		request.responseType = "arraybuffer";
		request.onLoad.listen((e) {
			audioCtx.decodeAudioData(request.response).then((AudioBuffer buffer){
				print("Loaded Sound: " + url);
				_sounds[url] = buffer;
			});
		});

		request.send();

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

	static AudioBuffer getSound(String url)
	{
		if(_sounds==null) {
			_sounds = new Map<String, AudioBuffer>();
		}
		return _sounds[url];
	}
}
