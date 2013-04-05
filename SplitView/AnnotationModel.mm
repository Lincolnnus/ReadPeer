//
//  AnnotationModel.m
//  SplitView
//
//  Created by Shaohuan Li on 16/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AnnotationModel.h"

@implementation AnnotationModel

@synthesize content,annot,aid,similarity;


-(id) initWithContent: (NSString*) c Annotation: (NSString*)a Aid: (NSString*)annotid Similarity:(NSString*)s{
    if (self = [super init]) {
        // Custom initialization
        content = c;
        annot = a;
        aid = annotid;
        similarity = s;
    }
    return self;
}

-(id)initWithJSON: (NSDictionary *)json
{
    if (self = [super init]) {
        // Custom initialization
        content = [json objectForKey:@"content"];
        annot = [json objectForKey:@"body"];
        aid = [json objectForKey:@"aid"];
        similarity = [json objectForKey:@"similarity"];
    }
    return self;
}
@end
