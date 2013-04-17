#import "MS.h"

namespace ms {
	//--------------------------------------
	// エフェクト基本クラス
	//--------------------------------------
	GLAnimEffect::GLAnimEffect():
	state((STATE)0),
	render(NULL),
	timeStart(0),
	timeAnimation(0),
	timer(0),
	execEnd(FALSE)
	{
	}
	//--------------------------------------
	GLAnimEffect::~GLAnimEffect(){
	}
	//--------------------------------------
	void GLAnimEffect::initWithTimeStart(ms::Uint32 _timeStart, ms::Uint32 _timeAnimation){
		timeStart = _timeStart;
		timeAnimation = _timeAnimation;
	}
	//--------------------------------------
	void GLAnimEffect::start(){
	}
	//--------------------------------------
	void GLAnimEffect::clear(){
		timer = 0.0f;
		state = (STATE)0;
		execEnd = FALSE;
	}
	//--------------------------------------
	void GLAnimEffect::update(ms::Uint32 elapsedTime){
		// 時間を進める
		if(state != STATE_END){
			timer += elapsedTime;
		}
		// 時間によって状態を変更
		switch(state){
			case STATE_EXEC_WAIT:
				if(timer >= timeStart){
					state = STATE_EXEC;
				}else{
					break;
				}
				//break;
			case STATE_EXEC:
                if(execEnd){
                    state = STATE_END;
                }else{
                    if(timer > (timeStart + timeAnimation)){
                        timer = (timeStart + timeAnimation);
                        execEnd = TRUE;
                    }
                }
				break;
			case STATE_END:
				break;
            default:
                break;
		}
		
	}
	//--------------------------------------
	BOOL GLAnimEffect::getEnd(){
		return (state == STATE_END);
	}
	
	//--------------------------------------
	// 移動：線形補間：座標指定
	GLAnimEffectMoveLinear::GLAnimEffectMoveLinear():
	startPos(ms::Vector3fMake(0.0f, 0.0f, 0.0f)),
	endPos(ms::Vector3fMake(0.0f, 0.0f, 0.0f))
	{
	}
	GLAnimEffectMoveLinear::~GLAnimEffectMoveLinear(){
	}
	void GLAnimEffectMoveLinear::update(ms::Uint32 elapsedTime){
		GLAnimEffect::update(elapsedTime);
		GLAnimEffect::STATE effectState = getState();
		if(effectState == STATE_EXEC){
			Sint32 elapsedTimeAnimation = getTimer() - getTimeStart();
			Sint32 timeAnimation = getTimeAnimation();
			Vector3f pos;
			pos.x = startPos.x + ((endPos.x - startPos.x) * elapsedTimeAnimation / timeAnimation);
			pos.y = startPos.y + ((endPos.y - startPos.y) * elapsedTimeAnimation / timeAnimation);
			pos.z = startPos.z + ((endPos.z - startPos.y) * elapsedTimeAnimation / timeAnimation);
			getRender()->setPos(pos);
		}
	}
	void GLAnimEffectMoveLinear::setPos(ms::Vector3f _startPos, ms::Vector3f _endPos){
		startPos = _startPos;
		endPos = _endPos;
	}

	//--------------------------------------
	// アルファ：線形補間
	//--------------------------------------
	GLAnimEffectAlphaLinear::GLAnimEffectAlphaLinear():
	startAlpha(0.0f),
	endAlpha(0.0f)
	{
	}
	//--------------------------------------
	GLAnimEffectAlphaLinear::~GLAnimEffectAlphaLinear(){
	}
	//--------------------------------------
	void GLAnimEffectAlphaLinear::update(ms::Uint32 elapsedTime){
		GLAnimEffect::update(elapsedTime);
		GLAnimEffect::STATE effectState = getState();
		if(effectState == STATE_EXEC){
			Sint32 elapsedTimeAnimation = getTimer() - getTimeStart();
			Sint32 timeAnimation = getTimeAnimation();
			float alpha = startAlpha + ((endAlpha - startAlpha) * (float)elapsedTimeAnimation / (float)timeAnimation);
			GLSprite* sprite = dynamic_cast<GLSprite*>(getRender());
			ASSERT(sprite);
			Color4f color = sprite->getColor();
			color.a = alpha;
			sprite->setColor(color);
		}
	}
	//--------------------------------------
	void GLAnimEffectAlphaLinear::setAlpha(float _startAlpha, float _endAlpha){
		startAlpha = _startAlpha;
		endAlpha = _endAlpha;
	}

