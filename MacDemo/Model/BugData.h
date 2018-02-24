//
//  BugData.h
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BugData : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)float rating;

-(instancetype)initWithTitle:(NSString *)title rating:(float)rating;
@end
