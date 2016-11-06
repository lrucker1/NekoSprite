//
//  GameScene.m
//  NekoSprite
//
//  Created by Lee Ann Rucker on 11/4/16.
//  Copyright © 2016 Lee Ann Rucker. All rights reserved.
//

#import "GameScene.h"

NSTimeInterval kAnimateInterval = 0.125f;

@interface NekoAction : NSObject

@property (strong) NSArray *frames;

@end

@interface GameView ()
@property id trackingTouchIdentity;

@end

@interface GameScene ()

@property (strong) SKSpriteNode *sprite;

@property (strong) NekoAction *stop, *jare, *kaki, *akubi, *sleep, *awake, *u_move, *d_move,
	        *l_move, *r_move, *ul_move, *ur_move, *dl_move, *dr_move, *u_togi,
			*d_togi, *l_togi, *r_togi;

- (void)touchMovedToPoint:(CGPoint)location;
- (void)touchDownAtPoint:(CGPoint)location;
- (void)pinToBounds;

@end

@implementation NekoAction

- (instancetype)initWithNames:(NSArray *)names
{
    self = [super init];
    if (!self) return nil;
    _frames = [self texturesFromFrames:names];
    return self;
}


- (NSArray *)texturesFromFrames:(NSArray *)names
{
    NSMutableArray *frames = [NSMutableArray array];
    for (NSString *textureName in names) {
        SKTexture *temp = [SKTexture textureWithImageNamed:textureName];
        [frames addObject:temp];
    }
    return frames;
}

- (SKAction *)animationAction
{
     return [SKAction animateWithTextures:self.frames
                            timePerFrame:kAnimateInterval
                                  resize:NO
                                 restore:YES];
}

@end

@implementation GameView

- (BOOL)acceptsFirstResponder
{
    return YES;
}
- (BOOL)acceptsTouchEvents
{
    return YES;
}

- (NSPoint)locationForTouch:(NSTouch *)touch
{
    NSPoint loc = [touch locationInView:self];
    return [self convertPoint:loc toScene:self.scene];
}

- (void)viewDidEndLiveResize
{
    [(GameScene *)self.scene pinToBounds];
}

- (void)touchesBeganWithEvent:(NSEvent *)event
{
    // Follow any new touch.

    NSSet<NSTouch *> *touches = [event touchesMatchingPhase:NSTouchPhaseBegan inView:self];
    // Note: Touches may contain 0, 1 or more touches.
    // What to do if there are more than one touch?
    // In this example, randomly pick a touch to track and ignore the other one.
    
    NSTouch *touch = touches.anyObject;
    if (touch != nil)
    {
        if (touch.type == NSTouchTypeDirect)
        {
            _trackingTouchIdentity = touch.identity;
            [(GameScene *)self.scene touchDownAtPoint:[self locationForTouch:touch]];
        }
    }
    
    [super touchesBeganWithEvent:event];
}

- (void)touchesMovedWithEvent:(NSEvent *)event
{
    if (self.trackingTouchIdentity)
    {
        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseMoved inView:self])
        {
            if (touch.type == NSTouchTypeDirect && [_trackingTouchIdentity isEqual:touch.identity])
            {
                [(GameScene *)self.scene touchMovedToPoint:[self locationForTouch:touch]];
            }
        }
    }
    
    [super touchesMovedWithEvent:event];
}

- (void)touchesEndedWithEvent:(NSEvent *)event
{
    if (self.trackingTouchIdentity)
    {
        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseEnded inView:self])
        {
            if (touch.type == NSTouchTypeDirect && [_trackingTouchIdentity isEqual:touch.identity])
            {
                // Finshed tracking successfully.
                _trackingTouchIdentity = nil;
                
                [(GameScene *)self.scene touchMovedToPoint:[self locationForTouch:touch]];
                break;
            }
        }
    }

    [super touchesEndedWithEvent:event];
}

@end


@implementation GameScene {
    SKShapeNode *_spinnyNode;

    SKLabelNode *_label;
}

- (void)configureNeko
{
    if (self.sprite) return;

    SKTexture *temp = [SKTexture textureWithImageNamed:@"awake"];

    self.sprite = [SKSpriteNode spriteNodeWithTexture:temp];
	self.stop =  [[NekoAction alloc] initWithNames:@[@"mati2"]];
	self.jare = [[NekoAction alloc] initWithNames:@[@"jare2", @"mati2"]];
	self.kaki = [[NekoAction alloc] initWithNames:@[@"kaki1", @"kaki2"]];
	self.akubi = [[NekoAction alloc] initWithNames:@[@"mati3"]];
    self.sleep = [[NekoAction alloc] initWithNames:@[@"sleep1", @"sleep2"]];
	self.awake = [[NekoAction alloc] initWithNames:@[@"awake"]];
	self.u_move = [[NekoAction alloc] initWithNames:@[@"up1", @"up2"]];
	self.d_move = [[NekoAction alloc] initWithNames:@[@"down1", @"down2"]];
	self.l_move = [[NekoAction alloc] initWithNames:@[@"left1", @"left2"]];
	self.r_move = [[NekoAction alloc] initWithNames:@[@"right1", @"right2"]];
	self.ul_move = [[NekoAction alloc] initWithNames:@[@"upleft1", @"upleft2"]];
	self.ur_move = [[NekoAction alloc] initWithNames:@[@"upright1", @"upright2"]];
	self.dl_move = [[NekoAction alloc] initWithNames:@[@"dwleft1", @"dwleft2"]];
	self.dr_move = [[NekoAction alloc] initWithNames:@[@"dwright1", @"dwright2"]];
	self.u_togi = [[NekoAction alloc] initWithNames:@[@"utogi1", @"utogi2"]];
	self.d_togi = [[NekoAction alloc] initWithNames:@[@"dtogi1", @"dtogi2"]];
	self.l_togi = [[NekoAction alloc] initWithNames:@[@"ltogi1", @"ltogi2"]];
	self.r_togi = [[NekoAction alloc] initWithNames:@[@"rtogi1", @"rtogi2"]];
  
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    if (self.sprite) return;
    [self configureNeko];
    self.sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:self.sprite];
    [self nekoIdle];
}

