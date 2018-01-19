//
//  AddDeviceWindow.m
//  MacDemo
//
//  Created by liuqin on 2018/1/18.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "AddDeviceWindow.h"
#import "AddDeviceViewController.h"
@interface AddDeviceWindow ()

@end

@implementation AddDeviceWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    self.contentViewController = [[AddDeviceViewController alloc] initWithNibName:@"AddDeviceViewController" bundle:nil];
}

@end
