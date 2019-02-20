//
//  LeafModel.m
//  MacDemo
//
//  Created by liuqin on 2018/3/30.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "LeafModel.h"

@implementation LeafModel
-(instancetype)initWithId:(NSString *)strId name:(NSString *)name   level:(int)level{
    if(self = [super init]){
        self.strId = strId;
        self.name = name;
        self.level = level;
    }
    return self;
}
@end
