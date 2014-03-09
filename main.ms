#Galloping_murderers main.ms
######################################################
### Set all default values at server start############
######################################################
set_timeout(1000, closure(
	_resetarrays()
	))
set_timeout(10000, closure(
	_setrace()
	))

 set_timeout(30000, closure(
	_startgame()
	))
	
#######################################################
### When any player quit the server ###################
#######################################################
bind(player_quit, null, null, @event,
	@quitname = @event['player']
	@playerlist = import('player.list')
	###If the player is NOT ingame or on waitlist
	if(!array_contains(@playerlist, @quitname)) {
		die()
	}
#	if(array_size(@playerlist) == 0) {
#		@status = import('status.join')
#			if(@status == 'ingame') {
#				_endrace('none')
#				die()
#			}
#	}
	if(array_contains(@playerlist, @quitname)) {
		_remove_player(@quitname)
		die()		
	}
	)
	
	
#######################################################
### When any player join the server ###################
#######################################################
bind(player_join, null, null, @playerjoinevent,
	@player = @playerjoinevent['player']
	set_timeout(1000, closure(
	set_ploc(@player, import('ident.gmr.spawn'))
	set_pmode(@player, 'ADVENTURE')
	@status = import('status.join')
	_emptyinv(@player)
		if(@status == 'on') {
			_addtolist(@player)
		}
)))

#######################################################
### When any player Respawn (From dying) ##############
#######################################################

bind(player_spawn, null, null, @playerspawnevent,
	@respawnname = @playerspawnevent['player']
	@playerlist = import('player.list')
		if(!array_contains(@playerlist, @respawnname)) {
			modify_event('location', import('ident.gmr.spawn'))
			_emptyinv(@player)
			die()
		} 
	@pnum = import('info.'.@respawnname)
	@location = import('player.'.@pnum)
		if(@location == null) {
			@cords = _startcord(@pnum)
			modify_event('location', @cords)
			_setpos(@respawnname, @pnum, @cords)
			die()
			set_timeout(5000, closure(
				tmsg(@player, color(4).'=-=-=-=-=-=-=-=-=-=-=-'.color(d).'ATTENTION'.color(4).'=-=-=-=-=-=-=-=-=-=-=-')
				tmsg(@player, color(4).'=-=-=-=-=-=-=-=-=-=-=-'.color(d).'ATTENTION'.color(4).'=-=-=-=-=-=-=-=-=-=-=-')
				tmsg(@player, color(4).'ATTENTION'color(5)'Do not Forget to hit'.color(e)'Wooden Button'.color(5)'For CheckPoints!')
				tmsg(@player, color(4).'=-=-=-=-=-=-=-=-=-=-=-'.color(d).'ATTENTION'.color(4).'=-=-=-=-=-=-=-=-=-=-=-')
				tmsg(@player, color(4).'ATTENTION'color(5)'Do not Forget to hit'.color(e)'Wooden Button'.color(5)'For CheckPoints!')
				))
		}
	modify_event('location', @location)
	_setpos(@respawnname, @pnum, @location)
)

#######################################################
### 	Make horses invincible      ###################
#######################################################
bind(entity_damage, null, null, @invhorse,
	@type = @invhorse['type']
		if(@type != 'PLAYER') {
			modify_event('amount', cancel())
		}
)

