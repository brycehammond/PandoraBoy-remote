//
//  PBClientAppDelegate.m
//  PBClient
//
//  Created by bryce.hammond on 7/18/10.

//

#import "PBServerAppDelegate.h"
#import "PandoraBoyProxy.h"
#import "PandoraStatus.h"
#import "ServerManager.h"

@interface PBServerAppDelegate (Private)

- (void)updateCurrentStatus;
- (void)createMenuBar;

@end


@implementation PBServerAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	_pbProxy = [[PandoraBoyProxy alloc] init];
	_serverManager = [[ServerManager alloc] initWithProxy:_pbProxy];
	[_serverManager startServer];
	
	[[NSDistributedNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(playerInfoChanged:)
	 name:@"net.frozensilicon.pandoraBoy.playerInfo"
	 object:nil
	 suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];
	
	[self createMenuBar];
	[self updateCurrentStatus];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playerInfoChanged:(NSNotification *)notification
{
	NSLog(@"%@",notification);
	[self updateCurrentStatus];
}

#pragma mark Button Actions

- (IBAction)playPause:(NSButton *)button
{
	if([_currentPandoraStatus playerStatus] == PAUSED)
	{
		[_playPauseButton setTitle:@"Pause"];
	}
	else 
	{
		[_playPauseButton setTitle:@"Play"];
	}
	[_pbProxy pausePlay];
}

- (IBAction)goToNextSong:(NSButton *)button
{
	[_pbProxy goToNextSong];
}

- (IBAction)goToNextStation:(NSButton *)button
{
	[_pbProxy goToNextStation];
}

- (IBAction)goToPreviousStation:(NSButton *)button
{
	[_pbProxy goToPreviousStation];
}

- (IBAction)thumbsUp:(NSButton *)button
{
	[_pbProxy thumbsUp];
}

- (IBAction)thumbsDown:(NSButton *)button
{
	[_pbProxy thumbsDown];
}

@end

@implementation PBServerAppDelegate (Private)

- (void)updateCurrentStatus
{
	[_currentPandoraStatus release];
	_currentPandoraStatus = [[PandoraStatus alloc] init];
	
	NSString *proxyReturn = [_pbProxy currentStatusInformation];
	[_currentPandoraStatus fillFromPandoraBoyInfo:proxyReturn];
	
	if([_currentPandoraStatus playerStatus] == PAUSED)
	{
		[_playPauseButton setTitle:@"Play"];
	}
	else 
	{
		[_playPauseButton setTitle:@"Pause"];
	}

	
	[_stationLabel setStringValue:[_currentPandoraStatus currentStation]];
	[_artistLabel setStringValue:[NSString stringWithFormat:@"By: %@",[_currentPandoraStatus artist]]];
	[_songLabel setStringValue:[_currentPandoraStatus name]];
	[_albumLabel setStringValue:[NSString stringWithFormat:@"On: %@",[_currentPandoraStatus album]]];
	[_serverManager setCurrentStatus:_currentPandoraStatus];
	[_serverManager sendClientUpdateForCurrentStatus];
	[_serverManager retrieveArtworkForCurrentStatus];
}

-(void)createMenuBar
{
	
	NSMenu *myMenu;
	NSMenuItem *menuItem;
	
	myMenu = [[NSMenu alloc] init];
	
	menuItem = [myMenu addItemWithTitle:@"Show Currently Playing"
								 action:@selector(showWindow:) keyEquivalent:@""];
	
	[menuItem setTarget:self];
	
	[myMenu addItemWithTitle:@"Quit"
					  action:@selector(terminate:) keyEquivalent:@""];
	
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[_statusItem retain];
	
	[_statusItem setTitle:@"PB"];
	[_statusItem setHighlightMode:YES];
	[_statusItem setMenu:myMenu];
	
}

- (void)showWindow:(id)sender
{
	[_currentlyPlayingWindow makeKeyAndOrderFront:self];
}

@end
