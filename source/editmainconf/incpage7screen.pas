{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.1 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage7screen.pas                                                       | }
{ | Show screen content of page #7                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page7screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 7/8: Language of webpages');
  textcolor(white);
  gotoxy(4,3); writeln('Czech');
  gotoxy(4,4); writeln('German');
  gotoxy(4,5); writeln('English');
  gotoxy(4,6); writeln('French');
  gotoxy(4,7); writeln('Croatian');
  gotoxy(4,8); writeln('Hungarian');
  gotoxy(4,9); writeln('Polish');
  gotoxy(4,10); writeln('Romanian');
  gotoxy(4,11); writeln('Russian');
  gotoxy(4,12); writeln('Slovak');
  gotoxy(4,13); writeln('Slovenian');
  gotoxy(4,14); writeln('Serbian');
  gotoxy(4,15); writeln('Ukrainian');
  b:=0;
  for b:=3 to 15 do
    if lng=CODE[b] then break;
  if b=0 then b:=5;
  gotoxy(MINPOSX[7,1],b); writeln('<<');
end;
