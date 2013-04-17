#import "MS.h"
#import "SceneDebugString.h"

namespace ms {
	//--------------------------------
	GLProgressBar::GLProgressBar():
	bgSprite(NULL),
	bodyLeftSprite(NULL),
	bodyRightSprite(NULL),
	bodyPos(Vector2fMake(0.0f, 0.0f)),
	bodyCenterSize(Vector2fMake(0.0f, 0.0f)),
	rate(0.0f),
	uvAnimSpeed(0.0f),
	uvAnimRate(0.0f),
	imageScale(0.0f),
	drawState(DRAW_STATE_NONE)
	{
		bzero(bodyCenterSprite, sizeof(bodyCenterSprite));
	}
	//--------------------------------
	GLProgressBar::~GLProgressBar(){
		MS_SAFE_DELETE(bgSprite);
		MS_SAFE_DELETE(bodyLeftSprite);
		MS_SAFE_DELETE(bodyRightSprite);
		for(int i = 0; i < ARRAYSIZE(bodyCenterSprite); i++){
			MS_SAFE_DELETE(bodyCenterSprite[i]);
		}
	}
	//--------------------------------
	void GLProgressBar::init(ms::GLTexture* _bgTexture,
							 ms::GLTexture* _bodyLeftTexture,
							 ms::GLTexture* _bodyRightTexture,
							 ms::GLTexture* _bodyCenterTexture,
							 ms::Vector2f& _bodyPos,
							 ms::Vector2f& _bodyCenterSize,
							 float _imageScale,
							 float _uvAnimSpeed)
	{
		GLRender::init();
		bodyPos = _bodyPos;
		bodyCenterSize = _bodyCenterSize;
		imageScale = _imageScale;
		uvAnimSpeed = _uvAnimSpeed;
		{
			ms::GLTexture* texture = _bgTexture;
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			object->setTexture(texture);
			object->alignParamToTexture(_imageScale);
			object->setVisible(TRUE);
			ASSERT(!bgSprite);
			bgSprite = object;
		}
		{
			ms::GLTexture* texture = _bodyLeftTexture;
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			object->setTexture(texture);
			object->alignParamToTexture(_imageScale);
			object->setVisible(TRUE);
			ASSERT(!bodyLeftSprite);
			bodyLeftSprite = object;
		}
		{
			ms::GLTexture* texture = _bodyRightTexture;
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			object->setTexture(texture);
			object->alignParamToTexture(_imageScale);
			object->setVisible(TRUE);
			ASSERT(!bodyRightSprite);
			bodyRightSprite = object;
		}
		for(int i = 0; i < ARRAYSIZE(bodyCenterSprite); i++){
			ms::GLTexture* texture = _bodyCenterTexture;
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			object->setTexture(texture);
			//object->alignParamToTexture(_imageScale);
			object->setVisible(TRUE);
			//ms::Vector2f imageSize = texture->getImageSize();
			ASSERT(!bodyCenterSprite[i]);
			bodyCenterSprite[i] = object;
		}
		setRate(rate);
	}
	//--------------------------------
	BOOL GLProgressBar::update(ms::Uint32 elapsedTime){
		BOOL isDraw = getVisible();
		uvAnimRate += uvAnimSpeed * (float)elapsedTime / (float)1000.0f;
		if(uvAnimRate >= 1.0f){
			uvAnimRate -= (int)uvAnimRate;
		}
		updateBar();
		return isDraw;
	}
	//--------------------------------
	void GLProgressBar::draw(){
		bgSprite->draw();

		if(drawState == DRAW_STATE_ONE){
			bodyLeftSprite->draw();
			bodyRightSprite->draw();
			bodyCenterSprite[0]->draw();
		}else if(drawState == DRAW_STATE_ALL){
			bodyLeftSprite->draw();
			bodyRightSprite->draw();
			for(int i = 0; i < ARRAYSIZE(bodyCenterSprite); i++){
				bodyCenterSprite[i]->draw();
			}
		}
	}
	//--------------------------------
	void GLProgressBar::setVisible(BOOL _visible){
		GLRender::setVisible(_visible);
		bgSprite->setVisible(_visible);
		bodyLeftSprite->setVisible(_visible);
		bodyRightSprite->setVisible(_visible);
		for(int i = 0; i < ARRAYSIZE(bodyCenterSprite); i++){
			bodyCenterSprite[i]->setVisible(_visible);
		}
	}
	//--------------------------------
	void GLProgressBar::setPos(const ms::Vector3f& _pos){
		//ms::Vector3f pos = ms::Vector3fMake((int)_pos.x, (int)_pos.y, (int)_pos.z);
		GLRender::setPos(_pos);
		bgSprite->setPos(_pos);
		updateBar();
	}
	//--------------------------------
	void GLProgressBar::setRate(float _rate){
		CLAMP(_rate, 0.0f, 1.0f);
		rate = _rate;
		updateBar();
	}
	//--------------------------------
	void GLProgressBar::updateBar(){
		if(rate > 0.0f){
			Vector3f pos = getPos();
			Vector3f barPos = Vector3fMake(pos.x+bodyPos.x, pos.y+bodyPos.y, pos.z);
			{
				bodyLeftSprite->setPos(barPos);
				barPos.x += bodyLeftSprite->getSize().x;
			}
			{
				Vector2f imageSize = bodyCenterSprite[0]->getTexture()->getImageSize();
				Vector2f textureSize = bodyCenterSprite[0]->getTexture()->getTextureSize();
				Vector2f drawBodyCenterSize = Vector2fMake((int)(bodyCenterSize.x*rate), (int)bodyCenterSize.y);
				Vector2f bodyCenterLeftSize = Vector2fMake(0.0f, 0.0f);
/*				{
					char str[256];
					sprintf(str, "%f", uvAnimRate);
					SceneDebugString::setString(str);
				}
*/
				// Sprite on the left side.
				if(drawBodyCenterSize.x > 0.0f){
					Vector2f size = Vector2fMake(0.0f, bodyCenterSize.y);
					float imageRestSizeW = (imageSize.x*imageScale)*uvAnimRate;
					if(imageRestSizeW > drawBodyCenterSize.x){
						size.x = (int)drawBodyCenterSize.x;
					}else{
						size.x = (int)imageRestSizeW;
					}
					UV uv = UVMake(imageSize.x*(1.0f-uvAnimRate)/textureSize.x, 0.0f, 0.0f, imageSize.y/textureSize.y);
					uv.u1 = uv.u0 + (size.x/imageScale/textureSize.x);
					if(uv.u1 > imageSize.x*textureSize.x){
						uv.u1 = imageSize.x*textureSize.x;
					}
					Vector3f pos = Vector3fMake(0.0f, 0.0f, 0.0f);
					bodyCenterSprite[0]->setPos(Vector3fMake(barPos.x+pos.x, barPos.y+pos.y, pos.z));
					bodyCenterSprite[0]->setSize(size);
					bodyCenterSprite[0]->setUV(uv);
					
					bodyCenterLeftSize = size;
				}
				
				// Sprite on the right side.
				if(bodyCenterLeftSize.x < drawBodyCenterSize.x){
					Vector3f pos = Vector3fMake(bodyCenterLeftSize.x, 0.0f, 0.0f);
					Vector2f size = Vector2fMake((int)(drawBodyCenterSize.x-bodyCenterLeftSize.x), bodyCenterSize.y);
					UV uv = UVMake(0.0f, 0.0f, size.x/imageScale/textureSize.x, imageSize.y/textureSize.y);
					bodyCenterSprite[1]->setPos(Vector3fMake(barPos.x+pos.x, barPos.y+pos.y, pos.z));
					bodyCenterSprite[1]->setSize(size);
					bodyCenterSprite[1]->setUV(uv);

					drawState = DRAW_STATE_ALL;
				}else{
					drawState = DRAW_STATE_ONE;
				}
				
				if(drawBodyCenterSize.x == 0.0f){
					drawState = DRAW_STATE_NONE;
				}

				barPos.x += drawBodyCenterSize.x;
			}

			bodyRightSprite->setPos(barPos);
		}else{
			drawState = DRAW_STATE_NONE;
		}
	}
}

