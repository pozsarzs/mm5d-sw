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
begin
  header(PRGNAME+' '+VERSION+' * Page 3/8: Growing hyphae - lighting');
  textcolor(white);
  for b:=1 to 4 do
  begin
    gotoxy(4,b+2); writeln('Input port #'+inttostr(b)+':');
    gotoxy(4,b+2+4); writeln('Output port #'+inttostr(b)+':');
    gotoxy(4,b+2+4+4); writeln('Error light #'+inttostr(b)+':');
  end;
  for b:=1 to 4 do
  begin
    gotoxy(MINPOSX[2,1],b+2); writeln(nam_in[b]);
    gotoxy(MINPOSX[2,1],b+2+4); writeln(nam_out[b]);
    gotoxy(MINPOSX[2,1],b+2+4+4); writeln(nam_err[b]);
  end;

  gotoxy(4,3); writeln('Lights switch-on time #1:');
  gotoxy(4,4); writeln('Lights switch-off time #1:');
  gotoxy(4,5); writeln('Lights switch-on time #2:');
  gotoxy(4,6); writeln('Lights switch-off time #2:');

[ports]
; GPIO port number of error lights and ports
prt_act=25
prt_err1=12
prt_err2=16
prt_err3=20
prt_err4=21
prt_in1=17
prt_in2=18
prt_in3=22
prt_in4=23
prt_out1=5
prt_out2=6
prt_out3=13
prt_out4=19
prt_sensor=24
prt_switch=26
prt_twrgreen=3
prt_twrred=2
prt_twryellow=4



end;
