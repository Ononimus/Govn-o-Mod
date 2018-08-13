surface.CreateFont("hui_sosi", {
	font = "Segoe UI",
	size = 16,
})

local fr = vgui.Create('DFrame')
fr:SetSize(math.floor((ScrW()-20)/325)*325+20, ScrH()-100)
fr:Center()
fr:ShowCloseButton(true)
fr:MakePopup()
fr:SetTitle('')
fr.Paint = function(self, w, h)
	surface.SetDrawColor(10, 10, 10, 228)
	surface.DrawRect(0, 0, w, 30)
	
	surface.SetDrawColor(30, 30, 30, 200)
	surface.DrawRect(0, 25, w, h - 25)
end
fr.OnClose = function()
	timer.Stop('privet')	
end

local lst = vgui.Create('DPanelList', fr)
lst:Dock(FILL)
lst:SetSpacing(5) 
lst:EnableHorizontal(true)
lst:EnableVerticalScrollbar(true) 

local tbl = {}

local function update()
	for k, v in ipairs(ents.FindByClass('theater_thumbnail')) do
		local url = v:GetThumbnail()
		local pnl = tbl[v]

		if url=='' then
			if pnl then
				pnl:Remove()
				tbl[v] = nil
			end
		elseif not pnl then
			local itm = vgui.Create('Panel')
			lst:AddItem(itm)
			itm:SetSize(320, 230)
			itm.Paint = function(self, w, h)
				surface.SetDrawColor(0, 0, 0)
				surface.DrawRect(0, 0, w, h)
				
				surface.SetFont('hui_sosi')
				surface.SetTextColor(255, 255, 255)
				
				local tw, ht = surface.GetTextSize(self.title)
				surface.SetTextPos(160-tw/2, 210)
				surface.DrawText(self.title)
				
				local tw, ht = surface.GetTextSize(self.name)
				surface.SetTextPos(160-tw/2, 5)
				surface.DrawText(self.name)
			end
			
			local aw = vgui.Create('Awesomium', itm)
			aw:SetHTML(string.format('<body background=%q></body>', url))
			aw:SetSize(320, 180)
			aw:SetPos(0, 25)
			itm.aw = aw
			
			itm.title = v:GetTitle()
			itm.name = v:GetTheaterName()
			itm.url = url
			
			tbl[v] = itm
		elseif pnl.url~=url then
			pnl.aw:OpenURL(url)
			pnl.title = v:GetTitle()
			pnl.name = v:GetTheaterName()
			pnl.url = url
		end
	end
end

timer.Create('privet', 1, 0, update)
update()