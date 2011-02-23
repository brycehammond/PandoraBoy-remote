//
//  PBClientManager.m
//  PBRemote
//
//  Created by bryce.hammond on 8/17/10.
//

#import "PBClientManager.h"
#import "AsyncSocket.h"
#import "JSON.h"

@implementation PBClientManager

@synthesize delegate;

- (void)setHostName:(NSString *)hostname andPort:(NSInteger)port
{
	[_hostname release];
	_hostname = [hostname retain];
	_port = port;
}

- (BOOL)connect
{
	if(nil == _pbClient && _hostname && _port)
	{
		_pbClient = [[AsyncSocket alloc] initWithDelegate:self];
		
		NSError *error = nil;
		BOOL connectResult = [_pbClient connectToHost:_hostname onPort:_port error:&error];

		NSLog(@"connection result: %i",connectResult);
		
		return connectResult;
		
	}
	
	return NO;
	
}

- (void)disconnect
{
	if([_pbClient isConnected])
	{
		[_pbClient disconnect];
	}
	
	[_pbClient setDelegate:nil];
	[_pbClient release];
	_pbClient = nil;
}

- (BOOL)isConnected
{
	return [_pbClient isConnected];
}

- (void)executeCommand:(NSString *)command
{
	
	NSDictionary *commandDictionary =
	[NSDictionary dictionaryWithObject:command forKey:@"Command"];
	
	NSString *commandString = [[commandDictionary JSONRepresentation] stringByAppendingString:@"\n"];
	
	[_pbClient writeData:[commandString dataUsingEncoding:NSUTF8StringEncoding]
			 withTimeout:-1 tag:2];
}

#pragma mark AsyncSocket delegate methods

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	//start reading
	[sock readDataToData:[AsyncSocket LFData] withTimeout:-1 tag:0];
	
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"received: %@",message);
	NSDictionary *dict = [message JSONValue];
	if([dict isKindOfClass:[NSDictionary class]])
	{
		PandoraStatus *newStatus = [[PandoraStatus alloc] init];
		[newStatus fillFromDictionary:dict];
		[delegate newPandoraStatusAvailable:newStatus];
		[newStatus release];
	}
	[message release];
	
	//start reading again
	[sock readDataToData:[AsyncSocket LFData] withTimeout:-1 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	NSLog(@"Client Disconnected: %@:%hu", _hostname, _port);
	[delegate clientDidDisconnect];
}



@end
