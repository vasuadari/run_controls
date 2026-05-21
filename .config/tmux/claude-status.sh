#!/bin/bash
# Claude Code tmux status indicator
# Shows current model and context usage

CLAUDE_SOCKET="/tmp/claude-code-*.sock"

if [ -S $CLAUDE_SOCKET ]; then
    # Claude Code is running
    echo "󱚣 Claude"
else
    echo ""
fi
