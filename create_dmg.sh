#!/opt/homebrew/bin/bash

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build for macOS
flutter build macos --release

# Check if build was successful
if [ ! -d "build/macos/Build/Products/Release/AppBuild Dev Cleaner.app" ]; then
    echo "❌ Build failed - app not found!"
    exit 1
fi

# Install create-dmg if not available
if ! command -v create-dmg &> /dev/null; then
    echo "📦 Installing create-dmg..."
    brew install create-dmg
fi

# Create DMG
echo "🔨 Creating DMG..."
create-dmg \
  --volname "AppBuild Dev Cleaner" \
  --window-pos 200 120 \
  --window-size 800 600 \
  --icon-size 100 \
  --icon "AppBuild Dev Cleaner.app" 200 190 \
  --hide-extension "AppBuild Dev Cleaner.app" \
  --app-drop-link 600 185 \
  "AppBuild-Dev-Cleaner.dmg" \
  "build/macos/Build/Products/Release/"

# Show DMG location
if [ -f "AppBuild-Dev-Cleaner.dmg" ]; then
    DMG_PATH=$(pwd)/AppBuild-Dev-Cleaner.dmg
    DMG_SIZE=$(du -h "AppBuild-Dev-Cleaner.dmg" | cut -f1)
    
    echo "✅ DMG created successfully!"
    echo "📍 Location: $DMG_PATH"
    echo "📊 Size: $DMG_SIZE"
    echo "🚀 Ready for distribution!"
    
    # Optional: Open folder containing DMG
    open .
else
    echo "❌ DMG creation failed!"
    exit 1
fi