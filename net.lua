function createNet()
	X2e1834df_b690_412b_ebe0_05e17790ac3f = nn.SpatialConvolution(1,3,5,5)()
	Xa1f13c16_eeaa_7bde_4814_b373a8e35962 = nn.SpatialMaxPooling(2,2)(X2e1834df_b690_412b_ebe0_05e17790ac3f)
	r_view_Xa1f13c16_eeaa_7bde_4814_b373a8e35962 = nn.View(432)(Xa1f13c16_eeaa_7bde_4814_b373a8e35962)
	Xcb4df374_7cc7_3644_3bad_09214b3931aa = nn.Linear(432,10)(r_view_Xa1f13c16_eeaa_7bde_4814_b373a8e35962)

 	soft_max = nn.LogSoftMax()(Xcb4df374_7cc7_3644_3bad_09214b3931aa)
 	local net = nn.gModule({X2e1834df_b690_412b_ebe0_05e17790ac3f}, {soft_max})
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

function testLoader()
	return imageLoader('testing', 28, 28)
end
function createNet()
	X2b07322c_2a25_6f52_bd47_70f6d85ad873 = nn.SpatialConvolution(1,3,5,5)()
	Xb39e6b95_55fe_a50f_d1eb_7aceaa3ca02d = nn.SpatialMaxPooling(2,2)(X2b07322c_2a25_6f52_bd47_70f6d85ad873)
	r_view_Xb39e6b95_55fe_a50f_d1eb_7aceaa3ca02d = nn.View(432)(Xb39e6b95_55fe_a50f_d1eb_7aceaa3ca02d)
	X4884dbf5_96bd_6373_7274_3c225de337aa = nn.Linear(432,10)(r_view_Xb39e6b95_55fe_a50f_d1eb_7aceaa3ca02d)

 	soft_max = nn.LogSoftMax()(X4884dbf5_96bd_6373_7274_3c225de337aa)
 	local net = nn.gModule({X2b07322c_2a25_6f52_bd47_70f6d85ad873}, {soft_max})
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

function testLoader()
	return imageLoader('testing', 28, 28)
end
