function createNet()
	c1 = nn.SpatialConvolution(1, 3, 5, 5)()
	p1 = nn.SpatialMaxPooling(2, 2)(c1)
	v1 = nn.View(432)(p1)
	l1 = nn.Linear(432, 10)(v1)
	soft_max = nn.LogSoftMax()(l1)
	local net = nn.gModule({c1}, {soft_max})


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
	return net
end

function dataLoader()
	return imageLoader("mnist_png/training", 28, 28)
end
