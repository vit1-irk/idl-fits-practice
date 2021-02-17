!path=!path+":/opt/IDLAstro/pro"

f="/home/vitya/FITS/aia.lev1.171A_2015-10-22T00_00_10.34Z.image_lev1.fits"
f1="/home/vitya/FITS/hmi.m_45s.2015.10.22_00_01_30_TAI.magnetogram.fits"
a0=readfits(f, header)
b0=readfits(f1, header1)

cdx=float(sxpar(header, "CDELT1"))
cdy=float(sxpar(header, "CDELT2"))
xc=long(sxpar(header, "CRPIX1"))
yc=long(sxpar(header, "CRPIX2"))
xlen=long(sxpar(header, "NAXIS1"))
ylen=long(sxpar(header, "NAXIS2"))

bcdx=float(sxpar(header1, "CDELT1"))
bcdy=float(sxpar(header1, "CDELT2"))
bxc=long(sxpar(header1, "CRPIX1"))
byc=long(sxpar(header1, "CRPIX2"))
bxlen=long(sxpar(header1, "NAXIS1"))
bylen=long(sxpar(header1, "NAXIS2"))

rotf=float(sxpar(header, "CROTA2"))
rotf1=float(sxpar(header1, "CROTA2"))

a0=rot(a0, rotf, 1, xc, yc, /interp)
b0=rot(b0, rotf1, 1, bxc, byc, /interp)

newx=512
newy=512

a=rebin(a0, newx, newy)
window, xsize=newx, ysize=newy, xpos=0, ypos=0


zoomx=float(newx)/float(xlen)
zoomy=float(newy)/float(ylen)

;xindices ndices-xc/2
contour,a,/nodata,/noerase
px = round(!d.x_size*(!x.window[1]-!x.window[0]))
py = round(!d.y_size*(!y.window[1]-!y.window[0]))

xshift=!d.x_size*!x.window[0]
yshift=!d.y_size*!y.window[0]

a2=congrid(a, px, py)
erase
tvscl, (a2<2000)>(-2000), xsize=px, ysize=py, xshift, yshift

;ax=(findgen(newx)-xc*zoomx)*cdx/zoomx
;ay=(findgen(newy)-yc*zoomy)*cdy/zoomy
ax=(findgen(newx)-511./2)*cdx/zoomx
ay=(findgen(newy)-511./2)*cdy/zoomy
ax1=congrid(ax, px)
ay1=congrid(ay, py)
contour,a2,ax1,ay1,/nodata,/noerase,xstyle=1,ystyle=1

cursor,x1,y1,/data,/down
cursor,x2,y2,/data,/down

print," cdelt x, y", cdx,cdy
print,"bcdelt x, y", bcdx,bcdy
print," center ", xc,yc, "; img x, y ", xlen,ylen
print,"bcenter ", bxc,byc, "; img x, y ", bxlen,bylen
print,"slice in data", x1,y1,x2,y2

xx1=long(x1/cdx)+xlen/2.
yy1=long(y1/cdy)+ylen/2.
xx2=long(x2/cdx)+xlen/2.
yy2=long(y2/cdy)+ylen/2.

bxx1=long(x1/bcdx)+bxlen/2.
byy1=long(y1/bcdy)+bylen/2.
bxx2=long(x2/bcdx)+bxlen/2.
byy2=long(y2/bcdy)+bylen/2.

print,"newslice  :", xx1,yy1,xx2,yy2
print,"newslice 1:", bxx1,byy1,bxx2,byy2

aslice=a0[xx1:xx2, yy1:yy2]
bslice=b0[bxx1:bxx2, byy1:byy2]
;bslice=rebin(bslice, xx2-xx1, yy2-yy1)
window,2

axslice=findgen(xx2-xx1+1)*cdx+x1
ayslice=findgen(yy2-yy1+1)*cdy+y1

contour,aslice,axslice,ayslice,/nodata,/noerase,xstyle=1,ystyle=1
bxslice=findgen(bxx2-bxx1+1)*bcdx+x1
byslice=findgen(byy2-byy1+1)*bcdy+y1
px = round(!d.x_size*(!x.window[1]-!x.window[0]))
py = round(!d.y_size*(!y.window[1]-!y.window[0]))

xshift=!d.x_size*!x.window[0]
yshift=!d.y_size*!y.window[0]

aslicecon=congrid(aslice, px, py)

ax_slice=findgen(px)
ay_slice=findgen(py)

help,axslice
help,ayslice
help,aslice
help,bslice

erase
device,decomposed=0
loadct,0
tvscl,aslicecon, xsize=px, ysize=py, xshift, yshift
contour,aslice,axslice,ayslice,/nodata,/noerase,xstyle=1,ystyle=1,xtitle='slice arcsec', ytitle='slice arcsec'
loadct,33
contour,bslice,bxslice,byslice,levels=max(bslice)*[-0.5,-0.3,0.3,0.5], c_colors=[0, 20, 200, 250], /overplot
end
