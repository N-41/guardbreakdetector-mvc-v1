if memory.readbyte(0xFF32A4) == 0x1 then print("yes")
else print("no") end

uncombos = 0;
mode = 0;
timer = 0;
playing = false;
previousanimation = 0;
previoushealth = 0;
previoushitstun = 0;
previoustype = 0;


--memory.writebyte(0xFF3853,0x26);



while true do
	p2 = input.get();
	--p2["P2 Up"] = true;
	for i = 0x0, 0xC00, 0x400 do
		j = tonumber(i) / 1024;
		gui.text(2,32 + (8*j),"Animid: " .. string.format("%x", memory.readdword(0xFF305e + i)));
	end
	
	if memory.readbyte(0xFF3400) == 1 then
		mode = 1;
		playing = true;
	elseif memory.readbyte(0xFF3c00) == 1 then
		mode = 3;
		playing = true;
	else
		playing = false;
	end
	
	if playing then
		--if previoushitstun > 1 and memory.readbyte(0xff3120) == 1 and memory.readdword(0xff3010 + (mode * 0x400)) ~= 456 then
		if
		previoustype == 0x1c and
		( (memory.readbyte(0xFF3060 + (mode * 0x400)) == 0x1c and
		   previousanimation > memory.readdword(0xFF305e + (mode * 0x400)) and
		   memory.readbyte(0xff3061 + (mode * 0x400)) > 0x12)or
		   memory.readbyte(0xFF3060 + (mode * 0x400)) == 0x22 and
		  (memory.readbyte(0xff3060) == 0x2e or memory.readbyte(0xff3860) == 0x2e)) and
		previoushitstun >= memory.readbyte(0xff3120) and
		memory.readbyte(0xff3120) == 1 then
			timer = 20;
			uncombos = uncombos + 1;
			
		end
		previousanimation = memory.readdword(0xFF305e + (mode * 0x400));
		previoushitstun = memory.readbyte(0xff3120);
		previoustype = memory.readbyte(0xFF3060 + (mode * 0x400));
		--end
		if memory.readbyte(0xff3061 + (mode * 0x400)) > 0x12 and memory.readbyte(0xff3060 + (mode * 0x400)) == 0x1c then
			if memory.readbyte(0xFF304b + (mode * 0x400)) == 0 then
				p2["P2 Right"] = true;
			else
				p2["P2 Left"] = true;
			end
		end
		if timer > 0 then
			timer = timer - 1;
			gui.text(2,24,"Succesful Uncombo!!","white");
			color = "green";
		else
			color = "white";
		end
		gui.text(2,8,"Opponent's animid: " .. string.format("%x", memory.readdword(0xFF305e + (mode * 0x400))),color);
		gui.text(2,16,"Uncombos performed: " .. uncombos, "white");
	--elseif mode ~= 0 then
	--	gui.text(2,8,"To make this lua work, please call War Machine to the arena","red")
	else
		gui.text(2,8,"Waiting for the game to start","yellow")
	end
	memory.writebyte(0xff3271, 0x90)
	memory.writebyte(0xff3274, 0x3)
	memory.writebyte(0xff3671, 0x90)
	memory.writebyte(0xff3674, 0x3)
	memory.writebyte(0xff3a71, 0x90)
	memory.writebyte(0xff3a74, 0x3)
	memory.writebyte(0xff3e71, 0x90)
	memory.writebyte(0xff3e74, 0x3)
	memory.writebyte(0xFF4008, 0x99)
	memory.writebyte(0xff32c6,0x9)
	memory.writebyte(0xff36c6,0x9)
	memory.writebyte(0xff3ac6,0x9)
	memory.writebyte(0xff3ec6,0x9)
	gui.text(2,64,"Hitstun: "..memory.readbyte(0xff3120),"green")
	gui.text(2,72,"Ypos: "..memory.readword(0xff3010 + (mode * 0x400)),"yellow")
	joypad.set(p2);
	emu.frameadvance();
end