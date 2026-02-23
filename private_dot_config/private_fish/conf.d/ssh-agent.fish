# SSH Agent configuration for Fish shell

if status is-interactive
    # macOS: Use the system SSH agent via launchd
    if test (uname) = "Darwin"
        # macOS sets SSH_AUTH_SOCK automatically via launchd
        # Only intervene if it's not set or invalid
        if not test -S "$SSH_AUTH_SOCK"
            # Find the launchd SSH agent socket
            set -l agent_sock (find /private/tmp/com.apple.launchd.*/Listeners -type s 2>/dev/null | head -1)
            if test -n "$agent_sock" -a -S "$agent_sock"
                set -gx SSH_AUTH_SOCK $agent_sock
            end
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