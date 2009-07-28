# IMRemoval

The tool to uninstall third-party Input Methods for Mac OS X

2008-2009 © Weizhong Yang. All Rights Reserved.

## Introduction

To install or uninstall an application is quote easy on Mac OS X, what a user need to do is to drag the application bundle to their disk, or drag the application to the trash can. However, to install or uninstall Input Methods is difficult.

Unlike other applications, Input Methods are system level plug-ins, if a user want to install a new third-party Input Method software, he or she need to copy the files to the "/Library/Input Methods" or "/Library/Components" folder with system administrator privilege, and the developers may need to design a customized software installer to do it. 

To uninstall an Input Method is another pain, users may not know where did they install the software, the system administrator privilege is still required, and there was no good tool to help them to find and uninstall the softwares.

The usage of IMRemoval is to list all installed third-party Input Methods in a list, users can check the Input Methods they decide not to use anymore, and what they need to do then is to click on a button.

Input Methods are much important for users in China, Korea, Japan, Taiwan and so on. Since they need such kind of software to combine radicals to characters, therefore they can input texts in their own native language. There are many kinds popular Input Methods in the areas, and the built-in ones may not satisfy their needs. People would like to try several different softwares and know what is the one that they really like.

## Requirement

To install the tool, you need

* Mac OS X 10.4 or higher versions, including 10.5 Leopard and 10.6 Snow Leopard.
* Intel or PowerPC Macintosh computers.

## Build your own version

If you want to build the application by your self, Mac OS X 10.5 Leopard and Xocde 3.0 or higher version are required. You can download Xcode IDE free from Apple Developer Connection. You will be asked to regiter an ADC account.

It is quite easy to build the application:

1. Open ``IMRemoval.xcodeproj`` with Xcode.
2. Click on the "Build" or "Build and Go" button on the toolbar.
3. Done!

## Feedback/Contact

Any suggestion or advice is welcome. Please write to zonble@lithoglyph.com