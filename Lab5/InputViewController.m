//
//  InputViewController.m
//  Lab4
//
//  Created by Adrian on 3/20/15.
//  Copyright (c) 2015 Adrian. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *quoteField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *authorField;

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.quoteField becomeFirstResponder];
    self.saveButton.enabled = NO;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.quoteField){
        
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        [self validateSaveButtonForText1: changedString forText2: self.authorField.text];
    }else if(textField == self.authorField){
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self validateSaveButtonForText1: changedString forText2: self.quoteField.text];
    }
    return YES;
}

-(void) validateSaveButtonForText1: (NSString *) text1 forText2: (NSString *) text2 {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    self.saveButton.enabled = ([[text1 stringByTrimmingCharactersInSet:set] length] > 0) && ([[text2 stringByTrimmingCharactersInSet:set] length] > 0);
}

- (IBAction)saveButtonTapped:(id)sender {
    if(self.completionHandler){
        self.completionHandler(self.quoteField.text,self.authorField.text);
    }
}
- (IBAction)CancelButtonTapped:(id)sender {
    if(self.completionHandler){
        self.completionHandler(nil,nil);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
