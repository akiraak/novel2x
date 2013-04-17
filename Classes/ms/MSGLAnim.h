namespace ms {

	//--------------------------------------
	// エフェクト基本クラス
	class GLAnimEffect : public ms::ListNode {
	public:
		GLAnimEffect();
		virtual ~GLAnimEffect();

		enum STATE {
			STATE_EXEC_WAIT = 0,
			STATE_EXEC,
			STATE_END,
		};

		virtual void initWithTimeStart(ms::Uint32 _timeStart, ms::Uint32 _timeAnimation);
		virtual void start();
		virtual void clear();
		virtual void update(ms::Uint32 elapsedTime);
		virtual BOOL getEnd();
		virtual STATE getState(){return state;}
		virtual void setRender(GLRender* _render){render = _render;}
		virtual GLRender* getRender(){return render;}
		virtual ms::Uint32 getTimeStart(){return timeStart;}
		virtual ms::Uint32 getTimeAnimation(){return timeAnimation;}
		virtual ms::Uint32 getTimer(){return timer;}

	private:
		STATE		state;
		GLRender*	render;
		ms::Uint32	timeStart;
		ms::Uint32	timeAnimation;
		ms::Uint32	timer;
		BOOL		execEnd;
	};

	//--------------------------------------
	// 移動：線形補間：座標指定
	class GLAnimEffectMoveLinear : public GLAnimEffect {
	public:
		GLAnimEffectMoveLinear();
		virtual ~GLAnimEffectMoveLinear();
		virtual void update(ms::Uint32 elapsedTime);
		virtual void setPos(ms::Vector3f _startPos, ms::Vector3f _endPos);
	private:
		ms::Vector3f startPos;
		ms::Vector3f endPos;
	};
	
	//--------------------------------------
	// アルファ：線形補間
	class GLAnimEffectAlphaLinear : public GLAnimEffect {
	public:
		GLAnimEffectAlphaLinear();
		virtual ~GLAnimEffectAlphaLinear();
		virtual void update(ms::Uint32 elapsedTime);
		virtual void setAlpha(float _startAlpha, float _endAlpha);
	private:
		float startAlpha;
		float endAlpha;
	};
	
	//--------------------------------------
	// アニメーション制御
	class GLAnim {
	public:
		GLAnim();
		virtual ~GLAnim();
		
		void init(BOOL _effectDelete);
		void update(ms::Uint32 elapsedTime);
		void setRender(GLRender* _render);
		void addEffect(GLAnimEffect* effect);
		void start();
		void stop();
		BOOL getEnd();
		BOOL resting();
	private:
		enum STATE {
			STATE_IDLE = 0,
			STATE_EXEC_INIT,
			STATE_EXEC,
			STATE_END,
		};
		STATE			state;
		GLRender*		render;
		List			effects;
		BOOL			effectDelete;
		ms::Uint32		timer;
	};
};


#if 0
//
//  RenderAnimation.h
//  IAI
//
//  Created by akira on 09/04/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderSprite.h"

CGPoint CGPointMakeByVector(double r, double theta);
void CGPointGetVectorValue(CGPoint p, double *r, double *theta);

//--------------------------------------
// アニメーション基本クラス
typedef enum {
	RENDER_ANIMATION_EFFECT_STATE_EXEC_WAIT = 0,
	RENDER_ANIMATION_EFFECT_STATE_EXEC,
	RENDER_ANIMATION_EFFECT_STATE_END,
} RENDER_ANIMATION_EFFECT_STATE;

@interface RenderAnimationEffect : NSObject {
	Render*							render;
	double							timeStart;
	double							timeAnimation;
	double							timer;
	RENDER_ANIMATION_EFFECT_STATE	state;
	BOOL							execEnd;
}

- (id) initWithTimeStart:(double)_timeStart timeAnimation:(double)_timeAnimation;
- (void) start;
- (void) clear;
- (void) update:(NSTimeInterval)elapsedTime;
- (BOOL) end;

@property (nonatomic, retain) Render* render;
@property (readonly) double timer;

@end

//--------------------------------------
// 表示
@interface RenderAnimationEffectVisible : RenderAnimationEffect {
	BOOL visible;
	BOOL exec;
}

