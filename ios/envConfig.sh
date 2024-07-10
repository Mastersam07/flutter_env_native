#!/bin/bash

# Ensure the script is being run from the root of the Flutter project
if [ ! -d "ios" ]; then
    echo "Error: This script must be run from the root of your Flutter project."
    exit 1
fi

# Path to the Runner scheme file
SCHEME_FILE="ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme"

if [ ! -f "$SCHEME_FILE" ]; then
    echo "Error: Runner.xcscheme file not found. Please ensure you have opened the iOS project in Xcode at least once."
    exit 1
fi

# Add pre-actions build script to the Runner scheme
if ! grep -q "entry_decode" "$SCHEME_FILE"; then
    echo "Adding pre-actions build script to Runner scheme..."

    # Backup the original file
    cp "$SCHEME_FILE" "$SCHEME_FILE.bak"

    # Insert the PreActions block
    awk '
    /<\/TestAction>/ {
        print "  <PreActions>"
        print "    <ExecutionAction ActionType=\"Xcode.IDEStandardExecutionActionsCore.ExecutionActionType.ShellScriptAction\">"
        print "      <ActionContent title=\"Run Script\" scriptText=\"function entry_decode() { echo \\\"${*}\\\" | base64 --decode; } IFS=\",\" read -r -a define_items <<< \\\"$DART_DEFINES\\\"; for index in \\\"${!define_items[@]}\\\"; do define_items[$index]=$(entry_decode \\\"${define_items[$index]}\\\"); done; printf \\\"%s\\n\\\" \\\"${define_items[@]}\\\" > \\\"${SRCROOT}/Flutter/Environment.xcconfig\\\"\">"
        print "      </ActionContent>"
        print "      <buildableReference"
        print "         BuildableIdentifier=\"primary\""
        print "         BlueprintIdentifier=\"97C146ED1CF9000F007C117D\""
        print "         BuildableName=\"Runner.app\""
        print "         BlueprintName=\"Runner\""
        print "         ReferencedContainer=\"container:Runner.xcodeproj\">"
        print "      </buildableReference>"
        print "    </ExecutionAction>"
        print "  </PreActions>"
    }
    { print $0 }
    ' "$SCHEME_FILE.bak" > "$SCHEME_FILE"

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

echo "iOS environment setup completed."
