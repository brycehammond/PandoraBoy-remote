//
//  PBRemoteViewController.m
//  PBRemote
//
//  Created by bryce.hammond on 8/16/10.
//  Copyright Wall Street On Demand, Inc. 2010. All rights reserved.
//

#import "PBRemoteViewController.h"
#import "PandoraStatus.h"
#import "PBClientManager.h"
#import "Constants.h"
#import "NSData+Base64.h"

@implementation PBRemoteViewController

@synthesize clientManager = _clientManager;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if(! _bonjourBrowser)
	{
		_bonjourBrowser = [[BonjourBrowserViewController alloc] initWithTitle:@"PandoraBoy Servers"
													 showDisclosureIndicators:NO showCancelButton:NO];
		[_bonjourBrowser setDelegate:self];
		[_bonjourBrowser setSearchingForServicesString:@"Searching for Servers"];
		
	}
	
	CGRect frame = [[_bonjourBrowser view] frame];
	frame.origin = CGPointMake(0, 0);
	[[_bonjourBrowser view] setFrame:frame];
	
	[self showBonjourSelector];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)showBonjourSelector
{
	if([[_bonjourBrowser view] superview] == nil)
	{
		[[self view] addSubview:[_bonjourBrowser view]];
	}
	[_bonjourBrowser searchForServicesOfType:kBonjourServiceName inDomain:@""];
}

- (void)updateWithStatus:(PandoraStatus *)status
{
	[_currentStatus release];
	_currentStatus = [status retain];
	[_stationLabel setText:[status currentStation]];
	[_songLabel setText:[status name]];
	[_artistLabel setText:[NSString stringWithFormat:@"by: %@",[status artist]]];
	[_albumLabel setText:[NSString stringWithFormat:@"on: %@",[status album]]];
	
	[_playPauseButton setImage:(([status playerStatus] == PLAYING) ? 
								[UIImage imageNamed:@"Pause-Decoded.png"] :
								[UIImage imageNamed:@"Play-Decoded.png"])
					  forState:UIControlStateNormal];
	
	if([_currentStatus imageData])
	{
		NSData *imageData = [NSData dataWithBase64EncodedString:[_currentStatus imageData]];
		UIImage *artworkImage = [UIImage imageWithData:imageData];
		[_artworkImageView setImage:artworkImage];
	}
	else
	{
		[_artworkImageView setImage:nil];
	}
}

- (IBAction)playPause:(UIButton *)button
{
	[_playPauseButton setImage:(([_currentStatus playerStatus] == PLAYING) ? 
								[UIImage imageNamed:@"Play-Decoded.png"] :
								[UIImage imageNamed:@"Pause-Decoded.png"])
					  forState:UIControlStateNormal];
	[[self clientManager] executeCommand:kPlayPauseCommand];
}

- (IBAction)nextTrack:(UIButton *)button
{
	[[self clientManager] executeCommand:kNextTrackCommand];
}

- (IBAction)volumeUp:(UIButton *)button
{
	[[self clientManager] executeCommand:kVolumeUpCommand];
}

- (IBAction)volumeDown:(UIButton *)button
{
	[[self clientManager] executeCommand:kVolumeDownCommand];
}

- (IBAction)previousStation:(UIButton *)button
{
	[[self clientManager] executeCommand:kPreviousStationCommand];
}

- (IBAction)nextStation:(UIButton *)button
{
	[[self clientManager] executeCommand:kNextStationCommand];
}

- (IBAction)thumbsUp:(UIButton *)button
{
	[[self clientManager] executeCommand:kThumbsUpCommand];
}

- (IBAction)thumbsDown:(UIButton *)button
{
	[[self clientManager] executeCommand:kThumbsDownCommand];
}

#pragma mark BonjourBrowserViewControllerDelegate methods

- (void) browserViewController:(BonjourBrowserViewController*)bvc didResolveInstance:(NSNetService*)ref
{
	//connect to the service we've resolved
	[_clientManager setHostName:[ref hostName] andPort:[ref port]];
	[_clientManager connect];
	[[_bonjourBrowser view] removeFromSuperview];
}

#pragma mark -
#pragma mark PBClientManagerDelegate methods

- (void)newPandoraStatusAvailable:(PandoraStatus *)status
{
	[self updateWithStatus:status];
}

- (void)clientDidDisconnect
{
	[self showBonjourSelector];
}

@end