- (void) update:(NSTimeInterval)elapsedTime;
- (id) setShow:(BOOL)_visible;

@end

//--------------------------------------
// ベース：線形補間
@interface RenderAnimationEffectSeq : RenderAnimationEffect {
	NSArray *values;
}

- (void) update:(NSTimeInterval)elapsedTime;
- (void) updated:(NSTimeInterval)elapsedTime prevValue:(id)prevValue nextValue:(id)nextValue ratio:(double)ratio;
- (id) setValues:(NSArray*)array;

@end

//--------------------------------------
// 移動：線形補間：座標指定
@interface RenderAnimationEffectMoveLinear : RenderAnimationEffect {
	CGPoint posStart;
	CGPoint posEnd;
}

- (void) update:(NSTimeInterval)elapsedTime;
- (id) setPosStart:(CGPoint)_posStart posEnd:(CGPoint)_posEnd;

@end

//--------------------------------------
// 移動：線形補間：ベクトル指定
@interface RenderAnimationEffectMoveLinearVec : RenderAnimationEffect {
	CGPoint posStart;
	CGPoint vecMove;
}

- (void) update:(NSTimeInterval)elapsedTime;
- (id) setPosStart:(CGPoint)_posStart vecMove:(CGPoint)_vecMove;

@end

//--------------------------------------
// 移動：線形補間：ベクトル指定
@interface RenderAnimationEffectMoveAccel : RenderAnimationEffect {
	CGPoint posStart;
	CGPoint vecMove;
	CGPoint vecMoveAccel;
}

- (void) update:(NSTimeInterval)elapsedTime;
- (id) setPosStart:(CGPoint)_posStart vecMove:(CGPoint)_vecMove vecMoveAccel:(CGPoint)_vecMoveAccel;

@end

//--------------------------------------
// 移動：ターゲット指定
@interface RenderAnimationEffectMoveFollow : RenderAnimationEffect {
	NSInvocation *invocation;
	CGPoint offset;
}

@property (nonatomic, retain) NSInvocation *invocation;

- (id) setTarget:(id)anObject selector:(SEL)aSelector;
- (id) setOffset:(CGPoint)aPoint;

@end

//--------------------------------------
// スケール：線形補間：値指定
@interface RenderAnimationEffectSeqScale : RenderAnimationEffectSeq {
	CGPoint scalePoint;
}

- (id) setStartValue:(CGPoint)start endValue:(CGPoint)end;
- (id) setScaleValues:(NSUInteger)count, ...;
- (id) setScaleCenter:(CGPoint)aPoint;

@end

//--------------------------------------
// 色：線形補間：色指定
@interface RenderAnimationEffectSeqColor : RenderAnimationEffectSeq {
}

@end

//--------------------------------------
// UV変更：線形補間
@interface RenderAnimationEffectUVLinear : RenderAnimationEffect {
	UV uvStart;
	UV uvEnd;
}

- (void) update:(NSTimeInterval)elapsedTime;
- (id) setUVStart:(UV)_uvStart uvEnd:(UV)_uvEnd;

@end

//--------------------------------------
// アニメーション制御
typedef enum {
	RENDER_ANIMATION_STATE_IDLE = 0,
	RENDER_ANIMATION_STATE_EXEC_INIT,
	RENDER_ANIMATION_STATE_EXEC,
	RENDER_ANIMATION_STATE_END,
} RENDER_ANIMATION_STATE;

@protocol Animation

- (void) update:(NSTimeInterval)elapsedTime;
- (void) start;
- (void) stop;
- (BOOL) end;
- (BOOL) resting;

@end


@interface RenderAnimation : NSObject<Animation> {
	Render*			render;
	NSArray*				effects;
	double					timer;
	RENDER_ANIMATION_STATE	state;
}

@property (nonatomic, retain) Render* render;
@property (nonatomic, retain) NSArray* effects;

//- (id) initWithRender:(RenderSprite*)_renderSprite effects:(NSArray*)_effects;
- (id) init;
- (void) setEffects:(NSArray*)_effects;


@end
#endif