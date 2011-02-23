//
//  PandoraStatus.h
//  PBClient
//
//  Created by bryce.hammond on 7/24/10.
//

#import <Foundation/Foundation.h>

typedef enum
{
	PLAYING = 0,
	PAUSED = 1
} PlayerStatus;

@interface PandoraStatus : NSObject {
	NSString *_currentStation;
	NSString *_nextStation;
	NSString *_previousStation;
	NSString *_artist;
	NSString *_name;
	NSString *_album;
	NSString *_imageData;
	PlayerStatus _playerStatus;
}

- (void)fillFromPandoraBoyInfo:(NSString *)pbInfo;
- (NSString *)JSONString;
- (void)fillFromDictionary:(NSDictionary *)dict;

@property (nonatomic, retain) NSString *currentStation;
@property (nonatomic, retain) NSString *nextStation;
@property (nonatomic, retain) NSString *previousStation;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *album;
@property (nonatomic, retain) NSString *imageData;
@property (assign) PlayerStatus playerStatus;

@end
