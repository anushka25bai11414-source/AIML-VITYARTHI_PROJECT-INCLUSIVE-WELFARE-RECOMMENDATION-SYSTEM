%===========================================================
% AI-BASED INCLUSIVE WELFARE RECOMMENDATION SYSTEM
%-----------------------------------------------------------
% THIS SYSTEM SUGGESTS ELIGIBLE WELFARE SCHEMES BASED ON 
% USER ATTRIBUTES USING RULE-BASED REASONING 
%===========================================================

%===========================================================
% USER DATA(FACTS)
%===========================================================
:- dynamic income/2.
:- dynamic category/2.
:- dynamic gender/2.
:- dynamic education/2.
:- dynamic age/2.
:- dynamic rural/2.
:- dynamic disability/2.

:- discontiguous income/2.
:- discontiguous category/2.
:- discontiguous gender/2.
:- discontiguous education/2.
:- discontiguous age/2.
:- discontiguous rural/2.
:- discontiguous disability/2.

% FORMAT:
% income(Person, level)
% category(Person, category)
% gender(Person, gender)
% education(Person, level)
% age(Person, years)
% rural(Person, yes/no)
% disability(Person, yes/no)

%==============FIRST USER====================
income(anushka, 200000).
category(anushka, obc).
gender(anushka, female).
education(anushka, undergraduate).
age(anushka, 20).
rural(anushka, yes).
disability(anushka, no).

%===========================================
%             ADDITIONAL USERS
%===========================================

income(kush, 150000).
category(kush, sc).
gender(kush, male).
education(kush, undergraduate).
age(kush, 19).
rural(kush, yes).
disability(kush, no).

income(preeti, 600000).
category(preeti, general).
gender(preeti, female).
education(preeti, postgraduate).
age(preeti, 24).
rural(preeti, no).
disability(preeti, no).

income(pranav, 120000).
category(pranav, st).
gender(pranav, male).
education(pranav, school).
age(pranav, 17).
rural(pranav, yes).
disability(pranav, yes).


%======================================================
%              INCOME CLASSIFICATION
%======================================================

low_income(Person) :-
    income(Person, X),
    X =< 250000.

middle_income(Person) :-
    income(Person, X),
    X > 250000,
    X =< 800000.

high_income(Person) :-
    income(Person, X),
    X > 800000.


%======================================================
% SCHEME DEFINITIONS
%======================================================

scheme(education_support).
scheme(women_empowerment).
scheme(sc_st_welfare).
scheme(disability_support).
scheme(rural_development).
scheme(youth_scholarship).

%------------------------------------------------------
%_______SCHOLARSHIP ON ACCOUNT OF(REASON)______
%-----------------------------------------------------
scheme_info(education_support, 'National Education Support Scheme', 2020).
scheme_info(women_empowerment, 'Women Empowerment Initiative', 2018).
scheme_info(sc_st_welfare, 'SC/ST Welfare Development Scheme', 2016).
scheme_info(disability_support, 'Accessible India Campaign', 2015).
scheme_info(rural_development, 'Rural Development Mission', 2014).
scheme_info(youth_scholarship, 'National Youth Scholarship Program', 2019).

%============ RULE 1-EDUCATION SUPPORT ===============
eligible(Person, education_support) :-
    low_income(Person),
    education(Person, undergraduate).

%============ RULE 2-WOMEN EMPOWERMENT ===============
eligible(Person, women_empowerment) :-
    gender(Person, female),
    low_income(Person).

%============ RULE 3-SC/ST WELFARE ====================
eligible(Person, sc_st_welfare) :-
    category(Person, sc).

eligible(Person, sc_st_welfare) :-
    category(Person, st).

%============ RULE 4-DISABILITY SUPPORT ==============
eligible(Person, disability_support) :-
    disability(Person, yes).

%============ RULE 5-RURAL DEVELOPMENT ===============
eligible(Person, rural_development) :-
    rural(Person, yes),
    low_income(Person).

%============ RULE 6-YOUTH SCHOLARSHIP ================
eligible(Person, youth_scholarship) :-
    age(Person, Age),
    Age =< 21,
    education(Person, undergraduate).


%--------------------------------------------------------
% ___________SCHOLARSHIP EXPLANATIONS__________________
%--------------------------------------------------------

%--------------------------------------------------------
% EXPLAIN WHY A PERSON IS ELIGIBLE
%--------------------------------------------------------

explain(Person, Scheme) :-
    scheme_info(Scheme, Title, Year),
    write('Scheme Name: '), write(Title),
    write(' , Launched: '), write(Year), nl,
    explanation_reason(Person, Scheme), nl.

%--------------------------------------------------------
% RULE-SPECIFIC REASONS
%--------------------------------------------------------

