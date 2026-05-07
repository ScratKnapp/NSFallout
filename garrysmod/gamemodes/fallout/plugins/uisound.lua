local PLUGIN = PLUGIN
PLUGIN.name = "UI Sound Overwrite"
PLUGIN.author = ""
PLUGIN.desc = "Overwrites various UI sounds"

--
if(CLIENT) then
	SOUND_BUSINESS_BUY = "ui_menu_ok.wav"
	SOUND_BUSINESS_PREVENT_BUY = "buttons/button11.wav"
	SOUND_BUSINESS_PREVENT_RESPONSE = "buttons/button3.wav"
	SOUND_BUSINESS_PREVENT_TIMEOUT = "ui_menu_cancel.wav"
	SOUND_CUSTOM_CHAT_SOUND = ""
	SOUND_F1_MENU_UNANCHOR = "ui_menu_ok.wav"
	SOUND_MENU_BUTTON_ROLLOVER = "ui_menu_focus.wav"
	SOUND_MENU_BUTTON_PRESSED = "ui_menu_ok.wav"
	SOUND_NOTIFY = {"ui_popup_messagewindow.wav", 75, 100}
	SOUND_CHAR_HOVER = {"ui_menu_focus.wav", 75, 100}
	SOUND_CHAR_CLICK = {"ui_menu_prevnext.wav", 75, 100}
	SOUND_CHAR_WARNING = {"ui_menu_cancel.wav", 75, 100}
	SOUND_BAG_RESPONSE = {"ui_items_takeall.wav", 50}
	SOUND_ATTRIBUTE_BUTTON = {"ui_menu_focus.wav", 30, 100}
	SOUND_VENDOR_CLICK = {"ui_menu_cancel.wav", 30, 100}
end