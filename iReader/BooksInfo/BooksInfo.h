//
//  BooksInfo.h
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "Entity.h"
#import "Config.h"


@interface BooksInfo : Entity
{
    @private
    NSString *bookKind;
    NSArray *bookArray;
    ControllerCode code;
}

- (BOOL)refresh :(ControllerCode)controllerCode;
- (BOOL)loadData;
- (BOOL)setBookdArray :(NSArray*)bookArray;
- (BOOL)setBookKind :(NSString*)parmBookKind;

- (NSString*)getBookKind;

- (NSArray*)getBooksArray;

@end
