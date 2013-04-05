//
//  CommentViewController.h
//  ReadPeer
//
//  Created by Shaohuan Li on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotationModel.h"
@interface CommentViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableView *commentView;
@property (weak, nonatomic) IBOutlet UITextView *annotView;
@property (weak, nonatomic) IBOutlet UITextView *contentView;
-(void)updateCurrentAnnotation : (AnnotationModel*)selectedAnnotation;
@end
