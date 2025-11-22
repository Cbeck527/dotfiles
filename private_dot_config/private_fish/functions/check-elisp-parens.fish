function check-elisp-parens --description "Check Emacs Lisp files for parsing errors using tree-sitter"
    set -l grammar_dir "/Users/chris/.local/share/tree-sitter/tree-sitter-elisp"
    set -l grammar_file "$grammar_dir/src/parser.c"

    # Check if arguments were provided
    if test (count $argv) -eq 0
        echo "Usage: check-elisp-parens <file1.el> [file2.el ...]"
        return 1
    end

    # Check if grammar is generated
    if not test -f $grammar_file
        echo "Error: tree-sitter elisp grammar not generated!"
        echo "Please run:"
        echo "  cd $grammar_dir"
        echo "  tree-sitter generate --abi 14"
        echo "Then try again."
        return 1
    end

    # Save current directory
    set -l original_dir (pwd)

    # Change to grammar directory
    cd $grammar_dir

    # Process each file
    set -l exit_code 0

    for file in $argv
        # Get absolute path of the file
        set -l abs_file (realpath -q $original_dir/$file 2>/dev/null)

        # If realpath failed, try the file as-is (might already be absolute)
        if test -z "$abs_file"
            set abs_file (realpath -q $file 2>/dev/null)
        end

        # Check if file exists
        if test -z "$abs_file"; or not test -f "$abs_file"
            echo "x $file: File not found"
            set exit_code 1
            continue
        end

        # Run tree-sitter parse and capture output
        tree-sitter parse -q $abs_file 2>&1
    end

    # Return to original directory
    cd $original_dir
end
