#if 0
//
//  MSSubtitle.m
//  IAI
//
//  Created by akira on 09/03/15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MSSubtitle.h"

@implementation MSSubtitleData

@synthesize text;
@synthesize time;

+(id)initWithData:(NSArray*)_text time:(double)_time
{
	ASSERT([_text count] <= SUBTITLE_LINES_MAX);
	MSSubtitleData* data = [[MSSubtitleData alloc] init];	
	[data autorelease];
	data.text = _text;
	data.time = _time;
	return data;
}

- (void)dealloc {
	[text release];
	[super dealloc];
}
@end // MSSubtitleData


//------------------------------------------------------------
@implementation MSSubtitle

@synthesize texture;
@synthesize textInfo;
@synthesize data;

- (id) initWithSize:(int)_spaceWidth posY:(int)_posY gapPosX:(int)_gapPosX{
	state = (SUBTITLE_STATE)0;
	timer = 0;
	showCount = 0;
	showIndex = 0;
	lineHeight = 0;

	if (self = [super init]){
		spaceWidth = _spaceWidth;
		posY = _posY;

		for(int i = 0; i < SUBTITLE_LINES_MAX; i++){
			RenderText* render = [[RenderText alloc] initWithTextMax:256 spaceWidth:spaceWidth gapPosX:_gapPosX];
			textRender[i] = render;
			textRenderActive[i] = FALSE;
		}
	}
	return self;
}

- (void)start
{
	state = SUBTITLE_STATE_INIT;
}

- (void)stop
{
	state = SUBTITLE_STATE_IDLE;
}

- (void)setLineHeight:(int)height
{
	lineHeight = height;
}

-(void)update:(NSTimeInterval)elapsedTime
{
	switch(state)
	{			
		case SUBTITLE_STATE_IDLE:
			break;

		case SUBTITLE_STATE_INIT:
			timer = 0.0;
			showCount = [data count];
			showIndex = 0;
			state = SUBTITLE_STATE_SHOW_INIT;
			//break;

		case SUBTITLE_STATE_SHOW_INIT:
			if(showIndex < showCount){
				MSSubtitleData* subtileData = [data objectAtIndex:showIndex];
				int lineCount = [subtileData.text count];
				for(int i = 0; i < SUBTITLE_LINES_MAX; i++){
					if(i < lineCount){
						textRender[i].texture = texture;
						textRender[i].textInfo = textInfo;
						[textRender[i] setRenderText:[subtileData.text objectAtIndex:i]];
						textRenderActive[i] = TRUE;
					}else{
						textRenderActive[i] = FALSE;
					}
				}
				state = SUBTITLE_STATE_SHOW;				
				break;
			}else{
				for(int i = 0; i < SUBTITLE_LINES_MAX; i++){
					textRenderActive[i] = FALSE;
				}
				state = SUBTITLE_STATE_IDLE;
				break;
			}
			//break;
		
		case SUBTITLE_STATE_SHOW:
		{	
			MSSubtitleData* subtileData = [data objectAtIndex:showIndex];
			timer += elapsedTime;
			if(timer >= subtileData.time){
				timer -= subtileData.time;
				showIndex++;
				state = SUBTITLE_STATE_SHOW_INIT;				
			}				
			break;
		}
	}
}

-(void)draw
{
	if( state == SUBTITLE_STATE_SHOW_INIT ||
		state == SUBTITLE_STATE_SHOW )
	{
		float y = (float)posY;
		for(int i = 0; i < SUBTITLE_LINES_MAX; i++){
			if(textRenderActive[i]){
				int x = (320 / 2) - (textRender[i].drawWidth / 2);
				[textRender[i] setPos:CGPointMake(x, y)];
				[textRender[i] draw];
				y += lineHeight;
			}
		}
	}
}

-(void)dealloc {
	[texture release];
	[textInfo release];
	[data release];
	for(int i = 0; i < SUBTITLE_LINES_MAX; i++){
		[textRender[i] release];
	}
	[super dealloc];
}

@end // MSSubtitle

#endif