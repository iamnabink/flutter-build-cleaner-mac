#!/usr/bin/env python3
"""
Script to remove all monospace font usage and fix const issues.
"""

import re
from pathlib import Path

def remove_monospace_and_fix_const(file_path):
    """Remove monospace fonts and fix const issues."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return False
    
    original_content = content
    
    # Remove .copyWith(fontFamily: 'monospace')
    content = re.sub(r'\.copyWith\(fontFamily:\s*[\'"]monospace[\'"]\)', '', content)
    
    # Remove .copyWith(fontFamily: 'Courier')
    content = re.sub(r'\.copyWith\(fontFamily:\s*[\'"]Courier[\'"]\)', '', content)
    
    # Remove conditional fontFamily: label == 'Full Path' ? 'monospace' : null
    content = re.sub(
        r'\)\.copyWith\(fontFamily:\s*label\s*==\s*[\'"]Full\s+Path[\'"]\s*\?\s*[\'"]monospace[\'"]\s*:\s*null\)',
        ')',
        content
    )
    
    # Remove fontFamily parameter from GoogleFonts.montserrat if it exists
    # Pattern: fontFamily: label == 'Full Path' ? 'monospace' : null,
    content = re.sub(
        r'fontFamily:\s*label\s*==\s*[\'"]Full\s+Path[\'"]\s*\?\s*[\'"]monospace[\'"]\s*:\s*null,\s*\n\s*',
        '',
        content
    )
    
    # Fix const Text( that uses GoogleFonts.montserrat
    lines = content.split('\n')
    new_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        
        # Check if this line has const Text(
        if re.search(r'\bconst\s+Text\s*\(', line):
            # Look ahead to find if style uses GoogleFonts.montserrat
            j = i
            found_google_fonts = False
            
            # Look ahead up to 20 lines
            while j < min(i + 20, len(lines)):
                look_line = lines[j]
                if 'GoogleFonts.montserrat' in look_line:
                    found_google_fonts = True
                    break
                # Stop if we hit the closing paren of Text widget
                if j > i and ')' in look_line:
                    before = '\n'.join(lines[i:j+1])
                    if before.count('(') <= before.count(')'):
                        break
                j += 1
            
            # If we found GoogleFonts.montserrat, remove const
            if found_google_fonts:
                line = re.sub(r'\bconst\s+Text\s*\(', 'Text(', line)
        
        new_lines.append(line)
        i += 1
    
    content = '\n'.join(new_lines)
    
    # Clean up any double closing parens that might have been created
    content = re.sub(r'\)\s*\)\s*\)', '))', content)
    content = re.sub(r'\)\s*\)\s*\)', '))', content)  # Do it twice for nested cases
    
    if content != original_content:
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        except Exception as e:
            print(f"Error writing {file_path}: {e}")
            return False
    
    return False

def main():
    """Main function."""
    dart_files = []
    for pattern in ['lib/widgets/**/*.dart', 'lib/pages/*.dart']:
        dart_files.extend(Path('.').glob(pattern))
    
    updated_count = 0
    for file_path in sorted(dart_files):
        if file_path.is_file():
            print(f"Processing: {file_path}")
            if remove_monospace_and_fix_const(file_path):
                updated_count += 1
                print(f"  ✓ Updated")
    
    print(f"\n✓ Removed monospace fonts and fixed const issues in {updated_count} files.")

if __name__ == '__main__':
    main()

