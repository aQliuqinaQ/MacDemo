//
//  WebServiceController.m
//  MacDemo
//
//  Created by liuqin on 2018/1/23.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "WebServiceController.h"
#import "TDNetworkHelper.h"
#import "Public.h"
@implementation WebServiceController
static WebServiceController *instance = nil;
+ (WebServiceController *) getInstance {
    if (instance == nil)
    {
        instance = [[WebServiceController alloc] init];
    }
    
    return (instance);
}
#pragma mark 自己调用
/**
 *  json转字符串
 */
- (NSString *)jsonToString:(NSDictionary *)dic
{
    if(!dic){
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 *  json转数组
 */
- (NSArray *)jsonToArray:(NSDictionary *)dic
{
    if(!dic){
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    return dataArr;
}
/**
 *  json转字典
 */
- (NSDictionary *)jsonToDictionary:(NSDictionary *)dic
{
    if(!dic){
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    return dataDic;
}
//获取公共视界列表
-(NSURLSessionDataTask *)getSharePublicListWithPageNum:(int)pageNum requestNum:(int)requestNum typeId:(NSString *)typeId Suc:(void (^)(NSArray *result))suc Failure:(void (^)(int error))failure{
    NSDictionary * param = @{@"index":@(pageNum),@"limit":@(requestNum),@"typeId":typeId};
    NSURLSessionDataTask *task = [TDNetworkHelper GET:[NSString stringWithFormat:@"%@%@",@"http://p2pcloud.myviewcloud.com:7000/",@"wsp2p/rest/public/getShareHostsLimit"] parameters:param needCache:NO success:^(id responseObject) {
        NSDictionary *dataDic = [self jsonToDictionary:responseObject];
//        NSLog(@"getSharePublicList JSON: %@"  dataDic);
        if (dataDic) {
            if([dataDic[@"ret"] intValue] == 0){
                NSArray *resultArr = dataDic[@"content"][@"channels"];
                NSMutableArray *publicArr = [[NSMutableArray alloc] init];
                for(NSDictionary * dic in resultArr){
                    Public *public = [[Public alloc] init];
                    public.strId = dic[@"id"];
                    public.hostId = dic[@"hostId"];
                    public.channelNum = [dic[@"channelNum"] intValue];
                    public.userName = dic[@"username"];
//                    NSData *EncryptData1 = [GTMBase64 decodeString:dic[@"password"]];//解密前进行GTMBase64编码
//                    public.password = [SecurityUtil decryptAESData:EncryptData1 app_key:Security_key];
                    public.shareName = dic[@"shareName"];
                    public.imageUrl = dic[@"imgUrl"];
                    [publicArr addObject:public];
                }
                if(suc){
                    suc(publicArr);
                }
            } else {
                if (failure) {
                    failure(-1);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure((int)error.code);
        }
        NSLog(@"error: %@", @"getSharePublicList 接口调用失败");
    }];
    return task;
}
@end
