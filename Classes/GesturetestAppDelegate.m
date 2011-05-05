//
//  GesturetestAppDelegate.m
//  Gesturetest
//
//  Created by Antonio "Willy" Malara on 30/04/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "GesturetestAppDelegate.h"
#import "GestureWindow.h"

@implementation GesturetestAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application;
{
	window = [[GestureWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window makeKeyAndVisible];
}

- (void)dealloc;
{
    [window release];
    [super dealloc];
}

@end
