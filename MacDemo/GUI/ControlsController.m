//
//  ControlsController.m
//  MacDemo
//
//  Created by liuqin on 2019/2/18.
//  Copyright © 2019 liuqin. All rights reserved.
//

#import "ControlsController.h"

@interface ControlsController ()<NSComboBoxDelegate,NSComboBoxDataSource,NSTextFieldDelegate>{
    NSPopover *pop;
    __weak IBOutlet NSTextField *_filePathTF;
}
@property(nonatomic,strong)NSDatePicker *datePicker;
@property (weak) IBOutlet NSImageView *imageView;
@property(nonatomic,strong)NSArray *datas;
@end

@implementation ControlsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //日历控件
    if (_datePicker == nil) {
        _datePicker = [[NSDatePicker alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];//坑，不管设置多大，frame都不会变
        _datePicker.datePickerStyle = NSDatePickerStyleTextFieldAndStepper;
        _datePicker.datePickerElements = NSDatePickerElementFlagYearMonthDay|NSDatePickerElementFlagHourMinuteSecond;
        _datePicker.datePickerMode = NSDatePickerModeRange;
        _datePicker.dateValue = [NSDate date];
        _datePicker.maxDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30*12];
        _datePicker.minDate = [NSDate dateWithTimeIntervalSince1970:0];
        _datePicker.target = self;//坑，不设置target，action会不响应
        [_datePicker setAction:@selector(updateDateResult:)];
    }
    [self.view addSubview:_datePicker];
    [_datePicker mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(100);
    }];
    
    //下拉列表
    //初始化数据
    self.datas = @[
                   @"羊肉泡馍",
                   @"油泼扯面",
                   @"板栗烧鸡",
                   @"豆腐花",
                   ];
    NSComboBox *comboBox = [[NSComboBox alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];//高度好像不起作用,宽度只对box内容有效
    comboBox.numberOfVisibleItems = 3;
    comboBox.stringValue = @"请选择--";
    comboBox.usesDataSource = YES;
    comboBox.dataSource = self;
    comboBox.delegate = self;
    [self.view addSubview:comboBox];
    [comboBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_datePicker.mas_right).offset(20);
        make.top.equalTo(_datePicker);
    }];

    //radio
    NSButton *radioBtn = [NSButton radioButtonWithTitle:@"单选" target:self action:@selector(onClickRadioBtn:)];
    [self.view addSubview:radioBtn];
    [radioBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_datePicker.mas_right).offset(140);
        make.top.equalTo(_datePicker);
    }];
    
    //checkbox
    NSButton *checkbox = [NSButton checkboxWithTitle:@"多选" target:self action:@selector(onClickCheckBox:)];
    [self.view addSubview:checkbox];
    [checkbox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_datePicker.mas_right).offset(200);
        make.top.equalTo(_datePicker);
    }];
    
    //Slider
    NSSlider *slider = [[NSSlider alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    slider.sliderType = NSSliderTypeLinear;
    slider.numberOfTickMarks = 24;
    slider.tickMarkPosition = NSTickMarkPositionAbove;
    slider.maxValue = 100;
    slider.minValue = 0;
    slider.allowsTickMarkValuesOnly = YES;
    slider.target = self;
    slider.action = @selector(sliderValueChanged:);
    [self.view addSubview:slider];
    [slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_datePicker);
        make.top.equalTo(_datePicker.mas_bottom).offset(20);
    }];
}

- (void)updateDateResult:(NSDatePicker *)datePicker{
    //坑，datepicker的style为图形界面时，action会响应2次，mouse down和mouse up会各响应一次
    // 拿到当前选择的日期
    NSDate *theDate = [datePicker dateValue];
    
    NSLog(@"日期：%@",theDate);
    
    if (theDate) {
        
        // 把选择的日期格式化成想要的形式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSString *dateString = [formatter stringFromDate:theDate];
        
        NSLog(@"日期：%@",dateString);
        
    }
}
#pragma mark - NSComboBoxDataSource

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    
    return [self.datas count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
    
    return self.datas[index];
}


#pragma mark - NSComboBoxDelegate

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    
    
    NSComboBox *comboBox = notification.object;
    NSInteger selectedIndex = comboBox.indexOfSelectedItem;
    
    NSLog(@"comboBoxSelectionDidChange selected item %@",self.datas[selectedIndex]);
}
- (void)comboBoxSelectionIsChanging:(NSNotification *)notification {
    
    NSComboBox *comboBox = notification.object;
    NSInteger selectedIndex = comboBox.indexOfSelectedItem;
    
    NSLog(@"comboBoxSelectionIsChanging selected item %@",self.datas[selectedIndex]);
}
-(void)controlTextDidChange:(NSNotification*)notification
{
    id object = [notification object];
    NSLog(@"notification : %@",notification);
}

- (void)onClickRadioBtn:(NSButton *)btn{
    NSLog(@"");
}
- (void)onClickCheckBox:(NSButton *)btn{
    if (btn.state == NSControlStateValueOn) {
        NSLog(@"点击多选");
    }else{
        NSLog(@"取消多选");
    }
    
}
- (void)sliderValueChanged:(NSSlider *)slider{
    if (pop == nil) {
        NSViewController *popController = [[NSViewController alloc] initWithNibName:nil bundle:nil];
        NSTextField * textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 25)];
        textField.editable = NO;
        popController.view = textField;
        pop = [[NSPopover alloc] init];
        pop.contentViewController = popController;
        pop.behavior = NSPopoverBehaviorSemitransient;
    }
    NSTextField *tf = (NSTextField *)pop.contentViewController.view;
    tf.stringValue = [NSString stringWithFormat:@"%f",slider.floatValue];
    float allLength = slider.bounds.size.width;
    float ratio = (slider.doubleValue - slider.minValue) / (slider.maxValue - slider.minValue);
    float leftWidth = allLength * ratio;
    NSRect targetRect = NSMakeRect(leftWidth, 0, 10, 10);
    [pop showRelativeToRect:targetRect ofView:slider preferredEdge:NSRectEdgeMinY];
    
}
- (IBAction)pickerFile:(id)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    [panel setAllowsMultipleSelection:YES];  //是否允许多选file
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSMutableArray* filePaths = [[NSMutableArray alloc] init];
            for (NSURL* elemnet in [panel URLs]) {
                [filePaths addObject:[elemnet path]];
            }
            
            NSLog(@"filePaths : %@",filePaths);
            _filePathTF.stringValue = filePaths[0];
        }
        
    }];
}
- (IBAction)saveFile:(id)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.title = @"保存图片";
    [panel setMessage:@"选择图片保存地址"];//提示文字
    
    [panel setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"]]];//设置默认打开路径
    
    [panel setNameFieldStringValue:@"123"];
    [panel setAllowsOtherFileTypes:YES];
    [panel setAllowedFileTypes:@[@"jpg",@"png"]];
    [panel setExtensionHidden:NO];
    [panel setCanCreateDirectories:YES];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result){
        if (result == NSModalResponseOK)
        {
            NSString *path = [[panel URL] path];
            NSData *tiffData = [self.imageView.image TIFFRepresentation];
            [tiffData writeToFile:path atomically:YES];
        }
    }];
}
@end
