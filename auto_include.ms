#Galloping_murderers auto_include.ms
################################################
### _emptyinv(player()) 
###   Procedure that emtpy inventory
###   and armor of designated player
################################################
proc(_emptyinv, @player,

	@empty = array(
				null, null, null, null, null, null, null, null, null, null, 
				null, null, null, null, null, null, null, null, null, null,
				null, null, null, null, null, null, null, null, null, null,
				null, null, null, null, null, 100:null, 101:null, 102:null, 103:null
			)

	if(@player == '',
		return(@empty),
		set_pinv(@player, @empty)
		return(true)
	)
	)
	
################################################
### _addtolist(player()) 
###   Procedure that add player to the
###   next game array
################################################
proc(_addtolist, @player,
	if(import('loadhorsearray') != 'done') {
		_setrace()
		export('loadhorsearray', 'done')
	}
		@playerarray = import('player.list')
		@pfarray = import('pfarray.list')
		array_push(@playerarray, @player)
		export('player.list', @playerarray)
			if(!array_contains(@pfarray, @player)) {
				array_push(@pfarray, @player)
				export('pfarray.list', @pfarray)
			}
		tmsg(@player, color(2).'You have been added to the waiting list.')
	
	)
	
################################################
### _addtogame(@player, @number) 
###   Procedure that add player to the
###   current race
################################################
proc(_addtogame, @player, @number
	if(@number == '') {
		@player = import('temp.addtogame.player')
		@number = import('temp.addtogame.number')
	}
		_give_startitem(@player)
		_setposstart(@player, @number)
		export('info.'.@player, @number)
		@playerarray = import('player.list')
		@pfarray = import('pfarray.list')
		array_push(@playerarray, @player)
		export('player.list', @playerarray)
			array_contains(@pfarray, @player) 
				array_push(@pfarray, @player)
				export('pfarray.list', @pfarray)
			
	)
################################################
### _give_startitem(@player) 
###   Procedure that give racer
###   starting items
################################################
proc(_give_startitem, @player,
	if(has_permission(@player, 'donator.vip+')) {
		set_inventory_item(pinfo(@player, 13), 39, array(type: 306))
		set_inventory_item(pinfo(@player, 13), 38, array(type: 307))
		set_inventory_item(pinfo(@player, 13), 37, array(type: 308))
		set_inventory_item(pinfo(@player, 13), 36, array(type: 309))
		set_inventory_item(pinfo(@player, 13), 2, array(type: 272))
		set_inventory_item(pinfo(@player, 13), 1, array(type: 329))
		set_inventory_item(pinfo(@player, 13), 3, array(type: 364, qty: 10))
	}
	if(has_permission(@player, 'donator.vip') && !has_permission(@player, 'donator.vip+')) {
		set_inventory_item(pinfo(@player, 13), 39, array(type: 306))
		set_inventory_item(pinfo(@player, 13), 38, array(type: 303))
		set_inventory_item(pinfo(@player, 13), 37, array(type: 304))
		set_inventory_item(pinfo(@player, 13), 36, array(type: 309))
		set_inventory_item(pinfo(@player, 13), 2, array(type: 283))
		set_inventory_item(pinfo(@player, 13), 1, array(type: 329))
		set_inventory_item(pinfo(@player, 13), 3, array(type: 364, qty: 10))
	}
	if(!has_permission(@player, 'donator.vip') && !has_permission(@player, 'donator.vip+')) {
		set_inventory_item(pinfo(@player, 13), 39, array(type: 302))
		set_inventory_item(pinfo(@player, 13), 38, array(type: 303))
		set_inventory_item(pinfo(@player, 13), 37, array(type: 304))
		set_inventory_item(pinfo(@player, 13), 36, array(type: 305))
		set_inventory_item(pinfo(@player, 13), 2, array(type: 268))
		set_inventory_item(pinfo(@player, 13), 1, array(type: 329))
		set_inventory_item(pinfo(@player, 13), 3, array(type: 364, qty: 10))
		
		}
	)

################################################
###_startgame() 
###   Procedure that start a race from the
###   player.list
################################################

proc(_startgame,
	broadcast(color(6).'Game Starting in 1 minutes, type'color(4).'/gmr join'.color(6).', if not already done, To join the next Race!')
	set_timeout(30000, closure(
		_remindjoin()
		broadcast(color(6).'Game Starting in 30 seconds, type'color(4).'/gmr join'.color(6).', if not already done, To join the next Race!')
		) )
	set_timeout(60000, closure(  #time for countdown(adjust second timeout too!)
		_createidarray()
		@parray = import('player.list') ###import all player waiting to start next game.
		if(array_size(@parray) < 2) { #minimum number of players to start a game
		broadcast(color(4).'Need minimum 2 players to Start the Race.')
			_startgame()
			die()
			}
			@i = 0
			foreach(@parray, @name) {
				@i++
				export('info.'.@name, @i)
				_give_startitem(@name)
				}
				export('nextnumber', add(@i, '1'))
			foreach(@parray, @name) {
			@num = import('info.'.@name)
			_setposstart(@name, @num)
				}
			export('status.join', 'ingame')
				))
				)
				
