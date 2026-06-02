-- Pipboy input manager.
--

pipboy = pipboy or {}
pipboy.input = pipboy.input or {}
local PI = pipboy.input

-- One-shot button EVENTS. Set on the matching +bind press, read by the active
-- page during PreRender, force-cleared at the end of that pass.
PI.leftClick  = false   -- +attack   (was IsLeftClickPress)
PI.rightClick = false   -- +attack2  (was IsRightMouseDown)
PI.use        = false   -- +use      (was IsUseDown)
PI.reload     = false   -- +reload   (was IsReloadUse)

-- Live HELD key state, refreshed every Think. Peek only; never consumed.
PI.reloadHeld = false   -- KEY_R held (was IS_R_DOWN)

-- Polled left-mouse, refreshed once per PreRender pass in Poll().
PI.leftEdge   = false   -- one-frame press edge (was the local IsLeftMouseDown)
PI.leftDown   = false   -- raw button-held (for drags / sliders)
PI._leftPrev  = false   -- internal: previous frame's leftDown

--- Lifecycle ---------------------------------------------------------------


function PI:HandleBind(bind)
    if bind == "+attack"  then self.leftClick  = true return true end
    if bind == "+attack2" then self.rightClick = true return true end
    if bind == "+reload"  then self.reload     = true return true end
    if bind == "+use"     then self.use        = true return true end
    return false
end

-- Top of the PreRender pass, before any page logic: sample the physical left
-- button and derive a one-frame press edge.
function PI:Poll()
    local down = input.IsMouseDown(MOUSE_LEFT)
    self.leftEdge  = down and not self._leftPrev
    self.leftDown  = down
    self._leftPrev = down
end

-- End of the PreRender pass, after page logic: drop any one-shot the active
-- page did not consume so it never leaks into the next frame.
function PI:Clear()
    self.leftClick  = false
    self.rightClick = false
    self.use        = false
    self.reload     = false
end

-- Every T"hink": refresh held-key state. Suppressed while a Derma panel owns
-- input (text entry etc.), matching the old IS_R_DOWN behaviour.
function PI:UpdateHeld()
    self.reloadHeld = input.IsKeyDown(KEY_R) and not PIPBOY_INPUT_BLOCKED()
end

--- Queries -----------------------------------------------------------------

-- Peek: is this event pending this frame? Does NOT consume -- use when several
-- things may react to the same press, or when end-of-frame Clear() is enough.
function PI:LeftClick()  return self.leftClick  end
function PI:RightClick() return self.rightClick end
function PI:Use()        return self.use        end
function PI:Reload()     return self.reload     end

-- Take: consume the event, returning true at most once per press. Use when a
-- single handler should "own" the press (the common case for buttons/menus).
function PI:TakeLeftClick()  local v = self.leftClick;  self.leftClick  = false return v end
function PI:TakeRightClick() local v = self.rightClick; self.rightClick = false return v end
function PI:TakeUse()        local v = self.use;        self.use        = false return v end
function PI:TakeReload()     local v = self.reload;     self.reload     = false return v end

-- Held / polled state (peek; refreshed by UpdateHeld / Poll).
function PI:ReloadHeld() return self.reloadHeld end  -- KEY_R held right now
function PI:LeftEdge()   return self.leftEdge   end  -- left pressed this frame
function PI:LeftDown()   return self.leftDown   end  -- left button held (drag)
