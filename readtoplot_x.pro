
function readtoplot_x, f
	a=readfits(f, header)
	xc=long(sxpar(header, "CRPIX1"))
	yc=long(sxpar(header, "CRPIX2"))
	xlen=long(sxpar(header, "NAXIS1"))
	ylen=long(sxpar(header, "NAXIS2"))

	cdx=float(sxpar(header, "CDELT1"))
	cdy=float(sxpar(header, "CDELT2"))
	print,xc,yc,xlen,ylen

	xvalues=findgen(xlen)
	yvalues=findgen(ylen)
	xindices=indgen(xlen)
	yindices=indgen(ylen)

	for x=0,xlen-1 do begin
		sumy=float(0)
		for y=(yc-10),(yc+10) do begin
			sumy=sumy+a[x,y]
		endfor
		xvalues[x]=sumy/21.0
	endfor
	for y=0,ylen-1 do begin
		sumx=float(0)
		for x=(xc-10),(xc+10) do begin
			sumx=sumx+a[x,y]
		endfor
		yvalues[y]=sumx/21.0
	endfor

	xindices=(xindices-xc)*cdx
	yindices=(yindices-yc)*cdy
	arr=[xindices, xvalues]
	return,arr
end

