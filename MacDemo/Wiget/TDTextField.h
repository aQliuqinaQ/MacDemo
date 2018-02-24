//
//  TDTextField.h
//  MacDemo
//
//  Created by liuqin on 2018/1/22.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TDTextField : NSTextFieldCell
- (NSRect)adjustedFrameToVerticallyCenterText:(NSRect)frame;
@end
