//
//  PandoraStatus.m
//  PBClient
//
//  Created by bryce.hammond on 7/24/10.
//

#import "PandoraStatus.h"
#import "JSON.h"

@implementation PandoraStatus

@synthesize currentStation = _currentStation;
@synthesize nextStation = _nextStation;
@synthesize previousStation = _previousStation;
@synthesize artist = _artist;
@synthesize name = _name;
@synthesize album = _album;
@synthesize imageData = _imageData;
@synthesize playerStatus = _playerStatus;

- (void)dealloc
{
	[_currentStation release];
	[_nextStation release];
	[_previousStation release];
	[_artist release];
	[_name release];
	[_album release];
	[_imageData release];
	[super dealloc];
}

- (void)fillFromPandoraBoyInfo:(NSString *)pbInfo
{
	NSArray *components = [pbInfo componentsSeparatedByString:@"\n"];
	for(NSString *component in components)
	{
		NSRange range = [component rangeOfString:@":"];
		if(range.location != NSNotFound && range.location < [component length])
		{
			NSString *field = [component substringToIndex:range.location];
			NSString *value = [component substringFromIndex:range.location + 1];
			if([field isEqualToString:@"CurrentStation"])
			{
				[self setCurrentStation:value];
			}
			else if([field isEqualToString:@"NextStation"])
			{
				[self setNextStation:value];
			}
			else if([field isEqualToString:@"PreviousStation"])
			{
				[self setPreviousStation:value];
			}
			else if([field isEqualToString:@"Artist"])
			{
				[self setArtist:value];
			}
			else if([field isEqualToString:@"Name"])
			{
				[self setName:value];
			}
			else if([field isEqualToString:@"Album"])
			{
				[self setAlbum:value];
			}
			else if([field isEqualToString:@"PlayerState"])
			{
				if([value isEqualToString:@"playing"])
				{
					[self setPlayerStatus:PLAYING];
				}
				else 
				{
					[self setPlayerStatus:PAUSED];
				}

			}

		}
	}
}

- (NSString *)JSONString
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[self currentStation] forKey:@"CurrentStation"];
	[dict setObject:[self nextStation] forKey:@"NextStation"];
	[dict setObject:[self previousStation] forKey:@"PreviousStation"];
	[dict setObject:[self artist] forKey:@"Artist"];
	[dict setObject:[self name] forKey:@"Name"];
	[dict setObject:[self album] forKey:@"Album"];
	[dict setObject:[NSNumber numberWithInt:[self playerStatus]] forKey:@"PlayerState"];
	if([self imageData])
	{
		[dict setObject:[self imageData] forKey:@"Base64ImageData"];
	}
	return [dict JSONRepresentation];
}

- (void)fillFromDictionary:(NSDictionary *)dict
{
	[self setCurrentStation:[dict objectForKey:@"CurrentStation"]];
	[self setNextStation:[dict objectForKey:@"NextStation"]];
	[self setPreviousStation:[dict objectForKey:@"PreviousStation"]];
	[self setArtist:[dict objectForKey:@"Artist"]];
	[self setName:[dict objectForKey:@"Name"]];
	[self setAlbum:[dict objectForKey:@"Album"]];
	[self setPlayerStatus:[[dict objectForKey:@"PlayerState"] intValue]];
	[self setImageData:[dict objectForKey:@"Base64ImageData"]];
}

@end
