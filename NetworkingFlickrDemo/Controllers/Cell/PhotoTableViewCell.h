//
//  PhotoTableViewCell.h
//  NetworkingFlickrDemo
//
//  Created by hillel on 18.01.17.
//  Copyright © 2017 hillel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *photoTitleLabel;
@end
