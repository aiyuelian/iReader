//
//  iReaderManager.h
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "Communicator.h"
#import "iReadercommunicatorDelegate.h"
#import "FlatViewController.h"
#import "Config.h"
#import "BookShelfViewController.h"

typedef enum
{
    FlatViewCode,
    BookViewCode,
}DisplayViewCode;

@interface iReaderManager : NSObject<iReadercommunicatorDelegate>
{
    @private
    NSMutableArray *books;
    NSMutableData *mRecieve;
    
    FlatViewController *flatViewController;
    BookShelfViewController  *bookShelfViewController;
    Communicator *commmunicator;
    
    NSString *currentBookKind;
    
    NSInteger lastSenment;
}

@property(nonatomic,strong) UIViewController *currentDisplayController;

- (BOOL)startRequestData :(NSString*)methond :(NSString*)url :(BOOL)isCheckLocal;
- (BOOL)setDisplayView :(DisplayViewCode)code;

@end
