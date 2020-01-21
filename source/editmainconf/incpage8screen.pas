{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.1 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage8screen.pas                                                       | }
{ | Show screen content of page #8                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page8screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 8/8: Logging');
  textcolor(white);
  gotoxy(4,3); writeln('Storing time of log records in days:');
  gotoxy(4,4); writeln('Enable debug log (0: disable):');
  gotoxy(MINPOSX[8,1],3); writeln(day_log);
  gotoxy(MINPOSX[8,1],4); writeln(dbg_log);
end;
