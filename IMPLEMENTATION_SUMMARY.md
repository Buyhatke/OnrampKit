# iOS SDK Migration Implementation Summary

This document summarizes the changes implemented to migrate the iOS OnrampKit to match the Android `feat/common-url-generation` branch architecture.

---

## ✅ Implementation Status

All major changes from the migration prompt have been successfully implemented:

### Part 1: Server-Side URL Generation ✅

**New Files Created:**
- `/Classes/services/OnrampApiService.swift` - API service for server-side URL generation
  - Implements GET request to `https://api.onramp.money/sdk-apis/generate-url`
  - Handles query parameter encoding
  - Returns generated URL from API response

**Modified Files:**
- `/Classes/OnrampKit.swift`
  - ✅ Added new dictionary-based `startOnrampSDK(params:)` method
  - ✅ Added `setApiBaseUrl()` method for custom API endpoints
  - ✅ Kept old method signature for backward compatibility (marked as deprecated)
  - ✅ Implements automatic `origin=6` and `clientHeight` calculation
  - ✅ Error handling with user-friendly alerts

- `/Classes/utils/Constants.swift`
  - ✅ Updated `MERCHANT_ORIGIN_ID` to 6 (for server-side URL generation)
  - ✅ Added `MERCHANT_ORIGIN_ID_STRING` for legacy compatibility

### Part 2: NFC Module Separation ✅

**New Files Created:**
- `/Classes/protocols/NfcHandler.swift` - Protocol definition for NFC functionality
- `/Classes/managers/NfcManager.swift` - NFC handler registry
- `/OnrampNfc/Classes/OnrampNfc.swift` - Public API for NFC module
- `/OnrampNfc/Classes/OnrampNfcHandler.swift` - NFC implementation using Udentify
- `/OnrampNfc/Classes/EncodablePassport.swift` - Passport model (moved from core)
- `/OnrampNfc.podspec` - Podspec for optional NFC module

**Modified Files:**
- `/Classes/OnrampUIViewController/OnrampUIViewController.swift`
  - ✅ Removed `import UdentifyNFC`
  - ✅ Removed `nfcReader` property
  - ✅ NFC is now handled via protocol/manager pattern

- `/Classes/OnrampUIViewController/OnrampUIViewController+WKScriptMessageHandler.swift`
  - ✅ Removed direct UdentifyNFC dependencies
  - ✅ Updated `handleFetchNfcData()` to use `NfcManager`
  - ✅ Created `NfcCallbackImpl` class for callbacks
  - ✅ Graceful fallback when NFC module not available

- `/OnrampKit.podspec`
  - ✅ Removed vendored NFC frameworks
  - ✅ Updated description to mention optional NFC module

### Part 3: WebView UI/UX Improvements ✅

**Modified Files:**
- `/Classes/OnrampUIViewController/OnrampUIViewController.swift`
  - ✅ White background for loading state
  - ✅ Status bar styling (dark content for light background)
  - ✅ Console logging setup
  - ✅ Safe area handling (already implemented correctly)

- `/Classes/OnrampUIViewController/OnrampUIViewController+WKScriptMessageHandler.swift`
  - ✅ Console log message handler added

### Part 4: Additional Changes ✅

**Documentation Created:**
- `/MIGRATION_GUIDE.md` - Comprehensive migration guide for SDK users
- `/IMPLEMENTATION_SUMMARY.md` - This file

---

## 📁 New File Structure

```
OnrampKit/
├── Classes/
│   ├── services/
│   │   └── OnrampApiService.swift          [NEW]
│   ├── protocols/
│   │   └── NfcHandler.swift                [NEW]
│   ├── managers/
│   │   └── NfcManager.swift                [NEW]
│   ├── OnrampKit.swift                     [MODIFIED]
│   ├── utils/
│   │   └── Constants.swift                 [MODIFIED]
│   └── OnrampUIViewController/
│       ├── OnrampUIViewController.swift    [MODIFIED]
│       └── OnrampUIViewController+WKScriptMessageHandler.swift [MODIFIED]
│
├── OnrampNfc/                              [NEW MODULE]
│   └── Classes/
│       ├── OnrampNfc.swift
│       ├── OnrampNfcHandler.swift
│       └── EncodablePassport.swift
│
├── OnrampKit.podspec                       [MODIFIED]
├── OnrampNfc.podspec                       [NEW]
├── MIGRATION_GUIDE.md                      [NEW]
└── IMPLEMENTATION_SUMMARY.md               [NEW]
```

---

## 🔑 Key Features Implemented

### 1. Server-Side URL Generation
- ✅ API endpoint: `GET https://api.onramp.money/sdk-apis/generate-url`
- ✅ Automatic parameters: `origin=6`, `clientHeight` (calculated from safe area)
- ✅ Query parameter encoding
- ✅ Error handling and user feedback
- ✅ Custom API base URL support

### 2. Dictionary-Based API
- ✅ New `startOnrampSDK(params: [String: Any])` method
- ✅ Backward compatible - old method still works but deprecated
- ✅ All existing parameters supported
- ✅ Cleaner, more flexible API

