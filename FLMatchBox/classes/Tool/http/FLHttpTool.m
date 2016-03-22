//
//  FLHttpTool.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/22.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLHttpTool.h"

#import <AFNetworking.h>


@implementation FLHttpTool

+ (void)postWithUrlString:(NSString *)urlString param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    
    
    
    [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        FLLog(@"%@",responseObject);
        
        if (success) {
            success(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        FLLog(@"%@",error);
        if (failure) {
            failure(error);
        }
        
        
    }];
    

}



@end
