###########################################################################
### This 'tangle' R script was created from an RSP document.
### RSP source document: 'QPot_Example1.md.rsp'
### Metadata 'keywords': ''
###########################################################################

holdthese <- par(no.readonly = TRUE)
		tsdens.col <- c("lightsteelblue", "white", "indianred")
		qp.col <- c("#FDE725FF", "#E3E418FF", "#C7E020FF", "#ABDC32FF", "#8FD744FF", 
					"#75D054FF", "#5DC963FF", "#47C06FFF", "#35B779FF", "#28AE80FF", 
					"#20A486FF", "#1F9A8AFF", "#21908CFF", "#24868EFF", "#287C8EFF", 
					"#2C728EFF", "#31688EFF", "#355D8DFF", "#3B528BFF", "#404688FF", 
					"#443A83FF", "#472D7BFF", "#481F71FF","#471163FF", "#440154FF")
		legend.col <- function(col, lev, xadj){ 
				opar <- par
				n <- length(col)
				bx <- par("usr")
				box.cx <- c(bx[2] + (bx[2] - bx[1]) / 1000 + 0, bx[2] + (bx[2] - bx[1]) / 1000 + (bx[2] - bx[1]) / 50)
				box.cy <- c(bx[3], bx[3])
				box.sy <- (bx[4] - bx[3]) / n
				xx <- rep(box.cx, each = 2) + xadj
				par(xpd = TRUE)
				for(i in 1:n){
					yy <- c(box.cy[1] + (box.sy * (i - 1)),
					box.cy[1] + (box.sy * (i)),
					box.cy[1] + (box.sy * (i)),
					box.cy[1] + (box.sy * (i - 1)))
					polygon(xx, yy, col = col[i], border = col[i])
				}
				par(new = TRUE)
				plot(0, 0, type = "n", ylim = c(min(lev), max(lev)), yaxt = "n", ylab = "",
				xaxt = "n", xlab = "", frame.plot = FALSE)
				axis(side = 4, las = 2, tick = FALSE, line = (.25 + xadj))
				par <- opar
			}
require(QPot)
	require(R.devices)
	require(R.rsp)
	var.eqn.x <- "(alpha*x)*(1-(x/beta)) - ((delta*(x^2)*y)/(kappa+(x^2)))"
	var.eqn.y <- "((gamma*(x^2)*y)/(kappa+(x^2))) - mu*(y^2)"
	model.parms <- c(alpha = 1.54, beta = 10.14, delta = 1, gamma = 0.476, kappa = 1, mu = 0.112509)
	parms.eqn.x <- Model2String(var.eqn.x, parms = model.parms)
	rcat("\n")
	parms.eqn.y <- Model2String(var.eqn.y, parms = model.parms) 
	rcat("\n")
require(phaseR)
	model.ex1 <- function(t, y, parameters){
		x <- y[1]
		y <- y[2]
		alpha <- parameters["alpha"]
		beta <- parameters["beta"]
		delta <- parameters["delta"]
		kappa <- parameters["kappa"]
		gamma <- parameters["gamma"]
		mu <- parameters["mu"]
		dx <- (alpha*x)*(1-(x/beta)) - ((delta*(x^2)*y)/(kappa + (x^2)))
		dy <- ((gamma*(x^2)*y)/(kappa + (x^2))) - mu*(y^2)
		list(c(dx,dy))
	}
