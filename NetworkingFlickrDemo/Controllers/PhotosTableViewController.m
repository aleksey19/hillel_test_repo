//
//  PhotosTableViewController.m
//  NetworkingFlickrDemo
//
//  Created by hillel on 15.01.17.
//  Copyright © 2017 hillel. All rights reserved.
//

#define FlickrAPIKey @"70ad5fbf9b69b2ad37db84dc02e83e3a"

#import "PhotosTableViewController.h"
#import "PhotoTableViewCell.h"
#import "Photo+CoreDataClass.h"

dispatch_queue_t serialQueue;
dispatch_queue_t concurrentQueue;

@interface PhotosTableViewController ()

@property (weak, nonatomic) IBOutlet UIRefreshControl *spinner;
@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.operationQueue = [NSOperationQueue new];
    
    [self requestRecentPhotosAction:nil];
}

- (IBAction)requestRecentPhotosAction:(id)sender {
//    [self requestRecentPhotos];
}

//- (void)requestRecentPhotos {
//    NSString *method = @"flickr.photos.getRecent";
//    NSString *format = @"json";
//    NSString *extras = @"url_t";
//    NSUInteger jsonCallback = 1;
//    
//    NSString *URLString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=%@&api_key=%@&format=%@&nojsoncallback=%@&extras=%@", method, FlickrAPIKey, format, @(jsonCallback), extras];
//    NSURL *URL = [NSURL URLWithString:URLString];
//    
//    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
//    __weak typeof(self) weakSelf = self;
//    [self.spinner beginRefreshing];
//    NSURLSessionDataTask *task = [defaultSession dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (!error) {
//            NSError *parseError = nil;
//            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
//            NSArray *photos = [jsonDictionary valueForKeyPath:@"photos.photo"];
//            for (NSDictionary *photoDictionary in photos) {
//                [Photo savePhotoWithDictionary:photoDictionary];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.photosArray = [NSArray arrayWithArray:photos];
//                [weakSelf.tableView reloadData];
//                [weakSelf.spinner endRefreshing];
//            });
//        }
//    }];
//    [task resume];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoTableViewCell *cell = (PhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"photoCellID" forIndexPath:indexPath];
    id object = self.photosArray[indexPath.row];
    cell.photoTitleLabel.text = [object valueForKey:@"title"];
    
    NSString *URLString = [object valueForKey:@"url_t"];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    // SERIAL QUEUE
//    dispatch_async(serialQueue, ^{
//        NSData *data = [NSData dataWithContentsOfURL:URL];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            cell.thumbImageView.image = [UIImage imageWithData:data];
//        });
//    });
    
    // CONCURRENT QUEUE
//    dispatch_async(concurrentQueue, ^{
//        NSData *data = [NSData dataWithContentsOfURL:URL];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            cell.thumbImageView.image = [UIImage imageWithData:data];
//        });
//    });

    // OPERATION QUEUE
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:URL];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.thumbImageView.image = [UIImage imageWithData:data];
        }];
    }];
    [blockOperation setCompletionBlock:^{
        NSLog(@"Loaded image for row №%@", @(indexPath.row));
    }];
    [self.operationQueue addOperation:blockOperation];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
