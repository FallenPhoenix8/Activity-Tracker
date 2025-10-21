import SwiftUI

/// A centralized collection of reusable styles for the app.
public struct AppTheme {
    /// Background color for active or selected list rows.
    /// Intended for use with modifiers that expect a `View`, such as `listRowBackground`.
    public static let activeRowBackground: Color = Color.accentColor.opacity(0.2)
    
    /// Transparent background color, useful for clearing backgrounds.
    /// Intended for use with modifiers that expect a `View`, such as `listRowBackground`.
    public static let clearRowBackground: Color = Color.clear
    
    /// Background fill style for active or selected rows.
    /// Intended for use with modifiers that accept a `ShapeStyle`, such as `.background(_:)` on shapes or chart marks.
    public static let activeFillStyle: AnyShapeStyle = AnyShapeStyle(Color.accentColor.gradient.opacity(0.2))
}
