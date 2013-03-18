//
//  MasterViewController.h
//  SpitViewControllerDemo
//
//  Created by Shaohuan Li on 14/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotationModel.h" 
#import "AnnotDetailViewController.h"
#import "DetailViewController.h"

@interface MasterViewController : UITableViewController<AnnotationDelegate>

@property (nonatomic,strong)AnnotDetailViewController *annotController;
@property (nonatomic) NSMutableArray *annotations;
@end
