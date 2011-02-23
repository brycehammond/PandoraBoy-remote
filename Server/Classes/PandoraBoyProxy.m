//
//  PandoraBoyProxy.m
//  PBClient
//
//  Created by bryce.hammond on 7/23/10.
//

#import "PandoraBoyProxy.h"


@implementation PandoraBoyProxy

- (void)volumeUp
{
	if(nil == _volumeUpScript)
	{
		NSError *error = nil;
		_volumeUpScript = [[NSAppleScript alloc] initWithSource:
						   [NSString stringWithContentsOfFile:
							[[NSBundle mainBundle] pathForResource:@"volume_up"
															ofType:@"applescript"]
													 encoding:NSUTF8StringEncoding
														error:&error]];
	}
	
	NSDictionary *error = nil;
	[_volumeUpScript executeAndReturnError:&error];
}

- (void)volumeDown
{
	if(nil == _volumeDownScript)
	{
		NSError *error = nil;
		_volumeDownScript = [[NSAppleScript alloc] initWithSource:
						   [NSString stringWithContentsOfFile:
							[[NSBundle mainBundle] pathForResource:@"volume_down"
															ofType:@"applescript"]
													 encoding:NSUTF8StringEncoding
														error:&error]];
	}
	
	NSDictionary *error = nil;
	[_volumeDownScript executeAndReturnError:&error];
}

- (void)thumbsUp
{
	if(nil == _thumbsUpScript)
	{
		NSError *error = nil;
		_thumbsUpScript = [[NSAppleScript alloc] initWithSource:
							 [NSString stringWithContentsOfFile:
							  [[NSBundle mainBundle] pathForResource:@"thumbs_up"
															  ofType:@"applescript"]
													   encoding:NSUTF8StringEncoding
														  error:&error]];
	}
	
	NSDictionary *error = nil;
	[_thumbsUpScript executeAndReturnError:&error];
}

- (void)thumbsDown
{
	if(nil == _thumbsDownScript)
	{
		NSError *error = nil;
		_thumbsDownScript = [[NSAppleScript alloc] initWithSource:
						   [NSString stringWithContentsOfFile:
							[[NSBundle mainBundle] pathForResource:@"thumbs_down"
															ofType:@"applescript"]
													 encoding:NSUTF8StringEncoding
														error:&error]];
	}
	
	NSDictionary *error = nil;
	[_thumbsDownScript executeAndReturnError:&error];
}

- (void)pausePlay
{
	if(nil == _pausePlayScript)
	{
		NSError *error = nil;
		_pausePlayScript = [[NSAppleScript alloc] initWithSource:
							 [NSString stringWithContentsOfFile:
							  [[NSBundle mainBundle] pathForResource:@"pause_play"
															  ofType:@"applescript"]
													   encoding:NSUTF8StringEncoding
														  error:&error]];
	}
	
	NSDictionary *error = nil;
	[_pausePlayScript executeAndReturnError:&error];
}

- (void)goToNextSong
{	if(nil == _nextTrackScript)
	{
		NSError *error = nil;
		_nextTrackScript = [[NSAppleScript alloc] initWithSource:
							  [NSString stringWithContentsOfFile:
							   [[NSBundle mainBundle] pathForResource:@"next_track"
															   ofType:@"applescript"]
														encoding:NSUTF8StringEncoding
														   error:&error]];
	}
	
	NSDictionary *error = nil;
	[_nextTrackScript executeAndReturnError:&error];
}

- (void)goToNextStation
{
	if(nil == _nextStationScript)
	{
		NSError *error = nil;
		_nextStationScript = [[NSAppleScript alloc] initWithSource:
							[NSString stringWithContentsOfFile:
							 [[NSBundle mainBundle] pathForResource:@"next_station"
															 ofType:@"applescript"]
													  encoding:NSUTF8StringEncoding
														 error:&error]];
	}
	
	NSDictionary *error = nil;
	[_nextStationScript executeAndReturnError:&error];
}

- (void)goToPreviousStation
{
	if(nil == _previousStationScript)
	{
		NSError *error = nil;
		_previousStationScript = [[NSAppleScript alloc] initWithSource:
							  [NSString stringWithContentsOfFile:
							   [[NSBundle mainBundle] pathForResource:@"previous_station"
															   ofType:@"applescript"]
														encoding:NSUTF8StringEncoding
														   error:&error]];
	}
	
	NSDictionary *error = nil;
	[_previousStationScript executeAndReturnError:&error];
}

- (NSString *)currentStatusInformation
{
	if(nil == _trackInformationScript)
	{
		NSError *error = nil;
		NSString *scriptResource = [[NSBundle mainBundle] pathForResource:@"status_info"
																   ofType:@"applescript"];
		NSString *infoScript = [NSString stringWithContentsOfFile:scriptResource
														 encoding:NSUTF8StringEncoding
															error:&error];
		_trackInformationScript = [[NSAppleScript alloc] initWithSource:infoScript];
	}
	
	NSDictionary *error = nil;
	return [[_trackInformationScript executeAndReturnError:&error] stringValue];
}

- (void)dealloc
{
	[_volumeUpScript release];
	[_volumeDownScript release];
	[_thumbsUpScript release];
	[_thumbsDownScript release];
	[_pausePlayScript release];
	[_nextStationScript release];
	[_previousStationScript release];
	
	[super dealloc];
}

@end
