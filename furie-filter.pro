!path=!path+":/opt/IDLAstro/pro"

f="/home/vitya/FITS/aia.lev1.171A_2015-10-22T00_00_10.34Z.image_lev1.fits"
print, f
a=readfits(f, header)
a=a[1024:1535,1024:1535]

xc=long(sxpar(header, "CRPIX1"))
yc=long(sxpar(header, "CRPIX2"))
xlen=long(sxpar(header, "NAXIS1"))
ylen=long(sxpar(header, "NAXIS2"))

print,xlen,ylen

afft=FFT(a, /center)

power_spec = abs(afft)
img_reversed = power_spec - max(power_spec)

window, 1, xsize=512, ysize=512, xpos=0, ypos=0
tvscl, a

window, 2, xsize=512, ysize=512, xpos=512, ypos=0
tvscl, alog10(power_spec^2)

print,min(img_reversed), max(img_reversed)
mask = img_reversed gt -837

window, 3, xsize=512, ysize=512, xpos=0, ypos=512
tvscl,alog10(afft*mask)

rev_fft = FFT(afft*mask, /inverse, /center)
window, 4, xsize=512, ysize=512, xpos=512, ypos=512
tvscl,rev_fft

end
