//
//  VideoPlayFullWindow.m
//  MacDemo
//
//  Created by liuqin on 2019/2/15.
//  Copyright © 2019 liuqin. All rights reserved.
//

#import "VideoPlayFullWindow.h"

@interface VideoPlayFullWindow ()

@end

@implementation VideoPlayFullWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willExitFull:) name:NSWindowWillExitFullScreenNotification object:self.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowDidResize:)
                                                 name:NSWindowDidResizeNotification
                                               object:self];
}
-(void)willExitFull:(NSNotification*)notification {
    
    NSLog(@"即将退出全屏");
    NSView *view = self.window.contentView.subviews[0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fullWindowClosed" object:view];
    [self close];
}
@end
