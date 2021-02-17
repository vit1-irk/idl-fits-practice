!path=!path+":/opt/IDLAstro/pro"

openw, 1, filepath("/home/vitya/FITS/test.vits")

a=indgen(100)
writeu, 1, fix(1), long(100)

for x=0,99 do begin
	writeu,1,float(a[x])
endfor
close, 1

end
