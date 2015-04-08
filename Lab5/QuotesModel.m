//
//  QuotesModel.m
//  Lab3
//
//  Created by Adrian on 2/24/15.
//  Copyright (c) 2015 Adrian. All rights reserved.
//

#import "QuotesModel.h"
// class extension
@interface QuotesModel ()
// private properties
@property(strong, nonatomic)NSMutableArray *quotes;
@property(strong, nonatomic)NSDictionary *currentQuote;
@property NSUInteger currentIndex;
@property(strong, nonatomic)NSMutableArray *favorites;
@property (strong, nonatomic) NSString *filepath;
@end

// Dictionary keys
NSString *const QuoteKey = @"quote";
NSString *const AuthorKey = @"author";

// plist Filename
NSString *const QuotesPlist = @"quotes.plist";

@implementation QuotesModel
+(instancetype) sharedModel {
    static QuotesModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // thread safe
        _sharedModel = [[self alloc] init];
        
    });
    
    return _sharedModel;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _filepath = [documentsDirectory stringByAppendingPathComponent:QuotesPlist];
        _quotes = [NSMutableArray arrayWithContentsOfFile:_filepath];
        _favorites = [[NSMutableArray alloc] init];
        
        if(!_quotes) { // no file
            _quotes = [[NSMutableArray alloc] initWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Clint Eastwood",@"author",@"There's only one way to have a happy mariage and as soon as I learn what it is I'll get married again.",@"quote",nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"The cars", @"author",@"Life's the same, except for the shoes",@"quote", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Mark Twain",@"author",@"Go to Heaven for the climate, Hell for the company.",@"quote", nil],
                    nil];
        }
        
        self.currentIndex = 0;
    }
    return self;
}
- (void) save{
    [self.quotes writeToFile:self.filepath atomically:YES];
}

- (void) removeFavoriteAtIndex: (NSUInteger) index{
    NSUInteger numberOfFavorites = [self numberOfFavorites];
    if(index < numberOfFavorites){
        [self.favorites removeObjectAtIndex:index];
    }
}

- (NSUInteger) numberOfFavorites{
    return [self.favorites count];
}

- (void) insertFavorite: (NSString *) quote author: (NSString *) author atIndex: (NSUInteger) index{
    NSUInteger numOfFavorites = [self numberOfFavorites];
    if(index <= numOfFavorites){
        [self.favorites
         insertObject:[NSDictionary dictionaryWithObjectsAndKeys:author,@"author",quote,@"quote", nil]
         atIndex:index];
    }
}

- (void) insertFavorite: (NSDictionary *) quote atIndex: (NSUInteger) index{
    NSUInteger numOfFavorites = [self numberOfFavorites];
    if(index <= numOfFavorites){
        [self.favorites
         insertObject:quote
         atIndex:index];
    }
}

- (NSDictionary *) favoriteAtIndex: (NSUInteger) index{
    return [self.favorites objectAtIndex:index];
}

-(void) addQuoteToFavorites{
    if([self numberOfQuotes])
    {
        [self insertFavorite:[self quoteAtIndex:self.currentIndex] atIndex:0];
    }
}

- (NSDictionary *) randomQuote{
    if([self numberOfQuotes]){
        NSUInteger index = random() % [self numberOfQuotes];
        self.currentIndex = index;
        return [self quoteAtIndex:index];
    }
    else{
        NSDictionary *emptyQuoteAlert = @{
                         @"quote": @"Quotes model is empty of quotes",
                         @"author": @""
                         };
        return  emptyQuoteAlert ;
    }
    
    
}

- (NSUInteger) numberOfQuotes{
    return [self.quotes count];
}

- (NSDictionary *) quoteAtIndex: (NSUInteger) index{
    return [self.quotes objectAtIndex:index];
}

- (void) removeQuoteAtIndex: (NSUInteger) index{
    NSUInteger numOfQuotes = [self numberOfQuotes];
    if(index < numOfQuotes){
        [self.quotes removeObjectAtIndex:index];
        [self save];
    }
    
}

- (void) insertQuote: (NSString *) quote author: (NSString *) author atIndex: (NSUInteger) index{
    NSUInteger numOfQuotes = [self numberOfQuotes];
    if(index <= numOfQuotes){
        [self.quotes
         insertObject:[NSDictionary dictionaryWithObjectsAndKeys:author,@"author",quote,@"quote", nil]
         atIndex:index];
        [self save];
    }
    
}

- (void) insertQuote: (NSDictionary *) quote atIndex: (NSUInteger) index{
    NSUInteger numOfQuotes = [self numberOfQuotes];
    if(index <= numOfQuotes){
        [self.quotes
         insertObject:quote
         atIndex:index];
        [self save];
    }
}

- (NSDictionary *) nextQuote{
    self.currentIndex = (self.currentIndex + 1) % [self numberOfQuotes];
    return [self.quotes objectAtIndex:self.currentIndex];
}

- (NSDictionary *) prevQuote{
    
    if(self.currentIndex == 0){
        self.currentIndex = [self numberOfQuotes] -1;
    }else{
        self.currentIndex = (self.currentIndex - 1);
    }
    
    return [self.quotes objectAtIndex:self.currentIndex];
}



@end
