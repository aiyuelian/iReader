//
//  CustomTableViewCellForFlat.m
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "CustomTableViewCellForFlat.h"

@implementation CustomTableViewCellForFlat

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        title = [[UILabel alloc]initWithFrame:CGRectMake(200, 20, 60, 40)];
        title.textColor = [UIColor blackColor];
        //title.backgroundColor = [UIColor greenColor];
        author = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 60, 40)];
        imageView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"loading.png"]];
        imageView.delegate = self;
         imageView.frame = CGRectMake(10, 10, 80, 100);
        [self.contentView addSubview:imageView];
        //self.imageView.image = imageView.image;
        [self addSubview:title];
        [self addSubview:author];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 公有方法
- (LoadImageFinish)getImageLoadFinishBlock
{
    return loadFinish;
}
- (BOOL)setAuthorText :(NSArray*)authorArray
{
    author.text = @"作者:";
    for (int i = 0; i != [authorArray count]; ++i)
    {
        author.text = [author.text stringByAppendingString:[authorArray objectAtIndex:i]];
        break;
        //author.text = [author.text stringByAppendingString:@"\n"];
    }
    return YES;
}
- (BOOL)setTitleText:(NSString *)text
{
    title.text = @"书名:";
    title.text = [title.text stringByAppendingString:text];
    return YES;
}

- (BOOL)setAuthorFrame:(CGRect)frame
{
    [author removeFromSuperview];
    author.frame = frame;
    [self addSubview:author];
    return YES;
}
- (BOOL)setTitleFrame:(CGRect)frame
{
    [title removeFromSuperview];
    title.frame = frame;
    [self addSubview:title];
    return YES;
}
- (BOOL)setImageViewUrl:(NSString *)url
{
    imageView.imageURL = [NSURL URLWithString:url];
   
    return YES;
}
- (BOOL)setImageLoad:(LoadImageFinish)loadFinishBlock
{
    loadFinish = loadFinishBlock;
    return YES;
}

- (EGOImageView*)getImageView
{
    return imageView;
}

#pragma mark - EGOImageViewDelegate

- (void)imageViewLoadedImage:(EGOImageView *)parmimageView
{
    loadFinish(parmimageView);
}
@end
