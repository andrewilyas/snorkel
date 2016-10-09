local net = torch.load("model.t7")
local imageresp = http:request({
    method = "get", 
    url = url_from_decoded_json
});

local imagefile = io.open("some_file", "w")
imagefile:write(resp.content)
imagefile:close()

