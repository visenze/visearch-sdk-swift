## Overview

This is a Swift iOS SDK for the Rezolve (formerly ViSenze) Visual Search API. It ships as both a CocoaPod (`ViSearchSDK.podspec`) and a Swift Package (`Package.swift`). Minimum deployment target: iOS 12. The SDK depends on `ViSenzeAnalytics` (the `visenze-tracking-swift` package) for analytics and session tracking.

## Building and Testing

Tests live in `ViSearchSDK/ViSearchSDKTests/` and are run via the Xcode project:

```bash
# Run all tests via xcodebuild (use an available iOS simulator)
xcodebuild test \
  -project ViSearchSDK/ViSearchSDK.xcodeproj \
  -scheme ViSearchSDK \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 14' \
  ONLY_ACTIVE_ARCH=NO

# Validate the podspec before publishing
pod spec lint ViSearchSDK.podspec
```

There is no standalone CLI build — all compilation happens through Xcode or the Swift Package Manager.

## Architecture

The SDK has two parallel API surfaces:

### Legacy ViSearch API (`ViSearch` / `ViSearchClient`)
- **`ViSearch`** — singleton (`sharedInstance`), initialized with `setup(accessKey:secret:)` or `setup(appKey:)`. Delegates all calls to an underlying `ViSearchClient`.
- **`ViSearchClient`** — the HTTP client. Supports both app-key auth (`access_key` query param) and Basic Auth (access/secret key pair via `Authorization` header). Base URL defaults to `https://visearch.visenze.com`.
- Endpoints: `colorsearch`, `search`, `uploadsearch`, `recommendations`, `discoversearch`.
- Request params all extend `ViBaseSearchParams` and implement `toDict() -> [String:Any]`.
- Responses are parsed into `ViResponseData`.

### Product Search API (`ViProductSearch` / `ViProductSearchClient`)
- **`ViProductSearch`** — singleton (`sharedInstance`), initialized with `setUp(appKey:placementId:)` or `setUp(appKey:placementId:baseUrl:)`. Default base URL: `https://multimodal.search.rezolve.com`.
- **`ViProductSearchClient`** — extends `ViSearchClient`, adds `post(path:params:imageData:...)` and `get(path:params:...)` methods that return `ViProductSearchResponse`.
- Endpoints: `v1/product/search_by_image`, `v1/product/recommendations/{id}`, `v1/product/multisearch`, `v1/product/multisearch/autocomplete`, `v1/product/multisearch/complementary`, `v1/product/multisearch/outfit-recommendations`.
- Request params extend `ViBaseProductSearchParam`. `ViSearchByImageParam` supports image upload (via `UIImage`), URL (`imUrl`), image ID (`imId`), or text query (`q`). **Important:** `getCompressedImageData()` must be called before `toDict()` when uploading images — it resizes the image and sets the scaled `compress_box`.
- Responses parsed into `ViProductSearchResponse`, which contains `result: [ViProduct]`, `objects: [ViProductObjectResult]`, `groupResults: [ViGroupResult]`, `facets`, `strategy`, `experiment`, etc.

### Shared infrastructure
- **`ViRequestSerialization`** — builds query strings; handles array params by repeating the key (`key=v1&key=v2`); percent-escapes values.
- **`ViMultipartFormData`** — encodes image `Data` into multipart/form-data for upload endpoints.
- Analytics fields (`va_uid`, `va_sid`, `va_os`, etc.) are automatically injected from `VaSessionManager` and `VaDeviceData` (from the `ViSenzeAnalytics` dependency) unless already set by the caller.

## Versioning

The SDK version string appears in two places and must be kept in sync:
- `ViSearchSDK.podspec` → `s.version`
- `ViSearchClient.swift` → `public var userAgent`
