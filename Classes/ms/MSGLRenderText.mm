#if 0
//
//  RenderText.m
//  IAI
//
//  Created by akira on 09/02/15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <memory.h>
#import "RenderText.h"

@implementation RenderTextInfo

@synthesize uv;

+ (id) infoWithUV:(CGFloat)u0 v0:(CGFloat)v0  u1:(CGFloat)u1  v1:(CGFloat)v1
{
	RenderTextInfo* text = [[RenderTextInfo alloc] init];	
	[text autorelease];
	[text setUV:u0 v0:v0 u1:u1 v1:v1];
	return text;
}

- (void) setUV:(CGFloat)u0 v0:(CGFloat)v0  u1:(CGFloat)u1  v1:(CGFloat)v1
{
	uv.uv0.x = u0;
	uv.uv0.y = v0;
	uv.uv1.x = u1;
	uv.uv1.y = v1;
}

@end

@implementation RenderText

@synthesize texture;
@synthesize textInfo;
@synthesize text;
@synthesize drawWidth;

- (id) initWithTextMax:(int)_textMax spaceWidth:(int)_spaceWidth gapPosX:(int)_gapPosX
{
	if (self = [super init]){
		textMax = _textMax;
		spaceWidth = _spaceWidth;
		gapPosX = _gapPosX;
		
		textRender = malloc(sizeof(RenderSprite*)*_textMax);
		ASSERT(textRender);
		memset(textRender, 0, sizeof(RenderSprite*)*_textMax);
		for(int i = 0; i < _textMax; i++){
			RenderSprite* renderSprite = [[RenderSprite alloc] init];
			[renderSprite setAlphaTest:TRUE];
			textRender[i] = renderSprite;
		}
		
		drawWidth = 0;
	}
	return self;
}

- (void) setRenderText:(NSString*)_text
{
	if(textInfo && textRender){
		NSUInteger textLength = [_text length];
		ASSERT(textLength <= textMax);
		for(int i = 0; i < textLength; i++){
			unichar c = [_text characterAtIndex:i];
			if(c != ' '){
				NSString* charKey = [NSString stringWithCharacters:&c length:1];
				RenderTextInfo* nowTextInfo = [textInfo objectForKey:charKey];
				textRender[i].uv = nowTextInfo.uv;
			}else{
				textRender[i].uv = UVMake(0.0f, 0.0f, 0.0f, 0.0f);
			}
		}
		self.text = _text;
		
		[self setPos:pos];
	}else{
		ASSERT(false);
	}
}

- (void) setPos:(CGPoint)_pos{
	ASSERT(texture);
	[super setPos:_pos];

	CGSize textureSize = texture.textureSize;
	int posX = _pos.x;
	int length = [text length];
	ASSERT(length > 0);
	for(int i = 0; i < length; i++){
		CGPoint posWord;
		posWord.x = posX;
		posWord.y = _pos.y;
		unichar c = [text characterAtIndex:i];
		if(c != ' '){
			[textRender[i] setRenderTexture:texture];
			[textRender[i] setPos:posWord];
			UV uv = textRender[i].uv;
			posX += (textureSize.x * (uv.uv1.x - uv.uv0.x)) + gapPosX;
		}else{
			posX += spaceWidth + gapPosX;
		}
	}
	drawWidth = posX - _pos.x;
}

- (void) draw{
	int length = [text length];
	for(int i = 0; i < length; i++){
		[textRender[i] draw];
	}
}

- (void)dealloc {
	[texture release];
	if(textRender){
		for(int i = 0; i < textMax; i++){
			[textRender[i] release];
		}
		free(textRender);
	}
	[textInfo release];
	[text release];
	[super dealloc];
}
@end


#endif