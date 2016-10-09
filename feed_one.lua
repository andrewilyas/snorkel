require 'nngraph'
local dl = require 'dataload'

local net = torch.load("model.t7")
test_dataloader = dl.ImageClass('./test_data/', {1, 28, 28})
for k, inputs, targets in test_dataloader:sampleiter(1, 1) do
	inputs = inputs:double()
	local output = net:forward(inputs)
	maxs, index = torch.max(output, 1)
	print(index)
end
