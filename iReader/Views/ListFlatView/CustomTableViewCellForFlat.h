//
//  CustomTableViewCellForFlat.h
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "BlockDef.h"

@interface CustomTableViewCellForFlat : UITableViewCell<EGOImageViewDelegate>

{
    @private
    UILabel *title;
    UILabel *author;
    EGOImageView *imageView;
    LoadImageFinish loadFinish;
}

@property(nonatomic,weak) id<EGOImageViewDelegate> delegate;


- (EGOImageView*)getImageView;
- (BOOL)setImageViewUrl :(NSString*)url;
- (BOOL)setTitleText :(NSString*)text;
- (BOOL)setAuthorText :(NSArray*)authorArray;
- (BOOL)setTitleFrame :(CGRect)frame;
- (BOOL)setAuthorFrame :(CGRect)frame;

- (BOOL)setImageLoad :(LoadImageFinish)loadFinishBlock;

- (LoadImageFinish)getImageLoadFinishBlock;

@end
