return {
PlaceObj('ModItemCode', {
	'name', "AutoFire",
	'CodeFileName', "Code/AutoFire.lua",
}),
PlaceObj('ModItemCode', {
	'name', "BurstFire",
	'CodeFileName', "Code/BurstFire.lua",
}),
PlaceObj('ModItemCode', {
	'name', "CTHCalc",
	'CodeFileName', "Code/CTHCalc.lua",
}),
PlaceObj('ModItemCode', {
	'name', "ChanceToHit",
	'CodeFileName', "Code/ChanceToHit.lua",
}),
PlaceObj('ModItemCode', {
	'name', "FirearmProperty",
	'CodeFileName', "Code/FirearmProperty.lua",
}),
PlaceObj('ModItemCode', {
	'name', "AK47",
	'CodeFileName', "Code/AK47.lua",
}),
PlaceObj('ModItemCode', {
	'name', "SingleShot",
	'CodeFileName', "Code/SingleShot.lua",
}),
PlaceObj('ModItemGameRuleDef', {
	display_name = T(531183076058, --[[ModItemGameRuleDef APReductionOnHit display_name]] "APReductionOnHit"),
	id = "APReductionOnHit",
	msg_reactions = {
		PlaceObj('MsgReaction', {
			Event = "DamageTaken",
			Handler = function (self, attacker, target, dmg, hit_descr)
				ap_penalty = 1
				if target:GetStatusEffect("SpentAP") then
					ap_penalty = target:GetEffectValue("spent_ap") +1
				else target:AddStatusEffect("SpentAP") 
				end
				target:SetEffectValue("spent_ap", ap_penalty)
				print('Damage: '..tostring(dmg )..'dmg')
				print('AP Penalty: '..tostring(ap_penalty )..'AP')
			end,
			HandlerCode = function (self, attacker, target, dmg, hit_descr)
				ap_penalty = 1
				if target:GetStatusEffect("SpentAP") then
					ap_penalty = target:GetEffectValue("spent_ap") +1
				else target:AddStatusEffect("SpentAP") 
				end
				target:SetEffectValue("spent_ap", ap_penalty)
				print('Damage: '..tostring(dmg )..'dmg')
				print('AP Penalty: '..tostring(ap_penalty )..'AP')
			end,
			param_bindings = false,
		}),
	},
}),
}
