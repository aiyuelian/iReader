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
    //[[bookModel stub]createcommunicator:[O];
    flatViewController.bookModel = bookModel;
    [[bookModel expect] request:[OCMArg any]];
    [flatViewController requestData];
    [bookModel verify];
}

- (void)test_Communicator_start_Methond_Called_When_Model_Request_Methond_Called
{
    BooksInfo *model = [[BooksInfo alloc]init];
    id communicator = [OCMockObject mockForClass:[Communicator class]];
    model.communicator = communicator;
    [[communicator stub]setURL:[OCMArg any]];
    [[communicator expect]start:YES];
    [model request :[OCMArg any]];
    [communicator verify];
}

- (void)test_ASIHttpRequest_startAsynchronous_Methond_Called_When_Communicator_start_Called
{
    Communicator *communicator = [[Communicator alloc]init];
    id asiRequest = [OCMockObject mockForClass:[ASIHTTPRequest class]];
    [[asiRequest stub]setDelegate:[OCMArg any]];
    [[asiRequest stub]setURL:[OCMArg any]];
    [[asiRequest expect]startAsynchronous];
    communicator.request = asiRequest;
    [communicator start:NO];
}

- (void)test_RequestData_Posted_To_Model
{
    Communicator *communicator = [[Communicator alloc]init];
    id delegate = [OCMockObject mockForProtocol:@protocol(iReadercommunicatorDelegate)];
    [[delegate stub]parseCount:0];
    [[delegate expect]parseFinish:[OCMArg any]];
    
    communicator.delegate = delegate;
    [communicator setURL:[OCMArg any]];
    [communicator.request.delegate requestFinished:[OCMArg any]];
    [delegate verify];
}

- (void)test_FlatViewController_Receive_Model_Change_Notification
{
    id delegate = [OCMockObject mockForProtocol:@protocol(iReadercommunicatorDelegate)];
    [[[delegate stub]andPost:[NSNotification notificationWithName:kflatViewRefreshNotifiCationName object:nil]] parseFinish:[OCMArg any]];
    id observerMock  = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:kflatViewRefreshNotifiCationName object:nil];
    
    [[observerMock expect] notificationWithName:kflatViewRefreshNotifiCationName object:[OCMArg any]];
    [delegate parseFinish:[OCMArg any]];
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    [observerMock verify];
}

- (void)test_Refresh_Called_When_Pull_Down
{
    id flatViewController = [OCMockObject mockForClass:[FlatViewController class]];
  
    [[flatViewController expect]refreshData];
    PullTableView *tableView = [[PullTableView alloc]init];
    tableView.pullDelegate = flatViewController;
    [tableView.pullDelegate pullTableViewDidTriggerRefresh:[OCMArg any]];
    [flatViewController verify];
    
}
@end
