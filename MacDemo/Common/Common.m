//
//  Common.m
//  EasyLive
//
//  Created by liuqin on 16/8/25.
//  Copyright © 2016年 tiandy. All rights reserved.
//

#import "Common.h"
#import "FMDB.h"
#import "Host.h"
@implementation Common
static Common *instance = nil;

+ (Common *) getInstance {
    if (instance == nil)
    {
        instance = [[Common alloc] init];
    }
    
    return (instance);
}
-(int)addDeviceWithDeviceName:(NSString *)deviceName ip:(NSString *)ip domain:(NSString *)domain port:(int)port domainName:(NSString *)domainName username:(NSString *)username password:(NSString *)passowrd  connType:(int)connType{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select s_id from device_host where s_caption = '%@'",deviceName];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            return ERR_CAPTION_EXSIT;
        }
        if(![ip isEqualToString:@""]){
            sql = [NSString stringWithFormat:@"select s_id from device_host where s_ip_address = '%@'",ip];
            rs = [db executeQuery:sql];
            while ([rs next]) {
                return ERR_DEVICE_ADDRESS_EXSIT;
            }
        }
        if(![domain isEqualToString:@""]){
            sql = [NSString stringWithFormat:@"select s_id from device_host where s_domain_address = '%@'",domain];
            rs = [db executeQuery:sql];
            while ([rs next]) {
                return ERR_DEVICE_DOMAIN_EXSIT;
            }
        }
        if(![domainName isEqualToString:@""]){
            sql = [NSString stringWithFormat:@"select s_id from device_host where s_domain_name = '%@'",domainName];
            rs = [db executeQuery:sql];
            while ([rs next]) {
                return ERR_DEVICE_DOMAIN_NAME_EXSIT;
            }
        }
        
      sql = [NSString stringWithFormat:@"INSERT INTO device_host(S_ID,S_CAPTION,S_IP_ADDRESS,S_DOMAIN_ADDRESS,S_PORT,S_DOMAIN_NAME,S_USERNAME,S_PASSWORD,S_CONN_TYPE) VALUES('%@','%@','%@','%@',%d, '%@','%@', '%@',%d)",[[NSUUID UUID] UUIDString],deviceName,ip,domain,port,domainName,username,passowrd,connType];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to insert data::%@",db.lastErrorMessage);
            return ERR_DB_ERROR;
        } else {
            NSLog(@"succ to insert data");
        }
        [db close];
         return DB_SUCCESS;
    } else {
        NSLog (@"error when open db");
        return ERR_DB_ERROR;
    }
}
-(int)updateDeviceWithDeviceId:(NSString *)deviceId deviceName:(NSString *)deviceName ip:(NSString *)ip domain:(NSString *)domain port:(int)port domainName:(NSString *)domainName username:(NSString *)username password:(NSString *)passowrd{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select s_id from device_host where s_id = '%@'",deviceId];
        FMResultSet * rs = [db executeQuery:sql];
        while (![rs next]) {
            return ERR_HOST_NOT_EXSIT;
        }
        sql = [NSString stringWithFormat:@"select s_id from device_host where s_caption = '%@' and s_id != '%@'",deviceName,deviceId];
        rs = [db executeQuery:sql];
        while ([rs next]) {
            return ERR_CAPTION_EXSIT;
        }
        if(![ip isEqualToString:@""]){
            sql = [NSString stringWithFormat:@"select s_id from device_host where s_ip_address = '%@' and s_id != '%@'",ip,deviceId];
            rs = [db executeQuery:sql];
            while ([rs next]) {
                return ERR_DEVICE_ADDRESS_EXSIT;
            }
        }
        if(![domain isEqualToString:@""]){
            sql = [NSString stringWithFormat:@"select s_id from device_host where s_domain_address = '%@' and s_id != '%@'",domain,deviceId];
            rs = [db executeQuery:sql];
            while ([rs next]) {
                return ERR_DEVICE_DOMAIN_EXSIT;
            }
        }
        if(![domainName isEqualToString:@""]){
            sql = [NSString stringWithFormat:@"select s_id from device_host where s_domain_name = '%@' and s_id != '%@'",domainName,deviceId];
            rs = [db executeQuery:sql];
            while ([rs next]) {
                return ERR_DEVICE_DOMAIN_NAME_EXSIT;
            }
        }
        
        sql = [NSString stringWithFormat:@"update  device_host set S_CAPTION = '%@' , S_IP_ADDRESS = '%@' , S_DOMAIN_ADDRESS = '%@' , S_PORT = %d , S_DOMAIN_NAME = '%@' , S_USERNAME = '%@' , S_PASSWORD = '%@' WHERE S_ID = '%@'",deviceName,ip,domain,port,domainName,username,passowrd,deviceId];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to update data::%@",db.lastErrorMessage);
            return ERR_DB_ERROR;
        } else {
            NSLog(@"succ to update data");
        }
        [db close];
        return DB_SUCCESS;
    } else {
        NSLog (@"error when open db");
        return ERR_DB_ERROR;
    }
}
-(NSMutableArray *)getAllDevice{
    NSMutableArray * resultArr = [[NSMutableArray alloc] init];
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet * rs = [db executeQuery:@"select * from device_host"];
        while ([rs next]) {
            Host * host = [[Host alloc] init];
            for(int i = 0;i< [rs columnCount];i++ ){
                if(![[rs objectForColumnIndex:i] isKindOfClass:[NSNull class]]){
                    if(i == 0){
                        host.strId = [rs objectForColumnIndex:i];
                    }else if(i == 1){
                        host.strCaption = [rs objectForColumnIndex:i];
                    }else if(i == 2){
                        host.strIPAddress = [rs objectForColumnIndex:i];
                    }else if(i == 3){
                        host.strDomainAddress = [rs objectForColumnIndex:i];
                    }else if(i == 4){
                        host.iPort = [[rs objectForColumnIndex:i] intValue];
                    }else if(i == 5){
                        host.strDomainName = [rs objectForColumnIndex:i];
                    }else if(i == 7){
                        host.strUsername = [rs objectForColumnIndex:i];
                    }else if(i == 8){
                        host.strPassword = [rs objectForColumnIndex:i];
                    }else if(i == 9){
                        host.iConnType = [[rs objectForColumnIndex:i] intValue];
                    }else if(i == 10){
                        host.isOnline = [[rs objectForColumnIndex:i] intValue];
                    }
                
                }
            }
            if (host!=nil) {
                [resultArr addObject:host];
            }
            
        }
        [db close];
    } else {
        NSLog (@"error when open db");
    }
    return resultArr;
}
-(BOOL)deleteDeviceById:(NSString *)deviceId{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from device_host where S_ID = '%@'",deviceId];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to delete db data");
            [db close];
            return NO;
        } else {
            NSLog(@"succ to delete db data");
            [db close];
            return YES;
        }
    } else {
        NSLog (@"error when open db");
        return NO;
    }
}
@end
