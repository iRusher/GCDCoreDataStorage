//
//  RSMessageListVC.m
//  ConcurrencyCoreData
//
//  Created by yonglang on 13-7-25.
//  Copyright (c) 2013年 iRusher. All rights reserved.
//


#import "RSMessageListVC.h"
#import "ChatCoreDataStorage.h"
#import <CoreData/CoreData.h>
#import <DDLog.h>
#import "Message.h"
#import "RSMessageCell.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface RSMessageListVC () <NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) ChatCoreDataStorage *chatStorage;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultController;

@end

@implementation RSMessageListVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.chatStorage = [[ChatCoreDataStorage alloc]init];
    
    dispatch_queue_t loadDataQueue = dispatch_queue_create("laodData", NULL);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_after(popTime, loadDataQueue, ^(void){
        
        [self.chatStorage handleMessageIncomming];
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
	
    if ([[self.fetchedResultController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Message *msg = [self.fetchedResultController objectAtIndexPath:indexPath];
    cell.message = msg;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *msg = [self.fetchedResultController objectAtIndexPath:indexPath];
    [self.chatStorage updateMessageReadFlag:YES withId:msg.seqid];
    
    //如果你直接这样更新的化，会发生什么？！
//    msg.isRead = [NSNumber numberWithBool:YES];
}

#pragma mark - NSFetchedResultsController

-(NSFetchedResultsController*) fetchedResultController
{
    if (!_fetchedResultController) {
        
        NSManagedObjectContext *context = [self.chatStorage mainThreadManagedObjectContext];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
 
        _fetchedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
        _fetchedResultController.delegate = self;
        NSError *error;
        if (![_fetchedResultController performFetch:&error]) {
            DDLogVerbose(@"error. %@",[error userInfo]);
        }
        
    }
    return _fetchedResultController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView reloadData];
}


@end
