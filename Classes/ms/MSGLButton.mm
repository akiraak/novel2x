#import "MS.h"

#define PUSH_WAIT_TIME	(160)

namespace ms {
	//--------------------------------
	GLButton::GLButton():
	state((STATE)0),
	visibleType((VISIBLE_TYPE)0),
	viewTouch(NULL),
	reactionRect(CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)),
	isDrawFlag(FALSE)
	{
		memset(textureState, 0, sizeof(textureState));
		memset(uv, 0, sizeof(uv));
		memset(size, 0, sizeof(size));
	}
	//--------------------------------
	GLButton::~GLButton(){
	}
	//--------------------------------
	void GLButton::init(){
		ms::GLSprite::init();
	}
	//--------------------------------
	void GLButton::clean(){
		visibleType = VISIBLE_TYPE_IDLE;
		setTexture(textureState[visibleType]);
		setUV(uv[visibleType]);
		setSize(ms::Vector2fMake(size[visibleType].x, size[visibleType].y));
		state = STATE_IDLE;
		isDrawFlag = TRUE;
	}
	//--------------------------------
	void GLButton::draw(){
		if(getVisible()){
			if(!getTexture()){
				ASSERT(textureState[visibleType]);
				setTexture(textureState[visibleType]);
				setUV(uv[visibleType]);
				setSize(ms::Vector2fMake(size[visibleType].x, size[visibleType].y));
			}
		}
		GLSprite::draw();
	}
	//--------------------------------
	BOOL GLButton::update(ms::Uint32 elapsedTime){
		BOOL isDraw = isDrawFlag;
		isDrawFlag = FALSE;
		switch(state){
			case STATE_IDLE:
				break;
			case STATE_PUSH_WAIT_INIT:
				timer = 0;
				state = STATE_PUSH_WAIT;
				//break;
			case STATE_PUSH_WAIT:
				timer += elapsedTime;
				if(timer >= PUSH_WAIT_TIME){
					sendChildNotifyMessage(NOTIFY_PUSH, NULL);
					state = STATE_PUSH;
				}
				break;
			case STATE_PUSH:
				break;
		}
		return isDraw;
	}
	//--------------------------------
	void GLButton::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
		if(visibleType == VISIBLE_TYPE_IDLE && getVisible()){
			if( touchPos[0].x >= reactionRect.origin.x && touchPos[0].x < (reactionRect.origin.x + reactionRect.size.width) &&
			   touchPos[0].y >= reactionRect.origin.y && touchPos[0].y < (reactionRect.origin.y + reactionRect.size.height) )
			{
				visibleType = VISIBLE_TYPE_PUSH;
				state = STATE_PUSH_WAIT_INIT;
				setTexture(textureState[visibleType]);
				setUV(uv[visibleType]);
				setSize(ms::Vector2fMake(size[visibleType].x, size[visibleType].y));
				isDrawFlag = TRUE;
			}
		}
	}
	//--------------------------------
	void GLButton::alignParamToTexture(float scale){
		ms::Vector2f lastImageSize = ms::Vector2fMake(0.0f, 0.0f);
		for(int i = 0; i < VISIBLE_TYPE_COUNT; i++){
			GLTexture* texture = textureState[i];
			if(texture){
				ms::Vector2f imageSize = texture->getImageSize();
				ms::Vector2f textureSize = texture->getTextureSize();
				setUVWithState((VISIBLE_TYPE)i, ms::UVMake(0.0f, 
														   0.0f, 
														   imageSize.x/textureSize.x, 
														   imageSize.y/textureSize.y));
				setSizeWithState((VISIBLE_TYPE)i, ms::Vector2fMake(imageSize.x*scale,
																   imageSize.y*scale));
				lastImageSize = imageSize;
			}
		}
		ms::Vector3f pos = getPos();
		CGRect rect = CGRectMake(pos.x, pos.y, lastImageSize.x*scale, lastImageSize.y*scale);
		setReactionRect(rect);
	}
	//--------------------------------
	void GLButton::setEnable(BOOL enable){
		if(enable){
			visibleType = VISIBLE_TYPE_IDLE;
		}else{
			visibleType = VISIBLE_TYPE_DISABLE;
		}
		setTexture(textureState[visibleType]);
		setUV(uv[visibleType]);
		setSize(ms::Vector2fMake(size[visibleType].x, size[visibleType].y));
	}
	//--------------------------------
	void GLButton::setReactionRect(const CGRect& rect){
		reactionRect = rect;
	}
	//--------------------------------
	void GLButton::setReactionPos(const ms::Vector2f& _pos){
		reactionRect.origin.x = _pos.x;
		reactionRect.origin.y = _pos.y;
	}
	//--------------------------------
	BOOL GLButton::getPush(){
		return (visibleType == VISIBLE_TYPE_PUSH);
	}
	//--------------------------------
	void GLButton::setTextureWithState(ms::GLButton::VISIBLE_TYPE _visibleType, GLTexture* _texture){
		ASSERT(_visibleType >= 0 && _visibleType < VISIBLE_TYPE_COUNT);
		textureState[_visibleType] = _texture;
	}
	//--------------------------------
	void GLButton::setUVWithState(ms::GLButton::VISIBLE_TYPE _visibleType, const UV& _uv){
		ASSERT(_visibleType >= 0 && _visibleType < VISIBLE_TYPE_COUNT);
		uv[_visibleType] = _uv;
	}
	//--------------------------------
	void GLButton::setSizeWithState(ms::GLButton::VISIBLE_TYPE _visibleType, const ms::Vector2f& _size){
		ASSERT(_visibleType >= 0 && _visibleType < VISIBLE_TYPE_COUNT);
		size[_visibleType] = _size;
	}
	//--------------------------------
	ms::Vector2f GLButton::getSizeWithState(ms::GLButton::VISIBLE_TYPE _visibleType){
		ASSERT(_visibleType >= 0 && _visibleType < VISIBLE_TYPE_COUNT);
		return size[_visibleType];
	}
}
