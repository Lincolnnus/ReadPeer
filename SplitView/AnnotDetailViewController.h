//
//  AnnotDetailViewController.h
//  SplitView
//
//  Created by Shaohuan Li on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "AnnotationModel.h"
#include "CommentDetailViewController.h"

@interface AnnotDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) IBOutlet UITextView* contentView;
@property (nonatomic,strong) IBOutlet UITableView* commentView;
@property (strong, nonatomic) IBOutlet UITextView *annotView;
@property (nonatomic) AnnotationModel* currentAnnot;
@property (nonatomic) NSMutableArray *comments;
@end
