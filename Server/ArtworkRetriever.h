//
//  ArtworkRetriever.h
//  PBServer
//
//  Created by bryce.hammond on 8/31/10.
//

#import <Foundation/Foundation.h>
#import "PandoraStatus.h"

@protocol ArtworkRetrieverDelegate

- (void)didRetrieveNewArtworkData:(NSData *)artworkData;

@end


@interface ArtworkRetriever : NSObject {
	NSString *_currentSearchKey;
	
	NSObject<ArtworkRetrieverDelegate> *delegate;
}

@property (retain) NSString *currentSearchKey;  //this is non-atomic because it works across threads
@property (assign) NSObject<ArtworkRetrieverDelegate> *delegate;

- (void)getArtworkForArtist:(NSString *)artist songName:(NSString *)name album:(NSString *)album;


@end
