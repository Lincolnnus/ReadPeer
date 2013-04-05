//
//  AnnotationModel.h
//  SplitView
//
//  Created by Shaohuan Li on 16/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnotationModel : NSObject

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *annot;
@property (nonatomic,copy) NSString *aid;
@property (nonatomic,copy) NSString *similarity;

-(id) initWithContent: (NSString*) content Annotation: (NSString*)annot Aid: (NSString*)aid Similarity:(NSString*)similarity;
-(id) initWithJSON: (NSDictionary *)json;
@end
