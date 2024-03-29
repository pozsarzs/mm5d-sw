{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.6 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage11screen.pas                                                      | }
{ | Show screen content of page #11                                          | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page11screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 11/11: Common parameters');
  textcolor(white);
  gotoxy(4,3); writeln('Relative unwanted gas concentrate:');
  gotoxy(45,3);
  if gasconmax>9 then gotoxy(45,3) else gotoxy(46,3); writeln(gasconmax,' %');
end;
