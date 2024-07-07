% Interactive Execution Monitor

% Initialize the monitor
init_monitor :-
	init_simulation,
	main_loop.

% Main interaction loop
main_loop :-
	write('Entering main_loop'), nl,
	current_node(NodeID),
	write('Current NodeID: '), write(NodeID), nl,
	(   plan_node(NodeID, Action, _, Children) ->
	    write('Action: '), write(Action), nl,
	    write('Children: '), write(Children), nl,
	    display_current_state,
	    (	Action = branch_then(Condition) ->
		write('Handling branch_then'), nl,
		handle_branch(Condition, Children)
	    ;	Action = branch_else(_) ->
		write('Handling branch_else'), nl,
		handle_else(Children)
	    ;	
		write('Handling action'), nl,
		handle_action(Action, Children)
	    )
	;   
	    write('Plan completed.'), nl
	).

% Display current state
display_current_state :-
	nl,
	write('Current Time: '), current_time(Time), write(Time), nl,
	write('Current State: '), current_state(State), write(State), nl,
	write('Current Action: '), current_node(NodeID), plan_node(NodeID, Action, _, _), write(Action), nl.

% Handle a branch node
handle_branch(Condition, Children) :-
	write('Entering handle_branch'), nl,
	write('Condition: '), write(Condition), nl,
	write('Children: '), write(Children), nl,
	write('Is the condition true? (y/n): '),
	read(Response),
	write('Response: '), write(Response), nl,
	(   Response = y ->
	    write('Condition is true, taking then branch'), nl,
	    [ThenNode|_] = Children,
	    write('ThenNode: '), write(ThenNode), nl,
	    retract(current_node(_)),
	    assertz(current_node(ThenNode)),
	    current_state(State),
	    write('Current State before update: '), write(State), nl,
	    retract(current_state(_)),
	    assertz(current_state([Condition|State])),
	    write('Current State after update: '), current_state(NewState), write(NewState), nl,
	    write('Calling main_loop'), nl,
	    main_loop
	;   Response = n ->
	    write('Condition is false, taking else branch'), nl,
	    (	Children = [_,ElseNode|_] ->
		write('ElseNode: '), write(ElseNode), nl,
		retract(current_node(_)),
		assertz(current_node(ElseNode)),
		write('Calling main_loop'), nl,
		main_loop
	    ;	
		write('No else branch found. Ending execution.'), nl,
		true
	    )
	;   
	    write('Invalid response. Please enter y or n.'), nl,
	    handle_branch(Condition, Children)
	).

% Handle an else node
handle_else(Children) :-
	[NextNode|_] = Children,
	retract(current_node(_)),
	assertz(current_node(NextNode)),
	main_loop.

% Handle an action node
handle_action(Action, Children) :-
	write('Execute action? (y/n): '),
	read(Response),
	(   Response = y ->
	    execute_action(Action),
	    (	Children = [NextNode|_] ->
		retract(current_node(_)),
		assertz(current_node(NextNode)),
		main_loop
	    ;	
		write('Plan completed.'), nl
	    )
	;   Response = n ->
	    write('Exiting monitor.'), nl,
	    exit_monitor
	;   
	    write('Invalid response. Please enter y or n.'), nl,
	    handle_action(Action, Children)
	).

% Start the interactive monitor
start_monitor :-
	init_monitor,
	catch(main_loop, exit_monitor, true).

exit_monitor :-
	throw(exit_monitor).

%% ?- start_monitor.