	//--------------------------------------
	// アニメーション制御
	//--------------------------------------
	GLAnim::GLAnim():
	state((STATE)0),
	render(NULL),
	effectDelete(FALSE),
	timer(0)
	{
		effects.init();
	}
	//--------------------------------------
	GLAnim::~GLAnim(){
		if(effectDelete){
			GLAnimEffect* node = (GLAnimEffect*)effects.getTail();
			while(node){
				GLAnimEffect* prevNode = (GLAnimEffect*)node->getPrev();
				effects.remove(node);
				MS_SAFE_DELETE(node);
				node = prevNode;
			}
		}

	}
	//--------------------------------------
	void GLAnim::init(BOOL _effectDelete){
		effectDelete = _effectDelete;
	}
	//--------------------------------------
	void GLAnim::update(ms::Uint32 elapsedTime){
		switch(state){
			case STATE_IDLE:
				break;
			case STATE_EXEC_INIT:
			{
				// 全てのエフェクトをクリア
				GLAnimEffect* node = (GLAnimEffect*)effects.getHead();
				while(node){
					GLAnimEffect* nodeNext = (GLAnimEffect*)node->getNext();
					node->clear();
					node->start();
					node = nodeNext;
				}
				timer = 0;
				state = STATE_EXEC;
				//break;
			}
			case STATE_EXEC:
			{
				// エフェクトの更新と終了判定
				BOOL end = TRUE;
				GLAnimEffect* node = (GLAnimEffect*)effects.getHead();
				while(node){
					GLAnimEffect* nodeNext = (GLAnimEffect*)node->getNext();
					node->update(elapsedTime);
					if(node->getEnd() == FALSE){
						end = FALSE;
					}
					node = nodeNext;
				}
				if(end){
					state = STATE_END;
				}
				timer += elapsedTime;
				break;
			}
			case STATE_END:
				break;
		}		
	}
	//--------------------------------------
	void GLAnim::setRender(GLRender* _render){
		// エフェクトへ描画オブジェクトを関連付け
		ASSERT(_render);
		render = _render;
		GLAnimEffect* node = (GLAnimEffect*)effects.getHead();
		while(node){
			node->setRender(_render);
			node = (GLAnimEffect*)node->getNext();
		}
	}
	//--------------------------------------
	void GLAnim::addEffect(GLAnimEffect* effect){
		ASSERT(effect);
		effects.addTail(effect);
	}
	//--------------------------------------
	void GLAnim::start(){
		state = STATE_EXEC_INIT;
	}
	//--------------------------------------
	void GLAnim::stop(){
		state = STATE_IDLE;
	}
	//--------------------------------------
	BOOL GLAnim::getEnd(){
		return (state == STATE_END);
	}
	//--------------------------------------
	BOOL GLAnim::resting(){
		return (state == STATE_END || state == STATE_IDLE);
	}
}












#if 0
//
//  RenderAnimation.m
//  IAI
//
//  Created by akira on 09/04/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RenderAnimation.h"

CGPoint CGPointMakeByVector(double r, double theta) {
	return CGPointMake(r*cos(theta), r*sin(theta));
}

void CGPointGetVectorValue(CGPoint p, double *r, double *theta) {
	*theta = atan2((double)(p.y), (double)(p.x));
	*r = pow(p.x*p.x + p.y*p.y, 0.5);
}


//--------------------------------------
@implementation RenderAnimationEffect

@synthesize render;
@synthesize timer;

- (id) initWithTimeStart:(double)_timeStart timeAnimation:(double)_timeAnimation{
	// メンバの初期化
	timeStart = 0.0;
	timeAnimation = 0.0;
	[self clear];

	if(self = [super init]){
		timeStart = _timeStart;
		timeAnimation = _timeAnimation;
	}
	return self;	
}

- (void) start {}

- (void) clear{
	timer = 0.0f;
	state = (RENDER_ANIMATION_EFFECT_STATE)0;
	execEnd = FALSE;
}

- (void) update:(NSTimeInterval)elapsedTime{
	// 時間を進める
	if(state != RENDER_ANIMATION_EFFECT_STATE_END){
		timer += elapsedTime;
	}
	// 時間によって状態を変更
	switch(state){
		case RENDER_ANIMATION_EFFECT_STATE_EXEC_WAIT:
			if(timer >= timeStart){
				state = RENDER_ANIMATION_EFFECT_STATE_EXEC;
			}else{
				break;
			}
			//break;
		case RENDER_ANIMATION_EFFECT_STATE_EXEC:
			if(timeAnimation >= 0.0){
				if(execEnd){
					state = RENDER_ANIMATION_EFFECT_STATE_END;
				}else{
					if(timer > (timeStart + timeAnimation)){
						timer = (timeStart + timeAnimation);
						execEnd = TRUE;
					}
				}
			}
			break;
		case RENDER_ANIMATION_EFFECT_STATE_END:
			break;
	}
	
}

