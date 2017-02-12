//
//  PhotosTableViewControllerWithCoreData.m
//  NetworkingFlickrDemo
//
//  Created by Alexey Bidnyk on 1/23/17.
//  Copyright © 2017 hillel. All rights reserved.
//


#import "PhotosTableViewControllerWithCoreData.h"
#import "PhotoTableViewCell.h"
#import <CoreData/CoreData.h>
#import "Photo+CoreDataClass.h"
#import "AppDelegate.h"
#import "WebService.h"
#import "FEMDeserializer.h"
#import <MagicalRecord/MagicalRecord.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PhotosTableViewControllerWithCoreData () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIRefreshControl *spinner;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation PhotosTableViewControllerWithCoreData

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestRecentPhotos];
    
    self.fetchedResultsController = [Photo MR_fetchAllSortedBy:@"photoID"
                                                     ascending:YES withPredicate:nil
                                                       groupBy:nil
                                                      delegate:self];
}

- (IBAction)requestRecentPhotosAction:(id)sender {
    [self requestRecentPhotos];
}
    
- (void)requestRecentPhotos {
    WebService *webService = [WebService sharedService];
    
    __weak typeof(self) weakSelf = self;
    [webService getRecentPhotosWithBlock:^(id object, NSError *error) {
        if (object) {
            NSArray *photos = [FEMDeserializer collectionFromRepresentation:object mapping:[Photo mapping] context:[NSManagedObjectContext MR_defaultContext]];
//            [Photo MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"NO SELF IN %@", photos]]
//                                       inContext:[NSManagedObjectContext MR_defaultContext]];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            [weakSelf.spinner endRefreshing];
            NSLog(@"Response: %@", object);
        }
    }];
}

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            PhotoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
        }
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoTableViewCell *cell = (PhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"photoCellID" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(PhotoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.photoTitleLabel.text = photo.title;
    
    NSString *URLString = photo.urlThumbnail;
    NSURL *URL = [NSURL URLWithString:URLString];
    [cell.thumbImageView sd_setImageWithURL:URL
                           placeholderImage:nil
                                    options:SDWebImageRefreshCached];
}

@end
