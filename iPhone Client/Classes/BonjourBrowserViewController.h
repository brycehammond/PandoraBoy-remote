#import <UIKit/UIKit.h>
#import <Foundation/NSNetServices.h>

@class BonjourBrowserViewController;

@protocol BonjourBrowserViewControllerDelegate <NSObject>
@required
// This method will be invoked when the user selects one of the service instances from the list.
// The ref parameter will be the selected (already resolved) instance or nil if the user taps the 'Cancel' button (if shown).
- (void) browserViewController:(BonjourBrowserViewController*)bvc didResolveInstance:(NSNetService*)ref;
@end

@interface BonjourBrowserViewController : UITableViewController <NSNetServiceBrowserDelegate, NSNetServiceDelegate> {

	id<BonjourBrowserViewControllerDelegate> _delegate;
	NSString* _searchingForServicesString;
	BOOL _showDisclosureIndicators;
	NSMutableArray* _services;
	NSNetServiceBrowser* _netServiceBrowser;
	NSNetService* _currentResolve;
	NSTimer* _timer;
	BOOL _needsActivityIndicator;
	BOOL _initialWaitOver;
}

@property (nonatomic, assign) id<BonjourBrowserViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString* searchingForServicesString;

@property (nonatomic, assign, readwrite) BOOL showDisclosureIndicators;
@property (nonatomic, retain, readwrite) NSMutableArray* services;
@property (nonatomic, retain, readwrite) NSNetServiceBrowser* netServiceBrowser;
@property (nonatomic, retain, readwrite) NSNetService* currentResolve;
@property (nonatomic, retain, readwrite) NSTimer* timer;
@property (nonatomic, assign, readwrite) BOOL needsActivityIndicator;
@property (nonatomic, assign, readwrite) BOOL initialWaitOver;

- (id)initWithTitle:(NSString *)title showDisclosureIndicators:(BOOL)showDisclosureIndicators showCancelButton:(BOOL)showCancelButton;
- (BOOL)searchForServicesOfType:(NSString *)type inDomain:(NSString *)domain;

@end
