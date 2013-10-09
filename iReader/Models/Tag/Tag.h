//
//  Tag.h
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject<NSCoding>

@property long count ;//count;
@property(nonatomic,strong) NSString *name;//name
@property(nonatomic,strong) NSString *title;//title

@end
