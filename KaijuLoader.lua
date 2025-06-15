-- KaijuParadise Key Loader
local SECRET_KEY = "502730583724508"  -- Your activation key
local HWID_SECRET = "KaijuParadise_HWID_2024"  -- Change this before deployment

-- Get hardware ID for device locking
local function getHWID()
    local identifiers = ""
    pcall(function()
        identifiers = game:GetService("RbxAnalyticsService"):GetClientId() or ""
    end)
    pcall(function()
        identifiers ..= tostring(game:GetService("ContentProvider"):GetAssetId() or "")
    end)
    return #identifiers > 0 and identifiers or "DEFAULT_HWID_"..tostring(math.random(10000,99999))
end

-- Simple but effective obfuscation
local function transformKey(input)
    local transformed = ""
    for i = 1, #input do
        local byte = string.byte(input, i)
        transformed = transformed .. string.char(byte + 3 - (i % 3))
    end
    return transformed
end

-- Validate the key
local function validateKey(input)
    if not input or type(input) ~= "string" then
        return false
    end
    
    -- Clean input
    local cleanKey = input:gsub("%s+", "")
    
    -- Transform both keys for comparison
    local transformedInput = transformKey(cleanKey)
    local transformedSecret = transformKey(SECRET_KEY)
    
    return transformedInput == transformedSecret
end

-- Main execution flow
local function main()
    -- Check if key exists in environment
    if not getgenv().Key then
        warn("❌ ERROR: Key not found. Use: getgenv().Key = \"YOUR_KEY\"")
        return
    end

    -- Validate the key
    if validateKey(getgenv().Key) then
        print("✅ Key validated! Loading executor...")
        
        -- Add hardware ID lock (optional)
        getgenv().HWID = getHWID()
        
        -- Load the main executor
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Mixvpnv2/KaijuParadise/refs/heads/main/KaijuParadise", true))()
        end)
        
        if not success then
            warn("❌ Failed to load executor: "..tostring(err))
        end
    else
        warn("❌ Invalid key! Please check your activation key")
        warn("Contact support if you believe this is an error")
    end
end

-- Run the loader
pcall(main)
