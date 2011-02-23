//
//  PBRemoteAppDelegate.m
//  PBRemote
//
//  Created by bryce.hammond on 8/16/10.
//  Copyright Wall Street On Demand, Inc. 2010. All rights reserved.
//

#import "PBRemoteAppDelegate.h"
#import "PBRemoteViewController.h"
#import "PBClientManager.h"
  
@implementation PBRemoteAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

	if(! _clientManager)
	{
		_clientManager = [[PBClientManager alloc] init];
	}
	
    // Add the view controller's view to the window and display.
	[_clientManager setDelegate:viewController];
	[viewController setClientManager:_clientManager];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[_clientManager setDelegate:nil];
	[_clientManager disconnect];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	
}


- (void)applicationDidBecomeActive:(UIApplication *)application 
{
   
	
	//reconnect to the client if possible
	[_clientManager setDelegate:viewController];
	if(NO == [_clientManager isConnected])
	{
		if(NO == [_clientManager connect])
		{
			//we couldn't reconnect so show the selector again
			[viewController showBonjourSelector];
			
		}
	}
	
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
