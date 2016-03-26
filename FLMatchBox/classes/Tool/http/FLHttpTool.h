//
//  FLHttpTool.h
//  FLMatchBox
//
//  Created by asddfg on 16/3/22.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLHttpTool : NSObject


+ (void)postWithUrlString:(NSString *)urlString param:(NSDictionary *)param success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;


+ (void)uploadWithImage:(UIImage *)image
                    url:(NSString *)url
               filename:(NSString *)filename
                   name:(NSString *)name
               mimeType:(NSString *)mimeType
                 params:(NSDictionary *)param
               progress:(void(^)(NSProgress *uploadProgress))progress
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

@end
