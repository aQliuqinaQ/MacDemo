//
//  VideoPlayView.h
//  MacDemo
//
//  Created by liuqin on 2019/2/13.
//  Copyright © 2019 liuqin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol VideoPlayViewDelegate <NSObject>

- (void)fullScreen:(NSControlStateValue)state;

@end
@interface VideoPlayView : NSView
@property(nonatomic,weak)id<VideoPlayViewDelegate>delegate;
-(void)setViewsWithM:(int)m N:(int)n;
- (void)setFullScreenItemState:(NSControlStateValue)state;
@end

NS_ASSUME_NONNULL_END
