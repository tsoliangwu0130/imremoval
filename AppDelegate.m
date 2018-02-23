#import "AppDelegate.h"

@import AppCenter;
@import AppCenterAnalytics;
@import AppCenterCrashes;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[MSAppCenter start:@"51391f2a-6794-419c-a3b1-6861a2828a8a" withServices:@[[MSAnalytics class],[MSCrashes class]]];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
