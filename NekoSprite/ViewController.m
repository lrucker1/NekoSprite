//
//  ViewController.m
//  NekoSprite
//
//  Created by Lee Ann Rucker on 11/4/16.
//  Copyright © 2016 Lee Ann Rucker. All rights reserved.
//

#import "ViewController.h"
#import "GameScene.h"
static NSTouchBarItemIdentifier CustomViewIdentifier = @"com.NekoSprite.customView";
static NSTouchBarCustomizationIdentifier CustomViewCustomizationIdentifier = @"com.NekoSprite.customViewViewController";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#if 1
    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    //scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene
    [self.skView presentScene:scene];
    
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
#endif
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

#if 1
- (NSTouchBar *)makeTouchBar
{
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
    
    bar.customizationIdentifier = CustomViewCustomizationIdentifier;
    
    // Set the default ordering of items.
    bar.defaultItemIdentifiers =
        @[CustomViewIdentifier, NSTouchBarItemIdentifierOtherItemsProxy];
    
    bar.customizationAllowedItemIdentifiers = @[CustomViewIdentifier];
        
    return bar;
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:CustomViewIdentifier])
    {
        GameView *customView = [[GameView alloc] initWithFrame:NSZeroRect];
        
    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    //scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene
    [customView presentScene:scene];
        
        _customViewItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:CustomViewIdentifier];
        self.customViewItem.view = customView;
        self.customViewItem.customizationLabel = @"Custom View";

        return self.customViewItem;
    }
    
    return nil;
}
#endif
@end
