//
//  ChatCoreDataStorage.m
//  ConcurrencyCoreData
//
//  Created by yonglang on 13-7-25.
//  Copyright (c) 2013年 iRusher. All rights reserved.
//

#import "ChatCoreDataStorage.h"
#import "Message.h"
#import <DDLog.h>

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@implementation ChatCoreDataStorage

-(void) handleMessageIncomming
{
    [self scheduleBlock:^{
       
        for (NSInteger i= 0; i<5; i++) {
            
            Message *message = [NSEntityDescription insertNewObjectForEntityForName:@"Message"
                                                             inManagedObjectContext:self.managedObjectContext];
            message.from = @"me";
            message.to = @"you";
            message.text = @"text";
            message.timestamp = [NSDate date];
            message.type = [NSNumber numberWithInt:0];
            message.loginuser = @"me";
            message.isRead = NO;
            message.seqid = [NSString stringWithFormat:@"%d-%d",arc4random()%100000,i];
        }
        
    }];
}

-(void) updateMessageReadFlag:(BOOL) readFlag withId:(NSString *) seqid
{
    [self scheduleBlock:^{
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seqid=%@ and loginuser=%@",seqid,@"me"];
        [fetchRequest setPredicate: predicate];
        
        NSError *error = nil;
        NSArray *fethedResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchRequest) {
            Message *msg = [fethedResult lastObject];
            
            msg.isRead = [NSNumber numberWithBool:YES];
        }
    }];
}


@end
