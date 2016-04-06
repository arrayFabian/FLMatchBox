//
//  FLAddressCellModel.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/31.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLAddressCellModel.h"
#import <MJExtension.h>
@implementation FLAddressCellModel

MJExtensionCodingImplementation
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
    
}
- (void)setNilValueForKey:(NSString *)key
{
    _name = @"";
}


- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    if (_userName.length<1) {
        _aleph = @"#";
        return;
    }
    _aleph = [self changeEnglish:_userName];
    
 
}

- (NSString *)changeEnglish:(NSString *)base
{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:base];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        NSLog(@"Pingying: %@",ms);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        NSLog(@"Pingying: %@", [[ms uppercaseString] substringToIndex:1]);
    }
    
    return [[ms uppercaseString] substringToIndex:1];
    
    
    
}

- (void)setUrl:(NSString *)url
{
    url = [url stringByReplacingOccurrencesOfString:@"//head" withString:@"/head"];
    _url = url;
}

@end

