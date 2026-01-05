# Legacy Code Removal Summary

All legacy client-side URL generation code has been removed. The SDK now exclusively uses server-side URL generation via the API.

---

## What Was Removed

### 1. ✅ Legacy `startOnrampSDK` Method
**Removed from:** `/Classes/OnrampKit.swift` (Lines 89-157)

The old method with individual parameters:
```swift
// ❌ REMOVED
public static func startOnrampSDK(
    _ viewController: UIViewController,
    _ target: OnrampKitDelegate,
    appId: Int = 0,
    walletAddress: String? = nil,
    flowType: Int? = 1,
    coinCode: String? = nil,
    // ... 20+ more parameters
)
```

### 2. ✅ Client-Side URL Building Functions
**Removed from:** `/Classes/OnrampKit.swift`

- `getCustomUrlForSdkToShow()` (Lines 207-360)
  - 154 lines of client-side URL construction logic
  - Flow-specific path logic (/buy, /sell, /checkout, /swap)
  - Manual query parameter building
  - String concatenation for URL building

- `getCustomLoginUrlForSdkToShow()` (Lines 362-384)
  - Login-specific URL construction

- `getCustomKycUrlForSdkToShow()` (Lines 386-395)
  - KYC-specific URL construction

### 3. ✅ Legacy Constants
**Removed from:** `/Classes/utils/Constants.swift`

- `APP_DOMAIN = "https://onramp.money"` - No longer needed, API returns full URLs
- `TRBNS_DOMAIN = "https://onramp.trbns.com"` - No longer needed
- `TEST_APP_DOMAIN = "https://test.bitbns.com/onramp-gobhi"` - No longer needed
- `PATH = "/main"` - No longer needed
- `MERCHANT_ORIGIN_ID_STRING = "OnrampSdkIos"` - Replaced by numeric ID
- `INITIATE_KYC_PATH = "/initiate-kyc/"` - No longer needed

### 4. ✅ Example App Updated
**Updated:** `/Example/OnrampKit/ViewController.swift`

Changed from individual parameters to dictionary-based API for all examples.

---

## What Remains (New API-Only)

### Public API Methods

All methods now use dictionary-based parameters and server-side URL generation:

```swift
// 1. Start Onramp SDK (Buy/Sell/Checkout/Swap)
public static func startOnrampSDK(
    _ viewController: UIViewController,
    _ target: OnrampKitDelegate,
    params: [String: Any]
)

// 2. Start Login Flow
public static func startOnrampLogin(
    _ viewController: UIViewController,
    _ target: OnrampKitDelegate,
    params: [String: Any]
)

// 3. Initiate KYC Flow
public static func initiateOnrampKyc(
    _ viewController: UIViewController,
    _ target: OnrampKitDelegate,
    params: [String: Any]
)

// 4. Set Custom API Base URL (optional)
public static func setApiBaseUrl(_ url: String)

// 5. Stop SDK
public static func stopOnrampSDK(_ viewController: UIViewController)
```

### Remaining Constants

Only essential constants remain:
```swift
static let BUNDLE_IDENTIFIER = "com.onramp.money.OnrampSDK"
static let MERCHANT_ORIGIN_ID = 6  // iOS origin ID
static let VIDEO_KYC_PATH = "get-verified"
static let FRESHDESK_PATH = "freshdesk.com"
static let DOCUMENTATION_PATH = "user-guides"
static let hideCloseSDKModelAppIdList = [956556]
static let UDENTIFY_SERVER_URL = "https://udentify.private.cloud.fraud.com"
static let EVENT_NFC_NOT_SUPPORTED = "NFC_NOT_SUPPORTED"
static let EVENT_NFC_NOT_ENABLED = "NFC_NOT_ENABLED"
static let TYPE_NFC_RESPONSE = "nfcResponse"
static let TYPE_NFC_PROGRESS = "nfcProgress"
static let SUCCESS = "success"
static let ERROR = "error"
```

---

## Code Comparison

### Before (Legacy)

**OnrampKit.swift:** 399 lines
- Complex URL building logic
- Flow-specific path handling
- Manual query parameter concatenation
- Multiple method signatures

