%{
#include "flame.tab.h" 
void yyerror (char *s);
int yylex();
%}
%%
print				   {return print_result;}
info				   printf("\tFlame is a Domain specific High-level programming language.\n\tIt was designed in 2021 by UTECH APL students to remotely control any smart car given the correct command inputs.\n\tThe latest version is 1.0.\n\t======FEATURES======\n\tIt is a programming language used to remotely control smart cars via commands.\n\tIt also has a calculator embedded as well.\n\n\tTo view some of the commands for our remote car controller,\n\tplease type the keyword 'commands'\n");
commands		       printf("1.connect_car c_on|c_off\n2.turn_car t_on|t_off\n3.press_gas\n4.press_brake\n5.AC ac_on|ac_off\n6.turn_steering steer_left|steer_right\n7.handbrake hb_up|hb_down\n8.blow_horn\n9.doors door_open|door_close\n10.gear g_reverse|g_drive\n11.cruise_control cc_on|cc_off\n12.adjust_mirror am_up|am_down\n13.radio r_on|r_off\n14.wipers w_on|w_off\n\n");

exit				   return exit_com;
connect_car            return CONNECTCARTOK;
c_on|c_off             yylval.ident=!strcmp(yytext,"c_on");return CONNECTSTATE;
turn_car               return TURNCARTOK;
t_on|t_off             yylval.ident=!strcmp(yytext,"t_on");return TURNSTATE;
press_gas              printf("Car Speed has Increased \n");
press_brake 		   printf("Car slowing Down\n");
AC                     return ACTOK;
ac_on|ac_off           yylval.ident=!strcmp(yytext,"ac_on");return ACSTATE;
turn_steering          return TURNSTEERINGTOK;
steer_left|steer_right yylval.ident=!strcmp(yytext,"steer_left");return TURNSTEERINGSTATE;
handbrake              return HANDBRAKETOK;
hb_up|hb_down    	   yylval.ident=!strcmp(yytext,"hb_up");return HBSTATE;
blow_horn              printf("Car Horn is Blowing");
doors                  return DOORTOK;
door_open|door_close   yylval.ident=!strcmp(yytext,"door_open");return DOORSTATE;
gear                   return GEARTOK;
g_reverse|g_drive      yylval.ident=!strcmp(yytext,"g_reverse");return GEARSTATE;
cruise_control         return CRUISECONTROLTOK;
cc_on|cc_off           yylval.ident=!strcmp(yytext,"cc_on");return CRUISECONTROLSTATE;
adjust_mirror          return MIRRORTOK;
am_up|am_down          yylval.ident=!strcmp(yytext,"am_up");return MIRRORSTATE;
radio                  return RADIOTOK;
r_on|r_off             yylval.ident=!strcmp(yytext,"r_on");return RADIOSTATE;
wipers                 return WIPERTOK;
w_on|w_off             yylval.ident=!strcmp(yytext,"w_on");return WIPERSTATE;





[a-zA-Z]			   {yylval.ident = yytext[0]; return identifier;} /* yyval is now a union type which allows us to return different types*/
[0-9]+                 {yylval.numb = atoi(yytext); return number;}
[ \t\n]                ;
[-+=*/;]           	   {return yytext[0];}
.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}