toPNG("EX1vectordiagram", {
	# draws the vector field
	flowField(deriv = model.ex1, xlim = c(-0.1, 6), ylim = c(-0.1, 6), parameters = model.parms, add = F, points = 30, col = "grey70", ann = F, arrow.head = 0.025, frac = 1.1, xaxs = "i", yaxs = "i", las = 1)
	# draw the nullclines and suppress the output by assigning it to a variable
	supp.print <- nullclines(deriv = model.ex1, xlim = c(-0.1, 6), ylim = c(-0.1, 6), parameters = model.parms, col = c("blue", "red"), points = 250)
	# draw and label the equilibria
	# open circles are unstable, black are stable
	points(0,0 , pch = 21 , col = "black" , bg = "white" , cex = 1.5)
	text(0,0 , labels = expression(italic(e[u1])) , adj = c(-0.1,-.25) , cex = 1.5)
	points(1.4049, 2.8081 , pch = 21 , col = "black" , bg = "grey30" , cex = 1.5)
	text(1.4049, 2.8081 , labels = expression(italic(e[s1])) , adj = c(-0.1,1.25) , cex = 1.5)
	points(4.2008, 4.0039 , pch = 21 , col = "black" , bg = "white" , cex = 1.5)
	text(4.2008, 4.0039 , labels = expression(italic(e[u2])) , adj = c(-0.1,1.25) , cex = 1.5)
	points(4.9040, 4.0619 , pch = 21 , col = "black" , bg = "grey30" , cex = 1.5)
	text(4.9040, 4.0619 , labels = expression(italic(e[s2])) , adj = c(.4,-.35) , cex = 1.5)
	mtext(expression(italic(x)), side = 1, line = 2.5)
	mtext(expression(italic(y)), side = 2, line = 2.5)
})
model.state <- c(x = 1, y = 2) 	# initial condition
	model.sigma <- 0.05				# the level of noise
	model.time <- 1000 #12500				# the length of the simulation
	model.deltat <- 0.025			# the time step
	rcat("\n")
ts.ex1 <- TSTraj(y0 = model.state, time = model.time, 
		deltat = model.deltat, x.rhs = var.eqn.x, y.rhs = var.eqn.y, 
		parms = model.parms, sigma = model.sigma)
	rcat("\n")
toPNG("EX1timeseriesFig1", {TSPlot(ts.ex1, deltat = model.deltat)})
toPNG("EX1timeseriesFig2", {TSPlot(ts.ex1, deltat = model.deltat, dim = 2)})
toPNG("EX1timeseriesFig3", {TSDensity(ts.ex1, dim = 1)})
k2 <- MASS::kde2d(ts.ex1[,2], ts.ex1[,3], n = 200)
		k2dns <- k2$z/sum(k2$z)
		k2cut <- cut(k2dns, 100, label = FALSE)
		crramp <- colorRampPalette(tsdens.col)
		colr <- crramp(100)
toPNG("EX1timeseriesFig4", {
	par(mar = c(4, 4, 4 , 4))
	TSDensity(ts.ex1, dim = 2)
	legend.col(col = colr, lev = k2dns, xadj = 0.1)
	par(holdthese)
	})
bounds.x = c(-0.5, 20.0)
	bounds.y = c(-0.5, 20.0)
	step.number.x = 1000 # 4100
	step.number.y = 1000 # 4100
	eq1.x = 1.40491
	eq1.y = 2.80808
	eq2.x = 4.9040
	eq2.y = 4.06187
eq1.local <- QPotential(x.rhs = parms.eqn.x, x.start = eq1.x, x.bound = bounds.x, x.num.steps = step.number.x, y.rhs = parms.eqn.y, y.start = eq1.y,  y.bound = bounds.y, y.num.steps = step.number.y)
	eq2.local <- QPotential(x.rhs = parms.eqn.x, x.start = eq2.x, x.bound = bounds.x, x.num.steps = step.number.x, y.rhs = parms.eqn.y, y.start = eq2.y, y.bound = bounds.y, y.num.steps = step.number.y)
ex1.global <- QPGlobal(local.surfaces = list(eq1.local, eq2.local), unstable.eq.x = c(0, 4.2008), unstable.eq.y = c(0, 4.0039), x.bound = bounds.x, y.bound = bounds.y)
k2dns <- seq(min(ex1.global, na.rm = T), max(ex1.global, na.rm = T), 0.001)
	k2cut <- cut(k2dns, 100, label = FALSE)
	crramp <- colorRampPalette(qp.col)
	colr <- crramp(100)
toPNG("EX1globalvisualizationFig5", {
		QPContour(surface = ex1.global, dens = c(1000, 1000), x.bound = bounds.x, y.bound = bounds.y, 
					c.parm = 1, xlab = expression(italic("x")), ylab = "")
		mtext(text = expression(italic("y")), side = 2, line = 2.5, outer = T, at = 0.5)
	})
