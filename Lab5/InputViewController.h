//
//  InputViewController.h
//  Lab4
//
//  Created by Adrian on 3/20/15.
//  Copyright (c) 2015 Adrian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputCompletionHandler)(NSString *quoteText, NSString *authorText);

@interface InputViewController : UIViewController
@property(copy, nonatomic) InputCompletionHandler completionHandler;
@end
