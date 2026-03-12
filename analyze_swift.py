import re
import os
from pathlib import Path

def analyze_file(filepath):
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Get imports
    imports = re.findall(r'^import\s+(\w+)', content, re.MULTILINE)
    
    # Get main type declarations
    types = re.findall(r'^(class|struct|enum|protocol|extension)\s+(\w+)', content, re.MULTILINE)
    
    # Check for UIKit types in declarations
    uikit_pattern = r'\b(UIView|UIViewController|UIImage|UIColor|UIScrollView|UICollectionView|UITableView|UIButton|UILabel|UITextView|UIImageView|UIStackView|UIAlertView|UIDevice|UIApplication|UILayoutPriority|UIInterfaceOrientation|UIUserInterfaceSizeClass|UIBarButtonItem|UIPresentationController|UIGestureRecognizer|UITapGestureRecognizer|UIPanGestureRecognizer|UIResponder|UIControl|UIAccessibility|UIKeyboardType)\b'
    uikit_uses = len(re.findall(uikit_pattern, content))
    
    # Check specific UIKit types
    has_uiview = 'UIView' in content
    has_uiviewcontroller = 'UIViewController' in content
    has_uiimage = 'UIImage' in content
    has_uicolor = 'UIColor' in content
    has_uiscrollview = 'UIScrollView' in content
    has_uicontrol = 'UIControl' in content
    has_uibutton = 'UIButton' in content
    has_uilabel = 'UILabel' in content
    
    # Determine category
    if uikit_uses == 0 or (imports and 'UIKit' not in imports and 'SwiftUI' not in imports):
        category = "pure"
    elif uikit_uses == imports.count('UIColor'):  # only UIColor
        category = "color-only"
    else:
        category = "ui-heavy"
    
    can_be_macos = not (has_uiview or has_uiviewcontroller or has_uiimage or has_uiscrollview or has_uicontrol or has_uibutton or has_uilabel)
    
    return {
        'path': filepath,
        'imports': imports,
        'types': types,
        'uikit_uses': uikit_uses,
        'category': category,
        'can_be_macos': can_be_macos,
        'has_uicolor': has_uicolor,
    }

# Find all Swift files
root = Path('Sources/Mantis')
files = sorted(root.rglob('*.swift'))

for f in files:
    analysis = analyze_file(str(f))
    rel_path = str(f.relative_to('Sources/Mantis'))
    
    imports_str = ', '.join(analysis['imports']) if analysis['imports'] else 'none'
    types_str = ', '.join([f"{t[0]} {t[1]}" for t in analysis['types']]) if analysis['types'] else 'none'
    
    print(f"\n{rel_path}")
    print(f"  Imports: {imports_str}")
    print(f"  Types: {types_str}")
    print(f"  UIKit types in file: {analysis['uikit_uses']}")
    print(f"  macOS compatible (UIColor→NSColor): {analysis['can_be_macos']}")
    print(f"  Category: {analysis['category']}")

