#import "ViewerVSlider.h"
#import "Texture.h"

//--------------------------------
ViewerVSlider::ViewerVSlider():
topSprite(NULL),
bottomSprite(NULL),
middleSprite(NULL)
{
}
//--------------------------------
ViewerVSlider::~ViewerVSlider(){
}
//--------------------------------
void ViewerVSlider::init(){
	ms::Object::init();
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_v_slider_back_top);
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setTexture(texture);
		object->alignParamToTexture();
		ms::Vector2f imageSize = texture->getImageSize();
		object->setPos(ms::Vector3fMake(ms::GLScene::SCREEN_SIZE_W*0.5f-imageSize.x, -ms::GLScene::SCREEN_SIZE_H*0.5f, 0.0f));
		ASSERT(!topSprite);
		topSprite = object;
	}
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_v_slider_back_top);
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setTexture(texture);
		object->alignParamToTexture();

		ms::UV uvOrg = object->getUV();
		ms::UV uv = ms::UVMake(uvOrg.u0, uvOrg.v1, uvOrg.u1, uvOrg.v0);
		object->setUV(uv);
		
		ms::Vector2f imageSize = texture->getImageSize();
		object->setPos(ms::Vector3fMake(ms::GLScene::SCREEN_SIZE_W*0.5f-imageSize.x, ms::GLScene::SCREEN_SIZE_H*0.5f-imageSize.y, 0.0f));
		ASSERT(!bottomSprite);
		bottomSprite = object;
	}
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_v_slider_back_middle);
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setTexture(texture);
		object->alignParamToTexture();
		object->setPos(ms::Vector3fMake(ms::GLScene::SCREEN_SIZE_W*0.5f-topSprite->getTexture()->getImageSize().x,
										-ms::GLScene::SCREEN_SIZE_H*0.5f+topSprite->getTexture()->getImageSize().y,
										0.0f));
		object->setSize(ms::Vector2fMake(texture->getImageSize().x,
										 ms::GLScene::SCREEN_SIZE_H-(topSprite->getTexture()->getImageSize().y*2.0f)));
		ASSERT(!middleSprite);
		middleSprite = object;
	}
}
//--------------------------------
BOOL ViewerVSlider::update(ms::Uint32 elapsedTime){
	BOOL isDraw = FALSE;
	return isDraw;
}
//--------------------------------
void ViewerVSlider::draw2D(){
	topSprite->draw();
	bottomSprite->draw();
	middleSprite->draw();
}
//--------------------------------
void ViewerVSlider::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
}
//--------------------------------
void ViewerVSlider::touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
}
//--------------------------------
void ViewerVSlider::touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
}
//--------------------------------
void ViewerVSlider::touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
}
//--------------------------------
float ViewerVSlider::getWidth(){
	return topSprite->getSize().x;
}
