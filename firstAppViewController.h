//
//  firstAppViewController.h
//  firstApp
//
//  Created by Ambikesh Jayal on 25/05/2011.
//  ajayal@glos.ac.uk
//  ambi1999@gmail.com
//  Copyright 2011 University of Gloucestershire. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface firstAppViewController : UIViewController<UIWebViewDelegate, UIAlertViewDelegate> {
	
	IBOutlet UIWebView *webView;
	IBOutlet UITextField *addressBar;
	IBOutlet UIActivityIndicatorView *activityIndicator;	
	IBOutlet UILabel *myaddresslable;
	IBOutlet UILabel *valueOfURLByUser;	
}

@property(nonatomic,retain) UIWebView *webView;
@property(nonatomic,retain) UITextField *addressBar;
@property(nonatomic,retain) UIActivityIndicatorView *activityIndicator;

-(IBAction) gotoAddress:(id)sender;
-(IBAction) goBack:(id)sender;
-(IBAction) goForward:(id)sender;
-(void) printTime;

-(NSArray*)getAllFrameSrc:(NSString *) htmlPageSource;
-(NSArray*)getAllImageSrc:(NSString *) htmlPageSource;


@end

