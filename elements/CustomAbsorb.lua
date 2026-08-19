local A, L = ...
local oUF = L.oUF or oUF

---------------------------------------------------------------------
-- UpdateAbsorbs(self, event, unit)
---------------------------------------------------------------------

local function UpdateAbsorbs(self, event, unit)
  if not unit or self.__unit ~= unit then return end
  local element = self.CustomAbsorb
  if not element then return end
  if element.PreUpdate then
    element:PreUpdate(unit)
  end
  local currentAbsorb = UnitGetTotalAbsorbs(unit) or 0
  local maxHealth = UnitHealthMax(unit) or 1
  element:SetMinMaxValues(0, maxHealth)
  element:SetValue(currentAbsorb, Enum.StatusBarInterpolation.ExponentialEaseOut)
  if element.PostUpdate then
    element:PostUpdate(unit, currentAbsorb, maxHealth)
  end
end

---------------------------------------------------------------------
-- Path(self, ...)
---------------------------------------------------------------------

local function Path(self, ...)
  return (self.CustomAbsorb.Override or UpdateAbsorbs)(self, ...)
end

---------------------------------------------------------------------
-- Enable(self, unit)
---------------------------------------------------------------------

local function Enable(self, unit)
  local element = self.CustomAbsorb
  if not element then return end
  element.__owner = self
  self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", Path)
  self:RegisterEvent("UNIT_MAXHEALTH", Path)
  self:RegisterEvent("UNIT_HEALTH", Path)
  if not element:GetStatusBarTexture() then
    element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
  end
  element:Show()
  return true
end

---------------------------------------------------------------------
-- Disable(self)
---------------------------------------------------------------------

local function Disable(self)
  local element = self.CustomAbsorb
  if not element then return end
  self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", Path)
  self:UnregisterEvent("UNIT_MAXHEALTH", Path)
  self:UnregisterEvent("UNIT_HEALTH", Path)
  element:Hide()
end

---------------------------------------------------------------------
-- AddElement("CustomAbsorb", Path, Enable, Disable)
---------------------------------------------------------------------

oUF:AddElement("CustomAbsorb", Path, Enable, Disable)