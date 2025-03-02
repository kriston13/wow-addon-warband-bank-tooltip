local _, WBICT = ...

local lastId, lastItemCount

local function SetWarbandBankItemToTooltip(tooltip, data)
    -- print("DEBUG: Looking for item ID: " .. (data.id or "nil"))

    if data.id and data.id ~= lastId then
        lastId = data.id
        lastItemCount = WBICT:GetWarbankCount(data.id)
    end

    if lastItemCount and lastItemCount > 0 then
        tooltip:AddDoubleLine("Warband Bank", lastItemCount)
        tooltip:Show()
    end
end

-- print("DEBUG: Hooking tooltips for Warband Bank item count")
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, SetWarbandBankItemToTooltip)

-- -- 🔹 Extra Hook in case TooltipDataProcessor isn't working
-- GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
--     local _, itemLink = tooltip:GetItem()
--     if itemLink then
--         local itemId = tonumber(itemLink:match("item:(%d+)"))
--         if itemId then
--             SetWarbandBankItemToTooltip(tooltip, { id = itemId })
--         end
--     end
-- end)