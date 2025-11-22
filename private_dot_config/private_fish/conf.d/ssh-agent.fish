# SSH Agent configuration for Fish shell

if status is-interactive
    # macOS: Use the keychain SSH agent
    if test (uname) = "Darwin"
        # macOS handles SSH agent via launchd and keychain
        # Just ensure we're using the keychain
        set -gx SSH_AUTH_SOCK ~/.ssh/auth_sock
        
        # Link to the macOS SSH agent socket if it exists
        if test -S "$SSH_AUTH_SOCK"
            # Socket exists, we're good
        else if test -S /private/tmp/com.apple.launchd.*/Listeners
            # Find and link the SSH agent socket
            ln -sf /private/tmp/com.apple.launchd.*/Listeners $SSH_AUTH_SOCK 2>/dev/null
        end
    else
        # Linux: Start SSH agent if not running
        if not set -q SSH_AGENT_PID
            eval (ssh-agent -c | sed 's/^setenv/set -gx/;s/;$//')
        end
    end
    
    # Function to add common keys
    function ssh-add-keys --description "Add common SSH keys to agent"
        ssh-add ~/.ssh/id_ed25519 2>/dev/null
        ssh-add ~/.ssh/id_rsa 2>/dev/null
        # Add other keys as needed
    end
end