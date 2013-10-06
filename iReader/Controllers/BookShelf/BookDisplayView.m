//
//  BookDisplayView.m
//  iReader
//
//  Created by chenyu on 13-10-1.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "BookDisplayView.h"

@implementation BookDisplayView

- (id)init
{
    self = [super init];
    if (self) {
        egoImageView = [[EGOImageView alloc]init];
        self.freshControl = [[UIRefreshControl alloc]init];
        //[self addSubview:self.freshControl];
        
        self.frame = CGRectMake(20, 10, 72, 90);
        egoImageView.frame = self.frame;
        egoImageView.delegate = self;
        egoImageView.placeholderImage = [UIImage imageNamed:@"loading.png"];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
        tapGestureRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapGestureRecognizer];
        egoImageView.frame = CGRectMake(0, 0, 72, 90);
        [self addSubview:egoImageView];
    }
    return self;
}

- (void)doubleTapAction:(UITapGestureRecognizer*)recognizer 
{
    NSLog(@"doubleTapAction");
}

#pragma mark - 接口方法
- (BOOL)setImageViewUrl:(NSString *)url
{
    egoImageView.imageURL = [NSURL URLWithString:url];
    return YES;
}
- (BOOL)setImageViewPic:(UIImage *)image
{
    NSArray *subViews = [self subviews];
    for (UIView *view in subViews)
    {
        [view removeFromSuperview];
    }
    UIView *newView = [[UIImageView alloc]initWithImage:image];
    //CGRect rect = newView.frame;
    [self addSubview:newView];
    return YES;
}
- (BOOL)setLoadImageFinish:(LoadImageFinish)finishblock
{
    loadImageFinish = finishblock;
    return YES;
}
- (EGOImageView*)getEGOImageView
{
    return egoImageView;
}

#pragma mark - EGOImageViewDelegate

- (void)imageViewLoadedImage:(EGOImageView *)imageView
{
    loadImageFinish(imageView);
}
@end