################################################
### _setposstart(@name, @number) 
###   Procedure that set position for horse
###   and the player, at start of race
################################################
proc(_setposstart, @player, @number,
#@horses = get_value('horse.list')
#@horse = array_get(@horses, subtract(@number, '1'))
#tame_mob(@player, @horse)
	if(@number == '') {
		@player = import('temp.addtogame.player')
		@number = import('temp.addtogame.number')
	}
@cords = _startcord(@number)
set_ploc(@player, @cords)
tmsg(@player, color(4).'ATTENTION'color(5)'Type:'.color(4)'/tame'.color(5)'To tame your horse!')
)
################################################
### _setpos(@name, @number) 
###   Procedure that set position for horse
###   and the player during race
################################################
proc(_setpos, @player, @number, @location,
@horses = get_value('horse.list')
@horse = array_get(@horses, subtract(@number, '1'))
@horse = entity_id(@horse)
set_entity_loc(@horse, @location)
set_timeout(2000, closure(
set_entity_rider(@horse, pinfo(@player, 13))
))
)

################################################
###_remove_player(@removename) 
###   Procedure that remove a player from the
###   player.list
################################################
proc(_remove_player, @removename,
	### Remove the name from player.list
	@joinstatus = import('status.join')
	@playerlist = import('player.list')
	array_remove_values(@playerlist, @removename)
	export('player.list', @playerlist)
	tmsg(@removename, color(2).'You have left the game')
		if(@joinstatus == 'ingame') {
			@freenum = import('info.'.@removename)
			@allnum = import('free.num')
			array_push(@allnum, @freenum)
			export('free.num', @allnum)
			export('info.'.@removename, '')
			@horses = get_value('horse.list')
			@id = array_get(@horses, subtract(@freenum, '1'))
			@id = entity_id(@id)
			@cords = _startcord(@freenum)
				set_timeout(2000, closure(
					set_entity_loc(@id, @cords)
				))
		@winnum = import('winner.number')
			if(@winnum == '1') {
				if(@playerlist < 6) {
					_endrace()
				}
			}
			if(@winnum == '2') {
				if(@playerlist < 11) {
					_endrace()
				}
			}
			if(@winnum == '3') {
				if(@playerlist < 16) {
					_endrace()
				}
			}
			if(@winnum == '4') {
				if(@playerlist < 21) {
					_endrace()
				}
			}
		}
	)

################################################
###_remindjoin()
###   Procedure that end a game 
###
################################################
proc(_remindjoin,
@parray = import('player.list')
@allplayer = all_players()
	foreach(@allplayer, @name) {
		if(!array_contains(@parray, @name)) {
			tmsg(@name, color(e).'You did'color(4).'NOT'color(e).'Join The Galloping Murderers waiting list yet. Type:'color(4).'/gmr join'color(e).'Fast to Join the next Race!')
		}
	}
)
	
################################################
###_endrace(@winnername) 
###   Procedure that end the race 
###
################################################
proc(_endrace,
_teleportallspawn()
_endresetarray()
_endresetpers()
set_timeout(10000, closure(
_startgame()
_setrace
))
)

################################################
###_endresetpers() 
###   Procedure that reset info.@player
### at end of races
################################################
proc(_endresetpers,
@pflist = import('pfarray.list')
foreach(@pflist, @name) {
export('info.'@name, '')
}
)
################################################
###_teleporthorse() 
###   Procedure that Teleport all horse in 
###   there start place
################################################
proc(_teleporthorse,
	@horses = get_value('horse.list')
	@num = '1'
	@time = '1000'
		foreach(@horses, @id) {
		@id = entity_id(@id)
			@cords = _startcord(@num)
				set_timeout(@time, closure(
					set_entity_loc(@id, @cords)
				))
			@num++
			@time = add(@time, '1000')
		}
)
################################################
###_teleportallspawn() 
###   Procedure that Teleport all player in 
###   player.list to spawn
################################################	
proc(_teleportallspawn,
@telearray = import('player.list')
foreach(@telearray, @name) {
if(ponline(@name)) {
				set_ploc(@name, import('ident.gmr.spawn'))
				_emptyinv(@name)
				if(array_size(@telearray) > 6) {
				acc_add(@name, '10')
				tmsg(@name, 'You have been awarned 10$ for finishing the game!')
				}
				}
				}
	)
################################################
###_killall() 
###   Procedure that kill all horses  
###   
################################################
proc(_killall,
	@allentities = all_entities()
		foreach(@allentities, @id) {
			if(entity_type(@id) == 'HORSE') {
			set_entity_health(@id, '0')
			}
		}
	)
################################################
###_createidarray() 
###   Procedure that set horses id 
###   and teleport them
################################################
proc(_createidarray,
@allentities = all_entities()
			@horses = array()
				foreach(@allentities, @id) {
					if(entity_type(@id) == 'HORSE') {
					@id = entity_uuid(@id)
					array_push(@horses, @id)
					}
				}
			store_value('horse.list', @horses)
			)

################################################
###_setrace() 
###   Procedure that set horses id 
###   and teleport them
################################################
proc(_setrace,
	export('win.list', array())
	_killall()
		set_timeout(3000, closure(
			spawn_mob('HORSE', '10', import('ident.gmr.horse1'))
			spawn_mob('HORSE', '10', import('ident.gmr.horse2'))
		))
		set_timeout(15000, closure(
			_createidarray()
				set_timeout(5000, closure(
					_createidarray()
					_teleporthorse()
				))
		))
)

