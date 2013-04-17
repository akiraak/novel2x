#if 0
//
//  RenderText.h
//  IAI
//
//  Created by akira on 09/02/15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderSprite.h"

@interface RenderTextInfo : NSObject {
	UV uv;	
}

+ (id) infoWithUV:(CGFloat)u0 v0:(CGFloat)v0  u1:(CGFloat)u1  v1:(CGFloat)v1;
- (void) setUV:(CGFloat)u0 v0:(CGFloat)v0  u1:(CGFloat)u1  v1:(CGFloat)v1;

@property(readonly) UV uv;

@end


@interface RenderText : Render {
	Texture*		texture;
	NSDictionary*	textInfo;
	NSString*		text;
	RenderSprite**	textRender;
	int				textMax;
	int				textCount;
	int				drawWidth;
	int				spaceWidth;
	int				gapPosX;
}

@property (nonatomic, retain) Texture* texture;
@property (nonatomic, retain) NSDictionary* textInfo;
@property (nonatomic, retain) NSString* text;
@property (readonly) int drawWidth;

- (id) initWithTextMax:(int)_textMax spaceWidth:(int)_spaceWidth gapPosX:(int)_gapPosX;
- (void) setRenderText:(NSString*)_text;

@end
#endif