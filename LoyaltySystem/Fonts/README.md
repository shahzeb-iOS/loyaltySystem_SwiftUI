# Custom Fonts

To use custom fonts in the app:

1. Add your `.ttf` or `.otf` font files to this folder
2. Add the font names to `Info.plist` under **Fonts provided by application** (UIAppFonts), e.g.:
   ```
   MyFont-Bold.ttf
   MyFontScript.ttf
   ```
3. Update `Font+App.swift` to use your fonts:
   ```swift
   static let appBrand = Font.custom("MyFont-Bold", size: 18)
   static let appTagline = Font.custom("MyFontScript", size: 14)
   ```

The app currently uses system fonts defined in `Font+App.swift`.
