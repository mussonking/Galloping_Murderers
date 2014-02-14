################################################
###_resetarrays() 
###   Procedure that reset all arrays containing 
###   players and set timer to restart status
################################################
proc(_resetarrays,
	export('player.list', array())
	export('pfarray.list', array())
    export('winner.number', '0')
    export('status.join', 'on')
	export('button.locked', array())
	export('player.locked', array())
	export('free.num', array())
	export('ident.gmr.spawn', array('36', '109', '-105'))
	export('ident.gmr.horse1', array(world: world, x:180, y:67, z:25)) 
	export('ident.gmr.horse2', array(world: world, x:180, y:67, z:5)) 
	export('pressure.plate.checkpoint', array(array('133.0', '67.0', '-27.0'), array('134.0', '67.0', '-27.0'), array('158.0', '67.0', '-116.0'), array('114.0', '67.0', '-164.0'), array('35.0', '67.0', '-163.0'), array('41.0', '67.0', '-74.0')))
	export('pressure.plate.item', array(array('131.0', '67.0', '-35.0'), array('158.0', '68.0', '-76.0'), array('136.0', '67.0', '-158.0'), array('100.0', '67.0', '-175.0'), array('19.0', '67.0', '-152.0'), array('58.0', '69.0', '-150.0'), array('65.0', '70.0', '-120.0'), array('34.0', '67.0', '-111.0'), array('56.0', '70.0', '-65.0'), array('56.0', '70.0', '-73.0'), array('29.0', '67.0', '-72.0'), array('-57.0', '67.0', '-53.0')))
	export('pressure.plate.finish', array(array('-23.0', '67.0', '9.0'), array('-20.0', '67.0', '9.0'), array('-17.0', '67.0', '9.0'), array('-23.0', '67.0', '9.0')))
)
proc(_endresetarray,
	export('player.list', array())
	export('pfarray.list', array())
	export('status.join', 'on')
	export('button.locked', array())
	export('player.locked', array())
	export('free.num', array())
	)
	
################################################
### _startcord(@number) 
###   Procedure that return the each coords
###   at the start of a game
################################################
proc(_startcord, @number,
if(@number == '1') {
@array = array('189', '67', '-12')
return(@array)
export('player.'.@number, @array)
}
if(@number == '2') {
@array = array('189', '67', '-9')
return(@array)
export('player.'.@number, @array)
}
if(@number == '3') {
@array = array('189', '67', '-6')
return(@array)
export('player.'.@number, @array)
}
if(@number == '4') {
@array = array('189', '67', '-3')
return(@array)
export('player.'.@number, @array)
}
if(@number == '5') {
@array = array('189', '67', '0')
return(@array)
export('player.'.@number, @array)
}
if(@number == '6') {
@array = array('189', '67', '3')
return(@array)
export('player.'.@number, @array)
}
if(@number == '7') {
@array = array('189', '67', '6')
return(@array)
export('player.'.@number, @array)
}
if(@number == '8') {
@array = array('189', '67', '9')
return(@array)
export('player.'.@number, @array)
}
if(@number == '9') {
@array = array('189', '67', '12')
return(@array)
export('player.'.@number, @array)
}
if(@number == '10') {
@array = array('189', '67', '15')
return(@array)
export('player.'.@number, @array)
}
if(@number == '11') {
@array = array('189', '67', '18')
return(@array)
export('player.'.@number, @array)
}
if(@number == '12') {
@array = array('189', '67', '21')
return(@array)
export('player.'.@number, @array)
}
if(@number == '13') {
@array = array('189', '67', '24')
return(@array)
export('player.'.@number, @array)
}
if(@number == '14') {
@array = array('189', '67', '27')
return(@array)
export('player.'.@number, @array)
}
if(@number == '15') {
@array = array('189', '67', '30')
return(@array)
export('player.'.@number, @array)
}
if(@number == '16') {
@array = array('189', '67', '33')
return(@array)
export('player.'.@number, @array)
}
if(@number == '17') {
@array = array('189', '67', '36')
return(@array)
export('player.'.@number, @array)
}
if(@number == '18') {
@array = array('189', '67', '39')
return(@array)
export('player.'.@number, @array)
}
if(@number == '19') {
@array = array('189', '67', '42')
return(@array)
export('player.'.@number, @array)
}
if(@number == '20') {
@array = array('189', '67', '45')
return(@array)
export('player.'.@number, @array)
}
)