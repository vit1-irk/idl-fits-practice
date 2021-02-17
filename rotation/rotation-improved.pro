!path=!path+":/home/vitya/IDLAstro/pro"

f="/home/vitya/FITS/MDI/13.fits"
fn="/home/vitya/FITS/MDI/14.fits"
pi = 3.14159

print, f
a=readfits(f, header)
an=readfits(fn, headern)

xc=long(sxpar(header, "CRPIX1"))
yc=long(sxpar(header, "CRPIX2"))
xlen=long(sxpar(header, "NAXIS1"))
ylen=long(sxpar(header, "NAXIS2"))
rotf=float(sxpar(header, "CROTA2"))
rad=float(sxpar(header, "R_SUN"))

pixrad = long(rad)

print,rotf,rad,pixrad
a=rot(a, rotf, 1, xc, yc, /interp)
an=rot(an, rotf, 1, xc, yc, /interp)
orig = rebin((a>(-1000))<1000, 512,512)

recomp=findgen(long(xlen*pi/2),ylen)
xcl = long(xc * pi / 2)
for y=yc-pixrad,yc+pixrad do begin
	sintheta=float(y-yc)/rad
	xrady = long(rad*cos(asin(sintheta)))
  
  ; compute synoptic map
  lrad = float(xrady)*pi/2
  for l=-lrad,lrad do begin
    phi = float(l)/float(xrady)
    x = long(float(xrady)*sin(phi))
    recomp[xcl+l,y] = a[xc+x,y]
  endfor
endfor

; rotate original and synoptic images

print,yc-pixrad,yc+pixrad
for y=yc-pixrad,yc+pixrad do begin
	;z = rsin(theta); (y-yc)=pixrad*sin(theta)
	sintheta=float(y-yc)/rad
	sintheta2=sintheta*sintheta

	w = 1./26. * (1. - 1./8.*sintheta2 - 1./6.*sintheta2*sintheta2)
	xrady = rad*cos(asin(sintheta))
	toshift = w*xrady*pi*2

  recomp[*,y] = shift(recomp[*,y], toshift)
endfor

; move values from rotated synoptic map to original img

for y=yc-pixrad,yc+pixrad do begin
	sintheta=float(y-yc)/rad
	xrady = long(rad*cos(asin(sintheta)))
  lrad = float(xrady)*pi/2
  
  for x=-xrady,xrady do begin
    l = float(xrady)*atan(float(x) / sqrt(float(xrady*xrady) - float(x*x)))
    a[xc+x,y] = recomp[xcl+l,y]
	endfor
endfor

; remove junk on bounds

for x=0,xlen-1 do begin
	for y=0,ylen-1 do begin
		if ((x-xc)*(x-xc) + (y-yc)*(y-yc)) ge pixrad*pixrad then begin
			a[x, y] = -1000
		endif
	endfor
endfor

window, 0, xsize=512, ysize=512, xpos=512, ypos=0
tvscl, orig
xyouts, 0.1, 0.5, 'day 13 (real)', /normal, color=200, size=2

a1=rebin((a>(-1000))<1000, 512, 512)
window, 1, xsize=512, ysize=512, xpos=0, ypos=0
tvscl, a1
xyouts, 0.1, 0.5, 'day 14 (computed)', /normal, color=200, size=2

nsx = long(pi/2*512)
a3 = rebin((recomp>(-1000))<1000, nsx, 512)
window, 5, xsize=nsx, ysize=512, xpos=1024, ypos=0
tvscl, a3
xyouts, 0.1, 0.5, 'day 13 (stereo)', /normal, color=200, size=2

a2=rebin((an>(-1000))<1000, 512, 512)
window, 2, xsize=512, ysize=512, xpos=0, ypos=600
tvscl, a2
xyouts, 0.1, 0.5, 'day 14 (real Sun)', /normal, color=200, size=2

window, 3, xsize=512, ysize=512, xpos=512, ypos=600
tvscl, a2-a1
xyouts, 0.1, 0.5, 'day 14 diff (real - comp)', /normal, color=200, size=2

window, 4, xsize=512, ysize=512, xpos=1024, ypos=600
tvscl,a1-orig
xyouts, 0.1, 0.5, 'day 14 (computed) - day 13 (real)', /normal, color=200, size=2

end
