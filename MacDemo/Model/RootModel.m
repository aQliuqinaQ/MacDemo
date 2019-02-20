//
//  RootModel.m
//  MacDemo
//
//  Created by liuqin on 2018/3/30.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "RootModel.h"

@implementation RootModel
-(instancetype)initWithName:(NSString *)name level:(int)level{
    if(self = [super init]){
        self.name = name;
        self.level = level;
    }
    return self;
}
@end
