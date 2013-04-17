#if 0
//
//  NSMutableString+EmailEncoding.m
//  iTouchNumber
//
//  Created by ento on 12/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSMutableString+EmailEncoding.h"

@implementation NSMutableString (EmailEncoding)

- (NSMutableString*)encodeForEmail {
	// this escapes accented characters like Ü and É
	NSString *escaped = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[self setString:escaped];
	
	// this escapes other characters that the above function may miss
	[self replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"!" withString:@"%21" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"$" withString:@"%24" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"-" withString:@"%2D"options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"." withString:@"%2E"options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	[self replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self length])];
	return self;
}

@end
#endif