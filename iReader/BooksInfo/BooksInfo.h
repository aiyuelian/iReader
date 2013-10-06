//
//  BooksInfo.h
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
//#import "Entity.h"
#import "Communicator.h"
#import "Config.h"
#import "iReadercommunicatorDelegate.h"


//typedef enum
//{
//    flatViewControllerCode = 0,
//    bookShelfViewControllerCode,
//    
//}ControllerCode;
@interface BooksInfo : NSObject<iReadercommunicatorDelegate>
{
    @private
    NSString *bookKind;
    NSArray *bookArray;
   // ControllerCode code;
    Communicator *communicator;
}

@property (nonatomic,strong) NSString *currentController;
@property (nonatomic,strong) Communicator *communicator;

- (BOOL)refresh; //:(ControllerCode)controllerCode;
- (BOOL)loadData;
- (BOOL)setBookdArray :(NSArray*)bookArray;
- (BOOL)setBookKind :(NSString*)parmBookKind;

- (NSString*)getBookKind;

- (NSArray*)getBooksArray;

- (BOOL)request:(NSString *)bookKindName :(NSString*)controllerName;
- (void)test :(NSString *)bookKindName :(NSString*)controllerName;
- (void)createcommunicator :(NSString*)bookKindName;
@end
