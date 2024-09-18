
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
@_documentation(visibility: internal)
public class SFSymbol: RawRepresentable, Equatable, Hashable, @unchecked Sendable {
    public let rawValue: String

    public required init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: Dynamic Localization

    /// Determine whether `self` can be localized to `localization` on the current platform.
    public func has(localization: Localization) -> Bool {
        Self.allLocalizations[self]?.contains(localization) ?? false
    }

    /// If `self` is localizable to `localization`, localize it, otherwise return `nil`.
    public func localized(to localization: Localization) -> SFSymbol? {
        if has(localization: localization) {
            return SFSymbol(rawValue: "\(rawValue).\(localization.rawValue)")
        } else {
            return nil
        }
    }
}
