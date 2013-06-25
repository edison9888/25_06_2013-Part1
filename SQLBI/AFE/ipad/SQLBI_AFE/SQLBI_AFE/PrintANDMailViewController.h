//
//  PrintANDMailViewController.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PrintANDMailViewDelegate <NSObject>
-(void)printButtonClicked;
-(void)mailButtonClicked;
@end

@interface PrintANDMailViewController : UIViewController
@property(nonatomic,assign)id <PrintANDMailViewDelegate> delegate;

@end
