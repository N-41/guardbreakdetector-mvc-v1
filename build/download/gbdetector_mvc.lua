a = 0xFF3000

--ff4000 game state 6 = just starting 8 = playing a = game over
--ff32a4 1pwin ff36a4 2pwin
--ff3000 validity bit
--ff304b orientation bit
--ff3034 animid dword
--ff300c xpos
--ff3010 ypos

xpos = {}
ypos = {}
animid = {}
orientation = {}
validity = {}
gamestate = {}
victory = {}

k = 1;
while true do
	for i = 0x0, 0xC00, 0x400 do
		j = ((tonumber(i) / 1024)) * k;
		--print(memory.readword(0xFF300c + i));
		--print(memory.readword(0xFF300e + i));
		--print(j); 
		xpos[j+1] = memory.readword(0xFF300c + i);
		ypos[j+1] = memory.readword(0xFF3010 + i);
		animid[j+1] = memory.readdword(0xFF3034 + i);
		orientation[j+1] = memory.readbyte(0xFF304B + i);
		validity[j+1] = memory.readbyte(0xFF3000 + i);
		gamestate[j+1] = memory.readbyte(0xFF3034 + i);
		--print(memory.readdword(0xFF3034 + i));
		
	end

	for i = 0x0, 0x400, 0x400 do
		j = ((tonumber(i) / 1024)) * k;
		victory[j+1] = memory.readbyte(0xFF32A4 + i);
	end
k++;
emu.frameadvance();
end