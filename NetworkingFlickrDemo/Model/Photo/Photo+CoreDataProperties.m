//
//  Photo+CoreDataProperties.m
//  NetworkingFlickrDemo
//
//  Created by Alexey Bidnyk on 1/23/17.
//  Copyright © 2017 hillel. All rights reserved.
//

#import "Photo+CoreDataProperties.h"

@implementation Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
}

@dynamic photoID;
@dynamic owner;
@dynamic title;
@dynamic urlLarge;
@dynamic urlThumbnail;

@end
