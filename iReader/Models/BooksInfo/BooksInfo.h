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
{
    @private
    NSString *bookKind;
    NSArray *bookArray;
    Communicator *communicator;
}

@property (nonatomic,strong) NSString *currentController;
@property (nonatomic,strong) Communicator *communicator;

- (BOOL)refresh;
- (BOOL)setBookdArray :(NSArray*)bookArray;
- (BOOL)setBookKind :(NSString*)parmBookKind;
- (BOOL)request:(NSString*)controllerName;

- (NSString*)getBookKind;

- (NSArray*)getBooksArray;

@end
