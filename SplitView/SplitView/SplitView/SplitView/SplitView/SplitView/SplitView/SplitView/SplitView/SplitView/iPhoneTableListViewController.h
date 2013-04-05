//
//  iPhoneTableListViewController.h
//  ReadPeer
//
//  Created by Shaohuan Li on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotationModel.h"
@interface iPhoneTableListViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *annotationTable;
-(void) updateAnnotations:(NSMutableArray*) annots;
@end
