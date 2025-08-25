-----------------------
--- DeadStockMarket ---
-----------------------
ESX = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
Citizen.CreateThread(function()
	-- This is the thread for sending resource name 
	Citizen.Wait(1000)
	local rname = GetCurrentResourceName();
	SendNUIMessage({
		resourcename = rname;
	});
end)
RegisterNetEvent("DeadStocks:SendNotif")
AddEventHandler("DeadStocks:SendNotif", function(notif)
	SendNUIMessage({
		notification = notif;
	});
end)
RegisterNetEvent("DeadStocks:SendData")
AddEventHandler("DeadStocks:SendData", function(data)
	SendNUIMessage({
		theirStockData = data;
	});
end)

RegisterNUICallback("DeadStocks:Buy", function(data, cb)
	cb(TriggerServerEvent("DeadStocks:Buy", data, function(callback) return callback end))
end)

RegisterNUICallback("DeadStocks:Sell", function(data, cb)
	cb(TriggerServerEvent("DeadStocks:Sell", data, function(callback) return callback end))
end)

maxStocksOwned = 20; -- The max stocks the user is allowed to own 
RegisterNetEvent('DeadStockMarket:Client:SetMaxStocksOwned')
AddEventHandler('DeadStockMarket:Client:SetMaxStocksOwned', function(maxStocks)
	maxStocksOwned = maxStocks;
end)
stockData = nil;
RegisterNetEvent('DeadStockMarket:Client:GetStockData')
AddEventHandler('DeadStockMarket:Client:GetStockData', function(stockD)
	stockData = stockD;
end)
RegisterCommand('stocks', function(source, args, rawCommand)
	-- Toggle on and off stocks phone 
	TriggerServerEvent('DeadStockMarket:Server:GetStockHTML');
	SetNuiFocus(true, true);
	TriggerServerEvent('DeadStockMarket:Server:GetMaxStocks');
	SendNUIMessage({
		maxStocksAllowed = maxStocksOwned;
	});
	SendNUIMessage({
		show = true;
	});
	TriggerServerEvent("DeadStocks:SetupData");
	while stockData == nil do 
		Wait(500);
		SendNUIMessage({
			stockData = stockData;
		});
	end
	if stockData ~= nil then 
		SendNUIMessage({
			stockData = stockData;
		});
	end
end)
RegisterNUICallback('DeadPhoneClose', function(data, cb)
	SetNuiFocus(false, false)
	if (cb) then 
		cb('ok')
	end
end)
