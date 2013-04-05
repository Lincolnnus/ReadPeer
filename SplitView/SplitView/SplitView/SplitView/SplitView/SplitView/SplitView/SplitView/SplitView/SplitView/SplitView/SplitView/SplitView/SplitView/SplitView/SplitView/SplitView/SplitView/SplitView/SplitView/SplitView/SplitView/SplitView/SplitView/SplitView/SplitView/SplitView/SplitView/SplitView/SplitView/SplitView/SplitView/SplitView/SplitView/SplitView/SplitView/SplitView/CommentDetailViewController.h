//
//  CommentDetailViewController.h
//  SplitView
//
//  Created by Shaohuan Li on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *commentView;
@property (nonatomic) Comment* currentComment;
@end
