#import "SceneFade.h"
#import "Scene.h"

//--------------------------------
SceneFade::SceneFade():
state((STATE)0),
texture((TEXTURE)0),
sprite(NULL),
timer(0),
fadeTime(0),
alphaStart(0.0f),
alphaEnd(0.0f),
alpha(0.0f),
drawFlag(FALSE)
{
}
//--------------------------------
SceneFade::~SceneFade(){
	MS_SAFE_DELETE(sprite);
}
//--------------------------------
void SceneFade::init(){
	{
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setPos(ms::Vector3fMake(0.0f, 0.0f, 0.0f));
		object->setVisible(FALSE);
		ASSERT(!sprite);
		sprite = object;
	}
}
//--------------------------------
BOOL SceneFade::update(ms::Uint32 elapsedTime){
	BOOL isDraw = drawFlag;
	switch(state){
		case STATE_IDLE:
			break;
		case STATE_FADE_INIT:
			timer = 0;
			state = STATE_FADE;
			//break;
		case STATE_FADE:
		{
			timer += elapsedTime;
			if(timer >= fadeTime){
				timer = fadeTime;
				state = STATE_IDLE;
			}
			if(fadeTime != 0.0f){
				alpha = alphaStart+((alphaEnd-alphaStart) * (float)timer / fadeTime);
			}else{
				alpha = alphaEnd;
			}
			switch(texture){
				case TEXTURE_NONE:
					sprite->setColor(ms::Color4fMake(0.0f, 0.0f, 0.0f, alpha));
					break;
				default:
					ASSERT(0);
			}
			if(alpha > 0.0f){
				sprite->setVisible(TRUE);
			}else{
				sprite->setVisible(FALSE);
			}
			isDraw = TRUE;
			break;
		}
	}
	drawFlag = FALSE;
	return isDraw;
}
//--------------------------------
void SceneFade::draw(){
	sprite->draw();
}
//--------------------------------
void SceneFade::start(ms::Uint32 _fadeTime, float _alphaStart, float _alphaEnd, TEXTURE _texture){
	ms::Vector2n screenSize = ms::Vector2nMake(ms::GLScene::SCREEN_SIZE_W, ms::GLScene::SCREEN_SIZE_H);

	fadeTime = _fadeTime;
	alphaStart = _alphaStart;
	alphaEnd = _alphaEnd;
	alpha = _alphaStart;
	texture = _texture;
	drawFlag = TRUE;
	
	switch(_texture){
		case TEXTURE_NONE:
			sprite->setTexture(NULL);
			sprite->setSize(ms::Vector2fMake(screenSize.x, screenSize.y));
			sprite->setColor(ms::Color4fMake(0.0f, 0.0f, 0.0f, alpha));
			break;
		default:
			ASSERT(0);
	}

	state = STATE_FADE_INIT;
}
