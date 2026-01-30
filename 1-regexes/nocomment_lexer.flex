%x COMMENT ESCAPED ATTRIBUTE

%%

"//" {
  removed_count++;
  BEGIN(COMMENT);
}

<COMMENT>\n {
  BEGIN(INITIAL);
  yylval.character = '\n';
  return Other;
}
<COMMENT>.  ;

"\\" { 
  BEGIN(ESCAPED);
}

<ESCAPED>[^\n ]+  ;

<ESCAPED>[ \n] {
  BEGIN(INITIAL);
  yylval.character = yytext[0];
  return Other;
}

"(*" {
  removed_count++;
  BEGIN(ATTRIBUTE);
}
<ATTRIBUTE>"*)" { BEGIN(INITIAL); }
<ATTRIBUTE>\n   ;
<ATTRIBUTE>.    ;

.|\n {
  yylval.character = yytext[0];
  return Other;
}

<<EOF>> { return Eof; }

%%
