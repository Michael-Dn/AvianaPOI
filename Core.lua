print("CUSTOM POI CORE LOADED.")

local AvianaPOI, AvianaPOI = ...;

AvianaAddonPOI = LibStub("AceAddon-3.0"):NewAddon("AvianaAddonPOI")
local HereBeDragons_Pins = LibStub("HereBeDragons-Pins-2.0")
local HereBeDragons = LibStub("HereBeDragons-2.0")

AvianaPOI.DeactivatePrefix = "DEACT_CURSOR"


--[[AvianaAddonPOI.POI = CreateFrame("BUTTON", "AvianaAddonPOI.POI_1", UIParent);
AvianaAddonPOI.POI:SetSize(29, 29)
AvianaAddonPOI.POI:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
AvianaAddonPOI.POI:RegisterForClicks("AnyUp")
AvianaAddonPOI.POI:SetNormalTexture("Interface\\Icons\\wow_store")
AvianaAddonPOI.POI:SetHighlightTexture("Interface\\Icons\\wow_store")
AvianaAddonPOI.POI:SetFrameStrata("FULLSCREEN_DIALOG")
AvianaAddonPOI.POI:Show()]]



--[[local button = CreateFrame("Button", "MyRoundButton", UIParent, "AvianaPinActivateButtonTemplate")
button:SetPoint("CENTER")
button:SetSize(35, 35)]]
--button:SetTexture("Interface\\Artifacts\\Artifacts-PerkRing-Final-Mask")

--[[button.IconTexture = button:CreateTexture(nil,"BACKGROUND", nil, 1)
button.IconTexture:SetPoint("CENTER")
button.IconTexture:SetSize(button:GetWidth() , button:GetHeight() )
SetPortraitToTexture(button.IconTexture,"Interface\\Icons\\wow_store")

button.RingTexture = button:CreateTexture(nil, "ARTWORK", nil, 2)
button.RingTexture:SetPoint("CENTER")
button.RingTexture:SetTexture("Interface\\Artifacts\\Artifacts-PerkRing-Final-Mask")
button.RingTexture:SetSize(button:GetWidth() * 1.27, button:GetHeight() * 1.27)

button:SetScript("OnClick", function(self, button)
	print(button)
end)]]

function AvianaAddonPOI:OnEnable()
	C_ChatInfo.RegisterAddonMessagePrefix(AvianaPOI.DeactivatePrefix)
	WorldMapFrame:AddDataProvider(CreateFromMixins(AvianaPinLocationDataProviderMixin));
	WorldMapFrame:AddOverlayFrame("AvianaPinActivateButtonTemplate", "BUTTON", "TOPRIGHT", WorldMapFrame:GetCanvasContainer(), "TOPRIGHT", -68, -2);
end


SLASH_POITEST1 = "/poitest"
SlashCmdList["POITEST"] = function(msg)
	HereBeDragons_Pins:AddWorldMapIconMap(AvianaAddonPOI, button, 274, 0.5, 0.5, nil, PIN_FRAME_LEVEL_AREA_POI)
	print(C_Map.GetMapInfo(WorldMapFrame:GetMapID()).mapID)
end