//
//  ServerManager.h
//  PBClient
//
//  Created by bryce.hammond on 8/16/10.

//

#import <Foundation/Foundation.h>
#import "ArtworkRetriever.h"

@class PandoraBoyProxy;
@class AsyncSocket;
@class PandoraStatus;

@interface ServerManager : NSObject <NSNetServiceDelegate, ArtworkRetrieverDelegate> {
	PandoraBoyProxy *_pbProxy;
	AsyncSocket *_tcpServer;
	ArtworkRetriever *_artworkRetriever;
	
	NSNetService *_bonjourService;
	PandoraStatus *_currentStatus;
	
	NSMutableArray *_socketClients;
}

@property (nonatomic, retain) PandoraStatus *currentStatus;

- (id)initWithProxy:(PandoraBoyProxy *)proxy;
- (void)startServer;
- (void)sendClientUpdateForCurrentStatus;
- (void)retrieveArtworkForCurrentStatus;

@end
