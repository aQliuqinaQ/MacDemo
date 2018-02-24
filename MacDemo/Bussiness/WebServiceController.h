//
//  WebServiceController.h
//  MacDemo
//
//  Created by liuqin on 2018/1/23.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceController : NSObject
+ (WebServiceController *) getInstance;
//获取公共视界列表
-(NSURLSessionDataTask *)getSharePublicListWithPageNum:(int)pageNum requestNum:(int)requestNum typeId:(NSString *)typeId Suc:(void (^)(NSArray *result))suc Failure:(void (^)(int error))failure;
@end
