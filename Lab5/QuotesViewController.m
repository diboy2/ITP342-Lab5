//
//  ViewController.m
//  Lab3
//
//  Created by Adrian on 2/24/15.
//  Copyright (c) 2015 Adrian. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "QuotesViewController.h"
#import "QuotesModel.h"
@interface QuotesViewController ()
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *quotesLabel;
@property(strong,nonatomic) QuotesModel *model;

@end

@implementation QuotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [QuotesModel sharedModel];
    // Create Sound file Path
    NSString *path = [NSString stringWithFormat:@"%@/tone.mp3",[[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Initialize audio Player
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(singleTapRecognized:)];
    [self.view addGestureRecognizer:singleTap];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(leftSwipeGestureRecognized:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(rightSwipeGestureRecognized:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    NSDictionary *currentQuoteDict = [self.model randomQuote];
    NSString *quote = currentQuoteDict[@"quote"];
    NSString *author = currentQuoteDict[@"author"];
    self.quotesLabel.text = quote;
    self.authorLabel.text = author;
    self.quotesLabel.textColor = UIColor.blackColor;
    self.authorLabel.textColor = UIColor.blackColor;
    // Testing
    
    NSLog(@"For Testing");
    NSLog(@"Number quotes: %ld",[self.model numberOfQuotes]);
    NSLog(@"Inserting a quote now at index 0. The number of quotes should change" );
    [self.model insertQuote:@"The most boring thing in the entire world is nudity." author:@"George Burns" atIndex:0];
    NSLog(@"Number quotes: %ld",[self.model numberOfQuotes]);
    NSLog(@"Removing a quote now at index 0. The number of quotes should be less now.");
    [self.model removeQuoteAtIndex:0];
    NSLog(@"Number quotes: %ld",[self.model numberOfQuotes]);
    NSLog(@"Adding in quote again by passing the dictionary. The number of quotes should be more now.");
    NSDictionary *testQuote = @{    @"quote":@"The most boring thing in the entire world is nudity.",
                                    @"author":@"George Burns"
                                    };
    [self.model insertQuote:testQuote atIndex:0];
    NSLog(@"Number quotes: %ld",[self.model numberOfQuotes]);
    NSString *quoteString = @"";
    quoteString = [quoteString stringByAppendingString:@"The quote at the index 0 that I inserted in is '"];
    NSDictionary *testQuoteDict = [self.model quoteAtIndex:0];
    quoteString = [quoteString stringByAppendingString:testQuoteDict[@"quote"]];
    quoteString = [quoteString stringByAppendingString:@"'. The author is "];
    quoteString = [quoteString stringByAppendingString:testQuoteDict[@"author"]];
    quoteString = [quoteString stringByAppendingString:@"."];
    NSLog(quoteString,nil);
    [self.model removeQuoteAtIndex:0];
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *currentQuoteDict = [self.model randomQuote];
    NSString *quote = currentQuoteDict[@"quote"];
    NSString *author = currentQuoteDict[@"author"];
    self.quotesLabel.text = quote;
    self.authorLabel.text = author;
    self.quotesLabel.textColor = UIColor.blackColor;
    self.authorLabel.textColor = UIColor.blackColor;
}
- (void) singleTapRecognized: (UITapGestureRecognizer *) recognizer{
    NSDictionary *currentQuoteDict = [self.model randomQuote];
    //Testing
    NSString *quoteString = @"";
    quoteString = [quoteString stringByAppendingString:@"The random quote is '"];
    NSDictionary *testQuoteDict = currentQuoteDict;;
    quoteString = [quoteString stringByAppendingString:testQuoteDict[@"quote"]];
    quoteString = [quoteString stringByAppendingString:@"'. The author is "];
    quoteString = [quoteString stringByAppendingString:testQuoteDict[@"author"]];
    quoteString = [quoteString stringByAppendingString:@"."];
    NSLog(quoteString,nil);    NSString *quote = currentQuoteDict[@"quote"];
    NSString *author = currentQuoteDict[@"author"];
    // play audio
    [self.audioPlayer play];
    [self animateQuote:quote animateAuthor:author];
}

- (void) leftSwipeGestureRecognized: (UITapGestureRecognizer *) recognizer{
    NSDictionary *currentQuoteDict = [self.model prevQuote];
    //Testing
    NSString *quoteString = @"";
    quoteString = [quoteString stringByAppendingString:@"The prev quote is '"];
    NSDictionary *testQuoteDict = currentQuoteDict;;
    quoteString = [quoteString stringByAppendingString:testQuoteDict[@"quote"]];
    quoteString = [quoteString stringByAppendingString:@"'. The author is "];
    quoteString = [quoteString stringByAppendingString:testQuoteDict[@"author"]];
    quoteString = [quoteString stringByAppendingString:@"."];
    NSLog(quoteString,nil);    NSString *quote = currentQuoteDict[@"quote"];
    NSString *author = currentQuoteDict[@"author"];
    [self.audioPlayer play];
    [self animateQuote:quote animateAuthor:author];
}

- (void) rightSwipeGestureRecognized: (UITapGestureRecognizer *) recognizer{
    NSDictionary *currentQuoteDict = [self.model nextQuote];
    //Testing
    NSString *quoteString = @"";
    quoteString = [quoteString stringByAppendingString:@"The next quote is '"];
    NSDictionary *testQuoteDict = currentQuoteDict;;
    quoteString = [quoteString stringByAppendingString:testQuoteDict[@"quote"]];
    quoteString = [quoteString stringByAppendingString:@"'. The author is "];
    quoteString = [quoteString stringByAppendingString:testQuoteDict[@"author"]];
    quoteString = [quoteString stringByAppendingString:@"."];
    NSLog(quoteString,nil);
    NSString *quote = currentQuoteDict[@"quote"];
    NSString *author = currentQuoteDict[@"author"];
    [self.audioPlayer play];
    [self animateQuote:quote animateAuthor:author];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [self becomeFirstResponder];
}

- (void) motionEnded: (UIEventSubtype) motion withEvent: (UIEvent *) event{
    if (motion == UIEventSubtypeMotionShake){
        NSDictionary *currentQuoteDict = [self.model randomQuote];
        NSString *quote = currentQuoteDict[@"quote"];
        NSString *author = currentQuoteDict[@"author"];
        [self.audioPlayer play];
        [self animateQuote:quote animateAuthor:author];
    }
}

- (void) displayQuote: (NSString *) quote displayAuthor: (NSString *) author{
    self.quotesLabel.alpha = 0;
    self.quotesLabel.text = quote;
    self.authorLabel.alpha = 0;
    self.authorLabel.text = author;
    [UIView animateWithDuration:1.0 animations:^{
        self.quotesLabel.alpha = 1;
        self.authorLabel.alpha = 1;
    }];
}

- (void) animateQuote: (NSString *) quote animateAuthor: (NSString *) author{
    self.quotesLabel.alpha = 0;
    self.authorLabel.alpha = 0;
    self.quotesLabel.text = quote;
    self.authorLabel.text = author;
    
    if(self.quotesLabel.textColor == UIColor.blackColor){
        self.quotesLabel.textColor = UIColor.redColor;
        self.authorLabel.textColor = UIColor.redColor;
    }
    else{
        self.quotesLabel.textColor = UIColor.blackColor;
        self.authorLabel.textColor = UIColor.blackColor;
    }
    
    [UIView animateWithDuration:3.0 animations:
     ^{
         self.quotesLabel.alpha = 1;
         self.authorLabel.alpha = 1;
     }
     ];
    
}



@end
