!path=!path+":/opt/IDLAstro/pro"

openr, 1, filepath("/home/vitya/FITS/test.vits")
naxis=fix(0)
readu, 1, naxis

case naxis of 1: begin
	xlen=long(0)
	readu, 1, xlen

	a=fltarr(xlen)
	end
     2: begin
	lens=lonarr(2)
	readu, 1, lens
	print,lens
	xlen=lens[0]
	ylen=lens[1]

	a=fltarr(xlen,ylen)
	end
endcase

readu, 1, a
close, 1

case naxis of 1: begin
	xindices=indgen(xlen)
	plot,xindices,a
	end
     2: begin
	a=rebin(a, 512, 512)
	window, xsize=512, ysize=512, xpos=0, ypos=0
	tvscl, a

	end
endcase
end
