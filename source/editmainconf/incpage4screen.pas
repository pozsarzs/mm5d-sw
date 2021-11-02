{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.3 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage4screen.pas                                                       | }
{ | Show screen content of page #4                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write screen content
procedure page4screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 4/9: T/RH sensor');
  textcolor(white);
  gotoxy(4,3); writeln('Type of sensor:');
  gotoxy(MINPOSX[4,1],3); writeln(sensor_type);
end;
