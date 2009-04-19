//
//  MainController.m
//  IMRemoval
//
//  Created by zonble on 2009/4/19.
//  Copyright 2009 Lithoglyph Inc. All rights reserved.
//

#import "MainController.h"
#import <Security/Security.h>

static AuthorizationRef authorizationRef = NULL;

@implementation MainController

- (void) dealloc
{
	[_inputMethodArray release];
	[super dealloc];
}

- (NSString *)myLibraryFolder
{
	NSArray *libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	if (![libPaths count]) {
		return nil; 
	}
	return [libPaths objectAtIndex:0];
}

- (void)awakeFromNib
{
	_inputMethodArray = [[NSMutableArray alloc] init];
	[[self window] center];
	[[self window] setDelegate:self];
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
	NSArray *contents = [[NSFileManager defaultManager] directoryContentsAtPath:path];
	NSEnumerator *e = [contents objectEnumerator];
	NSString *item = nil;
	while (item = [e nextObject]) {
		NSString *fullPath = [path stringByAppendingPathComponent:item];
		NSBundle *bundle = [NSBundle bundleWithPath:fullPath];
		if (bundle) {
			NSNumber *number = [NSNumber numberWithBool:NO];
			NSString *name = [[bundle infoDictionary] valueForKey:@"CFBundleName"];
			if (!name) {
				name = [[bundle infoDictionary] valueForKey:@"CFBundleExecutable"];
			}
			NSMutableDictionary *d = [NSMutableDictionary dictionaryWithObjectsAndKeys:number, @"checked", fullPath, @"path", name, @"name", nil];
			[_arrayController addObject:d];
		}
	}
}
- (IBAction)removeAction:(id)sender
{
	NSMutableArray *a = [NSMutableArray array];
	NSEnumerator *e = [_inputMethodArray objectEnumerator];
	NSDictionary *d = nil;
	while (d = [e nextObject]) {
		if ([[d valueForKey:@"checked"] intValue]) {
			[a addObject:d];
		}
	}
	if ([a count]) {
		NSInteger r = NSRunAlertPanel(@"Removing Input Methods requires logout, do you want to continue?", @"", @"Remove", @"Cancel", nil);
		if (r == NSOKButton) {
			e = [a objectEnumerator];
			while (d = [e nextObject]) {
				NSString *path = [d valueForKey:@"path"];
				[self removeWithAuthorization:path];
			}
			[self scanAllFolder];
			NSAppleScript *script = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to log out"];
			[script autorelease];
			[script executeAndReturnError:nil];
		}
	}
	else {
		NSRunAlertPanel(@"You did not selected any Input Method.", @"", @"OK", nil, nil);
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
	
	char * args[2];
	args[0] = "-rf";	
	args[1] = (char *)[path UTF8String];
	args[2] = (char *)NULL;
	
	status = AuthorizationExecuteWithPrivileges(authorizationRef, "/bin/rm", 0, args, NULL);
	
	if (status != noErr) {
		NSLog(@"Could not move file.");
		return NO;
	}
	return YES;
}

- (void)windowWillClose:(NSNotification *)notification
{
	[NSApp terminate:self];
}
@end
