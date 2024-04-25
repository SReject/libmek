-- Installer posted to pastebin

local args = {...}
local GH_API_URI = 'https://api.github.com/';
local RELEASES_URI = GH_API_URI .. 'repos/SReject/libmek/releases';
local LATEST_RELEASE_URI = RELEASES_URI .. '/latest';

local function parseBody(response, cb)
    if (response == nil) then
        error('http request failed');
    end

    local body = response.readAll();
    if (body == nil or body == "") then
        error('http request returned no data');
    end

    local success, json = pcall(textutils.unserializeJSON, body);
    if (success ~= true) then
        error('http request did not return valid JSON data');
    end

    return json;
end

-- Attempt to get latest release
local result, errmsg = http.get(LATEST_RELEASE_URI);
local success, body;
if (result) then
    success,body = pcall(parseBody, result);
    if (success ~= true) then
        body = nil;
    end
end
if (result == nil or body == nil) then
    result,errmsg = http.get(RELEASES_URI);
    if (result == nil) then
        print("[libmek] Failed to retrieve list of available releases:");
        print("    " .. errmsg);
        return;
    end
    success,body = pcall(parseBody, result);
    if (success ~= true) then
        print("[libmek] Failed to retrieve list of available releases:");
        print("    "..body)
    elseif (body == nil) then
        print("[libmek] Failed to retrieve list of available releases:");
        print("   No data was returned");
    end
    ---@cast body table
    body = body[1]
end

---@type table
local assets = body["assets"];

local libmek, libmekmin;
for i,asset in pairs(assets) do
    if (asset["name"] == "libmek.lua") then
        libmek = asset["browser_download_url"];
    elseif (asset["name"] == "libmek.min.lua") then
        libmekmin = asset["browser_download_url"];
    end
end

local fileURL;
if (args[1] == "min" or args[1] == "mini" or args[1] == "minify" or args[1] == "minified") then
    fileURL = libmekmin;
else
    fileURL = libmek;
end

if (fileURL == nil) then
    print("[libmek] Failed to retrieve library file url")
    return;
end

result, errmsg = http.get(fileURL);
if (result == nil) then
    print("[libmek] Failed to retrieve library file:\n");
    print("    " .. errmsg);
    return;
end

body = result.readAll();
if (body == nil or body == "") then
    print("[libmek] Failed to retrieve library file:");
    print("    Not data returned")
    return;
end

pcall(function () fs.delete("libmek.lua") end);
local file = fs.open("libmek.lua", "w");
if (file == nil) then
    print("[libmek] Failed to create libmek.lua file");
    return;
end
file.write(body);
file.close();
print("[libmek] libmek installed");
