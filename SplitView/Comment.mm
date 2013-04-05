//
//  Comment.m
//  SplitView
//
//  Created by Shaohuan Li on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize commentDetail;

-(id)initWithJSON: (NSDictionary *)json
{
    if (self = [super init]) {
        // Custom initialization
        commentDetail = [json objectForKey:@"body"];
    }
    return self;
}
@end
