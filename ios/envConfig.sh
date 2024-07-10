#!/bin/bash

# Path to the Runner scheme file
SCHEME_FILE="ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme"

if [ ! -f "$SCHEME_FILE" ]; then
    echo "Error: Runner.xcscheme file not found. Please run this script from the root of your Flutter project."
    exit 1
fi

# Add pre-actions build script to the Runner scheme
if ! grep -q "entry_decode" "$SCHEME_FILE"; then
    echo "Adding pre-actions build script to Runner scheme..."
    /usr/libexec/PlistBuddy -c "Add :PreActions array" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Add :PreActions:0 dict" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Add :PreActions:0:ActionContent dict" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Add :PreActions:0:ActionContent:scriptText string" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Set :PreActions:0:ActionContent:scriptText \"function entry_decode() { echo \\\"\${*}\\\" | base64 --decode; } IFS=',' read -r -a define_items <<< \\\"\$DART_DEFINES\\\"; for index in \\\"\\\${!define_items[@]}\\\"; do define_items[\\\$index]=\\\$(entry_decode \\\"\\\${define_items[\\\$index]}\\\"); done; printf \\\"%s\\n\\\" \\\"\${define_items[@]}\\\" > \\\"\${SRCROOT}/Flutter/Environment.xcconfig\\\"\"" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Add :PreActions:0:ActionContent:title string \"Run Script\"" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Add :PreActions:0:buildableReference dict" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Add :PreActions:0:buildableReference:BuildableIdentifier string \"primary\"" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Add :PreActions:0:buildableReference:BlueprintIdentifier string \"\"" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Add :PreActions:0:buildableReference:BuildableName string \"Runner.app\"" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Add :PreActions:0:buildableReference:BlueprintName string \"Runner\"" "$SCHEME_FILE"
    /usr/libexec/PlistBuddy -c "Add :PreActions:0:buildableReference:ReferencedContainer string \"container:Runner.xcodeproj\"" "$SCHEME_FILE"
    echo "Pre-actions build script added successfully."
else
    echo "Pre-actions build script already exists in Runner scheme."
fi

# Add include statement to Debug.xcconfig and Release.xcconfig
for CONFIG in Debug Release; do
    CONFIG_FILE="ios/Flutter/${CONFIG}.xcconfig"
    if [ -f "$CONFIG_FILE" ]; then
        if ! grep -q "#include \"Environment.xcconfig\"" "$CONFIG_FILE"; then
            echo "#include \"Environment.xcconfig\"" >> "$CONFIG_FILE"
            echo "Added include statement to $CONFIG_FILE."
        else
            echo "Include statement already exists in $CONFIG_FILE."
        fi
    else
        echo "Error: $CONFIG_FILE not found."
    fi
done

# Add Environment.xcconfig to .gitignore
if ! grep -q "ios/Flutter/Environment.xcconfig" .gitignore; then
    echo "ios/Flutter/Environment.xcconfig" >> .gitignore
    echo "Added Environment.xcconfig to .gitignore."
else
    echo "Environment.xcconfig already exists in .gitignore."
fi

echo "iOS environment setup completed."
