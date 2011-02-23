//
//  ArtworkRetriever.m
//  PBServer
//
//  Created by bryce.hammond on 8/31/10.
//

#import "ArtworkRetriever.h"
#import "SignedAwsSearchRequest.h"

@interface ArtworkRetriever (Private)

- (void)getXMLForRequestString:(NSDictionary *)requestDict;
- (void)processXMLResponse:(NSDictionary *)xmlDocumentDict;

@end


@implementation ArtworkRetriever

@synthesize currentSearchKey = _currentSearchKey;
@synthesize delegate;

- (void)getArtworkForArtist:(NSString *)artist songName:(NSString *)name album:(NSString *)album
{
	
	if([kAWSAccessKeyId length] > 0 && [kAWSSecretAccessKeyId length] > 0)
	{
	
		[self setCurrentSearchKey:[NSString stringWithFormat:@"%@ %@",artist,album]];
		
		SignedAwsSearchRequest *req = [[[SignedAwsSearchRequest alloc] 
					initWithAccessKeyId:kAWSAccessKeyId
				secretAccessKey:kAWSSecretAccessKeyId] autorelease];
		
		NSMutableDictionary *params = [NSMutableDictionary dictionary];
		[params setValue:@"ItemSearch" forKey:@"Operation"];
		[params setValue:@"Music" forKey:@"SearchIndex"];
		[params setValue:@"Images" forKey:@"ResponseGroup"];
		[params setValue:[self currentSearchKey] forKey:@"Keywords"];
		
		NSString *urlString = [req searchUrlForParameterDictionary:params];
		
		NSDictionary *imageRequestDict = [NSDictionary dictionaryWithObjectsAndKeys:urlString, @"url", [self currentSearchKey], @"key",nil];
		
		[self performSelectorInBackground:@selector(getXMLForRequestString:) withObject:imageRequestDict];
	
	}
}

@end


@implementation ArtworkRetriever (Private)

- (void)getXMLForRequestString:(NSDictionary *)requestDict
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *requestString = [requestDict objectForKey:@"url"];
	
	NSError *error = nil;
	NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithContentsOfURL:
						   [NSURL URLWithString:requestString] options:0 error:&error] autorelease];
	
	NSDictionary *xmlProcessDict = [NSDictionary dictionaryWithObjectsAndKeys:doc, @"xmlDoc", [requestDict objectForKey:@"key"], @"key",nil];
	
	[self processXMLResponse:xmlProcessDict];
	[pool release];
}

- (void)processXMLResponse:(NSDictionary *)xmlDict
{
	NSXMLDocument *xmlDocument = [xmlDict objectForKey:@"xmlDoc"];
	
	NSArray *itemsNode = [[xmlDocument rootElement] elementsForName:@"Items"];
	if([itemsNode count] > 0)
	{
		NSArray *items = [[itemsNode objectAtIndex:0] elementsForName:@"Item"];
		if([items count] > 0)
		{
			NSArray *largeImage = [[items objectAtIndex:0] elementsForName:@"LargeImage"];
			if([largeImage count] > 0)
			{
				NSArray *urls = [[largeImage objectAtIndex:0] elementsForName:@"URL"];
				if([urls count] > 0)
				{
					NSString *imageURL = [[urls objectAtIndex:0] stringValue];
					if(imageURL != nil)
					{
						NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];
						
						if(imageData && [[self currentSearchKey] isEqualToString:[xmlDict objectForKey:@"key"]])
						{
							[delegate performSelectorOnMainThread:@selector(didRetrieveNewArtworkData:)
													   withObject:imageData waitUntilDone:NO];
						}
						
						[imageData release];
					}
				}
			}
		}
	}
}

@end
