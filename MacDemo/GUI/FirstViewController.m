//
//  FirstViewController.m
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "FirstViewController.h"
#import "TabButton.h"
@interface FirstViewController (){
    
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear{
    [super viewWillAppear];
    NSLog(@"show first");
}
- (IBAction)showMainViewController:(id)sender {
    if(self.mainBtnSelectedblock){
        self.mainBtnSelectedblock();
    }
}
- (IBAction)showDeviceManagerController:(id)sender {
    if(self.deviceManagerBtnSelectedblock){
        self.deviceManagerBtnSelectedblock();
    }
}
- (IBAction)showUserManagerController:(id)sender {
    if(self.userManagerBtnSelectedBlock){
        self.userManagerBtnSelectedBlock();
    }
}

@end
