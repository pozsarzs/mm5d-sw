{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.6 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage03screen.pas                                                      | }
{ | Show screen content of page #3                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page3screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 3/11: Growing hyphae - lighting');
  textcolor(white);
  gotoxy(4,3); writeln('Lamps switch-on time #1:');
  gotoxy(4,4); writeln('Lamps switch-off time #1:');
  gotoxy(4,5); writeln('Lamps switch-on time #2:');
  gotoxy(4,6); writeln('Lamps switch-off time #2:');
  gotoxy(45,3); if hlightson1<10 then write(' '); write(hlightson1,'.00');
  gotoxy(45,4); if hlightsoff1<10 then write(' '); write(hlightsoff1,'.00');
  gotoxy(45,5); if hlightson2<10 then write(' '); write(hlightson2,'.00');
  gotoxy(45,6); if hlightsoff2<10 then write(' '); write(hlightsoff2,'.00');
end;
