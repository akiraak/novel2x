#import "MS.h"

namespace ms {
	//--------------------------------
	GLKeyedSprite::GLKeyedSprite():
	keyCount(0),
	spriteMax(0),
	renderKeysCount(0),
	keyInfo(NULL),
	renderKeys(NULL),
	sprite(NULL),
	texture(NULL),
	gapPos(ms::Vector2fMake(0.0f, 0.0f)),
	posType((POS_TYPE)0),
	imageScale(1.0f)
	{
	}
	//--------------------------------
	GLKeyedSprite::~GLKeyedSprite(){
		MS_SAFE_FREE(keyInfo);
		MS_SAFE_FREE(renderKeys);
		for(int i = 0; i < spriteMax; i++){
			MS_SAFE_DELETE(sprite[i]);
		}
		MS_SAFE_FREE(sprite);
	}
	//--------------------------------
	void GLKeyedSprite::init(ms::Uint32 _keyCount, ms::Uint32 _spriteMax){
		ms::GLRender::init();
		keyCount = _keyCount;
		spriteMax = _spriteMax;
		
		ASSERT(!keyInfo);
		keyInfo = (KEY_INFO*)malloc(sizeof(KEY_INFO)*_keyCount);
		ASSERT(keyInfo);
		
		ASSERT(!renderKeys);
		renderKeys = (int*)malloc(sizeof(int)*_spriteMax);
		ASSERT(renderKeys);
		memset(renderKeys, 0, sizeof(int)*_spriteMax);
		
		ASSERT(!sprite);
		sprite = (ms::GLSprite**)malloc(sizeof(ms::GLSprite*)*_spriteMax);
		ASSERT(sprite);
		for(int i = 0; i < _spriteMax; i++){
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			sprite[i] = object;
		}
	}
	//--------------------------------
	void GLKeyedSprite::setPos(const ms::Vector3f& _pos){
		GLRender::setPos(_pos);
		Vector3f drawPos = _pos;
		ASSERT(texture);
		ms::Vector2f textureSize = texture->getTextureSize();
		if(posType == POS_TYPE_LT){
			for(int i = 0; i < renderKeysCount; i++){
				const KEY_INFO* info = getKeyInfo(renderKeys[i]);
				if(info){
					ms::GLSprite*	workSprite = sprite[i];
					ms::Vector2f	size = ms::Vector2fMake(textureSize.x*(info->uv.u1-info->uv.u0)*imageScale, textureSize.y*(info->uv.v1-info->uv.v0)*imageScale);
					workSprite->setUV(info->uv);
					workSprite->setSize(size);
					workSprite->setPos(drawPos);
					drawPos.x += size.x + gapPos.x;
				}else{
					ms::GLSprite*	workSprite = sprite[i];
					ms::Vector2f	size = ms::Vector2fMake(0.0f, 0.0f);
					workSprite->setUV(ms::UVMake(0.0f, 0.0f, 0.0f, 0.0f));
					workSprite->setSize(size);
					workSprite->setPos(drawPos);
				}
			}
		}else if(posType == POS_TYPE_RT){
			for(int i = renderKeysCount-1; i >= 0; i--){
				const KEY_INFO* info = getKeyInfo(renderKeys[i]);
				if(info){
					ms::GLSprite*	workSprite = sprite[i];
					ms::Vector2f	size = ms::Vector2fMake(textureSize.x*(info->uv.u1-info->uv.u0)*imageScale, textureSize.y*(info->uv.v1-info->uv.v0)*imageScale);
					workSprite->setUV(info->uv);
					workSprite->setSize(size);
					drawPos.x -= size.x + gapPos.x;
					workSprite->setPos(drawPos);
				}else{
					ms::GLSprite*	workSprite = sprite[i];
					ms::Vector2f	size = ms::Vector2fMake(0.0f, 0.0f);
					workSprite->setUV(ms::UVMake(0.0f, 0.0f, 0.0f, 0.0f));
					workSprite->setSize(size);
					workSprite->setPos(drawPos);
				}
			}
		}
	}
	//--------------------------------
	void GLKeyedSprite::setPosType(POS_TYPE _posType){
		ASSERT(_posType >= (POS_TYPE)0 && _posType < POS_TYPE_COUNT);
		posType = _posType;
	}
	//--------------------------------
	void GLKeyedSprite::setTexture(ms::GLTexture* _texture, float _imageScale){
		texture = _texture;
		imageScale = _imageScale;
		for(int i = 0; i < spriteMax; i++){
			sprite[i]->setTexture(_texture);
		}
	}
	//--------------------------------
	void GLKeyedSprite::setColor(UIColor* color){
		for(int i = 0; i < spriteMax; i++){
			sprite[i]->setColor(color);
		}
	}
	//--------------------------------
	void GLKeyedSprite::setColor(const Color4f& color){
		for(int i = 0; i < spriteMax; i++){
			sprite[i]->setColor(color);
		}
	}
	//--------------------------------
	void GLKeyedSprite::setKeyInfo(ms::Uint32 _keyIndex, const KEY_INFO& _keyInfo){
		ASSERT(_keyIndex < keyCount);
		keyInfo[_keyIndex] = _keyInfo;
	}
	//--------------------------------
	void GLKeyedSprite::setRenderKey(const int* keys, ms::Uint32 keysCount){
		ASSERT(keysCount <= spriteMax);
		renderKeysCount = keysCount;
		memset(renderKeys, 0, sizeof(int)*spriteMax);
		memcpy(renderKeys, keys, sizeof(int)*keysCount);
		ms::Vector3f _pos = getPos();
		setPos(_pos);
	}
	//--------------------------------
	void GLKeyedSprite::setRenderKeyWithCString(const char* string){
		int len = strlen(string);
		int keys[len];
		for(int i = 0; i < len; i++){
			keys[i] = string[i];
		}
		setRenderKey(keys, len);
	}
	//--------------------------------
	void GLKeyedSprite::draw(){
		if(getVisible()){
			for(int i = 0; i < renderKeysCount; i++){
				sprite[i]->draw();
			}
		}
	}
	//--------------------------------
	const GLKeyedSprite::KEY_INFO* GLKeyedSprite::getKeyInfo(int key){
		KEY_INFO* info = NULL;
		for(int i = 0; i < keyCount; i++){
			if(keyInfo[i].key == key){
				info = &keyInfo[i];
				break;
			}			
		}
		return info;
	}	
}

