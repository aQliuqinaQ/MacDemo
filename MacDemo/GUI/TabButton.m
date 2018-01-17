//
//  TabButton.m
//  MacDemo
//
//  Created by liuqin on 2018/1/17.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "TabButton.h"
@interface TabButton (){
    
    __weak IBOutlet NSButton *_imageBtn;
}

@end
@implementation TabButton
-(instancetype)initWithFrame:(NSRect)frameRect image:(NSImage *)image title:(NSString *)title tag:(NSString *)identifier{
    if(self = [super initWithFrame:frameRect]){
        NSNib * nib = [[NSNib alloc] initWithNibNamed:@"TabButton" bundle:nil];
        NSArray * topLevelObjects;
        if([nib instantiateWithOwner:self topLevelObjects:&topLevelObjects]){
            for(id topLevelObject in topLevelObjects){
                if([topLevelObject isKindOfClass:[TabButton class]]){
                    self = topLevelObject;
                    break;
                }
            }
        }
        self.frame = frameRect;
        _imageBtn.image = image;
        _imageBtn.title = title;
        self.identifier = identifier;
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor redColor].CGColor;
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
- (IBAction)closeView:(id)sender {
    if([self.delegate respondsToSelector:@selector(onClickTabCloseBtn:)]){
        [self.delegate onClickTabCloseBtn:self.identifier];
    }
}
- (IBAction)onClickTabBtn:(id)sender {
    if([self.delegate respondsToSelector:@selector(selecteTabBtn:)]){
        [self.delegate selecteTabBtn:self.identifier];
    }
}

@end
