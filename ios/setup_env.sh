#!/bin/bash

# Check if a root directory argument was provided
if [ -z "$1" ]; then
    echo "Error: Root directory argument is required."
    exit 1
fi

ROOT_DIR=$1

# Ensure the script is being run from the root of the Flutter project
if [ ! -d "$ROOT_DIR/ios" ]; then
    echo "Error: This script must be run from the root of your Flutter project."
    exit 1
fi

# Path to the schemes directory
SCHEMES_DIR="$ROOT_DIR/ios/Runner.xcodeproj/xcshareddata/xcschemes"

if [ ! -d "$SCHEMES_DIR" ]; then
    echo "Error: Schemes directory not found. Please ensure you have opened the iOS project in Xcode at least once."
    exit 1
fi

# Function to extract the BlueprintIdentifier and BlueprintName from a scheme file
extract_identifiers() {
    local scheme_file="$1"
    local buildable_identifier=$(xmllint --xpath 'string(//BuildableReference/@BuildableIdentifier)' "$scheme_file")
    local blueprint_identifier=$(xmllint --xpath 'string(//BuildableReference/@BlueprintIdentifier)' "$scheme_file")
    local blueprint_name=$(xmllint --xpath 'string(//BuildableReference/@BlueprintName)' "$scheme_file")
    local buildable_name=$(xmllint --xpath 'string(//BuildableReference/@BuildableName)' "$scheme_file")
    echo "$buildable_identifier,$blueprint_identifier,$blueprint_name,$buildable_name"
}

# Iterate over all .xcscheme files in the schemes directory
for SCHEME_FILE in "$SCHEMES_DIR"/*.xcscheme; do
    echo "Processing scheme: $SCHEME_FILE"

    identifiers=$(extract_identifiers "$SCHEME_FILE")
    IFS=',' read -r buildable_identifier blueprint_identifier blueprint_name buildable_name <<< "$identifiers"

    # Add pre-actions build script to the Runner scheme
    if ! grep -q "entry_decode" "$SCHEME_FILE"; then
        echo "Adding pre-actions build script to scheme: $SCHEME_FILE"

        # Backup the original file
        cp "$SCHEME_FILE" "$SCHEME_FILE.bak"

        # Insert the PreActions block after </BuildAction> tag
        awk -v buildable_identifier="$buildable_identifier" -v blueprint_identifier="$blueprint_identifier" -v blueprint_name="$blueprint_name" -v buildable_name="$buildable_name" '
        /<\/BuildAction>/ {
            print "      <PreActions>"
            print "         <ExecutionAction"
            print "            ActionType = \"Xcode.IDEStandardExecutionActionsCore.ExecutionActionType.ShellScriptAction\">"
            print "            <ActionContent"
            print "               title = \"Run Script\""
            print "               scriptText = \"#!/bin/sh&#10;&#10;function entry_decode() { echo &quot;${*}&quot; | base64 --decode; }&#10;&#10;IFS=&apos;,&apos; read -r -a define_items &lt;&lt;&lt; &quot;$DART_DEFINES&quot;&#10;&#10;for index in &quot;${!define_items[@]}&quot;&#10;do&#10;    define_items[$index]=$(entry_decode &quot;${define_items[$index]}&quot;);&#10;done&#10;&#10;printf &quot;%s\\n&quot; &quot;${define_items[@]}&quot; &gt; ${SRCROOT}/Flutter/Environment.xcconfig&#10;\">"
            print "               <EnvironmentBuildable>"
            print "                  <BuildableReference"
            print "                     BuildableIdentifier = \"" buildable_identifier "\""
            print "                     BlueprintIdentifier = \"" blueprint_identifier "\""
            print "                     BuildableName = \"" buildable_name "\""
            print "                     BlueprintName = \"" blueprint_name "\""
            print "                     ReferencedContainer = \"container:Runner.xcodeproj\">"
            print "                  </BuildableReference>"
            print "               </EnvironmentBuildable>"
            print "            </ActionContent>"
            print "         </ExecutionAction>"
            print "      </PreActions>"
        }
        { print $0 }
        ' "$SCHEME_FILE.bak" > "$SCHEME_FILE"

        echo "Pre-actions build script added successfully."
    else
        echo "Pre-actions build script already exists in Runner scheme."
    fi
done

# Add include statement to Debug.xcconfig and Release.xcconfig
for CONFIG in Debug Release; do
    CONFIG_FILE="$ROOT_DIR/ios/Flutter/${CONFIG}.xcconfig"
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
