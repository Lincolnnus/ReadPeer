//
//  CommentDetailViewController.m
//  SplitView
//
//  Created by Shaohuan Li on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CommentDetailViewController.h"

@interface CommentDetailViewController ()

@end

@implementation CommentDetailViewController

@synthesize currentComment;
@synthesize commentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    commentView.text=currentComment.commentDetail;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCommentView:nil];
    [super viewDidUnload];
}
@end
