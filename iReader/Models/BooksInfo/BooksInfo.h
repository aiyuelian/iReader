//
//  BooksInfo.h
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "Communicator.h"
#import "Config.h"
#import "iReadercommunicatorDelegate.h"

@interface BooksInfo : NSObject<iReadercommunicatorDelegate>

@property (nonatomic,strong) NSString *bookKind;
@property (nonatomic,strong) NSArray *bookArray;
//@property (nonatomic,strong) NSString *currentController;
@property (nonatomic,strong) Communicator *communicator;

- (BOOL)refresh;
- (BOOL)requestData;
@end
