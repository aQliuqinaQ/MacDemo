//
//  TabButton.h
//  MacDemo
//
//  Created by liuqin on 2018/1/17.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol TabBtnDelegate;
@interface TabButton : NSView
@property (nonatomic,assign)id<TabBtnDelegate>delegate;
-(instancetype)initWithFrame:(NSRect)frameRect image:(NSImage *)image title:(NSString *)title tag:(NSString *)identifier;
@end


@protocol TabBtnDelegate <NSObject>
-(void)onClickTabCloseBtn:(NSString *)identifier;
-(void)selecteTabBtn:(NSString *)identifier;
@end
