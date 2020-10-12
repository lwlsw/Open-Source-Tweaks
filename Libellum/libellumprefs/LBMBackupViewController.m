#import "LBMBackupViewController.h"

@implementation LBMNoteBackupViewController {
  UIView *_backgroundView;
  UILabel *_titleLabel;
  UITextView *_textView;
  UIButton *_viewBackupButton;
  UIButton *_backupNowButton;
  UIButton *_restoreBackupButton;
  UIButton *_deleteBackupButton;
  UIButton *_closeButton;
}

  -(instancetype)init {
    if(self = [super init]) {
      self.view.translatesAutoresizingMaskIntoConstraints = NO;

      if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
        MTMaterialView *materialView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipeNamed:@"plattersDark" inBundle:nil configuration:1 initialWeighting:1 scaleAdjustment:nil];
        materialView.recipe = 1;
        materialView.recipeDynamic = YES;
        _backgroundView = materialView;
      } else {
        _backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
      }
      _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.view addSubview:_backgroundView];

      _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      _titleLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBlack];
      _titleLabel.numberOfLines = 1;
      _titleLabel.text = @"Backup Management";
      _titleLabel.textAlignment = NSTextAlignmentCenter;
      _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
      _titleLabel.userInteractionEnabled = YES;
      [_titleLabel sizeToFit];
      [self.view addSubview:_titleLabel];

      _textView = [[UITextView alloc] initWithFrame:CGRectZero];
      _textView.backgroundColor = [UIColor clearColor];
      _textView.editable = NO;
      _textView.font = [UIFont systemFontOfSize:14];
      _textView.scrollEnabled = YES;
      _textView.textAlignment = NSTextAlignmentLeft;
      _textView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.view addSubview:_textView];
      [self lastBackupUpText];

      if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){13, 0, 0}]) {
        _titleLabel.textColor = [UIColor labelColor];
        _textView.textColor = [UIColor secondaryLabelColor];
        [self setModalInPresentation:YES];
      }

      _viewBackupButton = [UIButton buttonWithType:UIButtonTypeSystem];
      _viewBackupButton.clipsToBounds = YES;
      _viewBackupButton.backgroundColor = Pri_Color;
      _viewBackupButton.layer.cornerRadius = 5;
      _viewBackupButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
      _viewBackupButton.tintColor = [UIColor whiteColor];
      _viewBackupButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_viewBackupButton addTarget:self action:@selector(viewBackupNotes) forControlEvents:UIControlEventTouchUpInside];
      [_viewBackupButton setTitle:@"View Notes Backup" forState:UIControlStateNormal];
      [self.view addSubview:_viewBackupButton];

      _backupNowButton = [UIButton buttonWithType:UIButtonTypeSystem];
      _backupNowButton.clipsToBounds = YES;
      _backupNowButton.backgroundColor = Pri_Color;
      _backupNowButton.layer.cornerRadius = 5;
      _backupNowButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
      _backupNowButton.tintColor = [UIColor whiteColor];
      _backupNowButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_backupNowButton addTarget:self action:@selector(backupNotesNow) forControlEvents:UIControlEventTouchUpInside];
      [_backupNowButton setTitle:@"Backup Notes Now" forState:UIControlStateNormal];
      [self.view addSubview:_backupNowButton];

      _restoreBackupButton = [UIButton buttonWithType:UIButtonTypeSystem];
      _restoreBackupButton.clipsToBounds = YES;
      _restoreBackupButton.backgroundColor = Pri_Color;
      _restoreBackupButton.layer.cornerRadius = 5;
      _restoreBackupButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
      _restoreBackupButton.tintColor = [UIColor whiteColor];
      _restoreBackupButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_restoreBackupButton addTarget:self action:@selector(restoreBackupNotes) forControlEvents:UIControlEventTouchUpInside];
      [_restoreBackupButton setTitle:@"Restore Notes From Backup" forState:UIControlStateNormal];
      [self.view addSubview:_restoreBackupButton];

      _deleteBackupButton = [UIButton buttonWithType:UIButtonTypeSystem];
      _deleteBackupButton.clipsToBounds = YES;
      _deleteBackupButton.backgroundColor = Pri_Color;
      _deleteBackupButton.layer.cornerRadius = 5;
      _deleteBackupButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
      _deleteBackupButton.tintColor = [UIColor whiteColor];
      _deleteBackupButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_deleteBackupButton addTarget:self action:@selector(deleteBackupNotes) forControlEvents:UIControlEventTouchUpInside];
      [_deleteBackupButton setTitle:@"Delete Notes Backup" forState:UIControlStateNormal];
      [self.view addSubview:_deleteBackupButton];

      _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
      _closeButton.clipsToBounds = YES;
      _closeButton.backgroundColor = Pri_Color;
      _closeButton.layer.cornerRadius = 5;
      _closeButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
      _closeButton.tintColor = [UIColor whiteColor];
      _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
      [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
      [_closeButton setTitle:@"Done" forState:UIControlStateNormal];
      [self.view addSubview:_closeButton];

      UITapGestureRecognizer *dontTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quack)];
      dontTap.numberOfTapsRequired = 1;

      [NSLayoutConstraint activateConstraints:@[
        [_backgroundView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [_backgroundView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],

        [_titleLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:30],
        [_titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],

        [_textView.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:22],
        [_textView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_textView.widthAnchor constraintEqualToConstant:330],
        [_textView.heightAnchor constraintEqualToConstant:180],

        [_viewBackupButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_viewBackupButton.widthAnchor constraintEqualToConstant:330],
        [_viewBackupButton.heightAnchor constraintEqualToConstant:50],

        [_backupNowButton.topAnchor constraintEqualToAnchor:_viewBackupButton.bottomAnchor constant:10],
        [_backupNowButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_backupNowButton.widthAnchor constraintEqualToConstant:330],
        [_backupNowButton.heightAnchor constraintEqualToConstant:50],

        [_restoreBackupButton.topAnchor constraintEqualToAnchor:_backupNowButton.bottomAnchor constant:10],
        [_restoreBackupButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_restoreBackupButton.widthAnchor constraintEqualToConstant:330],
        [_restoreBackupButton.heightAnchor constraintEqualToConstant:50],

        [_deleteBackupButton.topAnchor constraintEqualToAnchor:_restoreBackupButton.bottomAnchor constant:10],
        [_deleteBackupButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_deleteBackupButton.widthAnchor constraintEqualToConstant:330],
        [_deleteBackupButton.heightAnchor constraintEqualToConstant:50],

        [_closeButton.topAnchor constraintEqualToAnchor:_deleteBackupButton.bottomAnchor constant:10],
        [_closeButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_closeButton.widthAnchor constraintEqualToConstant:330],
        [_closeButton.heightAnchor constraintEqualToConstant:50],
        [_closeButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-40],
      ]];
    }

    return self;
  }

  -(void)animateTextChangeTo:(id)text {
    NSMutableAttributedString *attributedText;
    if([text isKindOfClass:[NSString class]]) {
      attributedText = [[NSMutableAttributedString alloc] initWithString:text];
      [attributedText addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} range:(NSRange){0, attributedText.length}];
    } else {
      attributedText = text;
    }

    [attributedText addAttributes:@{NSForegroundColorAttributeName: _textView.textColor} range:(NSRange){0, attributedText.length}];

    [UIView transitionWithView:_textView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      _textView.attributedText = attributedText;
    } completion:nil];
  }

  -(void)lastBackupUpText {
    if([[NSFileManager defaultManager] fileExistsAtPath:filePathBK]) {
      NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePathBK error:nil];
      NSDate *lastModified = [fileAttributes objectForKey:NSFileModificationDate];
      NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
      [timeFormatter setDateFormat:@"h:mm a zzz"];
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"MMMM d, yyyy"];

      [self animateTextChangeTo:[NSString stringWithFormat:@"You last backed up your notes on %@ at %@.", [dateFormatter stringFromDate:lastModified], [timeFormatter stringFromDate:lastModified]]];
    } else {
      [self animateTextChangeTo:@"Your notes have never been backed up."];
    }
  }

  -(IBAction)viewBackupNotes {
    NSError *error = nil;
    NSMutableAttributedString *backupContent = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:filePathBK] options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} documentAttributes:nil error:&error];
    if(error) {
      [self animateTextChangeTo:[NSString stringWithFormat:@"Error viewing backed up notes:\n\n%@\n\nThere is no backup of your notes.", error]];
    } else {
      [self animateTextChangeTo:backupContent];
    }
  }

  -(IBAction)backupNotesNow {
    NSError *error = nil;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} documentAttributes:nil error:&error];
    NSData *data = [content dataFromRange:(NSRange){0, content.length} documentAttributes:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} error:&error];
    [data writeToFile:filePathBK atomically:YES];

    if(error) {
      [self animateTextChangeTo:[NSString stringWithFormat:@"Error backing up notes:\n\n%@", error]];
    } else {
      [self lastBackupUpText];
    }
  }

  -(IBAction)restoreBackupNotes {
    UIAlertController *cautionAlert = [UIAlertController alertControllerWithTitle:@"Restore" message:@"Are you sure you want to restore the backup of your notes? This will delete your current notes and respring your device." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      NSError *error = nil;
      NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:filePathBK] options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} documentAttributes:nil error:&error];
      NSData *data = [content dataFromRange:(NSRange){0, content.length} documentAttributes:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} error:&error];
      [data writeToFile:filePath atomically:YES];
      if(error) {
        [self animateTextChangeTo:[NSString stringWithFormat:@"Error restoring backed up notes:\n\n%@", error]];
      } else {
        [HBRespringController respring];
      }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [cautionAlert addAction:confirmAction];
    [cautionAlert addAction:cancelAction];
    [self presentViewController:cautionAlert animated:YES completion:nil];
  }

  -(IBAction)deleteBackupNotes {
    UIAlertController *cautionAlert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete the backup of your notes?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      NSError *error = nil;
      [[NSFileManager defaultManager] removeItemAtPath:filePathBK error:&error];
      if(error) {
        [self animateTextChangeTo:[NSString stringWithFormat:@"Error deleting backed up notes:\n\n%@", error]];
      } else {
        [self animateTextChangeTo:@"Backup deleted successfully."];
      }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [cautionAlert addAction:confirmAction];
    [cautionAlert addAction:cancelAction];
    [self presentViewController:cautionAlert animated:YES completion:nil];
  }

  -(IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
@end
