local module = {}

local function runDeskCommand(command, successMsg)
  hs.notify.new({
    title = "Desk Control",
    informativeText = "Processing..."
  }):send()

  -- Use hs.execute instead of hs.task for better compatibility
  hs.timer.doAfter(0.1, function()
    local output, status, exitType, exitCode = hs.execute(
      "/Users/vadari/.config/linak-controller/desk_wrapper.sh " .. command,
      true
    )

    if status then
      hs.notify.new({
        title = "Desk Control",
        informativeText = successMsg or output
      }):send()
    else
      -- Check log file for details
      local logOutput = hs.execute("tail -20 /tmp/desk_control.log", true)
      hs.notify.new({
        title = "Desk Control",
        informativeText = "Error - check log: /tmp/desk_control.log",
        hasActionButton = false
      }):send()
      print("Desk control error:", output)
      print("Log:", logOutput)
    end
  end)
end

module.init = function(k)
  -- Ctrl+T, then S for Sit
  k:bind('', 's', function()
    runDeskCommand("sit", "Moved to sitting position")
    k:exit()
  end)

  -- Ctrl+T, then D for Stand
  k:bind('', 'd', function()
    runDeskCommand("stand", "Moved to standing position")
    k:exit()
  end)

  -- Ctrl+T, then P for Position (check current height)
  k:bind('', 'p', function()
    runDeskCommand("position", nil)  -- Use the command's output as message
    k:exit()
  end)
end

return module