toPNG("EX1globalvisualizationFig6", {
		par(oma = c(0,1,0,2))
		QPContour(surface = ex1.global, dens = c(1000, 1000), x.bound = bounds.x, y.bound = bounds.y, 
					c.parm = 5, xlab = expression(italic("x")), ylab = "")
		legend.col(col = colr, lev = k2dns, xadj = 0.1)
		par(holdthese)
	})
require(plot3D)
	require(viridis)
toPNG( "EX1globalvisualization3D", {
	frac.x <- c(0.05, 0.3)
	frac.y <- c(0.125, 0.25)
	global.sub <- ex1.global[round(dim(ex1.global)[1]*frac.x[1]):round(dim(ex1.global)[1]*frac.x[2]), round(dim(ex1.global)[2]*frac.y[1]):round(dim(ex1.global)[2]*frac.y[2])]
	global.sub[global.sub > 0.01] <- NA
#	par(fin = c(4, 4), oma = rep(0,4), mar = c(3.5, 3.5, 0, 0))
	persp3D(z = global.sub, theta = 25, phi = 25, col = viridis(100, option = "C"), shade = 0.1, colkey = list(side = 4, length = 0.85), contour = T, zlim = c(-0.001, .011), zlab = intToUtf8(0x03A6))
})
VDAll <- VecDecomAll(surface = ex1.global, x.rhs = parms.eqn.x, y.rhs = parms.eqn.y, x.bound = bounds.x, y.bound = bounds.y)
toPNG("EX1vectorfielddecompDETSKEL", {
VecDecomPlot(x.field = VDAll[,,1], y.field = VDAll[,,2], dens = c(25, 25), x.bound = bounds.x, y.bound = bounds.y, xlim = c(0, 11), ylim = c(0, 6), arrow.type = "equal", tail.length = 0.25, head.length = 0.025)
})
toPNG("EX1vectorfielddecompGRAD", {
VecDecomPlot(x.field = VDAll[,,3], y.field = VDAll[,,4], dens = c(25, 25), x.bound = bounds.x, y.bound = bounds.y, arrow.type = "proportional", tail.length = 0.25, head.length = 0.025)
})
toPNG("EX1vectorfielddecompREM", {
VecDecomPlot(x.field = VDAll[,,5], y.field = VDAll[,,6], dens = c(25, 25), x.bound = bounds.x, y.bound = bounds.y, arrow.type = "proportional", tail.length = 0.35, head.length = 0.025)
})
toPNG("EX1vectorfielddecompFig8", {
			holdthese <- par(no.readonly = TRUE)
			par(mfrow = c(2,2), mar = c(2,2,1,1), oma = c(3,3,1,1))
			VecDecomPlot(x.field = VDAll[,,3], y.field = VDAll[,,4], dens = c(25, 25), x.bound = bounds.x, y.bound = bounds.y, arrow.type = "proportional", tail.length = 0.25, head.length = 0.025)
			mtext(side = 3, text = expression(Gradient~field~(-nabla~phi(x, y))))
			mtext(side = 2, text = "Proportional arrow lengths", line = 3.75)
			mtext(side = 2, text = expression(italic(y)), line = 2.25)
			VecDecomPlot(x.field = VDAll[,,5], y.field = VDAll[,,6], dens = c(25, 25), x.bound = bounds.x, y.bound = bounds.y, arrow.type = "proportional", tail.length = 0.35, head.length = 0.025)
			mtext(side = 3, text = expression(Remainder~field~(bold(r)(x, y))))
			VecDecomPlot(x.field = VDAll[,,3], y.field = VDAll[,,4], dens = c(25, 25), x.bound = bounds.x, y.bound = bounds.y, arrow.type = "equal", tail.length = 0.15, head.length = 0.025)
			mtext(side = 2, text = "Equal arrow lengths", line = 3.75)
			mtext(side = 2, text = expression(italic(y)), line = 2.25)
			mtext(side = 1, text = expression(italic(x)), line = 2.25)	
			VecDecomPlot(x.field = VDAll[,,5], y.field = VDAll[,,6], dens = c(25, 25), x.bound = bounds.x, y.bound = bounds.y, arrow.type = "equal", tail.length = 0.15, head.length = 0.025)
			mtext(side = 1, text = expression(italic(x)), line = 2.25)
			par(holdthese)
})
