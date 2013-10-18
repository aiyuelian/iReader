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
}
- (BOOL)setImageViewUrl :(NSString*)url :(LoadImageFinish)finishblock;
- (BOOL)setImageViewPic :(UIImage*)image;
- (EGOImageView*)getEGOImageView;
@end
