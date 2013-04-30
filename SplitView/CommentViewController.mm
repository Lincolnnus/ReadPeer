//
//  CommentViewController.m
//  ReadPeer
//
//  Created by Shaohuan Li on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CommentViewController.h"
#import "AnnotationModel.h"
#import "Comment.h"
#import "AFJSONRequestOperation.h"
#define CommentApiURL @"http://readpeer.com/api/comments/"
@interface CommentViewController ()

@end

@implementation CommentViewController
{
     NSMutableArray * comments;
    AnnotationModel *currentAnnot;
}

@synthesize commentView,contentView,annotView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)updateCurrentAnnotation : (AnnotationModel*)selectedAnnotation
{
    currentAnnot = selectedAnnotation;
    contentView.text=selectedAnnotation.content;
    [contentView setTextColor:[UIColor grayColor]];
    [annotView setFont:[UIFont boldSystemFontOfSize:25]];
    annotView.text=selectedAnnotation.annot;
    NSURL *url = [NSURL URLWithString:[CommentApiURL stringByAppendingString:currentAnnot.aid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        comments = [[NSMutableArray alloc]init];
        for (int i = 0; i < [JSON count];i++)
        {
            Comment *cms = [[Comment alloc] initWithJSON:JSON[i]];
            [comments addObject:cms];
        }
        NSLog(@"%@",JSON);
        [commentView reloadData];
    } failure:nil];
    
    [operation start];
}
- (void)loadView {
    NSArray *theView =  [[NSBundle mainBundle] loadNibNamed:@"commentView" owner:self options:nil];
    UIView *nv = [theView objectAtIndex:0];
    self.view = nv;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    commentView.dataSource = self;
    commentView.delegate = self;
    
}
- (IBAction)backButtonPressed:(id)sender {
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCommentView:nil];
    [self setAnnotView:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [comments count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedRowIndex = [commentView indexPathForSelectedRow];
    Comment *cms =  [comments objectAtIndex:[selectedRowIndex row]];
    [[[UIAlertView alloc] initWithTitle:@"Comment Detail"
                                message:cms.commentDetail
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    
    Comment *comment = [comments objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    [[cell textLabel] setText:comment.commentDetail];
    return cell;
}

@end
