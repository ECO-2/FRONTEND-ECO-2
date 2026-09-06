// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'AI-powered plant care';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInAction => 'Sign in';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'email@example.com';

  @override
  String get password => 'Password';

  @override
  String get passwordMinChars => 'min. 8 characters';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get username => 'Username';

  @override
  String get register => 'Sign up';

  @override
  String get noAccountYet => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get enterYourEmail => 'Please enter your email';

  @override
  String get enterYourPassword => 'Please enter your password';

  @override
  String get termsNotice =>
      'By signing up you accept ECO2\'s Terms of Use and Privacy Policy.';

  @override
  String get navStore => 'Store';

  @override
  String get navGarden => 'Garden';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navScanner => 'Scanner';

  @override
  String get navProfile => 'Profile';

  @override
  String get myGarden => 'My Garden';

  @override
  String get viewAll => 'view all';

  @override
  String get addPlant => 'Add Plant';

  @override
  String get gardenEmpty => 'Your garden is empty';

  @override
  String get needsWater => 'Water';

  @override
  String get upToDate => 'Up to date';

  @override
  String get noWateringYet => 'Not watered yet';

  @override
  String get wateringToday => 'Water today';

  @override
  String get wateringOverdue => 'Watering overdue';

  @override
  String get daysWithoutWater => 'days without water';

  @override
  String get daysInYourGarden => 'days in your garden';

  @override
  String get frequency => 'frequency';

  @override
  String get remaining => 'remaining';

  @override
  String get overdue => 'overdue';

  @override
  String get careStatus => 'Care status';

  @override
  String get urgentWatering => 'Needs Water';

  @override
  String get deletePlantTitle => 'Delete plant?';

  @override
  String deletePlantBody(String plantName) {
    return '\"$plantName\" will be removed from your garden. This action cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String lastWateredQuestion(String plantName) {
    return 'When did you last water $plantName?';
  }

  @override
  String get lastWateredHelp =>
      'This is how we work out when the next watering is due. If you\'re not sure, we\'ll start counting from today.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get someDaysAgo => 'A few days ago…';

  @override
  String get neverOrDontRemember => 'Never / can\'t remember';

  @override
  String get lastWatering => 'Last watering';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'ACCOUNT';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editProfileSubtitle => 'Name, bio, photo';

  @override
  String get changePassword => 'Change password';

  @override
  String get biometricAuth => 'Biometric authentication';

  @override
  String get notifications => 'NOTIFICATIONS';

  @override
  String get pushNotifications => 'Push notifications';

  @override
  String get wateringReminders => 'Watering reminders';

  @override
  String get achievementsAndMissions => 'Achievements and missions';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get systemLanguage => 'System language';

  @override
  String get language => 'Language';

  @override
  String get themeAndColors => 'Theme and colours';

  @override
  String get privacyAndData => 'PRIVACY AND DATA';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacySubtitle => 'Personal data controls';

  @override
  String get exportMyData => 'Export my data';

  @override
  String get application => 'APP';

  @override
  String get helpAndSupport => 'Help and support';

  @override
  String get aboutEco2 => 'About ECO2';

  @override
  String get dangerZone => 'DANGER ZONE';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSubtitle => 'This action is permanent';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get profile => 'Profile';

  @override
  String get plants => 'Plants';

  @override
  String get seeds => 'Seeds';

  @override
  String get co2Total => 'Total CO₂';

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String levelWithName(int level, String name) {
    return 'Level $level · $name';
  }

  @override
  String get myTrophies => 'My Trophies';

  @override
  String get trophies => 'Trophies';

  @override
  String get missions => 'Missions';

  @override
  String get achievements => 'Achievements';

  @override
  String get obtained => 'Earned';

  @override
  String get available => 'Available';

  @override
  String get completedPercent => 'Completed';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count day streak',
      one: '1 day streak',
    );
    return '$_temp0';
  }

  @override
  String xpPoints(int xp) {
    return '$xp XP';
  }

  @override
  String seedsCount(int count) {
    return '$count seeds';
  }

  @override
  String get greenFootprint => 'My Green Footprint';

  @override
  String get co2AbsorbedToday => 'CO₂ absorbed today';

  @override
  String get gramsPerDay => 'grams / day';

  @override
  String get contributionPerPlant => 'Contribution per plant';

  @override
  String get weeklyEvolution => 'Weekly evolution';

  @override
  String get weeklyEvolutionHelp =>
      'Reflects when each plant joined your garden.';

  @override
  String get copyMyFootprint => 'Copy my green footprint';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String accumulated(String kg) {
    return 'Accumulated: $kg kg';
  }

  @override
  String get noPlantsYet => 'You don\'t have any plants yet';

  @override
  String get footprintError => 'We couldn\'t work out your green footprint.';

  @override
  String get retry => 'Try again';

  @override
  String get scannerPointAtPlant => 'Point at a plant';

  @override
  String get scannerAnalyzing => 'Analysing...';

  @override
  String get scannerNotInCatalog =>
      'We recognised it, but it\'s not in the ECO2 catalogue yet — we can\'t add it to your garden for now.';

  @override
  String get scannerLowConfidence =>
      'We couldn\'t recognise it confidently. Try again with more light or from closer up.';

  @override
  String get connectionError => 'Connection error. Check your internet.';

  @override
  String get wrongCredentials => 'Incorrect email or password.';

  @override
  String get emailAlreadyUsed => 'This email already has an account.';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get greeting => 'Namaste';

  @override
  String get yourSeeds => 'Your seeds';

  @override
  String get activeMission => 'Active Mission';

  @override
  String get searchSpecies => 'Search species...';

  @override
  String get searchMyPlant => 'Search my plant...';

  @override
  String get exploreSpecies => 'Explore species';

  @override
  String get trendingThisWeek => 'Trending this week';

  @override
  String get allCategory => 'All';

  @override
  String plantsCount(int count) {
    return '$count plants';
  }

  @override
  String needsAttentionToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plants need attention today',
      one: '1 plant needs attention today',
    );
    return '$_temp0';
  }

  @override
  String get view => 'View';

  @override
  String get add => 'Add';

  @override
  String get allUpToDate => 'All up to date!';

  @override
  String get wateringStatus => 'Watering status';

  @override
  String get logEveryCare => 'Log every care action';

  @override
  String get viewHistory => 'View history';

  @override
  String get latestCare => 'Latest care';

  @override
  String get careType => 'Care type';

  @override
  String get suggestedNextWatering => 'Suggested next watering';

  @override
  String get inMyCollectionSince => 'In my collection since';

  @override
  String get howToCareTitle => 'How to care for your plant';

  @override
  String everyNDays(int days) {
    return 'Every $days days';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get noCareLogged => 'No care logged yet.';

  @override
  String get scannerHint => 'Point at a plant';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get notIdentified => 'Not confidently identified';

  @override
  String potsRemaining(int count) {
    return 'Pots remaining: $count';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get todayLabel => 'TODAY';

  @override
  String get thatsAllForNow => 'That\'s all for now';

  @override
  String get noNotifications => 'You have no notifications';

  @override
  String get wateringPending => 'Watering due';

  @override
  String get achievementUnlocked => 'Achievement unlocked!';

  @override
  String get newPlantAdded => 'New plant added';

  @override
  String get seedbed => 'Seedbed';

  @override
  String get redeemSeeds => 'Redeem your seeds for rewards';

  @override
  String get search => 'Search...';

  @override
  String get communityFavorites => 'Community favourites';

  @override
  String get newBadge => 'New';

  @override
  String get yourImpactEquals => 'Your impact is equivalent to:';

  @override
  String treesEquivalent(int count) {
    return '$count Trees';
  }

  @override
  String kilometersEquivalent(int count) {
    return '$count Kilometres';
  }

  @override
  String levelAndTrophies(int level, int trophies) {
    return 'Level $level · $trophies trophies';
  }

  @override
  String get noAchievementsYet =>
      'You haven\'t completed any achievements yet.';

  @override
  String get allAchievementsDone => 'You\'ve unlocked every achievement!';

  @override
  String get noAchievementsConfigured => 'No achievements configured yet.';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get reward => 'Reward';

  @override
  String get achievementUnlockedLabel => 'Achievement unlocked';

  @override
  String get achievementLockedLabel => 'Achievement locked';

  @override
  String get activeMissions => 'Active Missions';

  @override
  String get plantCatalog => 'Plant Catalogue';

  @override
  String get seedStore => 'Seed Store';

  @override
  String get freePlanActive => 'Free plan active';

  @override
  String get user => 'User';

  @override
  String get loading => 'Loading...';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get catTropical => 'Tropical';

  @override
  String get catSucculent => 'Succulent';

  @override
  String get catCactus => 'Cactus';

  @override
  String get catFern => 'Fern';

  @override
  String get catFlowering => 'Flowering';

  @override
  String get catHerb => 'Herb';

  @override
  String get catTree => 'Tree';

  @override
  String get catOther => 'Plant';

  @override
  String get lightLow => 'Low';

  @override
  String get lightMedium => 'Medium';

  @override
  String get lightHigh => 'High';

  @override
  String get lightIndirect => 'Indirect';

  @override
  String lightPrefix(String level) {
    return '$level light';
  }

  @override
  String get difficultyVeryEasy => 'Very easy';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String wateringEveryDays(int days) {
    return 'Water every ${days}d';
  }

  @override
  String get humidityLow => 'Low';

  @override
  String get humidityMedium => 'Medium';

  @override
  String get humidityHigh => 'High';

  @override
  String impactCarTitle(String km) {
    return '$km km by car';
  }

  @override
  String get impactCarSubtitle =>
      'That wouldn\'t need to be driven to emit that CO₂.';

  @override
  String impactBulbTitle(String hours) {
    return '$hours h of LED bulb';
  }

  @override
  String get impactBulbSubtitle => 'Of equivalent electricity use.';

  @override
  String impactTreeTitle(String days) {
    return '$days days of one tree';
  }

  @override
  String get impactTreeSubtitle =>
      'How long a mature tree takes to absorb the same.';

  @override
  String get impactApproxNote =>
      'Approximate equivalences, calculated from your garden\'s CO₂.';

  @override
  String get impactTooSmall =>
      'Your garden hasn\'t yet absorbed enough CO₂ for a useful equivalence.';

  @override
  String accumulatedGrams(String grams) {
    return 'Accumulated: $grams g';
  }

  @override
  String get category => 'Category';

  @override
  String get gallery => 'Gallery';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get cameraPermissionError =>
      'Couldn\'t access the camera or gallery. Check the app permissions.';

  @override
  String get flashAutoHint =>
      'The flash turns on automatically only when taking the photo.';

  @override
  String get showThisGuide => 'Show this guide.';

  @override
  String get upcomingAchievements => 'Upcoming achievements';

  @override
  String get closest => '• CLOSEST';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get quickPay => 'Quick pay';

  @override
  String get oneYearPlus => '1 year of ECO2 Plus';

  @override
  String get whatToDoNow => 'What to do now';

  @override
  String get uploadFromGallery => 'Upload from Gallery';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String careEveryNDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Every day',
    );
    return '$_temp0';
  }

  @override
  String timeAgoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String achievementUnlockedNamed(String name) {
    return 'Achievement unlocked: $name';
  }

  @override
  String purchaseSuccess(String item) {
    return 'Purchase successful: $item';
  }

  @override
  String plantAddedToGarden(String name) {
    return '$name added to your garden! 🌿';
  }

  @override
  String get couldNotAddPlant => 'Couldn\'t add the plant.';

  @override
  String get addNewPlant => 'Add a new plant';

  @override
  String get yourPlantName => 'Your plant\'s name';

  @override
  String potsFreeHint(int count) {
    return '[$count of 10 free pots]';
  }

  @override
  String gramsPerDayShort(String grams) {
    return '$grams g/day';
  }

  @override
  String get difficultyAll => 'All';

  @override
  String get lightHintLow => 'Low-light corners';

  @override
  String get lightHintHigh => 'Near a window';

  @override
  String get lightHintIndirect => 'No direct sun';

  @override
  String get lightHintDefault => 'Filtered light';

  @override
  String get filterByCategory => 'Filter by category';

  @override
  String get speciesNotFound => 'Species not found';
}
