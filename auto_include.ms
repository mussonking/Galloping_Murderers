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
		_createidarray()
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
		@number = import('temp.addtogame.number')
	}
	if(@player == '') {
		@player = import('temp.addtogame.player')
	}
				if(ponline) {
				_give_startitem(@player)
				}
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
		pgive_item(@player, 306, 1)
		pgive_item(@player, 307, 1)
		pgive_item(@player, 308, 1)
		pgive_item(@player, 309, 1)
		pgive_item(@player, 272, 1)
		pgive_item(@player, 329, 1)
		pgive_item(@player, 322, 20)
	}
	if(has_permission(@player, 'donator.vip') && !has_permission(@player, 'donator.vip+')) {
		pgive_item(@player, 306, 1)
		pgive_item(@player, 303, 1)
		pgive_item(@player, 304, 1)
		pgive_item(@player, 309, 1)
		pgive_item(@player, 283, 1)
		pgive_item(@player, 329, 1)
		pgive_item(@player, 322, 20)
	}
	if(!has_permission(@player, 'donator.vip') && !has_permission(@player, 'donator.vip+')) {
		pgive_item(@player, 302, 1)
		pgive_item(@player, 303, 1)
		pgive_item(@player, 304, 1)
		pgive_item(@player, 305, 1)
		pgive_item(@player, 268, 1)
		pgive_item(@player, 329, 1)
		pgive_item(@player, 322, 20)
		}
	)

################################################
###_startgame() 
###   Procedure that start a race from the
###   player.list
################################################

proc(_startgame,
	@starttask = import('start.timer')
	clear_task(@starttask)
	broadcast(color(6).'Game Starting in 1 minutes, type'color(4).'/gmr join'.color(6).', if not already done, To join the next Race!')
	@starttimer = set_timeout(30000, closure(  #time for countdown(adjust second timeout too!)
	_remindjoin()
		broadcast(color(6).'Game Starting in 30 seconds, type'color(4).'/gmr join'.color(6).', if not already done, To join the next Race!')
	set_timeout(30000, closure(
		_createidarray()
		@parray = import('player.list') ###import all player waiting to start next game.
		if(array_size(@parray) < 2) { #minimum number of players to start a game
		broadcast(color(4).'Need minimum 2 players to Start the Race.')
			_startgame()
			die()
			}
			export('start.task', 'on')
				@timer = set_timeout(900000, closure(
							@status = import('status.join')
								if(@status = 'ingame') {
									_endrace('timer')
								}
						))
						export('end.timer', @timer)
			export('status.join', 'ingame')
			@i = 0
			foreach(@parray, @name) {
				@i++
				export('info.'.@name, @i)
				if(ponline) {
				_give_startitem(@name)
				}
				}
				export('nextnumber', add(@i, '1'))
			foreach(@parray, @name) {
			@num = import('info.'.@name)
			_setposstart(@name, @num)
				}
				))
				))
			export('start.timer', @starttimer)
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
tmsg(@player, color(4).'=-=-=-=-=-=-=-=-=-=-=-'.color(d).'ATTENTION'.color(4).'=-=-=-=-=-=-=-=-=-=-=-')
tmsg(@player, color(4).'=-=-=-=-=-=-=-=-=-=-=-'.color(d).'ATTENTION'.color(4).'=-=-=-=-=-=-=-=-=-=-=-')
tmsg(@player, color(4).'ATTENTION'color(5)'Type:'.color(e)'/tame'.color(5)'To tame your horse!')
tmsg(@player, color(4).'=-=-=-=-=-=-=-=-=-=-=-'.color(d).'ATTENTION'.color(4).'=-=-=-=-=-=-=-=-=-=-=-')
tmsg(@player, color(4).'ATTENTION'color(5)'Type:'.color(e)'/tame'.color(5)'To tame your horse!')
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
set_timeout(6000, closure(
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
				if(array_size(@playerlist) < 6) {
					_endrace('quickend')
				}
			}
			if(@winnum == '2') {
				if(array_size(@playerlist) < 11) {
					_endrace('quickend')
				}
			}
			if(@winnum == '3') {
				if(array_size(@playerlist) < 16) {
					_endrace('quickend')
				}
			}
			if(@winnum == '4') {
				if(array_size(@playerlist) < 21) {
					_endrace('quickend')
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
proc(_endrace, @reason,
	export('status.join', 'on')
	set_timeout(5000, closure(
	_setrace()
	))
	if(@reason == 'none') {
		broadcast(color(4).'No one Won the race. Map is reseting.')
	}
	if(@reason == 'quickend') {
		@winnum = import('winner.number')
		@winnum = add(@winnum, '1')
		@winnumab = 'th'
			if(@winnum == '2') {
				@winnnumab = "nd"
			}
			if(@winnum == '3') {
				@winnnumab = "rd"
			}
			@winnum = @winnum.@winnumab
		broadcast(color(4).'Someone left! Not enough player left to Declare a'@winnum'place')
		}
	if(@reason == 'timer') {
		broadcast(color(4).'No one one the race. Timer run out. Map is reseting.')
	}
	@timer = import('end.timer')
	clear_task(@timer)
	_teleportallspawn()
	_endresetarray()
	_endresetpers()
		set_timeout(45000, closure(
			_startgame()
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
		@i = 0
		for(@i, @i < 21, @i++,
     export('player.'.@i, '')
	 )
)
################################################
###_teleporthorse() 
###   Procedure that Teleport all horse in 
###   there start place
################################################
proc(_teleporthorse,
	@horses = get_value('horse.list')
	@num = '1'
	@time = '500'
		foreach(@horses, @id) {
		@id = entity_id(@id)
			@cords = _startcord(@num)
				set_timeout(@time, closure(
					set_entity_loc(@id, @cords)
				))
			@num++
			@time = add(@time, '600')
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
		set_timeout(2000, closure(
			spawn_mob('HORSE', '10', import('ident.gmr.horse1'))
		))
		set_timeout(3500, closure(
			spawn_mob('HORSE', '10', import('ident.gmr.horse2'))
		))
		set_timeout(10000, closure(
			_createidarray()
				set_timeout(10000, closure(
					_createidarray()
					_teleporthorse()
				))
		))
)

