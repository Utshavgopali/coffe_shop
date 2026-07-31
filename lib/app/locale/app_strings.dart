import 'locale_state.dart';

class AppStrings {
  AppStrings._();

  static const Map<String, Map<AppLanguage, String>> _values = {
    // ---- Shared / settings ----
    'language': {
      AppLanguage.english: 'Language',
      AppLanguage.nepali: 'भाषा',
    },
    'theme': {
      AppLanguage.english: 'Theme',
      AppLanguage.nepali: 'थिम',
    },
    'light': {
      AppLanguage.english: 'Light',
      AppLanguage.nepali: 'उज्यालो',
    },
    'dark': {
      AppLanguage.english: 'Dark',
      AppLanguage.nepali: 'अँध्यारो',
    },
    'auto': {
      AppLanguage.english: 'Auto',
      AppLanguage.nepali: 'स्वचालित',
    },
    'autoBrightness': {
      AppLanguage.english: 'Auto brightness',
      AppLanguage.nepali: 'स्वचालित उज्यालोपन',
    },
    'retry': {
      AppLanguage.english: 'Retry',
      AppLanguage.nepali: 'पुनः प्रयास गर्नुहोस्',
    },
    'seeAll': {
      AppLanguage.english: 'See all',
      AppLanguage.nepali: 'सबै हेर्नुहोस्',
    },
    'somethingWentWrong': {
      AppLanguage.english: 'Something went wrong',
      AppLanguage.nepali: 'केही गलत भयो',
    },

    // ---- Profile screen ----
    'chooseFromGallery': {
      AppLanguage.english: 'Choose from Gallery',
      AppLanguage.nepali: 'ग्यालेरीबाट छान्नुहोस्',
    },
    'takeAPhoto': {
      AppLanguage.english: 'Take a Photo',
      AppLanguage.nepali: 'फोटो खिच्नुहोस्',
    },
    'failedToPickImage': {
      AppLanguage.english: 'Failed to pick image',
      AppLanguage.nepali: 'तस्बिर छान्न असफल भयो',
    },
    'profileUpdatedSuccessfully': {
      AppLanguage.english: 'Profile updated successfully!',
      AppLanguage.nepali: 'प्रोफाइल सफलतापूर्वक अद्यावधिक भयो!',
    },
    'failedToUpdateProfile': {
      AppLanguage.english: 'Failed to update profile details',
      AppLanguage.nepali: 'प्रोफाइल विवरण अद्यावधिक गर्न असफल भयो',
    },
    'confirmYourPassword': {
      AppLanguage.english: 'Confirm your password',
      AppLanguage.nepali: 'आफ्नो पासवर्ड पुष्टि गर्नुहोस्',
    },
    'enterPasswordToEnableFingerprint': {
      AppLanguage.english: 'For your security, please enter your password to enable fingerprint login.',
      AppLanguage.nepali: 'तपाईंको सुरक्षाको लागि, फिंगरप्रिन्ट लगइन सक्षम गर्न कृपया आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्।',
    },
    'password': {
      AppLanguage.english: 'Password',
      AppLanguage.nepali: 'पासवर्ड',
    },
    'cancel': {
      AppLanguage.english: 'Cancel',
      AppLanguage.nepali: 'रद्द गर्नुहोस्',
    },
    'pleaseEnterYourPassword': {
      AppLanguage.english: 'Please enter your password',
      AppLanguage.nepali: 'कृपया आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्',
    },
    'incorrectPassword': {
      AppLanguage.english: 'Incorrect password',
      AppLanguage.nepali: 'गलत पासवर्ड',
    },
    'confirm': {
      AppLanguage.english: 'Confirm',
      AppLanguage.nepali: 'पुष्टि गर्नुहोस्',
    },
    'noFingerprintSetUp': {
      AppLanguage.english: 'No fingerprint set up on this device. Add one in your phone settings first.',
      AppLanguage.nepali: 'यो उपकरणमा कुनै फिंगरप्रिन्ट सेटअप छैन। पहिले फोनको सेटिङमा एउटा थप्नुहोस्।',
    },
    'confirmFingerprintToEnable': {
      AppLanguage.english: 'Confirm your fingerprint to enable fingerprint login',
      AppLanguage.nepali: 'फिंगरप्रिन्ट लगइन सक्षम गर्न आफ्नो फिंगरप्रिन्ट पुष्टि गर्नुहोस्',
    },
    'fingerprintLogin': {
      AppLanguage.english: 'Fingerprint login',
      AppLanguage.nepali: 'फिंगरप्रिन्ट लगइन',
    },
    'coffeeBeansProfile': {
      AppLanguage.english: 'CoffeeBeans Profile',
      AppLanguage.nepali: 'कफीबीन्स प्रोफाइल',
    },
    'personalDetails': {
      AppLanguage.english: 'Personal details',
      AppLanguage.nepali: 'व्यक्तिगत विवरण',
    },
    'fullNameLabel': {
      AppLanguage.english: 'FULL NAME',
      AppLanguage.nepali: 'पूरा नाम',
    },
    'enterYourFullName': {
      AppLanguage.english: 'Enter your full name',
      AppLanguage.nepali: 'आफ्नो पूरा नाम प्रविष्ट गर्नुहोस्',
    },
    'nameIsRequired': {
      AppLanguage.english: 'Name is required',
      AppLanguage.nepali: 'नाम आवश्यक छ',
    },
    'saveChanges': {
      AppLanguage.english: 'Save Changes',
      AppLanguage.nepali: 'परिवर्तनहरू सुरक्षित गर्नुहोस्',
    },
    'myOrders': {
      AppLanguage.english: 'My Orders',
      AppLanguage.nepali: 'मेरा अर्डरहरू',
    },
    'changePassword': {
      AppLanguage.english: 'Change Password',
      AppLanguage.nepali: 'पासवर्ड परिवर्तन गर्नुहोस्',
    },
    'logout': {
      AppLanguage.english: 'Logout',
      AppLanguage.nepali: 'लगआउट',
    },

    // ---- Auth: shared ----
    'email': {
      AppLanguage.english: 'Email',
      AppLanguage.nepali: 'इमेल',
    },
    'emailIsRequired': {
      AppLanguage.english: 'Email is required',
      AppLanguage.nepali: 'इमेल आवश्यक छ',
    },
    'enterAValidEmail': {
      AppLanguage.english: 'Enter a valid email',
      AppLanguage.nepali: 'मान्य इमेल प्रविष्ट गर्नुहोस्',
    },
    'passwordIsRequired': {
      AppLanguage.english: 'Password is required',
      AppLanguage.nepali: 'पासवर्ड आवश्यक छ',
    },
    'minimum6Characters': {
      AppLanguage.english: 'Minimum 6 characters',
      AppLanguage.nepali: 'कम्तीमा ६ अक्षर',
    },

    // ---- Login page ----
    'welcomeBackSignIn': {
      AppLanguage.english: 'Welcome back! Sign in to continue.',
      AppLanguage.nepali: 'फेरि स्वागत छ! जारी राख्न साइन इन गर्नुहोस्।',
    },
    'forgotPassword': {
      AppLanguage.english: 'Forgot password?',
      AppLanguage.nepali: 'पासवर्ड बिर्सनुभयो?',
    },
    'login': {
      AppLanguage.english: 'Login',
      AppLanguage.nepali: 'लगइन',
    },
    'loginWithFingerprint': {
      AppLanguage.english: 'Login with fingerprint',
      AppLanguage.nepali: 'फिंगरप्रिन्टले लगइन गर्नुहोस्',
    },
    'continueWithGoogle': {
      AppLanguage.english: 'Continue with Google',
      AppLanguage.nepali: 'Google बाट जारी राख्नुहोस्',
    },
    'orContinueWith': {
      AppLanguage.english: 'OR',
      AppLanguage.nepali: 'वा',
    },
    'dontHaveAccount': {
      AppLanguage.english: "Don't have an account?",
      AppLanguage.nepali: 'खाता छैन?',
    },
    'signUp': {
      AppLanguage.english: 'Sign up',
      AppLanguage.nepali: 'साइन अप गर्नुहोस्',
    },

    // ---- Signup page ----
    'accountCreatedPleaseLogin': {
      AppLanguage.english: 'Account created! Please login.',
      AppLanguage.nepali: 'खाता सिर्जना भयो! कृपया लगइन गर्नुहोस्।',
    },
    'createAccount': {
      AppLanguage.english: 'Create Account',
      AppLanguage.nepali: 'खाता सिर्जना गर्नुहोस्',
    },
    'joinCoffeeShop': {
      AppLanguage.english: 'Join Coffee Shop',
      AppLanguage.nepali: 'Coffee Shop मा सामेल हुनुहोस्',
    },
    'createAccountSubtitle': {
      AppLanguage.english: 'Create an account to start ordering your favourite beans.',
      AppLanguage.nepali: 'आफ्नो मनपर्ने बीन्स अर्डर गर्न सुरु गर्न खाता सिर्जना गर्नुहोस्।',
    },
    'fullName': {
      AppLanguage.english: 'Full name',
      AppLanguage.nepali: 'पूरा नाम',
    },
    'confirmPassword': {
      AppLanguage.english: 'Confirm password',
      AppLanguage.nepali: 'पासवर्ड पुष्टि गर्नुहोस्',
    },
    'passwordsDoNotMatch': {
      AppLanguage.english: 'Passwords do not match',
      AppLanguage.nepali: 'पासवर्डहरू मेल खाँदैनन्',
    },
    'createAccountButton': {
      AppLanguage.english: 'Create account',
      AppLanguage.nepali: 'खाता सिर्जना गर्नुहोस्',
    },
    'alreadyHaveAccount': {
      AppLanguage.english: 'Already have an account?',
      AppLanguage.nepali: 'पहिले नै खाता छ?',
    },

    // ---- Forgot password page ----
    'resetPasswordTitle': {
      AppLanguage.english: 'Reset Password',
      AppLanguage.nepali: 'पासवर्ड रिसेट गर्नुहोस्',
    },
    'stepEmail': {
      AppLanguage.english: 'Email',
      AppLanguage.nepali: 'इमेल',
    },
    'stepVerify': {
      AppLanguage.english: 'Verify',
      AppLanguage.nepali: 'प्रमाणित गर्नुहोस्',
    },
    'stepNewPassword': {
      AppLanguage.english: 'New password',
      AppLanguage.nepali: 'नयाँ पासवर्ड',
    },
    'forgotYourPassword': {
      AppLanguage.english: 'Forgot your password?',
      AppLanguage.nepali: 'पासवर्ड बिर्सनुभयो?',
    },
    'enterEmailForCode': {
      AppLanguage.english: "Enter your email and we'll send you a verification code.",
      AppLanguage.nepali: 'आफ्नो इमेल प्रविष्ट गर्नुहोस्, हामी तपाईंलाई प्रमाणीकरण कोड पठाउनेछौं।',
    },
    'sendCode': {
      AppLanguage.english: 'Send code',
      AppLanguage.nepali: 'कोड पठाउनुहोस्',
    },
    'checkYourInbox': {
      AppLanguage.english: 'Check your inbox',
      AppLanguage.nepali: 'आफ्नो इनबक्स जाँच गर्नुहोस्',
    },
    'enter6DigitCodeSentTo': {
      AppLanguage.english: 'Enter the 6-digit code sent to',
      AppLanguage.nepali: 'यसमा पठाइएको ६ अंकको कोड प्रविष्ट गर्नुहोस्',
    },
    'enter6DigitCode': {
      AppLanguage.english: 'Enter the 6-digit code',
      AppLanguage.nepali: '६ अंकको कोड प्रविष्ट गर्नुहोस्',
    },
    'verifyCode': {
      AppLanguage.english: 'Verify code',
      AppLanguage.nepali: 'कोड प्रमाणित गर्नुहोस्',
    },
    'resendCode': {
      AppLanguage.english: 'Resend code',
      AppLanguage.nepali: 'कोड पुन: पठाउनुहोस्',
    },
    'setANewPassword': {
      AppLanguage.english: 'Set a new password',
      AppLanguage.nepali: 'नयाँ पासवर्ड सेट गर्नुहोस्',
    },
    'newPassword': {
      AppLanguage.english: 'New password',
      AppLanguage.nepali: 'नयाँ पासवर्ड',
    },
    'confirmNewPassword': {
      AppLanguage.english: 'Confirm new password',
      AppLanguage.nepali: 'नयाँ पासवर्ड पुष्टि गर्नुहोस्',
    },
    'resetPasswordButton': {
      AppLanguage.english: 'Reset password',
      AppLanguage.nepali: 'पासवर्ड रिसेट गर्नुहोस्',
    },
    'passwordReset': {
      AppLanguage.english: 'Password reset',
      AppLanguage.nepali: 'पासवर्ड रिसेट भयो',
    },
    'canNowLoginWithNewPassword': {
      AppLanguage.english: 'You can now log in with your new password.',
      AppLanguage.nepali: 'तपाईं अब आफ्नो नयाँ पासवर्डले लगइन गर्न सक्नुहुन्छ।',
    },
    'backToSignIn': {
      AppLanguage.english: 'Back to sign in',
      AppLanguage.nepali: 'साइन इनमा फर्कनुहोस्',
    },

    // ---- Change password page ----
    'confirmYourCurrentPassword': {
      AppLanguage.english: 'Confirm your current password',
      AppLanguage.nepali: 'आफ्नो हालको पासवर्ड पुष्टि गर्नुहोस्',
    },
    'sendCodeOnceConfirmed': {
      AppLanguage.english: "We'll send a verification code to your email once confirmed.",
      AppLanguage.nepali: 'पुष्टि भएपछि हामी तपाईंको इमेलमा प्रमाणीकरण कोड पठाउनेछौं।',
    },
    'currentPassword': {
      AppLanguage.english: 'Current password',
      AppLanguage.nepali: 'हालको पासवर्ड',
    },
    'currentPasswordIsRequired': {
      AppLanguage.english: 'Current password is required',
      AppLanguage.nepali: 'हालको पासवर्ड आवश्यक छ',
    },
    'enterCodeAndNewPassword': {
      AppLanguage.english: 'Enter code & new password',
      AppLanguage.nepali: 'कोड र नयाँ पासवर्ड प्रविष्ट गर्नुहोस्',
    },
    'updatePassword': {
      AppLanguage.english: 'Update password',
      AppLanguage.nepali: 'पासवर्ड अद्यावधिक गर्नुहोस्',
    },
    'passwordUpdated': {
      AppLanguage.english: 'Password updated',
      AppLanguage.nepali: 'पासवर्ड अद्यावधिक भयो',
    },
    'done': {
      AppLanguage.english: 'Done',
      AppLanguage.nepali: 'सम्पन्न',
    },

    // ---- Bottom nav ----
    'navBeans': {
      AppLanguage.english: 'Beans',
      AppLanguage.nepali: 'बीन्स',
    },
    'navExplore': {
      AppLanguage.english: 'Explore',
      AppLanguage.nepali: 'खोज्नुहोस्',
    },
    'navWishlist': {
      AppLanguage.english: 'Wishlist',
      AppLanguage.nepali: 'मनपर्ने सूची',
    },
    'navProfile': {
      AppLanguage.english: 'Profile',
      AppLanguage.nepali: 'प्रोफाइल',
    },

    // ---- Home screen ----
    'goodMorning': {
      AppLanguage.english: 'Good morning,',
      AppLanguage.nepali: 'शुभ प्रभात,',
    },
    'coffeeLover': {
      AppLanguage.english: 'Coffee Lover',
      AppLanguage.nepali: 'कफी प्रेमी',
    },
    'findYourPerfectBean': {
      AppLanguage.english: 'Find your perfect bean',
      AppLanguage.nepali: 'आफ्नो उत्तम बीन्स फेला पार्नुहोस्',
    },
    'searchCoffeeBeansOrigins': {
      AppLanguage.english: 'Search coffee beans, origins…',
      AppLanguage.nepali: 'कफी बीन्स, उत्पत्ति खोज्नुहोस्…',
    },
    'categoryAll': {
      AppLanguage.english: 'All',
      AppLanguage.nepali: 'सबै',
    },
    'categoryDarkRoast': {
      AppLanguage.english: 'Dark Roast',
      AppLanguage.nepali: 'डार्क रोस्ट',
    },
    'categorySingleOrigin': {
      AppLanguage.english: 'Single Origin',
      AppLanguage.nepali: 'सिंगल ओरिजिन',
    },
    'categoryBlends': {
      AppLanguage.english: 'Blends',
      AppLanguage.nepali: 'ब्लेन्ड्स',
    },
    'categoryDecaf': {
      AppLanguage.english: 'Decaf',
      AppLanguage.nepali: 'डिक्याफ',
    },
    'trendingBeans': {
      AppLanguage.english: 'Trending Beans',
      AppLanguage.nepali: 'ट्रेन्डिङ बीन्स',
    },
    'couldNotLoadBeansRetry': {
      AppLanguage.english: 'Could not load beans. Pull down to retry.',
      AppLanguage.nepali: 'बीन्स लोड गर्न सकिएन। पुन: प्रयासको लागि तल तान्नुहोस्।',
    },
    'noBeansAvailableYet': {
      AppLanguage.english: 'No beans available yet.',
      AppLanguage.nepali: 'अझै कुनै बीन्स उपलब्ध छैन।',
    },
    'allBeans': {
      AppLanguage.english: 'All Beans',
      AppLanguage.nepali: 'सबै बीन्स',
    },

    // ---- Search/Explore page ----
    'categoryBlend': {
      AppLanguage.english: 'Blend',
      AppLanguage.nepali: 'ब्लेन्ड',
    },
    'categoryEspresso': {
      AppLanguage.english: 'Espresso',
      AppLanguage.nepali: 'एस्प्रेसो',
    },
    'roastLight': {
      AppLanguage.english: 'Light',
      AppLanguage.nepali: 'लाइट',
    },
    'roastMedium': {
      AppLanguage.english: 'Medium',
      AppLanguage.nepali: 'मिडियम',
    },
    'roastMediumDark': {
      AppLanguage.english: 'Medium-Dark',
      AppLanguage.nepali: 'मिडियम-डार्क',
    },
    'roastDark': {
      AppLanguage.english: 'Dark',
      AppLanguage.nepali: 'डार्क',
    },
    'noBeansMatchFilters': {
      AppLanguage.english: 'No beans match your filters.',
      AppLanguage.nepali: 'तपाईंको फिल्टरसँग कुनै बीन्स मेल खाँदैन।',
    },

    // ---- Bean detail page ----
    'addedToCart': {
      AppLanguage.english: 'Added',
      AppLanguage.nepali: 'थपियो',
    },
    'toCart': {
      AppLanguage.english: 'to cart',
      AppLanguage.nepali: 'कार्टमा',
    },
    'couldNotAddToCart': {
      AppLanguage.english: 'Could not add to cart',
      AppLanguage.nepali: 'कार्टमा थप्न सकिएन',
    },
    'couldNotUpdateWishlist': {
      AppLanguage.english: 'Could not update wishlist',
      AppLanguage.nepali: 'मनपर्ने सूची अद्यावधिक गर्न सकिएन',
    },
    'roastLightFull': {
      AppLanguage.english: 'Light Roast',
      AppLanguage.nepali: 'लाइट रोस्ट',
    },
    'roastMediumFull': {
      AppLanguage.english: 'Medium Roast',
      AppLanguage.nepali: 'मिडियम रोस्ट',
    },
    'roastMediumDarkFull': {
      AppLanguage.english: 'Medium-Dark Roast',
      AppLanguage.nepali: 'मिडियम-डार्क रोस्ट',
    },
    'roastDarkFull': {
      AppLanguage.english: 'Dark Roast',
      AppLanguage.nepali: 'डार्क रोस्ट',
    },
    'processWashed': {
      AppLanguage.english: 'Washed',
      AppLanguage.nepali: 'वाश्ड',
    },
    'processNatural': {
      AppLanguage.english: 'Natural',
      AppLanguage.nepali: 'नेचुरल',
    },
    'processHoney': {
      AppLanguage.english: 'Honey',
      AppLanguage.nepali: 'हनी',
    },
    'processAnaerobic': {
      AppLanguage.english: 'Anaerobic',
      AppLanguage.nepali: 'एनारोबिक',
    },
    'outOfStock': {
      AppLanguage.english: 'Out of stock',
      AppLanguage.nepali: 'स्टकमा छैन',
    },
    'tastingNotes': {
      AppLanguage.english: 'Tasting notes',
      AppLanguage.nepali: 'स्वाद नोटहरू',
    },
    'addToCart': {
      AppLanguage.english: 'Add to Cart',
      AppLanguage.nepali: 'कार्टमा थप्नुहोस्',
    },
    'description': {
      AppLanguage.english: 'Description',
      AppLanguage.nepali: 'विवरण',
    },

    // ---- Cart page ----
    'yourCart': {
      AppLanguage.english: 'Your Cart',
      AppLanguage.nepali: 'तपाईंको कार्ट',
    },
    'yourCartIsEmpty': {
      AppLanguage.english: 'Your cart is empty',
      AppLanguage.nepali: 'तपाईंको कार्ट खाली छ',
    },
    'total': {
      AppLanguage.english: 'Total',
      AppLanguage.nepali: 'कुल',
    },
    'checkout': {
      AppLanguage.english: 'Checkout',
      AppLanguage.nepali: 'चेकआउट',
    },
    'clearCart': {
      AppLanguage.english: 'Clear cart',
      AppLanguage.nepali: 'कार्ट खाली गर्नुहोस्',
    },
    'clearCartConfirm': {
      AppLanguage.english: 'Remove all items from your cart?',
      AppLanguage.nepali: 'तपाईंको कार्टबाट सबै वस्तुहरू हटाउने हो?',
    },
    'yourCartIsEmptySubtitle': {
      AppLanguage.english: 'Looks like you haven\'t added any beans yet.',
      AppLanguage.nepali: 'तपाईंले अझै कुनै बीन्स थप्नुभएको छैन जस्तो देखिन्छ।',
    },
    'browseBeans': {
      AppLanguage.english: 'Browse Beans',
      AppLanguage.nepali: 'बीन्स हेर्नुहोस्',
    },
    'subtotal': {
      AppLanguage.english: 'Subtotal',
      AppLanguage.nepali: 'उप-जम्मा',
    },
    'each': {
      AppLanguage.english: 'each',
      AppLanguage.nepali: 'प्रति थान',
    },

    // ---- Checkout page ----
    'shippingDetails': {
      AppLanguage.english: 'Shipping details',
      AppLanguage.nepali: 'ढुवानी विवरण',
    },
    'phone': {
      AppLanguage.english: 'Phone',
      AppLanguage.nepali: 'फोन',
    },
    'city': {
      AppLanguage.english: 'City',
      AppLanguage.nepali: 'शहर',
    },
    'streetAddress': {
      AppLanguage.english: 'Street address',
      AppLanguage.nepali: 'सडक ठेगाना',
    },
    'payWithKhalti': {
      AppLanguage.english: 'Pay with Khalti',
      AppLanguage.nepali: 'खल्तीबाट भुक्तानी गर्नुहोस्',
    },
    'isRequiredSuffix': {
      AppLanguage.english: 'is required',
      AppLanguage.nepali: 'आवश्यक छ',
    },

    // ---- Orders list page ----
    'noOrdersYet': {
      AppLanguage.english: 'No orders yet',
      AppLanguage.nepali: 'अझै कुनै अर्डर छैन',
    },
    'orderNumberPrefix': {
      AppLanguage.english: 'Order #',
      AppLanguage.nepali: 'अर्डर #',
    },
    'item': {
      AppLanguage.english: 'item',
      AppLanguage.nepali: 'वस्तु',
    },
    'items': {
      AppLanguage.english: 'items',
      AppLanguage.nepali: 'वस्तुहरू',
    },
    'statusPending': {
      AppLanguage.english: 'Pending',
      AppLanguage.nepali: 'विचाराधीन',
    },
    'statusPaid': {
      AppLanguage.english: 'Paid',
      AppLanguage.nepali: 'भुक्तानी भयो',
    },
    'statusFailed': {
      AppLanguage.english: 'Failed',
      AppLanguage.nepali: 'असफल',
    },
    'statusCancelled': {
      AppLanguage.english: 'Cancelled',
      AppLanguage.nepali: 'रद्द भयो',
    },

    // ---- Order detail page ----
    'orderDetails': {
      AppLanguage.english: 'Order Details',
      AppLanguage.nepali: 'अर्डर विवरण',
    },
    'itemsHeader': {
      AppLanguage.english: 'Items',
      AppLanguage.nepali: 'वस्तुहरू',
    },
    'shippingAddress': {
      AppLanguage.english: 'Shipping address',
      AppLanguage.nepali: 'ढुवानी ठेगाना',
    },

    // ---- Order confirmation page ----
    'paymentSuccessful': {
      AppLanguage.english: 'Payment successful!',
      AppLanguage.nepali: 'भुक्तानी सफल भयो!',
    },
    'paymentNotCompleted': {
      AppLanguage.english: 'Payment not completed',
      AppLanguage.nepali: 'भुक्तानी पूरा भएन',
    },
    'orderPlacedBeingPrepared': {
      AppLanguage.english: 'Your order has been placed and is being prepared.',
      AppLanguage.nepali: 'तपाईंको अर्डर राखिएको छ र तयार गरिँदैछ।',
    },
    'paymentCancelledOrFailed': {
      AppLanguage.english: 'The payment was cancelled or could not be verified. If you were charged, check My Orders shortly.',
      AppLanguage.nepali: 'भुक्तानी रद्द गरियो वा प्रमाणित गर्न सकिएन। यदि तपाईंबाट रकम कट्टा भएको छ भने, केही समयमा मेरा अर्डरहरू जाँच गर्नुहोस्।',
    },
    'viewOrder': {
      AppLanguage.english: 'View order',
      AppLanguage.nepali: 'अर्डर हेर्नुहोस्',
    },
    'backToShop': {
      AppLanguage.english: 'Back to shop',
      AppLanguage.nepali: 'पसलमा फर्कनुहोस्',
    },

    // ---- Wishlist page ----
    'noFavouritesYet': {
      AppLanguage.english: 'No favourites yet',
      AppLanguage.nepali: 'अझै कुनै मनपर्ने छैन',
    },
    'tapHeartToSave': {
      AppLanguage.english: 'Tap the heart on a bean to save it here for quick access.',
      AppLanguage.nepali: 'द्रुत पहुँचको लागि यहाँ बचत गर्न कुनै बीन्सको मुटु आइकनमा ट्याप गर्नुहोस्।',
    },
    'couldNotRemoveFromWishlist': {
      AppLanguage.english: 'Could not remove from wishlist',
      AppLanguage.nepali: 'मनपर्ने सूचीबाट हटाउन सकिएन',
    },

    // ---- Review section ----
    'reviews': {
      AppLanguage.english: 'Reviews',
      AppLanguage.nepali: 'समीक्षाहरू',
    },
    'editYourReview': {
      AppLanguage.english: 'Edit your review',
      AppLanguage.nepali: 'आफ्नो समीक्षा सम्पादन गर्नुहोस्',
    },
    'writeAReview': {
      AppLanguage.english: 'Write a review',
      AppLanguage.nepali: 'समीक्षा लेख्नुहोस्',
    },
    'couldNotLoadReviews': {
      AppLanguage.english: 'Could not load reviews',
      AppLanguage.nepali: 'समीक्षाहरू लोड गर्न सकिएन',
    },
    'review': {
      AppLanguage.english: 'review',
      AppLanguage.nepali: 'समीक्षा',
    },
    'noReviewsYet': {
      AppLanguage.english: 'No reviews yet. Be the first to share what you think!',
      AppLanguage.nepali: 'अझै कुनै समीक्षा छैन। आफ्नो विचार साझा गर्ने पहिलो व्यक्ति बन्नुहोस्!',
    },
    'verified': {
      AppLanguage.english: 'Verified',
      AppLanguage.nepali: 'प्रमाणित',
    },
    'coffeeLoverFallback': {
      AppLanguage.english: 'Coffee lover',
      AppLanguage.nepali: 'कफी प्रेमी',
    },
    'delete': {
      AppLanguage.english: 'Delete',
      AppLanguage.nepali: 'मेटाउनुहोस्',
    },
    'pleaseWriteAtLeast3Chars': {
      AppLanguage.english: 'Please write at least 3 characters',
      AppLanguage.nepali: 'कृपया कम्तीमा ३ अक्षर लेख्नुहोस्',
    },
    'failedToSubmitReview': {
      AppLanguage.english: 'Failed to submit review',
      AppLanguage.nepali: 'समीक्षा पेश गर्न असफल भयो',
    },
    'shareThoughtsAboutBean': {
      AppLanguage.english: 'Share your thoughts about this bean…',
      AppLanguage.nepali: 'यो बीन्सको बारेमा आफ्नो विचार साझा गर्नुहोस्…',
    },
    'submit': {
      AppLanguage.english: 'Submit',
      AppLanguage.nepali: 'पेश गर्नुहोस्',
    },

    // ---- Notifications page ----
    'notifications': {
      AppLanguage.english: 'Notifications',
      AppLanguage.nepali: 'सूचनाहरू',
    },
    'markAllRead': {
      AppLanguage.english: 'Mark all read',
      AppLanguage.nepali: 'सबै पढेको चिन्ह लगाउनुहोस्',
    },
    'noNotificationsYet': {
      AppLanguage.english: 'No notifications yet',
      AppLanguage.nepali: 'अझै कुनै सूचना छैन',
    },

    // ---- Splash page ----
    'premiumCoffeeBeans': {
      AppLanguage.english: 'Freshly roasted, thoughtfully brewed',
      AppLanguage.nepali: 'ताजा रोस्ट, ध्यानपूर्वक तयार',
    },

    // ---- Onboarding ----
    'onboardTitle1': {
      AppLanguage.english: 'Premium Coffee Beans',
      AppLanguage.nepali: 'प्रिमियम कफी बीन्स',
    },
    'onboardSubtitle1': {
      AppLanguage.english: 'Discover single-origin beans sourced directly from the finest farms around the world.',
      AppLanguage.nepali: 'विश्वभरका उत्कृष्ट खेतीबाट सिधै ल्याइएका सिंगल-ओरिजिन बीन्स पत्ता लगाउनुहोस्।',
    },
    'onboardTitle2': {
      AppLanguage.english: 'Fresh Every Roast',
      AppLanguage.nepali: 'हरेक रोस्ट ताजा',
    },
    'onboardSubtitle2': {
      AppLanguage.english: 'Our beans are roasted to order — dark, medium, or light — to match your perfect cup.',
      AppLanguage.nepali: 'तपाईंको उत्तम कपसँग मिल्ने गरी हाम्रा बीन्स अर्डरमै रोस्ट गरिन्छ — डार्क, मिडियम वा लाइट।',
    },
    'onboardTitle3': {
      AppLanguage.english: 'Order at Your Doorstep',
      AppLanguage.nepali: 'तपाईंको ढोकैमा अर्डर',
    },
    'onboardSubtitle3': {
      AppLanguage.english: 'Get your favourite coffee beans delivered fresh, straight to your home.',
      AppLanguage.nepali: 'तपाईंको मनपर्ने कफी बीन्स ताजै तपाईंको घरमै डेलिभर पाउनुहोस्।',
    },
    'skip': {
      AppLanguage.english: 'Skip',
      AppLanguage.nepali: 'छोड्नुहोस्',
    },
    'getStarted': {
      AppLanguage.english: 'Get Started',
      AppLanguage.nepali: 'सुरु गर्नुहोस्',
    },
    'next': {
      AppLanguage.english: 'Next',
      AppLanguage.nepali: 'अर्को',
    },

    // ---- Chatbot ----
    'coffeeAssistant': {
      AppLanguage.english: 'Coffee Assistant',
      AppLanguage.nepali: 'कफी सहायक',
    },
    'clearChat': {
      AppLanguage.english: 'Clear chat',
      AppLanguage.nepali: 'च्याट खाली गर्नुहोस्',
    },
    'clearChatConfirm': {
      AppLanguage.english: 'Clear this conversation? This cannot be undone.',
      AppLanguage.nepali: 'यो कुराकानी खाली गर्ने हो? यो पूर्ववत गर्न सकिँदैन।',
    },
    'askMeAnythingCoffee': {
      AppLanguage.english: 'Ask me anything about our coffee, beans, or your order!',
      AppLanguage.nepali: 'हाम्रो कफी, बीन्स, वा तपाईंको अर्डरको बारेमा जे पनि सोध्नुहोस्!',
    },
    'typeYourMessage': {
      AppLanguage.english: 'Type a message…',
      AppLanguage.nepali: 'सन्देश टाइप गर्नुहोस्…',
    },
    'chatWithUs': {
      AppLanguage.english: 'Chat with us',
      AppLanguage.nepali: 'हामीसँग च्याट गर्नुहोस्',
    },
  };

  static String get(String key, AppLanguage language) {
    return _values[key]?[language] ?? key;
  }
}
