//
//  Controller.m
//  Lucky Draw
//
//  Created by nowa on 08-8-12.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Controller.h"
#import <AppKit/AppKit.h>

@implementation Controller

- (void)openImageURL: (NSURL*)url
{
	[mImageView setImageWithURL: url];
}

- (void)awakeFromNib
{
    NSString *   path = [[NSBundle mainBundle] pathForResource: @"background"
														ofType: @"png"];
    NSURL *      url = [NSURL fileURLWithPath: path];
	
    [self openImageURL: url];
	
    // customize the IKImageView...
    [mImageView setDoubleClickOpensImageEditPanel: NO];
    // [mImageView setCurrentToolMode: IKToolModeMove];
    [mImageView zoomImageToFit: self];
    [mImageView setDelegate: self];
	
}

- (IBAction)draw:(id)sender
{
	NSInteger * button_status = [mButton tag];
	NSLog(@"B: %d", button_status);
	if (button_status == 0) {
		[NSThread
		 detachNewThreadSelector: @selector(interpret:)
		 toTarget:		     self
		 withObject:		     nil];
	} else if (button_status == 1) {
		[mButton setTag:0];
		[mButton setTitle:@"开始抽奖"];
	}
}

- (void)interpret:(id)theNames
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[mButton setTag:1];
	[mButton setTitle:@"停止抽奖"];
	
	NSString * filename = @"~/Desktop/list.txt";
	filename = [filename stringByStandardizingPath];
	NSLog(@"filename: %s", [filename UTF8String]);
	
	NSString * name_list = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:NULL];
	NSLog(@"namelist: %d", [name_list length]);
	
	if (name_list == NULL) {
		[mLabel setTitleWithMnemonic:@"你的桌面上没有list.txt文件！"];
		[NSThread exit];
	}
	
	NSRange range = [name_list rangeOfString:@"\n"];
	NSLog(@"location: %i", range.location);
	
	NSArray * anames = [name_list componentsSeparatedByString:@"\n"];
	NSLog(@"names length: %d", [anames count]);
	
	int count = [anames count];
	while ([mButton tag] == 1) {
		NSString * temp = [anames objectAtIndex:SSRandomIntBetween(0, count-1)];
		if (temp != NULL) {
			[mLabel setTitleWithMnemonic:temp];
			[NSThread sleepForTimeInterval:0.09];
		}
	}
	[pool release];
	[NSThread exit];
}

@end
