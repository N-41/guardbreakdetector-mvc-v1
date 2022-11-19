--memory.writebyte(0xff3053, 0x22);
a = 0xffdf12;
b = 0xffdf16;
prj = {};
--chr = true;

while not false do
--	memory.writeword(0xff416e, 0x1432);
--	gui.text(2,8,memory.readbyte(0xff3053));
--	emu.frameadvance()
	prj = {};
	b = 0xffdf16;
	while memory.readdword(b) ~= 0xff3000 and memory.readdword(b) ~= 0xff3800 and memory.readdword(b) ~= 0x0 do
		table.insert(prj,memory.readdword(b));
		b = b - 0x4;
	end
	table.insert(prj,memory.readdword(b));
	if prj ~= nil then
		for i=1,table.getn(prj),1 do 
			gui.text(2,8 + (i * 8),"Currently reading 0x"..string.format("%x", prj[i]).." XPos: "..memory.readword(prj[i]+ 0xc).." YPos: "..memory.readword(prj[i]+ 0x10));
			--gui.text(2,16,"X Position: "..memory.readword(memory.readdword(a)+ 0xc));
			--gui.text(2,24,"Y Position: "..memory.readword(memory.readdword(a) + 0x10));
		end
	end
	
	memory.writebyte(0xFF4009, 0x41)
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
	memory.writeword(0xFF416E, 0x1432)
	emu.frameadvance()
end