{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.1 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019 Pozsár Zsolt <pozsar.zsolt@.szerafingomba.hu>         | }
{ | incpage3screen.pas                                                       | }
{ | Show screen content of page #3                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page3screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 3/8: GPIO port numbers');
  textcolor(white);
  for b:=1 to 4 do
  begin
    gotoxy(4,b+2); writeln('Input port #'+inttostr(b)+':');
    gotoxy(4,b+2+4); writeln('Output port #'+inttostr(b)+':');
    gotoxy(4,b+2+4+4); writeln('Error LED #'+inttostr(b)+':');
  end;
  for b:=1 to 4 do
  begin
    gotoxy(MINPOSX[3,1],b+2); writeln('GPIO',prt_in[b]);
    gotoxy(MINPOSX[3,1],b+2+4); writeln('GPIO',prt_out[b]);
    gotoxy(MINPOSX[3,1],b+2+4+4); writeln('GPIO',prt_err[b]);
  end;
  gotoxy(4,15); writeln('T/RH sensor:');
  gotoxy(4,16); writeln('Mode switch:');
  gotoxy(4,17); writeln('Active LED:');
  gotoxy(4,18); writeln('Green light output:');
  gotoxy(4,19); writeln('Red light output:');
  gotoxy(4,20); writeln('Yellow light output:');
  gotoxy(MINPOSX[3,1],15); writeln('GPIO',prt_sensor);
  gotoxy(MINPOSX[3,1],16); writeln('GPIO',prt_switch);
  gotoxy(MINPOSX[3,1],17); writeln('GPIO',prt_act);
  gotoxy(MINPOSX[3,1],18); writeln('GPIO',prt_twrgreen);
  gotoxy(MINPOSX[3,1],19); writeln('GPIO',prt_twrred);
  gotoxy(MINPOSX[3,1],20); writeln('GPIO',prt_twryellow);
end;
