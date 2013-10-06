//
//  FlatViewControllerTests.m
//  iReader
//
//  Created by xyooyy on 13-10-6.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "FlatViewControllerTests.h"


@implementation FlatViewControllerTests

- (void)test_Model_Request_Methond_Called_When_Controller_RequestData_Methond_Called
{
    FlatViewController *flatViewController =[[FlatViewController alloc]init];
    id bookModel = [OCMockObject mockForClass:[BooksInfo class]];
    [[bookModel stub]createcommunicator:[OCMArg any]];
    flatViewController.bookModel = bookModel;
    [[bookModel expect] request:[OCMArg any] :[OCMArg any]];
    [flatViewController requestData:[OCMArg any]];
    [bookModel verify];
}

- (void)test_ModelPropertyCommunicator_start_Methond_Called_When_Model_Request_Methond_Called
{
    BooksInfo *model = [[BooksInfo alloc]init];
    id communicator = [OCMockObject mockForClass:[Communicator class]];
    model.communicator = communicator;
    [[communicator expect]start:NO];
    [model request :[OCMArg any] :[OCMArg any]];
    [communicator verify];
}

- (void)test_ASIHTTPRequest_startAsynchronous_Methond_Call_When_Communicator_start_Called
{
    Communicator *communicator = [[Communicator alloc]init];
    id asiRequest = [OCMockObject mockForClass:[ASIHTTPRequest class]];
    [[asiRequest stub]setDelegate:[OCMArg any]];
    [[asiRequest stub]setURL:[OCMArg any]];
    [[asiRequest expect]startAsynchronous];
    [[asiRequest stub]initWithURL:[OCMArg any]];
    communicator.request = asiRequest;
    [communicator start:NO];
}


@end
