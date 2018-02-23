#import "MainController.h"

static AuthorizationRef authorizationRef = NULL;

@interface MainController () <NSWindowDelegate>
@end

@implementation MainController

- (NSString *)myLibraryFolder
{
	NSArray *libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	if (!libPaths.count) {
		return nil;
	}
	return libPaths[0];
}

- (void)awakeFromNib
{
	_inputMethodArray = [[NSMutableArray alloc] init];
	[self.window center];
	self.window.delegate = self;
	[self scanAllFolder];
}

- (void)scanAllFolder
{
	[_inputMethodArray removeAllObjects];
	[_arrayController rearrangeObjects];
	[self scanFolder:@"/Library/Input Methods"];
	[self scanFolder:@"/Library/Components"];
	NSString *myLibraryFolder = [self myLibraryFolder];
	[self scanFolder:[myLibraryFolder stringByAppendingPathComponent:@"Input Methods"]];
	[self scanFolder:[myLibraryFolder stringByAppendingPathComponent:@"Components"]];
}

- (void)scanFolder:(NSString *)path
{
	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
	for (NSString *item in contents) {
		NSString *fullPath = [path stringByAppendingPathComponent:item];
		NSBundle *bundle = [NSBundle bundleWithPath:fullPath];
		if (bundle) {
			NSNumber *number = @NO;
			NSString *name = [bundle.infoDictionary valueForKey:@"CFBundleName"];
			if (!name) {
				name = [bundle.infoDictionary valueForKey:@"CFBundleExecutable"];
			}
			NSMutableDictionary *d = [NSMutableDictionary dictionaryWithObjectsAndKeys:number, @"checked", fullPath, @"path", name, @"name", nil];
			[_arrayController addObject:d];
		}
	}
}

- (BOOL)removeWithAuthorization:(NSString *)path
{
	OSStatus status;

	if (authorizationRef == NULL) {
		status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef);
	}
	else {
		status = noErr;
	}

	if (status != noErr) {
		NSLog(@"Could not get authorization, failing.");
		return NO;
	}

	char *args[2];
	args[0] = "-rf";
	args[1] = (char *) path.UTF8String;
	args[2] = (char *) NULL;

	status = AuthorizationExecuteWithPrivileges(authorizationRef, "/bin/rm", 0, args, NULL);

	if (status != noErr) {
		NSLog(@"Could not move file.");
		return NO;
	}
	return YES;
}

- (IBAction)removeAction:(id)sender
{
	NSMutableArray *a = [NSMutableArray array];
	for (NSDictionary *d in _inputMethodArray) {
		if ([d[@"checked"] boolValue]) {
			[a addObject:d];
		}
	}
	if (!a.count) {
		NSRunAlertPanel(NSLocalizedString(@"You did not selected any Input Method.", @""), @"", NSLocalizedString(@"OK", @""), nil, nil);
		return;
	}
	NSInteger r = NSRunAlertPanel(NSLocalizedString(@"Removing Input Methods requires logout, do you want to continue?", @""), @"", NSLocalizedString(@"Remove", @""), NSLocalizedString(@"Cancel", @""), nil);
	if (r != NSOKButton) {
		return;
	}

	for (NSDictionary *d in a) {
		NSString *path = d[@"path"];
		[self removeWithAuthorization:path];
	}
	[self scanAllFolder];
	NSAppleScript *script = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to log out"];
	[script executeAndReturnError:nil];
}

- (IBAction)homepageAction:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://github.com/zonble/imremoval/tree/master"]];
}

- (void)windowWillClose:(NSNotification *)notification
{
	[NSApp terminate:self];
}
@end
