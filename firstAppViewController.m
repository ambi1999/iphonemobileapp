//
//  firstAppViewController.m
//  firstApp
//
//  Created by Ambikesh Jayal on 25/05/2011.
//  ajayal@glos.ac.uk
//  ambi1999@gmail.com
//  Copyright 2011 University of Gloucestershire. All rights reserved.
//

//====================================================================
//Step 1: User enters url in address bar. 
//Step 2: BEFORE LOAD: Print Before load URL which is the url typed by user.
//Step 3: Make a connection using URL (possibly adding http to url if needed)
//Step 4: DOCUMENT LOADED: Print the url of document loaded
//Step 5: IP Addresses: Print ip addresses of document loaded
//Step 6: Fetch the HTML source code as a string
//Step 7: Parse HTMl soruce code for iframe using regular expression by calling function getAllFramesSrcFromHTMLPageContent
//Step 8: IFRAME SOURCE: Print iframe source
//Step 9: IP Addresses: Print ip addresses of the iframe source
//Step 10: Parse HTMl soruce code for image using regular expression by calling function getAllImageSrcFromHTMLPageContent
//Step 11: Print image source
//====================================================================


#import "firstAppViewController.h"

@implementation firstAppViewController


@synthesize webView, addressBar, activityIndicator;



-(void) printTime{
	NSDate* date=[NSDate date];
	NSDateFormatter* formatter=[[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"HH:MM:SS"];
	
	NSString* str=[formatter stringFromDate:date];
	
	valueOfURLByUser.text=str;

}

//first function called
-(void) loadView {
	[super loadView];
}

//this method is called when the app has loaded successfully
//this function loads the browser with html content
- (void)viewDidLoad {
		
    [super viewDidLoad];
	
	webView.delegate=self;
	
	
	//code to preload the webview with a url
	/*
	NSString *urlAddress = @"http://www.o2.co.uk";
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
	[addressBar setText:urlAddress];
	*/
	
		
	//demonstrate that browser (UIWebView) can be loaded using a string by calling function loadHTMLString
	NSString *html = @"<html><head><title>Test html page></head><body><h1> Welcome to University of Gloucestershire.</h1><h1>Please enter the URL in the address bar and click the double arrow button. </h1></body></html>";  
	[webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.glos.ac.uk"]];
	[addressBar setText:@"http://www.glos.ac.uk"];

}


//this function prints all the iframe and their ip address within a string containing html page source
//Note: regular expression may need to be improved to cater to all HTML pages because there may be variations in writing the iframe tag.
//Note: this function currently just prints the iframe sources but does not return anything. Ideally it should return the iframe soruces as well.
-(void)getAllFramesSrcFromHTMLPageContent:(NSString *) strAllHTMLContent{
	
	
	NSError *error = NULL;
	
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<iframe[^>]*src=\"(.*?)\"" 
																		   options:NSRegularExpressionCaseInsensitive
																			 error:&error];
	
	
	NSArray *matches = [regex matchesInString:strAllHTMLContent
									  options:0
										range:NSMakeRange(0, [strAllHTMLContent length])];
	
	//NSString *myString = [NSString stringWithFormat:@"%d", [matches count]];
	
	int count=[matches count];
	
	
	if(count>0){
		
	//NSLog(@"Iframe count: %@",myString);
	//NSLog(@"\n************ IFrame SOURCES START \n");
	for (NSTextCheckingResult *match in matches) {
		NSRange matchRange = [match range];
		NSString* s1=[strAllHTMLContent substringWithRange:matchRange];
		NSString *search = @"src=\"";
		NSString *s2 = [s1 substringFromIndex:NSMaxRange([s1 rangeOfString:search])];
		s2=[s2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		NSLog (@"IFRAME SOURCE: %@", s2);
		
		//code to print the ip address of iframe
		NSURL *url = [NSURL URLWithString:s2];
		NSHost *host=[NSHost hostWithName:[url host]];
		NSArray *nsArrayIPAddresses =[host addresses];
		for (id ipValue in nsArrayIPAddresses){
			NSLog(@"IP Addresses of IFrame %@",ipValue);
		}
		
		
		
	}
	
	
	//[regex release];
		
		
	
	//NSLog(@"\n ************ IFrame SOURCES END\n ");
	}
	

		
}


//this function prints all the images within a html page
//Note: regular expression may need to be improved to cater to all HTML pages because there may be variations in writing the img tag.
//Note: this function currently just prints the img sources but does not return anything. Ideally it should return the img soruces as well.
-(void)getAllImageSrcFromHTMLPageContent:(NSString *) strAllHTMLContent{
	
	
	NSError *error = NULL;
	
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]*src=\"(.*?)\"" 
																		   options:NSRegularExpressionCaseInsensitive
																			 error:&error];
	
	
	NSArray *matches = [regex matchesInString:strAllHTMLContent
									  options:0
										range:NSMakeRange(0, [strAllHTMLContent length])];
	
	NSString *myString = [NSString stringWithFormat:@"%d", [matches count]];
	int count=[matches count];
	
	if(count>0){
	//NSLog(@"Image count: %@",myString);
	//NSLog(@"\n************ Image SOURCES START \n ");
	for (NSTextCheckingResult *match in matches) {
		NSRange matchRange = [match range];
		NSString* s1=[strAllHTMLContent substringWithRange:matchRange];
		NSString *search = @"src=\"";
		NSString *s2 = [s1 substringFromIndex:NSMaxRange([s1 rangeOfString:search])];
		s2=[s2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		NSLog (@"IMAGE SOURCE: %@", s2);
		
		
	}
	
	//[regex release];
	
	//NSLog(@"\n************ Image SOURCES END  \n ");
	}
		
}


//this fucntion is called everytime user clicks double arrow button labelled ">>"
//Note: Add code to handle situation when [addressBar text] is empty
//this functions prints BEFORE LOAD url which may not contain prefix http
//this function additionally prints the header information of the request object
-(IBAction)gotoAddress:(id) sender {
	
	
	NSLog(@"\n\n DATA Generated by Department of Computing, University of Gloucestershire \n\n");
	
	NSString* urlByUser=[addressBar text];
	NSString* formattedURLByUser=urlByUser;
	
	//code to append http if url is not already prefixed with http
	if(![urlByUser hasPrefix:@"http"]){
		formattedURLByUser=[NSString stringWithFormat:@"%@%@", @"http://", urlByUser];
	}
	
	NSURL *url = [NSURL URLWithString:formattedURLByUser];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	//int validationCode=[self getValidationCodeFromCyberSecurity: request];
	//[self processAccordingToValidationCode:validationCode:request];
	
	//Load the request in the UIWebView.
	[webView loadRequest:request];
	[addressBar resignFirstResponder];
	
	// Create the request.
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	NSHost *host=[NSHost hostWithName:[url host]];
	NSArray *nsArrayIPAddresses =[host addresses];
	//NSLog(@"BEFORE LOAD %@", [url absoluteString]);
	NSLog(@"BEFORE LOAD %@", urlByUser);
	

	NSDictionary *nsDictionary=[theRequest allHTTPHeaderFields];
	NSArray *nsArray =[nsDictionary allValues];
	
	valueOfURLByUser.text=@"REQUEST url= {";
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: [[theRequest URL] absoluteString ]];
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"}"];
	
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @" host= {"];
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: [[theRequest URL] host ]];
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"}"];
	
	
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @" Header Info ["];
	
	
	for (id value in nsArray){
		valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"{"];
		valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: value];
		valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"}"];
	}
	
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"]"];
	
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		//connection successful
	} else {
		//connection failed
	}
				
}
//this function prints the url that is finally loaded and its ip addresses
//this function additionally prints the header information of the response object
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	// cast the response to NSHTTPURLResponse so we can look for 404 etc
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	
	//valueOfURLByUser.text =[[httpResponse URL] absoluteString ];
	NSDictionary *nsDictionary=[httpResponse allHeaderFields];
	NSArray *nsArray =[nsDictionary allValues];
	
	 
	//valueOfURLByUser.text=@"url= {";
	
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"\n RESPONSE url = {"];
	
	
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: [[httpResponse URL] absoluteString ]];
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"}"];
	
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @" host= {"];
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: [[httpResponse URL] host ]];
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"}"];
	
	NSLog(@"DOCUMENT LOADED %@", [[httpResponse URL] absoluteString ]);
	NSHost *host=[NSHost hostWithName:[[httpResponse URL] host ]];
	NSArray *nsArrayIPAddresses =[host addresses];
	
	for (id ipValue in nsArrayIPAddresses){
		  NSLog(@"IP Addresses %@",ipValue);
	}
	
	
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @" Header Info ["];
	

	for (id value in nsArray){
		valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"{"];
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: value];
		valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"}"];
	}
	
	valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"]"];

	
	if ([httpResponse statusCode] >= 400) {
		// do error handling here
		NSLog(@"remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
	} else {
		// start recieving data
	}
	
}