**Example Usage:**
```swift
Onramp.startOnrampSDK(
    self,
    self,
    appId: 1,
    flowType: 1,
    coinCode: "sol",
    network: "spl",
    coinAmount: 6
)
```

### After (New API-Only)

**OnrampKit.swift:** 195 lines (51% smaller)
- Clean, simple API methods
- All URL generation delegated to server
- Consistent dictionary-based interface
- Better error handling

**Example Usage:**
```swift
Onramp.startOnrampSDK(
    self,
    self,
    params: [
        "appId": 1,
        "flowType": 1,
        "coinCode": "sol",
        "network": "spl",
        "coinAmount": 6
    ]
)
```

---

## Lines of Code Removed

| File | Before | After | Removed |
|------|--------|-------|---------|
| OnrampKit.swift | 399 lines | 195 lines | **204 lines (51%)** |
| Constants.swift | 30 lines | 23 lines | **7 lines (23%)** |
| **Total** | **429 lines** | **218 lines** | **211 lines (49%)** |

---

## Benefits of Removal

### 1. **Simpler Codebase**
- 49% less code to maintain
- No complex URL building logic
- Easier to understand and debug

### 2. **Server-Side Control**
- URL structure changes don't require SDK updates
- Can A/B test different URL formats
- Centralized validation and business logic

### 3. **Better Security**
- No hardcoded domain URLs in client
- Server validates all parameters
- Reduced attack surface

### 4. **Consistency**
- Same API pattern for all flows (Buy/Sell/Checkout/Swap/Login/KYC)
- Matches Android SDK architecture
- Dictionary-based interface is more flexible

### 5. **Future-Proof**
- Easy to add new parameters without SDK changes
- Server can add new flows without client updates
- Better versioning control

---

## Migration Path for Users

Users upgrading from v0.3.10 to v0.3.11+ will see breaking changes:

### Old Code (v0.3.10)
```swift
Onramp.startOnrampSDK(
    self,
    self,
    appId: 1,
    walletAddress: "0x...",
    flowType: 1,
    coinCode: "ETH"
)
```

### New Code (v0.3.11+)
```swift
Onramp.startOnrampSDK(
    self,
    self,
    params: [
        "appId": 1,
        "walletAddress": "0x...",
        "flowType": 1,
        "coinCode": "ETH"
    ]
)
```

**Migration Guide:** See `/MIGRATION_GUIDE.md` for complete details.

---

## Validation Results

✅ **OnrampKit.podspec:** PASSED
✅ **Example Project Build:** SUCCEEDED
✅ **All API methods:** Using server-side URL generation
✅ **No legacy code:** Completely removed

---

## Breaking Changes

This is a **breaking change** that requires users to update their code:

1. **Method signature changed** - Now accepts dictionary instead of individual parameters
2. **No backward compatibility** - Legacy method completely removed
3. **All flows affected** - Buy, Sell, Checkout, Swap, Login, KYC
4. **startOnrampLogin signature changed** - Now uses params dictionary
5. **initiateOnrampKyc signature changed** - Now uses params dictionary

---

## Version Recommendation

Given the breaking changes, this should be released as:
- **Major version bump:** v1.0.0 (recommended)
- **Or minor version:** v0.4.0 (if following semver 0.x rules)

**Not recommended:** Patch version (v0.3.12) due to breaking changes

---

## Files Modified

1. `/Classes/OnrampKit.swift` - Removed 204 lines of legacy code
2. `/Classes/utils/Constants.swift` - Removed 7 lines of unused constants
3. `/Example/OnrampKit/ViewController.swift` - Updated to use new API

---

## Next Steps

1. ✅ Legacy code removed
2. ✅ All methods use server-side URL generation
3. ✅ Example app updated
4. ✅ Build validated
5. 📝 Update README.md with new examples
6. 📝 Update CHANGELOG.md
7. 🏷️ Tag release (v1.0.0 or v0.4.0)
8. 📢 Notify users about breaking changes
9. 📚 Update documentation/website

---

**Summary:** All legacy client-side URL generation code has been successfully removed. The SDK is now 49% smaller and exclusively uses server-side URL generation via the API. ✅
