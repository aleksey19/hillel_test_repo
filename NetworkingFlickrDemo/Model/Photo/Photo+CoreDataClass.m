//
//  Photo+CoreDataClass.m
//  NetworkingFlickrDemo
//
//  Created by Alexey Bidnyk on 1/23/17.
//  Copyright © 2017 hillel. All rights reserved.
//

#import "Photo+CoreDataClass.h"
#import <UIKit/UIKit.h>

@implementation Photo

@end

@implementation Photo (Mapping)

+ (FEMMapping *)mapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Photo"];
    [mapping setRootPath:@"photos.photo"];
//    [mapping setPrimaryKey:@"photoID"];
    
    FEMAttribute *photoIDAttribute = [FEMAttribute mappingOfProperty:@"photoID" map:^id _Nullable(id  _Nullable value) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            return @([[value objectForKey:@"id"] integerValue]);
        }
        return value;
    }];
    [mapping addAttribute:photoIDAttribute];
    
    [mapping addAttributesFromDictionary:@{                                           
                                           @"ownerName" : @"owner",
                                           @"title" : @"title",
                                           @"urlLarge" : @"url_l",
                                           @"urlThumbnail" : @"url_t"                                           }];
    
    return mapping;
}

@end
