%option noyywrap

%{

#include "nocomment.hpp"

// The following line avoids an annoying warning in Flex
// See: https://stackoverflow.com/questions/46213840/
extern "C" int fileno(FILE *stream);
int removed_count = 0;
%}
%x COMMENT ESCAPED ATTRIBUTE

%%

"//"{
removed_count++;
  BEGIN(COMMENT);
}

<COMMENT>\n {
  BEGIN(INITIAL);
  yylval.character = '\n';
  return Other;
}

<COMMENT>. ;

"\\"{
  BEGIN(ESCAPED);
}

<ESCAPED>\n {
  BEGIN(INITIAL);
  yylval.character = '\n';
}

<ESCAPED>. {
  yylval.character = yytext[0];
  return Other;
}

"(*"{
  BEGIN(ATTRIBUTE);
  removed_count++;
}

<ATTRIBUTE>"*)" {
  BEGIN(INITIAL);
  return Other;
}

<ATTRIBUTE>. ;

. {
  yylval.character = yytext[0];
  return Other;
}

EOF {
  return Eof;
}

%%

/* Error handler. This will get called if none of the rules match. */
void yyerror (char const *s)
{
  fprintf (stderr, "Flex Error: %s\n", s);
  exit(1);
}
