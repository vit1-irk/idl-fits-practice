!path=!path+":/opt/IDLAstro/pro"

files=["/home/debug/FITS/aia.lev1.171A_2015-10-22T00_00_10.34Z.image_lev1.fits",$
"/home/debug/FITS/aia.lev1.304A_2015-10-22T00_00_06.12Z.image_lev1.fits"]

labels=['304A-x', '304A-y']
colors=[150, 200]

device, decomposed=0
loadct, 0
i=0
ar=readtoplot_x(files[1])
xi=ar[0:4095]
xv=ar[4096:8191]
plot,xi,xv,color=255,xtitle='arcsec from center',ytitle='intensity'
loadct, 13

oplot,xi,xv,color=colors[i]
xyouts, 0.1, colors[i] / 255. - 0.1, labels[i], /normal, color=colors[i], size=3

i=1
ar=readtoplot_y(files[1])
xi=ar[0:4095]
xv=ar[4096:8191]
oplot,xi,xv,color=colors[i]
xyouts, 0.1, colors[i] / 255. - 0.1, labels[i], /normal, color=colors[i], size=3

image=tvrd(True=1)
Write_PNG, '304data.png', image

end
