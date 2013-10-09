//
//  BookDisplayView.h
//  iReader
//
//  Created by chenyu on 13-10-1.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "BlockDef.h"

@interface BookDisplayView : UIView<EGOImageViewDelegate>
{
    @private
    EGOImageView *egoImageView;
    LoadImageFinish loadImageFinish;
    ;
}

@property(nonatomic,strong) UIRefreshControl *freshControl;

- (BOOL)setImageViewUrl :(NSString*)url;
- (BOOL)setImageViewPic :(UIImage*)image;
- (BOOL)setLoadImageFinish :(LoadImageFinish)finishblock;
- (EGOImageView*)getEGOImageView;
@end