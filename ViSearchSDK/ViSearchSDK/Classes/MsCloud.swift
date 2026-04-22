import Foundation

/// Cloud deployment target for ProductSearch API.
/// Use `.aws` for AWS-hosted apps and `.azure` for Azure-hosted apps.
/// These select the new cloud-specific domains and their updated endpoint paths.
public enum MsCloud {
    case aws
    case azure

    public var baseUrl: String {
        switch self {
        case .aws:   return "https://multisearch-aw.rezolve.com"
        case .azure: return "https://multisearch-az.rezolve.com"
        }
    }
}
