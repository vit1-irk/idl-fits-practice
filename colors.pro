!path=!path+":/opt/IDLAstro/pro"

f="/home/debug/FITS/aia.lev1.171A_2015-10-22T00_00_10.34Z.image_lev1.fits"
print, f
a0=readfits(f, header)

newx=512
newy=512

a=rebin(a0, newx, newy)

device, decomposed=0
window, xsize=newx, ysize=newy, xpos=0, ypos=0

loadct, 5
tvscl,a
end
