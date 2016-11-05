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
@property (strong) SKSpriteNode *sprite;

@end

@interface GameScene ()

@property NSPoint spriteOrigin;
@property SKSpriteNode *currentSprite;
@property (strong) SKSpriteNode *sprite;

@property (strong) NekoAction *stop, *jare, *kaki, *akubi, *sleep, *awake, *u_move, *d_move,
	        *l_move, *r_move, *ul_move, *ur_move, *dl_move, *dr_move, *u_togi,
			*d_togi, *l_togi, *r_togi;
@end

@implementation NekoAction

- (instancetype)initWithNames:(NSArray *)names
{
    self = [super init];
    if (!self) return nil;
    _frames = [self texturesFromFrames:names];
    self.sprite = [SKSpriteNode spriteNodeWithTexture:_frames[0]];
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

- (void)doAction
{
    if ([self.frames count] == 1) {
        return;
    }
    //This is our general runAction method to make our neko animate.
    [self.sprite runAction:[SKAction repeatActionForever:
            [self animationAction]]];
    return;
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
    
    // Get label node from scene and store it for use later
//    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
//    
//    _label.alpha = 0.0;
//    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    
//    CGFloat w = (self.size.width + self.size.height) * 0.05;
    
//    // Create shape node to use during mouse interaction
//    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
//    _spinnyNode.lineWidth = 2.5;
    [self configureNeko];
    self.spriteOrigin = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self nekoIdle];

//    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
//    [_spinnyNode runAction:[SKAction sequence:@[
//                                                [SKAction waitForDuration:0.5],
//                                                [SKAction fadeOutWithDuration:0.5],
//                                                [SKAction removeFromParent],
//                                                ]]];

}

- (void)showNeko:(NekoAction *)neko
{
    if (self.currentSprite) {
        self.spriteOrigin = self.currentSprite.position;
        [self.currentSprite removeFromParent];
    }
    self.currentSprite = neko.sprite;
    neko.sprite.position = self.spriteOrigin;
    [self addChild:neko.sprite];
    [neko doAction];
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
        [SKAction sequence:@[[SKAction waitForDuration:3],
                             [SKAction repeatAction:[self.jare animationAction] count:10],
                             [SKAction repeatAction:[self.kaki animationAction] count:6],
                             [SKAction repeatAction:[self.akubi animationAction] count:4],
                             [SKAction repeatActionForever:[self.sleep animationAction]]]];
    [self.currentSprite runAction:idleAction withKey:@"nekoIdle"];
}

- (void)touchDownAtPoint:(CGPoint)location
{
    if ([self.currentSprite actionForKey:@"nekoMoving"]) {
        //stop moving and look surprised
        [self.currentSprite removeActionForKey:@"nekoMoving"];
    }
    if ([self.currentSprite actionForKey:@"nekoIdle"]) {
        //stop moving and look surprised
        [self.currentSprite removeActionForKey:@"nekoIdle"];
    }
    [self showNeko:self.awake];
}

- (void)touchMovedToPoint:(CGPoint)location
{
}

- (void)touchUpAtPoint:(CGPoint)location
{

    NekoAction *action = nil;
    CGSize screenSize = self.frame.size;
    float bearVelocity = screenSize.width / 5.0;
    CGPoint moveDifference = CGPointMake(location.x - self.currentSprite.position.x, location.y - self.currentSprite.position.y);
    float distanceToMove = sqrtf(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y);
    float moveDuration = distanceToMove / bearVelocity;
    action = [self nekoForDirection:moveDifference];
    [self showNeko:action];
    SKAction *moveAction = [SKAction moveTo:location duration:moveDuration];
    SKAction *doneAction = [SKAction runBlock:(dispatch_block_t)^() {
        [self nekoIdle];
    }];
    SKAction *moveActionWithDone = [SKAction sequence:@[moveAction,doneAction]];
    [self.currentSprite runAction:moveActionWithDone withKey:@"nekoMoving"];
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
