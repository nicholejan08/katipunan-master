local blips = {
	
	--HOTELES
	{ name = 'Motel', sprite = -211556852, x = -325.74, y = 772.92, z = 117.44 },
	--SHERIFF
	{ name = 'Departamento ng mga Pulis', sprite = 1047294027, x = -277.76, y = 804.97, z = 119.38 },
	{ name = 'Departamento ng mga Pulis', sprite = 1047294027, x = -764.14, y = -1270.92, z = 44.04 },
	{ name = 'Bulwagan ng Pulis Maynila', sprite = 1047294027, x = 2513.35, y = -1308.75, z = 47.99 },
	{ name = 'Bulwagan ng Pulis Maynila', sprite = 1047294027, x = -5529.16, y = -2928.08, z = -2.36 },
	--BARBERO
	--{ name = 'Barbero', sprite = -2090472724, x = -815.85, y = -1364.77, z = 43.75 },
	--FOTOS
	{ name = 'Potograpiya', sprite = 1364029453, x = -814.54, y = -1374.74, z = 44.23 },
	--BUTCHER
	{ name = 'Karnihan', sprite = -1665418949, x = 2817.81, y = -1329.99, z = 46.47 },
	{ name = 'Karnihan', sprite = -1665418949, x = -341.07, y = 767.2, z = 115.71 },
	{ name = 'Karnihan', sprite = -1665418949, x = -1752.95, y = -392.81, z = 155.24 },
	{ name = 'Karnihan', sprite = -1665418949, x = 1297.58, y = -1277.66, z = 75.08 },
	{ name = 'Karnihan', sprite = -1665418949, x = 2075.05, y = 1000.12, z = 111.58 },
	{ name = 'Karnihan', sprite = -1665418949, x = -5508.10, y = -2947.73, z = -1.87 },
	{ name = 'Karnihan', sprite = -1665418949, x = -750.88, y = -1284.73, z = 42.32 },
	--OTHERS 
	{ name = 'Nakawan', sprite = -507621590, x = 2393.81, y = -1082.67, z = 52.43 },
	{ name = 'Motel', sprite = 1586273744, x = -1811.84, y = -370.33, z = 151.92 },
	{ name = 'Tiyatro', sprite = -417940443, x = 2537.76, y = -1278.32, z = 48.27 },
	{ name = 'Misyon ng Teritoryo', sprite = 2113496404, x = -4207.02, y = -3582.37, z = 49.43 },
	{ name = 'Simbahan ng Quiapo', sprite = -2039778370, x = 2741.1, y = -1264.1, z = 50.1 },
	{ name = 'Pier', sprite = 1106719664, x = 2781.65, y = -1536.25, z = 48.39 },
	{ name = 'Pier', sprite = 1106719664, x = 1284.18, y = -6871.62, z = 43.3 },
	{ name = 'Plaza', sprite = -1989725258, x = 2449.91, y = -1217.36, z = 47.44 },
	{ name = 'Langit', sprite = 350569997, x = 4104.61, y = -6149.77, z = 49.52 },
	{ name = 'Timber Co.', sprite = 1904459580, x = -1413.3, y = -246.5, z = 99.71 },
	{ name = 'Cripps', sprite = 1369919445, x = -10.12, y = 950.44, z = 210.84 },
	{ name = 'Sementeryo', sprite = 350569997, x = 2700.29, y = -1060.66, z = 48.05 },

	--GUARMA 
	{ name = 'Karnihan', sprite = -1665418949, x = 1365.87, y = -7003.29, z = 54.6 }, -- Butcher
	{ name = 'Bulkang Mayon', sprite = -910004446, x = 2085.16, y = -8740.46, z = 594.76 },
	{ name = 'Bahay ng Aswang', sprite = -428972082, x = 1684.04, y = -6727.98, z = 108.59 },

	--POINT OF INTEREST 

	{ name = 'Odessa Tumbali Cave', sprite = -2039778370, x = -2665.27, y = 690.63, z = 184.33 }, -- Kuweba
	{ name = 'Tabon Caves', sprite = -2039778370, x = -2324.84, y = 96.58, z = 229.35 }, -- Kuweba
	{ name = 'aFmsda12#$#$2fk', sprite = -2039778370, x = 806.49, y = 1922.8, z = 91.0 }, -- Statues
	{ name = 'Kulto', sprite = -2039778370, x = -160.86, y = 1599.23, z = 178.89 }, -- Kulto
	{ name = 'Hiking Quarters', sprite = -1606321000, x = -9.94, y = 1226.46, z = 214.01 }, -- Hiking
	{ name = 'Poisoned Western Toad', sprite = 2039778370, x = 2490.52, y = 896.79, z = 73.39 }, -- Poisoned Western Toad

	--MGA MISYON 

	{ name = 'Misyon', sprite = 639638961, x = -268.72, y = 784.55, z = 117.5 }, -- Valentine
	{ name = 'Misyon', sprite = 639638961, x = 2517.25, y = -1312.06, z = 48.87 }, -- St. Denis
	{ name = 'Misyon', sprite = 639638961, x = 1353.53, y = -1304.14, z = 76.81 }, -- Rhodes
	{ name = 'Misyon', sprite = 639638961, x = -1803.9, y = -356.73, z = 164.09 }, -- Strawberry
	{ name = 'Misyon', sprite = 639638961, x = 2915.8, y = 1313.67, z = 43.15 }, -- Annesburg
	{ name = 'Misyon', sprite = 639638961, x = -3624.2, y = -2599.72, z = -13.81 }, -- Armadillo
	{ name = 'Misyon', sprite = 639638961, x = -764.33, y = -1260.9, z = 43.54 } -- Blackwater

}

Citizen.CreateThread(function()
	for _, info in pairs(blips) do
        local blip = N_0x554d9d53f696d002(1664425300, info.x, info.y, info.z)
        SetBlipSprite(blip, info.sprite, 1)
		SetBlipScale(blip, 0.2)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip, info.name)
    end  
end)