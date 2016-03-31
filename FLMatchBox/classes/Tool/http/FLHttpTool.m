//
//  FLHttpTool.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/22.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLHttpTool.h"

#import <MBProgressHUD.h>

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>


@implementation FLHttpTool

+ (void)postWithUrlString:(NSString *)urlString param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:FLKeyWindow animated:YES];
        hud.labelText = @"请求失败";
        [hud show:YES];
        FLLog(@"%@",error);
        if (failure) {
            failure(error);
        }
        
        
    }];
    

}

+ (void)uploadWithImage:(UIImage *)image url:(NSString *)url filename:(NSString *)filename name:(NSString *)name  mimeType:(NSString *)mimeType params:(NSDictionary *)param progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    [manager POST:url  parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        
        [formData appendPartWithFileData:imageData name:name fileName:filename mimeType:mimeType];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];

}


@end
