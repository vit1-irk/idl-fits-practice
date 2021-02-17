!path=!path+":/opt/IDLAstro/pro"

f="/home/vitya/FITS/aia.lev1.1700A_2015-10-22T00_00_53.71Z.image_lev1.fits"
print, f
a=readfits(f, header)
naxis=fix(sxpar(header, "NAXIS"))
xlen=long(sxpar(header, "NAXIS1"))
ylen=long(sxpar(header, "NAXIS2"))
print,naxis,xlen,ylen

openw, 1, filepath("/home/vitya/FITS/test.vits")
writeu, 1, naxis, xlen,ylen

for x=0,xlen-1 do begin
	for y=0,ylen-1 do begin
		writeu,1,float(a[x,y])
	endfor
endfor
close, 1

end