#######################################################
###  Inventory Click to shoot projectile   ############
###  And checpoints & items button         ############
#######################################################
bind(player_interact, null, null, @invclick,
	@status = import('status.join')
		if(@status = 'ingame') {							
			@player = @invclick['player']
			@leftclick = @invclick['action']
			@slotitem = @invclick['item']
			@block = @invclick['block']
			@blocation = pcursor()
				if(@leftclick == 'left_click_block' || @leftclick == 'left_click_air') {
					if(@slotitem == '262:0') {
						shoot_projectile(@player, 'ARROW')
						ptake_item(@player, '262', '1')
					}
					if(@slotitem == '385:0') {
						shoot_projectile(@player, 'SMALL_FIREBALL')
						ptake_item(@player, '385', '1')
					}
					if(@slotitem == '377:0') {
						shoot_projectile(@player, 'FIREBALL')
						ptake_item(@player, '377', '1')
					}
					if(@slotitem == '144:1') {
						shoot_projectile(@player, 'WITHER_SKULL')
						ptake_item(@player, '144:1', '1')
					}
				}
				if(@leftclick == 'right_click_block' && @block == '77:1' || @block == '77:2' || @block == '77:3' || @block == '77:4') {
					@lockbutton = import('button.locked')
						if(array_contains(@lockbutton, @blocation)) {
							die(color(4).'YOU CANT!! --> This button was already use. 5 Seconds cooldown')
						}
					@lockplayer = import('player.locked')
						if(array_contains(@lockplayer, @player)) {
							die(color(4).'YOU CANT!! --> You already got an item. 10 Seconds cooldown')
						}
		@itemarray = array('144:1', '144:1', '144:1', '377', '377', '377', '377', '377', '385', '385', '385', '385', '262', '262', '262', '262', '262', '262', '262', '262')
		@itemtogive = array_rand(@itemarray, 1, false)[0]
		if(@itemtogive == '262') {
			pgive_item(@player, @itemtogive, 3)
			msg(color(2).'You just received 3' data_name(@itemtogive))
		}
		if(@itemtogive == '377' || @itemtogive == '385') {
			pgive_item(@player, @itemtogive, 1)
			msg(color(2).'You just received a Fireball')
		}
		if(@itemtogive == '144:1') {
			pgive_item(@player, @itemtogive, 1)
			msg(color(2).'You just received a Whiter Skull')
		}
				array_push(@lockbutton, @blocation)
				export('button.locked', @lockbutton)
				array_push(@lockplayer, @player)
				export('player.locked', @lockplayer)
				set_timeout(5000, closure(
				array_remove_values(@lockbutton, @blocation)
				export('button.locked', @lockbutton)
					))
				set_timeout(10000, closure(
				array_remove_values(@lockplayer, @player)
				export('player.locked', @lockplayer)
					))
			}
				if(@leftclick == 'right_click_block' && @block == '143:1' || @block == '143:2' || @block == '143:3' || @block == '143:4' || @block == '143:9' || @block == '143:10' || @block == '143:11' || @block == '143:12') {
					msg(color(3).'NEW CHECK POINT SET!!')
					@number = import('info.'.@player)
					array_normalize(@blocation)
					@x = array_get(@blocation, 0)
					@y = array_get(@blocation, 1)
					@z = array_get(@blocation, 2)
					@x = add(@x, '1')
					@z = add(@z, '1')
					@blocation = array(@x, @y, @z)
					export('player.'.@number, @blocation)
				}
				if(@leftclick == 'right_click_block' && @block == '19') {
					@winnum = import('winner.number')
					@plist = import('player.list')
					@winlist = import('win.list')
					if(array_contains(@winlist, @player)) {
					die()
					}
					if(!array_contains(@plist, @player)){
					die()
					}
							if(@winnum == '4') {
								export('winner.number', '0')
								broadcast(color(4).@player color(5).'Finished Fifth!!!')
								array_push(@winlist, @player)
								export('win.list', @winlist)
								export('winner.name.5', @player)
									if(array_size(@plist) > 9) {
										acc_add(@player, '5')
										}
									if(array_size(@plist) < 21) {
										export('winner.number', '0')
										_endrace(@player)
										
									}
								}
							if(@winnum == '3') {
								export('winner.number', '4')
								broadcast(color(4).@player color(5).'Finished Fourth!!!')
								array_push(@winlist, @player)
								export('win.list', @winlist)
								export('winner.name.4', @player)
									if(array_size(@plist) > 9) {
										acc_add(@player, '10')
									}
									if(array_size(@plist) < 16) {
										export('winner.number', '0')
										_endrace(@player)
									}
									if(array_size(@plist) >= 16) {
											broadcast(color(5).'Who is going to finish'color(4)'5th'.color(5).'?')
										}
								}
							if(@winnum == '2') {
								export('winner.number', '3')
								broadcast(color(4).@player color(5).'Finished Third!!!')
								array_push(@winlist, @player)
								export('win.list', @winlist)
								export('winner.name.3', @player)
									if(array_size(@plist) > 9) {
										acc_add(@player, '20')
									}
									if(array_size(@plist) < 11) {
										export('winner.number', '0')
										_endrace(@player)
									}
									if(array_size(@plist) >= 11) {
											broadcast(color(5).'Who is going to finish'color(4)'4th'.color(5).'?')
										}
							}
						if(@winnum == '1') {
								export('winner.number', '2')
								broadcast(color(4).@player color(5).'Finished second!!!')
								array_push(@winlist, @player)
								export('win.list', @winlist)
								export('winner.name.2', @player)
									if(array_size(@plist) > 9) {
										acc_add(@player, '25')
									}
									if(array_size(@plist) < 6) {
										export('winner.number', '0')
										_endrace(@player)
									}
									if(array_size(@plist) >= 6) {
											broadcast(color(5).'Who is going to finish'color(4)'3rd'.color(5).'?')
										}
						}
						if(@winnum == '0') {
							export('winner.number', '1')
							broadcast(color(5).'Congratulation' color(4).@player.color(5).'!!! You just won the 'color(4).'Galloping Murderers Race!')
							array_push(@winlist, @player)
							export('win.list', @winlist)
								if(array_size(@plist) > 9) {
									acc_add(@player, '30')
								}
								if(array_size(@plist) < 4) {
									export('winner.number', '0')
										_endrace(@player)
								}
								if(array_size(@plist) >= 4) {
									broadcast(color(5).'Who is going to finish'color(4)'2nd'.color(5).'?')
								}
						}

				}
	}
)

