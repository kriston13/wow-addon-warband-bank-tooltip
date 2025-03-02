local _, WBICT = ...

WBICT:RegisterEvent("BANKFRAME_OPENED")
WBICT:RegisterEvent("BANKFRAME_CLOSED")
WBICT:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
WBICT:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
WBICT:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED")
WBICT:RegisterEvent("BAG_UPDATE") -- BAG_UPDATE_DELAYED doesn't include the bagId, but BAG_UPDATE does


local isBankOpen = false
local WarbankStart = BACKPACK_CONTAINER + ITEM_INVENTORY_BANK_BAG_OFFSET + NUM_BANKBAGSLOTS 
local WarbankEnd = WarbankStart + 4
local bankContents = {}
-- structure is
-- bankContents[id][1] = itemId
-- bankContents[id][2] = stackCount
-- bankContents[id][3] = name (debugging)
local function ScanWarbandBank()

    if isBankOpen then
        print("Scanning Warband Bank")
        -- mustUpdate = false
        wipe(bankContents)

        for bag=WarbankStart, WarbankEnd,1 do
            -- print("looking at bag",bag)
            for slot = 1, C_Container.GetContainerNumSlots(bag) do
                local itemInfo = C_Container.GetContainerItemInfo(bag,slot)
                if itemInfo then
                    -- print('adding ',itemInfo.itemID, 'with count of ',itemInfo.stackCount)
                    if not bankContents[itemInfo.itemID] then
                        bankContents[itemInfo.itemID] = {}
                        bankContents[itemInfo.itemID][1] = itemInfo.itemID
                        bankContents[itemInfo.itemID][2] = itemInfo.stackCount
                        bankContents[itemInfo.itemID][3] = C_Item.GetItemNameByID(itemInfo.itemID)
                    else
                        bankContents[itemInfo.itemID][2] = bankContents[itemInfo.itemID][2] + itemInfo.stackCount
                    end
                end
            end
        end
        if next(bankContents) ~= nil then
            WBICT:Save(bankContents)
        end 
    end

end


function WBICT:BANKFRAME_OPENED(e)
    isBankOpen = true
    C_Timer.After(0.5, ScanWarbandBank)
end

function WBICT:BANKFRAME_CLOSED(e)
    isBankOpen = false
end


function WBICT:PLAYERBANKBAGSLOTS_CHANGED(e)
    -- isBankOpen = true
    C_Timer.After(0.5, ScanWarbandBank)
end


function WBICT:PLAYERBANKSLOTS_CHANGED(e)
    -- isBankOpen = true
    C_Timer.After(0.5, ScanWarbandBank)
end


function WBICT:PLAYERREAGENTBANKSLOTS_CHANGED(e)
    -- isBankOpen = true
    C_Timer.After(0.5, ScanWarbandBank)
end

local updateTimer
local lastUpdatedBag
function WBICT:BAG_UPDATE(bagId)

    -- Check if the updated bag is a Warband bank bag
    if bagId and bagId >= WarbankStart and bagId <= WarbankEnd and isBankOpen then
        lastUpdatedBag = bagId  -- Store the last updated bag ID

        -- Throttle updates with a timer
        if updateTimer then
            updateTimer:Cancel()
        end
        updateTimer = C_Timer.NewTimer(0.5, ScanWarbandBank)
    end
end