!path=!path+":/opt/IDLAstro/pro"

files=["/home/debug/FITS/aia.lev1.1700A_2015-10-22T00_00_53.71Z.image_lev1.fits",$
"/home/debug/FITS/aia.lev1.1600A_2015-10-22T00_00_15.12Z.image_lev1.fits",$
"/home/debug/FITS/aia.lev1.304A_2015-10-22T00_00_06.12Z.image_lev1.fits",$
"/home/debug/FITS/aia.lev1.171A_2015-10-22T00_00_10.34Z.image_lev1.fits"]

labels=['1700A', '1600A', '304A', '171A']
colors=[80, 150, 200, 255]

device, decomposed=0
for i=0,n_elements(files)-1 do begin
	f1=files[i]
	print,f1
	ar=readtoplot_x(f1)
	xi=ar[0:4095]
	xv=ar[4096:8191]
	
	if (i eq 0) then begin
		loadct, 0
		plot,xi,xv,color=255,xtitle='arcsec from center',ytitle='intensity'
		loadct, 13
	endif
	oplot,xi,xv,color=colors[i]
	xyouts, 0.1, colors[i] / 255. - 0.1, labels[i], /normal, color=colors[i], size=3
endfor
image=tvrd(True=1)
Write_PNG, "xdata.png", image

end
