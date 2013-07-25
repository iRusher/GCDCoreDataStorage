//
//  Message.h
//  ConcurrencyCoreData
//
//  Created by yonglang on 13-7-25.
//  Copyright (c) 2013年 iRusher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * loginuser;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * seqid;

@end
