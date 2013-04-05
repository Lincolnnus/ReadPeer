//
//  iPhoneTableListViewController.m
//  ReadPeer
//
//  Created by Shaohuan Li on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "iPhoneTableListViewController.h"
#import "Comment.h"
#import "CommentViewController.h"

@interface iPhoneTableListViewController ()

@end

@implementation iPhoneTableListViewController
{
    NSMutableArray * annotations;
    CommentViewController *commentViewController;
}

@synthesize annotationTable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)updateAnnotations:(NSMutableArray*) annots
{
    annotations = annots;
    [annotationTable reloadData];
}
- (IBAction)cancelList:(id)sender {
    [self.view removeFromSuperview];
}
- (void)loadView {
    NSArray *theView =  [[NSBundle mainBundle] loadNibNamed:@"iPhoneTableView" owner:self options:nil];
    UIView *nv = [theView objectAtIndex:0];
    self.view = nv;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    annotations = [[NSMutableArray alloc]init];
   // comments = [[NSMutableArray alloc] init];
    annotationTable.dataSource = self;
    annotationTable.delegate = self;
    commentViewController = [[CommentViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAnnotationTable:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    AnnotationModel *selectedAnnotation = [annotations objectAtIndex:[selectedRowIndex row]];
    [commentViewController updateCurrentAnnotation : selectedAnnotation];
    [self.view addSubview:commentViewController.view];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [annotations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnnotationCell";
    
    AnnotationModel *annotation = [annotations objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    [[cell textLabel] setText:annotation.annot];
    cell.detailTextLabel.text= annotation.content;
    return cell;
}


@end
