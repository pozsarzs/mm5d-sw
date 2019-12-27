{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.1 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019 Pozsár Zsolt <pozsar.zsolt@.szerafingomba.hu>         | }
{ | incpage2screen.pas                                                       | }
{ | Show screen content of page #2                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page2screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 2/8: Name of ports and error lights');
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
end;