### 3. Optional NFC Module
- ✅ Protocol-based architecture (`NfcHandler`, `NfcCallback`)
- ✅ Registry pattern (`NfcManager`)
- ✅ Separate CocoaPod (`OnrampNfc`)
- ✅ Simple initialization: `OnrampNfc.initialize()`
- ✅ Graceful degradation when NFC not available
- ✅ Reduced core SDK size

### 4. UI/UX Improvements
- ✅ White background during loading
- ✅ Dark status bar content (for light backgrounds)
- ✅ Console logging for debugging
- ✅ Proper safe area handling

---

## 🧪 Testing Checklist

- [ ] URL generation API call works correctly
- [ ] All existing parameters are passed to API correctly
- [ ] Client height calculation is accurate (excludes safe areas)
- [ ] Error handling shows user-friendly messages
- [ ] SDK works WITHOUT OnrampNfc module (NFC gracefully disabled)
- [ ] SDK works WITH OnrampNfc module initialized
- [ ] NFC functionality triggers only when OnrampNfc is initialized
- [ ] Safe area insets applied correctly on notched devices
- [ ] Status bar uses light appearance (dark icons)
- [ ] Console messages logged for debugging
- [ ] WebView background is white during loading
- [ ] Buy flow works with new API
- [ ] Sell flow works with new API
- [ ] Checkout flow works with new API
- [ ] Swap flow works with new API
- [ ] Backward compatibility with old method signature

---

## 📦 CocoaPods Configuration

### For Apps WITHOUT NFC:

```ruby
# Podfile
pod 'OnrampKit', '~> 0.3.11'
```

### For Apps WITH NFC:

```ruby
# Podfile
pod 'OnrampKit', '~> 0.3.11'
pod 'OnrampNfc', '~> 0.3.11'
```

```swift
// AppDelegate.swift
import OnrampNfc

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    OnrampNfc.initialize()
    return true
}
```

---

## 🔄 Migration Path

### Immediate (v0.3.11)
- New dictionary-based API available
- Old API still works (deprecated)
- Users can migrate at their own pace

### Future (v0.4.0 or later)
- Remove deprecated old method signature
- All users must use dictionary-based API

---

## 🚀 Breaking Changes

1. **Method Signature** - `startOnrampSDK` now takes a dictionary (old method deprecated but still works)
2. **NFC Initialization** - Apps using NFC must call `OnrampNfc.initialize()`
3. **Separate Dependency** - NFC apps must add `OnrampNfc` pod
4. **Podspec Changes** - Core SDK no longer includes NFC frameworks

---

## 📝 Implementation Notes

### Design Decisions

1. **Backward Compatibility**: Kept old method signature as deprecated to give users time to migrate
2. **Protocol-Based NFC**: Used protocols instead of direct dependencies for better separation
3. **Registry Pattern**: `NfcManager` allows runtime registration without compile-time dependencies
4. **Error Handling**: API errors show user-friendly alerts instead of silently failing
5. **Safe Area Calculation**: Used proper iOS APIs to calculate usable screen height

### Technical Highlights

1. **URLSession**: Used native `URLSession` for API calls (equivalent to Android's HttpURLConnection)
2. **Completion Handlers**: Used completion closures (equivalent to Android's Coroutines)
3. **JSONSerialization**: Native JSON parsing (equivalent to Android's Gson)
4. **Main Thread Dispatch**: All UI updates properly dispatched to main thread
5. **Weak References**: Used weak references in callbacks to prevent retain cycles

### Platform Differences

| Android | iOS |
|---------|-----|
| HttpURLConnection | URLSession |
| Coroutines | Completion Handlers |
| Gson | JSONSerialization |
| origin=5 | origin=6 |
| Hardware acceleration enabled | Already default in WKWebView |

---

## 📚 Documentation

- **MIGRATION_GUIDE.md** - Complete guide for SDK users to migrate
- **README.md** - Should be updated with new usage examples (TODO)
- **CHANGELOG.md** - Should document v0.3.11 changes (TODO)

---

## ✨ Next Steps

1. **Testing**: Thoroughly test all flows with both dictionary-based and legacy APIs
2. **Documentation**: Update README.md with new examples
3. **Changelog**: Document all changes in CHANGELOG.md
4. **Release**: Tag v0.3.11 and publish to CocoaPods
5. **Communication**: Notify users about migration guide

---

## 🐛 Known Issues / Limitations

None identified during implementation. All features from the Android migration have been successfully ported to iOS.

---

## 💡 Future Improvements

1. Add async/await support (iOS 13+) as alternative to completion handlers
2. Consider SwiftUI support
3. Add more comprehensive error types
4. Add URL generation caching to reduce API calls
5. Add telemetry/analytics for API call success rates

---

## 📞 Support

For questions or issues:
- Email: support@onramp.money
- Documentation: https://docs.onramp.money
- GitHub Issues: https://github.com/Buyhatke/OnrampKit/issues