- (BOOL) end{
	return (state == RENDER_ANIMATION_EFFECT_STATE_END);
}

@end

//--------------------------------------
@implementation RenderAnimationEffectVisible

- (id) initWithTimeStart:(double)_timeStart timeAnimation:(double)_timeAnimation{
	if(self = [super initWithTimeStart:_timeStart timeAnimation:_timeAnimation]){
		exec = FALSE;
	}
	return self;
}

- (void) update:(NSTimeInterval)elapsedTime{
	[super update:elapsedTime];
	if(state == RENDER_ANIMATION_EFFECT_STATE_EXEC && !exec){
		[render setVisible:visible];
		exec = TRUE;
	}
}

- (id) setShow:(BOOL)_visible{
	visible = _visible;
	return self;
}

@end


//--------------------------------------
@implementation RenderAnimationEffectSeq


- (void) update:(NSTimeInterval)elapsedTime{
	[super update:elapsedTime];
	
	if(state == RENDER_ANIMATION_EFFECT_STATE_EXEC){
		NSUInteger maxIndex = [values count] - 1;
		double elapsedTimeIndex = maxIndex * (timer - timeStart) / timeAnimation;
		NSUInteger prevIndex = (int)(floor(elapsedTimeIndex));
		NSUInteger nextIndex = (prevIndex == maxIndex) ? prevIndex : prevIndex + 1;
		double gradient = elapsedTimeIndex - prevIndex;
		[self updated:elapsedTime
			prevValue:[values objectAtIndex:prevIndex]
			nextValue:[values objectAtIndex:nextIndex]
				ratio:gradient];
	}
}

- (void) updated:(NSTimeInterval)elapsedTime prevValue:(id)prevValue nextValue:(id)nextValue ratio:(double)ratio {
}

- (id)setValues:(NSArray*)array{
	[values release];
	values = array;
	[values retain];
	return self;
}

- (void)dealloc {
	[values release];
	[super dealloc];
}

@end

//--------------------------------------
@implementation RenderAnimationEffectMoveLinear

- (void) update:(NSTimeInterval)elapsedTime{
	[super update:elapsedTime];
	
	if(state == RENDER_ANIMATION_EFFECT_STATE_EXEC){
		double elapsedTimeAnimation = timer - timeStart;
		CGPoint pos;
		pos.x = posStart.x + ((posEnd.x - posStart.x) * elapsedTimeAnimation / timeAnimation);
		pos.y = posStart.y + ((posEnd.y - posStart.y) * elapsedTimeAnimation / timeAnimation);
		[render setPos:pos];	
	}
}

- (id) setPosStart:(CGPoint)_posStart posEnd:(CGPoint)_posEnd{
	// メンバの初期化
	posStart = _posStart;
	posEnd = _posEnd;
	return self;
}

@end

//--------------------------------------
@implementation RenderAnimationEffectMoveLinearVec

- (void) update:(NSTimeInterval)elapsedTime{
	[super update:elapsedTime];
	
	if(state == RENDER_ANIMATION_EFFECT_STATE_EXEC){
		double elapsedTimeAnimation = timer - timeStart;
		CGPoint pos;
		pos.x = posStart.x + vecMove.x * elapsedTimeAnimation;
		pos.y = posStart.y + vecMove.y * elapsedTimeAnimation; 
		[render setPos:pos];	
	}
}

- (id) setPosStart:(CGPoint)_posStart vecMove:(CGPoint)_vecMove{
	// メンバの初期化
	posStart = _posStart;
	vecMove = _vecMove;
	return self;
}

@end

//--------------------------------------
@implementation RenderAnimationEffectMoveAccel

- (void) update:(NSTimeInterval)elapsedTime{
	[super update:elapsedTime];
	
	if(state == RENDER_ANIMATION_EFFECT_STATE_EXEC){
		CGPoint pos;
		pos = [render pos];
		pos.x += vecMove.x * elapsedTime;
		pos.y += vecMove.y * elapsedTime;
		[render setPos:pos];	
		
		vecMove.x += vecMoveAccel.x * elapsedTime;
		vecMove.y += vecMoveAccel.y * elapsedTime;
	}
}

