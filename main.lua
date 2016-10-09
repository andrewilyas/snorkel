local dl = require 'dataload'
local optim = require 'optim'
local nn = require 'nn'

-- TODO: Change this to be parameterized
local net = nn.Sequential()
net:add(nn.SpatialConvolution(1, 3, 5, 5))
net:add(nn.SpatialMaxPooling(2, 2))
net:add(nn.View(432))
net:add(nn.Linear(432, 10))

local function weights_init(m)
	local name = torch.type(m)
	if name:find('Convolution') then
		m.weight:normal(0.0, 0.01)
		m.bias:fill(0)
	elseif name:find('BatchNormalization') then
		if m.weight then m.weight:normal(1.0, 0.02) end
		if m.bias then m.bias:fill(0) end
	end
end
net:apply(weights_init)
params,gradParams = net:getParameters()
net:add(nn.LogSoftMax())
crit = nn.CrossEntropyCriterion()

opt = {
	learningRate = 0.1,
	momentum = 0,
}

dataloader = dl.ImageClass('./mnist_png/training', {1, 28, 28})
for k, inputs, targets in dataloader:sampleiter(10, 1*60000) do
	local eval_deriv = function(x)
		gradParams:zero()
		inputs = inputs:double()
		local outputs = net:forward(inputs)
		local f_value = crit:forward(outputs, targets)

		local back_prop = crit:backward(outputs, targets)
		net:backward(inputs, back_prop)
		return f_value, gradParams
	end
	sgdState = sgdState or {
		learningRate = opt.learningRate,
		momentum = opt.momentum,
		learningRateDecay = 5e-7
	}
	optim.sgd(eval_deriv, params, sgdState)
	print(k)
end

test_dataloader = dl.ImageClass('./mnist_png/testing', {1, 28, 28})
local top1 = 0
local counter = 0
for k, inputs, targets in test_dataloader:sampleiter(256, 10000) do
	inputs = inputs:double()
	local output = net:forward(inputs)
	local _,preds = output:float():sort(2, true)
	for i=1,targets:size(1) do
		local rank = torch.eq(preds[i], targets[i]):nonzero()[1][1]
		if rank == 1 then
			top1 = top1 + 1
		end
		counter = counter + 1
	end
	print(top1/counter)
end
