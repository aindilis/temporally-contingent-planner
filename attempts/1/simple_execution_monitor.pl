% Simple Execution Simulator

% Simulation state
:- dynamic current_state/1, current_time/1, current_node/1.

% Initialize simulation
init_simulation :-
	retractall(current_state(_)),
	retractall(current_time(_)),
	retractall(current_node(_)),
	assertz(current_state([])),
	assertz(current_time(0)),
	plan_root(Root),
	assertz(current_node(Root)).

% Execute the next action
execute_next :-
	current_node(NodeID),
	plan_node(NodeID, Action, _, Children),
	(   Action = branch_then(Condition) ->
	    (	check_condition(Condition) ->
		[NextNode|_] = Children
	    ;	
		[_, NextNode|_] = Children)
	;   Action = branch_else(_) ->
	    [NextNode|_] = Children
	;   
	    execute_action(Action),
	    [NextNode|_] = Children
	),
	retract(current_node(_)),
	assertz(current_node(NextNode)),
	write('Executed: '), write(Action), nl.

% Execute an action (update state and time)
execute_action(Action) :-
    (   Action = start ->
        true  % Do nothing for the start action
    ;   
        action(Action, _, Effects, Duration),
        current_state(State),
        append(Effects, State, NewState),
        retract(current_state(_)),
        assertz(current_state(NewState)),
        current_time(Time),
        NewTime is Time + Duration,
        retract(current_time(_)),
        assertz(current_time(NewTime))
    ).

% Check if a condition is true in the current state
check_condition(Condition) :-
	current_state(State),
	member(Condition, State).

% Run the entire simulation
run_simulation :-
	init_simulation,
	run_simulation_step.

run_simulation_step :-
	(   execute_next ->
	    run_simulation_step
	;   
	    write('Simulation complete.'), nl,
	    current_time(FinalTime),
	    write('Total time: '), write(FinalTime), nl,
	    current_state(FinalState),
	    write('Final state: '), write(FinalState), nl
	).

%% ?- run_simulation.

