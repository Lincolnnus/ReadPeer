//
//  iPhoneViewController.m
//  SplitView
//
//  Created by Shaohuan Li on 16/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "iPhoneViewController.h"
#import "iPhoneTableListViewController.h"
#import "AFJSONRequestOperation.h"
#define SearchApiURL @"http://dbgpu.d1.comp.nus.edu.sg/xiaoli/ebook/api/search/"
@interface iPhoneViewController ()

@end

@implementation
iPhoneViewController{
    iPhoneTableListViewController *annotationView;
    NSString *result;
}

@synthesize popoverController;
@synthesize bookView;
@synthesize selectedImg;
@synthesize annotationButton;

- (IBAction)getAnnotations:(id)sender {
    [self.view addSubview: annotationView.view];
    if(result == NULL)
    {
        [[[UIAlertView alloc] initWithTitle:@"No Text Error"
                                    message:@"Please Select an Image to Begin"
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }else{
        //EFFECT: search annotations on the cloud after getting the text from OCR
        NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(                          NULL,
                                                                                                        (CFStringRef)result,                           NULL,                                  CFSTR("!*'();:@&=+$,/?%#[]"),                  kCFStringEncodingUTF8));
        NSString *searchURL = [SearchApiURL stringByAppendingString:escapedString];
        NSLog(@"espcapedString%@",searchURL);
        NSURL *url = [NSURL URLWithString:searchURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"json%@",JSON);
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
                [annotationView updateAnnotations:annotations];
            }
        } failure:nil];
        
        [operation start];

    }
}

-(void) hideAnnotation{
    [self.view removeFromSuperview];
}

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
    annotationView = [[iPhoneTableListViewController alloc] init];
	// Do any additional setup after loading the view.
}
- (IBAction)takePhoto:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
	[self presentModalViewController:picker animated:YES];

}
- (IBAction)loadPhoto:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
	[self presentModalViewController:picker animated:YES];

}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    for(UIView *subview in [bookView subviews]) {
        [subview removeFromSuperview];
    }
    selectedImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *pageView = [[UIImageView alloc] initWithImage:selectedImg];
    pageView.frame = CGRectMake(0, 0, bookView.frame.size.width, bookView.frame.size.height);
    [bookView addSubview: pageView];
    [popoverController dismissPopoverAnimated:YES];
    [picker dismissModalViewControllerAnimated:YES];
   // [self getTextfromImage:image];
    [self getAnnotations];
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

- (void)ocrProcessingFinished:(NSString *)r
{
    result = r;
    [[[UIAlertView alloc] initWithTitle:@"Recognized Texts"
                                message:[NSString stringWithFormat:@"Recognized:\n%@", result]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

- (void)getAnnotations
{
    self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHud.labelText = @"Processing OCR";
    
    [self.view addSubview:self.progressHud];
    [self.progressHud showWhileExecuting:@selector(processOcrAt:) onTarget:self withObject:selectedImg animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBookView:nil];
    [self setBookView:nil];
    [self setAnnotationButton:nil];
    [super viewDidUnload];
}
@end
