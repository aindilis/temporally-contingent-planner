%% Problem: Hurricane Evacuation Plan

%% Initial state
initial_state([at_home]).

%% Goal state (disjunctive)
goal_state(State) :-
	(   member(at_shelter, State) ; member(at_family, State) ; member(stayed_home, State)).

%% Create the plan
create_hurricane_plan :-
	%% Start the plan
	assertz(plan_root(root)),
	assertz(plan_node(root, start, null, [])),

	%% Check weather
	add_action(root, check_weather, N1),

	%% Branch based on weather severity
	add_branch(N1, hurricane_imminent, SevereWeather, MildWeather),

	%% Severe weather branch
	add_action(SevereWeather, gather_supplies, N2),
	add_action(N2, secure_home, N3),
	add_action(N3, fill_car, N4),

	%% Branch based on evacuation route
	add_branch(N4, main_road_open, EvacuateMain, EvacuateAlt),
	add_action(EvacuateMain, evacuate_to_shelter, _N5),
	add_action(EvacuateAlt, evacuate_to_family, _N6),

	%% Mild weather branch
	add_action(MildWeather, gather_supplies, N7),
	add_action(N7, secure_home, N8),
	add_branch(N8, conditions_worsened, EvacuateLater, StayHome),
	add_action(EvacuateLater, fill_car, N9),
	add_action(N9, evacuate_to_shelter, _N10),
	add_action(StayHome, stay_home, _N11),

	%% Add temporal constraints
	add_temporal_constraint(check_weather, gather_supplies, before, 0),
	add_temporal_constraint(gather_supplies, secure_home, before, 0),
	add_temporal_constraint(secure_home, fill_car, before, 0),
	add_temporal_constraint(fill_car, evacuate_to_shelter, before, 0),
	add_temporal_constraint(fill_car, evacuate_to_family, before, 0).

%% Validate the plan
validate_hurricane_plan :-
	create_hurricane_plan,
	validate_plan.
