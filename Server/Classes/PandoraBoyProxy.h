//
//  PandoraBoyProxy.h
//  PBClient
//
//  Created by bryce.hammond on 7/23/10.
//

#import <Cocoa/Cocoa.h>


@interface PandoraBoyProxy : NSObject {
	NSAppleScript *_volumeUpScript;
	NSAppleScript *_volumeDownScript;
	NSAppleScript *_thumbsUpScript;
	NSAppleScript *_thumbsDownScript;
	NSAppleScript *_pausePlayScript;
	NSAppleScript *_nextStationScript;
	NSAppleScript *_previousStationScript;
	NSAppleScript *_stationInformationScript;
	NSAppleScript *_trackInformationScript;
	NSAppleScript *_nextTrackScript;
}

- (void)volumeUp;
- (void)volumeDown;
- (void)thumbsUp;
- (void)thumbsDown;
- (void)pausePlay;
- (void)goToNextSong;
- (void)goToNextStation;
- (void)goToPreviousStation;
- (NSString *)currentStatusInformation;

@end
