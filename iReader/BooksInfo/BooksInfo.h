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
}

- (BOOL)refresh;
- (BOOL)loadData;
- (NSArray*)getBooksArray;
- (BOOL)setBookdArray :(NSArray*)bookArray;
- (NSString*)getBookKind;
- (BOOL)setBookKind :(NSString*)parmBookKind;

@end
