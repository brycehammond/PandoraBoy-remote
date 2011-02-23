//
//  PBClientAppDelegate.h
//  PBClient
//
//  Created by bryce.hammond on 7/18/10.

//

#import <Cocoa/Cocoa.h>

@class PandoraBoyProxy;
@class PandoraStatus;
@class ServerManager;

@interface PBServerAppDelegate : NSObject <NSApplicationDelegate> 
{
	
	IBOutlet NSPanel *_currentlyPlayingWindow;
	
	NSStatusItem *_statusItem;
	
	IBOutlet NSButton *_playPauseButton;
	IBOutlet NSButton *_nextButton;
	IBOutlet NSButton *_thumbsDownButton;
	IBOutlet NSButton *_thumbsUpButton;
	IBOutlet NSButton *_nextStationButton;
	IBOutlet NSButton *_previousStationButton;
	
	IBOutlet NSTextField *_stationLabel;
	IBOutlet NSTextField *_artistLabel;
	IBOutlet NSTextField *_songLabel;
	IBOutlet NSTextField *_albumLabel;
	
	PandoraBoyProxy *_pbProxy;
	PandoraStatus *_currentPandoraStatus;
	ServerManager *_serverManager;
	
}

- (IBAction)playPause:(NSButton *)button;
- (IBAction)goToNextSong:(NSButton *)button;
- (IBAction)goToNextStation:(NSButton *)button;
- (IBAction)goToPreviousStation:(NSButton *)button;
- (IBAction)thumbsUp:(NSButton *)button;
- (IBAction)thumbsDown:(NSButton *)button;

@end
