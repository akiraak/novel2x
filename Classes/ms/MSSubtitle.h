#if 0
//
//  Subtitle.h
//  IAI
//
//  Created by akira on 09/03/15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSGLRenderText.h"

#define MSSUBTITLE_LINES_MAX		(4)
#define MSSUBTITLE_COUNT			(100)

@interface MSSubtitleData : NSObject {
	NSArray*	text;
	double		time;
}

@property (nonatomic, retain) NSArray* text;
@property (readwrite) double time;

+(id)initWithData:(NSArray*)_text time:(double)_time;

@end

typedef enum
{
	MSSUBTITLE_STATE_IDLE = 0,
	MSSUBTITLE_STATE_INIT,
	MSSUBTITLE_STATE_SHOW_INIT,
	MSSUBTITLE_STATE_SHOW,
	MSSUBTITLE_STATE_END,
} MSSUBTITLE_STATE;

@interface MSSubtitle : NSObject {
	MSGLTexture*		texture;
	NSDictionary*		textInfo;
	MSGLRenderText*		textRender[SUBTITLE_LINES_MAX];
	BOOL				textRenderActive[SUBTITLE_LINES_MAX];
	NSArray*			data;
	MSSUBTITLE_STATE	state;
	double				timer;
	int					showCount;
	int					showIndex;
	int					lineHeight;
	int					spaceWidth;
	int					posY;
}

@property (nonatomic, retain) MSGLTexture* texture;
@property (nonatomic, retain) NSDictionary* textInfo;
@property (nonatomic, retain) NSArray* data;

- (id) initWithSize:(int)_spaceWidth posY:(int)_posY gapPosX:(int)_gapPosX;
- (void) setData:(NSArray*)_data;
- (void) start;
- (void) stop;
- (void) setLineHeight:(int)height;
- (void) update:(NSTimeInterval)elapsedTime;
- (void) draw;

@end
#endif