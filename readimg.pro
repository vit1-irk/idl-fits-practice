!path=!path+":/opt/IDLAstro/pro"

f="/home/debug/FITS/aia.lev1.1700A_2015-10-22T00_00_53.71Z.image_lev1.fits"
a0=readfits(f, header)

newx=512
newy=512

a=rebin(a0, newx, newy)
window, xsize=newx, ysize=newy, xpos=0, ypos=0

cdx=float(sxpar(header, "CDELT1"))
cdy=float(sxpar(header, "CDELT2"))

xc=long(sxpar(header, "CRPIX1"))
yc=long(sxpar(header, "CRPIX2"))
xlen=long(sxpar(header, "NAXIS1"))
ylen=long(sxpar(header, "NAXIS2"))

zoomx=float(newx)/float(xlen)
zoomy=float(newy)/float(ylen)

print,cdx,cdy
print,xc,yc,xlen,ylen

;xindices ndices-xc/2
contour,a,/nodata,/noerase
px = round(!d.x_size*(!x.window[1]-!x.window[0]))
py = round(!d.y_size*(!y.window[1]-!y.window[0]))

xshift=!d.x_size*!x.window[0]
yshift=!d.y_size*!y.window[0]

a2=congrid(a, px, py)
erase
tvscl, a2, xsize=px, ysize=py, xshift, yshift

ax=(findgen(newx)-xc*zoomx)*cdx/zoomx
ay=(findgen(newy)-yc*zoomy)*cdy/zoomy
ax1=congrid(ax, px)
ay1=congrid(ay, py)
contour,a2,ax1,ay1,/nodata,/noerase,xstyle=1,ystyle=1

cursor,x1,y1,/data,/down
cursor,x2,y2,/data,/down

print,"slice in data", x1,y1,x2,y2
xx1=long(x1/cdx)
yy1=long(y1/cdy)
xx2=long(x2/cdx)
yy2=long(y2/cdy)
print,"newslice", xx1,yy1,xx2,yy2
aslice=a(xx1:xx2, yy1:yy2)
tvscl,aslice
contour,aslice,/nodata,/noerase,xstyle=1,ystyle=1
end
