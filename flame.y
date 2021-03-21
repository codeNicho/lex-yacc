%{
void yyerror (char *s); /* This is defined else where and we need it to be call when there is a syntactical error when the grammar isnt suited*/
int yylex(); 
#include <stdio.h>   
#include <ctype.h>
#include <stdlib.h> /* we included this header file in order to access the C exit() function*/

int variables[52]; /* we have up to 52 variables lowercase a-z and uppercase A-Z*/
int variableVal(char var); /* this accepts a character and basically looks up the value of that variable in the variable table*/
void updateVariableVal(char var, int val); /* This will make sure the respective variable gets the value we are passing */
%}


%union {int numb; char ident;}         /* Union allows us to specify the different types our lexical analyser can return */
%start start_line /* This tells yacc where the starting rule or starting production is */
%token print_result /* We have a token we are expecting from our lexical analyzer called print_result*/
%token exit_com 
%token <numb> number /* the token number will get stored in the member variable 'numb' in the union type*/
%token <ident> identifier
%token <ident> CONNECTCARTOK CONNECTSTATE TURNCARTOK TURNSTATE ACTOK ACSTATE TURNSTEERINGTOK TURNSTEERINGSTATE HANDBRAKETOK HBSTATE DOORTOK DOORSTATE GEARTOK GEARSTATE CRUISECONTROLTOK CRUISECONTROLSTATE MIRRORTOK MIRRORSTATE RADIOTOK RADIOSTATE WIPERTOK WIPERSTATE
%type <ident> start_line exp term  connect_switch turn_switch ac_switch steering_switch handbrake_switch door_switch gear_switch cruise_switch mirror_switch radio_switch wiper_switch /* assigning types to the non terminals on the left hand side e.g. start_line, exp and term will be mapped to the type 'numb' which we know is an integer */
%type <ident> assignment /* assignment will be mapped to id which is a character */

%%

/* descriptions of expected inputs     corresponding actions (in C) */
/* non terminals come before the colon */
start_line: command ';'
		| assignment ';'		{;} /* a start_line maps to 7 different productions, In this line it can be an assignment*/
		| exit_com ';'		{exit(EXIT_SUCCESS);} /* here we call the C function exit and pass it Exit_SUCCESS*/
		| print_result exp ';'			{printf("Printing %d\n", $2);} /* a printing the value of the exp */
		| start_line assignment ';'	{;} /* recursive production which will not perform any action because we already have an assignment done from below*/
		| start_line print_result exp ';'	{printf("Printing %d\n", $3);} /* print the 3rd value */
		| start_line exit_com ';'	{exit(EXIT_SUCCESS);} /* Allows us to have more than 1 print statements in a single input file repetitively */
		| start_line command ';'
		;
assignment : identifier '=' exp  { updateVariableVal($1,$3); }
			;
exp    	: term                  {$$ = $1;} /* exp maps to term which can be a number or identifier as defined below, so exp will get the value of that term which is what {$$ = $1;} is saying */
       	| exp '+' term          {$$ = $1 + $3;} /* Our exp also maps to  exp '+' term, this is saying, exp gets $1 and term gets $3 */
       	| exp '-' term          {$$ = $1 - $3;} /* sames goes for this production rule*/
       	| exp '*' term          {$$ = $1 * $3;}
       	| exp '/' term          {$$ = $1 / $3;}
       	;
term   	: number                {$$ = $1;}
		| identifier			{$$ = variableVal($1);} 
        ;
command: connect_switch 
		| turn_switch 
		| ac_switch 
		| steering_switch 
		| handbrake_switch 
		| door_switch 
		| gear_switch 
		| cruise_switch 
		| mirror_switch 
		| radio_switch 
		| wiper_switch 
		;
connect_switch:
				CONNECTCARTOK CONNECTSTATE
				{
					if($2)
                        printf("\tRemote Control For Car Successfully Connected\n");
                else
                        printf("\tRemote Control Disabled\n");
				}
				;
turn_switch:
				TURNCARTOK TURNSTATE
				{
					if($2)
                        printf("\tCar Turned On!\n");
                else
                        printf("\tCar Turned Off!\n");
				}
				;
ac_switch:
				ACTOK ACSTATE
				{
					if($2)
                        printf("\tAC Turned On!\n");
                else
                        printf("\tAC turned off!\n");
				}
				;
steering_switch:
				TURNSTEERINGTOK TURNSTEERINGSTATE
				{
					if($2)
                        printf("\tSteering Turned Left\n");
                else
                        printf("\tSteering Turned Right\n");
				}
				;
handbrake_switch:
				HANDBRAKETOK HBSTATE
				{
					if($2)
                        printf("\tHandbrake Pulled Up!\n");
                else
                        printf("\tHandbrake Released!\n");
				}
				;
door_switch:
				DOORTOK DOORSTATE
				{
					if($2)
                        printf("\tDoor Opened!\n");
                else
                        printf("\tDoor Closed!\n");
				}
				;
gear_switch:
				GEARTOK GEARSTATE
				{
					if($2)
                        printf("\tGear Shifted To Reverse!\n");
                else
                        printf("\tGear Shifted To Drive!\n");
				}
				;
cruise_switch:
				CRUISECONTROLTOK CRUISECONTROLSTATE
				{
					if($2)
                        printf("\tCruise Control Turned On!\n");
                else
                        printf("\tCruise Control Turned Off\n");
				}
				;
mirror_switch:
				MIRRORTOK MIRRORSTATE
				{
					if($2)
                        printf("\tMirror Shifted Up\n");
                else
                        printf("\tMirror Shifted Down\n");
				}
				;
radio_switch:
				RADIOTOK RADIOSTATE
				{
					if($2)
                        printf("\tRadio Turned On!\n");
                else
                        printf("\tRadio Turned Off\n");
				}
				;
wiper_switch:
				WIPERTOK WIPERSTATE
				{
					if($2)
                        printf("\tWipers Turned On!\n");
                else
                        printf("\tWipers Turned Off\n");
				}
				;				

%%                     /* C code */

int computeVarIndex(char token)
{
	int idc = -1;
	if(islower(token)) {
		idc = token - 'a' + 26;
	} else if(isupper(token)) {
		idc = token - 'A';
	}
	return idc;
} 

/* this looks up the value of the variable and return that value*/
int variableVal(char var)
{
	int bucket = computeVarIndex(var); /* we can now compute our variable index which is the offset in our variable table array for that particular variable and once we compute it we return the value of it */
	return variables[bucket];
}

/* computes the index but then assign the value to that entry*/
void updateVariableVal(char var, int val)
{
	int bucket = computeVarIndex(var);
	variables[bucket] = val;
}

int main (void) {
	printf("\n\tWelcome to Flame version 1.0 Designed to Remotely Control Any Smart Car\n\t");
	printf("Type the command 'info' for more details\n\n");
	/* Using a forloop to initialize all our variables to 0 */
	int i;
	for(i=0; i<52; i++) {
		variables[i] = 0;
	}

	return yyparse ( ); /* we call yyparse to iteratively apply the grammar rules to the input until we run out of input or find a syntax error */
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} /* the parser will call this if we get a syntax error and print it out*/

