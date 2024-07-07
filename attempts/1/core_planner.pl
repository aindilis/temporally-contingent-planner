:- consult('/var/lib/myfrdcsa/codebases/minor/temporally-contingent-planner/attempts/1/interactive_execution_monitor.pl').
:- consult('/var/lib/myfrdcsa/codebases/minor/temporally-contingent-planner/attempts/1/simple_execution_monitor.pl').



:- multifile action/4.
:- discontiguous action/4.
:- dynamic action/4.

:- multifile state/2.
:- discontiguous state/2.
:- dynamic state/2.

:- multifile temporal_constraint/4.
:- discontiguous temporal_constraint/4.
:- dynamic temporal_constraint/4.

:- multifile plan_node/4.
:- discontiguous plan_node/4.
:- dynamic plan_node/4.

:- multifile plan_root/1.
:- discontiguous plan_root/1.
:- dynamic plan_root/1.



%% % Action representation
%% action(_Name, _Preconditions, _Effects, _Duration).

%% % State representation
%% state(_ID, _Facts).

%% % Temporal constraint
%% temporal_constraint(_Action1, _Action2, _Relation, _Value).

%% % Contingent plan node
%% plan_node(_ID, _Action, _Parent, _Children).

%% % Root of the plan
%% plan_root(_NodeID).



% Add an action to the plan
add_action(ParentID, ActionName, NewNodeID) :-
	action(ActionName, _, _, _),
	gensym(node, NewNodeID),
	assertz(plan_node(NewNodeID, ActionName, ParentID, [])),
	plan_node(ParentID, _, _, Children),
	retract(plan_node(ParentID, ParentAction, ParentParent, Children)),
	assertz(plan_node(ParentID, ParentAction, ParentParent, [NewNodeID|Children])).

% Add a branching point
add_branch(ParentID, Condition, ThenNodeID, ElseNodeID) :-
	gensym(node, ThenNodeID),
	gensym(node, ElseNodeID),
	assertz(plan_node(ThenNodeID, branch_then(Condition), ParentID, [])),
	assertz(plan_node(ElseNodeID, branch_else(Condition), ParentID, [])),
	plan_node(ParentID, ParentAction, ParentParent, _),
	retract(plan_node(ParentID, ParentAction, ParentParent, _)),
	assertz(plan_node(ParentID, ParentAction, ParentParent, [ThenNodeID, ElseNodeID])).

% Add a temporal constraint
add_temporal_constraint(Action1, Action2, Relation, Value) :-
	assertz(temporal_constraint(Action1, Action2, Relation, Value)).

% Simple validation (checks if actions exist and constraints are defined)
validate_plan :-
	plan_root(Root),
	validate_node(Root),
	findall(_, (temporal_constraint(A1, A2, _, _),
		    \+ plan_node(_, A1, _, _),
		    \+ plan_node(_, A2, _, _)), []),
	writeln('Plan appears valid.').

validate_node(NodeID) :-
	plan_node(NodeID, Action, _, Children),
	(   Action = branch_then(_) ; Action = branch_else(_) ; action(Action, _, _, _)),
	maplist(validate_node, Children).





%% action(move_to_shelter, [at(home)], [at(shelter)], 30).
%% action(gather_supplies, [at(home)], [has_supplies], 15).





%% % Start the plan
%% :- assertz(plan_root(root)).
%% :- assertz(plan_node(root, start, null, [])).

%% % Add actions and branches
%% add_actions :-
%% 	add_action(root, gather_supplies, N1),
%% 	add_action(N1, move_to_shelter, N2),
%% 	add_branch(N2, road_blocked, ThenBranch, ElseBranch),
%% 	add_action(ThenBranch, use_alternate_route, N3),
%% 	add_action(ElseBranch, wait_for_clearance, N4).

%% % Add temporal constraints
%% add_temporal_constraint(gather_supplies, move_to_shelter, before, 0).

%% %% ?- validate_plan.
