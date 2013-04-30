//
//  DetailViewController.m
//  SplitView
//
//  Created by Shaohuan Li on 14/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "Tesseract.h"
#import "AFJSONRequestOperation.h"
#define SearchApiURL @"http://readpeer.com/api/search/"
@implementation DetailViewController

@synthesize toolbar;
@synthesize popoverController;
@synthesize masterPopoverController;
@synthesize selectedImg;
@synthesize bookView;
@synthesize spinner;
@synthesize progressHud;
@synthesize tess;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // UISplitViewControllerDelegate
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Get Annotations";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    
    masterPopoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObject:button];
    [self.toolbar setItems:items animated:YES];
    masterPopoverController = nil;
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    for(UIView *subview in [bookView subviews]) {
        [subview removeFromSuperview];
    }
    selectedImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *pageView = [[UIImageView alloc] initWithImage:selectedImg];
    [bookView addSubview: pageView];
    [popoverController dismissPopoverAnimated:YES];
     [picker dismissModalViewControllerAnimated:YES];
    //[self getTextfromImage:image];
    [self getAnnotations];
    
}
- (IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.sourceType =UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    
    popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    
    [popoverController presentPopoverFromRect:CGRectMake(650.0, 0.0, 150.0, 100.0)
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
}

- (IBAction)loadPhoto:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    
    [popoverController presentPopoverFromRect:CGRectMake(650.0, 0.0, 150.0, 30.0)
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
}

- (void)getAnnotations
{
    self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHud.labelText = @"Processing OCR";
    
    [self.view addSubview:self.progressHud];
    [self.progressHud showWhileExecuting:@selector(processOcrAt:) onTarget:self withObject:selectedImg animated:YES];
}
#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.toolbar = nil;
    
}

- (void)processOcrAt:(UIImage *)image
{
    
     Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
     [tesseract setImage:image];
     [tesseract recognize];
     
     [self performSelectorOnMainThread:@selector(ocrProcessingFinished:)
     withObject:[tesseract recognizedText]
     waitUntilDone:NO];
}

- (void)ocrProcessingFinished:(NSString *)result
{
    //EFFECT: search annotations on the cloud after getting the text from OCR
  /*  NSURL *aUrl = [NSURL URLWithString:@"http://localhost/~shaohuanli/bookannotation/api/search/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [request setHTTPMethod:@"GET"];
    NSString *postString = [@"" stringByAppendingString:result];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (connection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        [[[UIAlertView alloc] initWithTitle:@"Recognized Texts"
         message:[NSString stringWithFormat:@"Recognized:\n%@", result]
         delegate:nil
         cancelButtonTitle:nil
         otherButtonTitles:@"OK", nil] show];
        NSLog(@"%@",result);
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Tesseract Sample"
                                    message:@"Fail to Connect to the Server"
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        // Inform the user that the connection failed.
    }*/
        //EFFECT: search annotations on the cloud after getting the text from OCR
    
    [[[UIAlertView alloc] initWithTitle:@"Recognized Texts"
                                message:[NSString stringWithFormat:@"Recognized:\n%@", result]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];

        NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(                          NULL,
                                                                                                        (CFStringRef)result,                           NULL,                                  CFSTR("!*'();:@&=+$,/?%#[]"),                  kCFStringEncodingUTF8));
        NSString *searchURL = [SearchApiURL stringByAppendingString:escapedString];
        NSURL *url = [NSURL URLWithString:searchURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            if ([JSON count] == 0) {
                [[[UIAlertView alloc] initWithTitle:@"No Similar Annotations"
                                            message:@"No Similar Annotations"
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil] show];
            }
            else{
                NSMutableArray *annotations = [[NSMutableArray alloc] init];
                for (int i = 0; i < [JSON count];i++)
                {
                    AnnotationModel *annot = [[AnnotationModel alloc] initWithJSON:JSON[i]];
                    [annotations addObject:annot];
                }
                [delegate updateAnnotations:annotations];//update the annotations
                NSLog(@"success update annotations");

            }
        } failure:nil];
        
        [operation start];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
