//
//  FirstViewController.h
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void (^MainBtnSelected)(void);
typedef void (^DeviceManagerBtnSelected)(void);
typedef void (^MainBtnSelected)(void);
@interface FirstViewController : NSViewController
@property (nonatomic,copy)MainBtnSelected mainBtnSelectedblock;
@property (nonatomic,copy)DeviceManagerBtnSelected deviceManagerBtnSelectedblock;
@end
