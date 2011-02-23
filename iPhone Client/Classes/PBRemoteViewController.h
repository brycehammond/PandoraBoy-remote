//
//  PBRemoteViewController.h
//  PBRemote
//
//  Created by bryce.hammond on 8/16/10.
//  Copyright Wall Street On Demand, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonjourBrowserViewController.h"
#import "PBClientManager.h"

@class PandoraStatus;

@interface PBRemoteViewController : UIViewController <BonjourBrowserViewControllerDelegate,
													  PBClientManagerDelegate> {
	IBOutlet UILabel *_stationLabel;
	IBOutlet UILabel *_songLabel;
	IBOutlet UILabel *_artistLabel;
	IBOutlet UILabel *_albumLabel;
	
	IBOutlet UIButton *_playPauseButton;
	IBOutlet UIButton *_nextTrackButton;
	IBOutlet UIButton *_volumeDownButton;
	IBOutlet UIButton *_volumeUpButton;
	IBOutlet UIButton *_previousStationButton;
	IBOutlet UIButton *_nextStationButton;
	IBOutlet UIButton *_thumbsDownButton;
	IBOutlet UIButton *_thumbsUpButton;
														  
	IBOutlet UIImageView *_artworkImageView;
	
	PBClientManager *_clientManager;
	BonjourBrowserViewController *_bonjourBrowser;
	PandoraStatus *_currentStatus;
}

@property (nonatomic, retain) PBClientManager *clientManager;

- (IBAction)playPause:(UIButton *)button;
- (IBAction)nextTrack:(UIButton *)button;
- (IBAction)volumeUp:(UIButton *)button;
- (IBAction)volumeDown:(UIButton *)button;
- (IBAction)previousStation:(UIButton *)button;
- (IBAction)nextStation:(UIButton *)button;
- (IBAction)thumbsUp:(UIButton *)button;
- (IBAction)thumbsDown:(UIButton *)button;

- (void)showBonjourSelector;

- (void)updateWithStatus:(PandoraStatus *)status;

@end

