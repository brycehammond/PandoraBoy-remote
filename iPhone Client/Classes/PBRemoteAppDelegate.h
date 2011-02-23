//
//  PBRemoteAppDelegate.h
//  PBRemote
//
//  Created by bryce.hammond on 8/16/10.
//  Copyright Wall Street On Demand, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>s

@class PBRemoteViewController;
@class PBClientManager;

@interface PBRemoteAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PBRemoteViewController *viewController;
	
	PBClientManager *_clientManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PBRemoteViewController *viewController;

@end

