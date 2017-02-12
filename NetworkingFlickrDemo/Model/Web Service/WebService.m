//
//  WebService.m
//  NetworkingFlickrDemo
//
//  Created by hillel on 05.02.17.
//  Copyright © 2017 hillel. All rights reserved.
//

#import "WebService.h"

#define FlickrAPIKey @"70ad5fbf9b69b2ad37db84dc02e83e3a"

@implementation WebService

+ (instancetype)sharedService {
    static dispatch_once_t onceToken;
    static WebService *sharedService = nil;
    dispatch_once(&onceToken, ^{
        sharedService = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.flickr.com/services/rest/"]];
    });
    return sharedService;
}
    
@end

@implementation WebService (Requests)

- (void)getRecentPhotosWithBlock:(CompletionBlock)block {
    NSDictionary *params = @{
                             @"method" : @"flickr.photos.getRecent",
                             @"api_key" : FlickrAPIKey,
                             @"format" : @"json",
                             @"nojsoncallback" : @(1),
                             @"extras" : @"url_t, url_l",
                             @"per_page" : @(10)
                             };
    [self GET:@""
   parameters:params
     progress:^(NSProgress * _Nonnull downloadProgress) {
    }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            block(responseObject, nil);
        }
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if (error) {
              block(nil, error);
          }
    }];
}

@end