//this fucntion receives the html page body, converts it to lowercase and calls function getAllFramesSrcFromHTMLPageContent to fetch iframes
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData{

	NSString *str = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
	NSString *str1=[str lowercaseString];
	[self getAllFramesSrcFromHTMLPageContent: str1];
	//[self getAllImageSrcFromHTMLPageContent: str1];
	[str release];
	
}

//this function is called when user clicks back button labelled as "<"
//Note: add code to update the address bar with the previous url
-(IBAction) goBack:(id)sender {
	[webView goBack];
}

//this function is called when user clicks forward button labelled as ">"
//Note: add code to update the address bar with the forward url
-(IBAction) goForward:(id)sender {
	[webView goForward];
	
}





-(int) getValidationCodeFromCyberSecurity: (NSURLRequest*)request{
	[self printTime];
	//[self showConfirmAlert];
	NSURL *URL = [request URL];	
	int cyberSecurityValidationCode=-9;
	
	//code by ambi
	
	NSString *urlUserWantsToGo=[URL absoluteString];
	NSString *allowedURL1 = @"bbc";
	NSString *allowedURL2 = @"glos";
	
	NSString *badURL1 = @"rediff";
	NSString *badURL2 = @"dellfake";
		
	if (([urlUserWantsToGo rangeOfString:allowedURL1].location != NSNotFound) ||  ([urlUserWantsToGo rangeOfString:allowedURL2].location != NSNotFound)   )
	{
		cyberSecurityValidationCode= 0;
		
	}else if (([urlUserWantsToGo rangeOfString:badURL1].location != NSNotFound) ||  ([urlUserWantsToGo rangeOfString:badURL2].location != NSNotFound)   )
	{
		cyberSecurityValidationCode= 1;
		
	}else {
		//not sure about the url
		cyberSecurityValidationCode= 2;
		
	}
	return cyberSecurityValidationCode;
}

