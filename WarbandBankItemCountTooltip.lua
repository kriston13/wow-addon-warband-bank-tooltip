local addonName, WBICT = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

function WBICT:RegisterEvent(event)
    frame:RegisterEvent(event)
end

function WBICT:UnregisterEvent(event)
    frame:UnregisterEvent(event)
end

function WBICT:ADDON_LOADED(arg1)
    -- print('DEBUG: this is',arg1)
    if arg1 == "WarbandBankItemCountTooltip" then
        -- print("DEBUG: ADDON_LOADED fired for", arg1) -- Debug message

        -- Ensure WBICT_DB exists and is a table
        if not WBICT_DB or type(WBICT_DB) ~= "table" then
            -- print("DEBUG: WBICT_DB was nil or not a table. Initializing now.")
            WBICT_DB = {}
        end
    end
end

function WBICT:Save(bankContents)
    WBICT_DB = bankContents
end

function WBICT:GetWarbankCount(itemId)
    if itemId and WBICT_DB[itemId] then
        -- print("db has ".. itemId .. " called ".. C_Item.GetItemNameByID(itemId))
        return WBICT_DB[itemId][2]
    end
    return 0
end

frame:SetScript("OnEvent", function(self, event, ...)
    WBICT[event](WBICT, ...)
end)

