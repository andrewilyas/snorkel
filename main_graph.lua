require 'nngraph'
require 'hdf5'
local dl = require 'dataload'
local optim = require 'optim'
local nn = require 'nn'

-- TODO: Change this to be parameterized
local f = loadfile('net.lua')
f()
local net = createNet()
params,gradParams = net:getParameters()
crit = nn.CrossEntropyCriterion()

opt = {
	learningRate = 0.1,
	momentum = 0,
}

function imageLoader(trainURL, imW, imH)
	return dl.ImageClass(trainURL, {1, imW, imH})
end

function textLoader(trainURL)
	os.execute("python preprocess.py custom /home/ailyas/GoogleNews-vectors-negative300.bin --train " + trainURL)
	local myFile = hdf5.open('/path/to/read.h5', 'r')
	local data = myFile:read('/'):all()
	local loader = dl.TensorLoader(data['train'], data['train_label'])
	myFile:close()
	return loader
end

dataloader = dataLoader()--dl.ImageClass('./mnist_png/training', {1, 28, 28})

for k, inputs, targets in dataloader:sampleiter(100, 3*60000) do
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

test_dataloader = testLoader()
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

torch.save('model.t7', net)
