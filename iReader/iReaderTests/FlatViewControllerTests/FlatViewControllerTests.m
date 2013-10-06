//
//  FlatViewControllerTests.m
//  iReader
//
//  Created by xyooyy on 13-10-6.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "FlatViewControllerTests.h"


@implementation FlatViewControllerTests

- (void)testFlatViewControllerHasANotification
{
    FlatViewController *flatViewController =[[FlatViewController alloc]init];
    id bookModel = [OCMockObject mockForClass:[BooksInfo class]];
    flatViewController.bookModel = bookModel;
    [[bookModel expect]requestData:[OCMArg any] :flatViewControllerCode];
    [flatViewController requestData:[OCMArg any]];
    [bookModel verify];
}
@end
