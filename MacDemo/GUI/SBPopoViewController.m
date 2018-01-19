//
//  SBPopoViewController.m
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "SBPopoViewController.h"

@interface SBPopoViewController ()

@end

@implementation SBPopoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)quit:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

@end
