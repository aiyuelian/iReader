//
//  Book.h
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Rating.h"

@interface Book : NSObject<NSCoding>

@property(nonatomic,strong) NSMutableArray *translator;//translator
@property(nonatomic,strong) NSMutableArray *author; //author
@property(nonatomic,strong) NSMutableArray *tags; //tags

@property(nonatomic,strong) Rating *rating;
@property(nonatomic,strong) Image *images; //images


@property(nonatomic,strong) NSString *url; //url
@property(nonatomic,strong) NSString *alt; //alt
@property(nonatomic,strong) NSString *publisher;//publisher
@property(nonatomic,strong) NSString *catalog;//catalog
@property(nonatomic,strong) NSString *binding;//binding;
@property(nonatomic,strong) NSString *origin_title;//origin_title
@property(nonatomic,strong) NSString *bookId; // id
@property(nonatomic,strong) NSString *pages; //pages
@property(nonatomic,strong) NSString *price; //price
@property(nonatomic,strong) NSString *isbn13 ; //isbn13
@property(nonatomic,strong) NSString *alt_title;//alt_title
@property(nonatomic,strong) NSString *author_intro; //author_intro
@property(nonatomic,strong) NSString *title; //title
@property(nonatomic,strong) NSString *summary; //summary
@property(nonatomic,strong) NSString *subtitle; //subtitle
@property(nonatomic,strong) NSString *pubdate; //pubdate
@property(nonatomic,strong) NSString *isbn10;//isbn10
@property(nonatomic,strong) NSString *image; //image;
@end
