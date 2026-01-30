%option noyywrap

%{

#include "nocomment.hpp"

// The following line avoids an annoying warning in Flex
// See: https://stackoverflow.com/questions/46213840/
extern "C" int fileno(FILE *stream);
int removed_counter = 0;
%}
%x COMMENT ESCAPED ATTRIBUTE

%%

"//" {
  removed_counter++;
  BEGIN(COMMENT);
}

<COMMENT>\n {
  BEGIN(INITIAL);
}

<COMMENT>. ;

"\\" {
  yylval.character = '\\';
  BEGIN(ESCAPED);
  return Other;
}

<ESCAPED>[^\n ] {
  yylval.character = yytext[0];
  return Other;
}

<ESCAPED>[ \n] {
  BEGIN(INITIAL);
  yylval.character = yytext[0];
  return Other;
}

"(*" {
  removed_counter++;
  BEGIN(ATTRIBUTE);
}

<ATTRIBUTE>"*)" {
  BEGIN(INITIAL);
}

<ATTRIBUTE>"//"[^\n]*\n ;

<ATTRIBUTE>\n ;
<ATTRIBUTE>.  ;

.|\n {
  yylval.character = yytext[0];
  return Other;
}

<<EOF>> { return Eof; }

%%
