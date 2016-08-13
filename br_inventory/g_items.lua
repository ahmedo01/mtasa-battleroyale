-- 1 - broń (value1 - id broni gta, value2 - zaladowane ammo)
-- 2 - amunicja (value1 - id broni gta, value2 - ilosc ammo do zaladowania)
-- 3 - lek (value1 - ilosc hp do leczenia)
-- 4 - armor (value1 - ilość armora do dodania)
-- 5 - hełm

gItems = 
{
	-- użytkowe 
	["Medkit"] = 
	{
		type=3,
		objectID=1580, -- obiekt w świecie GTA
		itemImage="img/icons/apteczka.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=50,
		value2=0,
		usingTime=2.5, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Bandage"] = 
	{
		type=3,
		objectID=1575, -- obiekt w świecie GTA
		itemImage="img/icons/bandage.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=25,
		value2=0,
		usingTime=1.5, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Armor"] = 
	{
		type=4,
		objectID=1242, -- obiekt w świecie GTA
		itemImage="img/icons/armor.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		rx= 90, 
		ry = 0, 
		rz = 0,
		value1=30,
		value2=0,
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Helmet"] = 
	{
		type=5,
		objectID=3092, -- obiekt w świecie GTA
		itemImage="img/icons/helmet.png", -- tekstura
		maxAmount = false, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		rx=  0, 
		ry = 0, 
		rz = 0,
		value1=30,
		value2=0,
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	-- bronie 
	["AK-47"] = 
	{
		type=1,
		objectID=355, -- obiekt w świecie GTA
		itemImage="img/icons/ak-47.png", -- tekstura
		maxAmount = false, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		rx= 90, 
		ry = 0, 
		rz = 0,
		value1=30,
		value2=0,
		usingTime=0, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},	
	
	["AK-47 Ammo"] = 
	{
		type=2,
		objectID=2358, -- obiekt w świecie GTA
		itemImage="img/icons/ak-47_ammo.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=30, -- id broni
		value2=30,  
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},	
	
	["Cuntgun"] = 
	{
		type=1,
		objectID=357, -- obiekt w świecie GTA
		itemImage="img/icons/cuntgun.png", -- tekstura
		maxAmount = false, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 90, 
		ry = 0, 
		rz = 0,
		value1=33, -- id broni
		value2=0,
		usingTime=0, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Cuntgun Ammo"] = 
	{
		type=2,
		objectID=2358, -- obiekt w świecie GTA
		itemImage="img/icons/cuntgun_ammo.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=33, -- id broni
		value2=30, -- ammo 
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Desert Eagle"] = 
	{
		type=1,
		objectID=348, -- obiekt w świecie GTA
		itemImage="img/icons/deagle.png", -- tekstura
		maxAmount = false, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 90, 
		ry = 0, 
		rz = 0,
		value1=24, -- id broni
		value2=0,
		usingTime=0, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Desert Eagle Ammo"] = 
	{
		type=2,
		objectID=2358, -- obiekt w świecie GTA
		itemImage="img/icons/deagle_ammo.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=24, -- id broni
		value2=20, -- ammo 
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["LR-300"] = 
	{
		type=1,
		objectID=356, -- obiekt w świecie GTA
		itemImage="img/icons/m4.png", -- tekstura
		maxAmount = false, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 90, 
		ry = 0, 
		rz = 0,
		value1=31, -- id broni
		value2=0,
		usingTime=0, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["LR-300 Ammo"] = 
	{
		type=2,
		objectID=2358, -- obiekt w świecie GTA
		itemImage="img/icons/m4_ammo.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=31, -- id broni
		value2=30, -- ammo 
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["MP5"] = 
	{
		type=1,
		objectID=353, -- obiekt w świecie GTA
		itemImage="img/icons/mp5.png", -- tekstura
		maxAmount = false, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 90, 
		ry = 0, 
		rz = 0,
		value1=29, -- id broni
		value2=0,
		usingTime=0, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["MP5 Ammo"] = 
	{
		type=2,
		objectID=2358, -- obiekt w świecie GTA
		itemImage="img/icons/mp5_ammo.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=29, -- id broni
		value2=30, -- ammo 
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Shotgun"] = 
	{
		type=1,
		objectID=349, -- obiekt w świecie GTA
		itemImage="img/icons/shotgun.png", -- tekstura
		maxAmount = false, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 90, 
		ry = 0, 
		rz = 0,
		value1=25, -- id broni
		value2=0,
		usingTime=0, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Shotgun Ammo"] = 
	{
		type=2,
		objectID=2358, -- obiekt w świecie GTA
		itemImage="img/icons/shotgun_ammo.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=25, -- id broni
		value2=30, -- ammo 
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Silenced 9mm Pistol"] = 
	{
		type=1,
		objectID=347, -- obiekt w świecie GTA
		itemImage="img/icons/silenced.png", -- tekstura
		maxAmount = false, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 90, 
		ry = 0, 
		rz = 0,
		value1=23, -- id broni
		value2=0,
		usingTime=0, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Silenced 9mm Pistol Ammo"] = 
	{
		type=2,
		objectID=2358, -- obiekt w świecie GTA
		itemImage="img/icons/silenced_ammo.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=23, -- id broni
		value2=20, -- ammo 
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Sniper Rifle"] = 
	{
		type=1,
		objectID=358, -- obiekt w świecie GTA
		itemImage="img/icons/sniper.png", -- tekstura
		maxAmount = false, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 90, 
		ry = 0, 
		rz = 0,
		value1=34, -- id broni
		value2=0,
		usingTime=0, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["Sniper Rifle Ammo"] = 
	{
		type=2,
		objectID=2358, -- obiekt w świecie GTA
		itemImage="img/icons/sniper_ammo.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=34, -- id broni
		value2=30, -- ammo 
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["SPAZ-12"] = 
	{
		type=1,
		objectID=351, -- obiekt w świecie GTA
		itemImage="img/icons/combat.png", -- tekstura
		maxAmount = false, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 90, 
		ry = 0, 
		rz = 0,
		value1=27, -- id broni
		value2=0,
		usingTime=0, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},
	
	["SPAZ-12 Ammo"] = 
	{
		type=2,
		objectID=2358, -- obiekt w świecie GTA
		itemImage="img/icons/combat_ammo.png", -- tekstura
		maxAmount = 10000, -- maxAmount = maksymalna ilość itemów do stackowania. maxAmount = false - item sie nie stakuje
		
		rx= 0, 
		ry = 0, 
		rz = 0,
		value1=27, -- id broni
		value2=30, -- magazynek 
		usingTime=2, -- czy używanie itema zajmuje jakiś okres czasu? 0 - x 
	},	
}