- (id) setPosStart:(CGPoint)_posStart vecMove:(CGPoint)_vecMove vecMoveAccel:(CGPoint)_vecMoveAccel{
	// メンバの初期化
	posStart = _posStart;
	vecMove = _vecMove;
	vecMoveAccel = _vecMoveAccel;
	return self;
}

@end

//--------------------------------------
@implementation RenderAnimationEffectMoveFollow

@synthesize invocation;

- (void) update:(NSTimeInterval)elapsedTime{
	[super update:elapsedTime];
	
	if(state == RENDER_ANIMATION_EFFECT_STATE_EXEC){
		CGPoint pos;
		[self.invocation invoke];
		[self.invocation getReturnValue:&pos];
		[render setPos:CGPointMake(pos.x + offset.x, pos.y + offset.y)];	
	}
}

- (id) setTarget:(id)target selector:(SEL)selector {
	// メンバの初期化
	NSMethodSignature * sig = nil;
	sig = [[target class] instanceMethodSignatureForSelector:selector];
	ASSERT(strcmp([sig methodReturnType], @encode(CGPoint)) == 0);
	NSInvocation * myInvocation = nil;
	myInvocation = [NSInvocation invocationWithMethodSignature:sig];
	[myInvocation setTarget:target];
	[myInvocation setSelector:selector];	
	self.invocation = myInvocation;
	return self;
}

- (id) setOffset:(CGPoint)aPoint {
	offset = aPoint;
	return self;
}

- (void) dealloc {
	[invocation release];
	[super dealloc];
}

@end

//--------------------------------------
@implementation RenderAnimationEffectSeqScale

- (id)initWithTimeStart:(double)_timeStart timeAnimation:(double)_timeAnimation{
	if(self = [super initWithTimeStart:_timeStart timeAnimation:_timeAnimation]) {
		scalePoint = CC;
	}
	return self;
}

- (void)start {
	if([render isKindOfClass:[RenderSprite class]]){
		RenderSprite* sprite = (RenderSprite*)render;
		[sprite setScalePoint:scalePoint];
	}
}

- (void) updated:(NSTimeInterval)elapsedTime prevValue:(id)prevValue nextValue:(id)nextValue ratio:(double)ratio {
	if([render isKindOfClass:[RenderSprite class]]){
		RenderSprite* sprite = (RenderSprite*)render;
		CGPoint prevScale, nextScale;
		[prevValue getValue:&prevScale];
		[nextValue getValue:&nextScale];
		CGPoint scale;
		scale.x = prevScale.x + (nextScale.x - prevScale.x) * ratio;
		scale.y = prevScale.y + (nextScale.y - prevScale.y) * ratio;
		[sprite setScale:scale];	
	}
}

- (id)setStartValue:(CGPoint)start endValue:(CGPoint)end {
	// メンバの初期化
	[self setValues:[NSArray arrayWithObjects:
					 [NSValue value:&start withObjCType:@encode(CGPoint)],
					 [NSValue value:&end withObjCType:@encode(CGPoint)],
					 nil]];
	return self;
}

- (id) setScaleValues:(NSUInteger)count, ... {
	NSMutableArray *temp = [NSMutableArray array];
	va_list lst;
	CGPoint each;
	va_start(lst, count);
	for (int i=count; i>0; i--) {
		each = va_arg(lst, CGPoint);
		[temp addObject:[NSValue value:&each withObjCType:@encode(CGPoint)]];
	}
	va_end(lst);
	[self setValues:[NSArray arrayWithArray:temp]];
	return self;
}

- (id)setScaleCenter:(CGPoint)aPoint {
	scalePoint = aPoint;
	return self;
}

@end

//--------------------------------------
@implementation RenderAnimationEffectSeqColor

- (void) updated:(NSTimeInterval)elapsedTime prevValue:(id)prevValue nextValue:(id)nextValue ratio:(double)ratio {
	if([render isKindOfClass:[RenderSprite class]]){
		RenderSprite* sprite = (RenderSprite*)render;
		CGColorRef prevColor = [(UIColor*)prevValue CGColor];
		CGColorRef nextColor = [(UIColor*)nextValue CGColor];
		const CGFloat *prevColorComponents = CGColorGetComponents(prevColor);
		const CGFloat *nextColorComponents = CGColorGetComponents(nextColor);
		size_t prevColorNum = CGColorGetNumberOfComponents(prevColor);
		size_t nextColorNum = CGColorGetNumberOfComponents(nextColor);
		ASSERT(prevColorNum==nextColorNum);
		CGFloat *newColorComponents = malloc(sizeof(CGFloat)*prevColorNum);
		for(int i=0; i<prevColorNum; i++){
			newColorComponents[i] = prevColorComponents[i] + (nextColorComponents[i] - prevColorComponents[i])*ratio;
		}
		//NSLOG(@"%f, %f, %f, %d, %d, %f", timeStart, timer, elapsedTimeIndex, prevIndex, nextIndex, newColorComponents[3]);
		CGColorRef newColor = CGColorCreate(CGColorGetColorSpace(prevColor), newColorComponents);
		[sprite setColor:[UIColor colorWithCGColor:newColor]];	
		CGColorRelease(newColor);
		free(newColorComponents);
	}
}

