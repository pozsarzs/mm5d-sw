{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.4 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage1screen.pas                                                       | }
{ | Show screen content of page #1                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page1screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 1/8: Growing hyphae - humidifying');
  textcolor(white);
  gotoxy(4,3); writeln('Minimal relative humidity:');
  gotoxy(4,4); writeln('Humidifier switch-on humidity:');
  gotoxy(4,5); writeln('Humidifier switch-off humidity:');
  gotoxy(4,6); writeln('Maximal relative humidity:');
  if hhummin>9 then gotoxy(45,3) else gotoxy(46,3); writeln(hhummin,' %');
  if hhumon>9 then gotoxy(45,4) else gotoxy(46,4); writeln(hhumon,' %');
  if hhumoff>9 then gotoxy(45,5) else gotoxy(46,5); writeln(hhumoff,' %');
  if hhummax>9 then gotoxy(45,6) else gotoxy(46,6); writeln(hhummax,' %');
  gotoxy(4,9); writeln('Disable humidifier (0/1):');
  for b:=0 to 9 do
  begin
    gotoxy(4,b+10);
    writeln(' '+inttostr(b)+'.00...'+inttostr(b)+'.59 ',hhumdis[b]);
  end;
  for b:=10 to 11 do
  begin
    gotoxy(4,b+10);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',hhumdis[b]);
  end;
  for b:=12 to 23 do
  begin
    gotoxy(22,b-2);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',hhumdis[b]);
  end;
end;