explanation_reason(Person, education_support) :-
    low_income(Person),
    education(Person, undergraduate),
    write('Reason: Applicant belongs to economically weaker section and is pursuing undergraduate education.').

explanation_reason(Person, women_empowerment) :-
    gender(Person, female),
    low_income(Person),
    write('Reason: Female Applicant from lower income bracket eligible under empowerment initiative. ').

explanation_reason(Person, sc_st_welfare) :-
    category(Person,sc),
    write('Reason: Applicant belongs to Scheduled Caste category as per welfare policy.').

explanation_reason(Person, sc_st_welfare) :-
    category(Person, st),
    write('Reason: Applicant belongs to Scheduled Tribe category as per welfare policy.').

explanation_reason(Person, disability_support) :-
    disability(Person, yes),
    write('Reason: Applicant qualifies under Persons with Disability(PWD) inclusion criteria.').

explanation_reason(Person, rural_development) :-
    rural(Person, yes),
    low_income(Person),
    write('Reason: Rural resident from low income background eligible under rural upliftment mission.').

explanation_reason(Person, youth_scholarship) :-
    age(Person, Age),
    Age =< 21,
    education(Person, undergraduate),
    write('Reason: Youth applicant under 21 enrolled in undergraduate program eligible for youth scholarship.').


%=====================================================
% OUTPUT SYSTEM
%=====================================================

show_eligible_yes(Person) :-
    eligible(Person, Scheme),
    write(Person), write( ' is eligible for: '),
    write(Scheme), nl,
    explain(Person, Scheme),
    write('---------------------'), nl,
    fail.

show_eligible_yes(_).


%====================================================
% PRIORITY FOR SCHOLARSHIPS 
%====================================================

%==========HIGH================
high_priority(Person) :-
    low_income(Person),
    disability(Person, yes),
    !.

high_priority(Person) :-
    low_income(Person),
    category(Person, sc).
    

high_priority(Person) :-
    low_income(Person),
    category(Person, st).

%==========MEDIUM===============
medium_priority(Person) :-
    middle_income(Person),
    gender(Person, female).

%============LOW================
low_priority(Person) :-
    high_income(Person).



%---------------------------------------------------
% DISPLAY PRIORITY
%---------------------------------------------------

show_priority(Person) :-
    high_priority(Person),
    write(Person), write(' -> Priority Level: P1 (CRITICAL INCLUSION CATEGORY)'), nl,
    fail.


show_priority(Person) :-
    medium_priority(Person),
    write(Person), write( ' -> Priority Level: P2 (TARGETED WELFARE SUPPORT)'), nl,
    fail.


show_priority(Person) :-
    low_priority(Person),
    write(Person), write( ' -> Priority Level: P3 (GENERAL CATEGORY ELIGIBILITY)'), nl,
    fail.

show_priority(Person) :-
    \+ high_priority(Person),
    \+ medium_priority(Person),
    \+ low_priority(Person),
    write(Person),
    write(' -> Priority Level: POLICY REVIEW REQUIRED'),
    nl.
show_priority(_).


%=====================================================================================
% RULING FUNCTION
%=====================================================================================

start :-
    write('======INCLUSIVE WELFARE EXPERT SYSTEM======'), nl,
    write('ENTER YOUR NAME: '), read(Name),
    ask_details(Name),
    nl, write('======ELIGIBLE SCHEMES======'), nl,
    show_eligible_yes(Name),
    nl, write('======PRIORITY STATUS======'), nl,
    show_priority(Name).


%---------------------------------------------------------
% USER CREDENTIAL SYSTEM
%---------------------------------------------------------

ask_details(Name) :-
    
    write('ENTER ANNUAL INCOME(numbers): '),
    read(Inc),
    retractall(income(Name, _)),
    assert(income(Name, Inc)),

    write('ENTER CATEGORY (sc/st/obc/general): '),
    read(Cat),
    retractall(category(Name, _)),
    assert(category(Name, Cat)),

    write('ENTER GENDER (male/female): '),
    read(Gen),
    retractall(gender(Name, _)),
    assert(gender(Name, Gen)),

    write('ENTER EDUCATION (school/undergraduate/postgraduate): '),
    read(Edu),
    retractall(education(Name, _)),
    assert(education(Name, Edu)),

    write('ENTER AGE: '),
    read(Age),
    retractall(age(Name, _)),
    assert(age(Name, Age)),

    write('DO YOU BELONG TO A RURAL AREA? (yes/no): '),
    read(Rural),
    retractall(rural(Name, _)),
    assert(rural(Name, Rural)),

    write('UNDER PWD CRITERIA? (yes/no): '),
    read(Dis),
    retractall(disability(Name, _)),
    assert(disability(Name, Dis)).








