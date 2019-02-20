//
//  RootModel.h
//  MacDemo
//
//  Created by liuqin on 2018/3/30.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RootModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic)BOOL isLeaf;
@property(nonatomic)int level;
@property(nonatomic,strong)NSMutableArray *children;
@property(nonatomic)BOOL selected;
-(instancetype)initWithName:(NSString *)name level:(int)level;
@end
