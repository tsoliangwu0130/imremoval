@import Cocoa;

@interface MainController : NSWindowController
{
	NSMutableArray *_inputMethodArray;
	IBOutlet NSArrayController *_arrayController;
	IBOutlet NSTableView *_tableView;
}

- (void)scanAllFolder;
- (void)scanFolder:(NSString *)path;
- (BOOL)removeWithAuthorization:(NSString *)path;
- (IBAction)removeAction:(id)sender;
- (IBAction)homepageAction:(id)sender;

@end