-(void)loadURLAndUpdateAddressBar: (NSURLRequest*)request{
	NSURL *URL = [request URL];	
	[addressBar setText:[URL absoluteString]];
	[webView loadRequest:request];
	[addressBar resignFirstResponder];

}

int buttonIndexClickedByUser=-9999;
//if the cyberSecurityValidationCode is 0 this fucntion loads the url
//if the cyberSecurityValidationCode is 1 or 2, this functions calls showCyberSecurityAlert function to show alert box to user and gets yes or no response
//Note: this function does call showCyberSecurityAlert fucntion to show alert box but it does not wait for user response as the alert box is not modal. Add code to make alert box modal.
- (void) processAccordingToValidationCode: (int) cyberSecurityValidationCode: (NSURLRequest*)request{
	NSURL *URL = [request URL];	
	valueOfURLByUser.text=[@"URL user wants to go: " stringByAppendingString: [URL absoluteString]];
	if(cyberSecurityValidationCode==0){
		[self loadURLAndUpdateAddressBar:request];
		valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"\n URL is GOOD"];
		
	}else if(cyberSecurityValidationCode==1){
		NSString *message=@"URL is BAD. Do you still want to proceed Yes or No?";
		[self showCyberSecurityAlert: message];
		
		if(buttonIndexClickedByUser==0){
			//yes, proceed
			[self loadURLAndUpdateAddressBar:request];
			valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"\n URL is BAD \n BUT USER WANTS TO PROCEED"];

		}else{
		valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"\n URL is BAD \n USER DOES NOT WANT TO PROCEED"];
		}
	}else if(cyberSecurityValidationCode==2){
		NSString *message=@"URL is NOT AUTHENTICATED . Do you still want to proceed Yes or No?";
		[self showCyberSecurityAlert: message];
		if(buttonIndexClickedByUser==0){
			//yes, proceed
			[webView loadRequest:request];
			[self loadURLAndUpdateAddressBar:request];
			valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"\n URL is NOT AUTHENTICATED \n USER WANTS TO PROCEED"];
		}else{
		valueOfURLByUser.text=[valueOfURLByUser.text stringByAppendingString: @"\n URL is NOT AUTHENTICATED \n USER DOES NOT WANT TO PROCEED"];
		}
		
	}else{
		//do nothing
	}

}
//this function shows an alert box
- (void)showCyberSecurityAlert: (NSString* ) message
{
	//buttonIndexClickedByUser=-9999;
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"First CyberSecurity Alert"];
	[alert setMessage:message];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
	[alert release];
		
}


//this fucntion is called wen the user clicks yes or no button in the alert box
//it sets buttonIndexClickedByUser to 0 if user has clicked yes button, sets buttonIndexClickedByUser to 1 if the user has clicked no button
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	buttonIndexClickedByUser=buttonIndex;
	
}



//this fucntion is called when user clicks a hyperlink within a webpage 
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	
	//CAPTURE USER LINK-CLICK.
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		int validationCode=[self getValidationCodeFromCyberSecurity: request];
		[self processAccordingToValidationCode:validationCode:request];
		return NO;
		}	 
	return YES;   
	
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[activityIndicator stopAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
	
}


- (void)dealloc {
	
	[super dealloc];
	
}

@end
