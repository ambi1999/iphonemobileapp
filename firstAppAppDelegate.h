//
//  firstAppAppDelegate.h
//  firstApp
//
//  Created by Ambikesh Jayal on 25/05/2011.
//  ajayal@glos.ac.uk
//  ambi1999@gmail.com
//  Copyright 2011 University of Gloucestershire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class firstAppViewController;

@interface firstAppAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    firstAppViewController *viewController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet firstAppViewController *viewController;

@end

