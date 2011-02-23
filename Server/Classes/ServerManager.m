//
//  ServerManager.m
//  PBClient
//
//  Created by bryce.hammond on 8/16/10.
//

#import "ServerManager.h"
#import "AsyncSocket.h"
#import "PandoraBoyProxy.h"
#import "PandoraStatus.h"
#import "Constants.h"
#import "JSON.h"
#import "NSData+Base64.h"

@implementation ServerManager

@synthesize currentStatus = _currentStatus;

- (id)init
{
	if(self = [super init])
	{
		_socketClients = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id)initWithProxy:(PandoraBoyProxy *)proxy
{
	if(self = [self init])
	{
		_pbProxy = [proxy retain];
	}
	
	return self;
}

- (void)startServer
{
	//start the TCP server
	
	if(nil == _tcpServer)
	{
		_tcpServer = [[AsyncSocket alloc] initWithDelegate:self];
		
		NSError *error = nil;
		if(! [_tcpServer acceptOnPort:2101 error:&error])
		{
			NSLog(@"Error starting server: %@", error);
			return;
		}
	}
	
	if(nil == _bonjourService)
	{
		_bonjourService = [[NSNetService alloc] initWithDomain:@""
														  type:kBonjourServiceName
														  name:@""
														  port:2101];
		
		if(_bonjourService)
		{
			[_bonjourService setDelegate:self];
			[_bonjourService publish];
		}
		else 
		{
			NSLog(@"An error occurred initializing the NSNetService object.");
		}

	}
	
	
} 

- (void)sendClientUpdateForCurrentStatus
{
	if([[self currentStatus] JSONString])
	{
		NSString *currentStatus = [NSString stringWithFormat:@"%@\n",[[self currentStatus] JSONString]];
		for(AsyncSocket *sock in _socketClients)
		{
			[sock writeData:[currentStatus dataUsingEncoding:NSUTF8StringEncoding]
				withTimeout:-1 tag:0];
		}
	}
	
}

- (void)retrieveArtworkForCurrentStatus
{
	if(nil == _artworkRetriever)
	{
		_artworkRetriever = [[ArtworkRetriever alloc] init];
		[_artworkRetriever setDelegate:self];
	}
	
	[_artworkRetriever getArtworkForArtist:[[self currentStatus] artist] 
								  songName:[[self currentStatus] name]
									 album:[[self currentStatus] album]];
}

- (void)dealloc
{
	[_pbProxy release];
	[_socketClients release];
	[_currentStatus release];
	[_bonjourService release];
	[_tcpServer disconnect];
	[_tcpServer release];
	[super dealloc];
}

#pragma mark AsyncSocket delegate methods

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	[_socketClients addObject:newSocket];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	if([self currentStatus])
	{
		NSString *sendString = [NSString stringWithFormat:@"%@\n",[[self currentStatus] JSONString]];
		//we have a new connection so send them the current status
		[sock writeData:[sendString dataUsingEncoding:NSUTF8StringEncoding]
			withTimeout:-1 tag:0];
	}
	
	[sock readDataToData:[AsyncSocket LFData] withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	
	NSString *receivedMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSDictionary *messageStructure = [receivedMessage JSONValue];
	[receivedMessage release];
	if(NO == [messageStructure isKindOfClass:[NSDictionary class]])
	{
		[sock readDataToData:[AsyncSocket LFData] withTimeout:-1 tag:0];
		return;
	}
	
	NSString *message = [messageStructure objectForKey:@"Command"];
	
	if([message isEqualToString:kPlayPauseCommand])
	{
		[_pbProxy pausePlay];
	}
	else if([message isEqualToString:kNextTrackCommand])
	{
		[_pbProxy goToNextSong];
	}
	else if([message isEqualToString:kVolumeUpCommand])
	{
		[_pbProxy volumeUp];
	}
	else if([message isEqualToString:kVolumeDownCommand])
	{
		[_pbProxy volumeDown];
	}
	else if([message isEqualToString:kPreviousStationCommand])
	{
		[_pbProxy goToPreviousStation];
	}
	else if([message isEqualToString:kNextStationCommand])
	{
		[_pbProxy goToNextStation];
	}
	else if([message isEqualToString:kThumbsUpCommand])
	{
		[_pbProxy thumbsUp];
	}
	else if([message isEqualToString:kThumbsDownCommand])
	{
		[_pbProxy thumbsDown];
	}
	
	
	[sock readDataToData:[AsyncSocket LFData] withTimeout:-1 tag:0];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	[_socketClients removeObject:sock];
}


#pragma mark NSNetServiceDelegate methods

- (void)netServiceDidPublish:(NSNetService *)sender
{
	NSLog(@"Successfully published service %@",[sender name]);
}

#pragma mark ArtworkRetrieverDelegate methods

- (void)didRetrieveNewArtworkData:(NSData *)artworkData
{
	[[self currentStatus] setImageData:[artworkData base64Encoding]];
	[self sendClientUpdateForCurrentStatus];
}


@end
