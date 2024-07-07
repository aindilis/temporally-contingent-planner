%% :- consult('/var/lib/myfrdcsa/codebases/minor/free-life-planner/lib/util/util.pl').

:- consult('/var/lib/myfrdcsa/codebases/minor/temporally-contingent-planner/attempts/1/core_planner.pl').
:- consult('/var/lib/myfrdcsa/codebases/minor/temporally-contingent-planner/attempts/1/domain.pl').
:- consult('/var/lib/myfrdcsa/codebases/minor/temporally-contingent-planner/attempts/1/problem.pl').

trace_no_wait :-
	leash(-all),
	trace.

run1 :-
	%% trace_no_wait,
	validate_hurricane_plan,
	run_simulation.

run2 :-
	validate_hurricane_plan,
	catch(start_monitor, exit_monitor, (write('Monitor exited.'), nl)).