@end

//--------------------------------------
@implementation RenderAnimationEffectUVLinear

- (void) update:(NSTimeInterval)elapsedTime{
	[super update:elapsedTime];
	
	if(state == RENDER_ANIMATION_EFFECT_STATE_EXEC){
		RenderSprite* sprite = (RenderSprite*)render;
		double elapsedTimeAnimation = timer - timeStart;
		UV uv;
		uv.uv0.x = uvStart.uv0.x + ((uvEnd.uv0.x - uvStart.uv0.x) * elapsedTimeAnimation / timeAnimation);
		uv.uv0.y = uvStart.uv0.y + ((uvEnd.uv0.y - uvStart.uv0.y) * elapsedTimeAnimation / timeAnimation);
		uv.uv1.x = uvStart.uv1.x + ((uvEnd.uv1.x - uvStart.uv1.x) * elapsedTimeAnimation / timeAnimation);
		uv.uv1.y = uvStart.uv1.y + ((uvEnd.uv1.y - uvStart.uv1.y) * elapsedTimeAnimation / timeAnimation);
		[sprite setUv:uv];
	}
}

- (id) setUVStart:(UV)_uvStart uvEnd:(UV)_uvEnd{
	uvStart = _uvStart;
	uvEnd = _uvEnd;
	return self;
}

@end

//--------------------------------------
@implementation RenderAnimation

@synthesize render;
@dynamic effects;

//- (id) initWithRender:(RenderSprite*)_renderSprite effects:(NSArray*)_effects{
- (id) init{
	// メンバの初期化
	render = nil;
	effects = nil;
	timer = 0.0;
	state = (RENDER_ANIMATION_STATE)0;
	
	if(self = [super init]){
	}
	return self;
}

- (void) setEffects:(NSArray*)_effects{
	[effects release];
	effects = _effects;
	[effects retain];
	
	// エフェクトへ描画オブジェクトを関連付け
	ASSERT(render);
	int effectCount = [effects count];
	for(int i = 0; i < effectCount; i++){
		RenderAnimationEffect* effect = [effects objectAtIndex:i];
		effect.render = render;
	}		
}

- (NSArray*)effects{
	return effects;
}

- (void) update:(NSTimeInterval)elapsedTime{
	
	switch (state) {
		case RENDER_ANIMATION_STATE_IDLE:
			break;
		case RENDER_ANIMATION_STATE_EXEC_INIT:
		{
			// 全てのエフェクトをクリア
			int effectCount = [effects count];
			for(int i = 0; i < effectCount; i++){
				RenderAnimationEffect* effect = [effects objectAtIndex:i];
				[effect clear];
				[effect start];
			}
			timer = 0.0;
			state = RENDER_ANIMATION_STATE_EXEC;
			//break;
		}
		case RENDER_ANIMATION_STATE_EXEC:
		{
			// エフェクトの更新と終了判定
			BOOL end = TRUE;
			int effectCount = [effects count];
			for(int i = 0; i < effectCount; i++){
				RenderAnimationEffect* effect = [effects objectAtIndex:i];
				[effect update:elapsedTime];
				if([effect end] == FALSE){
					end = FALSE;
				}
			}
			if(end){
				state = RENDER_ANIMATION_STATE_END;
			}
			timer += elapsedTime;
			break;
		}

		case RENDER_ANIMATION_STATE_END:
			break;
	}		
}

- (void) start{
	state = RENDER_ANIMATION_STATE_EXEC_INIT;
}
- (void) stop{
	state = RENDER_ANIMATION_STATE_IDLE;
}
- (BOOL) getEnd{
	return (state == RENDER_ANIMATION_STATE_END);
}

- (BOOL) resting {
	return (state == RENDER_ANIMATION_STATE_END || state == RENDER_ANIMATION_STATE_IDLE);
}

- (void)dealloc {
	[render release];
	[effects release];
	[super dealloc];
}

@end
#endif