- (void)showNeko:(NekoAction *)neko
{
    [self.sprite runAction:[SKAction repeatActionForever:[neko animationAction]]];
}

- (NekoAction *)nekoForDirection:(CGPoint)moveDifference
{
    NekoAction *NewState;
    double moveDx = moveDifference.x;
    double moveDy = moveDifference.y;
    double		LargeX, LargeY;
    double		Length;
    double		SinTheta;
	
    if (moveDx == 0.0f && moveDy == 0.0f) {
		NewState = self.stop;
    } else {
		LargeX = (double)moveDx;
		LargeY = (double)moveDy;
		Length = sqrt(LargeX * LargeX + LargeY * LargeY);
		SinTheta = LargeY / Length;
		//printf("SinTheta = %f\n", SinTheta);
		
		if (moveDx > 0) {
			if (SinTheta > 0.9239) {
				NewState = self.u_move;
			} else if (SinTheta > 0.3827) {
				NewState = self.ur_move;
			} else if (SinTheta > -0.3827) {
				NewState = self.r_move;
			} else if (SinTheta > -0.9239) {
				NewState = self.dr_move;
			} else {
				NewState = self.d_move;
			}
		} else {
			if (SinTheta > 0.9239) {
				NewState = self.u_move;
			} else if (SinTheta > 0.3827) {
				NewState = self.ul_move;
			} else if (SinTheta > -0.3827) {
				NewState = self.l_move;
			} else if (SinTheta > -0.9239) {
				NewState = self.dl_move;
			} else {
				NewState = self.d_move;
			}
		}
    }
	
    return NewState;
}

- (void)nekoIdle
{
    [self showNeko:self.stop];
    SKAction *idleAction =
        [SKAction sequence:@[[SKAction waitForDuration:2.5],
                             [SKAction repeatAction:[self.jare animationAction] count:10],
                             [SKAction repeatAction:[self.kaki animationAction] count:6],
                             [SKAction repeatAction:[self.akubi animationAction] count:4],
                             [SKAction repeatActionForever:[self.sleep animationAction]]]];
    [self.sprite runAction:idleAction withKey:@"nekoIdle"];
}


- (void)pinToBounds
{
    NSPoint p = self.sprite.position;
    NSRect bounds = self.frame;
    if (NSPointInRect(p, bounds)) {
        return;
    }
    if (p.x < NSMinX(bounds)) {
        p.x = NSMinX(bounds) + 16;
    }
    if (p.y < NSMinY(bounds)) {
        p.y = NSMinY(bounds) + 16;
    }
    if (p.x > NSMaxX(bounds)) {
        p.x = NSMaxX(bounds) - 16;
    }
    if (p.y > NSMaxY(bounds)) {
        p.y = NSMaxY(bounds) - 16;
    }
    [self touchMovedToPoint:p];
}

- (void)stopActions
{
    if ([self.sprite actionForKey:@"nekoMoving"]) {
        //stop moving and look surprised
        [self.sprite removeActionForKey:@"nekoMoving"];
    }
    if ([self.sprite actionForKey:@"nekoIdle"]) {
        //stop moving and look surprised
        [self.sprite removeActionForKey:@"nekoIdle"];
    }
}

- (void)touchDownAtPoint:(CGPoint)location
{
    [self stopActions];
    [self showNeko:self.awake];
}

- (void)touchMovedToPoint:(CGPoint)location
{
    [self stopActions];

    NekoAction *action = nil;
    CGSize screenSize = self.frame.size;
    // TouchBar is small; just move left/right.
    if (screenSize.height < 32) location.y = 0;

    float velocity = 100;//screenSize.width / 5.0;
    CGPoint moveDifference = CGPointMake(location.x - self.sprite.position.x, location.y - self.sprite.position.y);
    float distanceToMove = sqrtf(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y);
    float moveDuration = distanceToMove / velocity;
    action = [self nekoForDirection:moveDifference];
    [self showNeko:action];
    SKAction *moveAction = [SKAction moveTo:location duration:moveDuration];
    SKAction *doneAction = [SKAction runBlock:(dispatch_block_t)^() {
        [self nekoIdle];
    }];
    SKAction *moveActionWithDone = [SKAction sequence:@[moveAction,doneAction]];
    [self.sprite runAction:moveActionWithDone withKey:@"nekoMoving"];
}

- (void)touchUpAtPoint:(CGPoint)location
{
    [self touchMovedToPoint:location];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [self touchDownAtPoint:[theEvent locationInNode:self]];
}
- (void)mouseDragged:(NSEvent *)theEvent {
    [self touchMovedToPoint:[theEvent locationInNode:self]];
}
- (void)mouseUp:(NSEvent *)theEvent {
    [self touchUpAtPoint:[theEvent locationInNode:self]];
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
