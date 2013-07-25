//
//  ChatCoreDataStorage.h
//  ConcurrencyCoreData
//
//  Created by yonglang on 13-7-25.
//  Copyright (c) 2013年 iRusher. All rights reserved.
//

#import "GCDCoreDataStorage.h"
#import "GCDCoreDataStorageProtected.h"

@interface ChatCoreDataStorage : GCDCoreDataStorage 

-(void) handleMessageIncomming ;

-(void) updateMessageReadFlag:(BOOL) readFlag withId:(NSString *) seqid;

@end
