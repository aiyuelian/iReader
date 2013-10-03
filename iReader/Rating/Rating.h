//
//  Rating.h
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rating : NSObject<NSCoding>

@property (nonatomic,strong) NSString *min;
@property (nonatomic,strong) NSString *max;
@property (nonatomic,strong) NSString *numRaters;
@property (nonatomic,strong) NSString *average;
@end
