//
//  WebService.h
//  NetworkingFlickrDemo
//
//  Created by hillel on 05.02.17.
//  Copyright © 2017 hillel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^CompletionBlock)(id object, NSError *error);

@interface WebService : AFHTTPSessionManager
    
+ (instancetype)sharedService;

@end

@interface WebService (Requests)

- (void)getRecentPhotosWithBlock:(CompletionBlock)block;
    
@end
