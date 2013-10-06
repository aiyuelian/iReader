//
//  iReaderManagerDelegate.h
//  iReader
//
//  Created by chenyu on 13-9-29.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@protocol iReadercommunicatorDelegate <NSObject>

@required
- (void)parseFinish :(NSMutableArray*)books;
- (void)parseCount :(int)count;
@optional
- (void)connectedError :(NSError*)error;
- (void)parseOne :(Book*)book;

@end
