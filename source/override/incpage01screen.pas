{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.6 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage01screen.pas                                                      | }
{ | Show screen content of page #1                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

//write screen content
procedure page1screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Override output values');
  textcolor(white);
  gotoxy(4,3); writeln('Output #1 - heater:');
  gotoxy(4,4); writeln('Output #2 - light:');
  gotoxy(4,5); writeln('Output #3 - ventilator:');
  gotoxy(4,6); writeln('Output #4 - humidifier:');
  for b:=1 to 4 do
  begin
    gotoxy(30,2+b); writeln(outputs[b]);
  end;
end;