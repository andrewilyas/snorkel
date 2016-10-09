function createNet()
	X16e9c832_ed87_d830_d650_f3bc9f158919 = nn.SpatialConvolution(1,3,5,5)()
	X54d4aebe_ecb9_da3f_90b9_b2ebc7623cf6 = nn.SpatialMaxPooling(2,2)(X16e9c832_ed87_d830_d650_f3bc9f158919)
	r_view_X54d4aebe_ecb9_da3f_90b9_b2ebc7623cf6 = nn.View(432)(X54d4aebe_ecb9_da3f_90b9_b2ebc7623cf6)
	Xd95bc204_e42a_8f6f_b826_33ec065ff8c9 = nn.Linear(432,10)(r_view_X54d4aebe_ecb9_da3f_90b9_b2ebc7623cf6)

 	soft_max = nn.LogSoftMax()(Xd95bc204_e42a_8f6f_b826_33ec065ff8c9)
 	local net = nn.gModule({X16e9c832_ed87_d830_d650_f3bc9f158919}, {soft_max})
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