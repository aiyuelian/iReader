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

- (void)parseCount :(int)count;
- (void)connectedError :(NSError*)error;
- (void)parseOne :(Book*)book;
- (void)parseFinish :(NSMutableArray*)books;
@end
