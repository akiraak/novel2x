namespace ms {
	class GLTexture {
	public:
		GLTexture();
		virtual ~GLTexture();

		typedef enum {
			kPixelFormat_Automatic = 0,
			kPixelFormat_RGBA8888,
			kPixelFormat_A8,
		} PixelFormat;

		virtual void setDataRelease(BOOL _state){dataRelease=_state;}
		virtual void initWithFilePath(const char* fileName);
		virtual void initWithFilePath2(const char* fileName);
		virtual void initWithFilePathAsync(const char* path);
		virtual void initWithFilePathAsync(const char* fileName, const char* fileExtension);
		virtual void initWithString(NSString* string, Vector2f dimensions, UITextAlignment alignment, NSString* fontName, CGFloat fontSize);
		virtual void initWithData(const void* data, PixelFormat pixelFormat, Vector2f _textureSize, Vector2f _imageSize);
		virtual void initWithData(NSData* data);
		virtual void initWithUIImage(UIImage* uiImage);
		virtual BOOL startAsyncLoad();
		virtual void createAsyncTexture(BOOL releaseData=TRUE);
		virtual GLuint getTextureName(){return textureName;}
		virtual Vector2f getTextureSize(){return textureSize;}
		virtual Vector2f getImageSize(){return imageSize;}
		virtual void update();
		virtual BOOL isLoaded();
		virtual BOOL isCreated();
		virtual NSData* getFileData();
		virtual void* getData(){return data;}
		virtual NSString* getFilePath(){return filePath;}
/*		enum {
			kMaxTextureSize = 2048,
		};		
*/
		static void setTextureMaxSize(ms::Uint32 size){textureMaxSize = size;}
		static ms::Uint32 getTextureMaxSize(){return textureMaxSize;}
	private:
		static ms::Uint32	textureMaxSize;

		enum STATE {
			STATE_NONE = 0,
			STATE_LOAD_REQUEST_WAIT,
			STATE_LOADED,			
			STATE_CREATED,
		};
		STATE			state;
		GLuint			textureName;
		Vector2f		textureSize;
		Vector2f		imageSize;
		NSString*		filePath;
		void*			asyncReadBuffer;
		ms::Uint32		asyncReadSize;
		ms::Uint32		asyncReadedSize;
		BOOL			dataRelease;
		void*			data;

		static void asyncLoadCallBack (CFReadStreamRef stream, CFStreamEventType event, void *info);
	};
};
