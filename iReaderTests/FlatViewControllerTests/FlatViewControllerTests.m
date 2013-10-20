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
    id bookModel = [OCMockObject mockForClass:[BooksInfo class]];
    FlatViewController *flatViewController =[[FlatViewController alloc]initWithModel:bookModel];
    [[bookModel expect] request:[OCMArg any]];
    [flatViewController requestData];
    [bookModel verify];
}

- (void)test_Communicator_start_Methond_Called_When_Model_Request_Methond_Called
{
    BooksInfo *model = [[BooksInfo alloc]init];
    [model setBookKind:@"compoter"];
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
    //id observerMock = [OCMockObject mockForClass:[FlatViewController class]];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:kflatViewRefreshNotifiCationName object:nil];
    
    [[observerMock expect] notificationWithName:kflatViewRefreshNotifiCationName object:[OCMArg any]];
    [delegate parseFinish:[OCMArg any]];
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    [observerMock verify];
}

- (void)test_Model_Refresh_With_Specify_Parm_Called_When_Pull_Down
{
    id model = [OCMockObject mockForClass:[BooksInfo class]];
    [[model expect] refresh:kFlatViewControllerName];
    FlatViewController *controller = [[FlatViewController alloc]initWithModel:model];
   
    [controller.m_flatListView.pullDelegate pullTableViewDidTriggerRefresh:[OCMArg any]];
    [model verify];
}
- (void)test_Model_Called_bookArray_Called_When_Pull_Up
{
    id model = [OCMockObject mockForClass:[BooksInfo class]];
    [[model expect] bookArray];
    FlatViewController *controller = [[FlatViewController alloc]initWithModel:model];
    
    [controller.m_flatListView.pullDelegate pullTableViewDidTriggerLoadMore:[OCMArg any]];
    [model verify];
}
- (void)test_if_Not_Set_Request_BookKind_Controller_request_Methond_Should_return_NO
{
    FlatViewController *controller = [[FlatViewController alloc]init];
    GHAssertFalse([controller requestData], @"because not set bookkind,so requestData should return NO");
}
- (void)test_controller_will_requestData_if_model_has_bookkind_and_no_books
{
    id model = [OCMockObject mockForClass:[BooksInfo class]];
    [[[model stub]andReturn:@"computer"] bookKind];
    [[[model stub]andReturn:nil] bookArray];
    [[model expect] request:[OCMArg any]];
    FlatViewController *controller = [[FlatViewController alloc]initWithModel:model];
    [controller viewWillAppear:NO];
    [model verify];
}
- (void)test_controller_will_not_requestData_if_model_has_bookkind_and_books
{
    id model = [OCMockObject mockForClass:[BooksInfo class]];
    [[[model stub]andReturn:@"computer"] bookKind];
    NSMutableArray *books = [[NSMutableArray alloc]init];
    for (int i = 0; i != 12; i++) {
        Book *book = [[Book alloc]init];
        [books addObject:book];
    }
    [[[model stub]andReturn:books] bookArray];
    FlatViewController *controller = [[FlatViewController alloc]initWithModel:model];
    [controller viewWillAppear:NO];
    GHAssertNotNil(controller.displayBooks, @"when model has some books,controller should not requestData,and display books direct");
}

- (void)test_when_refresh_breakPoint_resetToZero
{
    id delegate = [OCMockObject mockForProtocol:@protocol(iReadercommunicatorDelegate)];
    [[[delegate stub]andPost:[NSNotification notificationWithName:kflatViewRefreshNotifiCationName object:nil]] parseFinish:[OCMArg any]];
    FlatViewController *controller = [[FlatViewController alloc]init];
    controller.breakPoint = 1;
    [delegate parseFinish:[OCMArg any]];
    [[NSNotificationCenter defaultCenter] removeObserver:controller];
    GHAssertEquals(controller.breakPoint, 0, @"controller.breakPoint should equal 0");
    
}

@end
