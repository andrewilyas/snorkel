function createNet()
	X617af7ac_0609_2221_d47b_a5a4bf11f54f = nn.SpatialConvolution(1,3,5,5)()
	X57487943_104d_0759_030e_ff4b1d0c7387 = nn.SpatialMaxPooling(2,2)(X617af7ac_0609_2221_d47b_a5a4bf11f54f)
	r_view_X57487943_104d_0759_030e_ff4b1d0c7387 = nn.View(432)(X57487943_104d_0759_030e_ff4b1d0c7387)
	X628d06a6_0529_f567_167c_ea35c369eaee = nn.Linear(432,10)(r_view_X57487943_104d_0759_030e_ff4b1d0c7387)

 	soft_max = nn.LogSoftMax()(X628d06a6_0529_f567_167c_ea35c369eaee)
 	local net = nn.gModule({X617af7ac_0609_2221_d47b_a5a4bf11f54f}, {soft_max})
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
	return imageLoader('training', 28, 28)
end