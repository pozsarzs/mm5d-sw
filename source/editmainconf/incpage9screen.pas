{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.2 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage9screen.pas                                                       | }
{ | Show screen content of page #9                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page9screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 9/9: IP cameras');
  textcolor(white);
  gotoxy(4,3); writeln('Show camera pictures (0: not show):');
  gotoxy(4,4); writeln('Enable camera #1 (0: disable):');
  gotoxy(4,5); writeln('Enable camera #2 (0: disable):');
  gotoxy(4,7); writeln('URL #1:');
  gotoxy(4,8); writeln('URL #2:');
  gotoxy(MINPOSX[9,1],3); writeln(cam_show);
  gotoxy(MINPOSX[9,1],4); writeln(cam1_enable);
  gotoxy(MINPOSX[9,1],5); writeln(cam2_enable);
  gotoxy(MINPOSX[9,2],7); writeln(cam1_jpglink);
  gotoxy(MINPOSX[9,2],8); writeln(cam2_jpglink);
end;
