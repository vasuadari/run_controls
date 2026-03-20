local module = {}

function module.cycleAppWindows(appName)
   local app = hs.application.find(appName)
   if not app then
      hs.application.launchOrFocus(appName)
      return
   end

   local windows = app:visibleWindows()
   if #windows == 0 then
      hs.application.launchOrFocus(appName)
      return
   elseif #windows == 1 then
      windows[1]:focus()
      return
   end

   -- Find currently focused window
   local focusedWindow = hs.window.focusedWindow()
   local currentIndex = nil

   for i, window in ipairs(windows) do
      if window == focusedWindow and window:application() == app then
         currentIndex = i
         break
      end
   end

   -- Cycle to next window
   local nextIndex = currentIndex and ((currentIndex % #windows) + 1) or 1
   windows[nextIndex]:focus()
end

module.init = function(k)
   local applications = {
      a = 'Alacritty',
      d = 'Dash',
      s = 'Slack',
      p = 'Postman',
      z = 'zoom.us',
      i = 'Preview',
      f = 'Finder',
      n = 'Numi',
      m = 'Sequel Pro',
      x = 'Firefox',
      w = 'Safari'
   }

   for key, application in pairs(applications) do
      k:bind('', key, function()
         module.cycleAppWindows(application)
         k:exit()
      end)
   end
end
return module
