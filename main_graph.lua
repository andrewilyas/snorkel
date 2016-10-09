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

for k, inputs, targets in dataloader:sampleiter(20, 1*60000) do
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

torch.save('model.t7', net)
