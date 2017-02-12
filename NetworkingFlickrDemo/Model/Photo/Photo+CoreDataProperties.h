//
//  Photo+CoreDataProperties.h
//  NetworkingFlickrDemo
//
//  Created by Alexey Bidnyk on 1/23/17.
//  Copyright © 2017 hillel. All rights reserved.
//

#import "Photo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest;

@property (nonatomic) NSNumber *photoID;
@property (nullable, nonatomic, copy) NSString *owner;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *urlLarge;
@property (nullable, nonatomic, copy) NSString *urlThumbnail;

@end

NS_ASSUME_NONNULL_END
