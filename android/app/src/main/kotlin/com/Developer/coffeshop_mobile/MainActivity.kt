package com.Developer.coffeshop_mobile

import io.flutter.embedding.android.FlutterFragmentActivity

// local_auth's Android biometric prompt requires a FragmentActivity host —
// FlutterActivity doesn't extend one, so the biometric prompt would fail
// to show (or crash) without this.
class MainActivity : FlutterFragmentActivity()
