local _, AvianaPOI = ...;

AvianaPinLocationDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin);

function AvianaPinLocationDataProviderMixin:OnAdded(mapCanvas)
	MapCanvasDataProviderMixin.OnAdded(self, mapCanvas);
	-- canvas handlers
	local priority = 80;
	self.onCanvasClickHandler = self.onCanvasClickHandler or function(mapCanvas, button, cursorX, cursorY) return self:OnCanvasClickHandler(button, cursorX, cursorY) end;
	mapCanvas:AddCanvasClickHandler(self.onCanvasClickHandler, priority);
	self.onPinMouseActionHandler = self.onPinMouseActionHandler or function(mapCanvas, mouseAction, button) return self:OnPinMouseActionHandler(mouseAction, button) end;
	mapCanvas:AddGlobalPinMouseActionHandler(self.onPinMouseActionHandler, priority);	
	self.cursorHandler = self.cursorHandler or
		function()
			if self:CanPlacePin() then
				return "MAP_PIN_CURSOR";
			end
		end
	;
	mapCanvas:AddCursorHandler(self.cursorHandler, priority);
	
	self:GetMap():RegisterCallback("AvianaPinLocationToggleUpdate", self.OnWayPointLocationToggleUpdate, self);
end

function AvianaPinLocationDataProviderMixin:OnPinMouseActionHandler(mouseAction, button)
	if button ~= "LeftButton" or mouseAction == MapCanvasMixin.MouseAction.Up or not self:CanPlacePin() then
		return false;
	end
	if mouseAction == MapCanvasMixin.MouseAction.Click then
		self:HandleClick(button);
	end
	-- do nothing on MapCanvasMixin.MouseAction.Down
	return true;
end


function AvianaPinLocationDataProviderMixin:OnCanvasClickHandler(button, cursorX, cursorY)
	if self:CanPlacePin() then
		self:HandleClick(button);
		return true;
	end
	return false;
end


function AvianaPinLocationDataProviderMixin:OnRemoved(mapCanvas)
	mapCanvas:RemoveCursorHandler(self.cursorHandler);
	MapCanvasDataProviderMixin.OnRemoved(self, mapCanvas);
end

function AvianaPinLocationDataProviderMixin:HandleClick(button)
	--if self.pin and self.pin:IsMouseOver() then
	--	C_Map.ClearUserWaypoint();
		--C_SuperTrack.SetSuperTrackedUserWaypoint(false);
		PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_REMOVE);
	--else
		local mapID = self:GetMap():GetMapID();
		local scrollContainer = self:GetMap().ScrollContainer;
		local cursorX, cursorY = scrollContainer:NormalizeUIPosition(scrollContainer:GetCursorPosition());
			if self:CanPlacePin() then
				if button == "LeftButton" then
					print(cursorX, cursorY)
				end
				C_ChatInfo.SendAddonMessage(AvianaPOI.DeactivatePrefix, "D", "WHISPER", UnitName("player"))
			end
			--local uiMapPoint = UiMapPoint.CreateFromCoordinates(mapID, cursorX, cursorY);
			--C_Map.SetUserWaypoint(uiMapPoint);
			--C_SuperTrack.SetSuperTrackedUserWaypoint(false);
	--end
end
function AvianaPinLocationDataProviderMixin:OnWayPointLocationToggleUpdate(isActive)
	self.toggleActive = isActive;
end
function AvianaPinLocationDataProviderMixin:CanPlacePin()
	return self.toggleActive;
end

----------------------------------






AvianaTrackingPinButtonMixin = { };

function AvianaTrackingPinButtonMixin:OnLoad()
	self:RegisterEvent("CHAT_MSG_ADDON");
end

function AvianaTrackingPinButtonMixin:OnEvent(event, prefix, ...)
	if event == "CHAT_MSG_ADDON" then
		if prefix == AvianaPOI.DeactivatePrefix then
			self:SetActive(false);
		end
	end
end

function AvianaTrackingPinButtonMixin:OnMouseDown(button)
	if self:IsEnabled() then
		self.Icon:SetPoint("TOPLEFT", 8, -8);
		self.IconOverlay:Show();
	end
end

function AvianaTrackingPinButtonMixin:OnMouseUp()
	self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6);
	self.IconOverlay:Hide();
end

function AvianaTrackingPinButtonMixin:OnClick()
	local shouldSetActive = not self.isActive;
	self:SetActive(shouldSetActive);
	PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_BUTTON_CLICK_ON);
end

function AvianaTrackingPinButtonMixin:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip_SetTitle(GameTooltip, "Ролевые точки на карте");
	local mapID = self:GetParent():GetMapID();
	print(mapID)
	
	GameTooltip_AddNormalLine(GameTooltip, "Вы можете поставить на карте ролевую точку.");
	GameTooltip_AddBlankLineToTooltip(GameTooltip);
	GameTooltip_AddInstructionLine(GameTooltip, "Щелкните по этой кнопке и укажите нужное место на карте.");
	GameTooltip:Show();
end

function AvianaTrackingPinButtonMixin:OnHide()
	self:SetActive(false);
end

function AvianaTrackingPinButtonMixin:Refresh()
	local mapID = self:GetParent():GetMapID();
	self:Enable();
	self:DesaturateHierarchy(0);
end

function AvianaTrackingPinButtonMixin:SetActive(isActive)
	self.isActive = isActive;
	self.ActiveTexture:SetShown(isActive);
	self:GetParent():TriggerEvent("AvianaPinLocationToggleUpdate", isActive);
end