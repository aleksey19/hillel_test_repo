//
//  Photo+CoreDataClass.h
//  NetworkingFlickrDemo
//
//  Created by Alexey Bidnyk on 1/23/17.
//  Copyright © 2017 hillel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <FEMMapping.h>

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSManagedObject

@end

NS_ASSUME_NONNULL_END

@interface Photo (Mapping)

+ (FEMMapping  * _Nonnull)mapping;
    
@end

#import "Photo+CoreDataProperties.h"
