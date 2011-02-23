//
//  PBClientManager.h
//  PBRemote
//
//  Created by bryce.hammond on 8/17/10.
//

#import <Foundation/Foundation.h>
#import "PandoraStatus.h"

@class AsyncSocket;

@protocol PBClientManagerDelegate

- (void)newPandoraStatusAvailable:(PandoraStatus *)status;
- (void)clientDidDisconnect;

@end


@interface PBClientManager : NSObject 
{	
	AsyncSocket *_pbClient;
	
	id<PBClientManagerDelegate> delegate;
	
	NSString *_hostname;
	NSInteger _port;
}

@property (assign) id<PBClientManagerDelegate> delegate;

- (void)setHostName:(NSString *)hostname andPort:(NSInteger)port;

- (BOOL)connect;
- (void)disconnect;
- (BOOL)isConnected;

- (void)executeCommand:(NSString *)command;

@end
