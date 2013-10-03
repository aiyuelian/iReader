//
//  BookShelfViewController.h
//  iReader
//
//  Created by chenyu on 13-10-1.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookShelfView.h"
#import "BookDisplayView.h"
#import "Config.h"
#import "Book.h"
#import "BlockDef.h"



@interface BookShelfViewController : UIViewController
{
    @private
    BookShelfView *bookShelfView;
    NSArray *books;
    NSString *bookKind;
    NSString *refash;
   // RightButtonPressed rightButtonPressed;
    
   
}

- (BOOL)setRightButtonPressedAction :(RightButtonPressed)action;
- (id)initWithArray :(NSArray*)parmBooks;
- (BOOL)setBookKind :(NSString*)parmBookKind;

@end
