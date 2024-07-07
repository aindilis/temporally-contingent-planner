% Domain: Hurricane Evacuation

action(start, [], [], 0).

% Actions
action(check_weather, [], [weather_checked], 10).
action(gather_supplies, [], [supplies_gathered], 30).
action(secure_home, [], [home_secured], 45).
action(fill_car, [], [car_filled], 15).
action(evacuate_to_shelter, [supplies_gathered, home_secured, car_filled], [at_shelter], 60).
action(evacuate_to_family, [supplies_gathered, home_secured, car_filled], [at_family], 90).
action(stay_home, [home_secured, supplies_gathered], [stayed_home], 0).
action(call_for_assistance, [], [assistance_called], 10).

% Additional domain rules
severe_weather(State) :- member(hurricane_imminent, State).
safe_to_travel(State) :- member(weather_checked, State), \+ member(roads_closed, State).
